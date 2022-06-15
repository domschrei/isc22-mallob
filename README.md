
# Mallob in the International SAT Competition 2022

See the following branches of this repository for my submissions:

* Branch `ki` for the Parallel Track
* Branch `kiki` for the Cloud Track ("pure" configuration, one CDCL solver only)
* Branch `kicaliglu` for the Cloud Track (diverse portfolio due to the new rules)

## How to Build

To build the Mallob leader container: 

1. Navigate to the `leader` subdirectory.
2. Run `docker build -t mallob:leader .`

To build the Mallob worker container:

1. Navigate to the `worker` subdirectory.
2. Run `docker build -t mallob:worker .`

After building both images, run `docker image ls` and make sure you see both `mallob:leader` and `mallob:worker` in the list of images.

## License

The sources in this repository, including the Dockerfiles building Mallob, are licensed under MIT-0.
The sources of Mallob itself are provided under a different license (LGPLv3 by default).

