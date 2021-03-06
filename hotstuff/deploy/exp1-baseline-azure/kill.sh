#!/bin/bash
base_dir="./deploy/exp1-baseline-azure"

if [ "$#" -le 0 ]
then

    echo "Usage: kill.sh {username}"

else

# kill the clients first
cat $base_dir/client.hosts | while read machine
do
    echo "kill clients on machine ${machine}"
    ssh $1@${machine} "killall hotstuff-client 2> /dev/null" &
done

# then kill the servers
cat $base_dir/server.hosts | while read machine
do
    echo "kill servers on machine ${machine}"
    ssh $1@${machine} "killall hotstuff-app 2> /dev/null" &
done

fi
