close all;
clc;
filename= '4';
% iminfo = dicominfo(filename)
I = dicomread(filename);
I = I + 2000;
I = rescale(I,0,1);
I = imadjust(I,[0.7 0.8],[0 1]);
% x=268; y=258;
figure, imshow(I,[]);
% pause;
J = segCroissRegion(0.52,I,0,0);
figure;
imshow(J);

function Phi = segCroissRegion(tolerance,Igray,x,y)
    if(x == 0 || y == 0)
        imshow(Igray,[]);
        [x,y] = ginput(1);
    end
    Phi = false(size(Igray,1),size(Igray,2));
    ref = true(size(Igray,1),size(Igray,2));
    PhiOld = Phi;
    Phi(uint8(x),uint8(y)) = 1;
    while(sum(Phi(:)) ~= sum(PhiOld(:)))
        PhiOld = Phi;
        segm_val = Igray(Phi);
        meanSeg = mean(segm_val);
        posVoisinsPhi = imdilate(Phi,strel('disk',1,0)) - Phi;
        voisins = find(posVoisinsPhi);
        valeursVoisins = Igray(voisins);
        Phi(voisins(valeursVoisins > meanSeg - tolerance & valeursVoisins < meanSeg + tolerance)) = 1;
    end
end

% Uncomment this if you only want to get the region boundaries
% SE = strel('disk',1,0);
% ImErd = imerode(Phi,SE);
% Phi = Phi - ImErd;