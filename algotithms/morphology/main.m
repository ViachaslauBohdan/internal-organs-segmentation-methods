function [seg_image] = main(image_to_process)
max(image_to_process(:))

    user_response = '';
    addpath('morphology');
    while ~strcmp(user_response,'5')
        user_response = input(['choose the number of an action (1,2,3 or 4)' newline ...
            '1) perform image reconstruction' newline ...
            '2) perform holes filling' newline ...
            '3) opening by reconstruction' newline ...
            '4) closing by reconstruction' newline ...
            '5) exit' newline ...
            ':'],'s');
        if strcmp(user_response,'1')
            
            [image_to_process] = reconstruct(image_to_process);
            render_image(image_to_process);
        elseif strcmp(user_response,'2')
            
            [image_to_process] = fill_holes(image_to_process);
            render_image(image_to_process);
        elseif strcmp(user_response,'3')
            se_radius = input('enter structure element radius (example: 11):')
            
            [image_to_process] = open_by_reconst(image_to_process,se_radius);
            render_image(image_to_process);
        elseif strcmp(user_response,'4')
            se_radius = input('enter structure element radius (example: 11):')
            
            [image_to_process] = close_by_reconst(image_to_process,se_radius);
            render_image(image_to_process);
        end
    end
    close all;
    seg_image = image_to_process;
end

function render_image(image)
    figure;
    imshow(image);
end


