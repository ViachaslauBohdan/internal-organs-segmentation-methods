function [] = read_images()
clear;
close all;


path_to_folder = strcat('~/','Pulpit/magisterka/ct_images/23_16_2006/SE3/');
dicomlist = dir(path_to_folder);
filenames = string({dicomlist.name});
filenames(1:2)=[];

% Preallocate the 256-by-256-by-1-by-20 image array.
X = repmat(int16(0), [512 512 1 56]);

% Read the series of images.
 for p=289:289+numel(filenames)-1
   filename = strcat(path_to_folder,sprintf('img_0%d', p));
   X(:,:,1,p) = dicomread(filename);
 end

 % Display the image stack.
montage(X,'displayrange',[]);
end

