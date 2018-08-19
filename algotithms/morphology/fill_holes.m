function [im_filled] = fill_holes(image)
%HOLES_FILLING Summary of this function goes here
%   Detailed explanation goes here
im_filled = imfill(image,'holes');
end

