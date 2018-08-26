function ret = fn(b,h)
    
     path = fullfile('static','tomografiaguznerki.jpg')
     image = imread(path);
     ret = processing(image);
end

function back = processing(o)
 seg = imbinarize(o,0.62); % pierwszy sposób progowania
 se = strel('diamond',1);
 otw = imopen(seg,se);
 figure;
 image(otw);
 figure;
 image(seg);
 auto = graythresh(o)
 auto_seg = imbinarize(o,auto);
 figure;
 image(auto_seg);
 back = 'segmentation perfomed';
 close all
end