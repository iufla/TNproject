regions = struct();

% specify ROI coordinates as [x,y,z] arrays
% size is radius of sphere around [x,y,z] centre coordinates
regions(1).name = 'MPFC';
regions(1).coordinates = [-6, 54, 32];
regions(1).size = 8;
regions(end+1).name = 'LTPJ';
regions(end).coordinates = [-52, -64, 20];
regions(end).size = 7.8;    % largest possible value such that still inside
regions(end+1).name = 'RTPJ';
regions(end).coordinates = [56, -46, 20];
regions(end).size = 8;
regions(end+1).name = 'PREC';
regions(end).coordinates = [2, -56, 40];
regions(end).size = 8;

spm('defaults','FMRI')

pathBase = what('TNproject');
pathBase = pathBase.path;

pathBase = fullfile(pathBase, 'data');
dirs = dir(fullfile(pathBase,'sub*'));

for f=1:numel(dirs)
    path = fullfile(pathBase,dirs(f).name);
    
    filenames = dir(fullfile(path, 'func', '*dis*.nii'));
    
    glmPath = fullfile(path, 'GLM');
       
    for i=1:numel(filenames)
        fileNameBase = strrep(filenames(i).name, '.nii', '');
        glmPathTask = fullfile(glmPath, fileNameBase);
        getTimeSeries(glmPathTask,regions);
    end
end