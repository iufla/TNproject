% Script to preprocess fMRI data given in .nii files
% Input: String data_path specifying the location of the folders 'func' and 'anat'
% containing the functional resp. anatomical fMRI data.
%
% Mostly copied from the SPM example documented in
% http://www.fil.ion.ucl.ac.uk/spm/doc/manual.pdf#Chap:data:auditory
% Copyright (C) 2014 Wellcome Trust Centre for Neuroimaging, Guillaume Flandin
%
function preprocessNiiData(data_path)
    savePath = fullfile(data_path,'preprocessed');
    mkdir(savePath);
    existingFiles = [dir(fullfile(data_path,'anat'))',dir(fullfile(data_path,'func'))'];

    % Initialise SPM
    %--------------------------------------------------------------------------
    spm('Defaults','fMRI');
    spm_jobman('initcfg');
    % spm_get_defaults('cmdline',true);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % SPATIAL PREPROCESSING
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    f = spm_select('FPList', fullfile(data_path,'func'), '^sub.*\.nii$');
    a = spm_select('FPList', fullfile(data_path,'anat'), '^sub.*\.nii$');

    clear matlabbatch

    % Realign
    %--------------------------------------------------------------------------
    matlabbatch{1}.spm.spatial.realign.estwrite.data = {cellstr(f)};
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [0 1];

    % Coregister
    %--------------------------------------------------------------------------
    matlabbatch{2}.spm.spatial.coreg.estimate.ref    = cellstr(spm_file(f(1,:),'prefix','mean'));
    matlabbatch{2}.spm.spatial.coreg.estimate.source = cellstr(a);

    % Segment
    %--------------------------------------------------------------------------
    matlabbatch{3}.spm.spatial.preproc.channel.vols  = cellstr(a);
    matlabbatch{3}.spm.spatial.preproc.channel.write = [0 1];
    matlabbatch{3}.spm.spatial.preproc.warp.write    = [0 1];

    % Normalise: Write
    %--------------------------------------------------------------------------
    matlabbatch{4}.spm.spatial.normalise.write.subj.def      = cellstr(spm_file(a,'prefix','y_','ext','nii'));
    matlabbatch{4}.spm.spatial.normalise.write.subj.resample = cellstr(f);
    matlabbatch{4}.spm.spatial.normalise.write.woptions.vox  = [3 3 3];

    matlabbatch{5}.spm.spatial.normalise.write.subj.def      = cellstr(spm_file(a,'prefix','y_','ext','nii'));
    matlabbatch{5}.spm.spatial.normalise.write.subj.resample = cellstr(spm_file(a,'prefix','m','ext','nii'));
    matlabbatch{5}.spm.spatial.normalise.write.woptions.vox  = [1 1 3];

    % Smooth
    %--------------------------------------------------------------------------
    matlabbatch{6}.spm.spatial.smooth.data = cellstr(spm_file(f,'prefix','w'));
    matlabbatch{6}.spm.spatial.smooth.fwhm = [6 6 6];
    
    % Run all the configured steps
    spm_jobman('run',matlabbatch);
%     spm_jobman('interactive',matlabbatch);  % run spm interactively (batch editor)

    % move preprocessed files to separate folder
    currentlyExistingFiles = [dir(fullfile(data_path,'anat'))',dir(fullfile(data_path,'func'))'];
    for n=1:numel(currentlyExistingFiles)
        if ~contains([existingFiles.name],currentlyExistingFiles(n).name)
            movefile(fullfile(currentlyExistingFiles(n).folder,currentlyExistingFiles(n).name),savePath);
        end
    end
end