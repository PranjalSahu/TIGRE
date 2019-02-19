%clc;clear;close all

%folderpathfirst  = '/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/DBT_recon_data/vcts_deformed/';
%folderpathsecond = '_888076.0.575565525455.20180521024130774/Phantom.dat';
%reconpathfirst   = '/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/DBT_recon_data/low-res-projvolume/SART/db3/45_random_projvolume_wave/';


folderpathfirst  = '/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/duke_phantom/attenuation_values/';
folderpathsecond = '.mat';

reconpath_orig   = '/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/duke_phantom/SART/db3/65_proj_wave_full_resolution/';
reconpath_new   = '/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/duke_phantom/SART/db3/65_proj_wave_4/';


for phantomindex=1:176
    
    disp(phantomindex);
    
    reconpath        = strcat([reconpath_orig, int2str(phantomindex), '.mat']) ;
    reconpath_second = strcat([reconpath_new, int2str(phantomindex), '.mat']) ;
    
    res = load(reconpath);
    res = res.recSART_all;
    wd2           = wavedec3(res, 3, 'db3');
    recSART_all   = wd2.dec{1};
    
    disp(size(recSART_all));
    save(reconpath_second, 'recSART_all');
end