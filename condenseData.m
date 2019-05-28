pathBase = what('TNproject');
pathBase = pathBase.path;

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
    
    copyfile(fullfile(folderDir, 'GLM'), fullfile(destinationDir, 'GLM'));
    
    dcmFolderSource = fullfile(folderDir, 'DCM');
    if exist(dcmFolderSource, 'dir')
        copyfile(dcmFolderSource, fullfile(destinationDir, 'DCM'));
    end
end