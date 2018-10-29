function [output_img] = open_by_reconst(image,se_radius)
%OPEN_BY_RECONST Summary of this function goes here
%   Detailed explanation goes here
se = strel('disk',se_radius);
% se = strel('line',10,45);
im_opened = imopen(image,se);
marker = im_opened;
output_img = imreconstruct(marker,image);
end

