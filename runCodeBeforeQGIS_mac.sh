#!/bin/bash

# Set the data path to the absolute path of the current directory
DATA_PATH=$(pwd)

# Array of R scripts to run
scripts=(
    "getCoordsFromRuns.R"
    "get5mCoordsAroundHWMs.R"
    "getWetIndsAroundHWMs.R"
    "getAdjPredsAtAndAroundHWMs.R"
    "dnsclAroundHWMs.R"
    "dnsclAtHWMs.R"
    "compareBds.R"
    "floodByElev.R"
    "modelProbFloodbyElev.R"
    "getProbFloodatDestLocs.R"
    "costDistPrep_FloodArea.R"
)

# Array of corresponding directories for the scripts
directories=(
    "code/dataProcessing"
    "code/dataProcessing"
    "code/dataProcessing"
    "code/dataProcessing"
    "code/evaluation"
    "code/evaluation"
    "code/evaluation"
    "code/evaluation"
    "code/models"
    "code/dataProcessing"
    "code/dataProcessing"
)

# Loop through scripts and execute them
for i in "${!scripts[@]}"; do
    cd "$DATA_PATH/${directories[$i]}" || { echo "Failed to change directory to ${directories[$i]}"; exit 1; }
    Rscript "${scripts[$i]}" "$DATA_PATH"
done