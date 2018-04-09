close all;
clc;
filename= '1'
iminfo = dicominfo(filename)
I = dicomread(filename);
I = I + 2000;
f2 = figure;
imshow(I,[]);
imcontrast;

I = rescale(I,0,1);
I = imadjust(I,[0.7 0.8],[0 1]);
thresh = multithresh(I,7)
valuesMax = [thresh max(I(:))];
[quant8_I_max, index] = imquantize(I,thresh,valuesMax);
valuesMin = [min(I(:)) thresh];
quant8_I_min = valuesMin(index);

f1 = figure;
imshow(I,[]);
imcontrast;
imdisplayrange;

RGB = label2rgb(seg_I,'flag');

figure;
imshowpair(quant8_I_min,quant8_I_max,'montage') 
title('Minimum Interval Value           Maximum Interval Value')





