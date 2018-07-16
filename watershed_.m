%%Step 1: Read image
close all;
clc;
filename= '9';

% iminfo = dicominfo(filename)
I = dicomread(filename);
I = I + 2000;
I = rescale(I,0,1);
I = imadjust(I,[0.7 0.8],[0 1]);


figure;
imshow(I,[]);

%%Step 2: Use the Gradient Magnitude as the Segmentation Function
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(I, hy, 'replicate');
Ix = imfilter(I, hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);
figure;
imshow(gradmag,[]), title('Gradient magnitude (gradmag)');

%% Step 3
L = watershed(gradmag);
Lrgb = label2rgb(L);
figure, imshow(Lrgb), title('Watershed transform of gradient magnitude (Lrgb)')

se = strel('disk', 20);
Io = imopen(I, se);
figure
imshow(Io), title('Opening (Io)')

se = strel('disk', 20);
Io = imopen(I, se);
figure
imshow(Io), title('Opening (Io)')

Ie = imerode(I, se);
Iobr = imreconstruct(Ie, I);
figure
imshow(Iobr), title('Opening-by-reconstruction (Iobr)')

Ioc = imclose(Io, se);
figure
imshow(Ioc), title('Opening-closing (Ioc)')

Iobrd = imdilate(Iobr, se);
Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);
figure
imshow(Iobrcbr), title('Opening-closing by reconstruction (Iobrcbr)')

fgm = imregionalmax(Iobrcbr);
figure
imshow(fgm), title('Regional maxima of opening-closing by reconstruction (fgm)')

I2 = I;
I2(fgm) = 255;
figure
imshow(I2), title('Regional maxima superimposed on original image (I2)')

se2 = strel(ones(5,5));
fgm2 = imclose(fgm, se2);
fgm3 = imerode(fgm2, se2);

fgm4 = bwareaopen(fgm3, 20);
I3 = I;
I3(fgm4) = 255;
figure
imshow(I3)
title('Modified regional maxima superimposed on original image (fgm4)')

bw = imbinarize(Iobrcbr);
figure
imshow(bw), title('Thresholded opening-closing by reconstruction (bw)')

D = bwdist(bw);
DL = watershed(D);
bgm = DL == 0;
figure
imshow(bgm), title('Watershed ridge lines (bgm)')

gradmag2 = imimposemin(gradmag, bgm | fgm4);

L = watershed(gradmag2);

I4 = I;
I4(imdilate(L == 0, ones(3, 3)) | bgm | fgm4) = 255;
figure
imshow(I4)
title('Markers and object boundaries superimposed on original image (I4)')

Lrgb = label2rgb(L, 'jet', 'w', 'shuffle');
figure
imshow(Lrgb)
title('Colored watershed label matrix (Lrgb)')

figure
imshow(I)
hold on
himage = imshow(Lrgb);
himage.AlphaData = 0.3;
title('Lrgb superimposed transparently on original image')