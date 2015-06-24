function [atlas,xtform,translation] = create_atlas(mosaic,row_img,current_row_num,xtform,percent_overlap,cornerSearch_pixelWidth)

%% Video Mosaicking
% Video mosaicking is the process of stitching video frames together to
% form a comprehensive view of the scene. The resulting mosaic image is a
% compact representation of the video data, which is often used in video
% compression and surveillance applications.

%   Copyright 2004-2010 The MathWorks, Inc.
%   $Revision: 1.1.6.2.2.1 $  $Date: 2011/01/25 21:57:17 $

%% Introduction
% This demo illustrates how to use the CornerDetector System object, the
% GeometricTransformEstimator System object, the AlphaBlender System object,
% and the GeometricTransformer System object to create a mosaic image from a
% video sequence. First, the demo identifies the corners in the first
% (reference) and second video frame. Then, it calculates the projective
% transformation matrix that best describes the transformation between
% corner positions in these frames. Finally, the demo overlays the second
% image onto the first image. The demo repeats this process to create a
% mosaic image of the video scene.
% mosaic
% row_img
% current_row_num
% numRows
% cornerSearch_pixelWidth
% xtform
%??????????????????????????????????????????????????????????????
rowSize = size(row_img);
rowSize
% percent_overlap = 25;
pixel_overlap = floor(rowSize(1) * percent_overlap);
pixel_overlap

horizontal_center = floor(rowSize(2)/2);
cornerSearch_left = horizontal_center - floor(cornerSearch_pixelWidth/2);
cornerSearch_right = horizontal_center + floor(cornerSearch_pixelWidth/2);  

added_height_per_row = rowSize(1) - pixel_overlap;
added_height_per_row
sizeAtlas = [(rowSize(1) + (current_row_num-1)*added_height_per_row), rowSize(2)];
sizeAtlas
current_mosaic_bottom = rowSize(1) + (current_row_num-2)*added_height_per_row;
current_mosaic_bottom
%??????????????????????????????????????????????????????????????

%% Initialization
% Use these next sections of code to initialize the required System objects.
featWinLen = 15;         % Length of feature window 
winSize = floor(featWinLen/2);
maxNumPoints = 500;      % Maximum number of points 
sizePano = sizeAtlas;
origPano = [1 1];
ptsOffset = int32(floor([featWinLen;featWinLen]/2));
classToUse = 'single';
initFeatDiff = cast(1e+10, classToUse);   % Initial feature difference

%%
% Create a VideoFileReader System object to read video from a file. 
% hsrc = vision.VideoFileReader( ...
%     'vipmosaicking.avi', ...
%     'ImageColorSpace', 'RGB', ...
%     'PlayCount', 1);

%%
% Create a ColorSpaceConverter System object to convert the RGB image to
% intensity format.
hcsc = vision.ColorSpaceConverter( ...
    'Conversion', 'RGB to intensity');

%%
% Create a CornerDetector System object to identify the corner locations of
% current and the previous video frames. 
 hcornerdet = vision.CornerDetector( ...
    'Method', 'Local intensity comparison (Rosen & Drummond)', ...
    'IntensityThreshold', 0.1, ...
    'MaximumCornerCount', maxNumPoints, ...
    'CornerThreshold', 0.001, ...
    'NeighborhoodSize', [21 21]);
                
%%
% Create an GeometricTransformEstimator System object to implement the
% RANSAC (RANdom SAmple Consensus) algorithm. This System object verifies
% that the corners have been properly identified. It also calculates the
% transformation matrix that maps the corner positions in the current frame
% to the corner positions in previous frame.
hestgeotform = vision.GeometricTransformEstimator( ...
    'AlgebraicDistanceThreshold',   1, ...
    'NumRandomSamplingsMethod', 'Desired confidence', ...
    'MaximumRandomSamples', 500, ...
    'InlierPercentageSource', 'Property', ...
    'InlierPercentage', 75, ...
    'RefineTransformMatrix',  true, ...
    'InlierOutputPort', true);
    
%%
% Create a GeometricTransformer System object.
hgeotrans = vision.GeometricTransformer( ...
    'OutputImagePositionSource', 'Property', ...
    'OutputImagePosition', [-origPano sizePano]);     %, ...
%     'ROIInputPort', true);

%%
% Create a AlphaBlender System object to overlay the consecutive video
% frames to produce the panorama.
halphablender = vision.AlphaBlender( ...
    'Operation', 'Binary mask', ...
    'MaskSource', 'Input port');

%%
% Create a MarkerInserter System object to draw the corner locations in each
% video frame.
hdrawmarkers = vision.MarkerInserter( ...
    'Shape', 'Circle', ...
    'BorderColor', 'Custom', ...
    'CustomBorderColor', [1 0 0]);           
                        
%%
% Create two VideoPlayer System objects, one to display the corners of each
% frame and other to draw the panorama.

hVideo1 = vision.VideoPlayer('Name', 'Corners');
hVideo1.Position(1) = hVideo1.Position(1) - 350;                        

hVideo2 = vision.VideoPlayer('Name', 'Mosaic');
hVideo2.Position(1) = hVideo1.Position(1)+ 400;
hVideo2.Position([3 4]) = [750 500];

%% Stream Processing Loop
% Create a processing loop to create panorama from the input video. This
% loop uses the System objects you instantiated above.

points = zeros(2,maxNumPoints,classToUse);
features = zeros(featWinLen^2,maxNumPoints,classToUse);
numPoints = 0;

% if current_row_num <= numRows

% while ~isDone(hsrc)    %??????????????????????????????????????????????
    % Save the points and features computed from the previous image
    %#########################
    % Detect corners in the (bottom, overlapping part of) mosaic image   ***subimage of I selected to minimize
    % corner search time***
    upperLeft(1) = current_mosaic_bottom - floor(rowSize(1)*percent_overlap);
    lowerRight(1) = current_mosaic_bottom;
    upperLeft(2) = cornerSearch_left;
    lowerRight(2) = cornerSearch_right;
    upperLeft
    lowerRight
    gray_mosaic = step(hcsc, mosaic(upperLeft(1):lowerRight(1),upperLeft(2):lowerRight(2),:));

    cornerPoints = step(hcornerdet, gray_mosaic);
    numCornerPoints = size(cornerPoints,1);
    numCornerPoints
    cornerPoints = cast(cornerPoints, classToUse);
    
    % Extract the features for the corners
    [features, points] = extractFeatures(gray_mosaic, ...
        cornerPoints(1:numCornerPoints,:), 'BlockSize', featWinLen);
    numPoints = size(points, 1);
    numPoints
    sizePoints = size(points)
    sizePoints
    %### Recalibrate location of cornerPoints
    points(1,:) = points(1,:) + (current_mosaic_bottom - floor(rowSize(1)*percent_overlap));
    points(2,:) = points(2,:) + cornerSearch_left;
    
%#########################
    pointsPrev = points;
    featuresPrev = features;
    numPointsPrev = numPoints;
    
    %??????????????????????????????????????????????????????????????
    % To speed up mosaicking, select and process every 5th image
    rgb = row_img;
%     for i = 1:5
%         rgb = step(hsrc);
%         if isDone(hsrc)
%             break;
%         end
%     end
    %??????????????????????????????????????????????????????????????

    I = step(hcsc, rgb(1:floor(rowSize(1)*percent_overlap),cornerSearch_left:cornerSearch_right,:));
%     imageDim = size(I);  
%     roi = int32([1 1 size(I, 1)-2 size(I, 2)-2]);

    % Detect corners in the (top, overlapping part of) image   ***subimage of I selected to minimize
    % corner search time***
    release(hcornerdet);
    cornerPoints = step(hcornerdet, I);
    numCornerPoints = size(cornerPoints,1);
    numCornerPoints    
    cornerPoints = cast(cornerPoints, classToUse);
    
    % Extract the features for the corners
    [features, points] = extractFeatures(I, ...
        cornerPoints(1:numCornerPoints,:), 'BlockSize', featWinLen);
    numPoints = size(points, 1);
    numPoints
    %### Recalibrate location of cornerPoints
    points(:,2) = points(:,2) + cornerSearch_left;
    
    % Match features computed from the current and the previous images
    sizeFeatures = size(features);
    sizeFeaturesPrev = size(featuresPrev);
    sizeFeatures
    sizeFeaturesPrev
    indexPairs = matchFeatures(features,featuresPrev(1:numPointsPrev,:),...
        'MatchThreshold',0.5);                                                          % increase parameter?????
    sizeIndexPairs = size(indexPairs);
    sizeIndexPairs
    numMatchedPoints = cast(size(indexPairs, 1), 'int32');
    if numMatchedPoints > maxNumPoints
        numMatchedPoints = int32(maxNumPoints);
        indexPairs = indexPairs(1:numMatchedPoints,:);
    end

    % Check if there are enough corresponding points in the current and the
    % previous images
    isMatching = false;
    if numMatchedPoints > 4                                                          % increase parameter?????
        matchedPoints = zeros(maxNumPoints, 2);
        matchedPointsPrev = zeros(maxNumPoints, 2);
        matchedPoints(1:numMatchedPoints, :) = points(indexPairs(:, 1), :);
        matchedPointsPrev(1:numMatchedPoints,:) = ...
            pointsPrev(indexPairs(:, 2), :);
        
        % Find corresponding points in the current and the previous images,
        % and compute a geometric transformation from the corresponding
        % points
        [tform, inlier] = step(hestgeotform, ...
            matchedPoints, matchedPointsPrev);
       
        %=======================================================
        tform = [1 0;0 1;round(tform(3,1)) round(tform(3,2))];
        delta_x = tform(3,1)
        delta_y = tform(3,2)
        translation = struct('delta_x',delta_x,'delta_y',delta_y);
        %=======================================================
          
        if sum(inlier) >= 8
            % If there are at least 8 corresponding points, we declare the
            % current and the previous images matching
            isMatching = true;
        end
    end
    
    if isMatching
        % If the current image matches with the previous one, compute the
        % transformation for mapping the current image onto the mosaic
        % image
        xtform = xtform * tform;
    else
        % If the current image does not match the previous one, reset the
        % transformation and the mosaic image
        xtform = eye(3, classToUse);
        mosaic = zeros([sizePano,3],classToUse);
    end

    % Display the current image and the corner points
    cornerPoints(numCornerPoints+1:end, :) = -5;
    cornerImage = step(hdrawmarkers, rgb, cornerPoints);
    step(hVideo1, cornerImage);
    
    % Warp the current image onto the mosaic image and display the mosaic
    % image
    transformedImage = step(hgeotrans, rgb, xtform, roi);
    atlas = step(halphablender, mosaic, transformedImage, ...
        transformedImage(:,:,1)>0);
    step(hVideo2, atlas);

%#########################
%     % Detect corners in the (bottom, overlapping part of)  image   ***subimage of I selected to minimize
%     % corner search time***
%     [cornerPoints, numCornerPoints] = step(hcornerdet, I(floor(imageDim(1)*(1-percent_overlap)):end,cornerSearch_left:cornerSearch_right));
%     cornerPoints = cast(cornerPoints, classToUse);
%     
%     % Extract the features for the corners
%     [features, points] = extractFeatures(I, ...
%         cornerPoints(:,1:numCornerPoints), 'BlockSize', featWinLen);
%     numPoints = size(points, 2);
%#########################

% end

%% Release
% Here you call the release method on the System objects to close any open 
% files and devices.

%######## remove following line
% release(hsrc);

%% Summary
% The Corners window displays the input video along with the detected
% corners and Mosaic window displays the panorama created from the input
% video.

displayEndOfDemoMessage(mfilename)

%### Variables to return from function
% atlas;
% xtform;
