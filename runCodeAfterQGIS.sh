#!/bin/bash

# Set the data path to the absolute path of the current directory
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
    "comparePredMeanToTruthDest.R"
    "getTotalMAE95PIAccuracy.R"
    "getTotalSensitivitySpecificity.R"
    "getTotalSensitivitySpecificity.3mFlood.R"
    "costgrow10mto5m_MethodArea1.R"
)

# Array of corresponding directories for the scripts
directories=(
    "code/dataProcessing"
    "code/dataProcessing"
    "code/evaluation"
    "code/models"
    "code/models"
    "code/models"
    "code/models"
    "code/evaluation"
    "code/evaluation"
    "code/evaluation"
    "code/evaluation"
    "code/evaluation"
    "code/evaluation"
    "code/comparison/costgrow"
)

# Loop through scripts and execute them
for i in "${!scripts[@]}"; do
    cd "${directories[$i]}" || { echo "Failed to change directory to ${directories[$i]}"; exit 1; }
    Rscript "${scripts[$i]}" "$DATA_PATH"
done