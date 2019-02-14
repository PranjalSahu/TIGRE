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
disp(names);

statspath = '/media/pranjal/de24af8d-2361-4ea2-a07a-1801b54488d9/duke_phantom/Cohort1/Cohort1.1uncompressed/Cohort1.1uncompressed/';

for i = 1 : length(names)
    name = names(i, :);
    p = strcat(statspath, name, '/', name, '_statistics.txt');
    %disp(p);
    
    fid  = fopen(p, 'r');
    data = fgetl(fid);
    data = fgetl(fid);
    disp(name);
    disp(data);
end
