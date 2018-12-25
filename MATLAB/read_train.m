function [xtrain, ytrain, xvalid, yvalid]=read_train(samples, validate_samples)

    startnum = 42;
    
    xpath    = '/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/DBT_recon_data/25_projvolume/';
    ypath    = '/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/DBT_recon_data/65_projvolume/';
    
    xtrain = zeros(240, 80, 64, samples, 'single');
    ytrain = zeros(240, 80, 64, samples, 'single');
    
    xvalid = zeros(240, 80, 64, validate_samples, 'single');
    yvalid = zeros(240, 80, 64, validate_samples, 'single');
    
    for t=1:samples
        
        tx = load(strcat([xpath, int2str(startnum+t)]));
        tx = permute(tx.recFDK, [2 3 1]);
        tx = imresize3(tx, [240, 80, 64]);
        
        ty = load(strcat([ypath, int2str(startnum+t)]));
        ty = permute(ty.recFDK, [2 3 1]);
        ty = imresize3(ty, [240, 80, 64]);
        
        xtrain(:, :, :, t) = tx;
        ytrain(:, :, :, t) = ty;
        
    end
    
    for t=1:validate_samples
        tx = load(strcat([xpath, int2str(startnum+t+samples)]));
        tx = permute(tx.recFDK, [2 3 1]);
        tx = imresize3(tx, [240, 80, 64]);
        
        ty = load(strcat([ypath, int2str(startnum+t+samples)]));
        ty = permute(ty.recFDK, [2 3 1]);
        ty = imresize3(ty, [240, 80, 64]);
        
        xvalid(:, :, :, t) = tx;
        yvalid(:, :, :, t) = ty;
    end
    
    
end