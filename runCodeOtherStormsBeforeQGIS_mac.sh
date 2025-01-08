#!/bin/bash

DATA_PATH=$(pwd)

# Array of R scripts to run
scripts=("getWetIndsAroundHWMs.R" "dnsclAroundHWMs.R" "compareBds.R" "floodByElev.R" "modelProbFloodbyElev.R" "getProbFloodAtDestLocs.R" "costDistPrep_FloodArea.R")

# Array of corresponding directories for the scripts
directories=(
    "code/compareStorms/dataProcessing"
    "code/compareStorms/evaluation"
    "code/compareStorms/evaluation"
    "code/compareStorms/evaluation"
    "code/compareStorms/models"
    "code/compareStorms/dataProcessing"
    "code/compareStorms/dataProcessing"
)

# Loop through scripts and execute them
for i in "${!scripts[@]}"; do
    cd "${directories[$i]}" || { echo "Failed to change directory to ${directories[$i]}"; exit 1; }
    Rscript "${scripts[$i]}" "$DATA_PATH"
done