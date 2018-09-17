close all;
clc;
addpath(genpath('../montage'))
im_array = read_montage();
im = im_array{1};
thresh_count = 5;
bin_images_array = {1,thresh_count};
levels = multithresh(im,thresh_count);
im_segmented = imquantize(im,levels);
imshow(label2rgb(im_segmented));

% im_reconstructed = imreconstruct(imerode(im_segmented,strel('diamond',10)),im_segmented);
% figure;
% imshow(label2rgb(im_reconstructed),[]);

for i = 1:thresh_count
    bin_images_array{1,i} = im_segmented == i;
    figure('Name',strcat('Cluster number:  ',int2str(i)));
    single_label = im_segmented == i;
    imshow(label2rgb(single_label,@jet,'black'),[]);
end

clustered_img_number = input(['choose the number ','between 1 and ',int2str(thresh_count),' of a clustered image for further processing (e.x 3):'],'s');
num = str2num(clustered_img_number);
figure;
imshow(bin_images_array{1,num});
image_to_process = bin_images_array{1,num};

addpath(genpath('../morphology'));
seg_image = main(image_to_process);

render_seg_subplots(im,seg_image);