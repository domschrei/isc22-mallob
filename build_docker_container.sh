#! /bin/sh
cd leader
docker build -t mallob-calrat:leader .
cd ../worker
docker build -t mallob-calrat:worker .
cd ..
