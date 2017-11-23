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
	"usage: cluster_v1 --clusternum=10 ark:exp/test/spk_ivector.ark savefile\n";

    ParseOptions po(usage);
    int32 clusternum = 5;
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
    for (; !ivector_reader.Done(); ivector_reader.Next()) {
      std::string key = ivector_reader.Key();
      const Vector<BaseFloat> &ivector = ivector_reader.Value();
      num_done++;
      ivectors.push_back(std::make_pair(key, new Vector<BaseFloat>(ivector)));
    }
    
   // std::vector<std::pair<std::string, Vector<BaseFloat>*> > ivectors_clu;
    std::vector<double> spk_num(ivectors.size(),1);
    if (num_done != 0) {
      while (ivectors.size()!=clusternum){        
        size_t min_i;
        size_t min_j;
        std::vector<std::tuple<BaseFloat, size_t, size_t>> max_loc;
        int32 num = 1;
        for (size_t i = 0; i < ivectors.size(); i++) {
          Vector<BaseFloat> *ivector1 = ivectors[i].second;
          for (size_t j = num; j< ivectors.size(); j++) {
            Vector<BaseFloat> *ivector2 = ivectors[j].second;
            BaseFloat vecSim = VecVec(*ivector1, *ivector2);
            BaseFloat vec1_length =sqrt(VecVec(*ivector1, *ivector1));
            BaseFloat vec2_length =sqrt(VecVec(*ivector2, *ivector2));
            vecSim = vecSim/(vec1_length*vec2_length);
            max_loc.push_back(std::make_tuple(vecSim,i,j));
          }
          num++;
        }
        while (1){
          std::sort(max_loc.begin(), max_loc.end());
          min_i = std::get<1>(*(max_loc.end()-1));
          min_j = std::get<2>(*(max_loc.end()-1));
          std::cout<<spk_num[min_i]<<' '<<spk_num[min_j]<< "\n";
          if ((spk_num[min_i]>(109/clusternum))||(spk_num[min_j]>(109/clusternum))){
            max_loc.erase(max_loc.end()-1);
          }
          else {
            break;
          }
        }
        std::cout << ivectors.size()<< ' ' << std::get<0>(*(max_loc.end())) << ' ' << ivectors[min_i].first << ' ' << ivectors[min_j].first <<' ' << min_i << ' ' << min_j<<' '<<spk_num[min_i]<<' '<<spk_num[min_j]<< "\n";
        Vector<BaseFloat> ivector_clu = *ivectors[min_i].second;
        ivector_clu.AddVec(-1.0, *ivectors[min_i].second);
        ivector_clu.AddVec(spk_num[min_i]/(spk_num[min_i]+spk_num[min_j]), *ivectors[min_i].second);
        ivector_clu.AddVec(spk_num[min_j]/(spk_num[min_i]+spk_num[min_j]), *ivectors[min_j].second);
        std::string new_key = ivectors[min_i].first+"."+ivectors[min_j].first;
        ivectors.push_back(std::make_pair(new_key, new Vector<BaseFloat>(ivector_clu)));
        spk_num.push_back(spk_num[min_i]+spk_num[min_j]);
        ivectors.erase(ivectors.begin()+min_i);    
        spk_num.erase(spk_num.begin()+min_i);
        if (min_i > min_j) {
          ivectors.erase(ivectors.begin()+min_j);
          spk_num.erase(spk_num.begin()+min_j);
        }
        else {
          ivectors.erase(ivectors.begin()+min_j-1);
          spk_num.erase(spk_num.begin()+min_j-1);
        }
      }
      for (size_t m = 0; m < ivectors.size(); m++){
        std::string writekey = ivectors[m].first;
        std::cout << ivectors[m].first << "\n";
        Vector<BaseFloat> *writeivector = ivectors[m].second;
//        std::cout << *writeivector << "\n";
        ivector_writer.Write(writekey, *writeivector);
      }
    } 
  } catch(const std::exception &e) {
    std::cerr << e.what();
    return -1;
  }
}
