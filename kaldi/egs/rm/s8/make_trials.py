
import sys

utt2spk = open("data/test/utt2spk",'r').readlines()

trials = open("trials", 'w')

spkrlist = list()
uttlist= list()

for line in utt2spk:
 utt, spkr = line.strip().split()
 spkrlist.extend([spkr])
 uttlist.extend([utt])

for x in range(len(spkrlist)-1):
 if spkrlist[x]!=spkrlist[x+1]:
  for a in range(len(uttlist)):
   data = spkrlist[x]+' '+uttlist[a]
   if spkrlist[x]==uttlist[a][0:4]:
    data = data+' target'
   else:
    data = data+' nontarget'
   data = data+'\n'
   trials.write(data)
 if x==len(spkrlist)-2:
  for a in range(len(uttlist)):
   data = spkrlist[x]+' '+uttlist[a]
   if spkrlist[x]==uttlist[a][0:4]:
    data = data+' target'
   else:
    data = data+' nontarget'
   data = data+'\n'
   trials.write(data)


trials.close()
