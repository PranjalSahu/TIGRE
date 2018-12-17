function phantom=readphantom(path, phantomshape)
    fid  = fopen(path, 'r');
    data = fread(fid, phantomshape(1)*phantomshape(2)*phantomshape(3), 'char');  %change the shape of phantom 
    phantom = reshape(data, [phantomshape(1), phantomshape(2), phantomshape(3)]);
end


% show one slice of phantom
% imshow(reshape(phantom(:, 120, :), [329, 939])/10.0);


% Code to get the binary mask of the breast region
% Do it for each slice and then just do the binary multiplcation with the
% volume while back-projecting
%imshow(imerode(imdilate(tp>th,se7),se9));