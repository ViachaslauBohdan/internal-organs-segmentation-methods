close all;
clc;
filename= '3';
iminfo = dicominfo(filename)
I = dicomread(filename);
I = I + 2000;

figure;
I = rescale(I,0,1);
imshow(I,[]);
imcontrast;

I = imadjust(I,[0.685 0.784],[0 1]);
thresh = multithresh(I,3)
seg_I = imquantize(I,thresh);
se = [0 1 1 1 0 ; 1 1 1 1 1;0 1 1 1 0]
seg_I = imclose(seg_I,se);

% figure;
% imshow(I,[]);
% imcontrast;
% imdisplayrange;

RGB = label2rgb(seg_I,'flag');

figure;
imshowpair(I,RGB,'montage') 
title('Minimum Interval Value           Maximum Interval Value')





