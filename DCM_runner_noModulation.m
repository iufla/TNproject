pathBase = what('TNproject');
pathBase = pathBase.path;
pathBase = fullfile(pathBase, 'data');

testMode = 0; % runs the DCM estimation only on one subject
fullMode = 0; % runs the DCM estimation on all the tasks if 1, only on one if 0

if testMode == 1 % run it just for one subjects and one task
    subjectPath = fullfile(pathBase, 'sub-03');
    runName = 'sub-03_task-dis_run-01_bold';
    DCMRunOnSubject(subjectPath, runName);
else % run it for all subjects
    subjectDir = dir(fullfile(pathBase, 'sub*'));

    for subjectIndex = 1:numel(subjectDir)
        subjectPath = fullfile(subjectDir(subjectIndex).folder,subjectDir(subjectIndex).name);
        
        if fullMode == 0 % run it for one task
            runName = [subjectDir(subjectIndex).name, '_task-dis_run-04_bold'];
            DCMRunOnSubject_noModulation(subjectPath, runName);
            runName = [subjectDir(subjectIndex).name, '_task-dis_run-05_bold'];
            DCMRunOnSubject_noModulation(subjectPath, runName);
            runName = [subjectDir(subjectIndex).name, '_task-dis_run-06_bold'];
            DCMRunOnSubject_noModulation(subjectPath, runName);
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