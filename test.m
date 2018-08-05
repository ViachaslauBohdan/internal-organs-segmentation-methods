%  im = imread('/home/slawek/obrazy/GRAINS2.BMP');
%  im1 = imcomplement(im);
%  s = strel('square',11)
%  im2 = imerode(im1,s);
%  im3 = imdilate(im2,s);
%  im4 = imreconstruct(im2,im1);
%  imshow([im1 im2;im3 im4])

% min_distance=[2 1 0 1 2]
% hist_value = [1 2 3 4 5]
% for i=2:3
% 		min_distance =min(min_distance,  abs(hist_value-cluster(i)))
% end;

% f = figure;
% imshow(ans);
% imcontrast(f);

 im = imread('/home/slawek/obrazy/GRAINS1.BMP');
 im1 = imcomplement(im);
 imshow(im1)
 p = roipoly
 p2 = min(im2uint8(p),im1);
 im2 = imreconstruct(p2,im1);
 imshow([im1 p2 im2]);