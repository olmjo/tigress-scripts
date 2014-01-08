#!/bin/bash
module load python/2.7
echo -e 'module load python/2.7\n'
instdir=~/local/lib/python2.7/site-packages/
mkdir -p ${instdir}
echo -e 'PYTHONPATH=${instdir}:${PYTHONPATH}\n' >> ~/.bashrc
echo -e 'export PYTHONPATH\n'  >> ~/.bashrc
. ~/.bashrc
easy_install --prefix=$HOME/local pandas

