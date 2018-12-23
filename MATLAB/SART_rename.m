%% Function to rename projection images for SART Recon
% HHuang add 'crop_column= '. 10/04/2016
clear; clc
projDir     = '/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/DBT_recon_data/CE26/T_PR_RAW_R-CC_DIAGNOSIS_0003';
projSubName = 'CE26';
crop_column = 860;

outputDir = fullfile(projDir, 'Projections_Renamed_Seg'); % auto make output dir

%===================================%
if ~exist(outputDir,'dir');
    mkdir(outputDir);
end

imgSet = dir(fullfile(projDir,'*.IMA'));
info = dicominfo(fullfile(projDir,imgSet(2).name));
mAs = info.ExposureInuAs/1000;
filter = info.FilterMaterial;
laterality = info.ImageLaterality;
kVp = info.KVP;

if kVp < 49
    thresh = 0.001;
else
    thresh = 0.06;
end

switch filter
    case{'RHODIUM'},
        p = [70.4519   -3.1224];
    case{'TITANIUM'},
        p = [234.5246   -0.5660];
    case{'COPPER'},
        p = [153.8140   -1.9659];
end

I0 = polyval(p,mAs);
% I0 = 1;

for i = 2:length(imgSet)
    imgName = imgSet(i).name;
    fileIdx = num2str(i-1,'%04d');

    projImg = double(dicomread(fullfile(projDir,imgName)));
    
%     projImg = segmentProjection(projImg);
    
    if strcmp(laterality,'R'), projImg = imrotate(projImg,180); end
    projImg = projImg(:,1:crop_column);
    
    projImg = fliplr(projImg - 50); % Subtract detector offset
    projImg = -log(abs(projImg./I0));
%     projImg = abs(projImg);
    projImg = projImg - min(min(projImg));

%     projImg(1:100,:) = 0;
%     projImg(end-100:end,:) = 0;
%     projImg(projImg<thresh) = 0;
    
    projImg(isinf(projImg)) = 1;
    
    [dimX dimY] = size(projImg);
    
    outputProjName = [projSubName '.' num2str(dimX) 'x' num2str(dimY) '.' fileIdx];
    outputProjPath = fullfile(outputDir,outputProjName);
    fid=fopen(outputProjPath,'w');
    fwrite(fid,projImg,'float');
    fclose(fid);
    
%     figure; imagesc(projImg);
    disp(['Writing projection ' num2str(i) '...']);
end

disp('Rewrite complete.');