% In class 18

%GB comments
1.50 I could not get your code to run on my computer. If you can show me it works on yours then I would be happy to fix this grade. 
2. 100
overall: 75


clear all

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

%diameters determined from 3 random cells in image using improfile. I
%realized later this might have been done better with a regionprops
%application. 
xy(1) = pdist([232,189; 204,215],'euclidean');
xy(2) = pdist([215,239; 226,273],'euclidean');
xy(3) = pdist([204,250; 154,220],'euclidean');

rng = range(xy(1,:));
rng = rng/2;
dist = mean(xy(1,:));



Iy = imfilter(img1,fspecial('sobel'),'replicate');
Ix = imfilter(img1,fspecial('sobel'),'replicate');
edge_img1 = sqrt(Ix.^2+Iy.^2);


radiiLim = [((dist/2)-rng),((dist/2)+1)];
disp(['Radius range is: ' num2str(radiiLim(1,1)) ' and ' num2str(radiiLim(1,2))])
[centers,radii] = imfindcircles(edge_img1,[9,25],...
    'Sensitivity',0.95);
figure;imshow(edge_img1,[]);hold on;
for ii = 1:length(centers)
    ii
    drawcircle(centers(ii,:),radii(ii),'r')
    hold on;
end


imshow(edge_img1,[]);
disp('done');
%%
% Problem 2. (A) Draw two sets of 10 random numbers - one from the integers
% between 1 and 9 and the second from the integers between 1 and 10. Run a
% ttest to see if these are significantly different. (B) Repeat this a few
% times with different sets of random numbers to see if you get the same
% result. (C) Repeat (A) and (B) but this time use 100 numbers in each set
% and then 1000 numbers in each set. Comment on the results. 
clear all

%A
numdraw1 = ceil(rand(10)*9);
numdraw1 = numdraw1(1,:);
numdraw2 = ceil(rand(10)*10);
numdraw2 = numdraw2(1,:);

[sigchk, pval] = ttest(numdraw1,numdraw2);
%no the are not significant pval = 0.2262

%B
for ii = 1:100
numdraw1 = ceil(rand(10)*9);
numdraw1 = numdraw1(1,:);
numdraw2 = ceil(rand(10)*10);
numdraw2 = numdraw2(1,:);

[sigchk(ii), pval(ii)] = ttest(numdraw1,numdraw2);
end
sum(sigchk)
mean(pval)
%Only two out of the 100 samples had significance in my first run of this
%code, This is because the pvalue fell outside of the 95% range. This will
%happen with on of the random group means is very, very small and the other
%groups mean is very, very large. %Other runs I had turned up zero out of
%100 significant to as many as 15 in one instance.

%C
for ii = 1:100
numdraw1 = ceil(rand(100)*9);
numdraw1 = numdraw1(1,:);
numdraw2 = ceil(rand(100)*10);
numdraw2 = numdraw2(1,:);
[sigchk1(ii), pval1(ii)] = ttest(numdraw1,numdraw2);
end
sum(sigchk1)
mean(pval1)

for ii = 1:100
numdraw1 = ceil(rand(1000)*9);
numdraw1 = numdraw1(1,:);
numdraw2 = ceil(rand(1000)*10);
numdraw2 = numdraw2(1,:);
[sigchk2(ii), pval2(ii)] = ttest(numdraw1,numdraw2);
end
sum(sigchk2)
mean(pval2)

%the mean value for 100 random numbers is going to be very close to either
%4.5 or 5 depending on which set it came from. by increaseing out sample
%size to very large selections, we can solidify the values and assure
%ourselves that the means will be different. 
