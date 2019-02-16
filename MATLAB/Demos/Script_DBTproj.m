%clc;clear;close all

%folderpathfirst  = '/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/DBT_recon_data/vcts_deformed/';
%folderpathsecond = '_888076.0.575565525455.20180521024130774/Phantom.dat';
%reconpathfirst   = '/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/DBT_recon_data/low-res-projvolume/SART/db3/45_random_projvolume_wave/';


folderpathfirst  = '/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/duke_phantom/attenuation_values/';
folderpathsecond = '.mat';
reconpathfirst   = '/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/duke_phantom/SART/db3/25_proj_wave/';


TotalAngles      = 25;
t_cpu = cputime;

for phantomindex=1:176
    
    disp(phantomindex);
    
    phantompath  = strcat([folderpathfirst, int2str(phantomindex), folderpathsecond]);
    reconpath    = strcat([reconpathfirst, int2str(phantomindex), '.mat']) ;
    
    % Size for the unet model >> 960, 384, 256 >> db1
    % 120, 48, 32
    % Size for the unet model >> 989, 356, 290 >> db3
    % 128, 48, 40
    % Size for the unet model >> 804, 480, 350 >> db3
    % 104, 48, 64

    sx_a   = 1600;
    sy_a   = 4000;
    
    slices = 350;
    sx_b   = 804;
    sy_b   = 480;
    
    offdetector_height = sy_b*0.25/2;


    geo.DSD = 655;                             % Distance Source Detector      (mm)
    geo.DSO = 608;                             % Distance Source Origin        (mm)
    geo.nDetector = [sy_a;  sx_a];


    % Detector parameters
    geo.nDetector = [sy_a;  sx_a];                      % number of pixels              (px)
    geo.dDetector = [0.085; 0.085];                     % size of each pixel            (mm)
    geo.sDetector = geo.nDetector.*geo.dDetector;       % total size of the detector    (mm)


    % Image parameters
    geo.nVoxel = [slices; sx_b; sy_b];             % number of voxels              (vx)
    geo.dVoxel = [0.25 ; 0.25; 0.25];                 % size of each voxel            (mm)
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

    angles = linspace(-TotalAngles*pi/180, TotalAngles*pi/180, TotalAngles);
    angles = fliplr(angles);


    geo = staticDetectorGeo(geo, angles, offdetector_height);



    %% Adapt DBT projections to TIGRE CT projections
    disp(phantompath);
    
    %head        = readphantom(phantompath, [329 249 939]);
    %head        = padarray(head, [20 25 13],'both');
    %head        = padarray(head, [1 0 1],  'post');
    %head        = single(head/300);
    
    head = load(phantompath);
    head = single(head.head);
    head = permute(head, [1 3 2]);
    head = permute(head, [3 1 2]);
    projections = Ax(head, geo, angles,'interpolated');
    
    %recFDK = FDK( projections,geo,angles);
    
    %[recSART_all, recSART,  errL2SART] = SART(projections, geo, angles, 1, 1, phantomindex, 'OrderStrategy', 'random', 'init', 'image', 'initimg', recFDK);
    [recSART_all, recSART,  errL2SART] = SART(projections, geo, angles, 1, 1, phantomindex, 'OrderStrategy', 'random');
    
    
    save(reconpath, 'recSART_all');
end

e_cpu = cputime;
disp(e_cpu-t_cpu);