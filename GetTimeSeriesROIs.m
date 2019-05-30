regions = struct();

% specify ROI coordinates as [x,y,z] arrays
% size is radius of sphere around [x,y,z] centre coordinates
regions(1).name = 'MPFC';
regions(1).coordinates = [4.5, 49, 27.5];
regions(1).size = 9;
regions(end+1).name = 'LTPJ';
regions(end).coordinates = [-51, -56, 24];
regions(end).size = 9;    % largest possible value such that still inside
regions(end+1).name = 'RTPJ';
regions(end).coordinates = [54, -54, 23];
regions(end).size = 9;
regions(end+1).name = 'PREC';
regions(end).coordinates = [0.5, -56, 34];
regions(end).size = 9;

spm('defaults','FMRI')

pathBase = what('TNproject');
pathBase = pathBase.path;

pathBase = fullfile(pathBase, 'data');
subjects = dir(fullfile(pathBase,'sub*'));

for f=1:numel(subjects)
    subjectPath = fullfile(pathBase,subjects(f).name);
    
    filenames = dir(fullfile(subjectPath, 'func', '*dis*.nii'));
    
    glmPath = fullfile(subjectPath, 'GLM');
       
    for i=1:numel(filenames)
        fileNameBase = strrep(filenames(i).name, '.nii', '');
        glmPathTask = fullfile(glmPath, fileNameBase);
        GetTimeSeriesForFile(pathBase,glmPathTask,regions);
    end
end