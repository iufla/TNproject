% Translational Neuromodeling Project, ETH Zurich
% 'Decoding moral judgements from neurotypical individuals compared to
% individuals with ASD'
%--------------------------------------------------------------------------
% authors: Stephan Boner, Alexander Hess, Nina Stumpf
% date: 2019-05-30
% version: 1.0
%--------------------------------------------------------------------------
% This file is used to compare the 2 winning models from the 'BMS_runner.m'
% separately.
%==========================================================================


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

outputPathsNT = cell(0,0);
outputPathsASD = cell(0,0);
for n=1:2
    tmpPathNT = fullfile(outputPathNT,num2str(n,'%02d'));
    outputPathsNT(n) = {tmpPathNT};
    mkdir(tmpPathNT); 
    tmpPathASD = fullfile(outputPathASD,num2str(n,'%02d'));
    outputPathsASD(n) = {tmpPathASD};
    mkdir(tmpPathASD); 
    tmpPathOverall = fullfile(outputPathOverall,num2str(n,'%02d'));
    outputPathsOverall(n) = {tmpPathOverall};
    mkdir(tmpPathOverall); 
end

matlabbatch{1}.spm.dcm.bms.inference.dir = outputPathsNT(1);
matlabbatch{2}.spm.dcm.bms.inference.dir = outputPathsNT(2);

matlabbatch{3}.spm.dcm.bms.inference.dir = outputPathsASD(1);
matlabbatch{4}.spm.dcm.bms.inference.dir = outputPathsASD(2);

matlabbatch{5}.spm.dcm.bms.inference.dir = outputPathsOverall(1);
matlabbatch{6}.spm.dcm.bms.inference.dir = outputPathsOverall(2);

subjects = dir(fullfile(dataPath, 'sub*'));

asdCount = 0;
ntCount = 0;
for subject = 1:numel(subjects)
    subj = subjects(subject);
    subjectPath = fullfile(subj.folder, subj.name);
    dcms = dir(fullfile(subjectPath, 'DCM', '*_task-dis_run-01_bold', 'DCM_estimated*'));
    dcmmat = cell(2, 1);
    
    dcmDirASD = dcms(winningModelASD);
    dcmmat{1} = fullfile(dcmDirASD.folder, dcmDirASD.name);
    dcmDirNT = dcms(winningModelNT);
    dcmmat{2} = fullfile(dcmDirNT.folder, dcmDirNT.name);
    
    if ismember(subj.name, specs.ASD_names)
        asdCount = asdCount + 1;
        matlabbatch{3}.spm.dcm.bms.inference.sess_dcm{asdCount}.dcmmat = dcmmat;
        matlabbatch{4}.spm.dcm.bms.inference.sess_dcm{asdCount}.dcmmat = dcmmat;
        matlabbatch{5}.spm.dcm.bms.inference.sess_dcm{asdCount+ntCount}.dcmmat = dcmmat;
        matlabbatch{6}.spm.dcm.bms.inference.sess_dcm{asdCount+ntCount}.dcmmat = dcmmat;
    elseif ismember(subj.name, specs.NT_names)
        ntCount = ntCount + 1;
        matlabbatch{1}.spm.dcm.bms.inference.sess_dcm{ntCount}.dcmmat = dcmmat;
        matlabbatch{2}.spm.dcm.bms.inference.sess_dcm{ntCount}.dcmmat = dcmmat;
        matlabbatch{5}.spm.dcm.bms.inference.sess_dcm{asdCount+ntCount}.dcmmat = dcmmat;
        matlabbatch{6}.spm.dcm.bms.inference.sess_dcm{asdCount+ntCount}.dcmmat = dcmmat;
    else
        sprintf("Error!")
    end    
end

matlabbatch{1}.spm.dcm.bms.inference.model_sp = {''};
matlabbatch{1}.spm.dcm.bms.inference.load_f = {''};
matlabbatch{1}.spm.dcm.bms.inference.method = 'FFX';
matlabbatch{1}.spm.dcm.bms.inference.family_level.family_file = {''};
matlabbatch{1}.spm.dcm.bms.inference.bma.bma_yes.bma_famwin = 'famwin';
matlabbatch{1}.spm.dcm.bms.inference.verify_id = 1;

matlabbatch{2}.spm.dcm.bms.inference.model_sp = {''};
matlabbatch{2}.spm.dcm.bms.inference.load_f = {''};
matlabbatch{2}.spm.dcm.bms.inference.method = 'RFX';
matlabbatch{2}.spm.dcm.bms.inference.family_level.family_file = {''};
matlabbatch{2}.spm.dcm.bms.inference.bma.bma_yes.bma_famwin = 'famwin';
matlabbatch{2}.spm.dcm.bms.inference.verify_id = 1;

matlabbatch{3}.spm.dcm.bms.inference.model_sp = {''};
matlabbatch{3}.spm.dcm.bms.inference.load_f = {''};
matlabbatch{3}.spm.dcm.bms.inference.method = 'FFX';
matlabbatch{3}.spm.dcm.bms.inference.family_level.family_file = {''};
matlabbatch{3}.spm.dcm.bms.inference.bma.bma_yes.bma_famwin = 'famwin';
matlabbatch{3}.spm.dcm.bms.inference.verify_id = 1;

matlabbatch{4}.spm.dcm.bms.inference.model_sp = {''};
matlabbatch{4}.spm.dcm.bms.inference.load_f = {''};
matlabbatch{4}.spm.dcm.bms.inference.method = 'RFX';
matlabbatch{4}.spm.dcm.bms.inference.family_level.family_file = {''};
matlabbatch{4}.spm.dcm.bms.inference.bma.bma_yes.bma_famwin = 'famwin';
matlabbatch{4}.spm.dcm.bms.inference.verify_id = 1;

matlabbatch{5}.spm.dcm.bms.inference.model_sp = {''};
matlabbatch{5}.spm.dcm.bms.inference.load_f = {''};
matlabbatch{5}.spm.dcm.bms.inference.method = 'FFX';
matlabbatch{5}.spm.dcm.bms.inference.family_level.family_file = {''};
matlabbatch{5}.spm.dcm.bms.inference.bma.bma_yes.bma_famwin = 'famwin';
matlabbatch{5}.spm.dcm.bms.inference.verify_id = 1;

matlabbatch{6}.spm.dcm.bms.inference.model_sp = {''};
matlabbatch{6}.spm.dcm.bms.inference.load_f = {''};
matlabbatch{6}.spm.dcm.bms.inference.method = 'RFX';
matlabbatch{6}.spm.dcm.bms.inference.family_level.family_file = {''};
matlabbatch{6}.spm.dcm.bms.inference.bma.bma_yes.bma_famwin = 'famwin';
matlabbatch{6}.spm.dcm.bms.inference.verify_id = 1;

for n=1:numel(matlabbatch)
    spm_jobman('run', matlabbatch(n));
    saveDir = matlabbatch{n}.spm.dcm.bms.inference.dir{:};
    nPlots = 0;
    figures = findall(0,'type','figure');
    for m=1:numel(figures)
        if strcmp(figures(m).Tag,'Graphics')
            nPlots = nPlots + 1;
            saveas(figures(m),fullfile(saveDir,['resultsPlot_',num2str(nPlots),'.fig']));
        end
    end
    spm_dcm_bma_results(fullfile(saveDir,'BMS.mat'),lower(matlabbatch{n}.spm.dcm.bms.inference.method));
    figures = findall(0,'type','figure');
    for m=1:numel(figures)
        if strcmp(figures(m).Tag,'Graphics')
            nPlots = nPlots + 1;
            saveas(figures(m),fullfile(saveDir,['resultsPlot_',num2str(nPlots),'.fig']));
        end
    end
end