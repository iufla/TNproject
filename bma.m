pathBase = what('TNproject');
pathBase = pathBase.path;
pathBase = fullfile(pathBase, 'data');

dcmsNumber = numel(dir(fullfile(pathBase,'sub-03','DCM', 'DCM_estimated*')));
subjectsDir = dir(fullfile(pathBase,'sub*'));

specs = helperReadParticipantSpecs();


DCM_asd = cell(0,0);
DCM_nt = cell(0,0);
dcms_asd = struct('a',[],'b',[],'c',[],'d',[]);
dcms_nt = struct('a',[],'b',[],'c',[],'d',[]);
dcmvecs_asd = [];
dcmvecs_nt = [];
for f=1:numel(subjectsDir)
    path = fullfile(pathBase,subjectsDir(f).name, 'DCM');
    dcms = dir(fullfile(path, 'DCM_estimated*'));
    for i=1:numel(dcms)
        dcm = load(fullfile(path, dcms(i).name));
        dcm = dcm.DCM;
        if ismember(subjectsDir(f).name, specs.ASD_names)
            dcms_asd(end+1).a = dcm.a;
            dcms_asd(end).b = dcm.b;
            dcms_asd(end).c = dcm.c;
            dcms_asd(end).d = dcm.d;
            try
%                 dcmvecs_asd = [dcmvecs_asd , spm_vec(dcm.a,dcm.b,dcm.c,dcm.d)];
                dcmvecs_asd = [dcmvecs_asd , spm_vec(dcm.Ep)];
            catch e
                warning(e.message)
            end
            DCM_asd(end+1) = {dcm};
        elseif ismember(subjectsDir(f).name, specs.NT_names)
            dcms_nt(end+1).a = dcm.a;
            dcms_nt(end).b = dcm.b;
            dcms_nt(end).c = dcm.c;
            dcms_nt(end).d = dcm.d; 
            try
                dcmvecs_nt = [dcmvecs_nt , spm_vec(dcm.Ep)];
%                 dcmvecs_nt = [dcmvecs_nt , spm_vec(dcm.a,dcm.b,dcm.c,dcm.d)];
            catch e
               warning(e.message); 
            end
            DCM_nt(end+1) = {dcm};
        else
            sprintf("Error!")
        end  
    end
end
dcms_asd(1) = [];
dcms_nt(1) = [];

% spm_vec(DCM_asd{1,1}.a,DCM_asd{1,1}.b,DCM_asd{1,1}.c,DCM_asd{1,1}.d,DCM_asd{1,1}.Ce)

meandcmvecs_asd = mean(dcmvecs_asd,2);
meandcmvecs_nt = mean(dcmvecs_nt,2);


% bma_asd = spm_dcm_bma(DCM_asd);
% bma_nt = spm_dcm_bma(DCM_nt);

posteriorModelProbability_asd = BMS.DCM.rfx.model.g_post;
posteriorModelProbability_nt = BMS.DCM.rfx.model.g_post;
subjStruct_asd = model_space.subj;

bmaModelIdx_asd = 1:1:16;


bma_asd = spm_dcm_bma(posteriorModelProbability_asd,bmaModelIdx_asd,subjStruct_asd);
% bma_nt = spm_dcm_bma(DCM_nt);


% prior mean calculation
% [pE_asd,~,~] = spm_dcm_fmri_priors(dcms_asd.a,dcms_asd.b,dcms_asd.c,dcms_asd.d);
% [pE_nt,~,~] = spm_dcm_fmri_priors(dcms_nt.a,dcms_nt.b,dcms_nt.c,dcms_nt.d);
% T_asd = full(spm_vec(pE_asd));
% T_nt = full(spm_vec(pE_nt));



% posterior mean calculation
Ep_asd = bma_asd.mEp
% Ep_nt = bma_nt.mEp;
Cp_asd = spm_unvec((spm_vec(bma_asd.sEp)).^2,bma_asd.sEp);
% Cp_nt = unvec((spm_vec(bma_nt.sEp)).^2,bma_nt.sEp);


Ep_vec = abs(spm_vec(Ep_asd))
Cp_vec = spm_vec(Cp_asd)

% [meandcmvecs_asd;zeros(5,1)]

posteriorProbability_asd = spm_unvec(1-spm_Ncdf(full(meandcmvecs_asd),Ep_vec,Cp_vec),Ep_asd);
% posteriorProbability_asd = spm_unvec(1-spm_Ncdf([meandcmvecs_asd;zeros(5,1)],Ep_vec,Cp_vec,Ep_asd));
% posteriorProbability_nt = spm_unvec(1-spm_Ncdf(meandcmvec_nt,abs(spm_vec(Ep_nt)),spm_vec(Cp_nt)),Ep_nt);

% posteriorProbability_asd = spm_unvec(1-spm_Ncdf(T_asd,abs(spm_vec(Ep_asd)),spm_vec(Cp_asd)),Ep_asd);
% posteriorProbability_nt = spm_unvec(1-spm_Ncdf(T_nt,abs(spm_vec(Ep_nt)),spm_vec(Cp_nt)),Ep_nt);


figure
imagesc(posteriorProbability_asd.A);
title('A matrix posterior probability')

figure
imagesc(posteriorProbability_asd.B(:,:,2));
title('B matrix posterior probability (accidental harm input)')


figure
imagesc(posteriorProbability_asd.C(:,:,1));
title('B matrix posterior probability (harm input)')