% I = dicomread('/home/slawek/Pulpit/magisterka/ct_images/407_16_2006/SE3/img_0117_f');
% I=dicomread('/home/slawek/Pulpit/magisterka/ct_images/211_16_2005/SE3/img_0090_c');
I=dicomread('/home/slawek/Pulpit/magisterka/ct_images/217_16_2017/SE3/img_0117_d');
info = dicominfo('/home/slawek/Pulpit/magisterka/ct_images/211_16_2005/SE3/img_0107_c')
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

h = figure;
imshow(I_adj,[]);
% imcontrast(h);
[level,EM] = graythresh(I);
BW = imbinarize(I_adj,level);
BW1 = imbinarize(I_adj,0.2);
BW2 = imbinarize(I_adj,0.6);
BW3 = imbinarize(I_adj,0.7);

figure;
imshow(BW2);
title('threshold = 0.6, then opening by reconstruction')

figure;

subplot(2,2,1); subimage(BW1);
axis off;
title('threshold = 0.2');
subplot(2,2,2); subimage(BW);
axis off;
title('threshold = 0.43 (próg auto)');
subplot(2,2,3); subimage(BW2);
axis off;
title('threshold = 0.6');
subplot(2,2,4); subimage(BW3);
axis off;
title('threshold = 0.8');
addpath('../morphology');
seg_image = main(BW3);

L = bwlabel(seg_image);
rgb = label2rgb(L);
figure;
imshow(rgb)

% figure;
% imshow([I_adj,I_adj - 0.29 + seg_image])

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








% figure;
% imshow([BW,BW1,BW2]);


T = adaptthresh(I_adj,0.5);
BW1 = imbinarize(I_adj,T);
% figure;
% imshow([BW,BW1,BW2]);
% 
% BW2 = imbinarize(I_adj,0.1);
% BW3 = imbinarize(I_adj,0.4);
% BW4 = imbinarize(I_adj,0.7);
% 
% figure;
% imshow([BW,BW1,BW2,BW3,BW4]);