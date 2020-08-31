#!/bin/bash

base_dir="./deploy/exp1-baseline-azure"

# original hotstuff only one instance
echo "    starting baseline replica $1"

# print to screen
./examples/hotstuff-app $base_dir/conf/hotstuff.conf --conf $base_dir/conf/hotstuff-sec$1.conf  2>&1 &

