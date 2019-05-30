nSubjects = numel(BMS.DCM.rfx.bma.mEps);
b_PREC_RTPJ = nan(1,nSubjects);
for n=1:nSubjects
    b_PREC_RTPJ(n) = BMS.DCM.rfx.bma.mEps{n}.B(3,2,2);
end


% functions where still unclear how they work:
% spm_bms_ttest(BMS.DCM.rfx.bma.mEps)

% BMS_ASD = '.../BMS.mat';
% BMS_NT = '.../BMS.mat';
% BMSfiles = {BMS_ASD,BMS_NT};
% spm_bms_compare_groups(BMSfiles,'ASD_NT');