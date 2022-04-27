#!/bin/bash

command="mpirun --mca btl_tcp_if_include eth0 --allow-run-as-root --hostfile $1 \
--use-hwthread-cpus --map-by node:PE=2 --bind-to none --report-bindings \
`# Executable & formula input` \
mallob -mono=$2 \
`# General options` \
-sleep=1000 -t=4 -appmode=fork -nolog -v=3 -interface-fs=0 -trace-dir=competition -subproc-dir=. \
`# SAT solving options` \
-satsolver=kclg"

echo "run_mallob.sh : EXECUTE $command"

# Workaround for MPI error messages "Read -1, expected <some number>, errno = 1"
OMPI_MCA_btl_vader_single_copy_mechanism=none
export OMPI_MCA_btl_vader_single_copy_mechanism=none

# Allow MPI processes to spawn (non-communicating) subprocesses
RDMAV_FORK_SAFE=1
export RDMAV_FORK_SAFE=1

# Run the actual command
OMPI_MCA_btl_vader_single_copy_mechanism=none RDMAV_FORK_SAFE=1 $command

echo "run_mallob.sh : DONE"
