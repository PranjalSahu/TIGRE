lgraph = get_unet();



function lgraph=get_unet()
    imageSize    = [240, 80, 64];
    numClasses   = 2;
    encoderDepth = 3;
    lgraph       = unetLayers(imageSize,numClasses,'EncoderDepth',encoderDepth);
    lgraph       = removeLayers(lgraph, 'Segmentation-Layer');
    lgraph       = removeLayers(lgraph, 'Softmax-Layer');
    lgraph       = removeLayers(lgraph, 'Final-ConvolutionLayer');

    pl      = convolution2dLayer(1, 1, 'Padding', 'same','Name','output');
    layer   = regressionLayer('Name','routput');

    lgraph  = addLayers(lgraph, pl);
    lgraph  = addLayers(lgraph, layer);

    lgraph  = connectLayers(lgraph, 'Decoder-Stage-3-ReLU-2', 'output');
    lgraph  = connectLayers(lgraph, 'output', 'routput');

    disp(lgraph);
end


function [xtrain, ytrain]=read_train(samples)

    startnum = 42;
    xpath    = '/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/DBT_recon_data/25_projvolume/';
    ypath    = '/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/DBT_recon_data/35_projvolume/';
    
    xtrain = zeros(240, 80, 64, samples, 'single');
    ytrain = zeros(240, 80, 64, samples, 'single');
    
    for t=1:samples
        tx = load(strcat([xpath, int2str(startnum+t)]));
        tx = imresize3(tx.recFDK, [240, 80, 64]);
        
        ty = load(strcat([ypath, int2str(startnum+t)]));
        ty = imresize3(ty.recFDK, [240, 80, 64]);
        
        xtrain(:, :, :, t) = tx;
        ytrain(:, :, :, t) = ty;
    end
    
end