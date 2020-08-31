#!/bin/bash
base_dir="./deploy/exp1-archipelago-local"

if [ "$#" -le 0 ]
then

    echo "Usage: kill.sh {username}"

else

# kill the clients first
cat $base_dir/local.hosts | while read machine
do
    echo "kill clients on machine ${machine}"
    ssh $1@${machine} "killall archipelago-client 2> /dev/null" &
done

# then kill the servers
cat $base_dir/local.hosts | while read machine
do
    echo "kill servers on machine ${machine}"
    ssh $1@${machine} "killall hotstuff-app 2> /dev/null; killall archipelago-app 2> /dev/null" &

done

fi
