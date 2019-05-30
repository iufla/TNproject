pathBase = what('TNproject');
pathBase = pathBase.path;
dataPath = fullfile(pathBase, 'data');

winningModelASD = 1;
winningModelNT = 2;

specs = helperReadParticipantSpecs();

clear matlabbatch;

outputPath = fullfile(dataPath, 'BMSandBMA','old','run-01_old');
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
% histogram(BMS_Overall.DCM.rfx.model.g_post(:,1),'BinMethod','auto','Normalization','probability','BinLimits',[0,1],'BinWidth',0.1)
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


asdWinner = 1;
ntWinner = 2;

samples_asd = [];
samples_nt = [];
samples_overall = [];
for n=1:30000
    samples_asd = [samples_asd;gamrnd(BMS_ASD.DCM.rfx.model.alpha,1)];
    samples_nt = [samples_nt;gamrnd(BMS_NT.DCM.rfx.model.alpha,1)];
    samples_overall = [samples_overall;gamrnd(BMS_Overall.DCM.rfx.model.alpha,1)];
end
samples_norm_asd = samples_asd;
samples_norm_nt = samples_nt;
samples_norm_overall = samples_overall;
for m=1:30000
    samples_norm_asd(m,:) = samples_asd(m,:)./sum(samples_asd(m,:));
    samples_norm_nt(m,:) = samples_nt(m,:)./sum(samples_nt(m,:));
    samples_norm_overall(m,:) = samples_overall(m,:)./sum(samples_overall(m,:));
end
figure
ha = histogram(samples_norm_asd(:,asdWinner),'normalization','pdf')
hold on
hn = histogram(samples_norm_nt(:,asdWinner),'normalization','pdf')
ho = histogram(samples_norm_overall(:,asdWinner),'normalization','pdf')
legend('ASD','NT','Overall')

pa = fitdist(samples_norm_asd(:,asdWinner),'kernel')
pn = fitdist(samples_norm_nt(:,asdWinner),'kernel')
po = fitdist(samples_norm_overall(:,asdWinner),'kernel')
% figure
figure
plot(0:0.0001:1,pdf(pa,0:0.0001:1),'lineWidth',2,'color','red')
hold on
plot(0:0.0001:1,pdf(pn,0:0.0001:1),'lineWidth',2,'color','blue')
plot(0:0.0001:1,pdf(po,0:0.0001:1),'lineWidth',2,'color',[0.65 0.65 0.65])
line([0.5 0.5],get(gca,'YLim'),'LineStyle','--','color',[0.5 0.5 0.5])


figure
ha = histogram(samples_norm_asd(:,ntWinner),'normalization','pdf')
hold on
hn = histogram(samples_norm_nt(:,ntWinner),'normalization','pdf')
ho = histogram(samples_norm_overall(:,asdWinner),'normalization','pdf')
legend('ASD','NT','Overall')

pa = fitdist(samples_norm_asd(:,ntWinner),'kernel')
pn = fitdist(samples_norm_nt(:,ntWinner),'kernel')
po = fitdist(samples_norm_overall(:,ntWinner),'kernel')
% figure
figure
plot(0:0.0001:1,pdf(pa,0:0.0001:1),'lineWidth',2,'color','red')
hold on
plot(0:0.0001:1,pdf(pn,0:0.0001:1),'lineWidth',2,'color','blue')
plot(0:0.0001:1,pdf(po,0:0.0001:1),'lineWidth',2,'color',[0.65 0.65 0.65])
line([0.5 0.5],get(gca,'YLim'),'LineStyle','--','color',[0.5 0.5 0.5])
ylabel('Dirichlet Probability Density')
legend('ASD','NT','Overall')