#!/bin/bash

model=$1
tunit=$2

module load python36-modules-gcc
source ./env/bin/activate

mkdir $tunit/logs
cp -r $model $tunit/logs/
cd $tunit

model_name=$(basename $model)

python main.py --gpu $CUDA_VISIBLE_DEVICES --validation --load_model $model_name --dataset summer2winter --val_batch 8 --workers 0


