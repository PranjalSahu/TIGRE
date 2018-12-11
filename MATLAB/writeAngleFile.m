function writeAngleFile(img_path)
% Housekeeping function to write angle file for DBT scan for use in SART
% recon.
%% Inputs: projection path
%% Outputs: angle file written to disk
%% Version Number:      0.0
%% Version History
% 0.0   DAS   02/2016  Development
%%

imgSet = dir(fullfile(img_path,'*.IMA'));
if isempty(imgSet)
    imgSet = dir(fullfile(img_path,'*.dcm'));
end
metaSet = infoArray(img_path,imgSet);

for i = 2:26
    angle(i-1) = metaSet{i}.DetectorPrimaryAngle;
end

angle = angle'*pi/180;

fid = fopen(fullfile(img_path,'angles.ini'),'w');
fwrite(fid,angle,'float');
fclose(fid);

end