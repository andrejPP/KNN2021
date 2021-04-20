# KNN2021

## Prepare dataset before training
This script will download and prepare summer2winter_yosemit dataset into proper folder structure and compress it with name that training script expect
```
prepare_s2w.sh
```

## Training tunit
This command will run training script automatically on metacentrum. Don't forget to adjust 3 paths at the top of the script. Also system requirements are specified in first four comments. For more information visit https://wiki.metacentrum.cz/wiki/About_scheduling_system or https://wiki.metacentrum.cz/wiki/Beginners_guide
```
qsub tran_tunit_auto.sh
```
Scripts download model from https://github.com/andrejPP/tunit repository, so every change needs to be uploaded there. 

## Run validation
```
run_validation.sh $PATH_TO_THE_MODEL_DIR $PATH_TO_THE_TUNIT_DIR
```
for example
```
./run_validation.sh ../2021-04-10-07/results/GAN_20210410-045134/ ../tunit
```
Script expects the environment that was installed with training script.
