function [ Unow, center, now_obj_fcn ] = FCMforImage( img, clusterNum )
% 原始FCM算法用于图像分割的代码
% demo
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

% 初始化 U
Upre = rand(row, col, clusterNum);
dep_sum = sum(Upre, 3);
dep_sum = repmat(dep_sum, [1,1, clusterNum]);
Upre = Upre./dep_sum;

center = zeros(clusterNum,1); % 存储点的值
% 计算聚类中心点
for i=1:clusterNum
    center(i,1) = sum(sum(Upre(:,:,i).*img))/sum(sum(Upre(:,:,i)));
end
% 计算代价函数
pre_obj_fcn = 0;
for i=1:clusterNum
    pre_obj_fcn = pre_obj_fcn + sum(sum((Upre(:,:,i) .*img - center(i)).^2));
end
fprintf('Initial objective fcn = %f\n', pre_obj_fcn);

for iter = 1:mat_iter    
    %更新Unow(逐点更新)
    Unow = zeros(size(Upre));
    for i=1:row
        for j=1:col
            % 某个像素点的Unow更新
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

    if max(max(max(abs(Unow-Upre))))<epsilon || abs(now_obj_fcn - pre_obj_fcn)<epsilon %引入2个判定
        break;
    else
        Upre = Unow.^expoNum;
        % 重新计算聚类中心点
        for i=1:clusterNum
            center(i,1) = sum(sum(Upre(:,:,i).*img))/sum(sum(Upre(:,:,i)));
        end
        pre_obj_fcn = now_obj_fcn;
    end
end
