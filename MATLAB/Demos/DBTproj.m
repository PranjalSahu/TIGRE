clc;clear;close all


filepath = 'C:\\Users\\psahu\\TESTBED\\projections\\44_350\\';
sx_a   = 1000;
sy_a   = 3600;
slices = 249;
sx_b   = 939;
sy_b   = 329;
volume_name        = 'CE_2400x840_249_350_volume_random.raw';
offdetector_height = 329*0.2/2;


geo.DSD = 655;                             % Distance Source Detector      (mm)
geo.DSO = 608;                             % Distance Source Origin        (mm)
geo.nDetector = [sy_a;  sx_a];
 
 
% Detector parameters
geo.nDetector = [sy_a;  sx_a];                      % number of pixels              (px)
geo.dDetector = [0.085; 0.085];                     % size of each pixel            (mm)
geo.sDetector = geo.nDetector.*geo.dDetector;       % total size of the detector    (mm)
 
 
% Image parameters
geo.nVoxel = [slices; sx_b; sy_b];             % number of voxels              (vx)
geo.dVoxel = [0.2 ; 0.2; 0.2];                 % size of each voxel            (mm)
geo.sVoxel = geo.nVoxel.*geo.dVoxel;           % total size of the image       (mm)
 
 
% Offsets
Airgap = 17;
geo.offOrigin   = [((geo.sVoxel(1)/2)-(geo.DSD-geo.DSO)+Airgap); 0; geo.sVoxel(3)/2];           
geo.offDetector = [0; geo.sDetector(2)/2];    % Offset of Detector            (mm)
 
 
% Auxiliary 
geo.COR         = 0; 
geo.accuracy    = 0.1;                           % Accuracy of FWD proj          (vx/sample)
geo.mode        = 'cone';
geo.rotDetector = [0;0;0]; 
 
TotalAngles = 35;
 

angles = linspace(-35*pi/180, 35*pi/180, TotalAngles);
angles = fliplr(angles);
 
 
geo = staticDetectorGeo(geo, angles, offdetector_height);



%% Adapt DBT projections to TIGRE CT projections
head        = readphantom('/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/DBT_recon_data/vcts_deformed/0_888076.0.575565525455.20180521024130774/Phantom.dat', [329 249 939]);
head        = single(head);
projections = Ax(head, geo, angles,'interpolated');

% % If you use a true DBT projection, use the following lines to adapt you
% % data to TIGRE CT.Remember to use -log in your data.
% % projections = -log(projections./single(2^14-1)); %your maximum white
% % level.
% %% Simple BP
% recFDK = FDK( projections,geo,angles);
% 
% %% SART
% recSART = SART(projections,geo,angles,2,'OrderStrategy','ordered');
% 
% %% plot
% plotImg([recFDK recSART],'dim','x','clims',[0 1])
% 
