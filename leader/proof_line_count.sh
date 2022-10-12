#!/bin/bash

echo ">>>>>Proof Sizes<<<<<" 1>&2
grep --invert d /logs/processes/renumbered-dec.lrat | wc -l 1>&2
ls -l /logs/processes/*.lrat 1>& 2
# grep --invert d /logs/processes/._____combined_proof_file.frat | wc -l 1>&2
