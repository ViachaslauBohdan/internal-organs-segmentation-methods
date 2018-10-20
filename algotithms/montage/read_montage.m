function [im_array,I] = read_montage()
close all;
clear;
im_sets = {'23_16_2006/','211_16_2005/','217_16_2017/','239_64_2006/','407_16_2006/'};



im_set = im_sets{1,3};


path_to_folder = strcat('~/','Pulpit/magisterka/ct_images/',im_set,'SE3/');
dicomlist = dir(path_to_folder);
filenames = string({dicomlist.name});
filenames(1:2)=[];
im_amount = numel(filenames);

im_array = cell(1,im_amount);
for i=1:numel(filenames)
    im_array{i}=dicomread(strcat(path_to_folder,filenames(i))); 
    info = dicominfo(strcat(path_to_folder,filenames(i)));
    info.ImagePositionPatient
end

res = input('adjust images? (y/n):','s');
if(res=='y' || res=='Y')
    [im_array] = cuthist(im_array,filenames);
end

figure;
num_of_cols = 8;
for i=1:im_amount
     subplottight(floor(im_amount/num_of_cols) + mod(im_amount,num_of_cols),num_of_cols,i);
     imshow(im_array{i},'border', 'tight');
end

% fig = figure;
% I =im_array{19};
% imshow(im_array{9});
% i = imcontrast(fig);

end

function h = subplottight(n,m,i)
    [c,r] = ind2sub([m n], i);
    ax = subplot('Position', [(c-1)/m, 1-(r)/n, 1/m, 1/n]);
    set(gca,'Visible','off')
    if(nargout > 0)
      h = ax;
    end
end

function im_array = cuthist(im_array,filenames)
    for i=1:numel(filenames)
        im_array{i} = im_array{i} + 2000;
        im_array{i} = rescale(im_array{i},0,1);
%         im_array{i} = imadjust(im_array{i},[0.7 0.8],[0 1]);
        im_array{i} = iterative_cut_hist(im_array{i});
        im_array{i}=im2uint8(im_array{i});
    end
end

function J = iterative_cut_hist(I)


in_range1 = 0.65;
in_range2 = 1;
stop_first_loop = false;
for i=1:150
    J = imadjust(I,[in_range1 in_range2],[0 1]);
    I = J;
    N = histcounts(J);
    for j=2:size(N,2)
        if(N(1,j) < 250 || N(1,size(N,2)-j) < 250)
            if(N(1,j) < 250)
                in_range1 = 0.02;
            else
                in_range1 = 0;
            end
            
            if(N(1,size(N,2)-j) < 250)
                in_range2 = 0.98;
            else
                in_range2 = 1;
            end
        break

        else
            stop_first_loop = true;
            break
        end
    end
    
    if(stop_first_loop == 1)
        break
    end
end
end
