%% Initialize
clear;
close all;




%% Define Geometry
% 
% VARIABLE                                   DESCRIPTION                    UNITS
%-------------------------------------------------------------------------------------
geo.DSD = 655;                             % Distance Source Detector      (mm)
geo.DSO = 608;                             % Distance Source Origin        (mm)


% Detector parameters
geo.nDetector = [3584;  1618];					    % number of pixels              (px)
geo.dDetector = [0.085; 0.085]; 					% size of each pixel            (mm)
geo.sDetector = geo.nDetector.*geo.dDetector;       % total size of the detector    (mm)


slices = 71;
sx_b = 2690;
sy_b = 1198;

% Image parameters
geo.nVoxel = [slices; sx_b; sy_b];                % number of voxels              (vx)
geo.dVoxel = [1 ; 0.085; 0.085];               % size of each voxel            (mm)
geo.sVoxel = geo.nVoxel.*geo.dVoxel;          % total size of the image       (mm)


% Offsets
Airgap = 17;
geo.offOrigin   = [((geo.sVoxel(1)/2)-(geo.DSD-geo.DSO)+Airgap); 0; geo.sVoxel(3)/2];
%geo.offOrigin  = [-110.5; -110.5; -30];      % Offset of image from origin   (mm)              
geo.offDetector = [0; 0];    % Offset of Detector            (mm)


% Auxiliary 
geo.COR=0; 
geo.accuracy    = 0.1;                           % Accuracy of FWD proj          (vx/sample)
geo.mode        = 'cone';
geo.rotDetector = [0;0;0]; 

fid    = fopen('C:\Users\psahu\ClinicalExample\CE14\LE_proj\angles.ini', 'r');
angles = fread(fid, 25, 'float');
angles = angles';
%angles = fliplr(angles);


geo = staticDetectorGeo(geo, angles);

%% Load data and generate projections

sx_a = 1618;
sy_a = 3584;

noise_projections = zeros(sx_a, sy_a, 25, 'double');
files = dir('C:\Users\psahu\ClinicalExample\CE14\LE_proj\Projections_Renamed_Seg\');
for t=3:27
  disp(strcat(files(t).folder, '\', files(t).name));
  fid = fopen(strcat(files(t).folder, '/', files(t).name), 'r');
  c   = fread(fid, sx_a*sy_a, 'float');
  cb  = reshape(c, [sy_a, sx_a]);
  cb = cb';
  noise_projections(:, :, t-2) = cb;
end

%noise_projections = -log(noise_projections./single(2^14-1));
noise_projections = single(noise_projections);

%% Lets create a OS-SART test for comparison
%[imgOSSART, errL2OSSART] = OS_SART(noise_projections, geo, angles, 20);

%recFDK  = FDK(noise_projections,  geo,  angles);
%recSART = SART(noise_projections, geo, angles, 1, 'OrderStrategy', 'random', 'InitImg', recFDK);
%recSART = SART(noise_projections, geo, angles, 2, 'OrderStrategy', 'random');
%recFDK = FDK(noise_projections,  geo,  angles);

%imgSARTTV = SART_TV(noise_projections,geo,angles,50,'TViter',100,'TVlambda',50);





alpha=0.05;
ng=25;
lambda=1;
lambdared=0.98;
alpha_red=0.95;
ratio=0.7;
verb=true;

imgOSASDPOCS = OS_ASD_POCS(noise_projections, geo, angles, 25,...
                     'TViter', ng, 'alpha', alpha,... % these are very important
                     'lambda',lambda,'lambda_red',lambdared,'Ratio',ratio,'Verbose',verb,...% less important.
                     'BlockSize', 5,'OrderStrategy','random'); % less important.

temp = zeros(sx_b, sy_b, slices, 'double');
for t=1:71
    temp(:, :, t) = imgOSASDPOCS(t, :, :);
end

fid = fopen('vol-ce-14-pocs_2690x1198_71.raw','w+');
cnt = fwrite(fid, temp, 'float');
fclose(fid);

                 
%  OS_ASD_POCS: Odered Subset-TV algorithm
%==========================================================================
%==========================================================================
%
% The logical next step to imporce ASD-POCS is substituting SART with a
% faster algorithm, such as OS-SART
%
% The parameters are the same as in ASD-POCS, but also have 'BlockSize' and
% @OrderStrategy', taken from OS-SART

%imgOSASDPOCS = OS_ASD_POCS(noise_projections,geo,angles,50,...
%                     'TViter',ng,'maxL2err',epsilon,'alpha',alpha,... % these are very important
%                     'lambda',lambda,'lambda_red',lambdared,'Ratio',ratio,'Verbose',verb,...% less important.
%                     'BlockSize',size(angles,2)/10,'OrderStrategy','angularDistance'); %OSC options
           
                
           
%  B-ASD-POCS-beta 
%==========================================================================
%==========================================================================
% Is another version of ASD-POCS that has uses Bregman iteration, i.e.
% updates the data vector every some ASD-POCS iteration, bringing closer
% the data to the actual image. According to the original article, this
% accelerates convergence rates, giving a better image in the same amount
% of iteratiosn.
%
% It has all the inputs from ASD-POCS, and has 3 extra:
%   'beta'         hyperparameter controling the Bragman update. default=1
% 
%   'beta_red'     reduction of the beta hyperparameter. default =0.75
% 
%   'bregman_iter' amount of global bregman iterations. This will define
%                  how often the bregman iteration is executed. It has to
%                  be smaller than the number of iterations.

%Note that the number of iteration for TV has changed

%Uncomment this block later
%imgBASDPOCSbeta=B_ASD_POCS_beta(noise_projections,geo,angles,50,...
%                    'TViter',40,'maxL2err',epsilon,'alpha',alpha,... % these are very important
%                     'lambda',lambda,'lambda_red',lambdared,'Ratio',ratio,'Verbose',verb,... % less important.
%                      'beta',0.5,'beta_red',0.7,'bregman_iter',10); % bregman options
%Uncomment this block later 

%   SART-TV 
%==========================================================================
%==========================================================================      
%
%   This implementation differs more from the others, as it minimizes the
%   ROF model, i.e. when minimizing the total variation of the image, it
%   also takes into account the information of the image. If only the total
%   variation minimization step was run in the rest of the algorithms, the
%   result would be a flat image (as that is the minimum total variation
%   image), altertatively, the ROF model enforces the image not to change too
%   much.
%   
%   This algirths performs better with more projections, but noisy data, by
%   enforncing the TV very little
%  
%   The optional parameters are for the total variatiot part of the image:
%
%
%  
%   'TViter'       amoutn of iteration in theTV step. Default 50
% 
%   'TVlambda'     hyperparameter in TV iteration. IT gives the ratio of
%                  importance of the image vs the minimum total variation.
%                  default is 15. Lower means more TV denoising.
% 
                  
% Uncomment this block later
%imgSARTTV = SART_TV(noise_projections,geo,angles,50,'TViter',100,'TVlambda',50);           
% Uncomment this block later



%%

% Obligatory XKCD reference: https://xkcd.com/833/

%fid=fopen('vol_3584x1800.raw','w+');
%cnt=fwrite(fid, imgOSSART(25, :, :), 'double');
%fclose(fid);


