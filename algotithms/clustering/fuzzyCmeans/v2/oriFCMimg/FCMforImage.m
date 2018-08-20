function [ Unow, center, now_obj_fcn ] = FCMforImage( img, clusterNum )
% ԭʼFCM�㷨����ͼ��ָ�Ĵ���
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
