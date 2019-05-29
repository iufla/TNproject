function GLMGetTimeSeriesForFile(pathBase,path,regions)
    for n=1:numel(regions)
        clear matlabbatch
        matlabbatch{1}.spm.util.voi.spmmat = {fullfile(path,'SPM.mat')};
        matlabbatch{1}.spm.util.voi.adjust = 3;
        matlabbatch{1}.spm.util.voi.session = 1;
        matlabbatch{1}.spm.util.voi.name = regions(n).name;
%         matlabbatch{1}.spm.util.voi.roi{1}.spm.thresh = threshold;  % set low p value threshold for contrasts in order not to cause SMP move the sphere centre
        matlabbatch{1}.spm.util.voi.roi{1}.sphere.centre = regions(n).coordinates;
        matlabbatch{1}.spm.util.voi.roi{1}.sphere.radius = regions(n).size;
        matlabbatch{1}.spm.util.voi.roi{1}.sphere.move.fixed = 1;        
        matlabbatch{1}.spm.util.voi.expression = 'i1';
        try
            spm_jobman('run', matlabbatch);
        catch
            logFile = fopen(fullfile(pathBase,'_log.txt'),'a');
            fprintf(logFile,'%s\n',['Time series extraction failed for region ',regions(n).name,' in ',strrep(path,pathBase,''),' .']);
            fclose(logFile);
        end
    end
end