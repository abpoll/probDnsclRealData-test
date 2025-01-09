#!/bin/bash
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=10gb
#SBATCH --partition=open

module load anaconda3/2021.05

DATA_PATH=$(pwd)
cd $DATA_PATH/plots

conda env create --file probDnscl_env.yml --prefix $DATA_PATH
ln -s $DATA_PATH/probDnscl_env ~/.conda/envs/probDnscl_env

conda deactivate
