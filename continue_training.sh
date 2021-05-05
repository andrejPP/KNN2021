#!/bin/bash

MODELPATH=$1
BRANCHNAME=$2
JTIMEOUT=$3
SHOUR=$(echo $JTIMEOUT | cut -d: -f1)
STIME=$((SHOUR - 1))


FULLMODELPATH=`pwd`/$MODELPATH

echo $FULLMODELPATH


qsub -v modelpath="$FULLMODELPATH",branch="$BRANCHNAME",stime="$STIME" -l walltime=$JTIMEOUT ./train_tunit_auto.sh
