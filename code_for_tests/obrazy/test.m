 o = imread('uscal.tif');
 figure('Name','Obraz poczatkowy');imshow(o);
 se1 = [0 1 0 ; 1 1 1 ; 0 1 0] % pierwszy element strukturujący
 se2 = strel('disk',5) % drugi element strukturujący
 oe1 = imerode(o, se1);
 figure('Name','Wynik erozji z se1');imshow(oe1);
 oe2 = imerode(o, se2);
 figure('Name','Wynik erozji z se2');imshow(oe2);
 od1 = imdilate(o, se1);
 figure('Name','Wynik dylacji z se1');imshow(od1);
 od2 = imdilate(o, se2);
 figure('Name','Wynik dylacji z se2');imshow(od2);