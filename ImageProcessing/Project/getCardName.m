function [value, suit] = getCardName(I, s, f, n, suits, CI, DI, HI, SI)
    %% Auxiliar Functions
    
    noiseSize = 150;

    slope = @(line) (line.point2(2) - line.point1(2))/(line.point2(1) - line.point1(1));
    intercept = @(line,m) line.point1(2) - m* line.point1(1);
    
    %% Processing image

    BW = edge(I, 'canny', 0.5);
    
%     figure
%     imshowpair(I,BW,'montage')
%     title('Canny edges')

    [H,T,R] = hough(BW, 'RhoResolution', 2);
    P = houghpeaks(H, 100);
    lines = houghlines(BW, T, R, P);

    if (length(lines) > 4)
        % We just want to get four lines, four edges has a standard playing card
        lines = removeDuplicates(lines);
    end

    % Getting intersection points
    m1 = slope(lines(1));
    m2 = slope(lines(2));
    m3 = slope(lines(3));
    m4 = slope(lines(4));

    b1 = intercept(lines(1), m1);
    b2 = intercept(lines(2), m2);
    b3 = intercept(lines(3), m3);
    b4 = intercept(lines(4), m4);

    corners = [];

    % Another problem here: line index is wrong, 
    %   2 1 3 4 (top, right, bottom, left)
    %   4 2 3 1
    % TODO: Fix this, lines must ever get the same order
    % [corners(1).x corners(1).y] = intersectionPoint(m1,m2,b1,b2)
    [corners(1).x, corners(1).y] = intersectionPoint(m1,m4,b1,b4);
    [corners(2).x, corners(2).y] = intersectionPoint(m1,m3,b1,b3);
    % [corners(3).x corners(3).y] = intersectionPoint(m3,m4,b3,b4)
    [corners(3).x, corners(3).y] = intersectionPoint(m2,m3,b2,b3);
    [corners(4).x, corners(4).y] = intersectionPoint(m2,m4,b2,b4);
    
    % showEdges(I, lines, corners);

    % Generating orthophoto
    % Cropping from original image
    I2 = imcrop(f, s(n).BoundingBox);
    I2 = im2bw(I2, graythresh(I2));
    % I2 = rgb2gray(I2)
    
    % TODO: Same problem here, we must to solve the lines and corners
    % order.

%     x = [corners(4).x; corners(1).x; corners(2).x; corners(3).x];
%     y = [corners(4).y; corners(1).y; corners(2).y; corners(3).y];
    x = [corners(1).x; corners(4).x; corners(3).x; corners(2).x];
    y = [corners(1).y; corners(4).y; corners(3).y; corners(2).y];
    movingPoints = [x,y];

    xfix = [1;500;500;1];
    yfix = [1;1;700;700];
    fixedPoints = [xfix, yfix];

    T = fitgeotrans(movingPoints,fixedPoints,'projective');
    R = imref2d([700 500]);
    neworthophoto = imwarp(I2,T,'OutputView',R);
    
%     figure
%     title('New genereated orthophoto')
%     imshow(neworthophoto)

    % Getting new regions for value and suit
    processedorthophoto = imcomplement(neworthophoto);
    processedorthophoto = bwareaopen(processedorthophoto, noiseSize);
    s2 = regionprops(processedorthophoto,'BoundingBox','Image');

    showRegions(neworthophoto, s2)

    % Processing the card's value
    % index 1 = suit
    % index 2 = value
    valueimage = imcrop(neworthophoto, s2(2).BoundingBox);
    % imshow(valueimage)

    % BW = imdilate(valueimage,strel('disk',0, 8));
    % imshowpair(valueimage,BW,'montage')

    ocrResults = ocr(valueimage, 'TextLayout', 'Block', 'CharacterSet', 'A23456789JKQ');
    showOCRValue(valueimage, ocrResults)
    value = ocrResults.Text;
    % disp(value)

    % Processing the card's suit
    suitimage = imcrop(neworthophoto, s2(3).BoundingBox);
    suit = getCardSuit(suitimage, suits, CI, DI, HI, SI);
end