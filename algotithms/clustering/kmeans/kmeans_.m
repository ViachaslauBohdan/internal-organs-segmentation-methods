k = 6;
[mu,mask] = kmeans(I,k);
% mask=mat2gray(mask);% convert matrix to image 
close all;

for i = 1:k
    figure;
    single_label = mask == i;
    imshow(label2rgb(single_label,@jet,'black'),[]);
end


function [centroidsCoordinates,mask]=kmeans(image,k)
figure;
imshow(image);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   kmeans image segmentation
%
%   Input:
%          ima: grey color image
%          k: Number of classes
%   Output:
%          mu: vector of class means 
%          mask: clasification image mask
%
%   Author: Jose Vicente Manjon Herrera
%    Email: jmanjon@fis.upv.es
%     Date: 27-08-2005
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% check image
image=double(image);
copy=image;         % make a copy
image=image(:);       % vectorize ima
minImageValue=min(image);      % deal with negative 
image=image-minImageValue+1;     % and zero values

imageLength=length(image);

% create image histogram

maxImageValue=max(image)+1;
imageHistogram=zeros(1,maxImageValue);
histClusters=zeros(1,maxImageValue);

for i=1:imageLength
  if(image(i)>0) imageHistogram(image(i))=imageHistogram(image(i))+1;end; %imageHist = [323 222 894 19 190 ...]
end

histIndexes=find(imageHistogram);
histLength=length(histIndexes);

% initiate centroids

centroidsCoordinates=(1:k)*maxImageValue/(k+1); %[63 127 191]

% start process
p=0;
while(p==0)
  
  oldCentroidsCoordinates=centroidsCoordinates;
  % current classification  
 
  for i=1:histLength
      distance=abs(histIndexes(i)-centroidsCoordinates);
      cluster=find(distance==min(distance));
      histClusters(histIndexes(i))=cluster(1); % [1 1 1 1 1 1 1 1 2 2 2 2 2 2 3 3 3  3 3 3 3 3 4 4 4 4 4 5 5 5  5 5 6 6 6 6]
  end

  %recalculation of means  
  
  for i=1:k, 
      histClusterIndexes=find(histClusters==i); %[1 2 3 4 5 6 7 8]
      
      centroidsCoordinates(i)=...
          sum(histClusterIndexes.*imageHistogram(histClusterIndexes))/sum(imageHistogram(histClusterIndexes));
%           sum(histClusterIndexes)/length(histClusterIndexes);
      
  end
  
  if(centroidsCoordinates==oldCentroidsCoordinates) break;end;
%   p=+1;
end

% calculate mask
imageLength=size(copy);
mask=zeros(imageLength);
for i=1:imageLength(1),
for j=1:imageLength(2),
  distance=abs(copy(i,j)-centroidsCoordinates);
  histClusterIndexes=find(distance==min(distance));  
  mask(i,j)=histClusterIndexes(1);
end
end
centroidsCoordinates
centroidsCoordinates=centroidsCoordinates+minImageValue-1;   % recover real range
end