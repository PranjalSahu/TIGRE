function info = infoArray(path,filename)
%% Function name:       infoArray
%% Version Number:      1.0
%% Description and Usage
% Housekeeping function to read in a series of DICOM headers. 
%% Inputs: absolute path, filename or struct of file attributes
%% Version History
% 1.0   DAS   01/2014  Development
%%
for M = 1:length(filename)
    file = fullfile(path,filename(M).name);
    info{M} = dicominfo(file);
end

end