#include "base/kaldi-common.h"
#include "util/common-utils.h"
#include "gmm/am-diag-gmm.h"
#include "ivector/ivector-extractor.h"
#include "thread/kaldi-task-sequence.h"
int main(int argc, char *argv[]) {
  using namespace kaldi;
  typedef kaldi::int32 int32;
  typedef std::string string;
  try {
    const char *usage =
	"usage: online_recog_v1 ark:exp/test/spk_ivector.ark savefile\n";

    ParseOptions po(usage);
    BaseFloat clusternum = 10;
    po.Register("clusternum", &clusternum, "cluter number");

    po.Read(argc, argv);
    int64 num_done = 0;
    if (po.NumArgs() != 2) {
      po.PrintUsage();
      exit(1);
    }
    std::string ivector_rspecifier = po.GetArg(1),
        ivector_wspecifier = po.GetArg(2);
    

    std::vector<std::pair<std::string, Vector<BaseFloat>*> > ivectors;

    SequentialBaseFloatVectorReader ivector_reader(ivector_rspecifier);
    BaseFloatVectorWriter ivector_writer(ivector_wspecifier);
    
    int32 num = 1;
    int32 mergenum = 1;
    for (; !ivector_reader.Done(); ivector_reader.Next()) {
      std::string key = ivector_reader.Key();
      const Vector<BaseFloat> &ivector = ivector_reader.Value();
      num_done++;
      ivectors.push_back(std::make_pair(key, new Vector<BaseFloat>(ivector)));
    }
    if (num_done != 0) {
      string minkey1;
      string minkey2;
     
      for (size_t k = 0; k >= clusternum; k++){
        BaseFloat vecSim_max=-1;

        for (size_t i = 0; i < ivectors.size(); i++) {
          std::string key1 = ivectors[i].first;
          Vector<BaseFloat> *ivector1 = ivectors[i].second;
          for (size_t j = num; j< ivectors.size(); j++) {
            std::string key2 = ivectors[j].first;
            Vector<BaseFloat> *ivector2 = ivectors[j].second;
            BaseFloat vecSim = VecVec(*ivector1, *ivector2);
            BaseFloat vec1_length =sqrt(VecVec(*ivector1, *ivector1));
            BaseFloat vec2_length =sqrt(VecVec(*ivector2, *ivector2));
            vecSim = vecSim/(vec1_length*vec2_length);
	    if (vecSim>vecSim_max) { 
	      vecSim_max=vecSim;
	      minkey1 = key1;
              minkey2 = key2;
	    }
          }
  	  num++;
        }
      
      }

    } 
  } catch(const std::exception &e) {
    std::cerr << e.what();
    return -1;
  }
}
