 im = imread('/home/slawek/obrazy/GRAINS2.BMP');
 im1 = imcomplement(im);
 s = strel('square',11)
 im2 = imerode(im1,s);
 im3 = imdilate(im2,s);
 im4 = imreconstruct(im2,im1);
 imshow([im1 im2;im3 im4])