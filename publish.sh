#/bin/bash
MAJOR=2
MINOR=0
FIX=0
docker build -t marcopeg/humble:latest -t marcopeg/humble:$MAJOR -t marcopeg/humble:$MAJOR.$MINOR -t marcopeg/humble:$MAJOR.$MINOR.$FIX .
docker push marcopeg/humble
