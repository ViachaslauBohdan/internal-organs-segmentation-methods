function render_seg_subplots(init_image,seg_image)

if(strcmp(class(init_image),'uint8'))
    figure;
    subplot(1,3,1);
    imshow(init_image);
    axis off;
    title('obraz przed segmentacją');
    subplot(1,3,3);
    imshow(init_image - 50 + im2uint8(seg_image));
    axis off;

    title('suma obrazów');
    subplot(1,3,2);
    imshow(seg_image);
    axis off;
    title('obraz po segmentacji');
        
elseif(strcmp(class(init_image),'double'))
    figure;
    subplot(1,3,1);
    imshow(init_image);
    axis off;
    title('obraz przed segmentacją');
    subplot(1,3,3);
    imshow(init_image - 0.29 + seg_image);
    axis off;

    title('suma obrazów');
    subplot(1,3,2);
    imshow(seg_image);
    axis off;
    title('obraz po segmentacji');    
end

    
end
