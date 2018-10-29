function clustered_images = fuzzy_py_step1(num,clusterNum)

    close all;
    
    addpath('../')
    I = read_image_uint8_py(num);
    bin_images_array = {1,clusterNum};
    img = double(I);
    
    [ Unow, center, now_obj_fcn ] = FCMforImage( img, clusterNum );

%     figure;
%     for i=1:clusterNum
%         subplot(floor(sqrt(clusterNum)),floor(sqrt(clusterNum))+2,i);
%         imshow(Unow(:,:,i),[]);
%         title(strcat('cluster',{' '},int2str(i)));
%     end
    
    clustered_images = cell(1,clusterNum);
    
    for i = 1:clusterNum
        bin_images_array{1,i} = imbinarize(Unow(:,:,i),0.65);
%        figure;
%        imshow(bin_images_array{1,i})
        clustered_images{1,i} = pylist_from_matlab_matrix(bin_images_array{1,i});
    end
    
    clustered_images = clustered_images(:);
    
    
%     image_to_process = choose_cluster(clusterNum,Unow);
% 
%     run_second_time = input('run fuzzy-C_means algorithm for the socend time on a choosen cluster? [y/n]:','s');
%     if(run_second_time=='Y' || run_second_time=='y')
%            clusterNum = input('choose number of clusters (e.x. 2):');
%            [ Unow, center, now_obj_fcn ] = FCMforImage( image_to_process, clusterNum )
%            figure;
%            for i=1:clusterNum
%                subplot(floor(sqrt(clusterNum)),floor(sqrt(clusterNum))+2,i);
%                imshow(Unow(:,:,i),[]);
%                title(strcat('cluster',{' '},int2str(i)));
%            end
%            image_to_process = choose_cluster(clusterNum,Unow);
%            image_to_process = imbinarize(image_to_process,0.65);
%            main_plus_render(I,image_to_process)
%     else
%         image_to_process = imbinarize(image_to_process,0.65);
%         main_plus_render(I,image_to_process)
%     end
end




function image_to_process = choose_cluster(clusterNum,Unow)
    clustered_img_number = input(['choose the number ','between 1 and ',int2str(clusterNum),' of a clustered image for further processing (e.x 3):'],'s');
    num = str2num(clustered_img_number);
    % image_to_process = imbinarize(Unow(:,:,num),0.5);
    image_to_process = Unow(:,:,num);
%    figure;
%    imshow(image_to_process);
    title('image_to_process');
end

function main_plus_render(I,image_to_process)
   addpath(genpath('~/Pulpit/magisterka/algotithms/morphology/'));
   seg_image = main(image_to_process);
   render_seg_subplots(I,seg_image);
end


function [ Unow, center, now_obj_fcn ] = FCMforImage( img, clusterNum )
    % img = double(imread('brain.tif'));
    % clusterNum = 3;
    % [ Unow, center, now_obj_fcn ] = FCMforImage( img, clusterNum );
    % figure;
    % subplot(2,2,1); imshow(img,[]);
    % for i=1:clusterNum
    %     subplot(2,2,i+1);
    %     imshow(Unow(:,:,i),[]);
    % end

    if nargin < 2
        clusterNum = 2;   % number of cluster
    end

    [row, col] = size(img);
    expoNum = 2;      % fuzzification parameter
    epsilon = 0.001;  % stopping condition
    mat_iter = 100;   % number of maximun iteration

    % ��ʼ�� U
    Upre = rand(row, col, clusterNum);
    dep_sum = sum(Upre, 3);
    dep_sum = repmat(dep_sum, [1,1, clusterNum]);
    Upre = Upre./dep_sum;

    center = zeros(clusterNum,1); % �洢���ֵ
    % ����������ĵ�
    for i=1:clusterNum
        center(i,1) = sum(sum(Upre(:,:,i).*img))/sum(sum(Upre(:,:,i)));
    end
    % ������ۺ���
    pre_obj_fcn = 0;
    for i=1:clusterNum
        pre_obj_fcn = pre_obj_fcn + sum(sum((Upre(:,:,i) .*img - center(i)).^2));
    end
    fprintf('Initial objective fcn = %f\n', pre_obj_fcn);

    for iter = 1:mat_iter    
        %����Unow(������)
        Unow = zeros(size(Upre));
        for i=1:row
            for j=1:col
                % ĳ�����ص��Unow����
                for uII = 1:clusterNum
                    tmp = 0;
                    for uJJ = 1:clusterNum
                        disUp = abs(img(i,j) - center(uII));
                        disDn = abs(img(i,j) - center(uJJ));
                        tmp = tmp + (disUp/disDn).^(2/(expoNum-1));
                    end
                    Unow(i,j, uII) = 1/(tmp);
                end            
            end
        end   

        now_obj_fcn = 0;
        for i=1:clusterNum
            now_obj_fcn = now_obj_fcn + sum(sum((Unow(:,:,i) .*img - center(i)).^2));
        end
        fprintf('Iter = %d, Objective = %f\n', iter, now_obj_fcn);

        if max(max(max(abs(Unow-Upre))))<epsilon || abs(now_obj_fcn - pre_obj_fcn)<epsilon %����2���ж�
            break;
        else
            Upre = Unow.^expoNum;
            % ���¼���������ĵ�
            for i=1:clusterNum
                center(i,1) = sum(sum(Upre(:,:,i).*img))/sum(sum(Upre(:,:,i)));
            end
            pre_obj_fcn = now_obj_fcn;
        end
    end
end

