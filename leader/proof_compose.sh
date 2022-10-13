#!/bin/bash


# this also outputs the unpruned DRAT proof.
/compose-proofs --loose --keep-temps --write-unpruned /logs/processes/drat.lrat --binary $* 1>&2 
