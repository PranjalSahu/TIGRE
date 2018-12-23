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
% slices = 541;%46;
% sx_b   = 2600;
% sy_b   = 1300;
% volume_name   = 'CE-12_2600x1300_46_sart-1.raw';
% offdetector_height = 35;
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
% % Synthetic Data
filepath = 'C:\\Users\\psahu\\TESTBED\\projections\\44_250\\';
sx_a   = 1000;
sy_a   = 3600;
slices = 50; %50;
sx_b   = 2400;
sy_b   = 840;
volume_name   = 'CE_2400x840_249_10.raw';
offdetector_height = 75;

%
% Synthetic Data downsampled (Does not work)
% filepath = '/media/pranjal/2d33dff3-95f7-4dc0-9842-a9b18bcf1bf9/pranjal/DBT_data/projections/70_250/';
% sx_a   = 450;
% sy_a   = 896;
% slices = 249; %50;
% sx_b   = 600;
% sy_b   = 280;
% volume_name   = 'CE_600x280_249.raw';
% offdetector_height = 15;

%
% % Settings for CE-26
%filepath = '/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/DBT_recon_data/CE26/RE_diff/';
% filepath  = '/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/DBT_recon_data/CE26/T_PR_RAW_R-CC_DIAGNOSIS_0003/' ;
% sx_a   = 860;
% sy_a   = 3584;
% slices = 58;
% sx_b   = 2810;
% sy_b   = 860;
% volume_name   = 'CE_2810x860_58_1.raw';
% offdetector_height = 35;



%% Define Geometry
% 
% VARIABLE                                   DESCRIPTION                    UNITS
%-------------------------------------------------------------------------------------

anglefile       = strcat(filepath, 'angles.ini');
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

TotalAngles = 25;

%fid    = fopen(anglefile, 'r');
%angles = fread(fid, 25, 'float');
%angles = angles';
angles = linspace(-25*pi/180, 25*pi/180, TotalAngles);
angles = fliplr(angles);


geo = staticDetectorGeo(geo, angles, offdetector_height);
%disp(geo.DSD);

%% Load data and generate projections


noise_projections = zeros(sx_a, sy_a, size(angles, 2), 'double');
files             = dir(projections_dir);

disp(size(files));

for t=3:27
  disp(strcat(files(t).folder, '/', files(t).name))
  fid = fopen(strcat(files(t).folder, '/', files(t).name), 'r');
  c   = fread(fid, sx_a*sy_a, 'float');
  cb  = reshape(c, [sy_a, sx_a]);
  cb  = cb';
  cb  = rot90(rot90(cb));
  noise_projections(:, :, t-2) = cb;
end

noise_projections = single(noise_projections);


%% Lets create a SART test for comparison
[recSART,  errL2SART] = SART(noise_projections, geo, angles, 1, 'OrderStrategy', 'random');

temp    = zeros(sx_b, sy_b, slices, 'double');
maxarea = 0;
bbox    = [];

tl_x = 10000000;
tl_y = 10000000;
br_x = -1;
br_y = -1;

for t=1:slices
    temp(:, :, t)    = recSART(t, :, :);
    level            = graythresh(temp(:, :, t));
    BW               = imbinarize(temp(:, :, t), level);
    BW               = bwareaopen(BW, 504000);
    temp(:, :, t)    = BW.*temp(:, :, t);
    
%     if t > 20 && t < 30
%         st   = regionprops(BW, 'BoundingBox' );
%         
%         disp(st(1).BoundingBox);
%         
%         if tl_x > st(1).BoundingBox(1)
%             tl_x = ceil(st(1).BoundingBox(1));
%         end
%         
%         if tl_y > st(1).BoundingBox(2)
%             tl_y = ceil(st(1).BoundingBox(2));
%         end
%         
%         if br_x < st(1).BoundingBox(3)
%             br_x = ceil(st(1).BoundingBox(3));
%         end
%         
%         if br_y < st(1).BoundingBox(4)
%             br_y = ceil(st(1).BoundingBox(4));
%         end
%         
%         %area = st(1).BoundingBox(3)*st(1).BoundingBox(4);
%         
%         %disp(t);
%         %disp(area);
%             
%         %if area > maxarea
%         %    maxarea = area;
%         %    bbox    = st(1);
%         %end
%         
%     end
end

disp(tl_x);
disp(tl_y);
disp(br_x);
disp(br_y);

%temp = temp(ceil(bbox.BoundingBox(1)):bbox.BoundingBox(4), ceil(bbox.BoundingBox(2)):bbox.BoundingBox(3), :);
%temp = temp(tl_y:br_y,tl_x:br_x,  :);
temp = flip(temp, 3);
disp('Recon Volume size is');
disp(size(temp));

fid = fopen(volume_path, 'w+');
cnt = fwrite(fid, temp, 'float');
fclose(fid);