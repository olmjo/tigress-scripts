#!/usr/bin/env bash

## Prepare Env
. /etc/profile.d/modules.sh

source ~/.bashrc

## Compile Test Binary
mpic++ hello.c -o tester

## Run Test Binary
mpirun -np 3 -mca btl ^openib ./tester

## Remove Test Binary
rm -f ./tester
