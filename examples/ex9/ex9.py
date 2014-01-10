import os

arraysize = int(os.environ['ARRAYSIZE'])
thisrank = int(os.environ['PBS_ARRAYID'])

for idx in range(1, arraysize + 1) :
    if idx ==  thisrank :
        bigstring = 'This is array rank ' + os.environ['PBS_ARRAYID'] + ' from job ' + os.environ['PBS_JOBID']
        bigstring += ' out of ' + os.environ['ARRAYSIZE']
        print(bigstring)


