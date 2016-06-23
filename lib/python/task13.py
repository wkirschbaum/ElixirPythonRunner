import time

# start and resume methods are required
def start():
    print "start task 13"
    do_work()
    return

def resume():
    print "resume task 13"
    do_work()
    return

def do_work():
    time.sleep(10)
    print "task 13 done"
    return
