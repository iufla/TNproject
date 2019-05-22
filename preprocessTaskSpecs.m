% pro preprocessed folder 1 struct mit diesen vier arrays

pathBase = 'TNProject/data/';
dirs = dir([pathBase,'sub*/func/*task-dis_run*.tsv']);

for f=1:numel(dirs)
    filename = dirs(f).name;
    folder = dirs(f).folder;
    struct = readTaskSpecs(fullfile(folder, filename));
    
    preprocessedFolder = strrep(folder, '/func', '/preprocessed/func');
    structName = strrep(filename,'tsv','mat');
    save(fullfile(preprocessedFolder,structName),'struct');
end