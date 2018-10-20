function [output_img,marker] = reconstruct(image)
%RECONSTRUCT Summary of this function goes here
%   Detailed explanation goes here
figure;
% marker = roipoly(image);
marker = logical(zeros(size(image)));

imshow(image,[]);
[xi,yi] = ginput;
xi = round(xi);
yi = round(yi);
xi
yi
marker(yi,xi) = true;
figure;
imshow(marker);
title('marker');
% p2 = min(im2uint8(p),im1);
output_img = imreconstruct(marker,image);
end

