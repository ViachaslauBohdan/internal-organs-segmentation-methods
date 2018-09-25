function [im_filled] = fill_holes(image)
im_filled = imfill(image,'holes');
end

