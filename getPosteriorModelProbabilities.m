pathBase = what('TNproject');
pathBase = pathBase.path;
pathBase = fullfile(pathBase, 'data');

dcmsNumber = numel(dir(fullfile(pathBase,'sub-03','DCM', 'DCM_estimated*')));
subjectsDir = dir(fullfile(pathBase,'sub*'));

negativeFreeEnergySums = zeros(dcmsNumber, 1);

for f=1:numel(subjectsDir)
    path = fullfile(pathBase,subjectsDir(f).name, 'DCM');
    dcms = dir(fullfile(path, 'DCM_estimated*'));
    for i=1:numel(dcms)
        dcm = load(fullfile(path, dcms(i).name));
        negativeFreeEnergySums(i) = negativeFreeEnergySums(i) + dcm.DCM.F;
    end
end

%negativeFreeEnergySums = negativeFreeEnergySums(1:4);

negativeFreeEnergySums = negativeFreeEnergySums - max(negativeFreeEnergySums);
%negativeFreeEnergySums = negativeFreeEnergySums / 100;
posteriorProbability = exp(negativeFreeEnergySums)./sum(exp(negativeFreeEnergySums))