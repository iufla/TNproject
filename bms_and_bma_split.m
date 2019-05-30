pathBase = what('TNproject');
pathBase = pathBase.path;
dataPath = fullfile(pathBase, 'data');

run = 2;
runString = ['run-',num2str(run,'%02d')];

specs = preprocessReadParticipantSpecs();

clear matlabbatch;

outputPath = fullfile(dataPath, 'BMSandBMA');
mkdir(outputPath);

outputPath = fullfile(outputPath, runString);
mkdir(outputPath);

outputPathNT = fullfile(outputPath, 'NT');
mkdir(outputPathNT);

outputPathASD = fullfile(outputPath, 'ASD');
mkdir(outputPathASD);

outputPathsNT = cell(0,0);
outputPathsASD = cell(0,0);
for n=1:5
    tmpPathNT = fullfile(outputPathNT,num2str(n,'%02d'));
    outputPathsNT(n) = {tmpPathNT};
    mkdir(tmpPathNT); 
    tmpPathASD = fullfile(outputPathASD,num2str(n,'%02d'));
    outputPathsASD(n) = {tmpPathASD};
    mkdir(tmpPathASD); 
end

matlabbatch{1}.spm.dcm.bms.inference.dir = outputPathsNT(1);
matlabbatch{2}.spm.dcm.bms.inference.dir = outputPathsNT(2);
matlabbatch{3}.spm.dcm.bms.inference.dir = outputPathsNT(3);
matlabbatch{4}.spm.dcm.bms.inference.dir = outputPathsNT(4);
matlabbatch{5}.spm.dcm.bms.inference.dir = outputPathsNT(5);

matlabbatch{6}.spm.dcm.bms.inference.dir = outputPathsASD(1);
matlabbatch{7}.spm.dcm.bms.inference.dir = outputPathsASD(2);
matlabbatch{8}.spm.dcm.bms.inference.dir = outputPathsASD(3);
matlabbatch{9}.spm.dcm.bms.inference.dir = outputPathsASD(4);
matlabbatch{10}.spm.dcm.bms.inference.dir = outputPathsASD(5);

subjects = dir(fullfile(dataPath, 'sub*'));

asdCount = 0;
ntCount = 0;
for subject = 1:numel(subjects)
    subj = subjects(subject);
    subjectPath = fullfile(subj.folder, subj.name);
    dcms = dir(fullfile(subjectPath, 'DCM', ['*',runString,'*'], 'DCM_estimated*'));
    dcmmat = cell(numel(dcms), 1);
    DCMY_ref = struct();
    for dcm = 1:numel(dcms)
        dcmDir = dcms(dcm);
        dcmmat{dcm} = fullfile(dcmDir.folder, dcmDir.name);
%         DCM = load(fullfile(dcmDir.folder, dcmDir.name));
%         DCM = DCM.DCM;
%         if dcm > 15
% %         if isempty(strfind(DCM.xY(1).spec.fname,'steeve'))
%             try
%                 DCM.Y = DCMY_ref;
% %                 for i=1:3
% %                     DCM.xY(i).spec.fname = strrep(DCM.xY(i).spec.fname,'/media/nina/Seagate Expansion Drive/TNU/data/','/Users/steeve/Documents/ETH/FS2019/Translational_Neuromodelling/Project/TNproject/data/');
% %                     disp(DCM.xY(i).spec.fname)
% %                     save(fullfile(dcmDir.folder, dcmDir.name),'DCM')
% %                 end
%                 save(fullfile(dcmDir.folder, dcmDir.name),'DCM')
%             catch
%                 warning('failed')
%             end
%         elseif dcm == 1
%             DCMY_ref = DCM.Y;
%         end
        
%         save(fullfile(dcmDir.folder, dcmDir.name),'DCM')
    end
    
    if ismember(subj.name, specs.ASD_names)
        asdCount = asdCount + 1;
        matlabbatch{6}.spm.dcm.bms.inference.sess_dcm{asdCount}.dcmmat = dcmmat;
        matlabbatch{7}.spm.dcm.bms.inference.sess_dcm{asdCount}.dcmmat = dcmmat;
        matlabbatch{8}.spm.dcm.bms.inference.sess_dcm{asdCount}.dcmmat = dcmmat;
        matlabbatch{9}.spm.dcm.bms.inference.sess_dcm{asdCount}.dcmmat = dcmmat;
        matlabbatch{10}.spm.dcm.bms.inference.sess_dcm{asdCount}.dcmmat = dcmmat;
    elseif ismember(subj.name, specs.NT_names)
        ntCount = ntCount + 1;
        matlabbatch{1}.spm.dcm.bms.inference.sess_dcm{ntCount}.dcmmat = dcmmat;
        matlabbatch{2}.spm.dcm.bms.inference.sess_dcm{ntCount}.dcmmat = dcmmat;
        matlabbatch{3}.spm.dcm.bms.inference.sess_dcm{ntCount}.dcmmat = dcmmat;
        matlabbatch{4}.spm.dcm.bms.inference.sess_dcm{ntCount}.dcmmat = dcmmat;
        matlabbatch{5}.spm.dcm.bms.inference.sess_dcm{ntCount}.dcmmat = dcmmat;
    else
        sprintf("Error!")
    end    
end

matlabbatch{1}.spm.dcm.bms.inference.model_sp = {''};
matlabbatch{1}.spm.dcm.bms.inference.load_f = {''};
matlabbatch{1}.spm.dcm.bms.inference.method = 'FFX';
matlabbatch{1}.spm.dcm.bms.inference.family_level.family_file = {''};
matlabbatch{1}.spm.dcm.bms.inference.bma.bma_yes.bma_famwin = 'famwin';
matlabbatch{1}.spm.dcm.bms.inference.verify_id = 0;

matlabbatch{2}.spm.dcm.bms.inference.model_sp = {''};
matlabbatch{2}.spm.dcm.bms.inference.load_f = {''};
matlabbatch{2}.spm.dcm.bms.inference.method = 'RFX';
matlabbatch{2}.spm.dcm.bms.inference.family_level.family_file = {''};
matlabbatch{2}.spm.dcm.bms.inference.bma.bma_yes.bma_famwin = 'famwin';
matlabbatch{2}.spm.dcm.bms.inference.verify_id = 0;

matlabbatch{3}.spm.dcm.bms.inference.model_sp = {''};
matlabbatch{3}.spm.dcm.bms.inference.load_f = {''};
matlabbatch{3}.spm.dcm.bms.inference.method = 'FFX';
matlabbatch{3}.spm.dcm.bms.inference.family_level.family(1).family_name = 'modulatory\_towards\_RTPJ';
matlabbatch{3}.spm.dcm.bms.inference.family_level.family(1).family_models = [2 3 4 5 6 9 10 11 12 13 15 16];
matlabbatch{3}.spm.dcm.bms.inference.family_level.family(2).family_name = 'selfmodulatory\_RTPJ';
matlabbatch{3}.spm.dcm.bms.inference.family_level.family(2).family_models = [1 7 8 14];
matlabbatch{3}.spm.dcm.bms.inference.family_level.family(3).family_name = 'no\_modulation';
matlabbatch{3}.spm.dcm.bms.inference.family_level.family(3).family_models = [17 18 19 20];
% matlabbatch{3}.spm.dcm.bms.inference.bma.bma_yes.bma_famwin = 'famwin';
matlabbatch{3}.spm.dcm.bms.inference.bma.bma_yes.bma_part = 1;  % take index of best family
matlabbatch{3}.spm.dcm.bms.inference.verify_id = 0;

matlabbatch{4}.spm.dcm.bms.inference.model_sp = {''};
matlabbatch{4}.spm.dcm.bms.inference.load_f = {''};
matlabbatch{4}.spm.dcm.bms.inference.method = 'RFX';
matlabbatch{4}.spm.dcm.bms.inference.family_level.family(1).family_name = 'modulatory\_towards\_RTPJ';
matlabbatch{4}.spm.dcm.bms.inference.family_level.family(1).family_models = [2 3 4 5 6 9 10 11 12 13 15 16];
matlabbatch{4}.spm.dcm.bms.inference.family_level.family(2).family_name = 'selfmodulatory\_RTPJ';
matlabbatch{4}.spm.dcm.bms.inference.family_level.family(2).family_models = [1 7 8 14];
matlabbatch{4}.spm.dcm.bms.inference.family_level.family(3).family_name = 'no\_modulation';
matlabbatch{4}.spm.dcm.bms.inference.family_level.family(3).family_models = [17 18 19 20];
% matlabbatch{4}.spm.dcm.bms.inference.bma.bma_yes.bma_famwin = 'famwin';
matlabbatch{4}.spm.dcm.bms.inference.bma.bma_yes.bma_part = 1;  % take index of best family
matlabbatch{4}.spm.dcm.bms.inference.verify_id = 0;

matlabbatch{5}.spm.dcm.bms.inference.model_sp = {''};
matlabbatch{5}.spm.dcm.bms.inference.load_f = {''};
matlabbatch{5}.spm.dcm.bms.inference.method = 'RFX';
matlabbatch{5}.spm.dcm.bms.inference.family_level.family(1).family_name = 'driving\_also\_towards\_RTPJ';
matlabbatch{5}.spm.dcm.bms.inference.family_level.family(1).family_models = [5 8 11 12 13 14 15 16 18 20];
matlabbatch{5}.spm.dcm.bms.inference.family_level.family(2).family_name = 'driving\_not\_towardsRTPJ';
matlabbatch{5}.spm.dcm.bms.inference.family_level.family(2).family_models = [1 2 3 4 6 7 9 10 17 19];
% matlabbatch{5}.spm.dcm.bms.inference.bma.bma_yes.bma_famwin = 'famwin';
matlabbatch{5}.spm.dcm.bms.inference.bma.bma_yes.bma_part = 1;  % take index of best family
matlabbatch{5}.spm.dcm.bms.inference.verify_id = 0;

matlabbatch{6}.spm.dcm.bms.inference.model_sp = {''};
matlabbatch{6}.spm.dcm.bms.inference.load_f = {''};
matlabbatch{6}.spm.dcm.bms.inference.method = 'FFX';
matlabbatch{6}.spm.dcm.bms.inference.family_level.family_file = {''};
matlabbatch{6}.spm.dcm.bms.inference.bma.bma_yes.bma_famwin = 'famwin';
matlabbatch{6}.spm.dcm.bms.inference.verify_id = 0;

matlabbatch{7}.spm.dcm.bms.inference.model_sp = {''};
matlabbatch{7}.spm.dcm.bms.inference.load_f = {''};
matlabbatch{7}.spm.dcm.bms.inference.method = 'RFX';
matlabbatch{7}.spm.dcm.bms.inference.family_level.family_file = {''};
matlabbatch{7}.spm.dcm.bms.inference.bma.bma_yes.bma_famwin = 'famwin';
matlabbatch{7}.spm.dcm.bms.inference.verify_id = 0;

matlabbatch{8}.spm.dcm.bms.inference.model_sp = {''};
matlabbatch{8}.spm.dcm.bms.inference.load_f = {''};
matlabbatch{8}.spm.dcm.bms.inference.method = 'RFX';
matlabbatch{8}.spm.dcm.bms.inference.family_level.family(1).family_name = 'modulatory\_towards\_RTPJ';
matlabbatch{8}.spm.dcm.bms.inference.family_level.family(1).family_models = [2 3 4 5 6 9 10 11 12 13 15 16];
matlabbatch{8}.spm.dcm.bms.inference.family_level.family(2).family_name = 'selfmodulatory\_RTPJ';
matlabbatch{8}.spm.dcm.bms.inference.family_level.family(2).family_models = [1 7 8 14];
matlabbatch{8}.spm.dcm.bms.inference.family_level.family(3).family_name = 'no\_modulation';
matlabbatch{8}.spm.dcm.bms.inference.family_level.family(3).family_models = [17 18 19 20];
% matlabbatch{8}.spm.dcm.bms.inference.bma.bma_yes.bma_famwin = 'famwin';
matlabbatch{8}.spm.dcm.bms.inference.bma.bma_yes.bma_part = 2;  % take index of best family
matlabbatch{8}.spm.dcm.bms.inference.verify_id = 0;

matlabbatch{9}.spm.dcm.bms.inference.model_sp = {''};
matlabbatch{9}.spm.dcm.bms.inference.load_f = {''};
matlabbatch{9}.spm.dcm.bms.inference.method = 'RFX';
matlabbatch{9}.spm.dcm.bms.inference.family_level.family(1).family_name = 'modulatory\_towards\_RTPJ';
matlabbatch{9}.spm.dcm.bms.inference.family_level.family(1).family_models = [2 3 4 5 6 9 10 11 12 13 15 16];
matlabbatch{9}.spm.dcm.bms.inference.family_level.family(2).family_name = 'selfmodulatory\_RTPJ';
matlabbatch{9}.spm.dcm.bms.inference.family_level.family(2).family_models = [1 7 8 14];
matlabbatch{9}.spm.dcm.bms.inference.family_level.family(3).family_name = 'no\_modulation';
matlabbatch{9}.spm.dcm.bms.inference.family_level.family(3).family_models = [17 18 19 20];
% matlabbatch{9}.spm.dcm.bms.inference.bma.bma_yes.bma_famwin = 'famwin';
matlabbatch{9}.spm.dcm.bms.inference.bma.bma_yes.bma_part = 2;  % take index of best family
matlabbatch{9}.spm.dcm.bms.inference.verify_id = 0;

matlabbatch{10}.spm.dcm.bms.inference.model_sp = {''};
matlabbatch{10}.spm.dcm.bms.inference.load_f = {''};
matlabbatch{10}.spm.dcm.bms.inference.method = 'RFX';
matlabbatch{10}.spm.dcm.bms.inference.family_level.family(1).family_name = 'driving\_also\_towards\_RTPJ';
matlabbatch{10}.spm.dcm.bms.inference.family_level.family(1).family_models = [5 8 11 12 13 14 15 16 18 20];
matlabbatch{10}.spm.dcm.bms.inference.family_level.family(2).family_name = 'driving\_not\_towardsRTPJ';
matlabbatch{10}.spm.dcm.bms.inference.family_level.family(2).family_models = [1 2 3 4 6 7 9 10 17 19];
% matlabbatch{10}.spm.dcm.bms.inference.bma.bma_yes.bma_famwin = 'famwin';
matlabbatch{10}.spm.dcm.bms.inference.bma.bma_yes.bma_part = 2;  % take index of best family
matlabbatch{10}.spm.dcm.bms.inference.verify_id = 0;

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