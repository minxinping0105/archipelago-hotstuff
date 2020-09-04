#!/bin/bash
base_dir="./deploy/exp3-archipelago-azure"


if [ "$#" -le 2 ]
then

  echo "Usage: run_server.sh {username} {number of nodes} {number of machine per node}"

else

    replica_id=0
    instance_id=0
    replica_rest=$(($2))
    instance_rest=$(($3))
    cat $base_dir/server.hosts | while read machine
    do
        echo "#### deploy instance ${instance_id} replica ${replica_id} on machine ${machine}"

        ssh $1@${machine} "cd ~/hotstuff/hotstuff; 
                           ${base_dir}/single_server.sh ${replica_id} $2 ${instance_id}&" &

        replica_id=$((replica_id+1))
        replica_rest=$((replica_rest - 1))

        if [ $replica_rest -le 0 ]
        then
            instance_id=$((instance_id+1))
            instance_rest=$((instance_rest - 1))
            replica_id=0
            replica_rest=$(($2))
        fi

        if [ $instance_rest -le 0 ]
        then
            break
        fi
        
    done

fi
