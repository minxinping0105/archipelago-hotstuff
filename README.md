# Archipelago-Hotstuff

This repo contains our implementation of Archipelago on top of HotStuff. Please refer to our OSDI'20 paper and contact Yunhao Zhang(yz2327@cornell.edu) for questions about this repo.

# Step1: build and run on a single machine

We assume you have a Linux machine. Suppose your username is `user1` and the machine name is `driver` so the `user1@driver:` below indicates your shell prompt. Below are the initialization commands.

```shell
# go to your home directory
user1@driver: cd

# clone the repo
user1@driver: git clone https://github.com/yhzhang0128/archipelago-hotstuff.git

# name it as hotstuff (future scripts will use this directory name)
user1@driver: mv archipelago-hotstuff hotstuff

# install the dependencies
user1@driver: cd ~/hotstuff/
user1@driver: ./install_deps.sh
```

Below are the build and run commands.

```shell
# goto ~/hotstuff/hotstuff
user1@driver: cd ~/hotstuff/hotstuff

# build the code
user1@driver: ./build.sh
# it should build successfully

# make sure that you can ssh directly to your local machine
# i.e., ssh user1@127.0.0.1 works without typing passwords or something
# run servers; change the user1 to your own username
./deploy/exp1-archipelago-local/run_server.sh user1
# feel free to type enters to type the next command

# run clients
./deploy/exp1-archipelago-local/run_client.sh user1 4 20
# 4 is the number of clients (4 is a minimum for hotstuff)
# 30 is the duration (30 seconds)
# feel free to type enters to type the next command

# wait for about 20-30 seconds, scripts will terminate

# collect the experiment data
./deploy/exp1-archipelago-local/data.sh user1
# the experiment data is now in client0.exec.log and client0.order.log
# client0.order.log is the ordering phase log
# client0.exec.log is the execution phase log
```

# Step2: build and run on a distributed cluster

TBD
