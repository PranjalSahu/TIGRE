%% Initialize
clear;
close all;


% % Settings for CE-05
% filepath = '/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/DBT_recon_data/CE05/';
% sx_a   = 1400;
% sy_a   = 3584;
% slices = 45;
% sx_b   = 2200;
% sy_b   = 1000;
% volume_name   = 'CE-05_2200x1000_45.raw';
% 
%
% % Settings for CE-12
% filepath = '/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/DBT_recon_data/CE12/';
% sx_a   = 1800;
% sy_a   = 3584;
% slices = 46;
% sx_b   = 2600;
% sy_b   = 1300;
% volume_name   = 'CE-12_2600x1300_46.raw';
% 
%
% % Settings for CE-14
% filepath = '/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/DBT_recon_data/CE14/';
% sx_a   = 1618;
% sy_a   = 3584;
% slices = 71;
% sx_b   = 2690;
% sy_b   = 1198;
% volume_name   = 'CE-14_2690x1198_71.raw';
% 
% 
% % Settings for CE-16
% filepath = '/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/DBT_recon_data/CE16/';
% sx_a   = 1100;
% sy_a   = 3584;
% slices = 48;
% sx_b   = 2200;
% sy_b   = 980;
% volume_name   = 'CE-16_2200x980_48.raw';
%
%
% % Settings for CE-17
% filepath = '/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/DBT_recon_data/CE17/';
% sx_a   = 1618;
% sy_a   = 3584;
% slices = 46;
% sx_b   = 2230;
% sy_b   = 1190;
% volume_name   = 'CE-16_2230x1190_46.raw';
%
%
% % Settings for CE-18
% filepath = '/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/DBT_recon_data/CE17/';
% sx_a   = 1618;
% sy_a   = 3584;
% slices = 46;
% sx_b   = 2230;
% sy_b   = 1190;
% volume_name   = 'CE-16_2230x1190_46.raw';
%
%
% % Settings for CE-23
% filepath = '/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/DBT_recon_data/CE23/';
% sx_a   = 1600;
% sy_a   = 3584;
% slices = 62;
% sx_b   = 3150;
% sy_b   = 1465;
% volume_name   = 'CE-23_3150x1465_62.raw';
% offdetector_height = 55;
%
%
filepath = '/media/pranjal/2d33dff3-95f7-4dc0-9842-a9b18bcf1bf9/pranjal/DBT_data/projections/70_250/';
sx_a   = 1800;
sy_a   = 3584;
slices = 50;
sx_b   = 2400;
sy_b   = 1100;
volume_name   = 'CE_2400x1100_50.raw';
offdetector_height = 15;




%% Define Geometry
% 
% VARIABLE                                   DESCRIPTION                    UNITS
%-------------------------------------------------------------------------------------

anglefile       = strcat(filepath, 'LE_proj/angles.ini');
projections_dir = strcat(filepath, 'Projections_Renamed_Seg');
volume_path     = strcat(filepath,  volume_name); 


geo.DSD = 655;                             % Distance Source Detector      (mm)
geo.DSO = 608;                             % Distance Source Origin        (mm)
geo.nDetector = [sy_a;  sx_a];


% Detector parameters
geo.nDetector = [sy_a;  sx_a];					    % number of pixels              (px)
geo.dDetector = [0.085; 0.085]; 					% size of each pixel            (mm)
geo.sDetector = geo.nDetector.*geo.dDetector;       % total size of the detector    (mm)


% Image parameters
geo.nVoxel = [slices; sx_b; sy_b];             % number of voxels              (vx)
geo.dVoxel = [1 ; 0.085; 0.085];               % size of each voxel            (mm)
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

%fid    = fopen(anglefile, 'r');
%angles = fread(fid, 25, 'float');
%angles = angles';
angles = linspace(-25*pi/180, 25*pi/180, 25);


geo = staticDetectorGeo(geo, angles, offdetector_height);
%disp(geo.DSD);

%% Load data and generate projections


noise_projections = zeros(sx_a, sy_a, 25, 'double');
files             = dir(projections_dir);

%disp(size(files));
%disp(files(1));
%disp(files(2));

for t=3:27
  disp(strcat(files(t).folder, '/', files(t).name))
  fid = fopen(strcat(files(t).folder, '/', files(t).name), 'r');
  c   = fread(fid, sx_a*sy_a, 'float');
  cb  = reshape(c, [sy_a, sx_a]);
  cb = cb';
  noise_projections(:, :, t-2) = cb;
end

noise_projections = single(noise_projections);

%% Lets create a SART test for comparison
[recSART,  errL2SART] = SART(noise_projections, geo, angles, 1, 'OrderStrategy', 'random');

temp = zeros(sx_b, sy_b, slices, 'double');
for t=1:slices
    temp(:, :, t)  = recSART(t, :, :);
end

fid = fopen(volume_path, 'w+');
cnt = fwrite(fid, temp, 'float');
fclose(fid);
