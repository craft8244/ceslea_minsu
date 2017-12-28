import sys

spk2gender=open(sys.argv[1]+'/spk2gender', 'r').readlines()
text=open(sys.argv[1]+'/text', 'r').readlines()
utt2spk=open(sys.argv[1]+'/utt2spk', 'r').readlines()
wavscp=open(sys.argv[1]+'/wav.scp', 'r').readlines()
cmvn=open(sys.argv[1]+'/cmvn.scp', 'r').readlines()
feats=open(sys.argv[1]+'/feats.scp', 'r').readlines()
label_spk2gen=open(sys.argv[3]+'/spk2gender', 'r').readlines()
spk_list = list()
label_utt2spk=open(sys.argv[3]+'/utt2spk', 'r').readlines()
utt_list = list()

for line in label_spk2gen:
 spkl = line[0:4]
 spk_list.append(spkl) 
for line in label_utt2spk:
 utt = line[0:18]
 utt_list.append(utt)

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
 uttr = line[0:18]
 if uttr in utt_list:
  textW.write(line)
textW.close()

utt2spkW=open(sys.argv[2]+'/utt2spk', 'w')
for line in utt2spk:
 uttr = line[0:18]
 if uttr in utt_list:
  utt2spkW.write(line)
utt2spkW.close()

featsW=open(sys.argv[2]+'/feats.scp', 'w')
for line in feats:
 uttr= line[0:18]
 if uttr in utt_list:
  featsW.write(line)
featsW.close()

wavscpW=open(sys.argv[2]+'/wav.scp', 'w')
for line in wavscp:
 uttr= line[0:18]
 if uttr in utt_list:
  wavscpW.write(line)
wavscpW.close()
