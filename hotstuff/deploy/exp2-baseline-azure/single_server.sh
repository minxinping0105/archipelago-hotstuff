#!/bin/bash

base_dir="./deploy/exp2-baseline-azure"

# original hotstuff only one instance
echo "    starting baseline replica $1"

# print to screen
./examples/hotstuff-app $base_dir/conf/$2/hotstuff.gen.conf --conf $base_dir/conf/$2/hotstuff.gen-sec$1.conf > /dev/null 2>&1 &

