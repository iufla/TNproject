spm('defaults','FMRI')

pathBase = what('TNproject');
pathBase = pathBase.path;
pathBase = fullfile(pathBase, 'data');
dirs = dir(fullfile(pathBase,'sub*'));

for f=1:numel(dirs)
    path = fullfile(pathBase,dirs(f).name);
    
    filenames = dir(fullfile(path, 'func', '*dis*.nii'));
    
    for i=1:numel(filenames)
        spm_glm_batch_job(path, filenames(i).name);
    end
end
