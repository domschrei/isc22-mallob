#!/bin/bash

processes_per_host=$(cat $1|grep -oE "slots=[0-9]+"|head -1|grep -oE "[0-9]+")

command="mpirun --mca btl_tcp_if_include eth0 --allow-run-as-root --hostfile $1 \
--use-hwthread-cpus --map-by node:PE=$processes_per_host --bind-to none --report-bindings \
`# Executable & formula input` \
mallob -mono=$2 \
`# General options` \
-sleep=1000 -t=4 -appmode=fork -nolog -v=3 -interface-fs=0 -trace-dir=competition -subproc-dir=. -max-lits-per-thread=50000000 -pipe-large-solutions=0 -processes-per-host=$processes_per_host -regular-process-allocation=1 -strict-clause-length-limit=20 -clause-buffer-discount=1 \
`# SAT solving options` \
-clause-filter-clear-interval=300 -max-lbd-partition-size=2 -export-chunks=20 \
`# Kicaliglu portfolio` \
`#-satsolver=kkclkkclkkclkkclccgg` `# 8 Kissat, 6 CaDiCaL, 4 Lingeling, 2 Glucose`
`# Ki, Kiki portfolio` \
-satsolver=k"

echo "run_mallob.sh : EXECUTE $command"

# Workaround for MPI error messages: Read -1, expected <some number>, errno = 1
OMPI_MCA_btl_vader_single_copy_mechanism=none
export OMPI_MCA_btl_vader_single_copy_mechanism=none

# Allow MPI processes to spawn (non-communicating) subprocesses
RDMAV_FORK_SAFE=1
export RDMAV_FORK_SAFE=1

# Run the actual command
OMPI_MCA_btl_vader_single_copy_mechanism=none RDMAV_FORK_SAFE=1 $command

echo "run_mallob.sh : DONE"
