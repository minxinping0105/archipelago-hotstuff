#!/bin/bash
base_dir="./deploy/exp1-baseline-azure"

if [ "$#" -le 0 ]
then

  echo "Usage: collect_data.sh {username}"

else


rm -f ~/hotstuff/hotstuff/$base_dir/data/* 2> /dev/null

cat $base_dir/client.hosts | while read machine
do

  scp $1@${machine}:/home/$1/hotstuff/hotstuff/$base_dir/log/client* ~/hotstuff/hotstuff/$base_dir/data/;

done

wc -l ~/hotstuff/hotstuff/$base_dir/data/*;

fi
