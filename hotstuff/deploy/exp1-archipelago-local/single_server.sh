#!/bin/bash

base_dir="./deploy/exp1-archipelago-local"

# original hotstuff only one instance
echo "    starting archipelago replica $1"

# print to screen
#./examples/hotstuff-app $base_dir/conf/hotstuff.conf --conf $base_dir/conf/hotstuff-sec$1.conf > /dev/null 2>&1 &

./examples/archipelago-app $base_dir/conf-archipelago/hotstuff.gen.conf $base_dir/log/server$1.log --conf $base_dir/conf-archipelago/hotstuff.gen-sec$1.conf > /dev/null  2>&1 &

