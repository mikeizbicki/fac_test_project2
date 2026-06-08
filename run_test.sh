#!/bin/bash

# This test checks that variables used in dependencies but not in the target
# correctly trigger builds of the dependencies, both incrementally and from scratch.

source ../framework.sh

# Incremental build tests: each fac call builds on top of the previous.
fac 'outline.json'
ls -R | dotest checkpoint1

fac 'sub$LEVEL1/outline.json'
ls -R | dotest checkpoint2

fac 'sub$LEVEL1/sub$LEVEL2/outline.json'
ls -R | dotest checkpoint3

fac 'final.txt'
ls -R | dotest checkpoint4

# Rerunning the same commands should be no-ops and leave files matching checkpoint4.
fac 'outline.json'
ls -R | dotest checkpoint4

fac 'sub$LEVEL1/outline.json'
ls -R | dotest checkpoint4

fac 'sub$LEVEL1/sub$LEVEL2/outline.json'
ls -R | dotest checkpoint4

fac 'final.txt'
ls -R | dotest checkpoint4

# From-scratch build tests: reset_git wipes build artifacts between each fac call.
reset_git
fac 'outline.json'
ls -R | dotest checkpoint1

reset_git
fac 'sub$LEVEL1/outline.json'
ls -R | dotest checkpoint2

reset_git
fac 'sub$LEVEL1/sub$LEVEL2/outline.json'
ls -R | dotest checkpoint3

reset_git
fac 'final.txt'
ls -R | dotest checkpoint4

finalize_tests
