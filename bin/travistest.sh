#!/usr/bin/env bash
# mkdir ${HOME}/distfiles/test
# /bin/ls -lart ${HOME}/distfiles
# exit $?
. ${HOME}/local/setup-env.sh
set -ex

bam2bax -h
bamSieve -h
bax2bam -h
blasr -h
ccs -h
dataset -h
pbalign -h
pbindex -h
pbmerge -h
pbservice -h
pbsmrtpipe -h
pbtestkit-runner -h
pbtools-runner -h
pbvalidate -h
#sawriter
fasta-to-reference --help
python -c "from pbcore.io import *"
for myfile in bin/pitchfork; do
    pep8 --ignore=E221,E501,E265,E731,E402,E302,W292 $myfile
done
# /bin/ls -lart /home/travis
