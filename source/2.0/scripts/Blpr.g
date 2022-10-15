#!/bin/sh 
SCI="SCILAB_DIRECTORY"
export SCI
ARG1=$1
shift
$SCI/bin/Slpr "$ARG1" $*
