function getTimeSeries(path,regions)
    for n=1:numel(regions)
        clear matlabbatch
        matlabbatch{1}.spm.util.voi.spmmat = {fullfile(path,'SPM.mat')};
        matlabbatch{1}.spm.util.voi.adjust = 3;
        matlabbatch{1}.spm.util.voi.session = 1;
        matlabbatch{1}.spm.util.voi.name = regions(n).name;
        matlabbatch{1}.spm.util.voi.roi{1}.sphere.centre = regions(n).coordinates;
        matlabbatch{1}.spm.util.voi.roi{1}.sphere.radius = regions(n).size;
        matlabbatch{1}.spm.util.voi.roi{1}.sphere.move.fixed = 1;        
        matlabbatch{1}.spm.util.voi.expression = 'i1';
        spm_jobman('run', matlabbatch);
    end
end
