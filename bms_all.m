pathBase = what('TNproject');
pathBase = pathBase.path;
dataPath = fullfile(pathBase, 'data');

clear matlabbatch;

outputPath = fullfile(dataPath, 'BMS');
mkdir(outputPath);

matlabbatch{1}.spm.dcm.bms.inference.dir = {outputPath};

subjects = dir(fullfile(dataPath, 'sub*'));

for subject = 1:numel(subjects)
    subj = subjects(subject);
    subjectPath = fullfile(subj.folder, subj.name);
    dcms = dir(fullfile(subjectPath, 'DCM', 'DCM_estimated*'));
    dcmmat = cell(numel(dcms), 1);
    for dcm = 1:numel(dcms)
        dcmDir = dcms(dcm);
        dcmmat{dcm} = fullfile(dcmDir.folder, dcmDir.name);
    end
    matlabbatch{1}.spm.dcm.bms.inference.sess_dcm{subject}.dcmmat = dcmmat;
end


matlabbatch{1}.spm.dcm.bms.inference.model_sp = {''};
matlabbatch{1}.spm.dcm.bms.inference.load_f = {''};
matlabbatch{1}.spm.dcm.bms.inference.method = 'RFX';
matlabbatch{1}.spm.dcm.bms.inference.family_level.family_file = {''};
matlabbatch{1}.spm.dcm.bms.inference.bma.bma_no = 0;
matlabbatch{1}.spm.dcm.bms.inference.verify_id = 1;


spm_jobman('run', matlabbatch);