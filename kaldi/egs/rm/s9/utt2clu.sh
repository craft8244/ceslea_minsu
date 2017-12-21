#!/bin/bash

. ./cmd.sh
. ./path.sh
set -e # exit on error

for x in 3 5 7 10; do
cluster_test_v1 scp:exp/ivectors_test/ivector.scp ark:save_train_${x}_r.ark utt_scores_${x}_r
done

exit 0
