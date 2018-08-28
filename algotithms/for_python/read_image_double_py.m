function [image] = read_image_double_py(num)
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
        disp('try')
        I = dicomread(filename);
        err = false;
        catch e
          disp('err')
          i = i +1;
          filename= [paths{i},num];
          disp(num)
    end
end
disp(err)
I = I + 2000;
% I=im2uint8(I);
I = rescale(I,0,1);
I = imadjust(I,[0.7 0.8],[0 1]);
% I = rescale(I,0,255);
% I = round(I);
% I=im2uint8(I);
image = I;
% h1 = figure;
% imshow(I);
end

