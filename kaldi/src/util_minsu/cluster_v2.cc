#include "base/kaldi-common.h"
#include "util/common-utils.h"
#include "gmm/am-diag-gmm.h"
#include "ivector/ivector-extractor.h"
#include "thread/kaldi-task-sequence.h"
#include <iostream>
//v2: make cluster to use min clustering
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
         spkscores_wxfilename = po.GetArg(2);

    std::vector<std::pair<std::string, Vector<BaseFloat>*> > ivectors;
    Output ko(spkscores_wxfilename, false);

    SequentialBaseFloatVectorReader ivector_reader(ivector_rspecifier);
    for (; !ivector_reader.Done(); ivector_reader.Next()) {
      std::string key = ivector_reader.Key();
      const Vector<BaseFloat> &ivector = ivector_reader.Value();
      num_done++;
      ivectors.push_back(std::make_pair(key, new Vector<BaseFloat>(ivector)));
    }
    std::vector<std::pair<std::string, Vector<BaseFloat>*> > ori_ivectors;
    ori_ivectors=ivectors;

   // std::vector<std::pair<std::string, Vector<BaseFloat>*> > ivectors_clu;
    std::vector<double> spk_num(ivectors.size(),1);
    std::vector<std::vector<size_t> > clu_ivec;
    if (num_done != 0) {
      size_t min_i;
      size_t min_j;
      size_t clu_i;
      size_t clu_j;
      std::vector<size_t> new_ivec;
//      string key_clu = "clu";

      while (ivectors.size()!=clusternum){        
        BaseFloat vecSim_max=-1;      
        int32 num = 1;
        for (size_t i = 0; i < ivectors.size(); i++) {
          for (size_t j = num; j< ivectors.size(); j++) {
            if (ivectors[i].first.compare(ivectors[j].first)!=0){
              Vector<BaseFloat> *ivector1 = ivectors[i].second;
              Vector<BaseFloat> *ivector2 = ivectors[j].second;
              BaseFloat vecSim = VecVec(*ivector1, *ivector2);
              BaseFloat vec1_length =sqrt(VecVec(*ivector1, *ivector1));
              BaseFloat vec2_length =sqrt(VecVec(*ivector2, *ivector2));
              BaseFloat mer_cost = (spk_num[i]+spk_num[j])/(spk_num[i]*spk_num[j]);
              vecSim = mer_cost*(vecSim/(vec1_length*vec2_length)+1);
	      if (vecSim>vecSim_max) { 
	        vecSim_max=vecSim;
                min_i=i;
                min_j=j;
	      }
            }
          }
          num++;
        }
        std::cout << ivectors.size()<< ' ' << vecSim_max << ' ' << ivectors[min_i].first << ' ' << ivectors[min_j].first <<' ' << min_i << ' ' << min_j<< "\n";
//        if (ivectors[min_i].first.substr(0,3)==key_clu and ivectors[min_j].first.substr(0,3)==key_clu)

        if (ivectors[min_j].first.length()>ivectors[min_i].first.length()){
          size_t temp=min_i;
          min_i=min_j;
          min_j=temp;
        }
        std::string new_key = ivectors[min_i].first+"."+ivectors[min_j].first;
        double new_spk_num = spk_num[min_i]+spk_num[min_j];
        if (ivectors[min_i].first.length()!=4){
          for (size_t i = 0; i < clu_ivec.size(); i++) {
            if (std::find(clu_ivec[i].begin(), clu_ivec[i].end(), min_i) != clu_ivec[i].end() ){
                clu_i=i;
            }
          }
          if (ivectors[min_j].first.length()!=4){
            for (size_t i = 0; i < clu_ivec.size(); i++) {
              if (std::find(clu_ivec[i].begin(), clu_ivec[i].end(), min_j) != clu_ivec[i].end() ){
                clu_j=i;
              }          
            }
            //clu_ivec[clu_i]에 clu_ivec[clu_j]를 병합
            clu_ivec[clu_i].insert( clu_ivec[clu_i].end(), clu_ivec[clu_j].begin(), clu_ivec[clu_j].end() );
            //clu_ivec[clu_j]를 삭제
            clu_ivec.erase(clu_ivec.begin()+clu_j);
          }
          else{
            //clu_ivec[clu_i]에min_j값 추가
	    clu_ivec[clu_i].push_back(min_j); 
          }
          //clu_ivec[clu_i]에 있는 인자들의 ivectors[i].first에 이름들 new_key로 수정
          //    ''         에 있는 인자들의 spk_num[i]값 수정
          for (size_t i=0; i < clu_ivec[clu_i].size(); i++) {
            ivectors[clu_ivec[clu_i][i]].first=new_key;
            spk_num[clu_ivec[clu_i][i]]=new_spk_num;
          }
        }
        else{
          new_ivec.push_back(min_i);
          new_ivec.push_back(min_j);
          clu_ivec.push_back(new_ivec);
          new_ivec.clear();
          ivectors[min_i].first = new_key;
          ivectors[min_j].first = new_key;
          spk_num[min_i]=new_spk_num;
	  spk_num[min_j]=new_spk_num;
        }

      }
      for (size_t m = 0; m < ivectors.size(); m++){
        for (size_t n = 0; n < clu_ivec.size(); n++){
          if (std::find(clu_ivec[n].begin(), clu_ivec[n].end(), m) != clu_ivec[n].end() ){
            ko.Stream() << ori_ivectors[m].first << ' ' << n << std::endl;
          }
        }
      }
    } 
  } catch(const std::exception &e) {
    std::cerr << e.what();
    return -1;
  }
}
