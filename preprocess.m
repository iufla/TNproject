%preprocesses all the data in the sub-xx folders in the given directory
% first it extracts all the .gz-files, than it continues with preprocessing the Nii-Files,
% after that it adjusts the
% textfiles and then it extracts the task specifications

pathBase = what('TNProject');
pathBase = pathBase.path;
pathBase = fullfile(pathBase, 'data');

dFunc = dir([pathBase,'sub*/func/*.nii.gz']);
dAnat = dir([pathBase,'sub*/anat/*.nii.gz']);

d = [dFunc',dAnat'];

for f=1:numel(d)
    file = fullfile(d(f).folder,d(f).name);
    gunzip(file);
    delete(file);
end

%preprocesses the Nii data

dirs = dir([pathBase,'sub*']);

for f=1:numel(dirs)
    preprocessNiiData(fullfile(pathBase,dirs(f).name))
end

%makes all the.txt-files right

for f=1:numel(dirs)
    subject = dirs(f).name;
    preprocessedFunc = fullfile(pathBase, subject, 'preprocessed', 'func');
    txtDir = dir(fullfile(preprocessedFunc, 'rp*.txt'));
    M = dlmread(fullfile(txtDir.folder, txtDir.name));

    si = size(M,1);
    batchSize = 166;
    if mod(si, batchSize) ~= 0
        warning('%s', subject)
    end
    for i = 1:6
        filename = [subject, '_task-dis_run-',num2str(i, '%02d'),'_bold', '.txt'];
        part = M((i-1)*batchSize+1:i*batchSize,:);
        dlmwrite(fullfile(preprocessedFunc, filename), part,'delimiter','\t', 'precision', '%.7e');
    end
end

% pro preprocessed folder 1 struct mit diesen vier arrays

dirs = dir([pathBase,'sub*/func/*task-dis_run*.tsv']);

for f=1:numel(dirs)
    filename = dirs(f).name;
    folder = dirs(f).folder;
    struct = readTaskSpecs(fullfile(folder, filename));
    
    preprocessedFolder = strrep(folder, '/func', '/preprocessed/func');
    structName = strrep(filename,'tsv','mat');
    save(fullfile(preprocessedFolder,structName),'struct');
end