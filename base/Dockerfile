################### Build Mallob
FROM ubuntu:20.04
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt install -y python3-pip git openssh-server openssh-server iproute2 openmpi-bin openmpi-common iputils-ping 

USER root

#  Install required softwares
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt install -y cmake build-essential zlib1g-dev libopenmpi-dev wget unzip build-essential zlib1g-dev cmake python3 build-essential gfortran wget curl libjemalloc-dev libjemalloc2 gdb libboost-all-dev
    
# Build Mallob
# This is a single command such that a change in the commit hash will make Docker re-fetch the repository
RUN git clone https://github.com/domschrei/mallob.git && cd mallob && git checkout distributed-combine && cd ..

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
RUN echo "Making the composition tools"
WORKDIR /mallob/tools/composition
# Just in case - causes problems later if you have built outside Docker.
RUN rm -Rf build
RUN make 

# Build preprocessor
RUN echo "Making preprocessor"
WORKDIR /
RUN git clone https://github.com/marijnheule/preprocess-simple.git 
WORKDIR /preprocess-simple
RUN make

# Build drat-trim
RUN echo "Making drat-trim"
WORKDIR /
RUN git clone https://github.com/marijnheule/drat-trim.git
WORKDIR /drat-trim
RUN sed -i 's/define MODE	1/define MODE	2/g' decompress.c
RUN make

