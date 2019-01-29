startnum = 243;
t        = 1;

ypath    = '/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/DBT_recon_data/full-res-projvolume/SART/65_projvolume/';
tya = load(strcat([ypath, int2str(startnum+t), '.mat']));
tya = tya.recSART;
tya = permute(tya, [2 3 1]);
wd_65 = wavedec3(tya, 3, 'db5');

ypath    = '/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/DBT_recon_data/full-res-projvolume/SART/25_projvolume/';
tyb = load(strcat([ypath, int2str(startnum+t), '.mat']));
tyb = tyb.recSART;
tyb = permute(tyb, [2 3 1]);
wd_25 = wavedec3(tyb, 3, 'db5');


wd_25.dec{1} = wd_65.dec{1};
t1 = waverec3(wd_25);


%imshow([tyb(:, :, 120), t1(:, :, 120), tya(:, :, 120)]*100);
imshow([tyb(:, :, 120), t1(:, :, 120)]*50);%, tya(:, :, 120)]*100);