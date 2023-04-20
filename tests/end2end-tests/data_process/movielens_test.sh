#!/bin/bash

GS_HOME=$(pwd)
export PYTHONPATH=$GS_HOME/python/

error_and_exit () {
	# check exec status of launch.py
	status=$1
	echo $status

	if test $status -ne 0
	then
		exit -1
	fi
}

# Test the DistDGL graph format.
echo "********* Test the DistDGL graph format ********"
python3 -m graphstorm.gconstruct.construct_graph --conf_file $GS_HOME/tests/end2end-tests/data_process/movielens.json --num_processes 1 --output_dir /tmp/movielens --graph_name ml

error_and_exit $?

echo "**************dataset: Test edge classification, RGCN layer: 1, node feat: fixed HF BERT, BERT nodes: movie, inference: mini-batch"
python3 $DGL_HOME/tools/launch.py --workspace $GS_HOME/training_scripts/gsgnn_ep/ --num_trainers $NUM_TRAINERS --num_servers 1 --num_samplers 0 --part_config /tmp/movielens/ml.json --ip_config ip_list.txt --ssh_port 2222 "python3 gsgnn_ep.py --cf ml_ec.yaml --num-gpus 1 --part-config /tmp/movielens/ml.json --n-epochs 1"

error_and_exit $?
