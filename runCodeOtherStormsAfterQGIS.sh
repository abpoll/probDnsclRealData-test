#!/bin/bash

DATA_PATH=$(pwd)

# Array of R scripts to run
scripts=(
    "getFloodedCellFromBackLink.R"
    "getSourcesForDests.R"
    "dnsclSource.R"
    "getMeanIfNot0ForDestCells.R"
    "probDestCellsWetVSDry.R"
    "probDestCellsFlood.3m.R"
    "getCDFandPDFatDests.R"
    "sensitivityAndSpecificityWetCells.R"
    "sensitivityAndSpecificity.3mWetCells.R"
    "getTotalMAE95PIAccuracy.R"
    "getTotalSensitivitySpecificity.R"
    "getTotalSensitivitySpecificity.3mFlood.R"
)

# Array of corresponding directories for the scripts
directories=(
    "code/compareStorms/dataProcessing"
    "code/compareStorms/dataProcessing"
    "code/compareStorms/evaluation"
    "code/compareStorms/models"
    "code/compareStorms/models"
    "code/compareStorms/models"
    "code/compareStorms/models"
    "code/compareStorms/evaluation"
    "code/compareStorms/evaluation"
    "code/compareStorms/evaluation"
    "code/compareStorms/evaluation"
    "code/compareStorms/evaluation"
)

# Loop through scripts and execute them
for i in "${!scripts[@]}"; do
    cd "${directories[$i]}" || { echo "Failed to change directory to ${directories[$i]}"; exit 1; }
    Rscript "${scripts[$i]}" "$DATA_PATH"
done