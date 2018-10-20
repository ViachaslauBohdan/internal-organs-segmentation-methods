I = dicomread('/home/slawek/Pulpit/magisterka/ct_images/407_16_2006/SE3/img_0115_f');
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
lowest_val = (info.WindowCenter - info.WindowWidth/2)
highest_val =(info.WindowCenter + info.WindowWidth/2)
figure;
imshow(I_HU,[lowest_val, highest_val]);


[lowest_row, lowest_col] = find(I_HU==lowest_val,1)
[highest_row, highest_col] = find(I_HU==highest_val,1)
I = I + min(I_HU(:));
I_rescaled = rescale(I_HU,0,1);

I_adj = imadjust(I_rescaled,[I_rescaled(lowest_row,lowest_col),I_rescaled(highest_row,highest_col)],[0 1]);
% imshow(I)
h = figure;
imshow(I_adj);
imcontrast(h)