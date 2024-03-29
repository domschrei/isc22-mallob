################### Build Mallob
FROM satcomp-base:worker AS builder
USER root
#  Install required softwares
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt install -y cmake build-essential zlib1g-dev libopenmpi-dev wget unzip build-essential zlib1g-dev cmake python3 build-essential gfortran wget curl libjemalloc-dev libjemalloc2 gdb

# Build Mallob
# This is a single command such that a change in the commit hash will make Docker re-fetch the repository
RUN git clone https://github.com/domschrei/mallob && cd mallob && git checkout interface && git checkout 35794bfa9d650f7c465c08cd0073a71833119162 && cd ..
WORKDIR mallob
RUN cd lib && bash fetch_and_build_sat_solvers.sh kclgy && cd ..
RUN mkdir build
RUN cd build && cmake -DCMAKE_BUILD_TYPE=RELEASE -DMALLOB_SUBPROC_DISPATCH_PATH=\"./\" -DMALLOB_ASSERT=1 -DMALLOB_USE_GLUCOSE=1 -DMALLOB_USE_ASAN=0 -DMALLOB_USE_JEMALLOC=1 -DMALLOB_JEMALLOC_DIR=/usr/lib/x86_64-linux-gnu -DMALLOB_LOG_VERBOSITY=3 .. && VERBOSE=1 make -j4 && cd ..
#RUN find /usr -name '*libjemalloc*'

################### Extract Mallob in run stage
FROM satcomp-base:worker AS mallob_liaison
RUN whoami
USER root
RUN DEBIAN_FRONTEND=noninteractive apt install -y libjemalloc-dev libjemalloc2 gdb psmisc
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
