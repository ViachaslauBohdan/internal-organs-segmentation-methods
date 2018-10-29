function [image] = read_image_uint8_py(num)
close all;
clc;
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
        info = dicominfo(filename);
        err = false;
        catch e
          i = i +1;
          filename= [paths{i},num];
    end
end

lowest_val = ((info.WindowCenter - info.WindowWidth/2) - info.RescaleIntercept)  / info.RescaleSlope
highest_val =((info.WindowCenter + info.WindowWidth/2)  - info.RescaleIntercept) / info.RescaleSlope
%figure;
%imshow(I,[lowest_val, highest_val]);

[lowest_row, lowest_col] = find(I==lowest_val,1);
[highest_row, highest_col] = find(I==highest_val,1);
I = I +2000;
I_rescaled = rescale(I,0,1);

J = imadjust(I_rescaled,[I_rescaled(lowest_row,lowest_col), I_rescaled(highest_row,highest_col)],[0 1]);


J=im2uint8(J);
image = J;
end

