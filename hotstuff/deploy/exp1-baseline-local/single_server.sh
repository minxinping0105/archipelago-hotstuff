#!/bin/bash

base_dir="./deploy/exp1-baseline-local"

# original hotstuff only one instance
echo "    starting baseline replica $1"

# print to screen
./examples/hotstuff-app $base_dir/conf/hotstuff.conf --conf $base_dir/conf/hotstuff-sec$1.conf > /dev/null 2>&1 &

