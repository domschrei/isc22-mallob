# SATComp Sample Solver

This repository contains two Dockerfiles that build the Mallob distributed solver using the SAT-Comp 2022 infrastructure.  It is intended to be used for teams to understand how to build solvers for SAT-Comp.

**N.B.:** Although this repository is released under the MIT-0 license, the Mallob solver that is built by these Docker files is under the [LGPL 3.0](https://opensource.org/licenses/lgpl-3.0.html) license, and that any use/extensions of Mallob will be governed by that license.

## Prerequisites

First, this build process has been tested only on linux (AL2 and Ubuntu 20).  Builds on other platforms have not been tested.
 
Second, the build process requires that Docker is installed on the machine.  

Third, the Mallob docker images are built on top of the base containers satcomp-base:leader and satcomp-base:worker.
The process of building these base images (as well as many other aspects of building solvers for SAT-Comp) is described in the README.md file in the [https://github.com/aws-samples/aws-batch-comp-infrastructure-sample](https://github.com/aws-samples/aws-batch-comp-infrastructure-sample) repository. 
Please follow the steps in this repository up to the point at which the base containers have been built.  

## How to Build

To build the Mallob leader container: 

1. Navigate to the `leader` subdirectory.
2. Run `docker build -t mallob:leader .`

To build the Mallob worker container:

1. Navigate to the `worker` subdirectory.
2. Run `docker build -t mallob:worker .`

After building both images, run `docker image ls` and make sure you see both `mallob:leader` and `mallob:worker` in the list of images.
