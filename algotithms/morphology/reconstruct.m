function [im_reconstructed] = reconstruct(image)
%RECONSTRUCT Summary of this function goes here
%   Detailed explanation goes here

marker = roipoly(image);
% p2 = min(im2uint8(p),im1);
im_reconstructed = imreconstruct(marker,image);
end

