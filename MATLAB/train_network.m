lgraph = get_unet();

%[xtrain, ytrain, xvalid, yvalid] = read_train(25, 3);

% options = trainingOptions('sgdm', 'LearnRateSchedule', 'piecewise', 'LearnRateDropPeriod', 500, ...
%     'InitialLearnRate',0.0001, 'LearnRateDropFactor', 0.4,...
%     'Verbose',false,...
%     'Plots','training-progress',...
%     'Shuffle', 'every-epoch', 'MaxEpochs', 100000, 'MiniBatchSize', 24, 'ValidationData',{xvalid, yvalid});

options = trainingOptions('adam', 'LearnRateSchedule', 'piecewise', 'LearnRateDropPeriod', 2000,...
    'InitialLearnRate',0.0001,'LearnRateDropFactor', 0.5,...
    'Verbose',false,...
    'Plots','training-progress',...
    'Shuffle', 'every-epoch', 'MaxEpochs', 10000, 'MiniBatchSize', 24, 'ValidationData',{xvalid, yvalid});

disp('Training data reading complete');

[net, info]            = trainNetwork(xtrain, ytrain, lgraph, options);

function lgraph=get_unet()
    imageSize    = [64, 240, 80];
    numClasses   = 2;
    encoderDepth = 3;
    lgraph       = unetLayers(imageSize,numClasses,'EncoderDepth',encoderDepth);
    lgraph       = removeLayers(lgraph, 'Segmentation-Layer');
    lgraph       = removeLayers(lgraph, 'Softmax-Layer');
    lgraph       = removeLayers(lgraph, 'Final-ConvolutionLayer');

    pl      = convolution2dLayer(1, 80, 'Padding', 'same','Name','output');
    layer   = regressionLayer('Name','routput');

    lgraph  = addLayers(lgraph, pl);
    lgraph  = addLayers(lgraph, layer);

    lgraph  = connectLayers(lgraph, 'Decoder-Stage-3-ReLU-2', 'output');
    lgraph  = connectLayers(lgraph, 'output', 'routput');

    disp(lgraph);
end



