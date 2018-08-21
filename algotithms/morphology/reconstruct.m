function [output_img] = reconstruct(image)
%RECONSTRUCT Summary of this function goes here
%   Detailed explanation goes here
figure;
marker = roipoly(image);
% p2 = min(im2uint8(p),im1);
output_img = imreconstruct(marker,image);
end

