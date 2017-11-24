#!/bin/bash

. ./cmd.sh
. ./path.sh
set -e # exit on error

trials=data/test/trials
trials_female=data/test_female/trials
trials_male=data/test_male/trials
num_components=1024


#local/rm_data_prep.sh /mnt/disk3/DB/LDC93S3A/rm_comp
#utils/prepare_lang.sh data/local/dict '!SIL' data/local/lang data/lang

#local/rm_prepare_grammar.sh      # Traditional RM grammar (bigram word-pair)
#local/rm_prepare_grammar_ug.sh   # Unigram grammar (gives worse results, but
                                 # changes in WER will be more significant.)
featdir=mfcc

#for x in test_mar87 test_oct87 test_feb89 test_oct89 test_feb91 test_sep92 train; do
 # steps/make_mfcc.sh --mfcc-config conf/mfcc.conf --nj 8 --cmd "$train_cmd" data/$x exp/make_feat/$x $featdir
 # #steps/make_plp.sh --nj 8 --cmd "$train_cmd" data/$x exp/make_feat/$x $featdir
 # steps/compute_cmvn_stats.sh data/$x exp/make_feat/$x $featdir
#done

#utils/combine_data.sh data/test data/test_{mar87,oct87,feb89,oct89,feb91,sep92}
#steps/compute_cmvn_stats.sh data/test exp/make_feat/test $featdir

#above code is original

#for x in test train; do
#sid/compute_vad_decision.sh --nj 8 --cmd "$train_cmd" \
  #data/$x exp/make_vad $featdir
#done

#utils/subset_data_dir.sh data/train 1000 data/train.1k
##utils/subset_data_dir.sh data/train 3000 data/train.3k

#sid/train_diag_ubm.sh --cmd "$train_cmd --mem 20G" \
 # --nj 8 --num-threads 4 \
 # data/train.1k $num_components \
 # exp/diag_ubm_$num_components

#sid/train_full_ubm.sh --nj 8 --remove-low-count-gaussians false \
 # --cmd "$train_cmd --mem 25G" data/train \
 # exp/diag_ubm_$num_components exp/full_ubm_$num_components

#sid/train_ivector_extractor.sh --cmd "$train_cmd --mem 35G" \
 # --ivector-dim 200 \
 # --num-iters 5 exp/full_ubm_$num_components/final.ubm data/train \
 # exp/extractor

#for x in test train; do
#	sid/extract_ivectors.sh --cmd "$train_cmd --mem 6G" --nj 8 \
# 	 exp/extractor data/$x \
# 	 exp/ivectors_$x
#done

#local/scoring_common.sh data/train data/train data/test \
#  exp/ivectors_train exp/ivectors_train exp/ivectors_test 


## Create a gender independent PLDA model and do scoring.
#local/plda_scoring.sh data/train data/train data/test \
#  exp/ivectors_train exp/ivectors_train exp/ivectors_test $trials local/scores_gmm_1024_ind_pooled
#local/plda_scoring.sh --use-existing-models true data/train data/train_female data/test_female \
#  exp/ivectors_train exp/ivectors_train_female exp/ivectors_test_female $trials_female local/scores_gmm_1024_ind_female
#local/plda_scoring.sh --use-existing-models true data/train data/train_male data/test_male \
#  exp/ivectors_train exp/ivectors_train_male exp/ivectors_test_male $trials_male local/scores_gmm_1024_ind_male

## Create gender dependent PLDA models and do scoring.
#local/plda_scoring.sh data/train_female data/train_female data/test_female \
#  exp/ivectors_train exp/ivectors_train_female exp/ivectors_test_female $trials_female local/scores_gmm_1024_dep_female
#local/plda_scoring.sh data/train_male data/train_male data/test_male \
#  exp/ivectors_train exp/ivectors_train_male exp/ivectors_test_male $trials_male local/scores_gmm_1024_dep_male

#mkdir -p local/scores_gmm_1024_dep_pooled
#cat local/scores_gmm_1024_dep_male/plda_scores local/scores_gmm_1024_dep_female/plda_scores \
#  > local/scores_gmm_1024_dep_pooled/plda_scores

# GMM-2048 PLDA EER
# ind pooled: 2.26
# ind female: 2.33
# ind male:   2.05
# dep female: 2.30
# dep male:   1.59
# dep pooled: 2.00

ivector-compute-dot-products trials_spktospk ark:exp/ivectors_test/spk_ivector.ark ark:exp/ivectors_test/spk_ivector.ark trials.scored
exit 0

#echo "GMM-$num_components EER"
#for x in ind dep; do
#  for y in female male pooled; do
#    python local/prepare_for_eer_forPY.py $trials local/scores_gmm_${num_components}_${x}_${y}/plda_scores
#    eer=`python computeEER.py resultfile`
#    echo "${x} ${y}: $eer"
#  done
#done

#echo "GMM-$num_components EER"
#for x in ind dep; do
#  for y in female male pooled; do
#    eer=`compute-eer <(python local/prepare_for_eer.py $trials local/scores_gmm_${num_components}_${x}_${y}/plda_scores) 2>&1`
#    echo "${x} ${y}: $eer"
#  done
#done

#python local/prepare_for_eer.py data/test/trials local/scores_gmm_1024_ind_female/plda_scores
#exit 0
#eer=`compute-eer <'python local/prepare_for_eer.py data/test/trials local/scores_gmm_1024_ind_female/plda_scores' 2> /devnull`
#echo "ind female: $eer"

exit 0

