# TNproject
Alexander Hess, Nina Stumpf, Stephan Boner\
ETH Zürich, 30. Mai 2019

## Data
We used the following dataset for our analysis:
https://openneuro.org/datasets/ds000212/versions/1.0.0

The dataset contains functional and anatomical scans from 39 subjects. For the experimental task conducted by Koster-Hale et al. (2013) each subject had to complet 6 runs. The data from all those 6 runs are stored in the 'func' subfolder.
Note: We encountered issues with sub-07 and sub-17 so we decided to not consider them due to the limited time window of this project. \
Also included is a file containing a detailed task description ('dataset_description.json') and one containing a detailed participant description ('participants.tsv'). Those files are also needed for the code to run smoothly.

## Code
All the necessary code can be downloaded from https://github.com/iufla/TNproject

When cloning the repository, the name of the folder will be set to 'TNproject' by default. This MUST NOT BE CHANGED for the code to run smoothly.

Additionaly, the code is relying on the Statistical Parametric Mapping framework (spm12, Wellcome Trust Center for Human Neuroimaging). SPM12 can be downloaded from https://www.fil.ion.ucl.ac.uk/spm/software/spm12/ following the installation guide on https://en.wikibooks.org/wiki/SPM (Make sure you add spm to your MATLAB path!). 

## Preprocessing
Download the complete dataset, rename the folder to 'data' and put it into the folder 'TNproject' (which has been downloaded and created in the previous step). Make sure that the file 'dataset_description.json' is in the 'data' folder. Delete the subfolders 'sub-07' and 'sub-17' to avoid complications with the preprocessing! \
For the preprocessing, run 'preprocessing_runner.m' (the files 'perprocess_NiiData.m' and 'helperReadTaskSpecs.m' are needed to run this program). The preprocessed data will, by default, be saved in your 'data' folder into a new subfolder for every subject called 'preprocessed'. The preprocessed data will be used in the next step of our analysis. Thus, we recommend to keep the 'data' folder and all subfolders as it they are created by default.

## GLM & Time-Series Extraction
To build the GLM's, run 'GLM_runner.m'. Files needed to run this programs are 'GLMRunOnSubject.m', 'GetTimeSeriesROIs.m' and 'GetTimeSeriesForFile.m'. Log files are created if there are problems arising with creating the GLM or extracting the time-series for a certain ROI. \
For every subject, a new subfolder 'GLM' will be created with the GLM's based on the preprocessed data, calculated for every 'dis' task (for more information, refer to the 'dataset_description.json'), so there will be six subfolders in the newly created GLM folder. In the end, the timeseries for our regions of interest (defined in 'GetTimeSeriesROIs.m') will be extracted and also saved into the created subfolders for each run.

## DCM
The file 'DCM_runner.m' is used to create our customized DCMs. In order to run this program, the files 'DCMRunOnSubject.m' and 'DCMCreateModels.m' are needed. \
Run 'DCM_runner.m' in FullMode to create and estimate all the DCM Models with their respective parameters for the 20 specified Models defined in 'DCMCreateModels.m'. This will generate a new subfolder for every subject called 'DCM', containing six subfolders with the DCM's for every task.

## BMS/BMA
to be continued...
