#!/usr/bin/env python
from __future__ import division
import sys, os, re
import getopt
import sys
import time
import os
import subprocess
from collections import deque

try:
    import psyco
    psyco.full()
except: pass
ext_pattern=re.compile(r'.*:\s+(\d+) extents? found')
def _supports_progress(f):
    if not hasattr(f, 'isatty'):
        return False
    if not f.isatty():
        return False
    if os.environ.get('TERM') == 'dumb':
        # e.g. emacs compile window
        return False
    return True



def ProgressBar(to_file=sys.stderr, **kwargs):
    """Abstract factory"""
    if _supports_progress(to_file):
        return TTYProgressBar(to_file=to_file, **kwargs)
    else:
        return DotsProgressBar(to_file=to_file, **kwargs)
    

class ProgressBarStack(object):
    """A stack of progress bars."""

    def __init__(self,
                 to_file=sys.stderr,
                 show_pct=False,
                 show_spinner=True,
                 show_eta=False,
                 show_bar=True,
                 show_count=True,
                 to_messages_file=sys.stdout,
                 klass=None):
        """Setup the stack with the parameters the progress bars should have."""
        self._to_file = to_file
        self._show_pct = show_pct
        self._show_spinner = show_spinner
        self._show_eta = show_eta
        self._show_bar = show_bar
        self._show_count = show_count
        self._to_messages_file = to_messages_file
        self._stack = []
        self._klass = klass or TTYProgressBar

    def top(self):
        if len(self._stack) != 0:
            return self._stack[-1]
        else:
            return None

    def bottom(self):
        if len(self._stack) != 0:
            return self._stack[0]
        else:
            return None

    def get_nested(self):
        """Return a nested progress bar."""
        if len(self._stack) == 0:
            func = self._klass
        else:
            func = self.top().child_progress
        new_bar = func(to_file=self._to_file,
                       show_pct=self._show_pct,
                       show_spinner=self._show_spinner,
                       show_eta=self._show_eta,
                       show_bar=self._show_bar,
                       show_count=self._show_count,
                       to_messages_file=self._to_messages_file,
                       _stack=self)
        self._stack.append(new_bar)
        return new_bar

    def return_pb(self, bar):
        """Return bar after its been used."""
        self._stack.pop()


class _BaseProgressBar(object):

    def __init__(self,
                 to_file=sys.stderr,
                 show_pct=False,
                 show_spinner=False,
                 show_eta=True,
                 show_bar=True,
                 show_count=True,
                 to_messages_file=sys.stdout,
                 _stack=None):
        object.__init__(self)
        self.to_file = to_file
        self.to_messages_file = to_messages_file
        self.last_msg = None
        self.last_cnt = None
        self.last_total = None
        self.show_pct = show_pct
        self.show_spinner = show_spinner
        self.show_eta = show_eta
        self.show_bar = show_bar
        self.show_count = show_count
        self._stack = _stack
        # seed throttler
        self.MIN_PAUSE = 0.5 # seconds
        now = time.time()
        # starting now
        self.start_time = now
        # next update should not throttle
        self.last_update = now - self.MIN_PAUSE - 1

    def finished(self):
        """Return this bar to its progress stack."""
        self.clear()
        assert self._stack is not None
        self._stack.return_pb(self)

    def note(self, fmt_string, *args, **kwargs):
        """Record a note without disrupting the progress bar."""
        self.clear()
        self.to_messages_file.write(fmt_string % args)
        self.to_messages_file.write('\n')

    def child_progress(self, **kwargs):
        return ChildProgress(**kwargs)


class DummyProgress(_BaseProgressBar):
    """Progress-bar standin that does nothing.

    This can be used as the default argument for methods that
    take an optional progress indicator."""
    def tick(self):
        pass

    def update(self, msg=None, current=None, total=None):
        pass

    def child_update(self, message, current, total):
        pass

    def clear(self):
        pass

    def note(self, fmt_string, *args, **kwargs):
        """See _BaseProgressBar.note()."""

    def child_progress(self, **kwargs):
        return DummyProgress(**kwargs)

class DotsProgressBar(_BaseProgressBar):

    def __init__(self, **kwargs):
        _BaseProgressBar.__init__(self, **kwargs)
        self.last_msg = None
        self.need_nl = False

    def tick(self):
        self.update()

    def update(self, msg=None, current_cnt=None, total_cnt=None):
        if msg and msg != self.last_msg:
            if self.need_nl:
                self.to_file.write('\n')

            self.to_file.write(msg + ': ')
            self.last_msg = msg
        self.need_nl = True
        self.to_file.write('.')

    def clear(self):
        if self.need_nl:
            self.to_file.write('\n')

    def child_update(self, message, current, total):
        self.tick()

class TTYProgressBar(_BaseProgressBar):
    """Progress bar display object.

    Several options are available to control the display.  These can
    be passed as parameters to the constructor or assigned at any time:

    show_pct
        Show percentage complete.
    show_spinner
        Show rotating baton.  This ticks over on every update even
        if the values don't change.
    show_eta
        Show predicted time-to-completion.
    show_bar
        Show bar graph.
    show_count
        Show numerical counts.

    The output file should be in line-buffered or unbuffered mode.
    """
    SPIN_CHARS = r'/-\|'


    def __init__(self, **kwargs):
        #from bzrlib.osutils import terminal_width
        #TODO: Determine terminal width
        _BaseProgressBar.__init__(self, **kwargs)
        self.spin_pos = 0
        self.width = 80
        self.start_time = time.time()
        self.last_updates = deque()
        self.child_fraction = 0


    def throttle(self):
        """Return True if the bar was updated too recently"""
        # time.time consistently takes 40/4000 ms = 0.01 ms.
        # but every single update to the pb invokes it.
        # so we use time.time which takes 20/4000 ms = 0.005ms
        # on the downside, time.time() appears to have approximately
        # 10ms granularity, so we treat a zero-time change as 'throttled.'

        now = time.time()
        interval = now - self.last_update
        # if interval > 0
        if interval < self.MIN_PAUSE:
            return True

        self.last_updates.append(now - self.last_update)
        self.last_update = now
        return False


    def tick(self):
        self.update(self.last_msg, self.last_cnt, self.last_total,
                    self.child_fraction)

    def child_update(self, message, current, total):
        if current is not None and total != 0:
            child_fraction = float(current) / total
            if self.last_cnt is None:
                pass
            elif self.last_cnt + child_fraction <= self.last_total:
                self.child_fraction = child_fraction
        if self.last_msg is None:
            self.last_msg = ''
        self.tick()


    def update(self, msg, current_cnt=None, total_cnt=None,
               child_fraction=0):
        """Update and redraw progress bar."""

        if current_cnt < 0:
            current_cnt = 0

        if current_cnt > total_cnt:
            total_cnt = current_cnt

        ## # optional corner case optimisation
        ## # currently does not seem to fire so costs more than saved.
        ## # trivial optimal case:
        ## # NB if callers are doing a clear and restore with
        ## # the saved values, this will prevent that:
        ## # in that case add a restore method that calls
        ## # _do_update or some such
        ## if (self.last_msg == msg and
        ##     self.last_cnt == current_cnt and
        ##     self.last_total == total_cnt and
        ##     self.child_fraction == child_fraction):
        ##     return

        old_msg = self.last_msg
        # save these for the tick() function
        self.last_msg = msg
        self.last_cnt = current_cnt
        self.last_total = total_cnt
        self.child_fraction = child_fraction

        # each function call takes 20ms/4000 = 0.005 ms,
        # but multiple that by 4000 calls -> starts to cost.
        # so anything to make this function call faster
        # will improve base 'diff' time by up to 0.1 seconds.
        if old_msg == self.last_msg and self.throttle():
            return

        if self.show_eta and self.start_time and self.last_total:
            eta = get_eta(self.start_time, self.last_cnt + self.child_fraction,
                    self.last_total, last_updates = self.last_updates)
            eta_str = " " + str_tdelta(eta)
        else:
            eta_str = ""

        if self.show_spinner:
            spin_str = self.SPIN_CHARS[self.spin_pos % 4] + ' '
        else:
            spin_str = ''

        # always update this; it's also used for the bar
        self.spin_pos += 1

        if self.show_pct and self.last_total and self.last_cnt:
            pct = 100.0 * ((self.last_cnt + self.child_fraction) / self.last_total)
            pct_str = ' (%5.1f%%)' % pct
        else:
            pct_str = ''

        if not self.show_count:
            count_str = ''
        elif self.last_cnt is None:
            count_str = ''
        elif self.last_total is None:
            count_str = ' %i' % (self.last_cnt)
        else:
            # make both fields the same size
            t = '%i' % (self.last_total)
            c = '%*i' % (len(t), self.last_cnt)
            count_str = ' ' + c + '/' + t

        if self.show_bar:
            # progress bar, if present, soaks up all remaining space
            cols = self.width - 1 - len(self.last_msg) - len(spin_str) - len(pct_str) \
                   - len(eta_str) - len(count_str) - 3

            if self.last_total:
                # number of markers highlighted in bar
                markers = int(round(float(cols) *
                              (self.last_cnt + self.child_fraction) / self.last_total))
                bar_str = '[' + ('=' * markers).ljust(cols) + '] '
            elif False:
                # don't know total, so can't show completion.
                # so just show an expanded spinning thingy
                m = self.spin_pos % cols
                ms = (' ' * m + '*').ljust(cols)

                bar_str = '[' + ms + '] '
            else:
                bar_str = ''
        else:
            bar_str = ''

        m = spin_str + self.last_msg + bar_str + count_str + pct_str + eta_str

        assert len(m) < self.width
        self.to_file.write('\r' + m.ljust(self.width - 1))
        #self.to_file.flush()

    def clear(self):
        self.to_file.write('\r%s\r' % (' ' * (self.width - 1)))
        #self.to_file.flush()


class ChildProgress(_BaseProgressBar):
    """A progress indicator that pushes its data to the parent"""
    def __init__(self, _stack, **kwargs):
        _BaseProgressBar.__init__(self, _stack=_stack, **kwargs)
        self.parent = _stack.top()
        self.current = None
        self.total = None
        self.child_fraction = 0
        self.message = None

    def update(self, msg, current_cnt=None, total_cnt=None):
        self.current = current_cnt
        self.total = total_cnt
        self.message = msg
        self.child_fraction = 0
        self.tick()

    def child_update(self, message, current, total):
        if current is None or total == 0:
            self.child_fraction = 0
        else:
            self.child_fraction = float(current) / total
        self.tick()

    def tick(self):
        if self.current is None:
            count = None
        else:
            count = self.current+self.child_fraction
            if count > self.total:
                count = self.total
        self.parent.child_update(self.message, count, self.total)

    def clear(self):
        pass

    def note(self, *args, **kwargs):
        self.parent.note(*args, **kwargs)


def str_tdelta(delt):
    if delt is None:
        return "-:--:--"
    delt = int(round(delt))
    return '%d:%02d:%02d' % (delt/3600,
                             (delt/60) % 60,
                             delt % 60)


def get_eta(start_time, current, total, enough_samples=3, last_updates=None, n_recent=10):
    if start_time is None:
        return None

    if not total:
        return None

    if current < enough_samples:
        return None

    if current > total:
        return None                     # wtf?
    elapsed = time.time() - start_time

    if elapsed < 5.0:                   # not enough time to estimate
        return None

    total_duration = float(elapsed) * float(total) / float(current)

    assert total_duration >= elapsed

    if last_updates and len(last_updates) >= n_recent:
        while len(last_updates) > n_recent:
            last_updates.popleft()
        avg = sum(last_updates) / float(len(last_updates))
        time_left = avg * (total - current)

        old_time_left = total_duration - elapsed

        # We could return the average, or some other value here
        return (time_left + old_time_left) / 2

    return total_duration - elapsed


class ProgressPhase(object):
    """Update progress object with the current phase"""
    def __init__(self, message, total, pb):
        object.__init__(self)
        self.pb = pb
        self.message = message
        self.total = total
        self.cur_phase = None

    def next_phase(self):
        if self.cur_phase is None:
            self.cur_phase = 0
        else:
            self.cur_phase += 1
        assert self.cur_phase < self.total
        self.pb.update(self.message, self.cur_phase, self.total)


def sort_by_value(d):
    """ Returns the keys of dictionary d sorted by their values """
    items=d.items()
    backitems=[ [v[1],v[0]] for v in items]
    backitems.sort()
    backitems.reverse()
    return [ backitems[i][1] for i in xrange(0,len(backitems))]
def copy(args):
    progress=subprocess.Popen(args,stdout=subprocess.PIPE,stderr=subprocess.PIPE).stdout
    c=progress.readline()
    c=progress.readline()
    c=progress.readline()
    while c != '':
        c=progress.read(1)
        if c =='\n':
            progress.read()
            sys.stdout.write(' '*80+'\r')
            return
        sys.stdout.write(c)
        if c == '\r':
            sys.stdout.write("     ")
            sys.stdout.flush()



def defrag(file, fs, fragments, threshold):
    #Performs a defrag
    if fragments<= threshold:
        print "     Already defragmented."
        return fragments
    status=subprocess.Popen(['lsof','-f','--',file], stdout=subprocess.PIPE).communicate()[0]
    if len(status)>1 and not status.startswith("COMMAND"):
        print "     Unable to determine if file is open, skipping..."
        return fragments

    if len(status)>1 and status.split('\n')[1].split()[3].find('w')>=0:
        print "     File is open for write, skipping..."
        return fragments
    import shutil
    try:
        os.mkdir(os.path.dirname(fs)+"/.defrag")
    except OSError: pass
    os.chmod(os.path.dirname(fs)+"/.defrag",0)
    old_mtime=os.path.getmtime(file)
    copy(["rsync",'-a','--progress', file,os.path.dirname(fs)+"/.defrag/"])
    new_numfrags=numfrags(os.path.dirname(fs)+"/.defrag/"+os.path.basename(file))
    if new_numfrags >= fragments:
        print "     No improvement (%.1f --> %.1f)" % (fragments,new_numfrags)
        os.unlink(os.path.dirname(fs)+"/.defrag/"+os.path.basename(file))
        return fragments
    else:
        if new_numfrags <= threshold:
            print "     Fully defragmented!"
        else:
            print "     Improved: (%.1f --> %.1f)" % (fragments,new_numfrags)
        if os.path.getmtime(file) == old_mtime:
            shutil.move(os.path.dirname(fs)+"/.defrag/"+os.path.basename(file), file)
            return new_numfrags
        else:
            print "     Aborted: file changed during defrag."
            return numfrags(file)

def build_filelist(fs):
    #Uses find to get list of files on desired filesystem
    list=subprocess.Popen(["/usr/bin/find",fs,'-xdev','-type','f', '-print0'],stdout=subprocess.PIPE).communicate()[0].split('\0')
    return list[:-1]
def numfrags(file):
    #Uses filefrag to determine # of fragments.
    fragresult=subprocess.Popen(["filefrag",file],stdout=subprocess.PIPE).communicate()[0]
    match=ext_pattern.search(fragresult)
    if not match:
        print "Error analyzing",file
        return 0
    else:
        frags=int(match.expand(r'\1'))
        if frags == 1:
            return 0
    filesize=os.path.getsize(file)
    if filesize == 0:
        return 0
    else:
        return frags/(filesize/1024.0/1024.0)
def run(path,threshold=0.5,passes=-1,list=None, fragmatrix=None):
    if not fragmatrix:
        print "Building list of files to analyze...",
        sys.stdout.flush()
        list=build_filelist(path)
        print "done!"
        fragmatrix={}
        n=0
        pb = ProgressBar(show_pct=True, show_bar=True, show_spinner=True, show_eta=False)
        for file in list:
            pb.update((file+" "*25)[:25]+" ",float(n),len(list))
            n+=1
            f=numfrags(file)
            if f> threshold: fragmatrix[file]=f
        pb.clear()
        print "\nAnalyze finished.",
        if len(fragmatrix) == 0:
            print "\n%s is not fragmented. Go home." % path
            sys.exit(0)
    most_fragmented_files=sort_by_value(fragmatrix)
    frags=sum(fragmatrix.values())
    print "%.1f" % (len(most_fragmented_files)*100.0/len(list)),"%% fragmentation (%d files)," % len(most_fragmented_files),  "%.1f average frags/MB" % (float(frags)/len(fragmatrix))
    print "Fragmented files:"
    try:
        for i in xrange(0,10):
            print "%.2f\t%s" % (fragmatrix[most_fragmented_files[i]], most_fragmented_files[i])
        print "..."
    except IndexError: pass
    if passes <0:
        while True:
            try:
                tmp=raw_input("How many passes to run? [10] ")
                if len(tmp)==0:
                    passes=-10
                    break
                passes=int(tmp)*abs(passes)/passes
                break
            except ValueError: pass
    try:
        for k in xrange(0,abs(passes)):
            n=0
            rfrags=0
            t=0
            for t in most_fragmented_files:
                rfrags+=fragmatrix[t]
            print "\n",(str(k+1))*60
            print "===> Pass", k+1,"of", abs(passes),"<===    Remaining Fragmentation %d/%d (%d%%)" % (rfrags,frags,(rfrags/frags)*100)
            print (str(k+1))*60+"\n"
            for i in most_fragmented_files:
                n+=1
                print "\n  Pass %d of %d, %d/%d (%d%%):" % (k+1,abs(passes),n,len(most_fragmented_files),100*n/len(most_fragmented_files)), "%.1f frags/MB" % fragmatrix[i], i
                try:
                    fragmatrix[i]=defrag(i,path,fragmatrix[i],threshold)
                except OSError:
                    print "     Error defragmenting. Did the file disappear?"
            tmp=most_fragmented_files[:]
            for i in tmp:
	        if fragmatrix[i] <= threshold:
                    most_fragmented_files.remove(i)

    finally:

        print "========= COMPLETE ==========="
        print "Remaining Fragmented Files:"
        try:
            most_fragmented_files.reverse()
            for i in most_fragmented_files:
                print "%.2f\t%s" % (fragmatrix[i], i)
        except IndexError: pass
        print "Frags/MB Before:\t %.2f" % frags
        nowfrags=0
        for i in most_fragmented_files:
            nowfrags+=fragmatrix[i]
        print "Frags/MB After: \t %.2f" % nowfrags
        print "Improvement:    \t %.1f %%" % ((frags-nowfrags)/frags * 100)
        print "==============================="
        if nowfrags and passes < 0:
            response='Fish'
            while not response in ('Y','y','N','n',''):
                response=raw_input("\nThere is still fragmentation. Run another set of passes? [Y/n]")
            if response in ('Y','y',''):
                run(path,threshold,passes,list,fragmatrix)


try:
    opts=None
    if os.getuid():
        raise "** ERROR ** This tool requires root/sudo access."
    try:
        opts=getopt.gnu_getopt(sys.argv[1:],'hn:t:a',('help', 'passes=', 'threshold=' ,'analyze'))
        passes = -1
        threshold = .5
        for i in opts[0]:
            if   i[0] in ('-n','--passes'):
                passes=int(i[1])
            elif i[0] in ('-h', '--help'):
                raise getopt.GetoptError("")
            elif i[0] in ('-t','--threshold'):
                threshold=float(i[1])
            elif i[0] in ('-a','--analyze'):
                passes=0
                threshold=0
        try:
            if os.path.isdir(opts[1][0]) and opts[1][0][-1] != '/':
                opts[1][0]+="/"
            run(opts[1][0], threshold, passes)
        except IndexError:
            raise getopt.GetoptError("No path specified")
    except getopt.GetoptError, info:
        print info
        print "%s [-h] [-n passes] [--passes n] [-t threshold] [--threshold n] [-a] [--analyze] [--help] path"% sys.argv[0]
finally:
    if opts and len(opts[1]) and os.path.isdir(os.path.dirname(opts[1][0])+"/.defrag"):
        subprocess.Popen(['rm','-f','-r',os.path.dirname(opts[1][0])+"/.defrag"], stdout=subprocess.PIPE).communicate()[0]
