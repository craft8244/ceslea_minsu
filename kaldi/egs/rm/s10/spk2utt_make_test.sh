#!/bin/bash

. ./cmd.sh
. ./path.sh
set -e # exit on error


for x in clu0 clu1 clu2; do
 utils/utt2spk_to_spk2utt.pl data-fbank/test_clu3/$x/utt2spk > data-fbank/test_clu3/$x/spk2utt
 utils/utt2spk_to_spk2utt.pl data-fbank/test_clu5/$x/utt2spk > data-fbank/test_clu5/$x/spk2utt
 utils/utt2spk_to_spk2utt.pl data-fbank/test_clu10/$x/utt2spk > data-fbank/test_clu10/$x/spk2utt
done

for x in clu3 clu4; do
 utils/utt2spk_to_spk2utt.pl data-fbank/test_clu5/$x/utt2spk > data-fbank/test_clu5/$x/spk2utt
 utils/utt2spk_to_spk2utt.pl data-fbank/test_clu10/$x/utt2spk > data-fbank/test_clu10/$x/spk2utt
done

for x in clu5 clu6 clu7 clu8 clu9; do
 utils/utt2spk_to_spk2utt.pl data-fbank/test_clu10/$x/utt2spk > data-fbank/test_clu10/$x/spk2utt
done
