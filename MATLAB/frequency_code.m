p = load('/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/DBT_recon_data/full-res-projvolume/65_projvolume/43.mat');
p = p.recFDK;
p = permute(p, [2 3 1]);
p = imresize3(p, [120, 40, 32]);

Y    = fftn(p);
Ys   = fftshift(Y);
Ysz  = Ys;
Yszr = real(Ysz);

Yszr(:, :, 1:12)   = 0;
Yszr(:, :, 20:32)  = 0;
Ysz_new            = complex(Yszr, imag(Ysz));
Yst_new            = ifftshift(Ysz_new);
Yreverse_new       = ifftn(Yst_new);

% imshow(real(Yreverse_new(:, :, 10)*100));
% imshow(real(Y(:, :, 10)*100));