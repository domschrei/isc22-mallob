################### Build Mallob
FROM satcomp-base:leader AS builder
USER root
#  Install required softwares
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt install -y cmake build-essential zlib1g-dev libopenmpi-dev wget unzip build-essential zlib1g-dev cmake python3 build-essential gfortran wget curl libjemalloc-dev libjemalloc2 gdb
    
# Build Mallob
# This is a single command such that a change in the commit hash will make Docker re-fetch the repository
RUN git clone https://github.com/domschrei/mallob && cd mallob && git checkout distributed-combine && cd ..

# Build Mallob
WORKDIR mallob
RUN cd lib && bash fetch_and_build_sat_solvers.sh ckly && cd ..
RUN mkdir build
RUN cd build \
  && cmake -DMALLOB_CERTIFIED_UNSAT=1 -DCMAKE_BUILD_TYPE=RELEASE \
    -DMALLOB_SUBPROC_DISPATCH_PATH=\"./\" -DMALLOB_ASSERT=1 -DMALLOB_USE_GLUCOSE=0 \
    -DMALLOB_USE_ASAN=0 -DMALLOB_USE_JEMALLOC=1 -DMALLOB_JEMALLOC_DIR=/usr/lib/x86_64-linux-gnu \
    -DMALLOB_LOG_VERBOSITY=3 .. \
  && VERBOSE=1 make -j4 \
  && cd ..

# Build Dawn's composition tools
# WORKDIR /
# COPY /tools tools
WORKDIR /mallob/tools/composition
# Just in case - causes problems later if you have built outside Docker.
RUN rm -Rf build
RUN make 

# Build preprocessor
RUN git clone https://github.com/marijnheule/preprocess-simple.git 
WORKDIR /preprocess-simple
RUN make

# Build drat-trim
RUN git clone https://github.com/marijnheule/drat-trim.git
WORKDIR /drat-trim
RUN make



################### Extract Mallob in run stage
FROM satcomp-base:leader AS mallob_liaison
RUN whoami
USER root
RUN DEBIAN_FRONTEND=noninteractive apt install -y libjemalloc-dev libjemalloc2 gdb psmisc
USER ecs-user
WORKDIR /
# Copy mallob and solver scripts
COPY --from=builder /mallob/build/mallob mallob
COPY --from=builder /mallob/build/mallob_sat_process mallob_sat_process
COPY --from=builder /mallob/build/mallob_process_dispatcher mallob_process_dispatcher
COPY --chown=ecs-user /run_mallob.sh /competition
COPY --chown=ecs-user /solver /competition
COPY --chown=ecs-user /cleanup /competition
USER ecs-user
RUN chmod +x /competition/run_mallob.sh
RUN chmod +x /competition/solver
RUN chmod +x /competition/cleanup


# Copy mallob and solver scripts
COPY --from=builder /drat-trim/lrat-check lrat-check
COPY --from=builder /drat-trim/compress compress
COPY --from=builder /drat-trim/decompress decompress
COPY --from=builder /drat-trim/drat-trim drat-trim
COPY --from=builder /preprocess-simple/cleanup preprocess-cnf
COPY --from=builder /mallob/tools/composition/build/compose-proofs compose-proofs 
COPY --from=builder /mallob/tools/composition/build/renumber-proofs renumber-proofs
COPY --from=builder /mallob/tools/composition/build/dratify dratify
COPY --chown=ecs-user /docker/leader/run_mallob.sh /competition
COPY --chown=ecs-user /docker/leader/compress_preprocessing_proof.sh /competition
COPY --chown=ecs-user /docker/leader/proof_line_count.sh /competition
COPY --chown=ecs-user /docker/leader/proof_compose.sh /competition
COPY --chown=ecs-user /docker/leader/proof_renumber.sh /competition
COPY --chown=ecs-user /docker/leader/proof_check.sh /competition
COPY --chown=ecs-user /docker/leader/preprocess_cnf.sh /competition
COPY --chown=ecs-user /docker/leader/drat_compose.sh /competition
COPY --chown=ecs-user /docker/leader/solver /competition
COPY --chown=ecs-user /docker/leader/cleanup /competition
COPY --chown=ecs-user /instances/r3unsat_200.cnf /competition/test.cnf
COPY --chown=ecs-user /instances/r3unsat_300.cnf /competition/test2.cnf
