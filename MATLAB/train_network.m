imageSize    = [480 640 50];
numClasses   = 5;
encoderDepth = 3;
lgraph       = unetLayers(imageSize,numClasses,'EncoderDepth',encoderDepth);
disp(lgraph);