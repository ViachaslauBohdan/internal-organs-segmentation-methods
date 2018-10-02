function [seg_image] = morpho_main(filter_number,mask,x_reconstruction_coords,y_reconstruction_coords,se_radius)
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




