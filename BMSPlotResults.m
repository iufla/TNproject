pathBase = what('TNproject');
pathBase = pathBase.path;
dataPath = fullfile(pathBase, 'data');

winningModelASD = 1;
winningModelNT = 14;

specs = helperReadParticipantSpecs();

clear matlabbatch;

outputPath = fullfile(dataPath, 'BMSandBMA');
mkdir(outputPath);

outputPathNT = fullfile(outputPath, 'NT_WinnerComparison');
mkdir(outputPathNT);

outputPathASD = fullfile(outputPath, 'ASD_WinnerComparison');
mkdir(outputPathASD);

outputPathOverall = fullfile(outputPath, 'Overall_WinnerComparison');
mkdir(outputPathOverall);

BMS_ASD = load(fullfile(outputPathASD,'02','BMS.mat'));
BMS_ASD = BMS_ASD.BMS;
BMS_NT = load(fullfile(outputPathNT,'02','BMS.mat'));
BMS_NT = BMS_NT.BMS;
BMS_Overall = load(fullfile(outputPathOverall,'02','BMS.mat'));
BMS_Overall = BMS_Overall.BMS;

% plot model posterior probabilities
figure
hold on
histogram(BMS_ASD.DCM.rfx.model.g_post(:,1),'BinMethod','auto','Normalization','probability','BinLimits',[0,1],'BinWidth',0.1)
histogram(BMS_NT.DCM.rfx.model.g_post(:,1),'BinMethod','auto','Normalization','probability','BinLimits',[0,1],'BinWidth',0.1)
histogram(BMS_Overall.DCM.rfx.model.g_post(:,1),'BinMethod','auto','Normalization','probability','BinLimits',[0,1],'BinWidth',0.1)
title('Posterior Model Probabilities')
legend('ASD','NT','Overall')

% plot fitted group model posterior Normal distributions
normal_ASD = fitdist(BMS_ASD.DCM.rfx.model.g_post(:,1),'Normal');
normal_NT = fitdist(BMS_NT.DCM.rfx.model.g_post(:,1),'Normal');
normal_Overall = fitdist(BMS_Overall.DCM.rfx.model.g_post(:,1),'Normal');
figure
hold on 
x = 0:0.05:1;
plot(x,[normal_ASD.pdf(x);normal_NT.pdf(x);normal_Overall.pdf(x)])
title('Posterior Model Probabilities')
legend('ASD','NT','Overall')