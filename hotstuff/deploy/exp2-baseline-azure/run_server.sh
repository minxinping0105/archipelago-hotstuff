#!/bin/bash
base_dir="./deploy/exp2-baseline-azure"


if [ "$#" -le 1 ]
then

  echo "Usage: run_server.sh {username} {server number}"

else

    replica_id=0
    replica_rest=$(($2))
    cat $base_dir/server.hosts | while read machine
    do
        echo "#### deploy replica ${replica_id} on machine ${machine}"

        ssh $1@${machine} "cd ~/hotstuff/hotstuff; 
                           ${base_dir}/single_server.sh ${replica_id} $2&" &

        replica_id=$((replica_id+1))
        replica_rest=$((replica_rest - 1))

        if [ $replica_rest -le 0 ]
        then
            break
        fi

    done

fi
