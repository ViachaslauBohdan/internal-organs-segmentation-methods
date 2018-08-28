close all;
clc;
filename= '/home/slawek/Pulpit/magisterka/test_images/images1/3';

% iminfo = dicominfo(filename);
I = dicomread(filename);

I = I + 2000;
% I=im2uint8(I);
I = rescale(I,0,1);
I = imadjust(I,[0.7 0.8],[0 1]);
% I = rescale(I,0,255);
% I = round(I);
I=im2uint8(I);
h1 = figure;
imshow(I);
% imcontrast(h1)


prompt = 'Enter number of neighbours (ex. 4 or 8) ';
neigbr_number = input(prompt)

J = regiongrowing(I,neigbr_number); 
figure(1);
imshow(I+J,[]);
figure(3);
imshow(J,[]);




function [output_img,b]=regiongrowing(input_img,neigbr_number,x,y,reg_maxdist)

if(exist('reg_maxdist','var')==0), reg_maxdist=0.12; end
if(exist('y','var')==0), figure, imshow(input_img,[]); [y,x]=getpts
    y=round(y(1)); x=round(x(1)); end
x
y

output_img = zeros(size(input_img)); % Output 
input_img_size = size(input_img); % Dimensions of input image

reg_median = input_img(x,y) % The mean of the segmented region
% p = reg_median
region_size = 1; % Number of pixels in region

% Free memory to store neighbours of the (segmented) region
memory_free = 10000; memory_possesed=0;
neigbor_list = zeros(memory_free,3); 

pixdist=0; % Distance of the region newest pixel to the regio mean

% Neighbor locations (footprint)
if(neigbr_number==4)
    neigb_locations=[-1 0
                      1 0
                      0 -1
                      0 1];
elseif(neigbr_number==8)
    neigb_locations=[-1 0
                     -1 1
                      1 1 
                      1 -1
                     -1 -1
                      1 0
                      0 -1
                      0 1]; 
end

% Start regiogrowing until distance between regio and posible new pixels become
% higher than a certain treshold
l=0;
while(pixdist<reg_maxdist && region_size<numel(input_img))

    % Add new neighbors pixels
    for j=1:neigbr_number,
        % Calculate the neighbour coordinate
        xn = x +neigb_locations(j,1); yn = y +neigb_locations(j,2);
        
        % Check if neighbour is inside or outside the image
        ins=(xn>=1)&&(yn>=1)&&(xn<=input_img_size(1))&&(yn<=input_img_size(2));
        
        % Add neighbor if inside and not already part of the segmented area
        if(ins&&(output_img(xn,yn)==0)) 
                memory_possesed = memory_possesed+1;
                neigbor_list(memory_possesed,:) = [xn yn input_img(xn,yn)]; 
                output_img(xn,yn)=1;
        end
    end

    % Add a new block of free memory
    if(memory_possesed+10>memory_free), memory_free=memory_free+10000; neigbor_list((memory_possesed+1):memory_free,:)=0; end
    
    % Add pixel with intensity nearest to the mean of the region, to the region
    dist = abs(neigbor_list(1:memory_possesed,3)-reg_median);
    [pixdist, index] = min(dist);
    output_img(x,y)=2; region_size=region_size+1;
  
    % Calculate the new median of the region
%     reg_med= (reg_med*region_size + neigbor_list(index,3))/(region_size+1);
       
%     ind = find(neigbor_list(:,3)>0);
%     neigbor_list(ind,3);
%     
%     reg_median = median(neigbor_list(ind,3));
%     p;
    
    
    % Save the x and y coordinates of the pixel (for the neighbour add proccess)
    x = neigbor_list(index,1); y = neigbor_list(index,2);
    
    % Remove the pixel from the neighbour (check) list
    neigbor_list(index,:)=[];
    memory_possesed=memory_possesed-1;
    l = l +1;
end
% Return the segmented area as logical matrix
output_img=output_img>1;
end

