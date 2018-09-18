function image = read_image_double(num)
close all;
clc;
filename= ['/home/slawek/Pulpit/magisterka/test_images/images1/',int2str(num)];

% iminfo = dicominfo(filename);
I = dicomread(filename);


I = I + 2000;
% I=im2uint8(I);
I = rescale(I,0,1);

in_range1 = 0.65;
in_range2 = 1;
stop_first_loop = false;

for i=1:150
    i
    J = imadjust(I,[in_range1 in_range2],[0 1]);
    I = J;
    N = histcounts(J);
    for j=2:size(N,2)
        if(N(1,j) < 100 || N(1,size(N,2)-j) < 100)
            if(N(1,j) < 100)
                in_range1 = 0.02;
            else
                in_range1 = 0;
            end
            
            if(N(1,size(N,2)-j) < 100)
                in_range2 = 0.98;
            else
                in_range2 = 1;
            end
        break

        else
            stop_first_loop = true;
            break
        end
    end
    
    if(stop_first_loop == 1)
        break
    end
end

% I = rescale(I,0,255);
% I = round(I);
% I=im2uint8(I);
image = J;
h1 = figure;
imshow(J);
imcontrast(h1);
end



