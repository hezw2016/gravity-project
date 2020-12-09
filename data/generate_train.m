clc
clear all;
close all;

%%
folder_hr = './HR';
folder_lr = './LR';

savepath = 'train.h5';

size_input = 48; % input: the low-resolution
size_label = 48; % label: the high-resolution
var_thres = 0.0005;
empty_ratio_thres = 0.01;

%% initialization
data = zeros(size_input, size_input, 3, 1);
label = zeros(size_label, size_label, 3, 1);

count = 0;

%% generate data
filepaths_hr = dir(fullfile(folder_hr, '*.png'));
filepaths_lr = dir(fullfile(folder_lr, '*.png'));

for i = 1 : length(filepaths_hr)
    for flip = 1: 3
        for degree = 1 : 4          
            image_hr = im2double(imread(fullfile(folder_hr,filepaths_hr(i).name)));
            image_lr = im2double(imread(fullfile(folder_lr,filepaths_lr(i).name)));

            if flip == 1
                image_hr = flipdim(image_hr ,1);
                image_lr = flipdim(image_lr ,1);
            end
            if flip == 2
                image_hr = flipdim(image_hr ,2);
                image_lr = flipdim(image_lr ,2);
            end
                    
            image_hr = imrotate(image_hr, 90 * (degree - 1));
            image_lr = imrotate(image_lr, 90 * (degree - 1));
           
            filepaths_hr(i).name
            
            im_input = image_lr;
            im_label = image_hr;
            
            [hei,wid,channel] = size(im_label);
            
            for index =  1 : 10000
                x = randi(hei-size_input+1, 1, 1);
                y = randi(wid-size_input+1, 1, 1);
                
                subim_input = im_input(x : x+size_input-1, y : y+size_input-1, :);
                subim_label = im_label(x : x+size_label-1, y : y+size_label-1, :);
                
                % check the number of white points (R=1G=1B=1) in HR
                % patches
                % control the variance of LR patches
                number = length(find(subim_label==1));
                if number < empty_ratio_thres*size_label*size_label
                    if var(rgb2gray(subim_input)) > var_thres
                        count=count+1;

                        data(:, :, :, count) = subim_input;
                        label(:, :, :, count) = subim_label;
                        imwrite(subim_input, ['./LRpatch/' num2str(count) '.png'])
                        imwrite(subim_label, ['./HRpatch/' num2str(count) '.png'])
                    end
                end                
            end
        end    
    end
end


order = randperm(count);
data = data(:, :, :, order);
label = label(:, :, :, order); 

%% writing to HDF5
chunksz = 64;
created_flag = false;
totalct = 0;

for batchno = 1:floor(count/chunksz)
    batchno
    last_read=(batchno-1)*chunksz;
    batchdata = data(:,:,:,last_read+1:last_read+chunksz); 
    batchlabs = label(:,:,:,last_read+1:last_read+chunksz);

    startloc = struct('dat',[1,1,1,totalct+1], 'lab', [1,1,1,totalct+1]);
    curr_dat_sz = store2hdf5(savepath, batchdata, batchlabs, ~created_flag, startloc, chunksz); 
    created_flag = true;
    totalct = curr_dat_sz(end);
end

h5disp(savepath);
