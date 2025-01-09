#!/bin/bash
DATA_PATH=$(pwd)

# Array of R scripts to run
scripts=("plotAccuracyWholeRegion.R" "plotP.3mFlood_Dnscl.R" "plot.3mFlood_Dnscl.R" "plotObsVSPreds.R" "plotCostGrow.3mFlood.R" "plotHR.3mFlood.R" "plotDistatHWMs_Dnscl.R")

plots_directory="code/plots"

# Loop through scripts and execute them
for script in "${scripts[@]}"; do
    cd "$DATA_PATH/$plots_directory" || { echo "Failed to change directory to $DATA_PATH/$plots_directory"; exit 1; }
    Rscript "$script" "$DATA_PATH"
done