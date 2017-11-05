% My Harris detector
% The code calculates
% the Harris Feature/Interest Points (FP or IP) 
% 
% When u execute the code, the test image file opened
% and u have to select by the mouse the region where u
% want to find the Harris points, 
% then the code will print out and display the feature
% points in the selected region.
% You can select the number of FPs by changing the variables 
% max_N & min_N


%%%
%corner : significant change in all direction for a sliding window
%%%


%%
% parameters
% corner response related
sigma = 2;
n_x_sigma = 6;
alpha = 0.04;
% maximum suppression related
Threshold = 20;  % should be between 0 and 1000
r=6; 


%%
% filter kernels
dx = [-1 0 1; -1 0 1; -1 0 1]; % horizontal gradient filter 
dy = dx'; % vertical gradient filter
g = fspecial('gaussian',max(1,fix(2*n_x_sigma*sigma)), sigma); % Gaussien Filter: filter size 2*n_x_sigma*sigma


%% load 'Im.jpg'
frame = imread('data/Im.jpg');
I = double(frame);
figure(1);
imshow(frame);
[xmax, ymax,ch] = size(I);
xmin = 1;
ymin = 1;


%%%%%%%%%%%%%%Intrest Points %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%
% get image gradient
% I_grey = grey_scale(I);

I_grey = double(rgb2gray(frame))/255;

Ix = imfilter(I_grey, dx);
Iy = imfilter(I_grey, dy);

%%%%%
% get all components of second moment matrix M = [[Ix2 Ixy];[Iyx Iy2]]; note Ix2 Ixy Iy2 are all Gaussian smoothed

% calculate Ix2 
Ix2 = Ix.*Ix;
Ix2_smoothed = imfilter(Ix2, g);

% calculate Iy2
Iy2 = Iy.*Iy;
Iy2_smoothed = imfilter(Iy2, g);

% calculate Ixy
IxIy = Ix.*Iy;
IxIy_smoothed = imfilter(IxIy, g);

% M = [[Ix2_smoothed IxIy_smoothed];[IxIy_smoothed Iy2_smoothed]];
%%%%%

%% visualize Ixy
figure(2);
imagesc(IxIy_smoothed);

%%%%%%% Demo Check Point -------------------


%%%%%
% get corner response function R = det(M)-alpha*trace(M)^2 
% calculate R
R = Ix2_smoothed.*Iy2_smoothed - IxIy_smoothed.*IxIy_smoothed -alpha*(Ix2_smoothed.*Iy2_smoothed).^2;
%%%%%

%% make max R value to be 1000
R = (1000/max(max(R)))*R; % be aware of if max(R) is 0 or not

%%%%%
%% using B = ordfilt2(A,order,domain) to complment a maxfilter
sze = 2*r+1; % domain width 
% [Your Code here] 
% calculate MX
%%%%%
MX = ordfilt2(R, sze^2, ones(sze, sze));
%%%%%
% find local maximum.
RBinary = (R == MX) & (MX > Threshold);
%%%%%


%% get location of corner points not along image's edges
offe = r-1;
count=sum(sum(RBinary(offe:size(RBinary,1)-offe,offe:size(RBinary,2)-offe))); % How many interest points, avoid the image's edge   
R=R*0;
R(offe:size(RBinary,1)-offe,offe:size(RBinary,2)-offe)=RBinary(offe:size(RBinary,1)-offe,offe:size(RBinary,2)-offe);
[r1,c1] = find(R);
  

%% Display
figure(3)
imagesc(uint8(I));
hold on;
plot(c1,r1,'or');
return;
