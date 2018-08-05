close all;
clc;

thresh_count = 6;
levels = multithresh(I,thresh_count);
im_segmented = imquantize(I,levels);
imshow(label2rgb(im_segmented));

im_reconstructed = imreconstruct(imerode(im_segmented,strel('diamond',10)),im_segmented);
imshow(label2rgb(im_reconstructed),[]);

% for i = 1:thresh_count
%     figure('Name',strcat('Cluster number:  ',int2str(i)));
%     single_label = im_segmented == i;
%     imshow(label2rgb(single_label,@jet,'black'),[]);
% end