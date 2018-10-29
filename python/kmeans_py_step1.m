function [clustered_images] = kmeans_py_step1(num,num_of_clusters)
    close all;
    addpath('../')
    I = read_image_uint8_py(num);
    bin_images_array = {1,num_of_clusters};

    [a,img,im_result,img_hist,hist_value,cluster,cluster_count,closest_cluster,...
        min_distance,imresult,clustersresult] = kmeansclustering(I,num_of_clusters);
    
    clustered_images = cell(1,num_of_clusters);
    
    for i = 1:num_of_clusters
        bin_images_array{1,i} = im_result == i;
        clustered_images{1,i} = pylist_from_matlab_matrix(bin_images_array{1,i});
    end
      clustered_images = clustered_images(:);
%     pylist = pylist_from_matlab_matrix(bin_images_array{1,1});
%     pylist = pylist(:);
%     pylist = bin_images_array{1,5}

end




function [clusters, result_image, clusterized_image,img_hist,...
    hist_value,cluster,cluster_count,closest_cluster,min_distance...
    ,imresult,clustersresult] = kmeansclustering(im,  k)

%histogram calculation
img_hist = zeros(256,1);
hist_value = zeros(256,1);

for i=1:256
	img_hist(i)=sum(sum(im==(i-1)));
end;
for i=1:256
	hist_value(i)=i-1;
end;
%cluster initialization
cluster = zeros(k,1);
cluster_count = zeros(k,1);
for i=1:k
	cluster(i)=uint8(rand*255);
end;

old = zeros(k,1);
while (sum(sum(abs(old-cluster))) ~=0)
	old = cluster;
	closest_cluster = zeros(256,1);
	min_distance = uint8(zeros(256,1));
	min_distance = abs(hist_value-cluster(1));


	%calculate the minimum distance to a cluster
	for i=2:k
		min_distance =min(min_distance,  abs(hist_value-cluster(i)));
	end;

	%calculate the closest cluster
	for i=1:k
		closest_cluster(min_distance==(abs(hist_value-cluster(i)))) = i;
	end;

	%calculate the cluster count
	for i=1:k
		cluster_count(i) = sum(img_hist .*(closest_cluster==i));
	end;


	for i=1:k 
		if (cluster_count(i) == 0)
			cluster(i) = uint8(rand*255);
		else
			cluster(i) = uint8(sum(img_hist(closest_cluster==i).*hist_value(closest_cluster==i))/cluster_count(i));
           % ŚREDNIA WAŻONA !!!
        end;
	end;
% 	    pause;
end;
imresult=uint8(zeros(size(im)));
for i=1:256
	imresult(im==(i-1))=cluster(closest_cluster(i));
end;

clustersresult=uint8(zeros(size(im)));
for i=1:256
	clustersresult(im==(i-1))=closest_cluster(i);
end;

clusters = cluster;
result_image = imresult;
clusterized_image = clustersresult;
end