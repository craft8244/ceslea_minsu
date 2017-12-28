#!/bin/bash

# Copyright 2012-2014  Brno University of Technology (Author: Karel Vesely)
# Apache 2.0

# This example script trains a DNN on top of FBANK features.
# The training is done in 3 stages,
#
# 1) RBM pre-training:
#    in this unsupervised stage we train stack of RBMs,
#    a good starting point for frame cross-entropy trainig.
# 2) frame cross-entropy training:
#    the objective is to classify frames to correct pdfs.
# 3) sequence-training optimizing sMBR:
#    the objective is to emphasize state-sequences with better
#    frame accuracy w.r.t. reference alignment.

# Note: With DNNs in RM, the optimal LMWT is 2-6. Don't be tempted to try acwt's like 0.2,
# the value 0.1 is better both for decoding and sMBR.

. ./cmd.sh ## You'll want to change cmd.sh to something that will work on your system.
           ## This relates to the queue.

. ./path.sh ## Source the tools/utils (import the queue.pl)

dev=data-fbank/test
train=data-fbank/train
for x in clu3_r/clu0 clu3_r/clu1 clu3_r/clu2 clu5_r/clu0 clu5_r/clu1 clu5_r/clu2 clu5_r/clu3 clu5_r/clu4 clu10_r/clu0 clu10_r/clu1 clu10_r/clu2 clu10_r/clu3 clu10_r/clu4 clu10_r/clu5 clu10_r/clu6 clu10_r/clu7 clu10_r/clu8 clu10_r/clu9 clu7_r/clu0 clu7_r/clu1 clu7_r/clu2 clu7_r/clu3 clu7_r/clu4 clu7_r/clu5 clu7_r/clu6; do
devclu=data-fbank/test_$x
trainclu=data-fbank/train_$x

gmm=exp/tri3b

stage=0
. utils/parse_options.sh || exit 1;

set -euxo pipefail

# Tuned with 6x1024 Relu units,
#lrate=0.001
#lrateclu=0.0005
#param_std=0.02

# Original Relu,
if [ $stage -le 1 ]; then
  # Train the DNN optimizing per-frame cross-entropy.
  dir=exp/blstm4i
  dirclu=exp/blstm4i-${x}-half
  ali=${gmm}_ali
  # Train
#  $cuda_cmd $dir/log/train_nnet.log \
#    steps/nnet/train.sh --learn-rate $lrate \
#    --cmvn-opts "--norm-means=true --norm-vars=true" \
#    --delta-opts "--delta-order=2" --splice 5 \
#    --hid-layers 6 --hid-dim 1024 \
#    --proto-opts "--activation-type <ParametricRelu> --param-stddev-factor $param_std --hid-bias-mean 0 --hid-bias-range 0 --no-glorot-scaled-stddev --no-smaller-input-weights" \
#    ${train}_tr90 ${train}_cv10 data/lang $ali $ali $dir

  $cuda_cmd $dirclu/log/train_nnet.log \
    dnn_train.sh --network-type blstm --learn-rate 0.00002 \
      --cmvn-opts "--norm-means=true --norm-vars=true" \
      --delta-opts "--delta-order=2" --feat-type plain --splice 0 \
      --scheduler-opts "--momentum 0.9 --halving-factor 0.5" \
      --train-tool "nnet-train-multistream-perutt" \
      --train-tool-opts "--num-streams=10 --max-frames=15000" \
      --nnet_init $dir/final.nnet  \
    ${trainclu}_tr90 ${trainclu}_cv10 data/lang $ali $ali $dirclu

  # Decode (reuse HCLG graph)
  steps/nnet/decode.sh --nj 8 --cmd "$decode_cmd" --config conf/decode_dnn.config --acwt 0.1 \
    $gmm/graph $devclu $dirclu/decode
fi




echo Success
done
exit 0

# Getting results [see RESULTS file]
# for x in exp/*/decode*; do [ -d $x ] && grep WER $x/wer_* | utils/best_wer.sh; done
