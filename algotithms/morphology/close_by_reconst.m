function [output_img] = open_by_reconst(image,se_radius)
%OPEN_BY_RECONST Summary of this function goes here
%   Detailed explanation goes here
se = strel('disk',se_radius);
im_closed = imclose(image,se);
marker = im_closed;
output_img = imreconstruct(marker,image);
end

