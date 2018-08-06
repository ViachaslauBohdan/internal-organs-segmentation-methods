close all;
clc;
im_array = read_montage()
im = im_array{1};
thresh_count = 6;
levels = multithresh(im,thresh_count);
im_segmented = imquantize(im,levels);
imshow(label2rgb(im_segmented));

im_reconstructed = imreconstruct(imerode(im_segmented,strel('diamond',10)),im_segmented);
figure;
imshow(label2rgb(im_reconstructed),[]);

for i = 1:thresh_count
    figure('Name',strcat('Cluster number:  ',int2str(i)));
    single_label = im_segmented == i;
    imshow(label2rgb(single_label,@jet,'black'),[]);
end