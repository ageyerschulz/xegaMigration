#!/bin/sh

# number of mpi processes
NPIDS=10

# R command and profile for mpi
R_CMD="Rscript --no-save --quiet"
#R_PROFILE_USER="rmpiProfile.R"

for ((I=0; I<NPIDS; I++))
do
   echo $R_CMD $1 $I $NPIDS &   
   $R_CMD $1 $I $NPIDS > "test10/test10out$I.txt" &   
#   $R_CMD $1 $I $NPIDS &   
done

wait
