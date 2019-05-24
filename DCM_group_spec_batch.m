% List of open inputs
% Region specification: Select DCM_*.mat - cfg_files
% Region specification: Select VOI_*.mat - cfg_files
nrun = X; % enter the number of runs here
jobfile = {'C:\Users\Alexander\Documents\Studium\Master HST\Neuroscience\Spring Semester 2019\Translational Neuromodeling\Project\200_github repository\TNproject\data\sub-04\GLM\sub-04_task-dis_run-01_bold\DCM_group_spec_batch_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(2, nrun);
for crun = 1:nrun
    inputs{1, crun} = MATLAB_CODE_TO_FILL_INPUT; % Region specification: Select DCM_*.mat - cfg_files
    inputs{2, crun} = MATLAB_CODE_TO_FILL_INPUT; % Region specification: Select VOI_*.mat - cfg_files
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
