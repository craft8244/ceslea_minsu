import sys

spk2gender=open(sys.argv[1]+'/spk2gender', 'r').readlines()
text=open(sys.argv[1]+'/text', 'r').readlines()
utt2spk=open(sys.argv[1]+'/utt2spk', 'r').readlines()
wavscp=open(sys.argv[1]+'/wav.scp', 'r').readlines()
cmvn=open(sys.argv[1]+'/cmvn.scp', 'r').readlines()
feats=open(sys.argv[1]+'/feats.scp', 'r').readlines()
utt2dur=open(sys.argv[1]+'/utt2dur', 'r').readlines()
spklist=sys.argv[3]
spk_list=spklist.split('.')

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

utt2spkW=open(sys.argv[2]+'/utt2spk', 'w')
for line in utt2spk:
 spkr= line[0:4]
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

utt2durW=open(sys.argv[2]+'/utt2dur', 'w')
for line in utt2dur:
 spkr= line[0:4]
 if spkr in spk_list:
  utt2durW.write(line)
utt2durW.close()


