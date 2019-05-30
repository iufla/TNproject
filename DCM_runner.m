% Translational Neuromodeling Project, ETH Zurich
% 'Decoding moral judgements from neurotypical individuals compared to
% individuals with ASD'
%--------------------------------------------------------------------------
% authors: Stephan Boner, Alexander Hess, Nina Stumpf
% date: 2019-05-30
% version: 1.0
%--------------------------------------------------------------------------
% This file creates 20 different DCMs (specified in 'DCMCreateModels.m') by
% calling the file 'DCMRunOnSubject.m'.
% In line 24, one can specify the testMode, in which only 1 run of 1
% subject will be estimated.
% When running in fullMode (line 25), DCMs are estimated for every run of
% every subject.
%
% This file calls: 'DCMRunOnSubject.m' (which calls 'DCMCreateModels.m' and
% 'spm_dcm_estimate.m')
%==========================================================================

pathBase = what('TNproject');
pathBase = pathBase.path;
pathBase = fullfile(pathBase, 'data');

testMode = 0; % runs the DCM estimation only on one subject
fullMode = 1; % runs the DCM estimation on all the tasks if 1, only on one if 0

if testMode == 1 % run it just for one subjects and one task
    subjectPath = fullfile(pathBase, 'sub-04');
    runName = 'sub-04_task-dis_run-01_bold';
    DCMRunOnSubject(subjectPath, runName);
else % run it for all subjects
    subjectDir = dir(fullfile(pathBase, 'sub*'));

    for subjectIndex = 1:numel(subjectDir)
        subjectPath = fullfile(subjectDir(subjectIndex).folder,subjectDir(subjectIndex).name);
        
        if fullMode == 0 % run it for one task
            runName = [subjectDir(subjectIndex).name, '_task-dis_run-01_bold'];
            DCMRunOnSubject(subjectPath, runName);
        else % run it for all tasks
            glmPath = fullfile(subjectPath, 'GLM');
            dirs = dir(fullfile(glmPath, 'sub*'));
            names = string();
            for i = 1:numel(dirs)
                names(i) = dirs(i).name;
            end
            for nameIndex = 1:numel(names)
                runName = names(nameIndex);
                DCMRunOnSubject(subjectPath, runName);
            end
        end
    end
end