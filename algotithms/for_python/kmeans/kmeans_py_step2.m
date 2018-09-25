function [] = kmeans_py_step2(image_to_process)
    seg_image = main(image_to_process);

    render_seg_subplots(I,seg_image);

end

