if [ "$#" -le 0 ]
then

    echo "Usage: deploy.sh {username}"

else
    # remove old log and data
    rm hotstuff/deploy/*/log/*
    rm hotstuff/deploy/*/data/*
    
    cat hosts | while read machine
    do
        echo "deploy code on machine ${machine}"

        rsync -rtuv ./hotstuff/examples $1@${machine}:/home/$1/hotstuff/hotstuff/ 

	    rsync -rtuv ./hotstuff/deploy $1@${machine}:/home/$1/hotstuff/hotstuff/

        #scp ./install_deps.sh $1@${machine}:/home/$1/hotstuff/

    done

fi
