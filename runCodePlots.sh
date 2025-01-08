#!/bin/bash
DATA_PATH=$(pwd)

# Array of R scripts to run
scripts=("plotAccuracyWholeRegion.R" "plotP.3mFlood_Dnscl.R" "plot.3mFlood_Dnscl.R" "plotCostGrow.3mFlood.R" "plotHR.3mFlood.R" "plotDistatHWMs_Dnscl.R")

for script in "${scripts[@]}"; do
   # Rscript "$script" "$DATA_PATH"
    echo "Running: Rscript \"$script\" \"$DATA_PATH\""
done