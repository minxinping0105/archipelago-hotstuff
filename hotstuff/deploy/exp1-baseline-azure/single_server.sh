#!/bin/bash

base_dir="./deploy/exp1-baseline-azure"

# original hotstuff only one instance
echo "    starting baseline replica $1"

./examples/hotstuff-app $base_dir/conf/hotstuff.gen.conf --conf $base_dir/conf/hotstuff.gen-sec$1.conf > /dev/null 2>&1 &

