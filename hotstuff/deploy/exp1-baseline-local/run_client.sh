#!/bin/bash
base_dir="./deploy/exp1-baseline-local"


if [ "$#" -le 2 ]
then

  echo "Usage: run_client.sh {username} {client number} {duration}"

else

    # 16 client machines in this experiment and each process creates 4 clients
    process_total=$(($2))
    process_per_machine=$(($2 / 64))
    if [ $process_per_machine -le 0 ]
    then
        process_per_machine=1
    fi


    cat $base_dir/local.hosts | while read machine
    do
        echo "#### delete old log on machine ${machine}"
        ssh $1@${machine} "cd ~/hotstuff/hotstuff;
                           rm -f ${base_dir}/log/client* 2> /dev/null;" &
    done
    sleep 2
    

    client_id=0
    cat $base_dir/local.hosts | while read machine
    do

        for ((i=0; i<$process_per_machine; i++)); do

            echo "#### deploy client${client_id} on machine ${machine}"
            ssh $1@${machine} "cd ~/hotstuff/hotstuff;
                            sleep 5;
                            ${base_dir}/single_client.sh ${client_id} &" &

            # 4 server machines in this test
            process_total=$((process_total - 4))
            client_id=$((client_id+1))
        done

        if [ $process_total -le 0 ]
        then
            break
        fi

    done

    # wait for duration
    # remote client will sleep for 5 seconds
    sleep $(($3 + 5))

    # kill the clients and servers
    $base_dir/kill.sh $1

fi
