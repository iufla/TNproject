%-----------------------------------------------------------------------
% Job saved on 21-May-2019 14:15:02 by cfg_util (rev $Rev: 7345 $)
% spm SPM - SPM12 (7487)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------

% filePath: points to the directory with the subject data .../sub-03
% filename: name of the raw file

function spm_glm_batch_job(pathBase, subjectPath, fileName)
    try
        fileNameBase = strrep(fileName, '.nii', '');
        glmPath = fullfile(subjectPath, 'GLM');
        matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.parent = {glmPath};
        matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.name = fileNameBase;
        matlabbatch{2}.spm.stats.fmri_spec.dir = {fullfile(glmPath, fileNameBase)};
        matlabbatch{2}.spm.stats.fmri_spec.timing.units = 'secs';
        matlabbatch{2}.spm.stats.fmri_spec.timing.RT = 2;
        matlabbatch{2}.spm.stats.fmri_spec.timing.fmri_t = 32;
        matlabbatch{2}.spm.stats.fmri_spec.timing.fmri_t0 = 16;
        matlabbatch{2}.spm.stats.fmri_spec.sess.scans = {fullfile(subjectPath, 'preprocessed', 'func',['sw',fileName])};

        taskSpecs = load(fullfile(subjectPath, 'preprocessed', 'func', [strrep(fileNameBase, 'bold', 'events'), '.mat']));
        taskSpecs = taskSpecs.struct;
        matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).name = 'harmful action';
        matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).onset = taskSpecs.onsetsHarm;
        matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).duration = taskSpecs.durationsHarm;
        matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
        matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).orth = 1;
        matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).name = 'accidental harmful action';
        matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).onset = taskSpecs.onsetsAccidental;
        matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).duration = taskSpecs.durationsAccidental;
        matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
        matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).orth = 1;
        matlabbatch{2}.spm.stats.fmri_spec.sess.multi = {''};
        matlabbatch{2}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});

        txtDir = dir(fullfile(subjectPath, 'preprocessed', 'func',[fileNameBase, '.txt']));
        matlabbatch{2}.spm.stats.fmri_spec.sess.multi_reg = {fullfile(txtDir.folder, txtDir.name)};
        matlabbatch{2}.spm.stats.fmri_spec.sess.hpf = 128;
        matlabbatch{2}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
        matlabbatch{2}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
        matlabbatch{2}.spm.stats.fmri_spec.volt = 1;
        matlabbatch{2}.spm.stats.fmri_spec.global = 'None';
        matlabbatch{2}.spm.stats.fmri_spec.mthresh = 0.8;
        matlabbatch{2}.spm.stats.fmri_spec.mask = {''};
        matlabbatch{2}.spm.stats.fmri_spec.cvi = 'AR(1)';
        matlabbatch{3}.spm.stats.fmri_est.spmmat = {fullfile(glmPath, fileNameBase, 'SPM.mat')};
        matlabbatch{3}.spm.stats.fmri_est.write_residuals = 0;
        matlabbatch{3}.spm.stats.fmri_est.method.Classical = 1;
        matlabbatch{4}.spm.stats.con.spmmat = {fullfile(glmPath, fileNameBase, 'SPM.mat')};
        matlabbatch{4}.spm.stats.con.consess{1}.tcon.name = 'harmful action > other';   % determine if smaller activity if cause of harm intentional than accidental
        matlabbatch{4}.spm.stats.con.consess{1}.tcon.weights = [1 0];
        matlabbatch{4}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
        matlabbatch{4}.spm.stats.con.consess{2}.tcon.name = 'harmful action > accidental';   % determine if smaller activity if cause of harm intentional than accidental
        matlabbatch{4}.spm.stats.con.consess{2}.tcon.weights = [1 -1];
        matlabbatch{4}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
        matlabbatch{4}.spm.stats.con.consess{3}.tcon.name = 'accidental > harmful action';
        matlabbatch{4}.spm.stats.con.consess{3}.tcon.weights = [-1 1];
        matlabbatch{4}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
        matlabbatch{4}.spm.stats.con.consess{4}.tcon.name = 'accidental > other';   % determine if smaller activity if cause of harm intentional than accidental
        matlabbatch{4}.spm.stats.con.consess{4}.tcon.weights = [0 1];
        matlabbatch{4}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
        
        matlabbatch{4}.spm.stats.con.consess{3}.fcon.name = 'effect of design';         % determine if any effect by intentional and/or accidental 
        matlabbatch{4}.spm.stats.con.consess{3}.fcon.weights = [1 0
                                                                0 1];
        matlabbatch{4}.spm.stats.con.consess{3}.fcon.sessrep = 'none';
        matlabbatch{4}.spm.stats.con.consess{4}.fcon.name = 'effect of design (more similar to t contrast)';         % determine if any effect by intentional and/or accidental 
        matlabbatch{4}.spm.stats.con.consess{4}.fcon.weights = [1 -1
                                                                -1 1];
        matlabbatch{4}.spm.stats.con.consess{4}.fcon.sessrep = 'none';
        matlabbatch{4}.spm.stats.con.delete = 0;
        matlabbatch{5}.spm.stats.results.spmmat = {fullfile(glmPath, fileNameBase, 'SPM.mat')};
        matlabbatch{5}.spm.stats.results.conspec.titlestr = '';
        matlabbatch{5}.spm.stats.results.conspec.contrasts = 1;
        matlabbatch{5}.spm.stats.results.conspec.threshdesc = 'FWE';
        matlabbatch{5}.spm.stats.results.conspec.thresh = 0.05;
        matlabbatch{5}.spm.stats.results.conspec.extent = 0;
        matlabbatch{5}.spm.stats.results.conspec.conjunction = 1;
        matlabbatch{5}.spm.stats.results.conspec.mask.none = 1;
        matlabbatch{5}.spm.stats.results.units = 1;
        matlabbatch{5}.spm.stats.results.export = cell(1, 0);
        spm = what('spm12');
        matlabbatch{6}.spm.util.render.display.rendfile = {fullfile(spm.path,'canonical','cortex_20484.surf.gii')};
        matlabbatch{6}.spm.util.render.display.conspec.spmmat = {fullfile(glmPath, fileNameBase, 'SPM.mat')};
        matlabbatch{6}.spm.util.render.display.conspec.contrasts = 1;
        matlabbatch{6}.spm.util.render.display.conspec.threshdesc = 'FWE';
        matlabbatch{6}.spm.util.render.display.conspec.thresh = 0.05;
        matlabbatch{6}.spm.util.render.display.conspec.extent = 0;
        matlabbatch{6}.spm.util.render.display.conspec.mask = struct('contrasts', {}, 'thresh', {}, 'mtype', {});
    
    
        spm_jobman('run', matlabbatch);
    catch e
        warning(e.message)
        logFile = fopen(fullfile(pathBase,'_log.txt'),'a');
        fprintf(logFile,'%s\n',['GLM generation failed for ',fullfile(glmPath, fileNameBase),' .']);
        fclose(logFile);
    end
end