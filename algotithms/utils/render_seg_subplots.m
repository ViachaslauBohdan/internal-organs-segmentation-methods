function render_seg_subplots(init_image,seg_image)
%RENDER_SEG_SUBPLOTS Summary of this function goes here
%   Detailed explanation goes here


figure;
subplot(1,3,1);
imshow(init_image);
subplot(1,3,2);
imshow(init_image + im2uint8(seg_image)/3);
subplot(1,3,3);
imshow(seg_image);
end

