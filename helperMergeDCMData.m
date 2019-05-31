% Translational Neuromodeling Project, ETH Zurich
% 'Decoding moral judgements from neurotypical individuals compared to
% individuals with ASD'
%--------------------------------------------------------------------------
% authors: Stephan Boner, Alexander Hess, Nina Stumpf
% date: 2019-05-30
% version: 1.0
%--------------------------------------------------------------------------
% This file merges the files stored in 2 different folders by iterating
% through all subjects in the destionation folder and adding all runs from
% the same subject in the source folder.
%
% Example way to use: 
% tnProjectPath = what('TNProject');
% tnProjectPath = tnProjectPath.path;
% mergeDCMData(fullfile(tnProjectPath, 'data_dcm_nomod'), fullfile(tnProjectPath, 'data'));
%==========================================================================

% Specify folders to be merged: 
tnProjectPath = what('TNProject');
tnProjectPath = tnProjectPath.path;
mergeDCMData(fullfile(tnProjectPath, 'data_dcm_nomod'), fullfile(tnProjectPath, 'data'));

function helperMergeDCMData(subjectsPathFrom, subjectsPathTo)
    toSubjects = dir(fullfile(subjectsPathTo, 'sub*'));
    for i = 1:numel(toSubjects)
        subject = toSubjects(i).name;
        dcmPathFrom = fullfile(subjectsPathFrom, subject, 'DCM');
        taskfoldersFrom = dir(fullfile(dcmPathFrom, 'sub*'));
        dcmPathTo = fullfile(subjectsPathTo, subject, 'DCM');
        if ~exist(dcmPathTo,'dir'); mkdir(dcmPathTo); end
        for j = 1:numel(taskfoldersFrom)
            taskFolderName = taskfoldersFrom(j).name;
            taskFolderToPath = fullfile(dcmPathTo, taskFolderName);
            if ~exist(taskFolderToPath,'dir'); mkdir(taskFolderToPath); end
            copyfile(fullfile(dcmPathFrom, taskFolderName, 'DCM*'), taskFolderToPath);
        end
    end
end