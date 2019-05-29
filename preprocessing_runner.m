% preprocesses all the data in the sub-xx folders in the given directory
% first it extracts all the .gz-files, than it continues with preprocessing the Nii-Files,
% after that it adjusts the
% textfiles and then it extracts the task specifications

pathBase = what('TNproject');
pathBase = pathBase.path;
pathBase = fullfile(pathBase, 'data');

dFunc = dir(fullfile(pathBase,'sub*/func/*.nii.gz'));
dAnat = dir(fullfile(pathBase,'sub*/anat/*.nii.gz'));

d = [dFunc',dAnat'];

% unpack all data

for f=1:numel(d)
    file = fullfile(d(f).folder,d(f).name);
    gunzip(file);
    delete(file);
end

sprintf('==== unpacked all data ====')

%preprocesses the Nii data

dirs = dir(fullfile(pathBase,'sub*'));

for f=1:numel(dirs)
    % if the process got interrupted, we can begin with the given specs
    % number
    beginning = 100; %0, if not needed
    if str2num(strrep(dirs(f).name, 'sub-','')) < beginning
        sprintf("skipped %s", dirs(f).name)
    else
        preprocessNiiData(fullfile(pathBase,dirs(f).name))
    end
end

sprintf('==== processed all nii-data ====')

%makes all the.txt-files right

for f=1:numel(dirs)
    subject = dirs(f).name;
    preprocessedFunc = fullfile(pathBase, subject, 'preprocessed', 'func');
    txtDir = dir(fullfile(preprocessedFunc, 'rp*.txt'));
    if size(txtDir,1) == 0
        warning('skipped %s',subject)
        continue
    end
    M = dlmread(fullfile(txtDir.folder, txtDir.name));

    si = size(M,1);
    batchSize = 166;
    if mod(si, batchSize) ~= 0
        warning('wrong number of lines in txt-file %s', subject)
        continue
    end
    for i = 1:6
        filename = [subject, '_task-dis_run-',num2str(i, '%02d'),'_bold', '.txt'];
        part = M((i-1)*batchSize+1:i*batchSize,:);
        dlmwrite(fullfile(preprocessedFunc, filename), part,'delimiter','\t', 'precision', '%.7e');
    end
end

sprintf('==== processed all textfiles ====')

% preprocess taskSpecs, generate matlab structs from .tsv-files

dirs = dir(fullfile(pathBase,'sub*','func','*task-dis_run*.tsv'));

for f=1:numel(dirs)
    filename = dirs(f).name;
    folder = dirs(f).folder;
    struct = preprocessReadTaskSpecs(fullfile(folder, filename));
    
    preprocessedFolder = strrep(folder, '/func', '/preprocessed/func');
    structName = strrep(filename,'tsv','mat');
    save(fullfile(preprocessedFolder,structName),'struct');
end

sprintf('==== generated structs from tsv ====')
sprintf('======== Finished! ========')