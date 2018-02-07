import sys
import os

spk2gender=open(sys.argv[1]+'/spk2gender', 'r').readlines()
text=open(sys.argv[1]+'/text', 'r').readlines()
utt2spk=open(sys.argv[1]+'/utt2spk', 'r').readlines()
wavscp=open(sys.argv[1]+'/wav.scp', 'r').readlines()
cmvn=open(sys.argv[1]+'/cmvn.scp', 'r').readlines()
feats=open(sys.argv[1]+'/feats.scp', 'r').readlines()

if not os.path.exists(sys.argv[2]):
 os.mkdir(sys.argv[2])
uttlist=open(sys.argv[3], 'r').readlines()
utt_list=list()
clu_list=list()

for line in uttlist:
 tar_utt, clu_num= line.strip().split()
 utt_list.append(tar_utt)
 clu_list.append(clu_num)

for line in spk2gender:
 spkr, _ = line.strip().split()
 dir_spk2gender=sys.argv[2]+'/clu'+clu_list[spk_list.index(spkr)]
 if not os.path.exists(dir_spk2gender):
  os.mkdir(dir_spk2gender)
 spk2genderW=open(dir_spk2gender+'/spk2gender', 'a') 
 spk2genderW.write(line)
 spk2genderW.close()

for line in cmvn:
 spkr = line[0:4]
 cmvnW=open(sys.argv[2]+'/clu'+clu_list[spk_list.index(spkr)]+'/cmvn.scp', 'a')
 cmvnW.write(line)
 cmvnW.close()

for line in text:
 utt= line[0:18]
 textW=open(sys.argv[2]+'/clu'+clu_list[utt_list.index(utt)]+'/text', 'a')
 textW.write(line)
 textW.close()

for line in utt2spk:
 utt= line[0:18]
 utt2spkW=open(sys.argv[2]+'/clu'+clu_list[utt_list.index(utt)]+'/utt2spk', 'a')
 utt2spkW.write(line)
 utt2spkW.close()

for line in feats:
 utt= line[0:18]
 featsW=open(sys.argv[2]+'/clu'+clu_list[utt_list.index(utt)]+'/feats.scp', 'a')
 featsW.write(line)
 featsW.close()

for line in wavscp:
 utt= line[0:18]
 wavscpW=open(sys.argv[2]+'/clu'+clu_list[utt_list.index(utt)]+'/wav.scp', 'a')
 wavscpW.write(line)
 wavscpW.close()

