#!/bin/bash
#PBS -q gpu
#PBS -l walltime=4:0:0
#PBS -l select=1:ncpus=2:ngpus=1:gpu_cap=cuda61:mem=20gb:scratch_ssd=20gb
#PBS -j oe

##!!!!! IF YOU CHANGE WALLTIME DONT FORGET TO CHANGE TIMEOUT FOR TRAINING SCRIPT. !!!!!####
##!!!!! TRAINING SCRIPT TIMEOUT SHOULD BE AT LEAST 30 min. SHORTER THAN WALLTIME. !!!!!####

trap 'clean_scratch' TERM EXIT

HOMEPATH=/storage/brno2/home/$PBS_O_LOGNAME
DATAPATH=$HOMEPATH/KNN2021/    #folder with s2w dataset
RESPATH=$HOMEPATH/knn2021/    #store results in this folder

cd $SCRATCHDIR

# Download the Tunit repository
git clone https://github.com/andrejPP/tunit.git

# Download dataset
mkdir data
cd data
cp $DATAPATH/summer2winter.tar.gz .
tar -xf summer2winter.tar.gz
cd ../

# Prepare environment
module load python36-modules-gcc
python3 -m venv env
source ./env/bin/activate
mkdir tmp
cd tunit
pip install --upgrade pip
TMPDIR=../tmp pip install --upgrade -r requirements.txt

# Start training.
timeout --foreground 3h python3 main.py --gpu $CUDA_VISIBLE_DEVICES --p_semi 1.0 --dataset summer2winter --output_k 2 --data_path ../data --workers 0 --batch_size 8

# Save model
new_model_dir=$RESPATH/$(date +%Y-%m-%d-%H)
mkdir $new_model_dir
cp -r logs $new_model_dir
cp -r results $new_model_dir


