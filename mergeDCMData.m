% One way to use: 
% tnProjectPath = what('TNProject');
% tnProjectPath = tnProjectPath.path;
% mergeDCMData(fullfile(tnProjectPath, 'data_dcm_nomod'), fullfile(tnProjectPath, 'data'));

function mergeDCMData(subjectsPathFrom, subjectsPathTo)
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