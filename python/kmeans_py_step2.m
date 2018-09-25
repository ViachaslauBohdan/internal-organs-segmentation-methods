function [seg_image] = main(user_response,image_to_process)
        if strcmp(user_response,'1')
%             [image_to_process] = reconstruct(image_to_process);
%             render_image(image_to_process);
        elseif strcmp(user_response,'2')
            [seg_image] = fill_holes(image_to_process);
        elseif strcmp(user_response,'3')
            se_radius = input('enter structure element radius (example: 11):')
            
            [image_to_process] = open_by_reconst(image_to_process,se_radius);
            render_image(image_to_process);
        elseif strcmp(user_response,'4')
            se_radius = input('enter structure element radius (example: 11):')
            
            [image_to_process] = close_by_reconst(image_to_process,se_radius);
            render_image(image_to_process);
        end
    close all;
    seg_image = image_to_process;
end

function [im_filled] = fill_holes(image)
im_filled = imfill(image,'holes');
end




