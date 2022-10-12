#!/bin/bash

echo ">>>>>Proof Sizes<<<<<" 1>&2
echo "/logs/processes/renumbered-dec.lrat :" `grep --invert d /logs/processes/renumbered-dec.lrat | wc -l` 1>&2
ls -l /logs/processes/*.lrat 1>& 2
echo ">>>>>End Proof Sizes<<<<<" 1>&2
