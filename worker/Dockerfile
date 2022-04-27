################### Build Mallob
FROM satcomp-base:worker AS builder
USER root
#  Install required softwares
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt install -y cmake build-essential zlib1g-dev libopenmpi-dev wget unzip build-essential zlib1g-dev cmake python3 build-essential gfortran wget curl libjemalloc-dev libjemalloc2 gdb

# Build Mallob
RUN git clone https://github.com/domschrei/mallob
WORKDIR mallob
RUN git checkout interface
RUN cd lib && bash fetch_and_build_sat_solvers.sh kclgy && cd ..
RUN mkdir build
RUN cd build && cmake -DCMAKE_BUILD_TYPE=RELEASE -DMALLOB_ASSERT=1 -DMALLOB_USE_GLUCOSE=1 -DMALLOB_USE_ASAN=0 -DMALLOB_USE_JEMALLOC=1 -DMALLOB_JEMALLOC_DIR=/usr/lib/x86_64-linux-gnu -DMALLOB_LOG_VERBOSITY=3 .. && VERBOSE=1 make -j4 && cd ..
#RUN find /usr -name '*libjemalloc*'

################### Extract Mallob in run stage
FROM satcomp-base:worker AS mallob_liaison
RUN whoami
USER root
RUN DEBIAN_FRONTEND=noninteractive apt install -y libjemalloc-dev libjemalloc2 gdb
USER ecs-user
WORKDIR /
# Copy mallob
COPY --from=builder /mallob/build/mallob mallob
COPY --from=builder /mallob/build/mallob_sat_process mallob_sat_process
COPY --chown=ecs-user /worker /competition
COPY --chown=ecs-user /cleanup /competition

RUN chmod +x /competition/worker
RUN chmod +x /competition/cleanup