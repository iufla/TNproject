% Translational Neuromodeling Project, ETH Zurich
% 'Decoding moral judgements from neurotypical individuals compared to
% individuals with ASD'
%--------------------------------------------------------------------------
% authors: Stephan Boner, Alexander Hess, Nina Stumpf
% date: 2019-05-30
% version: 1.0
%--------------------------------------------------------------------------
% Customized script to preprocess fMRI data given in .nii files
% Input: String data_path specifying the location of the folders 'func' and
% 'anat' containing the functional resp. anatomical fMRI data.
%
% Mostly copied from the SPM example documented in
% http://www.fil.ion.ucl.ac.uk/spm/doc/manual.pdf#Chap:data:auditory
% Copyright (C) 2014 Wellcome Trust Centre for Neuroimaging, Guillaume Flandin
%==========================================================================

function preprocessNiiData(data_path)
    savePath = fullfile(data_path,'preprocessed');
    savePathFunc = fullfile(savePath, 'func');
    savePathAnat = fullfile(savePath, 'anat');
    mkdir(savePath);
    mkdir(savePathFunc);
    mkdir(savePathAnat);
    
    existingFiles = [dir(fullfile(data_path,'anat'))',dir(fullfile(data_path,'func'))'];

    % Initialise SPM
    %--------------------------------------------------------------------------
    spm('Defaults','fMRI');
    spm_jobman('initcfg');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % SPATIAL PREPROCESSING
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    f = spm_select('FPList', fullfile(data_path,'func'), '^sub.*(dis).*\.nii');
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

    % Move preprocessed files to separate folder
    currentlyExistingFilesAnat = dir(fullfile(data_path,'anat'))';
    for n=1:numel(currentlyExistingFilesAnat)
        if ~contains([existingFiles.name],currentlyExistingFilesAnat(n).name)
            movefile(fullfile(currentlyExistingFilesAnat(n).folder,currentlyExistingFilesAnat(n).name),savePathAnat);
        end
    end
    currentlyExistingFilesFunc = dir(fullfile(data_path,'func'))';
   for n=1:numel(currentlyExistingFilesFunc)
        if ~contains([existingFiles.name],currentlyExistingFilesFunc(n).name)
            movefile(fullfile(currentlyExistingFilesFunc(n).folder,currentlyExistingFilesFunc(n).name),savePathFunc);
        end
    end

end