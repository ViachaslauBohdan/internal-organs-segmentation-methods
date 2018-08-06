close all;

path = strcat('~/','Pulpit/magisterka/test_images/images2/dicom_images/matlab/examples/sample_data/DICOM/digest_article/');
info = dicominfo(strcat(path,'brain_001.dcm'))
nRows = info.Rows;
nCols = info.Columns;
nPlanes = info.SamplesPerPixel;
nFrames = 20; % The number of files in the directory

X = repmat(int16(0), [nRows, nCols, nPlanes, nFrames]);


 for p=1:nFrames
   fname = strcat(path,sprintf('brain_%03d.dcm', p));
   X(:,:,1,p) = dicomread(fname);
 end

% Keep track of the minimum and maximum pixel values.
minPixels = repmat(0, [1, nFrames]);
maxPixels = repmat(0, [1, nFrames]);

for p = 1:nFrames
  fname = strcat(path,sprintf('brain_%03d.dcm', p));
  info = dicominfo(fname);
  minPixels(p) = info.SmallestImagePixelValue;
  maxPixels(p) = info.LargestImagePixelValue;
end

% Rescale image to start at 0.
b = min(minPixels);
m = 2^16/(max(maxPixels) - b);
Y = imlincomb(m, X, -(m * b), 'uint16');
 
 %Display the image stack.
montage(Y,'displayrange',[])
