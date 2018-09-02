function [pylist] = seed_mean_py(image_name,reg_maxdist,dist_type,neigbr_number)

reg_maxdist = reg_maxdist / 100; % range must be between 0-1
close all;
disp('1')
I = read_image_double_py(image_name);

% iminfo = dicominfo(filename)
% I = dicomread(filename);
% I = I + 2000;
% I = rescale(I,0,1);
% I = imadjust(I,[0.7 0.8],[0 1]);


% prompt = 'Enter number of neighbours (ex. 4 or 8) ';
% neigbr_number = input(prompt)

% neigbr_number = 4;

J = regiongrowing(I,neigbr_number,reg_maxdist,dist_type); 
figure(1);
imshow(I+J,[]);
figure(3);
imshow(J,[]);
pylist = pylist_from_matlab_matrix(J);
end




function [output_img]=regiongrowing(input_img,neigbr_number,reg_maxdist,dist_type,x,y)

if(exist('reg_maxdist','var')==0), reg_maxdist=0.1; end
if(exist('y','var')==0), figure, imshow(input_img,[]); [y,x]=getpts;
    y=round(y(1)); x=round(x(1)); end

output_img = zeros(size(input_img)); % Output 
input_img_size = size(input_img); % Dimensions of input image

if(strcmp(dist_type,'mean'))
    reg_mean = input_img(x,y); % The mean of the segmented region
else
    reg_median = input_img(x,y); % The median of the segmented region
end
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

while(pixdist<reg_maxdist && region_size<numel(input_img))

    % Add new neighbors pixels
    for j=1:neigbr_number
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
    if(strcmp(dist_type,'mean'))
        dist = abs(neigbor_list(1:memory_possesed,3)-reg_mean);
    else
        dist = abs(neigbor_list(1:memory_possesed,3)-reg_median);
    end
    [pixdist, index] = min(dist);
    output_img(x,y)=2; region_size=region_size+1;
    
    if(strcmp(dist_type,'mean'))
        % Calculate the new mean of the region
        reg_mean= (reg_mean*region_size + neigbor_list(index,3))/(region_size+1);
    else
        ind = find(neigbor_list(:,3)>0);
        neigbor_list(ind,3);
        reg_median = median(neigbor_list(ind,3));
    end
    
    % Save the x and y coordinates of the pixel (for the neighbour add proccess)
    x = neigbor_list(index,1); y = neigbor_list(index,2);
    
    % Remove the pixel from the neighbour (check) list
    neigbor_list(index,:)=[];
    memory_possesed=memory_possesed-1;

end
% Return the segmented area as logical matrix
output_img=output_img>1;
end

