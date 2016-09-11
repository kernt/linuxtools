#!/usr/bin/perl
use strict;
use warnings;
#
# Reporting disk usage on the mail server
#
# Run the script in a cron job
# Quelle: http://szabgab.com/talks/fundamentals_of_perl/read-excel-file.html
#
#  1) Report to Boss if there are people with large files
#    
#  2) If a user has a file that is too big then ask him to remove the
#      large e-mail from the mail server via web access
#      This one has not been implemented yet
#
#############################################################################################################

use Mail::Sendmail qw(sendmail);
use Filesys::Df    qw(df);

################## Limit Definitions
my $report_to_boss_limit = 1_000_000;   # the size of the /var/spool/mail/username file   in bytes
my $report_to_user_limit = 1_000_000;
my $boss_email = 'boss@hsu-hh.de';
my $from_email = 'Disk Usage Report <sysadmin@hsu-hh.de>';
my $disk_space_percantage = 80;


my %file_size;
foreach my $path (</var/spool/mail/*>) {    # each user has a file in that directory
    if ($path =~ /Save/) {                  # disregard the Save directory
        next;
    }
    if ($path =~ /\.pop$/) {                # disregard temporary .pop files
        next;
    }

    $file_size{$path} = -s $path;
}

my $txt = "x";
# sort files by size
foreach my $path (sort {$file_size{$b} <=> $file_size{$a}} keys %file_size) {
   my $name = $path;
   $name =~ s{/var/spool/mail/}{};

   if ($file_size{$path} > $report_to_boss_limit) {
      $txt .= "$name\t\t" . int ($file_size{$_}/1_000_000) . " MB\n";
   }

}

my @disks = qw(/ /boot);
foreach my $disk (@disks) {
   my $df = df($disk, 1024 * 1024 * 1024);
   if ($df->{per} > $disk_space_percantage) {
      $txt .= "\n\nDiskspace is low\n\nUsing " . $df->{per} . "\% of the space on $disk\n";
   }
}

if ($txt) {
   $txt = "Disk Usage of /var/spool/mail on the incoming mail server\n" .
          "Reporting users over $report_to_boss_limit bytes\n\n" .
          $txt;
   sendmail (
        To      => $boss_email,
        From    => $from_email,
        Subject => 'Disk Usage Report' . localtime(),
        Message => $txt,
    );
}
