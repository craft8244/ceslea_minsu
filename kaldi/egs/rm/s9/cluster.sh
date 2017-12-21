#!/bin/bash

. ./cmd.sh
. ./path.sh
set -e # exit on error

##local/cosine_scoring_speaker.sh data/test exp/ivectors_test data/test/speaker_trials cluster
cluster_v1 --clusternum=3 ark:exp/ivectors_train/spk_ivector.ark ark:save_train_3_r.ark

exit 0
