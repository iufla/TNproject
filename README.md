# TNproject
Alexander Hess, Nina Stumpf, Stephan Boner
ETH Zürich, 30. Mai 2019

## Data
We used the following dataset for our analysis:
https://openneuro.org/datasets/ds000212/versions/1.0.0
The dataset contains functional and anatomical scans from 39 subjects. For the experimental task conducted by Koster-Hale et al. (2013) each subject had to complet 6 runs. The data from all those 6 runs are stored in the 'func' subfolder.
Note: We encountered issues with sub-07 and sub-17 so we decided to not consider them due to the limited time window of this project.

## Preprocessing
Download the dataset, rename the folder to 'data' and put it into the main direcory. (Delete the folders 'sub-07' and 'sub-17' to avoid issues with the preprocessing!)
For preprocessing, run 'preprocessing_runner.m'. The preprocessed data will, by default, be saved in your 'data' folder into a new subfolder for every subject called 'preprocessed'. The preprocessed data will be used in the further step of our analysis. Thus, we recommend to keep the 'data' folder and all subfolders as it will be created by default.

## GLM & time-series extraction
For building the GLM's, run 'GLM_runner.m'. For every subject, a new subfolder 'GLM' will be created with the GLM's based on the preprocessed data, calculated for every task, so there will be six subfolders in the newly created GLM folder. In the end, the timeseries for our regions of interest (defined in 'GetTimeSeriesROIs.m') will be extracted and also saved into the created subfolders for each run.

## DCM
Run 'DCM_runner.m' to create and estimate all the DCM Models with their respective parameters for the 20 specified Models defined in 'DCMCreateModels.m'. This will generate a new subfolder for every subject called 'DCM', containing six subfolders with the DCM's for every task.

## BMS/BMA
to be continued...
