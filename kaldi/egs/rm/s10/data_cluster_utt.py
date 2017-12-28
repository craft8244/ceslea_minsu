import sys

spk2gender=open(sys.argv[1]+'/spk2gender', 'r').readlines()
text=open(sys.argv[1]+'/text', 'r').readlines()
utt2spk=open(sys.argv[1]+'/utt2spk', 'r').readlines()
wavscp=open(sys.argv[1]+'/wav.scp', 'r').readlines()
cmvn=open(sys.argv[1]+'/cmvn.scp', 'r').readlines()
feats=open(sys.argv[1]+'/feats.scp', 'r').readlines()
scorelist=open(sys.argv[3], 'r').readlines()
spkrlist= list()

for i in range(0, 10):
 spkrlist.append([])
for line in scorelist:
 utt, num = line.split()
 save_dir = sys.argv[2] + num
 spkr = utt[0:4]
 numint=int(num)

 spk2genderW=open(save_dir+'/spk2gender', 'a')
 for line in spk2gender:
  if spkr == line[0:4]:
   if spkr not in spkrlist[numint]:   
    spk2genderW.write(line)
 spk2genderW.close()

 cmvnW=open(save_dir+'/cmvn.scp', 'a')
 for line in cmvn:
  if spkr == line[0:4]:
   if spkr not in spkrlist[numint]:
    cmvnW.write(line)
    spkrlist[numint].append(spkr)
 cmvnW.close() 

 textW=open(save_dir+'/text', 'a')
 for line in text:
  uttT, _ = line.split(' ', 1)
  if utt == uttT:
   textW.write(line)
 textW.close()

 featsW=open(save_dir+'/feats.scp', 'a')
 for line in feats:
  uttY, _ = line.split(' ', 1)
  if utt == uttY:
   featsW.write(line)
 featsW.close()

 utt2spkW=open(save_dir+'/utt2spk', 'a')
 for line in utt2spk:
  uttW, _ = line.split()
  if utt == uttW:
   utt2spkW.write(line)
 utt2spkW.close()

 wavscpW=open(save_dir+'/wav.scp', 'a')
 for line in wavscp:
  uttX, _ = line.split(' ', 1)
  if utt == uttX:
   wavscpW.write(line)
 wavscpW.close()
