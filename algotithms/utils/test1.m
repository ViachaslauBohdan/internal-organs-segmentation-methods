a = [0 0 0; 0 0 0];
b = [231 123 12;93 32 222];

for i=1:size(b,1)
    for j=1:size(b,2)
        if(a(i,j) == 0)
            b(i,j) = 0;
        end
    end
end

% I = imread('/home/slawek/Pulpit/magisterka/test_images/images1/cat.jpg');
% h = figure;
% imshow(I);
% imcontrast(h);
% text_str = cell(3,1);
% for ii=1:3
%     ii
%    text_str{ii} = ['Confidence: ' num2str(conf_val(ii),'%0.2f') '%'];
% end
% text_str
close all;
original = imread('snowflakes.png');
figure;
imshow(original);
se = strel('disk',5);
figure;
imhist(original);
afterOpening = imopen(original,se);
figure;
imshow(afterOpening,[]);
figure;
imhist(afterOpening);


eroded = imerode(original,se);
figure;
imshow(eroded)
title('erode');

% function gray_img = bin_to_gray(bin_img,gray_img)
%     for i=1:size(bin_img,1)
%         for j=1:size(bin_img,2)
%             if(bin_img(i,j) == 0)
%                 gray_img(i,j) = 0;
%             end
%         end
%     end
% end

