#for x in clu3_r/clu0 clu3_r/clu1 clu3_r/clu2; do
for y in clu10_r clu10_nw; do
 for x in clu0 clu1 clu2 clu3 clu4 clu5 clu6 clu7 clu8 clu9; do
#  python data_cluster_gmm.py data/train data/train_$y/$x data-fbank/train_$y/$x
  python data_cluster_gmm_test.py data/test data/test_$y/$x data-fbank/test_$y/$x
  utils/utt2spk_to_spk2utt.pl data/test_$y/$x/utt2spk > data/test_$y/$x/spk2utt
 done
done
