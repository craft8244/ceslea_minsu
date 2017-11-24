
import sys

utt2spk = open("data/test/spk2gender",'r').readlines()

trials = open("trials_spktospk", 'w')

spkrlist = list()
genderlist= list()

for line in utt2spk:
 spkr, gender = line.strip().split()
 spkrlist.extend([spkr])
 genderlist.extend([gender])
num = 1
for x in range(len(spkrlist)):
  for a in range(num,len(spkrlist)):
   data = spkrlist[x]+' '+spkrlist[a]
   data = data+'\n'
   trials.write(data)
  num = num + 1

trials.close()
