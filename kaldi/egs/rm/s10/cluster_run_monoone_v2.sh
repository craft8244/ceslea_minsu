#!/bin/bash

. ./cmd.sh
set -e # exit on error


# call the next line with the directory where the RM data is
# (the argument below is just an example).  This should contain
# subdirectories named as follows:
#    rm1_audio1  rm1_audio2	rm2_audio


# mfccdir should be some place with a largish disk where you
# want to store MFCC features.   You can make a soft link if you want.
featdir=mfcc

#for x in train_clu0 train_clu1 train_clu2; do
#  steps/make_mfcc.sh --nj 8 --cmd "$train_cmd" data/train_clu3/$x exp/make_feat/train_clu3/$x $featdir/train_clu3/$x
#  steps/compute_cmvn_stats.sh data/train_clu3/$x exp/make_feat/train_clu3/$x $featdir/train_clu3/$x
#  steps/make_mfcc.sh --nj 8 --cmd "$train_cmd" data/train_clu5/$x exp/make_feat/train_clu5/$x $featdir/train_clu5/$x
#  steps/compute_cmvn_stats.sh data/train_clu5/$x exp/make_feat/train_clu5/$x $featdir/train_clu5/$x
#  steps/make_mfcc.sh --nj 8 --cmd "$train_cmd" data/train_clu10/$x exp/make_feat/train_clu10/$x $featdir/train_clu10/$x
#  steps/compute_cmvn_stats.sh data/train_clu10/$x exp/make_feat/train_clu10/$x $featdir/train_clu10/$x
#done
#
#for x in train_clu3 train_clu4; do
#  steps/make_mfcc.sh --nj 8 --cmd "$train_cmd" data/train_clu5/$x exp/make_feat/train_clu5/$x $featdir/train_clu5/$x
#  steps/compute_cmvn_stats.sh data/train_clu5/$x exp/make_feat/train_clu5/$x $featdir/train_clu5/$x
#  steps/make_mfcc.sh --nj 8 --cmd "$train_cmd" data/train_clu10/$x exp/make_feat/train_clu10/$x $featdir/train_clu10/$x
#  steps/compute_cmvn_stats.sh data/train_clu10/$x exp/make_feat/train_clu10/$x $featdir/train_clu10/$x
#done
#
#for x in train_clu5 train_clu6 train_clu7 train_clu8 train_clu9; do
#  steps/make_mfcc.sh --nj 8 --cmd "$train_cmd" data/train_clu10/$x exp/make_feat/train_clu10/$x $featdir/train_clu10/$x
#  steps/compute_cmvn_stats.sh data/train_clu10/$x exp/make_feat/train_clu10/$x $featdir/train_clu10/$x
#done
#
#for x in test_clu0 test_clu1 test_clu2; do
#  steps/make_mfcc.sh --nj 8 --cmd "$train_cmd" data/test_clu3/$x exp/make_feat/test_clu3/$x $featdir/train_clu3/$x
#  steps/compute_cmvn_stats.sh data/test_clu3/$x exp/make_feat/test_clu3/$x $featdir/train_clu3/$x
#  steps/make_mfcc.sh --nj 8 --cmd "$train_cmd" data/test_clu5/$x exp/make_feat/test_clu5/$x $featdir/train_clu5/$x
#  steps/compute_cmvn_stats.sh data/test_clu5/$x exp/make_feat/test_clu5/$x $featdir/train_clu5/$x
#  steps/make_mfcc.sh --nj 8 --cmd "$train_cmd" data/test_clu10/$x exp/make_feat/test_clu10/$x $featdir/train_clu10/$x
#  steps/compute_cmvn_stats.sh data/test_clu10/$x exp/make_feat/test_clu10/$x $featdir/train_clu10/$x
#done
#
#for x in test_clu3 test_clu4; do
#  steps/make_mfcc.sh --nj 8 --cmd "$train_cmd" data/test_clu5/$x exp/make_feat/test_clu5/$x $featdir/train_clu5/$x
#  steps/compute_cmvn_stats.sh data/test_clu5/$x exp/make_feat/test_clu5/$x $featdir/train_clu5/$x
#  steps/make_mfcc.sh --nj 8 --cmd "$train_cmd" data/test_clu10/$x exp/make_feat/test_clu10/$x $featdir/train_clu10/$x
#  steps/compute_cmvn_stats.sh data/test_clu10/$x exp/make_feat/test_clu10/$x $featdir/train_clu10/$x
#done
#
#for x in test_clu5 test_clu6 test_clu7 test_clu8 test_clu9; do
#  steps/make_mfcc.sh --nj 8 --cmd "$train_cmd" data/test_clu10/$x exp/make_feat/test_clu10/$x $featdir/train_clu10/$x
#  steps/compute_cmvn_stats.sh data/test_clu10/$x exp/make_feat/test_clu10/$x $featdir/train_clu10/$x
#done

#utils/subset_data_dir.sh data/train 1000 data/train.1k
for y in _r _nw; do
for x in 0 1 2; do
 # train tri1 [first triphone pass]
 local/train_deltas_v2.sh --cmd "$train_cmd" --tot_num_iters 105 --max_iter_inc 70 \
  1800 9000 data/train data/lang exp/mono_ali_one exp/tri1_clu3${y}_monoone_v2/clu$x data/train_clu3${y}/clu$x
 utils/mkgraph.sh data/lang exp/tri1_clu3${y}_monoone_v2/clu$x exp/tri1_clu3${y}_monoone_v2/clu$x/graph
 steps/decode.sh --config conf/decode.config --nj 8 --cmd "$decode_cmd" \
   exp/tri1_clu3${y}_monoone_v2/clu$x/graph data/test_clu3${y}/clu$x exp/tri1_clu3${y}_monoone_v2/clu$x/decode

 # align tri1
# steps/align_si.sh --nj 1 --cmd "$train_cmd" \
#   --use-graphs true data/train_clu3/train_clu$x data/lang exp/tri1_clu3_monoone/tri1_clu$x exp/tri1_ali_clu3_monoone/tri1_clu$x
done
done
exit 0
for x in 0 1 2 3 4; do
 # train tri1 [first triphone pass]
 steps/train_deltas.sh --cmd "$train_cmd" \
  1800 9000 data/train_clu5/train_clu$x data/lang exp/mono_ali_one exp/tri1_clu5_monoone/tri1_clu$x
 utils/mkgraph.sh data/lang exp/tri1_clu5_monoone/tri1_clu$x exp/tri1_clu5_monoone/tri1_clu$x/graph
 steps/decode.sh --config conf/decode.config --nj 20 --cmd "$decode_cmd" \
   exp/tri1_clu5_monoone/tri1_clu$x/graph data/test_clu5/test_clu$x exp/tri1_clu5_monoone/tri1_clu$x/decode

 # align tri1
 steps/align_si.sh --nj 1 --cmd "$train_cmd" \
   --use-graphs true data/train_clu5/train_clu$x data/lang exp/tri1_clu5_monoone/tri1_clu$x exp/tri1_ali_clu5_monoone/tri1_clu$x
done

for x in 0 1 2 3 4 5 6 7 8 9; do
 # train tri1 [first triphone pass]
 steps/train_deltas.sh --cmd "$train_cmd" \
  1800 9000 data/train_clu10/train_clu$x data/lang exp/mono_ali_one exp/tri1_clu10_monoone/tri1_clu$x
 utils/mkgraph.sh data/lang exp/tri1_clu10_monoone/tri1_clu$x exp/tri1_clu10_monoone/tri1_clu$x/graph
 steps/decode.sh --config conf/decode.config --nj 4 --cmd "$decode_cmd" \
   exp/tri1_clu10_monoone/tri1_clu$x/graph data/test_clu10/test_clu$x exp/tri1_clu10_monoone/tri1_clu$x/decode

 # align tri1
 steps/align_si.sh --nj 1 --cmd "$train_cmd" \
   --use-graphs true data/train_clu10/train_clu$x data/lang exp/tri1_clu10_monoone/tri1_clu$x exp/tri1_ali_clu10_monoone/tri1_clu$x
done
exit 0
# the tri2a experiments are not needed downstream, so commenting them out.
# # train tri2a [delta+delta-deltas]
# steps/train_deltas.sh --cmd "$train_cmd" 1800 9000 \
#  data/train data/lang exp/tri1_ali exp/tri2a

# # decode tri2a
# utils/mkgraph.sh data/lang exp/tri2a exp/tri2a/graph
# steps/decode.sh --config conf/decode.config --nj 20 --cmd "$decode_cmd" \
#   exp/tri2a/graph data/test exp/tri2a/decode

# train and decode tri2b [LDA+MLLT]
steps/train_lda_mllt.sh --cmd "$train_cmd" \
  --splice-opts "--left-context=3 --right-context=3" \
 1800 9000 data/train data/lang exp/tri1_ali exp/tri2b
utils/mkgraph.sh data/lang exp/tri2b exp/tri2b/graph

steps/decode.sh --config conf/decode.config --nj 20 --cmd "$decode_cmd" \
   exp/tri2b/graph data/test exp/tri2b/decode

# you could run these scripts at this point, that use VTLN.
# local/run_vtln.sh
# local/run_vtln2.sh

# Align all data with LDA+MLLT system (tri2b)
steps/align_si.sh --nj 8 --cmd "$train_cmd" --use-graphs true \
   data/train data/lang exp/tri2b exp/tri2b_ali

#  Do MMI on top of LDA+MLLT.
steps/make_denlats.sh --nj 8 --cmd "$train_cmd" \
  data/train data/lang exp/tri2b exp/tri2b_denlats
steps/train_mmi.sh data/train data/lang exp/tri2b_ali exp/tri2b_denlats exp/tri2b_mmi
steps/decode.sh --config conf/decode.config --iter 4 --nj 20 --cmd "$decode_cmd" \
   exp/tri2b/graph data/test exp/tri2b_mmi/decode_it4
steps/decode.sh --config conf/decode.config --iter 3 --nj 20 --cmd "$decode_cmd" \
   exp/tri2b/graph data/test exp/tri2b_mmi/decode_it3

# Do the same with boosting.
steps/train_mmi.sh --boost 0.05 data/train data/lang \
   exp/tri2b_ali exp/tri2b_denlats exp/tri2b_mmi_b0.05
steps/decode.sh --config conf/decode.config --iter 4 --nj 20 --cmd "$decode_cmd" \
   exp/tri2b/graph data/test exp/tri2b_mmi_b0.05/decode_it4
steps/decode.sh --config conf/decode.config --iter 3 --nj 20 --cmd "$decode_cmd" \
   exp/tri2b/graph data/test exp/tri2b_mmi_b0.05/decode_it3

# Do MPE.
steps/train_mpe.sh data/train data/lang exp/tri2b_ali exp/tri2b_denlats exp/tri2b_mpe
steps/decode.sh --config conf/decode.config --iter 4 --nj 20 --cmd "$decode_cmd" \
   exp/tri2b/graph data/test exp/tri2b_mpe/decode_it4
steps/decode.sh --config conf/decode.config --iter 3 --nj 20 --cmd "$decode_cmd" \
   exp/tri2b/graph data/test exp/tri2b_mpe/decode_it3


## Do LDA+MLLT+SAT, and decode.
steps/train_sat.sh 1800 9000 data/train data/lang exp/tri2b_ali exp/tri3b
utils/mkgraph.sh data/lang exp/tri3b exp/tri3b/graph
steps/decode_fmllr.sh --config conf/decode.config --nj 20 --cmd "$decode_cmd" \
  exp/tri3b/graph data/test exp/tri3b/decode

(
 utils/mkgraph.sh data/lang_ug exp/tri3b exp/tri3b/graph_ug
 steps/decode_fmllr.sh --config conf/decode.config --nj 20 --cmd "$decode_cmd" \
   exp/tri3b/graph_ug data/test exp/tri3b/decode_ug
)


# Align all data with LDA+MLLT+SAT system (tri3b)
steps/align_fmllr.sh --nj 8 --cmd "$train_cmd" --use-graphs true \
  data/train data/lang exp/tri3b exp/tri3b_ali


# # We have now added a script that will help you find portions of your data that
# # has bad transcripts, so you can filter it out.  Below we demonstrate how to
# # run this script.
# steps/cleanup/find_bad_utts.sh --nj 20 --cmd "$train_cmd" data/train data/lang \
#   exp/tri3b_ali exp/tri3b_cleanup
# # The following command will show you some of the hardest-to-align utterances in the data.
# head  exp/tri3b_cleanup/all_info.sorted.txt

## MMI on top of tri3b (i.e. LDA+MLLT+SAT+MMI)
steps/make_denlats.sh --config conf/decode.config \
   --nj 8 --cmd "$train_cmd" --transform-dir exp/tri3b_ali \
  data/train data/lang exp/tri3b exp/tri3b_denlats
steps/train_mmi.sh data/train data/lang exp/tri3b_ali exp/tri3b_denlats exp/tri3b_mmi

steps/decode_fmllr.sh --config conf/decode.config --nj 20 --cmd "$decode_cmd" \
  --alignment-model exp/tri3b/final.alimdl --adapt-model exp/tri3b/final.mdl \
   exp/tri3b/graph data/test exp/tri3b_mmi/decode

# Do a decoding that uses the exp/tri3b/decode directory to get transforms from.
steps/decode.sh --config conf/decode.config --nj 20 --cmd "$decode_cmd" \
  --transform-dir exp/tri3b/decode  exp/tri3b/graph data/test exp/tri3b_mmi/decode2

# demonstration scripts for online decoding.
# local/online/run_gmm.sh
# local/online/run_nnet2.sh
# local/online/run_baseline.sh
# Note: for online decoding with pitch, look at local/run_pitch.sh,
# which calls local/online/run_gmm_pitch.sh

#
# local/online/run_nnet2_multisplice.sh
# local/online/run_nnet2_multisplice_disc.sh

# ##some older scripts:
# # local/run_nnet2.sh
# # local/online/run_nnet2_baseline.sh

# ## if you have a WSJ setup, you can use the following script to do joint
# ## RM/WSJ training; this doesn't require that the phone set be the same, it's
# ## a demonstration of a multilingual script.
# local/online/run_nnet2_wsj_joint.sh
# ## and the discriminative-training continuation of the above.
# local/online/run_nnet2_wsj_joint_disc.sh

# ## The following is an older way to do multilingual training, from an
# ## already-trained system.
# #local/online/run_nnet2_wsj.sh



#first, train UBM for fMMI experiments.
steps/train_diag_ubm.sh --silence-weight 0.5 --nj 8 --cmd "$train_cmd" \
  250 data/train data/lang exp/tri3b_ali exp/dubm3b

# Next, various fMMI+MMI configurations.
steps/train_mmi_fmmi.sh --learning-rate 0.0025 \
  --boost 0.1 --cmd "$train_cmd" data/train data/lang exp/tri3b_ali exp/dubm3b exp/tri3b_denlats \
  exp/tri3b_fmmi_b

for iter in 3 4 5 6 7 8; do
 steps/decode_fmmi.sh --nj 20 --config conf/decode.config --cmd "$decode_cmd" --iter $iter \
   --transform-dir exp/tri3b/decode  exp/tri3b/graph data/test exp/tri3b_fmmi_b/decode_it$iter &
done

steps/train_mmi_fmmi.sh --learning-rate 0.001 \
  --boost 0.1 --cmd "$train_cmd" data/train data/lang exp/tri3b_ali exp/dubm3b exp/tri3b_denlats \
  exp/tri3b_fmmi_c

for iter in 3 4 5 6 7 8; do
 steps/decode_fmmi.sh --nj 20 --config conf/decode.config --cmd "$decode_cmd" --iter $iter \
   --transform-dir exp/tri3b/decode  exp/tri3b/graph data/test exp/tri3b_fmmi_c/decode_it$iter &
done

# for indirect one, use twice the learning rate.
steps/train_mmi_fmmi_indirect.sh --learning-rate 0.01 --schedule "fmmi fmmi fmmi fmmi mmi mmi mmi mmi" \
  --boost 0.1 --cmd "$train_cmd" data/train data/lang exp/tri3b_ali exp/dubm3b exp/tri3b_denlats \
  exp/tri3b_fmmi_d

for iter in 3 4 5 6 7 8; do
 steps/decode_fmmi.sh --nj 20 --config conf/decode.config --cmd "$decode_cmd" --iter $iter \
   --transform-dir exp/tri3b/decode  exp/tri3b/graph data/test exp/tri3b_fmmi_d/decode_it$iter &
done

# Demo of "raw fMLLR"
# local/run_raw_fmllr.sh


# You don't have to run all 2 of the below, e.g. you can just run the run_sgmm2.sh
local/run_sgmm2.sh
#local/run_sgmm2x.sh

# The following script depends on local/run_raw_fmllr.sh having been run.
#
# local/run_nnet2.sh

# Karel's neural net recipe.
# local/nnet/run_dnn.sh

# Karel's CNN recipe.
# local/nnet/run_cnn.sh

# Karel's 2D-CNN recipe (from Harish).
# local/nnet/run_cnn2d.sh

# chain recipe
# local/chain/run_tdnn_5f.sh
