p    = '/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/duke_phantom/Cohort1/Cohort1.1uncompressed/Cohort1.1uncompressed/stat.txt';
fid  = fopen(p, 'r');
names = [];
while 1
    data = fgetl(fid);
    if data == -1
        break;
    end
    names = [names; data];
end

% statspath = '/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/duke_phantom/Cohort1/Cohort1.1uncompressed/Cohort1.1uncompressed/';
% 
% all_arr = [];
% for i = 1 : length(names)
%     name = names(i, :);
%     p = strcat(statspath, name, '/', name, '_statistics.txt');
%     %disp(p);
%     
%     fid  = fopen(p, 'r');
%     data = fgetl(fid);
%     data = fgetl(fid);
%     
%     disp(data);
%     s = strsplit(data);
%     
%     arr = [];
%     if length(s) == 8
%         for tw=4:8
%             arr(tw-3) = str2num(char(s(tw)));
%         end
%         arr(6) = arr(5);
%     else
%         for tw=4:9
%             arr(tw-3) = str2num(char(s(tw)));
%         end
%     end
%     
%     all_arr = [all_arr; arr];
% end
% 
% 
% % all_values = [];
% % for i=1:length(all_arr)
% %     temp = [];
% %     for j=1:6
% %         a = mean_mu_breast(20, all_arr(i, j));
% %         temp = [temp a];
% %     end
% %     all_values = [all_values; temp];
% % end

% Size for the unet model >> 960, 384, 256 >> db1
% 120, 48, 32
% Size for the uner model >> 989, 356, 290 >> db3
% 128, 48, 40

% Duke Phantom
% Size for the uner model >> 804, 337, 435 >> db3
% 804, 350, 480
% 104, 48, 64


f        = dir('/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/duke_phantom/Cohort1/Cohort1.1_compressed/Cohort1.1_compressed/*.img');
img_path = '/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/duke_phantom/Cohort1/Cohort1.1_compressed/Cohort1.1_compressed/';


for i=1:length(names)
    path = dir(strcat(img_path, '/',  names(i, :),'*.img'));
    if length(path) == 1
        path = path(1).name;
        disp(path);
    end
end

%x_all = [];
%y_all = [];
%z_all = [];

% for i =1:length(f)
%     name = f(i).name;
%     path = strcat([img_path, name]);
%     s = strsplit(name, '_');
%     p = strsplit(s{5}, '.');
%     
%     x = str2num(s{3});
%     y = str2num(s{4});
%     z = str2num(p{1});
%     
%     %x_all = [x_all x];
%     %y_all = [y_all y];
%     %z_all = [z_all z];
%     
%     data = fread(fid, x*y*z, 'uint8');
%     data = reshape(data, [x, y, z]);
%     
%     head = padarray(data, [floor(804-x)/2 floor((350-y)/2) floor((480-z)/2)],'both');
%     [x, y, z] = size(head);
%     head = padarray(head, [804-x 350-y 480-z],  'post');
%     
%     
%     wd2       = wavedec3(head, 3, 'db3');
% end