startnum = 43;
t = 1;

ypath    = '/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/DBT_recon_data/full-res-projvolume/65_projvolume/';
ty = load(strcat([ypath, int2str(startnum+t)]));
ty = ty.recFDK*100;
ty = permute(ty, [2 3 1]);
ty = imresize3(ty, [120, 40, 32]);
[volume_65, N] = UnifyVolume(ty, 120, 40, 32);

ypath    = '/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/DBT_recon_data/full-res-projvolume/25_projvolume/';
ty = load(strcat([ypath, int2str(startnum+t)]));
ty = ty.recFDK*100;
ty = permute(ty, [2 3 1]);
ty = imresize3(ty, [120, 40, 32]);
[volume_25, N] = UnifyVolume(ty, 120, 40, 32);


spectrum_65 = fft3(volume_65);
%volume_65   = ifftn(spectrum_65);

spectrum_25 = fft3(volume_25);
%volume_25   = ifftn(spectrum_25);

spectrum_25   = fftshift(spectrum_25);
spectrum_25_a = spectrum_25;
spectrum_25_r = real(spectrum_25);
spectrum_25_i = imag(spectrum_25);

spectrum_65   = fftshift(spectrum_65);
spectrum_65_a = spectrum_65;
spectrum_65_r = real(spectrum_65);
spectrum_65_i = imag(spectrum_65);


sa = 42;
ea = 78;
spectrum_25_r(sa:ea, sa:ea, sa:ea) = spectrum_65_r(sa:ea, sa:ea, sa:ea);
spectrum_25_i(sa:ea, sa:ea, sa:ea) = spectrum_65_i(sa:ea, sa:ea, sa:ea);

specgram_25_new = complex(spectrum_25_r, spectrum_25_i);


spectrum_25_new = ifftshift(spectrum_25_new);
va              = ifftn(spectrum_25_new);

va_r = zeros(120, 120, 120);
va_i = zeros(120, 120, 120);




slice = 65;
imshow([real(va(:, :, slice)), real(volume_25(:, :, slice)), real(volume_65(:, :, slice))]);


a = reshape(real(va(:, slice, :)), [120, 120]);
b = reshape(real(volume_25(:, slice, :)), [120, 120]);
c = reshape(real(volume_65(:, slice, :)), [120, 120]);
imshow([a, b, c]);