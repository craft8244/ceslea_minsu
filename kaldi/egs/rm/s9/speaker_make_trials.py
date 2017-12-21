
import sys

utt2spk = open("data/test/spk2gender",'r').readlines()

trials = open("data/test/speaker_trials", 'w')

spkrlist = list()

for line in utt2spk:
 spkr, _ = line.strip().split()
 spkrlist.extend([spkr])

for x in range(len(spkrlist)-1):
  for y in range(x+1,len(spkrlist)):
    data= spkrlist[x] + " " + spkrlist[y]
    if y != len(spkrlist)+1:
      data = data+'\n'
    trials.write(data)

trials.close()
