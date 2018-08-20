close all;
clc;
im_array = read_montage();
im = im_array{39};
im_bin = repmat(false,size(im));
im_uint8 = repmat(uint8(0),size(im));

figure('Name','Choose thresholds');
imshow(im);
thresh_arr = input('choose threshold array e.x. [120 150]:','s');
[im_label,index] = imquantize(im,str2num(thresh_arr));

for i = 1:numel(im)
    if(im_label(i)~=2)
         im_uint8(i) = 0;
         im_bin(i) = 0;
         
    else
        im_uint8(i)=255;
        im_bin(i) = 1;
    end
end
figure;
imshow(im_uint8);

addpath('morphology');
seg_image = main(im_bin);

render_seg_subplots(im,seg_image);


