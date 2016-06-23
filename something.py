import sys
import time

if sys.argv[1] == "resume":
    print "resuming py"
else:
    print "starting py"

time.sleep(1)
print 'Script finished!'
