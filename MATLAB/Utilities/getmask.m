function mask = getmask(init_volume)

    totalsize   = size(init_volume);
    slices   = totalsize(1);
    mask     = zeros(size(init_volume));
    
    se7 = strel('rectangle',[7,7]);
    se9 = strel('rectangle',[9,9]);
    
    for t=1:slices
        tp = reshape(init_volume(t, :, :), totalsize(2), totalsize(3));
        th = graythresh(tp);
        mask(t, :, :)  = imerode(imdilate(tp>th,se7),se9);
    end
end

