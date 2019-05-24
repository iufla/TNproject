% List of open inputs
% Input specification: Select DCM_*.mat - cfg_files
% Input specification: Select SPM.mat - cfg_files
% Input specification: Inputs - cfg_repeat
nrun = X; % enter the number of runs here
jobfile = {'C:\Users\Alexander\Documents\Studium\Master HST\Neuroscience\Spring Semester 2019\Translational Neuromodeling\Project\200_github repository\TNproject\data\sub-04\GLM\sub-04_task-dis_run-01_bold\DCM_region_spec_batch_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(3, nrun);
for crun = 1:nrun
    inputs{1, crun} = MATLAB_CODE_TO_FILL_INPUT; % Input specification: Select DCM_*.mat - cfg_files
    inputs{2, crun} = MATLAB_CODE_TO_FILL_INPUT; % Input specification: Select SPM.mat - cfg_files
    inputs{3, crun} = MATLAB_CODE_TO_FILL_INPUT; % Input specification: Inputs - cfg_repeat
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
