startnum = 43;
t = 1;

ypath    = '/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/DBT_recon_data/full-res-projvolume/65_projvolume/';
ty = load(strcat([ypath, int2str(startnum+t)]));
ty = ty.recFDK*100;
ty = permute(ty, [2 3 1]);
%ty = imresize3(ty, [240, 80, 64]);
[volume_65, N] = UnifyVolume(ty, 240, 80, 64);

ypath    = '/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/DBT_recon_data/full-res-projvolume/25_projvolume/';
ty = load(strcat([ypath, int2str(startnum+t)]));
ty = ty.recFDK*100;
ty = permute(ty, [2 3 1]);
%ty = imresize3(ty, [240, 80, 64]);
[volume_25, N] = UnifyVolume(ty, 240, 80, 64);

%disp(size(volume_25));

spectrum_65 = fft3(volume_65);
%volume_65   = ifftn(spectrum_65);

spectrum_25 = fft3(volume_25);
%volume_25   = ifftn(spectrum_25);

disp(size(spectrum_65));

spectrum_25   = fftshift(spectrum_25);
spectrum_25_a = spectrum_25;
spectrum_25_r = real(spectrum_25);
spectrum_25_i = imag(spectrum_25);

spectrum_65   = fftshift(spectrum_65);
spectrum_65_a = spectrum_65;
spectrum_65_r = real(spectrum_65);
spectrum_65_i = imag(spectrum_65);

%disp(size(spectrum_65));

sa1 = 120-10;
ea1 = 120+10;

sa2 = 120-10;
ea2 = 120+10;

sa3 = 120-30;
ea3 = 120+30;

%spectrum_25_r(sa:ea, sa:ea, sa:ea) = spectrum_65_r(sa:ea, sa:ea, sa:ea);
%spectrum_25_i(sa:ea, sa:ea, sa:ea) = spectrum_65_i(sa:ea, sa:ea, sa:ea);

spectrum_25_r(sa1:ea1, sa2:ea2, sa3:ea3) = spectrum_65_r(sa1:ea1, sa2:ea2, sa3:ea3);
spectrum_25_i(sa1:ea1, sa2:ea2, sa3:ea3) = spectrum_65_i(sa1:ea1, sa2:ea2, sa3:ea3);


spectrum_25_new = complex(spectrum_25_r, spectrum_25_i);
spectrum_25_new = ifftshift(spectrum_25_new);
va              = ifftn(spectrum_25_new);

%disp(size(specgram_25_new));

% va_r = zeros(240, 240, 240);
% va_i = zeros(240, 240, 240);
% 
% va_r(sa1:ea1, sa2:ea2, :) = spectrum_65_r(sa1:ea1, sa2:ea2, :);
% %va_i(sa1:ea1, sa2:ea2, :) = spectrum_65_i(sa1:ea1, sa2:ea2, :);
% va_i(sa1:ea1, sa2:ea2, :) = spectrum_65_i(sa1:ea1, sa2:ea2, :);
% %va_i = spectrum_65_i;
% 
% va_new = complex(va_r, va_i);
% va_new = ifftshift(va_new);
% va_new = ifftn(va_new);

slice = 120;
%imshow([real(va(:, :, slice)), real(volume_25(:, :, slice)), real(volume_65(:, :, slice))]);



a = reshape(real(va(:, slice, :)), [120*2, 120*2]);
b = reshape(real(volume_25(:, slice, :)), [120*2, 120*2]);
c = reshape(real(volume_65(:, slice, :)), [120*2, 120*2]);
imshow([a, b, c]);