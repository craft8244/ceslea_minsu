import sys
import os

spk2gender=open(sys.argv[1]+'/spk2gender', 'r').readlines()
text=open(sys.argv[1]+'/text', 'r').readlines()
utt2spk=open(sys.argv[1]+'/utt2spk', 'r').readlines()
wavscp=open(sys.argv[1]+'/wav.scp', 'r').readlines()
cmvn=open(sys.argv[1]+'/cmvn.scp', 'r').readlines()
feats=open(sys.argv[1]+'/feats.scp', 'r').readlines()
utt2dur=open(sys.argv[1]+'/utt2dur', 'r').readlines()
if not os.path.exists(sys.argv[2]):
 os.mkdir(sys.argv[2])
spklist=open(sys.argv[3], 'r').readlines()
spk_list=list()
clu_list=list()

for line in spklist:
 tar_spkr, clu_num= line.strip().split()
 spk_list.append(tar_spkr)
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
 spkr= line[0:4]
 textW=open(sys.argv[2]+'/clu'+clu_list[spk_list.index(spkr)]+'/text', 'a')
 textW.write(line)
 textW.close()

for line in utt2spk:
 spkr= line[0:4]
 utt2spkW=open(sys.argv[2]+'/clu'+clu_list[spk_list.index(spkr)]+'/utt2spk', 'a')
 utt2spkW.write(line)
 utt2spkW.close()

for line in feats:
 spkr= line[0:4]
 featsW=open(sys.argv[2]+'/clu'+clu_list[spk_list.index(spkr)]+'/feats.scp', 'a')
 featsW.write(line)
 featsW.close()

for line in wavscp:
 spkr= line[0:4]
 wavscpW=open(sys.argv[2]+'/clu'+clu_list[spk_list.index(spkr)]+'/wav.scp', 'a')
 wavscpW.write(line)
 wavscpW.close()

for line in utt2dur:
 spkr= line[0:4]
 utt2durW=open(sys.argv[2]+'/clu'+clu_list[spk_list.index(spkr)]+'/utt2dur', 'w')
 utt2durW.write(line)
 utt2durW.close()


