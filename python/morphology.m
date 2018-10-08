function [seg_image,organs] = morpho_main(filter_number,mask,x_reconstruction_coords,y_reconstruction_coords,se_radius)
y_reconstruction_coords
x_reconstruction_coords

        if strcmp(filter_number,'1')
            marker = false(size(mask));
            for i=1:size(x_reconstruction_coords)
                marker(y_reconstruction_coords(i),x_reconstruction_coords(i)) = true;
            end
            size(mask)
            size(marker)
             [image_to_process] = reconstruct(marker,mask);
        elseif strcmp(filter_number,'2')
            [image_to_process] = fill_holes(mask);
        elseif strcmp(filter_number,'3')
            [image_to_process] = open_by_reconst(mask,se_radius);
        elseif strcmp(filter_number,'4')
            [image_to_process] = close_by_reconst(mask,se_radius);
        end
    
        [seg_image] = generate_pylist(image_to_process);
        bin_image = im2bw(image_to_process,0.5);
        [organs] = classify_organs(bin_image)
end

function [output_img] = reconstruct(marker,mask)
% figure;
% marker = roipoly(image);
% p2 = min(im2uint8(p),im1);
output_img = imreconstruct(marker,mask);
figure;
imshow(marker);
figure;
imshow(mask);
figure;
imshow(output_img)
end


function [im_filled] = fill_holes(image)
im_filled = imfill(image,'holes');
figure;
imshow(im_filled);
end

function [output_img] = open_by_reconst(image,se_radius)

se = strel('disk',se_radius);
im_opened = imopen(image,se);
marker = im_opened;
output_img = imreconstruct(marker,image);
figure;
imshow(output_img);
end

function [output_img] = close_by_reconst(image,se_radius)

se = strel('disk',se_radius);
im_closed = imclose(image,se);
marker = im_closed;
output_img = imreconstruct(marker,image);
figure;
imshow(output_img);
end

function [pylist] = generate_pylist(matrix)
      disp('pylist_from_matlab_matrix()');
      matrix = im2uint8(matrix);
      cell_matrix = num2cell(matrix);
      pylist = cell(1,size(matrix,1));

      for i= 1:size(matrix,1)
          pylist{i} = cell_matrix(i,:);
      end
end

function [organs] = classify_organs(bin_image)
    classes = {'left kidney', 'right kidney','spine','liver', 'bowel loops', 'muscles', 'stomach'};
    properties = ["Area","Centroid","Perimeter","BoundingBox"];
    
    L = bwlabel(bin_image);
    props = regionprops(L,"Area","Centroid","Perimeter","BoundingBox",'MajorAxisLength','MinorAxisLength');
    
    ref_props = init_ref_props();
    organs = {};
    for prop_index=1:size(props,1)
%         assignin('base','prop_index',ind)
        [organ,distance] = detect_organs(ref_props,props,false,prop_index);
%         distance
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





