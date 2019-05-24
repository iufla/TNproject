% List of open inputs
nrun = X; % enter the number of runs here
jobfile = {'C:\Users\Alexander\Documents\Studium\Master HST\Neuroscience\Spring Semester 2019\Translational Neuromodeling\Project\200_github repository\TNproject\data\sub-04\GLM\sub-04_task-dis_run-01_bold\BMS_batch_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
