function [image] = read_image(num)
%READ_IMAGE Summary of this function goes here
%   Detailed explanation goes here
close all;
clc;
filename= ['/home/slawek/Pulpit/magisterka/test_images/images1/',int2str(num)];

% iminfo = dicominfo(filename);
I = dicomread(filename);

I = I + 2000;
% I=im2uint8(I);
I = rescale(I,0,1);
I = imadjust(I,[0.7 0.8],[0 1]);
% I = rescale(I,0,255);
% I = round(I);
% I=im2uint8(I);
image = I;
h1 = figure;
imshow(I);
end

