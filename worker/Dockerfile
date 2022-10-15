################### Build Mallob
FROM satcomp-base:worker AS builder
USER root
#  Install required softwares
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt install -y cmake build-essential zlib1g-dev libopenmpi-dev wget unzip build-essential zlib1g-dev cmake python3 build-essential gfortran wget curl libjemalloc-dev libjemalloc2 gdb

# Build Mallob
# This is a single command such that a change in the commit hash will make Docker re-fetch the repository
RUN git clone https://github.com/domschrei/mallob.git && cd mallob && git checkout distributed-combine && git checkout 95f05a677f08308c54f31e9abd9a534bc93b8fa5 && cd ..

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

################### Extract Mallob in run stage
FROM satcomp-base:worker AS mallob_liaison
RUN whoami
USER root
RUN DEBIAN_FRONTEND=noninteractive apt install -y libjemalloc-dev libjemalloc2 gdb psmisc
RUN mkdir /logs
RUN chown ecs-user /logs

USER ecs-user
WORKDIR /
# Copy mallob
COPY --from=builder /mallob/build/mallob mallob
COPY --from=builder /mallob/build/mallob_sat_process mallob_sat_process
COPY --from=builder /mallob/build/mallob_process_dispatcher mallob_process_dispatcher
COPY --chown=ecs-user /worker /competition
COPY --chown=ecs-user /cleanup /competition

RUN chmod +x /competition/worker
RUN chmod +x /competition/cleanup

RUN mkdir -p /logs/processes
RUN mkdir -p /logs/extmem
RUN mkdir -p /logs/tracedir
