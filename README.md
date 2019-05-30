# TNproject
Alexander Hess, Nina Stumpf, Stephan Boner
ETH Zürich, 30. Mai 2019

## Data
We used the following Dataset for our analysis
https://openneuro.org/datasets/ds000212/versions/1.0.0
The Dataset contains data of 39 subjects with functional and anatomical fMRI-Data.
Remark: We encountered issues with sub-07 and sub-17 so we decided to not consider them due to our limited time.

## Preprocessing
Download the data, rename the folder to 'data' and put it into the main direcory.
For preprocessing, run 'preprocessing_runner.m'. The preprocessed data will, by default, be saved in a new subfolder for every subject called 'preprocessed'

## GLM 
For building the GLM's, run 'GLM_runner.m'. For every subject, a new subfolder 'GLM' will be created with the GLM's based on the preprocessed data, calculated for every task, so there will be six subfolders in GLM. At the end, it will start extracting the timeseries for our regions of interest (defined in 'GetTimeSeriesROIs.m')

## DCM
Run 'DCM_runner.m' to create and estimate all the DCM Models with their respective parameters for the 20 specified Models defined in 'DCMCreateModels.m'. This will generate a new subfolder for every subject called 'DCM', containing six subfolders with the DCM's for every task.

## BMS/BMA
to be continued...
