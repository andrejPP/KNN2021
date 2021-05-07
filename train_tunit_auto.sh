#!/bin/bash
#PBS -q gpu
#PBS -l select=1:ncpus=2:ngpus=2:gpu_cap=cuda70:mem=20gb:scratch_ssd=20gb
#PBS -j oe

##!!!!! IF YOU CHANGE WALLTIME DONT FORGET TO CHANGE TIMEOUT FOR TRAINING SCRIPT. !!!!!####
##!!!!! TRAINING SCRIPT TIMEOUT SHOULD BE AT LEAST 30 min. SHORTER THAN WALLTIME. !!!!!####

trap 'clean_scratch' TERM EXIT

HOMEPATH=/storage/brno2/home/$PBS_O_LOGNAME
DATAPATH=$HOMEPATH/KNN2021/    #folder with s2w dataset
RESPATH=$HOMEPATH/knn2021/    #store results in this folder

cd $SCRATCHDIR

# clean the SCRATCH directory
clean_scratch

# Download the Tunit repository
printf "Download the Tunit repository\n"
git clone https://github.com/andrejPP/tunit.git
cd tunit
git checkout $branch
cd ..

# Download dataset
printf "Download dataset\n"
mkdir data
cd data
cp $DATAPATH/summer2winter.tar.gz .
tar -xf summer2winter.tar.gz
cd ../

# Prepare directory with results
printf "Prepare directory with results\n"
if [ ! -d "$HOMEPATH/knn2021/" ]; then # test if dir exists
	mkdir $HOMEPATH/knn2021/
fi

printf "-----------------------------------------------------------\n"
printf "JOB ID:             $PBS_JOBID\n"
printf "JOB NAME:           $PBS_JOBNAME\n"
printf "JOB SERVER NODE:    $PBS_SERVER\n"
printf "START TIME:         $(date +%Y-%m-%d-%H)\n"
printf "GIT BRANCH:         $branch\n"
printf "-----------------------------------------------------------\n"

# Prepare environment
printf "Prepare environment\n"
module load python36-modules-gcc
python3 -m venv env
source ./env/bin/activate
mkdir tmp
cd tunit
pip install --upgrade pip
TMPDIR=../tmp pip install --upgrade torch==1.8.1+cu111 torchvision==0.9.1+cu111 torchaudio==0.8.1 -f https://download.pytorch.org/whl/torch_stable.html -r requirements.txt

# Start training.
if [ -z "$modelpath" ]; then
    python3 main.py --timeout ${stime} --p_semi 0.0 --dataset summer2winter --output_k 2 --data_path ../data --workers 0 --batch_size 16 --val_batch 8
else
    mkdir ./logs
    mkdir ./logs/latest_model
    cp -r ${modelpath}/* ./logs/latest_model
    python3 main.py --timeout ${stime} --p_semi 0.0  --load_model latest_model --dataset summer2winter --output_k 2 --data_path ../data --workers 0 --batch_size 16 --val_batch 8
fi

# Save model
new_model_dir=$RESPATH/$(date +%Y-%m-%d-%H)-${branch}-${stime}h
mkdir $new_model_dir
cp -r logs $new_model_dir
cp -r results $new_model_dir

# clean the SCRATCH directory
clean_scratch


