#! /bin/sh
cd leader
docker build --no-cache -t mallob-calrat-proof:leader .
cd ../worker
docker build --no-cache -t mallob-calrat-proof:worker .
cd ..
