pathBase = what('TNproject');
pathBase = pathBase.path;
pathBase = fullfile(pathBase, 'data');

dcmsNumber = numel(dir(fullfile(pathBase,'sub-03','DCM', 'DCM_estimated*')));
subjectsDir = dir(fullfile(pathBase,'sub*'));

% leave one DCM out (the winner-dcm of one group) to check if this task chooses the same model as the other then
% favorite model of NT: DCM_estimated_14.mat
% favorite model of ASD: DCM_estimated_15.mat
% dcmToIgnore = 'DCM_estimated_15.mat';
% if ~strcmp(dcmToIgnore, '')
%     dcmsNumber = dcmsNumber - 1;
% end

specs = readParticipantSpecs();

negativeFreeEnergySumsNT = zeros(dcmsNumber, 1);
negativeFreeEnergySumsASD = zeros(dcmsNumber, 1);

for f=1:numel(subjectsDir)
    path = fullfile(pathBase,subjectsDir(f).name, 'DCM');
    dcms = dir(fullfile(path, 'DCM_estimated*'));
    indexCorrection = 0;
    for i=1:numel(dcms)
        in = i - indexCorrection;
        if ~strcmp(dcms(i).name, dcmToIgnore)
            dcm = load(fullfile(path, dcms(i).name));
            if ismember(subjectsDir(f).name, specs.ASD_names)
                negativeFreeEnergySumsASD(in) = negativeFreeEnergySumsASD(in) + dcm.DCM.F;
            elseif ismember(subjectsDir(f).name, specs.NT_names)
                negativeFreeEnergySumsNT(in) = negativeFreeEnergySumsNT(in) + dcm.DCM.F;
            else
                sprintf("Error!")
            end
        else
            indexCorrection = 1;
        end
    end
end

avASD = negativeFreeEnergySumsASD / 16
avNT = negativeFreeEnergySumsNT / 16
%negativeFreeEnergySums = negativeFreeEnergySums(1:4);

% negativeFreeEnergySumsNT = negativeFreeEnergySumsNT - max(negativeFreeEnergySumsNT)
% negativeFreeEnergySumsASD = negativeFreeEnergySumsASD - max(negativeFreeEnergySumsASD)

% negativeFreeEnergySumsNT = negativeFreeEnergySumsNT / 16;
% negativeFreeEnergySumsASD = negativeFreeEnergySumsASD / 16;
% posteriorProbabilityNT = exp(negativeFreeEnergySumsNT)./sum(exp(negativeFreeEnergySumsNT))
% posteriorProbabilityASD = exp(negativeFreeEnergySumsASD)./sum(exp(negativeFreeEnergySumsASD))


% Best models
% ASD | NT
% 15  | 14
% 13  | 16
% 16  | 13
% 8   | 8
% 13  | 15