clear; close all; clc;
% subtraction in projection domain

folder_HE='E:\Project\CEDET\data\acquisition\CE20\T_PR_RAW_R-CC_DIAGNOSIS_0006';
folder_LE='E:\Project\CEDET\data\acquisition\CE20\T_PR_RAW_R-CC_DIAGNOSIS_0003';
folder_output='E:\Project\CEDET\data\acquisition\CE20\test';

imgSet_HE=dir(fullfile(folder_HE,'*.IMA'));
imgSet_LE=dir(fullfile(folder_LE,'*.IMA'));

info=dicominfo(fullfile(folder_LE,imgSet_LE(2).name));
kV=info.KVP;
breastT=info.BodyPartThickness/10; % in cm
wt=calcWF(kV,breastT,'rhodiu',0.0050,'copper',0.0237);

for i=1:26
    prj_HE=double(dicomread(fullfile(folder_HE,imgSet_HE(i).name)));
    prj_LE=double(dicomread(fullfile(folder_LE,imgSet_LE(i).name)));
       
    prj_LE(prj_LE<51)=51;
    prj_HE(prj_HE<51)=51;
    prj_sub=log(prj_HE-50)-wt*log(prj_LE-50);
    
    if i<11
        fname_prj=['Sub_prj_0',num2str(i-1),'.IMA'];
    else
        fname_prj=['Sub_prj_',num2str(i-1),'.IMA'];
    end
    
    output_prjsub=fullfile(folder_output,fname_prj);
    dicomwrite(uint16(exp(prj_sub)),output_prjsub,info,'CreateMode','Copy');
end