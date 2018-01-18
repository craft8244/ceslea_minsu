#include "base/kaldi-common.h"
#include "util/common-utils.h"
#include "gmm/am-diag-gmm.h"
#include "ivector/ivector-extractor.h"
#include "thread/kaldi-task-sequence.h"
#include <iostream>
int main(int argc, char *argv[]) {
  using namespace kaldi;
  typedef kaldi::int32 int32;
  typedef std::string string;
  try {
    const char *usage =
	"usage: cluster_test_v2 scp:exp/ivectors_test/ivector.scp ark:exp/ivectors_train/spk_ivector.ark savefile\n";

    ParseOptions po(usage);

    po.Read(argc, argv);
    int64 num_done_utt = 0;
    int64 num_done = 0;
    if (po.NumArgs() != 3) {
      po.PrintUsage();
      exit(1);
    }
    std::string ivector_utt_rspecifier = po.GetArg(1),
         ivector_rspecifier = po.GetArg(2),
         uttscores_wxfilename = po.GetArg(3);

    std::vector<std::pair<std::string, Vector<BaseFloat>*> > ivectors_utt;
    std::vector<std::pair<std::string, Vector<BaseFloat>*> > ivectors;

    SequentialBaseFloatVectorReader ivector_utt_reader(ivector_utt_rspecifier);
    SequentialBaseFloatVectorReader ivector_reader(ivector_rspecifier);
    Output ko(uttscores_wxfilename, false);

    for (; !ivector_utt_reader.Done(); ivector_utt_reader.Next()) {
      std::string key_utt = ivector_utt_reader.Key();
      const Vector<BaseFloat> &ivector_utt = ivector_utt_reader.Value();
      num_done_utt++;
      ivectors_utt.push_back(std::make_pair(key_utt, new Vector<BaseFloat>(ivector_utt)));
    }

    for (; !ivector_reader.Done(); ivector_reader.Next()) {
      std::string key = ivector_reader.Key();
      const Vector<BaseFloat> &ivector = ivector_reader.Value();
      num_done++;
      ivectors.push_back(std::make_pair(key, new Vector<BaseFloat>(ivector)));
    }
    
    if ((num_done != 0) && (num_done_utt != 0)) {
      size_t min_j;
      for (size_t i = 0; i < ivectors_utt.size(); i++) {
        BaseFloat vecSim_max=-1;      
        Vector<BaseFloat> *ivector_utt = ivectors_utt[i].second;
        for (size_t j = 0; j< ivectors.size(); j++) {
          Vector<BaseFloat> *ivector_clu = ivectors[j].second;
          BaseFloat vecSim = VecVec(*ivector_utt, *ivector_clu);
          BaseFloat vec1_length =sqrt(VecVec(*ivector_utt, *ivector_utt));
          BaseFloat vec2_length =sqrt(VecVec(*ivector_clu, *ivector_clu));
          vecSim = vecSim/(vec1_length*vec2_length);
          if (vecSim>vecSim_max) { 
            vecSim_max=vecSim;
            min_j=j;
          }
        }
        ko.Stream() << ivectors_utt[i].first << ' ' << ivectors[min_j].first << std::endl; 
      }
    } 
  } catch(const std::exception &e) {
    std::cerr << e.what();
    return -1;
  }
}
