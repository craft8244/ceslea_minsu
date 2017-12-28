. ./cmd.sh ## You'll want to change cmd.sh to something that will work on your system.
           ## This relates to the queue.

. ./path.sh ## Source the tools/utils (import the queue.pl)
. utils/parse_options.sh || exit 1;

for x in clu0 clu1 clu2; do
#  dirclu=exp/blstm4i-clu7_nw/${x}-half
#  dirclu=exp/blstm4i
  dirclu=exp/dnn4d-6L1024-relu-fbank-clu3_r/${x}
#  dirclu=exp/dnn4d-6L1024-relu-fbank
  gmm=exp/tri3b

#  for y in clu0 clu1 clu2 clu3 clu4 clu5 clu6; do
   for y in clu0 clu1 clu2; do
    devclu=data-fbank/test_clu3_r/$y
#    steps/nnet/decode.sh --nj 5 --cmd "$decode_cmd" --config conf/decode_dnn.config --acwt 0.1 \
#      $gmm/graph $devclu $dirclu/decode_$y
    steps/nnet/decode.sh --nj 5 --cmd "$decode_cmd" --config conf/decode_dnn.config --acwt 0.1 \
      $gmm/graph $devclu $dirclu/decode_$y
  done
done
