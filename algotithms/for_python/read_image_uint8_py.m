function [image] = read_image_uint8_py(num)
close all;
clc;
% filename= ['/home/slawek/Pulpit/magisterka/test_images/images1/',int2str(num)];
paths = {...
    '/home/slawek/Pulpit/magisterka/ct_images/23_16_2006/SE3/',...
    '/home/slawek/Pulpit/magisterka/ct_images/23_16_2006/SE4/',...
    '/home/slawek/Pulpit/magisterka/ct_images/211_16_2005/SE3/',...
    '/home/slawek/Pulpit/magisterka/ct_images/217_16_2017/SE3/',...
    '/home/slawek/Pulpit/magisterka/ct_images/239_64_2006/SE3/',...
    '/home/slawek/Pulpit/magisterka/ct_images/407_16_2006/SE3/',...
    };

filename= [paths{1},num];

err = true;
% iminfo = dicominfo(filename);
i = 1;
while(err == true)
    try
        I = dicomread(filename);
        err = false;
        catch e
          i = i +1;
          filename= [paths{i},num];
    end
end

% iminfo = dicominfo(filename);
% I = dicomread(filename);

I = I + 2000;
% I=im2uint8(I);
I = rescale(I,0,1);

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

% I = rescale(I,0,255);
% I = round(I);
J=im2uint8(J);
image = J;
h1 = figure;
imshow(J);
imcontrast(h1);
end

