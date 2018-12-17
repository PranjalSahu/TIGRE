clear; close all; clc;
% subtraction in projection domain

folder_HE='/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/DBT_recon_data/CE26/T_PR_RAW_R-CC_DIAGNOSIS_0006';
folder_LE='/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/DBT_recon_data/CE26/T_PR_RAW_R-CC_DIAGNOSIS_0003';
folder_output='/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/DBT_recon_data/CE26/RE_diff';

imgSet_HE=dir(fullfile(folder_HE,'*.IMA'));
imgSet_LE=dir(fullfile(folder_LE,'*.IMA'));

info=dicominfo(fullfile(folder_LE,imgSet_LE(2).name));
kV=info.KVP;
breastT=info.BodyPartThickness/10; % in cm
wt=0.2538 %calcWF(kV,breastT,'rhodiu',0.0050,'copper',0.0237);

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