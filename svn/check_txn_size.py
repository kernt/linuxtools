#!/usr/bin/env python
import sys,os,popen2
 
MAX_BYTES = 1024000
DEBUG = False
SVNLOOK = '/usr/bin/svnlook'
ALLOWED_USERS = ['david', 'ctang', 'vjain', 'mike', 'sbridges', 'tcirip']
ADMIN_EMAIL = '<a href="mailto:admin@company.com">admin@company.com</a>'
 
def printUsage():
  sys.stderr.write('Usage: %s "$REPOS" "$TXN" ' % sys.argv[0])
 
def getTransactionSize(repos, txn):
  txnRevPath = repos+'/db/transactions'+'/'+txn+'.txn'+'/rev'
  return os.stat(txnRevPath)[6]
 
def printDebugInfo(repos, txn):
  for root, dirs, files in os.walk(repos+'/db/transactions', topdown=False):
    sys.stderr.write(root+", filesize="+str(os.stat(root)[6])+"\n\n")
    for name in files:
      sys.stderr.write(name+", filesize="+str(os.stat(root+'/'+name)[6])+"\n")
 
def checkTransactionSize(repos, txn):
  size = getTransactionSize(repos, txn)
  if (size > MAX_BYTES):
    sys.stderr.write("Sorry, you are trying to commit %d bytes, which is larger than the limit of %d.\n" % (size, MAX_BYTES))
    sys.stderr.write("If you think you have a good reason to, email %s and ask for permission." % (ADMIN_EMAIL))
    sys.exit(1)
 
def getUser(repos, txn):
  cmd = SVNLOOK + " author " + repos + " -t " + txn
  out, x, y = popen2.popen3(cmd)
  cmd_out = out.readlines()
  return cmd_out[0][:-1]
 
if __name__ == "__main__":
  #Check that we got a repos and transaction with this script
  if len(sys.argv) != 3:
    printUsage()
    sys.exit(2)
  else:
    repos = sys.argv[1]
    txn = sys.argv[2]
 
  if DEBUG: printDebugInfo(repos, txn)
  user=getUser(repos, txn)
  if DEBUG: sys.stderr.write("User:"+user)
  if DEBUG:
    if (user in ALLOWED_USERS):
      sys.stderr.write(user+" in allowed users")
    else:
      sys.stderr.write(user+" not in allowed users")
  if (user not in ALLOWED_USERS):
    checkTransactionSize(repos, txn)
