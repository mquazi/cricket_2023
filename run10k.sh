#!/bin/bash -l
#PBS -q default
#PBS -l walltime=48:00:00,nodes=10:ppn=8
#PBS -M dattap@unm.edu
#PBS -m abe
#PBS -N cricket_2020_sampling
#PBS -o /users/dattap/cricket_2020/output_file
#PBS -e /users/dattap/cricket_2020/error_file

#load R module
module load r-4.0.2-gcc-9.3.0-python3-krncrvc
module load openmpi-3.1.5-intel-19.0.3-nbphrek
sleep 10

NUM_SAMPLES=10

mpirun -np 2 ./batch_run.sh ${NUM_SAMPLES} 1 
mpirun -np 2 ./batch_run.sh ${NUM_SAMPLES} 2
mpirun -np 2 ./batch_run.sh ${NUM_SAMPLES} 3 
mpirun -np 2 ./batch_run.sh ${NUM_SAMPLES} 4 
mpirun -np 2 ./batch_run.sh ${NUM_SAMPLES} 5 
mpirun -np 2 ./batch_run.sh ${NUM_SAMPLES} 6 
mpirun -np 2 ./batch_run.sh ${NUM_SAMPLES} 7 
mpirun -np 2 ./batch_run.sh ${NUM_SAMPLES} 8 
mpirun -np 2 ./batch_run.sh ${NUM_SAMPLES} 9 
mpirun -np 2 ./batch_run.sh ${NUM_SAMPLES} 10
