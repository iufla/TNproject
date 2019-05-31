% Translational Neuromodeling Project, ETH Zurich
% 'Decoding moral judgements from neurotypical individuals compared to
% individuals with ASD'
%--------------------------------------------------------------------------
% authors: Stephan Boner, Alexander Hess, Nina Stumpf
% date: 2019-05-30
% version: 1.0
%--------------------------------------------------------------------------
% This file iterates through all subjects specified in the folder in line
% 26 and takes the GLM & DCM folders and stores the data in a new folder
% (specified in line 22).
% In line 20, specify whether you want to copy the files or move them into
% the new folder.
%==========================================================================


pathBase = what('TNproject');
pathBase = pathBase.path;

move = 0;  % set to 1 if you want to move files instead of copying them

condensedDataFolderName = 'condensed_data_backup';
mkdir(pathBase, condensedDataFolderName);
condensedDataPath = fullfile(pathBase, condensedDataFolderName);

subsDir = dir(fullfile(pathBase, 'data', 'sub*'));

for i = 1:numel(subsDir)
    sub = subsDir(i);
    folderName = sub.name;
    folderDir = fullfile(sub.folder, folderName);
    mkdir(condensedDataPath, folderName);
    destinationDir = fullfile(condensedDataPath, folderName);
    dcmFolderSource = fullfile(folderDir, 'DCM');
    
    try
        if move
            movefile(fullfile(folderDir, 'GLM'), fullfile(destinationDir, 'GLM'));
            movefile(dcmFolderSource, fullfile(destinationDir, 'DCM'));
        else
            copyfile(fullfile(folderDir, 'GLM'), fullfile(destinationDir, 'GLM'));
            copyfile(dcmFolderSource, fullfile(destinationDir, 'DCM'));
        end
    catch e
        warning(e.message)
    end
end
