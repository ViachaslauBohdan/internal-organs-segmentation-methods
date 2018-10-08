    function [pylist,organs] = seed_mean_py(image_name,reg_maxdist,dist_type,neigbr_number,x_seeds,y_seeds)

    reg_maxdist = reg_maxdist / 100; % range must be between 0-1
    close all;
    disp('1')
    I = read_image_double_py(image_name);

    xi = x_seeds;
    yi = y_seeds;

    number_of_seeds = size(xi,2)


    J = regiongrowing(I,neigbr_number,xi,yi,number_of_seeds,reg_maxdist); 
    bin_image = im2bw(J,0.5);
    [organs] = classify_organs(bin_image);
%    figure;
%    imshow(I+J,[]);
%    figure;
%    imshow(J,[]);
    m = ones(512,512);
    m(:,256:512) = 0;
    pylist = pylist_from_matlab_matrix(J);
    pylist{256};
    pylist = pylist(:);

%     a = label2rgb(J);
%     imshow(a);
    end


    function [output_img]=regiongrowing(input_img,neigbr_number,y,x,number_of_seeds,reg_maxdist)

    if(exist('reg_maxdist','var')==0), reg_maxdist=0.05; end
    % if(exist('y','var')==0), figure, imshow(input_img,[]); [y,x]=getpts;
    %     y=round(y(1)); x=round(x(1)); end


    output_img = zeros(size(input_img)); % Output 
    input_img_size = size(input_img); % Dimensions of input image

    reg_mean = input_img(x,y); % The mean of the segmented region
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
    xi = x;
    yi = y;
    for i = 1:number_of_seeds
        x = xi(i);
        y = yi(i);
        reg_maxdist
        reg_mean = input_img(x,y);
        region_size = 1;
        pixdist = 0;

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
            dist = abs(neigbor_list(1:memory_possesed,3)-reg_mean);
            [pixdist, index] = min(dist);
            output_img(x,y)=(i+1); region_size=region_size+1;

            % Calculate the new mean of the region
            reg_mean= (reg_mean*region_size + neigbor_list(index,3))/(region_size+1);

            % Save the x and y coordinates of the pixel (for the neighbour add proccess)
            x = neigbor_list(index,1); y = neigbor_list(index,2);

            % Remove the pixel from the neighbour (check) list
            neigbor_list(index,:)=[];
            memory_possesed=memory_possesed-1;

        end
    end
    % Return the segmented area as logical matrix
    output_img=output_img>1;

    end
    
    function [organs] = classify_organs(bin_image)
    classes = {'left kidney', 'right kidney','spine','liver', 'bowel loops', 'muscles', 'stomach'};
    properties = ["Area","Centroid","Perimeter","BoundingBox"];
    
    L = bwlabel(bin_image);
    props = regionprops(L,"Area","Centroid","Perimeter","BoundingBox",'MajorAxisLength','MinorAxisLength');
    
    ref_props = init_ref_props();
    organs = {};
    for prop_index=1:size(props,1)
        [organ,distance] = detect_organs(ref_props,props,false,prop_index);
        [v,i] = min(distance);
        dist_copy = distance;
        dist_copy(i) = [];
        [sec_value,sec_index] = min(dist_copy);

        if(abs(v - sec_value) < 10)
            disp('recalculation')
            [organ,distance] = detect_organs(ref_props,props,true,prop_index)
        end
        organs{1,prop_index}=organ
    end
        
end

function [organ,dist_copy] = detect_organs(ref_props,props,consider_axis_ratio,prop_index)
    distance = [];
    for i=1:size(ref_props,2)
        distance(end+1) = calculate_dist(ref_props{1,i},props,consider_axis_ratio,prop_index);
    end
    [v,i] = min(distance);
    dist_copy = distance;
   
%     for ind=1:size(distance,2)
%         XY_swap_error = eliminateXYswap(i,ref_props,props)
%         if(XY_swap_error == true)
%             dist_copy(i) = [];
%             [v,i] = min(dist_copy);
%         else break
%         end
%     end
    organ = ref_props{1,i};
end

function [vector] = extract_ref_props(ref_props,consider_axis_ratio)
    cX = ref_props.centroidX;
    cY = ref_props.centroidY;
    axis_ratio = ref_props.axis_ratio;
    area = ref_props.area;
    if(consider_axis_ratio == false)
        vector = [cX, cY];
    else
        disp('consider axis ratio')
        vector = [cX, cY,axis_ratio*50];
    end
end

function [vector] = extract_props(props,consider_axis_ratio,prop_index)
    centroid = cat(1,props.Centroid);
    cX = centroid(prop_index,1);
    cY = centroid(prop_index,2);
    
    axis_ratio_vector = cat(1,props.MajorAxisLength)./cat(1,props.MinorAxisLength);
    axis_ratio = axis_ratio_vector(prop_index,1);
    
    area_vector = cat(1,props.Area);
    area = area_vector(prop_index,1);
    if(consider_axis_ratio == false)
        vector = [cX, cY];
    else
        disp('consider axis ratio')
        vector = [cX, cY,axis_ratio*50];
    end
end

function [dist] = calculate_dist(ref_props,props,consider_axis_ratio,prop_index)
    v_ref = extract_ref_props(ref_props,consider_axis_ratio)
    v = extract_props(props,consider_axis_ratio,prop_index)
    dist = sqrt(sum(abs(v-v_ref).^2));
end

function XY_swap_error = eliminateXYswap(i,ref_props,props)
    v_ref = extract_ref_props(ref_props{1,i},false)
    v = extract_props(props,false)
    abs(v_ref(1) - v(2))
    abs(v_ref(1) - v(1))
    if( abs(v_ref(1) - v(2))*1 < abs(v_ref(1) - v(1)) & abs(v_ref(2) - v(1))*1 < abs(v_ref(2) - v(2)))
        XY_swap_error = true;
    else
        XY_swap_error = false;
    end
end

function ref_props = init_ref_props()
    ref_props = {};
    
    obj.name = 'left kidney';
    obj.centroidX = 119.06;
    obj.centroidY = 312.62;
    obj.axis_ratio = 1.5601;
    obj.area = 20;
    ref_props{1,1} = obj;

    obj.name = 'right kidney';
    obj.centroidX = 340.38;
    obj.centroidY = 315.98;
    obj.axis_ratio =  1.3176;
    obj.area = 20;
    ref_props{1,2} = obj;

    obj.name = 'spine';
    obj.centroidX =   241.51;
    obj.centroidY = 313.48;
    obj.axis_ratio = 1.1;
    obj.area = 10;
    ref_props{1,3} = obj;

    obj.name = 'liver';
    obj.centroidX = 115;
    obj.centroidY = 262.47;
    obj.axis_ratio = 1.4;
    obj.area = 100;
    ref_props{1,4} = obj;

%     obj.name = 'muscles';
%     obj.centroidX = 244;
%     obj.centroidY = 379;
%     obj.axis_ratio = 2;
%     obj.area = 30;
%     ref_props{1,5} = obj;

    obj.name = 'stomach';
    obj.centroidX = 335.64;
    obj.centroidY = 174.06;
    obj.axis_ratio = 1.4;
    obj.area = 50;
    ref_props{1,5} = obj;
        
    obj.name = 'left rib';
    obj.centroidX = 98.57;
    obj.centroidY = 320.71;
    obj.axis_ratio = 6.7179;
    obj.area = 20;
    ref_props{1,6} = obj;
    
    obj.name = 'right rib';
    obj.centroidX = 365.53;
    obj.centroidY = 341.69;
    obj.axis_ratio =  5.5564;
    obj.area = 20;
    ref_props{1,7} = obj;
    
    obj.name = 'gallbladder';
    obj.centroidX =  236.27;
    obj.centroidY = 156.58;;
    obj.axis_ratio = 1;
    obj.area = 20;
    ref_props{1,8} = obj;
end
