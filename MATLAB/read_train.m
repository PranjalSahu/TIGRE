function [xtrain, ytrain, xvalid, yvalid]=read_train(samples, validate_samples)

    startnum = 69;
    
    
    folderpathfirst  = '/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/DBT_recon_data/low-res-projvolume/vcts_deformed/';
    folderpathsecond = '_888076.0.575565525455.20180521024130774/Phantom.dat';

    %xpath    = '/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/DBT_recon_data/full-res-projvolume/25_projvolume/';
    %ypath    = '/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/DBT_recon_data/full-res-projvolume/65_projvolume/';
    
    recon_x_path = '/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/DBT_recon_data/low-res-projvolume/25_projvolume/';
    recon_y_path = '/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/DBT_recon_data/low-res-projvolume/65_projvolume/';
    
    xtrain = zeros(240, 80, 64, samples, 'single');
    ytrain = zeros(240, 80, 64, samples, 'single');
    
    xvalid = zeros(240, 80, 64, validate_samples, 'single');
    yvalid = zeros(240, 80, 64, validate_samples, 'single');
    
    for t=1:samples
        phantompath  = strcat([folderpathfirst, int2str(startnum+t), folderpathsecond]);
        
        head = readphantom(phantompath, [329 249 939]);
        head = permute(head, [2 3 1]);
        head = single(head>0);
        head = imresize3(head, [120, 40, 32]);
        
        tx = load(strcat([xpath, int2str(startnum+t)]));
        tx = permute(tx.recFDK, [2 3 1]);
        tx = imresize3(tx, [120, 40, 32]);
        
        ty = load(strcat([ypath, int2str(startnum+t)]));
        ty = permute(ty.recFDK, [2 3 1]);
        ty = imresize3(ty, [120, 40, 32]);
        
        %xtrain(:, :, :, t) = tx;
        %ytrain(:, :, :, t) = ty;
        
        recFDK = tx.*head;
        save(strcat([recon_x_path, int2str(startnum+t)]), 'recFDK');
        
        recFDK = ty.*head;
        save(strcat([recon_y_path, int2str(startnum+t)]), 'recFDK');
    end
    
%     for t=1:validate_samples
%         tx = load(strcat([xpath, int2str(startnum+t+samples)]));
%         tx = permute(tx.recFDK, [2 3 1]);
%         tx = imresize3(tx, [240, 80, 64]);
%         
%         ty = load(strcat([ypath, int2str(startnum+t+samples)]));
%         ty = permute(ty.recFDK, [2 3 1]);
%         ty = imresize3(ty, [240, 80, 64]);
%         
%         xvalid(:, :, :, t) = tx;
%         yvalid(:, :, :, t) = ty;
%     end
    
    
end