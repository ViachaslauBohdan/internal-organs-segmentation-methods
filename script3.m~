close all;
clc;
filename= '3';
% iminfo = dicominfo(filename)
I = dicomread(filename);
I = I + 2000;
I = rescale(I,0,1);
I = imadjust(I,[0.7 0.8],[0 1]);
% x=268; y=258;
% figure, imshow(I,[]);
% pause;
J = regiongrowing(I); 
figure(1);
imshow(I+J,[]);
figure(3);
imshow(J,[]);



function output_img=regiongrowing(input_img,x,y,reg_maxdist)

if(exist('reg_maxdist','var')==0), reg_maxdist=0.13; end
if(exist('y','var')==0), figure, imshow(input_img,[]); [y,x]=getpts;
    y=round(y(1)); x=round(x(1)); end


output_img = zeros(size(input_img)); % Output 
input_img_size = size(input_img); % Dimensions of input image

reg_mean = input_img(x,y); % The mean of the segmented region
reg_size = 1; % Number of pixels in region

% Free memory to store neighbours of the (segmented) region
neg_free = 10000; neg_pos=0;
neg_list = zeros(neg_free,3); 

pixdist=0; % Distance of the region newest pixel to the regio mean

% Neighbor locations (footprint)
neigb=[-1 0; 1 0; 0 -1;0 1];

% Start regiogrowing until distance between regio and posible new pixels become
% higher than a certain treshold
while(pixdist<reg_maxdist&&reg_size<numel(input_img))

    % Add new neighbors pixels
    for j=1:4,
        % Calculate the neighbour coordinate
        xn = x +neigb(j,1); yn = y +neigb(j,2);
        
        % Check if neighbour is inside or outside the image
        ins=(xn>=1)&&(yn>=1)&&(xn<=input_img_size(1))&&(yn<=input_img_size(2));
        
        % Add neighbor if inside and not already part of the segmented area
        if(ins&&(output_img(xn,yn)==0)) 
                neg_pos = neg_pos+1;
                neg_list(neg_pos,:) = [xn yn input_img(xn,yn)]; output_img(xn,yn)=1;
        end
    end
    %neg_list = [123 27 0.473;
    %            231 510 0.192]

    % Add a new block of free memory
    if(neg_pos+10>neg_free), neg_free=neg_free+10000; neg_list((neg_pos+1):neg_free,:)=0; end
    
    % Add pixel with intensity nearest to the mean of the region, to the region
    dist = abs(neg_list(1:neg_pos,3)-reg_mean);
    [pixdist, index] = min(dist);
    output_img(x,y)=2; reg_size=reg_size+1;
    
    % Calculate the new mean of the region
    reg_mean= (reg_mean*reg_size + neg_list(index,3))/(reg_size+1);
    %reg_mean = (0.321 * 11 + )
    
    % Save the x and y coordinates of the pixel (for the neighbour add proccess)
    x = neg_list(index,1); y = neg_list(index,2);
    
    % Remove the pixel from the neighbour (check) list
    neg_list(index,:)=neg_list(neg_pos,:); neg_pos=neg_pos-1;
end

% Return the segmented area as logical matrix
output_img=output_img>1;
end
