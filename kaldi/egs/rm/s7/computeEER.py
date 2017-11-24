import sys
thresNum=0
result=open(sys.argv[1], 'r').readlines()
RateDis=list()
EER=list()
for threshold in range(-2000,1001):
 TR=0#true reject
 FA=0#false accept
 FR=0#false reject
 TA=0#true accept
 for line in result:
  score, answer = line.strip().split()
  score=float(score)
  thres=threshold*0.01
  if answer == "target" and score>=thres:
   TA=TA+1
  elif answer == "target" and score<thres:
   FR=FR+1
  elif answer == "nontarget" and score>=thres:
   FA=FA+1
  elif answer == "nontarget" and score<thres:
   TR=TR+1
 RateFA=FA/((TR+FA)*1.000)
 RateFR=FR/((TA+FR)*1.000)
 #print RateFA, RateFR
 RateDis.append(abs(RateFA-RateFR))
 if RateFR>=RateFA and thresNum==0:
  print "EER: %f %f" % (RateFR*100, abs(RateFA-RateFR))
  FRmin=FR
  thresNum=1
  threshold1=threshold
 if thresNum and FR>FRmin:
  print (threshold1+threshold)/2.0*0.01,
  print threshold*0.01
  break
 EER.append(max(RateFA,RateFR))
 #EER.append((RateFA+RateFR)*1.0/2)
 #print abs(RateFA-RateFR),
 #print (RateFA+RateFR)*1.0/2
else:
 L=RateDis.index(min(RateDis))
 print "EER: %f %f %f" % (EER[L]*100, RateDis[L]*100, (L-2000)*0.01)
