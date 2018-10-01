function [seg_image] = morpho_main(filter_number,mask,x_reconstruction_coords,y_reconstruction_coords)
        45
        marker = false(size(mask));
        for i=1:size(x_reconstruction_coords,2)
            marker(x_reconstruction_coords(1,i),y_reconstruction_coords(1,i)) = 1
        end
        
    
        if strcmp(filter_number,'1')
             [image_to_process] = reconstruct(marker,mask);
%              seg_image = pylist_from_matlab_matrix(image_to_process);
%             render_image(image_to_process);
        elseif strcmp(filter_number,'2')
            [seg_image] = fill_holes(image_to_process);
            seg_image = pylist_from_matlab_matrix(seg_image)
        elseif strcmp(filter_number,'3')
            se_radius = input('enter structure element radius (example: 11):')
            
            [image_to_process] = open_by_reconst(image_to_process,se_radius);
            render_image(image_to_process);
        elseif strcmp(filter_number,'4')
            se_radius = input('enter structure element radius (example: 11):')
            
            [image_to_process] = close_by_reconst(image_to_process,se_radius);
            render_image(image_to_process);
        end
    
    seg_image = image_to_process;
end

function [output_img] = reconstruct(marker,mask)
% figure;
% marker = roipoly(image);
% p2 = min(im2uint8(p),im1);
output_img = imreconstruct(marker,mask);
figure;
imshow(marker)
figure;
imshow(mask)
figure;
imshow(output_img)
end


function [im_filled] = fill_holes(image)
im_filled = imfill(image,'holes');
end

function [pylist] = pylist_from_matlab_matrix(matrix)
       
%     pylist = mat2cell(matrix,matrix(1,:));
      matrix = im2uint8(matrix);
      cell_matrix = num2cell(matrix);
      pylist = cell(1,size(matrix,1));

      for i= 1:size(matrix,1)
          pylist{i} = cell_matrix(i,:);
      end
end




