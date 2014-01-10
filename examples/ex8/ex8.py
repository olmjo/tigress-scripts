import multiprocessing
import time
import os

MC = 10
DUR = 20.0
nProcs = int(os.environ['PROCS'])
delays = [DUR / MC] * MC
print(delays)
####

thestart = time.time()

for i in delays :
    time.sleep(i)

theend = time.time()
thetotal = theend - thestart
print(thetotal)

####
thestart = time.time()

p = multiprocessing.Pool(processes = nProcs)
p.map(time.sleep, delays)

theend = time.time()
thetotal = theend - thestart
print(thetotal)
