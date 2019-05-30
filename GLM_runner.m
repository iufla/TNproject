% Translational Neuromodeling Project, ETH Zurich
% 'Decoding moral judgements from neurotypical individuals compared to
% individuals with ASD'
%--------------------------------------------------------------------------
% authors: Stephan Boner, Alexander Hess, Nina Stumpf
% date: 2019-05-30
% version: 1.0
%--------------------------------------------------------------------------
% This file builds a GLM for every run of the 'dis' task of every subject 
% with the regressors specified in 'GLMRunOnSubject.m'.
% Upon completion of the GLM, the time-series for the our ROIs are
% extracted by calling 'GetTimeSeriesROIs.m'.
%
% This file calls: 'GLMRunOnSubject.m', 'GetTimeSeriesROIs.m' (which in
% turn calls 'GetTimeSeriesForFile.m')
%==========================================================================


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

GetTimeSeriesROIs();