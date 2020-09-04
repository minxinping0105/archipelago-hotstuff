# Archipelago-Hotstuff

This repo contains our implementation of Archipelago on top of HotStuff. Please refer to our OSDI'20 paper and contact Yunhao Zhang(yz2327@cornell.edu) for questions about this repo. 

## Table of Contents

- Get Started
- Validating the Claims
- Troubleshooting

## Get Started

### Step1: build and run on a single machine (~15 minutes expected)

> :warning: **[WARNING]** Build and run on a single machine can check whether the binary executable files are generated correctly, but the experiment results are not meaningful.

We assume you have a Linux machine. Suppose your username is `user1` and the machine name is `driver` so the `user1@driver:` below indicates your shell prompt. Below are the initialization commands.

```shell
# go to your home directory
user1@driver: cd

# clone the repo
user1@driver: git clone https://github.com/yhzhang0128/archipelago-hotstuff.git

# name it as hotstuff (future commands and scripts assume this directory name)
user1@driver: mv archipelago-hotstuff hotstuff

# install the dependencies
user1@driver: cd ~/hotstuff/
user1@driver: ./install_deps.sh
```

Below are the build and run commands.

```shell
# build the code
user1@driver: cd ~/hotstuff/hotstuff
user1@driver: ./build.sh

# prepare directory for log and data
user1@driver: mkdir ./deploy/exp1-archipelago-local/log
user1@driver: mkdir ./deploy/exp1-archipelago-local/data

# make sure that you can ssh directly to your local machine
# i.e., ssh user1@127.0.0.1 works without typing passwords or something
# run servers; change user1 to your own username
user1@driver: ./deploy/exp1-archipelago-local/run_server.sh user1
# feel free to type some enters to continue

# run clients
user1@driver: ./deploy/exp1-archipelago-local/run_client.sh user1 4 30
# 4 is the number of clients (4 is a minimum for hotstuff)
# 30 is the experiment duration (30 seconds)
# wait for about 35-40 seconds; scripts will terminate
# feel free to type some enters to continue

# collect the experiment data
user1@driver: ./deploy/exp1-archipelago-local/data.sh user1
# the experiment data is now in client0.exec.log and client0.order.log
# ./deploy/exp1-archipelago-local/data/client0.order.log is the ordering phase log
# ./deploy/exp1-archipelago-local/data/client0.exec.log is the execution phase log
```

> :warning: **[WARNING]** Remember to prepare the `log` and `data` directories for **all** future experiments. Remember to replace the `user1` in the commands to your own username as well.

### Step2: generate configuration files (~10 minutes expected)

The Python script `hotstuff/scripts/gen_conf.py` generates the configuration files. First, you need to modify the IP addresses of the server nodes to your own environment.

```python
    # in hotstuff/scripts/gen_conf.py
    ...
        # datacenter small
        ips = ['10.0.0.4', '10.0.0.5', '10.0.0.6', '10.0.0.7']
        # modify this ips variable to your own server list
    ...
```

Then generate your configuration files and replace the old ones.

```shell
user1@driver: cd ~/hotstuff/hotstuff

# run the Python script
user1@driver: python scripts/gen_conf.py
# the configuration files are generated in `./conf-gen` directory. 

# replace the old configuration files of experiment1
user1@driver: cp ./conf-gen/* ./deploy/exp1-archipelago-azure/conf-archipelago/

# modify the client and server machine IPs
user1@driver: vim ./deploy/exp1-archipelago-azure/client.hosts
user1@driver: vim ./deploy/exp1-archipelago-azure/server.hosts
```

You are now ready to run experiment1 in your own distributed environment.

> :warning: **[WARNING]** We assume that different servers have different IP addresses. For other experiments, you will need to modify `client.hosts`, `server.hosts` and `conf*/*` similarly. Configurations for different experiments are slightly different and we have provided the reference version.


### Step3: build and run in your distributed environment (~15 minutes expected)

The following commands show how we conduct a basic throughput-latency experiment. First, you need to install dependencies on all your machines.

```shell
# run install_deps.sh on all your machines
user1@{machine_name}: {some_path}/install_deps.sh
# this will also create ~/hotstuff and ~/hotstuff/hotstuff directories on {machine_name}
```
You can deploy the code and run distributed experiments from your driver machine.

```shell
# scripts we provide deploy clients on 10.0.0.9 and servers on 10.0.0.5, 10.0.0.6, 10.0.0.7 and 10.0.0.8
# these IPs are defined in the file ./deploy/exp1-archipelago-azure/client.hosts and ./deploy/exp1-archipelago-azure/server.hosts

# prepare directory for log and data
user1@driver: cd ~/hotstuff/hotstuff
user1@driver: mkdir ./deploy/exp1-archipelago-azure/log
user1@driver: mkdir ./deploy/exp1-archipelago-azure/data

# we assume that code has been built successfully on the driver machine
# make sure that driver can ssh directly to all your machines
user1@driver: cd ~/hotstuff
user1@driver: ./deploy.sh user1
# the binary executables have been deployed on all the machines described in file `./hosts`

# run servers
user1@driver: cd ~/hotstuff/hotstuff
user1@driver: ./deploy/exp1-archipelago-azure/run_server.sh user1
# feel free to type some enters to continue

# run clients
user1@driver: ./deploy/exp1-archipelago-azure/run_client.sh user1 4 30
# wait for about 35-40 seconds; scripts will terminate
# feel free to type some enters to continue

# collect the experiment data
user1@driver: ./deploy/exp1-archipelago-azure/data.sh user1
# the data is now in ./deploy/exp1-archipelago-azure/data/client0.exec.log and ./deploy/exp1-archipelago-azure/data/client0.order.log
```

> :warning: **[WARNING]** Note that `exp1-archipelago-local` and `exp1-archipelago-azure` are different experiments. Type the one you want to conduct.
