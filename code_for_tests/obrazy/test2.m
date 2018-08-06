im1 = imread('baboon.jpg');
[im2 p2] = imread('lena.tif');
im2a = im2uint8(ind2rgb(im2,p2)); % konwersja typu obrazu
imshow([im1 im2a]); title('Obrazy początkowe');
im3 = zeros(512,512);
im3(200:399,200:399)=ones(200,200);
im3a = im2uint8(im3);
im3b(:,:,1) = im3a; % maska w wersji kolorowej - składowa R
im3b(:,:,2) = im3a; % składowa G
im3b(:,:,3) = im3a; % składowa B
im3c = imcomplement(im3b); % odwrócona maska
figure;
imshow([im3b im3c]); title('Obraz - maska');
im5 = min(im2a, im3b);
im4 = min(im1, im3c);
im6 = max(im4,im5);
figure;
imshow([im4 im5 im6]); title('Nałożenie');