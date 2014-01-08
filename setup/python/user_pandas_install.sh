#!/bin/bash

instdir=~/local/lib/python2.6/site-packages/
mkdir -p ${instdir}
echo -e PYTHONPATH=${instdir}:${PYTHONPATH} >> ~/.bashrc
echo -e export PYTHONPATH  >> ~/.bashrc
. ~/.bashrc
easy_install --prefix=$HOME/local pandas

