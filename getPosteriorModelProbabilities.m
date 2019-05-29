pathBase = what('TNproject');
pathBase = pathBase.path;
pathBase = fullfile(pathBase, 'data');

dcmsNumber = numel(dir(fullfile(pathBase,'sub-03','DCM', 'DCM_estimated*')));
subjectsDir = dir(fullfile(pathBase,'sub*'));

specs = readParticipantSpecs();

negativeFreeEnergySumsNT = zeros(dcmsNumber, 1);
negativeFreeEnergySumsASD = zeros(dcmsNumber, 1);

for f=1:numel(subjectsDir)
    path = fullfile(pathBase,subjectsDir(f).name, 'DCM');
    dcms = dir(fullfile(path, 'DCM_estimated*'));
    for i=1:numel(dcms)
        dcm = load(fullfile(path, dcms(i).name));
        if ismember(subjectsDir(f).name, specs.ASD_names)
            negativeFreeEnergySumsASD(i) = negativeFreeEnergySumsASD(i) + dcm.DCM.F;
        elseif ismember(subjectsDir(f).name, specs.NT_names)
            negativeFreeEnergySumsNT(i) = negativeFreeEnergySumsNT(i) + dcm.DCM.F;
        else
            sprintf("Error!")
        end
        
    end
end

%negativeFreeEnergySums = negativeFreeEnergySums(1:4);

negativeFreeEnergySumsNT = negativeFreeEnergySumsNT - max(negativeFreeEnergySumsNT)
negativeFreeEnergySumsASD = negativeFreeEnergySumsASD - max(negativeFreeEnergySumsASD)

% negativeFreeEnergySumsNT = negativeFreeEnergySumsNT / 16;
% negativeFreeEnergySumsASD = negativeFreeEnergySumsASD / 16;
posteriorProbabilityNT = exp(negativeFreeEnergySumsNT)./sum(exp(negativeFreeEnergySumsNT))
posteriorProbabilityASD = exp(negativeFreeEnergySumsASD)./sum(exp(negativeFreeEnergySumsASD))