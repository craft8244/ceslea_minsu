import sys

spk2gender=open(sys.argv[1]+'/spk2gender', 'r').readlines()
text=open(sys.argv[1]+'/text', 'r').readlines()
utt2spk=open(sys.argv[1]+'/utt2spk', 'r').readlines()
wavscp=open(sys.argv[1]+'/wav.scp', 'r').readlines()
cmvn=open(sys.argv[1]+'/cmvn.scp', 'r').readlines()
feats=open(sys.argv[1]+'/feats.scp', 'r').readlines()
spk2utt=open(sys.argv[1]+'/spk2utt', 'r').readlines()
label_spk2gen=open(sys.argv[3]+'/spk2gender', 'r').readlines()
spk_list = list()

for line in label_spk2gen:
 spkl = line[0:4]
 spk_list.append(spkl) 

spk2genderW=open(sys.argv[2]+'/spk2gender', 'w')
for line in spk2gender:
 spkr, _ = line.strip().split()
 if spkr in spk_list:
  spk2genderW.write(line)
spk2genderW.close()

cmvnW=open(sys.argv[2]+'/cmvn.scp', 'w')
for line in cmvn:
 spkr = line[0:4]
 if spkr in spk_list:
   cmvnW.write(line)
cmvnW.close()

textW=open(sys.argv[2]+'/text', 'w')
for line in text:
 spkr= line[0:4]
 if spkr in spk_list:
  textW.write(line)
textW.close()

spk2uttW=open(sys.argv[2]+'/spk2utt', 'w')
for line in spk2utt:
 spkr= line[0:4]
 if spkr in spk_list:
  spk2uttW.write(line)
spk2uttW.close()

utt2spkW=open(sys.argv[2]+'/utt2spk', 'w')
for line in utt2spk:
 _, spkr = line.strip().split()
 if spkr in spk_list:
  utt2spkW.write(line)
utt2spkW.close()

featsW=open(sys.argv[2]+'/feats.scp', 'w')
for line in feats:
 spkr= line[0:4]
 if spkr in spk_list:
  featsW.write(line)
featsW.close()

wavscpW=open(sys.argv[2]+'/wav.scp', 'w')
for line in wavscp:
 spkr= line[0:4]
 if spkr in spk_list:
  wavscpW.write(line)
wavscpW.close()

