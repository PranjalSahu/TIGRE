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
geo.nDetector = [3584;  1800];					    % number of pixels              (px)
geo.dDetector = [0.085; 0.085]; 					% size of each pixel            (mm)
geo.sDetector = geo.nDetector.*geo.dDetector;       % total size of the detector    (mm)


% Image parameters
geo.nVoxel = [46; 2600; 1300];                % number of voxels              (vx)
geo.dVoxel = [1 ; 0.085; 0.085];               % size of each voxel            (mm)
geo.sVoxel = geo.nVoxel.*geo.dVoxel;          % total size of the image       (mm)


% Offsets
Airgap = 17;
geo.offOrigin   = [((geo.sVoxel(1)/2)-(geo.DSD-geo.DSO)+Airgap); 0; geo.sVoxel(3)/2];
%geo.offOrigin  = [-110.5; -110.5; -30];      % Offset of image from origin   (mm)              
geo.offDetector = [0; geo.sDetector(2)/2];    % Offset of Detector            (mm)


% Auxiliary 
geo.COR=0; 
geo.accuracy    = 0.1;                           % Accuracy of FWD proj          (vx/sample)
geo.mode        = 'cone';
geo.rotDetector = [0;0;0]; 

fid = fopen('/media/pranjal/2d33dff3-95f7-4dc0-9842-a9b18bcf1bf9/pranjal/DBT_data/ClinicalExample/CE-12/proj_LE/angles.ini', 'r');
angles = fread(fid, 25, 'float');
angles = angles';
%angles = fliplr(angles);


geo = staticDetectorGeo(geo, angles);
%disp(geo.DSD);

%% Load data and generate projections




%angles = linspace(-25*pi/180, 25*pi/180, 25);

noise_projections = zeros(1800, 3584, 25, 'double');
files = dir('/media/pranjal/2d33dff3-95f7-4dc0-9842-a9b18bcf1bf9/pranjal/DBT_data/ClinicalExample/CE-12/proj_LE/Projections_Renamed_Seg_orig');
for t=3:27
  disp(strcat(files(t).folder, '\', files(t).name))
  fid = fopen(strcat(files(t).folder, '/', files(t).name), 'r');
  c   = fread(fid, 3584*1800, 'float');
  cb  = reshape(c, [3584, 1800]);
  cb = cb';
  noise_projections(:, :, t-2) = cb;
end

%noise_projections = -log(noise_projections./single(2^14-1));
noise_projections = single(noise_projections);

%% Lets create a OS-SART test for comparison
%[imgOSSART, errL2OSSART] = OS_SART(noise_projections, geo, angles, 5, 'OrderStrategy', 'random');

%[recFDK, errL2FDK]  = FDK(noise_projections,  geo,  angles);
%recSART = SART(noise_projections, geo, angles, 2, 'OrderStrategy', 'random', 'InitImg', recFDK);
%[recSART,  errL2SART] = SART(noise_projections, geo, angles, 3, 'OrderStrategy', 'random');
%recFDK = FDK(noise_projections,  geo,  angles);



%3.3106    3.2367    3.2169    3.2064    3.1987
%% Total Variation algorithms
%
%  ASD-POCS: Adaptative Steeppest Descent-Projection On Convex Subsets
% Often called POCS-TV
%==========================================================================
%==========================================================================
%  ASD-POCS minimizes At-B and the TV norm separately in each iteration,
%  i.e. reconstructs the image first and then reduces the TV norm, every
%  iteration. As the other algorithms the mandatory inputs are projections,
%  geometry, angles and maximum iterations.
%
% ASD-POCS has a veriety of optional arguments, and some of them are crucial
% to determine the behaviour of the algorithm. The advantage of ASD-POCS is
% the power to create good images from bad data, but it needs a lot of
% tunning. 
%
%  Optional parameters that are very relevant:
% ----------------------------------------------
%    'maxL2err'    Maximum L2 error to accept an image as valid. This
%                  parameter is crucial for the algorithm, determines at
%                  what point an image should not be updated further.
%                  Default is 20% of the FDK L2 norm.
%                  
% its called epsilon in the paper
%epsilon = errL2OSSART(end);
%   'alpha':       Defines the TV hyperparameter. default is 0.002. 
%                  However the paper mentions 0.2 as good choice
alpha   = 0.005;

%   'TViter':      Defines the amount of TV iterations performed per SART
%                  iteration. Default is 20


%Pranjal Good combination of parameter
%ng = 50, alpha = 0.2
%And
%ng = 25, alpha = 0.2
%And
%ng = 25, alpha = 0.2, iter = 50 (best till)
%ng = 25, alpha = 0.2, iter = 50
%ng = 25, alpha = 0.1, iter = 5  (good one)
ng = 25;

% Other optional parameters
% ----------------------------------------------
%   'lambda':      Sets the value of the hyperparameter for the SART iterations. 
%                  Default is 1
%
%   'lambdared':   Reduction of lambda Every iteration
%                  lambda=lambdared*lambda. Default is 0.99
%
lambda    = 1;
lambdared = 0.98;


%   'alpha_red':   Defines the reduction rate of the TV hyperparameter
alpha_red=0.95;

%   'Ratio':       The maximum allowed image/TV update ration. If the TV 
%                  update changes the image more than this, the parameter
%                  will be reduced.default is 0.95
ratio=0.7;

%   'Verbose'      1 or 0. Default is 1. Gives information about the
%                  progress of the algorithm.

verb=true;

%'maxL2err',epsilon
%imgASDPOCS = ASD_POCS(noise_projections, geo, angles, 5,...
%                    'TViter',ng,'alpha',alpha,... % these are very important
%                    'lambda',lambda,'lambda_red',lambdared,'Ratio', ratio,'Verbose', verb); % less important.







%  OS_ASD_POCS: Odered Subset-TV algorithm
%==========================================================================
%==========================================================================
%
% The logical next step to imporce ASD-POCS is substituting SART with a
% faster algorithm, such as OS-SART
%
% The parameters are the same as in ASD-POCS, but also have 'BlockSize' and
% @OrderStrategy', taken from OS-SART
%'maxL2err',epsilon,

imgOSASDPOCS = OS_ASD_POCS(noise_projections, geo, angles, 25,...
                     'TViter', ng, 'alpha', alpha,... % these are very important
                     'lambda',lambda,'lambda_red',lambdared,'Ratio',ratio,'Verbose',verb,...% less important.
                     'BlockSize', 5,'OrderStrategy','random'); %OSC options
           
                
           
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

%'maxL2err',epsilon
%imgBASDPOCSbeta = B_ASD_POCS_beta(noise_projections, geo, angles, 10,...
%                    'TViter', ng, 'alpha', alpha,... % these are very important
%                     'lambda', lambda, 'lambda_red', lambdared, 'Ratio', ratio, 'Verbose', verb,... % less important.
%                      'beta', 0.5, 'beta_red', 0.7, 'bregman_iter', 5); % bregman options
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
%disp(geo.DSD);
%disp(geo.DSO);

%imgSARTTV = SART_TV(noise_projections, geo, angles, 10, 'TViter', 10, 'TVlambda', 1000);%, 'InitImg', recFDK);           
% Uncomment this block later

temp = zeros(2600, 1300, 46, 'double');
for t=1:46
    %temp(:, :, t)  = imgOSSART(t, :, :);
    %temp(:, :, t) = imgASDPOCS(t, :, :);
    temp(:, :, t) = imgOSASDPOCS(t, :, :);
    %temp(:, :, t) = recFDK(t, :, :);
    %temp(:, :, t) = recSART(t, :, :);
end

fid = fopen('vol29_2600x1300_46.raw','w+');
cnt = fwrite(fid, temp, 'float');
fclose(fid);



 %% Lets visualize the results
% Notice the smoother images due to TV regularization.
%
%     thorax              OS-SART           ASD-POCS         
%    
%     OSC-TV             B-ASD-POCS-beta   SART-TV

%plotImg([ imgOSASDPOCS imgBASDPOCSbeta imgSARTTV; head imgOSSART  imgASDPOCS ] ,'Dim','Z','Step',2)
 % error

%plotImg(abs([ head-imgOSASDPOCS head-imgBASDPOCSbeta head-imgSARTTV;head-head head-imgOSSART  head-imgASDPOCS ]) ,'Dim','Z','Slice',64)




%%

% Obligatory XKCD reference: https://xkcd.com/833/

%fid=fopen('vol_3584x1800.raw','w+');
%cnt=fwrite(fid, imgOSSART(25, :, :), 'double');
%fclose(fid);



