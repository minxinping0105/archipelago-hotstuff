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

> :warning: **[WARNING]** Note that `exp1-archipelago-local` and `exp1-archipelago-azure` are different experiments. Type the correct one you want to conduct.


## Validating the Claims

We made 4 claims which can be found in Figure 3 of our submission. We copy-and-paste here.

- **claim1**: Archipelago achieves higher throughput than its baselines at the cost of increased latency (latencies are competitive when batching commands).

- **claim2**: Archipelago’s throughput degrades similarly to its baselines when *n* increases, but Archipelago can scale up each node for higher throughput.

- **claim3**: Archipelago incurs modest network overheads over its baselines.

- **claim4**: A geo-distributed deployment increases latencies, but Archipelago’s peak throughput remains similar to a single datacenter setting.

> :warning: The idea of "scale up" may be confusing in our submission version. Several reviewers have given us feedback and we will revise our writing.

### Validating claim1

> :warning: The cloud instance we used for our submission were deleted by Azure. We are using a similar instance for revision now and here are the numbers on this instance. They are similar but not completely the same as our Figure 4 in the submission. 

|                             | throughput | latency | validation |
|-----------------------------|------------|---------|------------|
| HotStuff (beta = 1)         | 526        | 7.1     | step1.1    |
| HotStuff (beta = 2000)      | 92933      | 83.8    | step1.3   |
| Archipelago-HS (beta = 1)   | 1479       | 2.5 (o) 87.1 (c) | step1.2 |
| Archipelago-HS (beta = 700) | 160060     | 13.6 (o), 97.1 (c) | step1.4 |

In claim1, we say that Archipelago achieves higher throughput than baseline (1479 > 526; 160060 > 92933) at the cost of increased latency (87.1 > 7.1). But latencies are comparable (83.8 vs. 97.1) when batching commands (beta is the batch size). 

#### step1.1
```shell
user1@driver: cd ~/hotstuff/hotstuff
user1@driver: ./deploy/exp1-baseline-azure/run_server.sh user1
user1@driver: ./deploy/exp1-baseline-azure/run_client.sh user1 4 30
user1@driver: ./deploy/exp1-baseline-azure/data.sh user1
user1@driver: cd ~/hotstuff
# process data
user1@driver: python process.py client hotstuff/deploy/exp1-baseline-azure/data
```

Note: throughput is the number of transactions reported by process.py divided by 30 (i.e., the time interval of the experiment).

#### step1.2
```shell
user1@driver: cd ~/hotstuff/hotstuff
user1@driver: ./deploy/exp1-archipelago-azure/run_server.sh user1
user1@driver: ./deploy/exp1-archipelago-azure/run_client.sh user1 4 30
user1@driver: ./deploy/exp1-archipelago-azure/data.sh user1
user1@driver: cd ~/hotstuff
# process data of ordering phase
user1@driver: python process.py order hotstuff/deploy/exp1-archipelago-azure/data
# process data of execution phase
user1@driver: python process.py exec hotstuff/deploy/exp1-archipelago-azure/data
```

#### step1.3

- modify file `hotstuff/hotstuff/deploy/exp1-baseline-azure/conf/hotstuff.gen.conf` changing `block-size` to 2000

- modify file `hotstuff/hotstuff/deploy/exp1-baseline-azure/single_client.sh` changing `--max-async` to 8000

- redo step1.1

#### step1.4

- modify file `hotstuff/hotstuff/deploy/exp1-archipelago-azure/conf-archipelago/hotstuff.gen.conf` changing `block-size` to 700

- redo step1.2


### Validating claim2

|                             |  validation |
|-----------------------------| -----------|
| Archipelago’s throughput degrades similarly to its baselines when *n* increases | step2.1    |
|  Archipelago can scale up each node for higher throughput      |  step2.2   |

#### step2.1

> :warning: **[WARNING]** You need to generate the configuration files for all different setups (i.e., n=4, n=7, n=10, n=13, n=16) and put them into the corresponding directory `hotstuff/hotstuff/deploy/exp2-baseline-azure/conf/{server number}` and `hotstuff/hotstuff/deploy/exp2-archipelago-azure/conf-archipelago/{server number}`. Generate and replace the configuration files before you proceed.

Every point in Figure 6 is a separate experiment. The commands for baseline HotStuff are:

```shell
user1@driver: cd ~/hotstuff/hotstuff
user1@driver: ./deploy/exp2-baseline-azure/run_server.sh user1 {server number}
user1@driver: ./deploy/exp2-baseline-azure/run_client.sh user1 4 30 {server number}
user1@driver: ./deploy/exp2-baseline-azure/data.sh user1
user1@driver: cd ~/hotstuff
user1@driver: python process.py client hotstuff/deploy/exp2-baseline-azure/data
```

Change the `{server number}` above to 4, 7, 10, 13 and 16 to conduct the experiments on different number of nodes. The commands for Archipelago-HotStuff are:

```shell
user1@driver: cd ~/hotstuff/hotstuff
user1@driver: ./deploy/exp2-archipelago-azure/run_server.sh user1 {server number}
user1@driver: ./deploy/exp2-archipelago-azure/run_client.sh user1 4 30 {server number}
user1@driver: ./deploy/exp2-archipelago-azure/data.sh user1
user1@driver: cd ~/hotstuff
user1@driver: python process.py order hotstuff/deploy/exp2-archipelago-azure/data
```

Change the `{server number}` above to 4, 7, 10, 13 and 16 to conduct the experiments on different number of nodes.

#### step2.2

> :warning: **[WARNING]** Read the example configuration files first before you generate them. Specifically, read `hotstuff/hotstuff/deploy/exp3-archipelago-azure/conf-archipelago/{server number}/{machine number}/hotstuff.gen.conf`. Generate and replace the configuration files before you proceed.

The commands for Figure 7 are:

```shell
user1@driver: cd ~/hotstuff/hotstuff
user1@driver: ./deploy/exp3-archipelago-azure/run_server.sh user1 {server number} {machine per server}
user1@driver: ./deploy/exp3-archipelago-azure/run_client.sh user1 4 30 {server number} {machine per server}
user1@driver: ./deploy/exp3-archipelago-azure/data.sh user1
user1@driver: cd ~/hotstuff
user1@driver: python process.py order hotstuff/deploy/exp3-archipelago-azure/data
```
where the parameters are 

|  {server number}  |  {machine per server}  |
|-----------------------------| -----------|
| 4 | 1   |
| 4 | 2   |
| 4 | 3   |
| 4 | 4   |
| 7 | 1   |
| 7 | 2   |

### Validating claim3

This is the same as **step1.1** and **step1.2**, but we use the `nload` tool to monitor the network usage of a single server node.

### Validating claim4

This is the same as **step1.3** and **step1.4**, but you need to generate the configuration files for your geo-distributed setting. Make sure that the IPs in your configurations are accessible to each other (e.g., there could be firewall issues).

## Troubleshooting

TBD
