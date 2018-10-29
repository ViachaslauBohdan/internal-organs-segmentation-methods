function [output_img,marker] = reconstruct(image)
[xi,yi] = ginput;
xi = round(xi);
yi = round(yi);
imshow(image,[]);

if (islogical(image))
    marker = logical(zeros(size(image)));
    for i=1:size(xi,1)
        marker(yi(i),xi(i)) = true;
    end
elseif (strcmp(class(image),'uint8'))
    marker = uint8(zeros(size(image)));
    for i=1:size(xi,1)
        marker(yi(i),xi(i)) = uint8(255);
    end
elseif (strcmp(class(image),'double'))
    marker = double(zeros(size(image)));
    for i=1:size(xi,1)
        marker(yi(i),xi(i)) = double(1);
    end
end
figure;
imshow(marker);
title('marker');
% p2 = min(im2uint8(p),im1);
output_img = imreconstruct(marker,image);
end

