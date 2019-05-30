pathBase = what('TNproject');
pathBase = pathBase.path;
dataPath = fullfile(pathBase, 'data');

specs = preprocessReadParticipantSpecs();

clear matlabbatch;

outputPath = fullfile(dataPath, 'BMS');
mkdir(outputPath);

outputPathNT = fullfile(outputPath, 'NT');
mkdir(outputPathNT);

outputPathASD = fullfile(outputPath, 'ASD');
mkdir(outputPathASD);

matlabbatch{1}.spm.dcm.bms.inference.dir = {outputPathNT};
matlabbatch{2}.spm.dcm.bms.inference.dir = {outputPathASD};

subjects = dir(fullfile(dataPath, 'sub*'));

asdCount = 0;
ntCount = 0;
for subject = 1:numel(subjects)
    subj = subjects(subject);
    subjectPath = fullfile(subj.folder, subj.name);
    
    dcmTaskFolders = dir(fullfile(subjectPath, 'DCM', 'sub*'));
    for task = 1:numel(dcmTaskFolders)
        taskFolder = fullfile(dcmTaskFolders(task).folder, dcmTaskFolders(task).name);
        dcms = dir(fullfile(taskFolder, 'DCM_estimated*'));
        dcmmat = cell(numel(dcms), 1);
        for dcm = 1:numel(dcms)
            dcmDir = dcms(dcm);
            dcmmat{dcm} = fullfile(dcmDir.folder, dcmDir.name);
        end
        
        if ismember(subj.name, specs.ASD_names)
            if task == 1
                asdCount = asdCount + 1;
            end
            matlabbatch{2}.spm.dcm.bms.inference.sess_dcm{asdCount}(task).dcmmat = dcmmat;
        elseif ismember(subj.name, specs.NT_names)
            if task == 1
                ntCount = ntCount + 1;
            end
            matlabbatch{1}.spm.dcm.bms.inference.sess_dcm{ntCount}(task).dcmmat = dcmmat;
        else
            sprintf("Error!")
        end   
    end    
end


matlabbatch{1}.spm.dcm.bms.inference.model_sp = {''};
matlabbatch{1}.spm.dcm.bms.inference.load_f = {''};
matlabbatch{1}.spm.dcm.bms.inference.method = 'RFX';
matlabbatch{1}.spm.dcm.bms.inference.family_level.family_file = {''};
matlabbatch{1}.spm.dcm.bms.inference.bma.bma_no = 0;
matlabbatch{1}.spm.dcm.bms.inference.verify_id = 1;

matlabbatch{2}.spm.dcm.bms.inference.model_sp = {''};
matlabbatch{2}.spm.dcm.bms.inference.load_f = {''};
matlabbatch{2}.spm.dcm.bms.inference.method = 'RFX';
matlabbatch{2}.spm.dcm.bms.inference.family_level.family_file = {''};
matlabbatch{2}.spm.dcm.bms.inference.bma.bma_no = 0;
matlabbatch{2}.spm.dcm.bms.inference.verify_id = 1;

batchNT = {matlabbatch{1}};
batchASD = {matlabbatch{2}};
spm_jobman('run', batchASD);
%spm_jobman('run', matlabbatch);
