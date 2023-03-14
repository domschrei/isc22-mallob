#! /bin/sh
cd base
docker build -t mallob-calrat-proof:base .
cd ../leader
docker build -t mallob-calrat-proof:leader .
cd ../worker
docker build -t mallob-calrat-proof:worker .
cd ..
