close all;
clear all;
clc;
% addpath(genpath('../montage'))
% im_array = read_montage();
% im = im_array{1};
% thresh_count = 5;
% bin_images_array = {1,thresh_count};
% I = dicomread('/home/slawek/Pulpit/magisterka/ct_images/407_16_2006/SE3/img_0117_f');
I=dicomread('/home/slawek/Pulpit/magisterka/ct_images/211_16_2005/SE3/img_0090_c');
% I=dicomread('/home/slawek/Pulpit/magisterka/ct_images/217_16_2017/SE3/img_0107_d');
% info = dicominfo('/home/slawek/Pulpit/magisterka/ct_images/211_16_2005/SE3/img_0107_c')
info=dicominfo('/home/slawek/Pulpit/magisterka/ct_images/211_16_2005/SE3/img_0090_c');
close all;
I_HU = I * info.RescaleSlope + info.RescaleIntercept;
% h = figure;
% imshow(I_HU);
% imcontrast(h)

info.ImagePositionPatient
info.DistanceSourceToPatient;
info.DistanceSourceToDetector;


%Skala Hounsfilda
%HU = Gray_Value * slope + intercept;
% 
% %Skala normalna
% %Gray_Value = (HU - intercept) / slope;
% 
lowest_val = (info.WindowCenter - info.WindowWidth/2);
highest_val =(info.WindowCenter + info.WindowWidth/2);
% figure;
% imshow(I_HU,[lowest_val, highest_val]);


[lowest_row, lowest_col] = find(I_HU==lowest_val,1);
[highest_row, highest_col] = find(I_HU==highest_val,1);
I = I + min(I_HU(:));
I_rescaled = rescale(I_HU,0,1);
I_adj = imadjust(I_rescaled,[I_rescaled(lowest_row,lowest_col),I_rescaled(highest_row,highest_col)],[0 1]);

% h = figure;
% imshow(I_adj,[]);

thresh_count = 5;
bin_images_array = {1,thresh_count};

levels = multithresh(I_adj,thresh_count);
im_segmented = imquantize(I_adj,levels);

figure;
subplot(3,3,1);
imshow(I_adj,[]);
title("original image");
subplot(3,3,2);
imshow(label2rgb(im_segmented));
title("labeled image");
for i = 1:thresh_count + 1
    bin_images_array{1,i} = im_segmented == i;
    subplot(3,3,i+2);
    imshow(label2rgb(bin_images_array{1,i},@jet,'black'),[]);
    title(strcat('cluster',{' '},int2str(i)));
end

% 
clustered_img_number = input(['choose the number ','between 1 and ',int2str(thresh_count),' of a clustered image for further processing (e.x 3):'],'s');
num = str2num(clustered_img_number);
figure;
imshow(bin_images_array{1,num});
image_to_process = bin_images_array{1,num};

addpath(genpath('../morphology'));
seg_image = main(image_to_process);

% render_seg_subplots(im,seg_image);

figure;

subplot(1,3,1); subimage(I_adj);
axis off;
title('obraz przed segmentacją');

subplot(1,3,2); subimage(seg_image);
axis off;
title('obraz po segmentacji z filtracją');

subplot(1,3,3); subimage(I_adj - 0.29 + seg_image);
axis off;
title('suma obrazów');