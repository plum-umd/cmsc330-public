#!/bin/bash

FILENAME=submission.zip

rm -f $FILENAME
zip -r $FILENAME bst/bst.pl solver/solver.pl
