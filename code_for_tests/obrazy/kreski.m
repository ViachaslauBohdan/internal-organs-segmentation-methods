clear all 
o = imread('obrazy/tomografiaguznerki.jpg');
subplot(1,2,1);
 subimage(o);
 seg = im2bw(o,0.62); % pierwszy sposób progowania
 se = strel('diamond',1);
 otw = imopen(seg,se);
 subplot(1,2,2); subimage(otw);
 




