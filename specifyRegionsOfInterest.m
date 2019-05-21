regions = struct();

% specify ROI coordinates as [x,y,z] arrays
regions.LIFG = [-42, 12, 24];
regions.MPFC = [-6, 54, 32];
regions.LTPJ = [-52, -64, 20];
regions.RTPJ = [56, -46, 20];
regions.PREC = [2, -56, 40];

regions.shape = 'sphere';   % spheric volumes around region MNI group coordinates
regions.size = 8;           % 8 mm radius

