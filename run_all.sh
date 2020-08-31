#!/bin/bash
#PBS -q default
#PBS -l walltime=24:00:00,nodes=2:ppn=8
#PBS -M dattap@unm.edu
#PBS -m abe
#PBS -N cricket_2020_sampling
#PBS -o /users/dattap/cricket_2020/output_file
#PBS -e /users/dattap/cricket_2020/error_file

#load R module
module load r-4.0.2-gcc-9.3.0-python3-krncrvc
sleep 10

#list of commands
R -e 'source("/users/dattap/cricket_2020/afghanistan/afgauto.R")' &
R -e 'source("/users/dattap/cricket_2020/australia/ausauto.R")'   &
R -e 'source("/users/dattap/cricket_2020/bangladesh/banauto.R")'  &
R -e 'source("/users/dattap/cricket_2020/england/engauto.R")'     &
R -e 'source("/users/dattap/cricket_2020/india/indauto.R")'       &
R -e 'source("/users/dattap/cricket_2020/ireland/irlauto.R")'     &
R -e 'source("/users/dattap/cricket_2020/newzealand/nzlauto.R")'  &
R -e 'source("/users/dattap/cricket_2020/pakistan/pakauto.R")'    &
R -e 'source("/users/dattap/cricket_2020/southafrica/safauto.R")' &
R -e 'source("/users/dattap/cricket_2020/srilanka/sriauto.R")'    &
R -e 'source("/users/dattap/cricket_2020/westindies/wiauto.R")'   &
R -e 'source("/users/dattap/cricket_2020/zimbabwe/zimauto.R")'    &

