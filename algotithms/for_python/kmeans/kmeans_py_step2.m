function [] = kmeans_py_step2(bin_images_array,num_of_clusters)
%     clustered_img_number = input(['choose the number ','between 1 and ',int2str(num_of_clusters),' of a clustered image for further processing (e.x 3):'],'s');
    clustered_img_number = '1';
    num = str2num(clustered_img_number);
    figure;
    imshow(bin_images_array{1,num});
    image_to_process = bin_images_array{1,num};

%     addpath('morphology');
%     seg_image = main(image_to_process);
% 
%     render_seg_subplots(I,seg_image);

end

