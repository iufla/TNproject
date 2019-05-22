%-----------------------------------------------------------------------
% Job saved on 21-May-2019 14:15:02 by cfg_util (rev $Rev: 7345 $)
% spm SPM - SPM12 (7487)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.parent = {'/home/nina/Downloads/TNU/Project/study_autism/example/'};
matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.name = 'GLM_0521';
matlabbatch{2}.spm.stats.fmri_spec.dir = {'/home/nina/Downloads/TNU/Project/study_autism/example/GLM'};
matlabbatch{2}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{2}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{2}.spm.stats.fmri_spec.timing.fmri_t = 32;
matlabbatch{2}.spm.stats.fmri_spec.timing.fmri_t0 = 16;
matlabbatch{2}.spm.stats.fmri_spec.sess.scans = {'/home/nina/Downloads/TNU/Project/study_autism/example/swsub-03_func_sub-03_task-dis_run-01_bold.nii'};
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).name = 'intentional';
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).onset = [26
                                                         58
                                                         154
                                                         218
                                                         250];
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).duration = [8
                                                            8
                                                            8
                                                            8
                                                            8];
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).orth = 1;
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).name = 'accidental';
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).onset = [90
                                                         122
                                                         186
                                                         282
                                                         314];
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).duration = [8
                                                            8
                                                            8
                                                            8
                                                            8];
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).orth = 1;
matlabbatch{2}.spm.stats.fmri_spec.sess.multi = {''};
matlabbatch{2}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
matlabbatch{2}.spm.stats.fmri_spec.sess.multi_reg = {'/home/nina/Downloads/TNU/Project/study_autism/example/rp_sub-03_func_sub-03_task-dis_run-01_bold.txt'};
matlabbatch{2}.spm.stats.fmri_spec.sess.hpf = 128;
matlabbatch{2}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{2}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{2}.spm.stats.fmri_spec.volt = 1;
matlabbatch{2}.spm.stats.fmri_spec.global = 'None';
matlabbatch{2}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{2}.spm.stats.fmri_spec.mask = {''};
matlabbatch{2}.spm.stats.fmri_spec.cvi = 'AR(1)';
matlabbatch{3}.spm.stats.fmri_est.spmmat = {'/home/nina/Downloads/TNU/Project/study_autism/example/GLM/SPM.mat'};
matlabbatch{3}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{3}.spm.stats.fmri_est.method.Classical = 1;
matlabbatch{4}.spm.stats.con.spmmat = {'/home/nina/Downloads/TNU/Project/study_autism/example/GLM/SPM.mat'};
matlabbatch{4}.spm.stats.con.consess{1}.tcon.name = '? > ?';
matlabbatch{4}.spm.stats.con.consess{1}.tcon.weights = [1 0];
matlabbatch{4}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{4}.spm.stats.con.consess{2}.tcon.name = '? > ?';
matlabbatch{4}.spm.stats.con.consess{2}.tcon.weights = [-1 0];
matlabbatch{4}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{4}.spm.stats.con.consess{3}.fcon.name = 'Effect of design';
matlabbatch{4}.spm.stats.con.consess{3}.fcon.weights = [1 0
                                                        0 1];
matlabbatch{4}.spm.stats.con.consess{3}.fcon.sessrep = 'none';
matlabbatch{4}.spm.stats.con.delete = 0;
matlabbatch{5}.spm.stats.results.spmmat = {'/home/nina/Downloads/TNU/Project/study_autism/example/GLM/SPM.mat'};
matlabbatch{5}.spm.stats.results.conspec.titlestr = '';
matlabbatch{5}.spm.stats.results.conspec.contrasts = 1;
matlabbatch{5}.spm.stats.results.conspec.threshdesc = 'FWE';
matlabbatch{5}.spm.stats.results.conspec.thresh = 0.05;
matlabbatch{5}.spm.stats.results.conspec.extent = 0;
matlabbatch{5}.spm.stats.results.conspec.conjunction = 1;
matlabbatch{5}.spm.stats.results.conspec.mask.none = 1;
matlabbatch{5}.spm.stats.results.units = 1;
matlabbatch{5}.spm.stats.results.export = cell(1, 0);
matlabbatch{6}.spm.util.render.display.rendfile = {'/home/nina/Downloads/TNU/Project/spm12/canonical/cortex_20484.surf.gii'};
matlabbatch{6}.spm.util.render.display.conspec.spmmat = {'/home/nina/Downloads/TNU/Project/study_autism/example/GLM/SPM.mat'};
matlabbatch{6}.spm.util.render.display.conspec.contrasts = 1;
matlabbatch{6}.spm.util.render.display.conspec.threshdesc = 'FWE';
matlabbatch{6}.spm.util.render.display.conspec.thresh = 0.05;
matlabbatch{6}.spm.util.render.display.conspec.extent = 0;
matlabbatch{6}.spm.util.render.display.conspec.mask = struct('contrasts', {}, 'thresh', {}, 'mtype', {});