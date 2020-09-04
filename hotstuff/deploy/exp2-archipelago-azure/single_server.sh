#!/bin/bash

base_dir="./deploy/exp2-archipelago-azure"

# original hotstuff only one instance
echo "    starting archipelago replica $1"


./examples/archipelago-app $base_dir/conf-archipelago/$2/hotstuff.gen.conf $base_dir/log/server$1.log --conf $base_dir/conf-archipelago/$2/hotstuff.gen-sec$1.conf > /dev/null  2>&1 &

