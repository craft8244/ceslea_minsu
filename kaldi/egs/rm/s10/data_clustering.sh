#!/bin/bash

. ./cmd.sh
. ./path.sh
set -e # exit on error

for x in 3 5 7 10; do
 #python data_cluster_train.py data/train data/train_clu$x save_train_$x
 python data_cluster_test_v2.py data/test data/test_clu$x test_utt_clu_$x
done
