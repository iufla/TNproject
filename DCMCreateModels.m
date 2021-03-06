% Translational Neuromodeling Project, ETH Zurich
% 'Decoding moral judgements from neurotypical individuals compared to
% individuals with ASD'
%--------------------------------------------------------------------------
% authors: Stephan Boner, Alexander Hess, Nina Stumpf
% date: 2019-05-30
% version: 1.0
%--------------------------------------------------------------------------
% This file creates 20 different customized DCM structs by calling 
% 'DCMCreateModels.m'. The created DCM structs are saved.
%
% Thise file is built on and customized for our needs from the SPM batch 
% script specified below:

% This batch script analyses the Attention to Visual Motion fMRI dataset
% available from the SPM website using DCM:
%   http://www.fil.ion.ucl.ac.uk/spm/data/attention/
% as described in the SPM manual:
%   http://www.fil.ion.ucl.ac.uk/spm/doc/spm12_manual.pdf#Chap:DCM_fmri
%__________________________________________________________________________
% Copyright (C) 2014 Wellcome Trust Centre for Neuroimaging

% Guillaume Flandin & Peter Zeidman
% $Id: dcm_spm12_batch.m 12 2014-09-29 19:58:09Z guillaume $
%==========================================================================


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DYNAMIC CAUSAL MODELLING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function DCMCreateModels(subjectPath,runName)
    % SPECIFICATION DCMs "attentional modulation of backward/forward connection"
    %--------------------------------------------------------------------------
    % To specify a DCM, you might want to create a template one using the GUI
    % then use spm_dcm_U.m and spm_dcm_voi.m to insert new inputs and new
    % regions. The following code creates a DCM file from scratch, which
    % involves some technical subtleties and a deeper knowledge of the DCM
    % structure.
    
    % Create results folder
    %--------------------------------------------------------------------------
    mkdir(fullfile(subjectPath,'DCM'));
    mkdir(fullfile(subjectPath, 'DCM', runName));
    
    % Load SPM struct generated by GLM
    %--------------------------------------------------------------------------
    SPM = load(fullfile(subjectPath,'GLM',runName,'SPM.mat'));
    SPM = SPM.SPM;

    % Load regions of interest
    %--------------------------------------------------------------------------
    vois = dir(fullfile(subjectPath,'GLM',runName,'VOI*.mat'));
    
    i = 0;
    for n=1:numel(vois)
        if isempty(strfind(vois(n).name, 'MPFC'))
            i = i+1;
            xYStruct = load(fullfile(vois(n).folder,vois(n).name),'xY');
            DCM.xY(i) = xYStruct.xY;
        end
    end

    DCM.n = length(DCM.xY);      % number of regions
    DCM.v = length(DCM.xY(1).u); % number of time points

    % Time series
    %--------------------------------------------------------------------------
    DCM.Y.dt  = SPM.xY.RT;
    DCM.Y.X0  = DCM.xY(1).X0;
    for i = 1:DCM.n
        DCM.Y.y(:,i)  = DCM.xY(i).u;
        DCM.Y.name{i} = DCM.xY(i).name;
    end

    DCM.Y.Q    = spm_Ce(ones(1,DCM.n)*DCM.v);

    % Experimental inputs
    %--------------------------------------------------------------------------
    DCM.U.dt   =  SPM.Sess.U(1).dt;
    DCM.U.name = [SPM.Sess.U.name];
    DCM.U.u    = [SPM.Sess.U.u];

    % DCM parameters and options
    %--------------------------------------------------------------------------
    DCM.delays = repmat(SPM.xY.RT/2,DCM.n,1);
    DCM.TE     = 0.04;

    DCM.options.nonlinear  = 0;
    DCM.options.two_state  = 0;
    DCM.options.stochastic = 0;
    DCM.options.nograph    = 1;

    
    % Connectivity matrices specifications
    %--------------------------------------------------------------------------
    nDCMs = 0;
    nInputs = numel(DCM.U.name);
    
    MPFCidx = find(contains({vois.name},'MPFC'));
    PRECidx = find(contains({vois.name},'PREC'));
    LTPJidx = find(contains({vois.name},'LTPJ'));
    RTPJidx = find(contains({vois.name},'RTPJ'));
    if PRECidx > MPFCidx
        PRECidx = PRECidx - 1;
    end
    if LTPJidx > MPFCidx
        LTPJidx = LTPJidx - 1;
    end
    if RTPJidx > MPFCidx
        RTPJidx = RTPJidx - 1;
    end
    harmInptIdx = find(contains(DCM.U.name,'harm'));
    accidentalInptIdx = find(contains(DCM.U.name,'accidental'));

    % 1. self-modulatory input at RTPJ, driving input towards PC
    nDCMs = nDCMs + 1;
    connectivityMatrices(nDCMs).a = ones(DCM.n,DCM.n);
    for n=1:nInputs
        connectivityMatrices(nDCMs).b(:,:,n) = zeros(DCM.n,DCM.n);
    end
    connectivityMatrices(nDCMs).b(RTPJidx,RTPJidx,n) = 1;
    connectivityMatrices(nDCMs).c = zeros(DCM.n,nInputs);
    connectivityMatrices(nDCMs).c(PRECidx,harmInptIdx) = 1;
    connectivityMatrices(nDCMs).d = zeros(DCM.n,DCM.n,0);   % not needed (only for nonlinear DCM)
    
    % 2. modulatory inputs towards RTPJ, driving input towards PC
    nDCMs = nDCMs + 1;
    connectivityMatrices(nDCMs).a = ones(DCM.n,DCM.n);
    for n=1:nInputs
        connectivityMatrices(nDCMs).b(:,:,n) = zeros(DCM.n,DCM.n);
    end
    connectivityMatrices(nDCMs).b(RTPJidx,[PRECidx,LTPJidx],n) = 1;
    connectivityMatrices(nDCMs).c = zeros(DCM.n,nInputs);
    connectivityMatrices(nDCMs).c(PRECidx,harmInptIdx) = 1;
    connectivityMatrices(nDCMs).d = zeros(DCM.n,DCM.n,0);   % not needed (only for nonlinear DCM)
    
    % 3. modulatory inputs from PREC towards RTPJ, driving input towards PC
    nDCMs = nDCMs + 1;
    connectivityMatrices(nDCMs).a = ones(DCM.n,DCM.n);
    for n=1:nInputs
        connectivityMatrices(nDCMs).b(:,:,n) = zeros(DCM.n,DCM.n);
    end
    connectivityMatrices(nDCMs).b(RTPJidx,PRECidx,n) = 1;
    connectivityMatrices(nDCMs).c = zeros(DCM.n,nInputs);
    connectivityMatrices(nDCMs).c(PRECidx,harmInptIdx) = 1;
    connectivityMatrices(nDCMs).d = zeros(DCM.n,DCM.n,0);   % not needed (only for nonlinear DCM)
    
    % 4. modulatory inputs from LTPJ towards RTPJ, driving input towards PC
    nDCMs = nDCMs + 1;
    connectivityMatrices(nDCMs).a = ones(DCM.n,DCM.n);
    for n=1:nInputs
        connectivityMatrices(nDCMs).b(:,:,n) = zeros(DCM.n,DCM.n);
    end
    connectivityMatrices(nDCMs).b(RTPJidx,LTPJidx,n) = 1;
    connectivityMatrices(nDCMs).c = zeros(DCM.n,nInputs);
    connectivityMatrices(nDCMs).c(PRECidx,harmInptIdx) = 1;
    connectivityMatrices(nDCMs).d = zeros(DCM.n,DCM.n,0);   % not needed (only for nonlinear DCM)
    
    % 5. modulatory inputs towards RTPJ, driving input towards PC, LTPJ, RTPJ
    nDCMs = nDCMs + 1;
    connectivityMatrices(nDCMs).a = ones(DCM.n,DCM.n);
    for n=1:nInputs
        connectivityMatrices(nDCMs).b(:,:,n) = zeros(DCM.n,DCM.n);
    end
    connectivityMatrices(nDCMs).b(RTPJidx,[PRECidx,LTPJidx],n) = 1;
    connectivityMatrices(nDCMs).c = zeros(DCM.n,nInputs);
    connectivityMatrices(nDCMs).c(:,harmInptIdx) = 1;
    connectivityMatrices(nDCMs).d = zeros(DCM.n,DCM.n,0);   % not needed (only for nonlinear DCM)
    
    % 6. modulatory inputs towards RTPJ, driving input towards PC, LTPJ
    nDCMs = nDCMs + 1;
    connectivityMatrices(nDCMs).a = ones(DCM.n,DCM.n);
    for n=1:nInputs
        connectivityMatrices(nDCMs).b(:,:,n) = zeros(DCM.n,DCM.n);
    end
    connectivityMatrices(nDCMs).b(RTPJidx,[PRECidx,LTPJidx],n) = 1;
    connectivityMatrices(nDCMs).c = zeros(DCM.n,nInputs);
    connectivityMatrices(nDCMs).c([PRECidx,LTPJidx],harmInptIdx) = 1;
    connectivityMatrices(nDCMs).d = zeros(DCM.n,DCM.n,0);   % not needed (only for nonlinear DCM)
    
    % 7. self-modulatory input at RTPJ, driving input towards PC, LTPJ
    nDCMs = nDCMs + 1;
    connectivityMatrices(nDCMs).a = ones(DCM.n,DCM.n);
    for n=1:nInputs
        connectivityMatrices(nDCMs).b(:,:,n) = zeros(DCM.n,DCM.n);
    end
    connectivityMatrices(nDCMs).b(RTPJidx,RTPJidx,n) = 1;
    connectivityMatrices(nDCMs).c = zeros(DCM.n,nInputs);
    connectivityMatrices(nDCMs).c([PRECidx,LTPJidx],harmInptIdx) = 1;
    connectivityMatrices(nDCMs).d = zeros(DCM.n,DCM.n,0);   % not needed (only for nonlinear DCM)
    
    % 8. self-modulatory input at RTPJ, driving input towards PC,LTPJ,RTPJ
    nDCMs = nDCMs + 1;
    connectivityMatrices(nDCMs).a = ones(DCM.n,DCM.n);
    for n=1:nInputs
        connectivityMatrices(nDCMs).b(:,:,n) = zeros(DCM.n,DCM.n);
    end
    connectivityMatrices(nDCMs).b(RTPJidx,RTPJidx,n) = 1;
    connectivityMatrices(nDCMs).c = zeros(DCM.n,nInputs);
    connectivityMatrices(nDCMs).c(:,harmInptIdx) = 1;
    connectivityMatrices(nDCMs).d = zeros(DCM.n,DCM.n,0);   % not needed (only for nonlinear DCM)
    
    % 9. modulatory inputs from PREC towards RTPJ, driving input towards
    % PC,LTPJ
    nDCMs = nDCMs + 1;
    connectivityMatrices(nDCMs).a = ones(DCM.n,DCM.n);
    for n=1:nInputs
        connectivityMatrices(nDCMs).b(:,:,n) = zeros(DCM.n,DCM.n);
    end
    connectivityMatrices(nDCMs).b(RTPJidx,PRECidx,n) = 1;
    connectivityMatrices(nDCMs).c = zeros(DCM.n,nInputs);
    connectivityMatrices(nDCMs).c([PRECidx,LTPJidx],harmInptIdx) = 1;
    connectivityMatrices(nDCMs).d = zeros(DCM.n,DCM.n,0);   % not needed (only for nonlinear DCM)
    
    % 10. modulatory inputs from LTPJ towards RTPJ, driving input towards
    % PC,LTPJ
    nDCMs = nDCMs + 1;
    connectivityMatrices(nDCMs).a = ones(DCM.n,DCM.n);
    for n=1:nInputs
        connectivityMatrices(nDCMs).b(:,:,n) = zeros(DCM.n,DCM.n);
    end
    connectivityMatrices(nDCMs).b(RTPJidx,LTPJidx,n) = 1;
    connectivityMatrices(nDCMs).c = zeros(DCM.n,nInputs);
    connectivityMatrices(nDCMs).c([PRECidx,LTPJidx],harmInptIdx) = 1;
    connectivityMatrices(nDCMs).d = zeros(DCM.n,DCM.n,0);   % not needed (only for nonlinear DCM)
    
    % 11. modulatory inputs from PREC towards RTPJ, driving input towards
    % PC,LTPJ;RTPJ
    nDCMs = nDCMs + 1;
    connectivityMatrices(nDCMs).a = ones(DCM.n,DCM.n);
    for n=1:nInputs
        connectivityMatrices(nDCMs).b(:,:,n) = zeros(DCM.n,DCM.n);
    end
    connectivityMatrices(nDCMs).b(RTPJidx,PRECidx,n) = 1;
    connectivityMatrices(nDCMs).c = zeros(DCM.n,nInputs);
    connectivityMatrices(nDCMs).c(:,harmInptIdx) = 1;
    connectivityMatrices(nDCMs).d = zeros(DCM.n,DCM.n,0);   % not needed (only for nonlinear DCM)
    
    % 12. modulatory inputs from LTPJ towards RTPJ, driving input towards
    % PC,LTPJ,RTPJ
    nDCMs = nDCMs + 1;
    connectivityMatrices(nDCMs).a = ones(DCM.n,DCM.n);
    for n=1:nInputs
        connectivityMatrices(nDCMs).b(:,:,n) = zeros(DCM.n,DCM.n);
    end
    connectivityMatrices(nDCMs).b(RTPJidx,LTPJidx,n) = 1;
    connectivityMatrices(nDCMs).c = zeros(DCM.n,nInputs);
    connectivityMatrices(nDCMs).c(:,harmInptIdx) = 1;
    connectivityMatrices(nDCMs).d = zeros(DCM.n,DCM.n,0);   % not needed (only for nonlinear DCM)
    
    % 13. modulatory inputs towards RTPJ, driving input towards PC, RTPJ
    nDCMs = nDCMs + 1;
    connectivityMatrices(nDCMs).a = ones(DCM.n,DCM.n);
    for n=1:nInputs
        connectivityMatrices(nDCMs).b(:,:,n) = zeros(DCM.n,DCM.n);
    end
    connectivityMatrices(nDCMs).b(RTPJidx,[PRECidx,LTPJidx],n) = 1;
    connectivityMatrices(nDCMs).c = zeros(DCM.n,nInputs);
    connectivityMatrices(nDCMs).c([PRECidx,RTPJidx],harmInptIdx) = 1;
    connectivityMatrices(nDCMs).d = zeros(DCM.n,DCM.n,0);   % not needed (only for nonlinear DCM)
    
    % 14. self-modulatory input at RTPJ, driving input towards PC, RTPJ
    nDCMs = nDCMs + 1;
    connectivityMatrices(nDCMs).a = ones(DCM.n,DCM.n);
    for n=1:nInputs
        connectivityMatrices(nDCMs).b(:,:,n) = zeros(DCM.n,DCM.n);
    end
    connectivityMatrices(nDCMs).b(RTPJidx,RTPJidx,n) = 1;
    connectivityMatrices(nDCMs).c = zeros(DCM.n,nInputs);
    connectivityMatrices(nDCMs).c([PRECidx,RTPJidx],harmInptIdx) = 1;
    connectivityMatrices(nDCMs).d = zeros(DCM.n,DCM.n,0);   % not needed (only for nonlinear DCM)
    
    % 15. modulatory inputs from PREC towards RTPJ, driving input towards
    % PC,RTPJ
    nDCMs = nDCMs + 1;
    connectivityMatrices(nDCMs).a = ones(DCM.n,DCM.n);
    for n=1:nInputs
        connectivityMatrices(nDCMs).b(:,:,n) = zeros(DCM.n,DCM.n);
    end
    connectivityMatrices(nDCMs).b(RTPJidx,PRECidx,n) = 1;
    connectivityMatrices(nDCMs).c = zeros(DCM.n,nInputs);
    connectivityMatrices(nDCMs).c([PRECidx,RTPJidx],harmInptIdx) = 1;
    connectivityMatrices(nDCMs).d = zeros(DCM.n,DCM.n,0);   % not needed (only for nonlinear DCM)
    
    % 16. modulatory inputs from LTPJ towards RTPJ, driving input towards
    % PC,RTPJ
    nDCMs = nDCMs + 1;
    connectivityMatrices(nDCMs).a = ones(DCM.n,DCM.n);
    for n=1:nInputs
        connectivityMatrices(nDCMs).b(:,:,n) = zeros(DCM.n,DCM.n);
    end
    connectivityMatrices(nDCMs).b(RTPJidx,LTPJidx,n) = 1;
    connectivityMatrices(nDCMs).c = zeros(DCM.n,nInputs);
    connectivityMatrices(nDCMs).c([PRECidx,RTPJidx],harmInptIdx) = 1;
    connectivityMatrices(nDCMs).d = zeros(DCM.n,DCM.n,0);   % not needed (only for nonlinear DCM)
    
    % 17. no modulatory inputs, driving input towards PC
    nDCMs = nDCMs + 1;
    connectivityMatrices(nDCMs).a = ones(DCM.n,DCM.n);
    for n=1:nInputs
        connectivityMatrices(nDCMs).b(:,:,n) = zeros(DCM.n,DCM.n);
    end
    connectivityMatrices(nDCMs).c = zeros(DCM.n,nInputs);
    connectivityMatrices(nDCMs).c(PRECidx,harmInptIdx) = 1;
    connectivityMatrices(nDCMs).d = zeros(DCM.n,DCM.n,0);   % not needed (only for nonlinear DCM)

    % 18. no modulatory inputs, driving input towards PC,LTPJ,RTPJ
    nDCMs = nDCMs + 1;
    connectivityMatrices(nDCMs).a = ones(DCM.n,DCM.n);
    for n=1:nInputs
        connectivityMatrices(nDCMs).b(:,:,n) = zeros(DCM.n,DCM.n);
    end
    connectivityMatrices(nDCMs).c = zeros(DCM.n,nInputs);
    connectivityMatrices(nDCMs).c([PRECidx,LTPJidx,RTPJidx],harmInptIdx) = 1;
    connectivityMatrices(nDCMs).d = zeros(DCM.n,DCM.n,0);   % not needed (only for nonlinear DCM)

    % 19. no modulatory inputs, driving input towards PC,LTPJ
    nDCMs = nDCMs + 1;
    connectivityMatrices(nDCMs).a = ones(DCM.n,DCM.n);
    for n=1:nInputs
        connectivityMatrices(nDCMs).b(:,:,n) = zeros(DCM.n,DCM.n);
    end
    connectivityMatrices(nDCMs).c = zeros(DCM.n,nInputs);
    connectivityMatrices(nDCMs).c([PRECidx,LTPJidx],harmInptIdx) = 1;
    connectivityMatrices(nDCMs).d = zeros(DCM.n,DCM.n,0);   % not needed (only for nonlinear DCM)

    % 20. no modulatory inputs, driving input towards PC,RTPJ
    nDCMs = nDCMs + 1;
    connectivityMatrices(nDCMs).a = ones(DCM.n,DCM.n);
    for n=1:nInputs
        connectivityMatrices(nDCMs).b(:,:,n) = zeros(DCM.n,DCM.n);
    end
    connectivityMatrices(nDCMs).c = zeros(DCM.n,nInputs);
    connectivityMatrices(nDCMs).c([PRECidx,RTPJidx],harmInptIdx) = 1;
    connectivityMatrices(nDCMs).d = zeros(DCM.n,DCM.n,0);   % not needed (only for nonlinear DCM)
    
    % Save resulting DCM structs
    %--------------------------------------------------------------------------
    for n=1:nDCMs
        DCM.a = connectivityMatrices(n).a;
        DCM.b = connectivityMatrices(n).b;
        DCM.c = connectivityMatrices(n).c;
        DCM.d = connectivityMatrices(n).d;
        save(fullfile(subjectPath,'DCM', runName,['DCM_design_',num2str(n,'%02d'),'.mat']),'DCM');
    end 
end