import time

# start and resume methods are required
def start():
    print "start task 12"
    do_work()
    return

def resume():
    print "resume task 12"
    do_work()
    return

def do_work():
    print "task 12 done"
    raise 'nooo!'
    return
