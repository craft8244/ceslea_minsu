#!/bin/bash

. ./cmd.sh
. ./path.sh
set -e # exit on error

cluster_test_v1 scp:../s9/exp/ivectors_test/ivector.scp ark:save_train_7.ark utt_scores_7

exit 0
