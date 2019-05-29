pathBase = what('TNproject');
pathBase = pathBase.path;
pathBase = fullfile(pathBase, 'data');

dcmsNumber = numel(dir(fullfile(pathBase,'sub-03','DCM', 'DCM_estimated*')));
subjectsDir = dir(fullfile(pathBase,'sub*'));

specs = readParticipantSpecs();


DCM_asd = cell(0,0);
DCM_nt = cell(0,0);
dcms_asd = struct('a',[],'b',[],'c',[],'d',[]);
dcms_nt = struct('a',[],'b',[],'c',[],'d',[]);
for f=1:numel(subjectsDir)
    path = fullfile(pathBase,subjectsDir(f).name, 'DCM');
    dcms = dir(fullfile(path, 'DCM_estimated*'));
    for i=1:numel(dcms)
        dcm = load(fullfile(path, dcms(i).name));
        dcm = dcm.DCM;
        if ismember(subjectsDir(f).name, specs.ASD_names)
            dcms_asd(end+1).a = dcm.a;
            dcms_asd(end+1).b = dcm.b;
            dcms_asd(end+1).c = dcm.c;
            dcms_asd(end+1).d = dcm.d;
            DCM_asd(end+1) = {dcm};
        elseif ismember(subjectsDir(f).name, specs.NT_names)
            dcms_nt(end+1).a = dcm.a;
            dcms_nt(end+1).b = dcm.b;
            dcms_nt(end+1).c = dcm.c;
            dcms_nt(end+1).d = dcm.d; 
            DCM_nt(end+1) = {dcm};
        else
            sprintf("Error!")
        end  
    end
end
dcms_asd(1) = [];
dcms_nt(1) = [];


bma_asd = spm_dcm_bma(DCM_asd);
bma_nt = spm_dcm_bma(DCM_nt);


% prior mean calculation
[pE_asd,~,~] = spm_dcm_fmri_priors(dcms_asd.a,dcms_asd.b,dcms_asd.c,dcms_asd.d);
[pE_nt,~,~] = spm_dcm_fmri_priors(dcms_nt.a,dcms_nt.b,dcms_nt.c,dcms_nt.d);
T_asd = full(spm_vec(pE_asd));
T_nt = full(spm_vec(pE_nt));



% posterior mean calculation
Ep_asd = bma_asd.mEp;
Ep_nt = bma_nt.mEp;
Cp_asd = unvec((spm_vec(bma_asd.sEp)).^2,bma_asd.sEp);
Cp_nt = unvec((spm_vec(bma_nt.sEp)).^2,bma_nt.sEp);

posteriorProbability_asd = spm_unvec(1-spm_Ncdf(T_asd,abs(spm_vec(Ep_asd)),spm_vec(Cp_asd)),Ep_asd);
posteriorProbability_nt = spm_unvec(1-spm_Ncdf(T_nt,abs(spm_vec(Ep_nt)),spm_vec(Cp_nt)),Ep_nt);

figure
imagesc(posteriorProbability_asd.A);
title('A matrix posterior probability')

figure
imagesc(posteriorProbability_asd.B(:,:,2));
title('B matrix posterior probability (accidental harm input)')


figure
imagesc(posteriorProbability_asd.C(:,:,1));
title('B matrix posterior probability (harm input)')