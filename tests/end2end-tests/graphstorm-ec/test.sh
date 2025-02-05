#!/bin/bash

service ssh restart

DGL_HOME=/root/dgl
GS_HOME=$(pwd)
NUM_TRAINERS=1
export PYTHONPATH=$GS_HOME/python/
cd $GS_HOME/training_scripts/gsgnn_ep

echo "127.0.0.1" > ip_list.txt

cat ip_list.txt

error_and_exit () {
	# check exec status of launch.py
	status=$1
	echo $status

	if test $status -ne 0
	then
		exit -1
	fi
}

echo "Test GraphStorm edge classification"

date

echo "**************dataset: Test edge classification, RGCN layer: 1, node feat: fixed HF BERT, BERT nodes: movie, inference: mini-batch"
python3 $DGL_HOME/tools/launch.py --workspace $GS_HOME/training_scripts/gsgnn_ep/ --num_trainers $NUM_TRAINERS --num_servers 1 --num_samplers 0 --part_config /data/movielen_100k_ec_1p_4t/movie-lens-100k.json --ip_config ip_list.txt --ssh_port 2222 "python3 gsgnn_ep.py --cf ml_ec.yaml --num-gpus 1 --part-config /data/movielen_100k_ec_1p_4t/movie-lens-100k.json --n-epochs 1"

error_and_exit $?

# TODO(zhengda) Failure found during evaluation of the auc metric returning -1 multiclass format is not supported
echo "**************dataset: Test edge classification, RGCN layer: 1, node feat: fixed HF BERT, BERT nodes: movie, inference: mini-batch, eval_metric: precision_recall"
python3 $DGL_HOME/tools/launch.py --workspace $GS_HOME/training_scripts/gsgnn_ep/ --num_trainers $NUM_TRAINERS --num_servers 1 --num_samplers 0 --part_config /data/movielen_100k_ec_1p_4t/movie-lens-100k.json --ip_config ip_list.txt --ssh_port 2222 "python3 gsgnn_ep.py --cf ml_ec.yaml --num-gpus 1 --part-config /data/movielen_100k_ec_1p_4t/movie-lens-100k.json --eval-metric precision_recall --n-epochs 1"

error_and_exit $?

# TODO(zhengda) Failure found during evaluation of the auc metric returning -1 multiclass format is not supported
echo "**************dataset: Test edge classification, RGCN layer: 1, node feat: fixed HF BERT, BERT nodes: movie, inference: mini-batch, eval_metric: precision_recall accuracy"
python3 $DGL_HOME/tools/launch.py --workspace $GS_HOME/training_scripts/gsgnn_ep/ --num_trainers $NUM_TRAINERS --num_servers 1 --num_samplers 0 --part_config /data/movielen_100k_ec_1p_4t/movie-lens-100k.json --ip_config ip_list.txt --ssh_port 2222 "python3 gsgnn_ep.py --cf ml_ec.yaml --num-gpus 1 --part-config /data/movielen_100k_ec_1p_4t/movie-lens-100k.json --eval-metric precision_recall accuracy --n-epochs 1"

error_and_exit $?

# TODO(zhengda) Failure found during evaluation of the auc metric returning -1 multiclass format is not supported
echo "**************dataset: Test edge classification, RGCN layer: 1, node feat: fixed HF BERT, BERT nodes: movie, inference: mini-batch, eval_metric: roc_auc"
python3 $DGL_HOME/tools/launch.py --workspace $GS_HOME/training_scripts/gsgnn_ep/ --num_trainers $NUM_TRAINERS --num_servers 1 --num_samplers 0 --part_config /data/movielen_100k_ec_1p_4t/movie-lens-100k.json --ip_config ip_list.txt --ssh_port 2222 "python3 gsgnn_ep.py --cf ml_ec.yaml --num-gpus 1 --part-config /data/movielen_100k_ec_1p_4t/movie-lens-100k.json --eval-metric roc_auc --n-epochs 1"

error_and_exit $?

echo "**************dataset: Test edge classification, RGCN layer: 1, node feat: fixed HF BERT, BERT nodes: movie, inference: full-graph"
python3 $DGL_HOME/tools/launch.py --workspace $GS_HOME/training_scripts/gsgnn_ep/ --num_trainers $NUM_TRAINERS --num_servers 1 --num_samplers 0 --part_config /data/movielen_100k_ec_1p_4t/movie-lens-100k.json --ip_config ip_list.txt --ssh_port 2222 "python3 gsgnn_ep.py --cf ml_ec.yaml --num-gpus 1 --part-config /data/movielen_100k_ec_1p_4t/movie-lens-100k.json --mini-batch-infer false --n-epochs 1"

error_and_exit $?

echo "**************dataset: Test edge classification, RGCN layer: 1, node feat: fixed HF BERT, BERT nodes: movie, inference: mini-batch, remove-target-edge: false"
python3 $DGL_HOME/tools/launch.py --workspace $GS_HOME/training_scripts/gsgnn_ep/ --num_trainers $NUM_TRAINERS --num_servers 1 --num_samplers 0 --part_config /data/movielen_100k_ec_1p_4t/movie-lens-100k.json --ip_config ip_list.txt --ssh_port 2222 "python3 gsgnn_ep.py --cf ml_ec.yaml --num-gpus 1 --part-config /data/movielen_100k_ec_1p_4t/movie-lens-100k.json --remove-target-edge false --n-epochs 1"

error_and_exit $?

echo "**************dataset: Test edge classification, RGCN layer: 2, node feat: fixed HF BERT, BERT nodes: movie, inference: mini-batch, fanout: different per etype, eval_fanout: different per etype"
python3 $DGL_HOME/tools/launch.py --workspace $GS_HOME/training_scripts/gsgnn_ep/ --num_trainers $NUM_TRAINERS --num_servers 1 --num_samplers 0 --part_config /data/movielen_100k_ec_1p_4t/movie-lens-100k.json --ip_config ip_list.txt --ssh_port 2222 "python3 gsgnn_ep.py --cf ml_ec.yaml --num-gpus 1 --part-config /data/movielen_100k_ec_1p_4t/movie-lens-100k.json --fanout 'rating:10@rating-rev:2,rating:5@rating-rev:0' --eval-fanout 'rating:10@rating-rev:2,rating:5@rating-rev:0' --n-layers 2 --n-epochs 1"

error_and_exit $?

echo "**************dataset: Generated multilabel EC test, RGCN layer: 1, node feat: generated feature, inference: mini-batch, exclude-training-targets: True"
python3 $DGL_HOME/tools/launch.py --workspace $GS_HOME/training_scripts/gsgnn_ep/ --num_trainers $NUM_TRAINERS --num_servers 1 --num_samplers 0 --part_config /data/movielen_100k_multi_label_ec/movie-lens-100k.json --ip_config ip_list.txt --ssh_port 2222 "python3 gsgnn_ep.py --cf ml_ec.yaml --num-gpus 1 --part-config /data/movielen_100k_multi_label_ec/movie-lens-100k.json --exclude-training-targets True --reverse-edge-types-map user,rating,rating-rev,movie --multilabel true --feat-name feat --n-epochs 1"

error_and_exit $?

echo "**************dataset: Test edge classification, RGCN layer: 1, node feat: fixed HF BERT, BERT nodes: movie, inference: full-graph, imbalance-class"
python3 $DGL_HOME/tools/launch.py --workspace $GS_HOME/training_scripts/gsgnn_ep/ --num_trainers $NUM_TRAINERS --num_servers 1 --num_samplers 0 --part_config /data/movielen_100k_ec_1p_4t/movie-lens-100k.json --ip_config ip_list.txt --ssh_port 2222 "python3 gsgnn_ep.py --cf ml_ec.yaml --num-gpus 1 --part-config /data/movielen_100k_ec_1p_4t/movie-lens-100k.json --mini-batch-infer false --imbalance-class-weights 1,1,2,1,2,1 --n-epochs 1"

error_and_exit $?

echo "**************dataset: Test edge classification, RGCN layer: 1, node feat: fixed HF BERT, BERT nodes: movie, inference: mini-batch early stop"
python3 $DGL_HOME/tools/launch.py --workspace $GS_HOME/training_scripts/gsgnn_ep/ --num_trainers $NUM_TRAINERS --num_servers 1 --num_samplers 0 --part_config /data/movielen_100k_ec_1p_4t/movie-lens-100k.json --ip_config ip_list.txt --ssh_port 2222 "python3 gsgnn_ep.py --cf ml_ec.yaml --num-gpus 1 --part-config /data/movielen_100k_ec_1p_4t/movie-lens-100k.json --enable-early-stop True --call-to-consider-early-stop 2 -e 30 --window-for-early-stop 3 --evaluation-frequency 100 --lr 0.01" | tee exec.log

error_and_exit $?

# check early stop
cnt=$(cat exec.log | grep "Evaluation step" | wc -l)
if test $cnt -eq 30
then
	echo "Early stop should work, but it didn't"
	exit -1
fi


if test $cnt -le 4
then
	echo "Need at least 5 iters"
	exit -1
fi

date

echo 'Done'
