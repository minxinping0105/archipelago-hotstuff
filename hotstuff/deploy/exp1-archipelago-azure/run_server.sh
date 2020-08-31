#!/bin/bash
base_dir="./deploy/exp1-archipelago-azure"


if [ "$#" -le 0 ]
then

  echo "Usage: run_server.sh {username}"

else

    replica_id=0
    cat $base_dir/server.hosts | while read machine
    do
        echo "#### deploy replica ${replica_id} on machine ${machine}"

        ssh $1@${machine} "cd ~/hotstuff/hotstuff; 
                           ${base_dir}/single_server.sh ${replica_id} &" &

        replica_id=$((replica_id+1))
    done

fi
