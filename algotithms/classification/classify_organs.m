function [organ_name,distance,ref_props,props] = classify_organs(bin_image)
    classes = {'left kidney', 'right kidney','spine','liver', 'bowel loops', 'muscles', 'stomach'};
    properties = ["Area","Centroid","Perimeter","BoundingBox"];
    
    props = regionprops(bin_image,"Area","Centroid","Perimeter","BoundingBox",'MajorAxisLength','MinorAxisLength');
    centroid = cat(1,props.Centroid);
    cX = centroid(1,1);
    cY = centroid(1,2);
    axis_ratio = cat(1,props.MajorAxisLength)/cat(1,props.MinorAxisLength);
    area = cat(1,props.Area);
    disp([cX;cY;axis_ratio;area])
    
    ref_props = init_ref_props();
    [organ_name,distance] = detect_organs(ref_props,props,false);
    distance
    [v,i] = min(distance);
    dist_copy = distance;
    dist_copy(i) = [];
    [sec_value,sec_index] = min(dist_copy);
    if(v - sec_value < 20)
        disp('recalculation')
        [organ_name,distance] = detect_organs(ref_props,props,true)
    end
        
end

function [organ_name,dist_copy] = detect_organs(ref_props,props,consider_axis_ratio)
    distance = [];
    for i=1:size(ref_props,2)
        distance(end+1) = calculate_dist(ref_props{1,i},props,consider_axis_ratio);
    end
    [v,i] = min(distance);
    dist_copy = distance;
   
    for ind=1:size(distance,2)
        XY_swap_error = eliminateXYswap(i,ref_props,props)
        if(XY_swap_error == true)
            dist_copy(i) = [];
            [v,i] = min(dist_copy);
        else break
        end
    end
    organ_name = ref_props{1,i}.name;
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

function [vector] = extract_props(props,consider_axis_ratio)
    centroid = cat(1,props.Centroid);
    cX = centroid(1,1);
    cY = centroid(1,2);
    axis_ratio = cat(1,props.MajorAxisLength)/cat(1,props.MinorAxisLength);
    area = cat(1,props.Area);
    if(consider_axis_ratio == false)
        vector = [cX, cY];
    else
        disp('consider axis ratio')
        vector = [cX, cY,axis_ratio*50];
    end
end

function [dist] = calculate_dist(ref_props,props,consider_axis_ratio)
    v_ref = extract_ref_props(ref_props,consider_axis_ratio);
    v = extract_props(props,consider_axis_ratio);
    dist = sqrt(sum(v-v_ref).^2);
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

    obj.name = 'muscles';
    obj.centroidX = 244;
    obj.centroidY = 379;
    obj.axis_ratio = 2;
    obj.area = 30;
    ref_props{1,5} = obj;

    obj.name = 'stomach';
    obj.centroidX = 335.64;
    obj.centroidY = 174.06;
    obj.axis_ratio = 1.4;
    obj.area = 50;
    ref_props{1,6} = obj;
        
    obj.name = 'left rib';
    obj.centroidX = 98.57;
    obj.centroidY = 320.71;
    obj.axis_ratio = 6.7179;
    obj.area = 20;
    ref_props{1,7} = obj;
    
    obj.name = 'right rib';
    obj.centroidX = 365.53;
    obj.centroidY = 341.69;
    obj.axis_ratio =  5.5564;
    obj.area = 20;
    ref_props{1,8} = obj;
    
    obj.name = 'gallbladder';
    obj.centroidX =  236.27;
    obj.centroidY = 156.58;;
    obj.axis_ratio = 1;
    obj.area = 20;
    ref_props{1,9} = obj;
end
