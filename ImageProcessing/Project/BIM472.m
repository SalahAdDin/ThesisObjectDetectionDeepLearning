%% Codes
clc;
close all;
clear all;

%% Loading suits templates

suits = ["clubs", "diamonds", "hearts", "spades"];

clubsimage = imread('suits/clubs.jpg');
CI = rgb2gray(clubsimage);
% CI_pts = detectSURFFeatures(CI); 
% [CI_features CI_validPts] = extractFeatures(CI, CI_pts); 

diamondsimage = imread('suits/diamonds.jpg');
DI = rgb2gray(diamondsimage);

heartsimage = imread('suits/hearts.jpg');
HI = rgb2gray(heartsimage);

spadesimage = imread('suits/spades.jpg');
SI = rgb2gray(spadesimage);

%% Image acquisition
% f = imread('images/3cards_extreme.jpg');
f = imread('images/green_close.jpg');
% f = imread('images/green_many.jpg');
% f = imread('images/6cards_normal.jpg');

% figure
% imshow(f);

[height, width, dim] = size(f);
imagesize = height * width;

%% Parameters
% Noise size will be every pixel area lesser than 1.5% image area
noiseSize = round(sqrt(0.015 * imagesize), -1);

%% Cleaning the image

% Image to black and white
threshold = graythresh(f);
img = im2bw(f, threshold);
img = bwareaopen(img, noiseSize.^2);  % removing small areas(noise)
img = imfill(img,'holes');
% img = imcomplement(img);

% imshow(img);
% imshowpair(f, img,'montage')

%% Getting object boundaries

% [B,L] = bwboundaries(img, 'noholes');
% imshow(label2rgb(L, @jet, [.5 .5 .5]))
% hold on
% for k = 1:length(B)
%    boundary = B{k};
%    plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
% end

s = regionprops(img,'BoundingBox','Image');

% showRegions(img, s);

%% Processing each image

for n=1:size(s,1)
    disp(['Processing card No. ', num2str(n)])
    I = s(n).Image;
    [v, p] = getCardName(I, s, f, n, suits, CI, DI, HI, SI);
    s(n).Name = append(v,p);
end
    
%% Showing the final result
% imshow(f);
% hold on
% text(8,785,strcat('\color{green}Cars Detected: ',num2str(length(s))))
% for n=1:size(s,1)
%     % rectangle('Position', s(n).BoundingBox,'EdgeColor','g','LineWidth',2);
%     annotation('textbox',s(n).BoundingBox,'String',s(n).Name);
% end
% hold off
