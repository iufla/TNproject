% Translational Neuromodeling Project, ETH Zurich
% 'Decoding moral judgements from neurotypical individuals compared to
% individuals with ASD'
%--------------------------------------------------------------------------
% authors: Stephan Boner, Alexander Hess, Nina Stumpf
% date: 2019-05-30
% version: 1.0
%--------------------------------------------------------------------------
% This file creates 20 different DCMs by calling 'DCMCreateModels.m'.
% The created DCM structs are saved and parameters are being estimated 
% using the function 'spm_dcm_estimate.m' from SPM12.
%
% This file calls: 'DCMRunOnSubject.m' (which calls 'DCMCreateModels.m' and
% 'spm_dcm_estimate.m')
%==========================================================================


function DCMRunOnSubject(subjectPath, runName)

    DCMCreateModels(subjectPath,runName)

    dcmPath = fullfile(subjectPath, 'DCM');
    
    designDCMsDirs = dir(fullfile(dcmPath, runName, 'DCM_design*.mat'));
    designDCMs = struct('DCM',[]);

    for i = 1:numel(designDCMsDirs)
        designDCMs(i) = load(fullfile(designDCMsDirs(i).folder,designDCMsDirs(i).name));
    end

    % ----- estimate DCM's ------
    estimatedDCMs = designDCMs;
    for i = 1:numel(designDCMs)
        estimatedDCMs(i).DCM = spm_dcm_estimate(designDCMs(i).DCM);
        DCM = estimatedDCMs(i).DCM;
        save(fullfile(dcmPath, runName,['DCM_estimated_',num2str(i,'%02d'),'.mat']),'DCM');
    end
    
    
    % ----- Print Summary ------
    
    for i = 1:numel(estimatedDCMs)
        sprintf("Negative free energy of Model %d:\t%f", i, estimatedDCMs(i).DCM.F)
    end

    % spm_dcm_review(dcms(1).DCM)

end