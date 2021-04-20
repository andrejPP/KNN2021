#!/bin/bash

wget https://people.eecs.berkeley.edu/~taesung_park/CycleGAN/datasets/summer2winter_yosemite.zip
unzip -qqn summer2winter_yosemite.zip

fixed_name=summer2winter

mv summer2winter_yosemite $fixed_name
cd $fixed_name

mkdir train
mkdir test

mv trainA train/summer
mv trainB train/winter
mv testA test/summer
mv testB test/winter
cd ..


tar -czvf summer2winter.tar.gz summer2winter 




