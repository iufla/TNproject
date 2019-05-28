function runDCMOnSubject(subjectPath, runName)

    createDCMstruct(subjectPath,runName)

    dcmPath = fullfile(subjectPath, 'DCM');
    
    designDCMsDirs = dir(fullfile(dcmPath, 'DCM_design*.mat'));
    designDCMs = struct('DCM',[]);

    for i = 1:numel(designDCMsDirs)
        designDCMs(i) = load(fullfile(designDCMsDirs(i).folder,designDCMsDirs(i).name));
    end

    % ----- estimate DCM's ------
    estimatedDCMs = designDCMs;
    for i = 1:numel(designDCMs)
        estimatedDCMs(i).DCM = spm_dcm_estimate(designDCMs(i).DCM);
        DCM = estimatedDCMs(i);
        save(fullfile(dcmPath,['DCM_estimated_',num2str(i,'%02d'),'.mat']),'DCM');
    end
    
    
    % ----- Print Summary ------
    
    for i = 1:numel(estimatedDCMs)
        sprintf("Negative free energy of Model %d:\t%f", i, estimatedDCMs(i).DCM.F)
    end

    % spm_dcm_review(dcms(1).DCM)

end