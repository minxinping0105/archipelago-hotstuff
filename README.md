# Archipelago-Hotstuff

This repo contains our implementation of Archipelago on top of HotStuff. Please refer to our OSDI'20 paper and contact Yunhao Zhang(yz2327@cornell.edu) for questions about this repo. To run experiments, please go through the following 3 steps one by one.

# Step1: build and run on a single machine

We assume you have a Linux machine. Suppose your username is `user1` and the machine name is `driver` so the `user1@driver:` below indicates your shell prompt. Below are the initialization commands.

```shell
# go to your home directory
user1@driver: cd

# clone the repo
user1@driver: git clone https://github.com/yhzhang0128/archipelago-hotstuff.git

# name it as hotstuff (future commands and scripts will assume this directory name)
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
user1@driver: ./deploy/exp1-archipelago-local/run_server.sh user1
# feel free to type enters to type the next command

# run clients
user1@driver: ./deploy/exp1-archipelago-local/run_client.sh user1 4 30
# 4 is the number of clients (4 is a minimum for hotstuff)
# 30 is the experiment duration (30 seconds)
# wait for about 35-40 seconds; scripts will terminate

# collect the experiment data
user1@driver: ./deploy/exp1-archipelago-local/data.sh user1
# the experiment data is now in client0.exec.log and client0.order.log
# client0.order.log is the ordering phase log
# client0.exec.log is the execution phase log
```


# Step2: generate configuration files for your distributed environment

The Python script `hotstuff/scripts/gen_conf.py` generates the configuration files. First, you need to modify the IP addresses of the server nodes.

```python
    # in hotstuff/scripts/gen_conf.py
    ...
        # datacenter
        ips = ['10.0.0.4', '10.0.0.5', '10.0.0.6', '10.0.0.7']
        # modify this ips variable to your own server list
    ...
```
> :warning: **[WARNING]** We assume that different servers have different IP addresses.

Then generate your configuration files and replace the old ones.

```shell
user1@driver: cd ~/hotstuff/hotstuff

# run the Python script
user1@driver: python scripts/gen_conf.py
# the configuration files are generated in `./conf-gen` directory. 

# replace the old configuration files of experiment1
user1@driver: cp ./conf-gen/* ./deploy/exp1-archipelago-azure/conf-archipelago/

# modify the client and server host IPs
user1@driver: vim ./deploy/exp1-archipelago-azure/client.hosts
user1@driver: vim ./deploy/exp1-archipelago-azure/server.hosts
```

You are now ready to run experiment1 in your distributed environment. Steps for other experiments are similar.


# Step3: build and run in a distributed environment

> :warning: **[WARNING]** Make sure that you have followed step2 carefully.

The following commands show how we conduct a basic throughput-latency experiment. First, you need to install dependencies on all machines.

```shell
# run install_deps.sh on all your machines
user1@{machine_name}: {some_path}/install_deps.sh
# this will also create ~/hotstuff and ~/hotstuff/hotstuff directories
```
You can deploy the code and run distributed experiments from your driver machine.

```shell
# we deploy clients on 10.0.0.8 and servers on 10.0.0.4, 10.0.0.5, 10.0.0.6 and 10.0.0.7
# all these IPs are included in the file ~/hotstuff/hosts

# we assume that code has been built successfully on the driver machine
# make sure that driver can ssh directly to all the machine
user1@driver: ./deploy.sh user1
# now the binary executables have been deployed on all the machines

# run servers
user1@driver: ./deploy/exp1-archipelago-azure/run_server.sh user1
# feel free to type enters to type the next command

# run clients
user1@driver: ./deploy/exp1-archipelago-azure/run_client.sh user1 4 30
# wait for about 35-40 seconds; scripts will terminate

# collect the experiment data
user1@driver: ./deploy/exp1-archipelago-azure/data.sh user1
# the experiment data is now in client0.exec.log and client0.order.log
```
