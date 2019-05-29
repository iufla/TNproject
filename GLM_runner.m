spm('defaults','FMRI')

pathBase = what('TNproject');
pathBase = pathBase.path;
pathBase = fullfile(pathBase, 'data');
subjects = dir(fullfile(pathBase,'sub*'));

for f=1:numel(subjects)
    path = fullfile(pathBase,subjects(f).name);
    
    filenames = dir(fullfile(path, 'func', '*dis*.nii'));
    
    for i=1:numel(filenames)
        GLMRunOnSubject(pathBase,path, filenames(i).name);
    end
end

GLMGetTimeSeriesROIs();