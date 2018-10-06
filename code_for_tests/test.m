%  im = imread('/home/slawek/obrazy/GRAINS2.BMP');
%  im1 = imcomplement(im);
%  s = strel('square',11)
%  im2 = imerode(im1,s);
%  im3 = imdilate(im2,s);
%  im4 = imreconstruct(im2,im1);
%  imshow([im1 im2;im3 im4])

% min_distance=[2 1 0 1 2]
% hist_value = [1 2 3 4 5]
% for i=2:3
% 		min_distance =min(min_distance,  abs(hist_value-cluster(i)))
% end;

% f = figure;
% imshow(ans);
% imcontrast(f);

%  im = imread('/home/slawek/obrazy/GRAINS1.BMP');
%  im1 = imcomplement(im);
%  imshow(im1)
%  p = roipoly
%  p2 = min(im2uint8(p),im1);
%  im2 = imreconstruct(p2,im1);
%  imshow([im1 p2 im2]);
% o = imread('./obrazy/lotnicze.tif');
% close all;
% subplot(2,2,1); subimage(o);
% 
% subplot(2,2,2); subimage(imadjust(o,[0.2 1],[0 1]));
% subplot(2,2,3); subimage(imadjust(o,[0.4 1],[0 1]));
% subplot(2,2,4); subimage(imadjust(o,[0.2 1],[0.1 0.6]));
% figure; % utwórz nowe okno wyświetlania obrazów
% subplot(2,2,1); subimage(o);
% subplot(2,2,2); subimage(imadjust(o,[0 1],[0 1],0.5));
% subplot(2,2,3); subimage(imadjust(o,[0 1],[0 1],2));
% subplot(2,2,4); subimage(imadjust(o,[0 1],[0 1],5));

 im = imread('./obrazy/CELLS1.BMP');
 imshow(im);title('obraz oryginalny');
 im2 = imclose(im,ones(3)); % filtracja wstępna
 im3 = im2 > 85; % segmentacja przez progowanie
 im3a = imerode(im3,ones(5)); % otwarcie przez rekonstrukcję
 im4 = imreconstruct(im3a,im3); % obrazu po segmentacji
 figure; imshow([im im2 ; im2uint8(im3) im2uint8(im4)]);
 title('filtracja i segmentacja');
[im5 n] = bwlabel(~im4); % etykietowanie
 figure; imshow(im5+1,rand(100,3)); title('wynik etykietowania');
 c = regionprops(im5,'Perimeter','Area');
 ar = cat(1,c.Area); % wektor powierzchni obiektów
 pe = cat(1,c.Perimeter); % wektor obwodów obiektów
 cc = (pe.*pe)./ar % wektor współczynników (cech)
 lut = cc < 14;
 lut1=zeros(256,1);
 lut1(1:size(lut,1)) = lut; % tablica korekcji
 im6 = intlut(uint8(im5-1),uint8(lut1)); % zastosowanie tablicy kor.
 im7 = (1 - uint8(im4)) + im6; % przygotowanie do wyświetlenia
 figure; imshow(im7+1,[0 0 0; 0 0 0 ;1 0 0 ; 0 1 0]); title('wynik klasyfikacji');
 