import sys
scores = open(sys.argv[1], 'rb').readlines()
while true:
  s=scores.read(1)
  if s == ' ': break
  print '%d'
