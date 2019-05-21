pathBase = 'TNProject/data/';

dFunc = dir([pathBase,'sub*/func/*.nii.gz']);
dAnat = dir([pathBase,'sub*/anat/*.nii.gz']);

d = [dFunc',dAnat'];

for f=1:numel(d)
    file = fullfile(d(f).folder,d(f).name);
    gunzip(file);
    delete(file);
end
