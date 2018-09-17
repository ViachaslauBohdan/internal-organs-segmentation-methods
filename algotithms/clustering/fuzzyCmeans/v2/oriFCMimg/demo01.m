clear all;  close all;  clc;

% img = double(imread('brain_n.tif'));
I=read_image(3);
img = double(I);
clusterNum = 5;
[ Unow, center, now_obj_fcn ] = FCMforImage( img, clusterNum );

figure;
for i=1:clusterNum
    subplot(floor(sqrt(clusterNum)),floor(sqrt(clusterNum))+2,i);
    imshow(Unow(:,:,i),[]);
    title(strcat('cluster',{' '},int2str(i)));
end

image_to_process = choose_cluster(clusterNum,Unow);

run_second_time = input('run fuzzy-C_means algorithm for the socend time on a choosen cluster? [y/n]:','s');
if(run_second_time=='Y' || run_second_time=='y')
       clusterNum = input('choose number of clusters (e.x. 2):');
       [ Unow, center, now_obj_fcn ] = FCMforImage( image_to_process, clusterNum )
       figure;
       for i=1:clusterNum
       subplot(floor(sqrt(clusterNum)),floor(sqrt(clusterNum))+2,i);
       imshow(Unow(:,:,i),[]);
       title(strcat('cluster',{' '},int2str(i)));
       end
       image_to_process = choose_cluster(clusterNum,Unow);
       image_to_process = imbinarize(image_to_process,0.65);
       main_plus_render(I,image_to_process)
else
    image_to_process = imbinarize(image_to_process,0.65);
    main_plus_render(I,image_to_process)
end




function image_to_process = choose_cluster(clusterNum,Unow)
    clustered_img_number = input(['choose the number ','between 1 and ',int2str(clusterNum),' of a clustered image for further processing (e.x 3):'],'s');
    num = str2num(clustered_img_number);
    % image_to_process = imbinarize(Unow(:,:,num),0.5);
    image_to_process = Unow(:,:,num);
    figure;
    imshow(image_to_process);
    title('image_to_process');
end

function main_plus_render(I,image_to_process)
   addpath('morphology');
   seg_image = main(image_to_process);
   render_seg_subplots(I,seg_image);
end
