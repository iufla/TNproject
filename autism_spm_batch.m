% This batch script analyses the Auditory fMRI dataset available from the 
% SPM website:
%   http://www.fil.ion.ucl.ac.uk/spm/data/auditory/
% as described in the SPM manual:
%   http://www.fil.ion.ucl.ac.uk/spm/doc/manual.pdf#Chap:data:auditory
%__________________________________________________________________________
% Copyright (C) 2014 Wellcome Trust Centre for Neuroimaging

% Guillaume Flandin
% $Id: auditory_spm12_batch.m 8 2014-09-29 18:11:56Z guillaume $

% Directory containing the Auditory data
%--------------------------------------------------------------------------
data_path = '/mypath/';
% data_path = '/home/nina/Downloads/TNU/Project/study_autism/example/';

% Initialise SPM
%--------------------------------------------------------------------------
spm('Defaults','fMRI');
spm_jobman('initcfg');
% spm_get_defaults('cmdline',true);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PREAMBLE: DUMMY SCANS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% f = spm_select('FPList', fullfile(data_path,''), '^f.*\.nii$') ;
% 
% clear matlabbatch
% 
% matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.parent = cellstr(data_path);
% matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.name = 'dummy';
% 
% matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_move.files = cellstr(f(1:12,:));
% matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_move.action.moveto = cellstr(fullfile(data_path,'dummy'));
% 
% spm_jobman('run',matlabbatch);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPATIAL PREPROCESSING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f = spm_select('FPList', fullfile(data_path,''), '^sub.*func.*\.nii$');
a = spm_select('FPList', fullfile(data_path,''), '^sub.*anat.*\.nii$');
% f = spm_select('FPList', fullfile(data_path,''), 'func.*\.nii$');
% a = spm_select('FPList', fullfile(data_path,''), 'anat.*\.nii$');

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

% spm_jobman('run',matlabbatch);
spm_jobman('interactive',matlabbatch);  % run spm interactively (batch editor)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GLM SPECIFICATION, ESTIMATION, INFERENCE, RESULTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f = spm_select('FPList', fullfile(data_path,''), '^sw.*\.nii$');

clear matlabbatch

% Output Directory
%--------------------------------------------------------------------------
matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.parent = cellstr(data_path);
matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.name = 'GLM';

% Model Specification
%--------------------------------------------------------------------------
% TODOs: 
% - check which parameter units SPM needs! (comments on the right are referring to dataset)
% - find out how slice timing information (in anat .json file) can be input
matlabbatch{2}.spm.stats.fmri_spec.dir = cellstr(fullfile(data_path,'GLM'));
matlabbatch{2}.spm.stats.fmri_spec.timing.units = 'scans';
matlabbatch{2}.spm.stats.fmri_spec.timing.RT = 2;           % RT = repetition time
% matlabbatch{2}.spm.stats.fmri_spec.timing.RT = 1.656;           % RT = response time (?) = time from stimulus onset until reaction, probably in seconds
matlabbatch{2}.spm.stats.fmri_spec.sess.scans = cellstr(f);
matlabbatch{2}.spm.stats.fmri_spec.sess.cond.name = 'active';
matlabbatch{2}.spm.stats.fmri_spec.sess.cond.onset = 12;        % given in seconds
matlabbatch{2}.spm.stats.fmri_spec.sess.cond.duration = 22;     % given in seconds

% Model Estimation
%--------------------------------------------------------------------------
matlabbatch{3}.spm.stats.fmri_est.spmmat = cellstr(fullfile(data_path,'GLM','SPM.mat'));

% Contrasts
%--------------------------------------------------------------------------
matlabbatch{4}.spm.stats.con.spmmat = cellstr(fullfile(data_path,'GLM','SPM.mat'));
matlabbatch{4}.spm.stats.con.consess{1}.tcon.name = '? > ?';
matlabbatch{4}.spm.stats.con.consess{1}.tcon.weights = [1 0];
matlabbatch{4}.spm.stats.con.consess{2}.tcon.name = '? > ?';
matlabbatch{4}.spm.stats.con.consess{2}.tcon.weights = [-1 0];

% Inference Results
%--------------------------------------------------------------------------
matlabbatch{5}.spm.stats.results.spmmat = cellstr(fullfile(data_path,'GLM','SPM.mat'));
matlabbatch{5}.spm.stats.results.conspec.contrasts = 1;
matlabbatch{5}.spm.stats.results.conspec.threshdesc = 'FWE';
matlabbatch{5}.spm.stats.results.conspec.thresh = 0.05;
matlabbatch{5}.spm.stats.results.conspec.extent = 0;
matlabbatch{5}.spm.stats.results.print = false;

% Rendering
%--------------------------------------------------------------------------
matlabbatch{6}.spm.util.render.display.rendfile = {fullfile(spm('Dir'),'canonical','cortex_20484.surf.gii')};
matlabbatch{6}.spm.util.render.display.conspec.spmmat = cellstr(fullfile(data_path,'GLM','SPM.mat'));
matlabbatch{6}.spm.util.render.display.conspec.contrasts = 1;
matlabbatch{6}.spm.util.render.display.conspec.threshdesc = 'FWE';
matlabbatch{6}.spm.util.render.display.conspec.thresh = 0.05;
matlabbatch{6}.spm.util.render.display.conspec.extent = 0;

% spm_jobman('run',matlabbatch);
spm_jobman('interactive',matlabbatch);
