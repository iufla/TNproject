%preprocesses all the data in the sub-xx folders in the given directory

%preprocessNiiData('TNProject/data/sub-03-test')

pathBase = 'TNProject/data/';
dirs = dir([pathBase,'sub*']);

for f=1:numel(dirs)
    preprocessNiiData(fullfile(pathBase,dirs(f).name))
end
