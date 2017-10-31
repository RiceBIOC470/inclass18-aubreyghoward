% In class 18

% Problem 1. In this directory, you will find the same image of yeast cells as you used
% in homework 5. First preprocess the image any way you like - smoothing, edge detection, etc. 
% Then, try to find as many of the cells as you can using the
% imfindcircles routine with appropriate parameters. 
% Display the image with the circles drawn on it.  
reader = bfGetReader('yeast.tif');

fid = fopen('readerData.txt','w');
for i = 1:length(reader)
    fprintf(fid,'Data for image number: %d \n',i);
    fprintf(fid,'Channel Num: %d \n',(reader.getSizeC));
    fprintf(fid,'Time Scale: %d \n',(reader.getSizeT));
    fprintf(fid,'Z slices: %d \n \n',(reader.getSizeZ));
end
fclose(fid);

chan = 1;
time = 1;
zplane = 1;
iplane = reader.getIndex(zplane-1,chan-1,time-1)+1;
img1 = bfGetPlane(reader,iplane);

img1 = im2double(img1);
img1 = imfilter(img1,fspecial('gaussian',4,2));

Iy = imfilter(img1,fspecial('sobel'),'replicate');
Ix = imfilter(img1,fspecial('sobel'),'replicate');
edge_img1 = sqrt(Ix.^2+Iy.^2);

[centers,radius] = imfindcircles(edge_img1,'Sensitivity',0.95);
figure;imshow(edgeimg,[]);hold on;
for ii = length(centers);
    drawcircle(centers(ii,:),radius(ii),'m');
end
hold off;

imshow(img1,[]);


% Problem 2. (A) Draw two sets of 10 random numbers - one from the integers
% between 1 and 9 and the second from the integers between 1 and 10. Run a
% ttest to see if these are significantly different. (B) Repeat this a few
% times with different sets of random numbers to see if you get the same
% result. (C) Repeat (A) and (B) but this time use 100 numbers in each set
% and then 1000 numbers in each set. Comment on the results. 