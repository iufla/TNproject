pathBase = what('TNproject');
pathBase = pathBase.path;

move = 0;  % set to 1 if you want to move files instead of copying them

condensedDataFolderName = 'condensed_data';
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
