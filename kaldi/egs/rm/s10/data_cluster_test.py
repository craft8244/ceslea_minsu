import sys

utt2spk=open(sys.argv[2]+'/utt2spk', 'r').readlines()
spk2gender=open(sys.argv[2]+'/spk2gender', 'r').readlines()
cmvn=open(sys.argv[1]+'/cmvn.scp', 'r').readlines()
feats=open(sys.argv[1]+'/feats.scp', 'r').readlines()
spklist = list()
uttlist=list()

for line in spk2gender:
 spkr = line[0:4]
 if spkr not in spklist:
  spklist.append(spkr)

for line in utt2spk:
 utt, _ = line.split()
 if utt not in uttlist:
  uttlist.append(utt)

cmvnW=open(sys.argv[2]+'/cmvn.scp', 'w')
for line in cmvn:
 spkr = line[0:4]
 if spkr in spklist:
   cmvnW.write(line)
cmvnW.close()

featsW=open(sys.argv[2]+'/feats.scp', 'w')
for line in feats:
 utt, _ = line.split()
 if utt in uttlist:
  featsW.write(line)
featsW.close()

