#!/bin/bash
# Copyright 2015   David Snyder
# Apache 2.0.
#
# This script trains an LDA transform and does cosine scoring.

echo "$0 $@"  # Print the command line for logging

if [ $# != 4 ]; then
  echo "Usage: $0 <speaker-data-dir> <speaker-ivec-dir> <trials-file> <scores-dir>"
fi

speaker_data_dir=$1
speaker_ivec_dir=$2
trials=$3
scores_dir=$4

ivector-computer $trials \
  scp:${speaker_ivec_dir}/spk_ivector.scp \
  scp:${speaker_ivec_dir}/spk_ivector.scp \
   $scores_dir/cosine_scores || exit 1;
