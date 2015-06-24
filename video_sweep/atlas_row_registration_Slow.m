function [mosaic,tform_data] = atlas_row_registration_Slow(frames,percent_overlap)
% function [mosaic,tform_data] = atlas_row_registration_Slow(frames,percent_overlap,cornerSearch_pixelWidth)
total_frames = size(frames,1)
nth_frame = 1;
sizeFrame = size(frames{1})

%% Video Mosaicking
% Video mosaicking is the process of stitching video frames together to
% form a comprehensive view of the scene. The resulting mosaic image is a
% compact representation of the video data, which is often used in video
% compression and surveillance applications.

%   Copyright 2004-2010 The MathWorks, Inc.
%   $Revision: 1.1.6.7.2.1 $  $Date: 2011/07/14 20:48:51 $

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
total_start = tic;

memInitial = memory;
memInitial
%% Initialization
% Use these next sections of code to initialize the required System objects.
featWinLen   = 21;            % Length of feature window 
maxNumPoints = int32(600);    % Maximum number of points 
sizePano     = [sizeFrame(1)+ceil((total_frames)*(1-percent_overlap)*sizeFrame(1)) 1.5*sizeFrame(2)];
origPano     = [ceil(.5*sizeFrame(2)) ceil(.1*sizeFrame(1))];
classToUse   = 'single';

%%
% Create a VideoFileReader System object to read video from a file. 
% hsrc = vision.VideoFileReader('mosaic_sample_RGB_0003.avi', 'ImageColorSpace', ...
%     'RGB', 'PlayCount', 1);
% info(hsrc)
%%
% Create a ColorSpaceConverter System object to convert the RGB image to
% intensity format.
hcsc = vision.ColorSpaceConverter('Conversion', 'RGB to intensity');

%%
% Create a CornerDetector System object to identify the corner locations of
% current and the previous video frames. 
 hcornerdet = vision.CornerDetector( ...
    'Method', 'Local intensity comparison (Rosten & Drummond)', ...
    'IntensityThreshold', 0.0001, 'MaximumCornerCount', maxNumPoints, ...
    'CornerThreshold', 0.005, 'NeighborhoodSize', [11 11]);
                
%%
% Create an GeometricTransformEstimator System object to implement the
% RANSAC (RANdom SAmple Consensus) algorithm. This System object verifies
% that the corners have been properly identified. It also calculates the
% transformation matrix that maps the corner positions in the current frame
% to the corner positions in previous frame.
hestgeotform = vision.GeometricTransformEstimator;
    
%%
% Create a GeometricTransformer System object.
hgeotrans = vision.GeometricTransformer( ...
    'OutputImagePositionSource', 'Property', 'ROIInputPort', true, ...
    'OutputImagePosition', [-origPano sizePano]);

%%
% Create a AlphaBlender System object to overlay the consecutive video
% frames to produce the panorama.
halphablender = vision.AlphaBlender( ...
    'Operation', 'Binary mask', 'MaskSource', 'Input port');

%%
% Create a MarkerInserter System object to draw the corner locations in each
% video frame.
hdrawmarkers = vision.MarkerInserter('Shape', 'Circle', ...
    'BorderColor', 'Custom', 'CustomBorderColor', [250 0 0]);           
                        
%%
% Create two VideoPlayer System objects, one to display the corners of each
% frame and other to draw the panorama.

hVideo1 = vision.VideoPlayer('Name', 'Corners');
hVideo1.Position(1) = hVideo1.Position(1) - 350;    
hVideo1.Position(2) = hVideo1.Position(2) - 400; 
hVideo1.Position([3 4]) = [1200 1200];

hVideo2 = vision.VideoPlayer('Name', 'Mosaic');
hVideo2.Position(1) = hVideo2.Position(1) + 800;
hVideo2.Position([3 4]) = [1200 600];

% hVideo3 = vision.VideoPlayer('Name', 'Matched_Corners');
% hVideo3.Position(1) = hVideo3.Position(1) - 350;    
% hVideo3.Position(2) = hVideo3.Position(2) + 150; 
% hVideo3.Position([3 4]) = [800 800];

%% Stream Processing Loop
% Create a processing loop to create panorama from the input video. This
% loop uses the System objects you instantiated above.

points   = zeros([0 2], classToUse);
features = zeros([0 featWinLen^2], classToUse);

iter = 0;
current_frame = 1;
% last_tform = [1 0;0 1;0 0];
% mosaic = zeros([sizePano,3], classToUse);
% xtform = eye(3, classToUse);
% while ~isDone(hsrc)
while current_frame < total_frames
    % Save the points and features computed from the previous image
    pointsPrev   = points;
    featuresPrev = features;
    
    current_frame = (iter * nth_frame) + 1;
    if current_frame > total_frames
        break;
    end
    iter = iter + 1;
    
    % To speed up mosaicking, select and process every 5th image
%     for i = 1:10
%         rgb = step(hsrc);
%         if isDone(hsrc)
%             break;
%         end
%     end
    rgb = frames{current_frame};
    I = step(hcsc, rgb);
    roi = int32([2 2 size(I, 2)-2 size(I, 1)-2]);
%     roi = int32([250 200 size(I, 2)-200 size(I, 1)-200]);   % -200 from width/height______________
    roi
    % Detect corners in the image
    tic
    cornerPoints = step(hcornerdet, I);
%     cornerPoints = cast(cornerPoints, classToUse);  FAILED: required int.
    cornerDetect_time(iter) = toc;
    
    memCorners = memory;
    memCorners
    
    % Extract the features for the corners
    tic
    [features, points] = extractFeatures(I, ...
        cornerPoints, 'BlockSize', featWinLen);
    features = cast(features, classToUse);
    extractFeatures_time(iter) = toc;
    
    memFeatures = memory;
    memFeatures
    
    % Match features computed from the current and the previous images
    tic
    indexPairs = matchFeatures(features, featuresPrev);
    matchFeatures_time(iter) = toc;
    
    memMatch = memory;
    memMatch
    
    % Check if there are enough corresponding points in the current and the
    % previous images
    isMatching = false;
    if size(indexPairs, 1) > 2
        matchedPoints     = points(indexPairs(:, 1), :);
        matchedPointsPrev = pointsPrev(indexPairs(:, 2), :);
        
        % Find corresponding points in the current and the previous images,
        % and compute a geometric transformation from the corresponding
        % points
        tic
        [tform, inlier] = step(hestgeotform, matchedPoints, matchedPointsPrev);
        tform_detail{iter} = tform;
        tform_detail{iter}
        sum_inlier{iter} = sum(inlier)
        tform = [1 0;0 1;round(tform(3,1)) round(tform(3,2))];
        delta_x(iter) = tform(3,1);
        delta_x(iter)
        delta_y(iter) = tform(3,2);
        delta_y(iter)
        estTform_time(iter) = toc;
        
        memEstTform = memory;
        memEstTform
        
        if sum(inlier) >= 8
            % If there are at least 8 corresponding points, we declare the
            % current and the previous images matching
            isMatching = true;
        end
    end
    
    disp('isMatching_test')
    
    if isMatching
        % If the current image matches with the previous one, compute the
        % transformation for mapping the current image onto the mosaic
        % image
        xtform = xtform * [tform, [0 0 1]'];
        xtform
    else
        % If the current image does not match the previous one, reset the
        % transformation and the mosaic image
%         xtform = xtform * [last_tform, [0 0 1]'];
        xtform = eye(3, classToUse);
        mosaic = zeros([sizePano,3], classToUse);
        
        memBlack = memory;
        memBlack
    end
%     last_tform = tform;

    % Display the current image and the corner points
    cornerImage = step(hdrawmarkers, rgb, cornerPoints);
    
    mem.cornerImage = memory;
    mem.cornerImage
    
    step(hVideo1, cornerImage);
    
    % Warp the current image onto the mosaic image
    tic
    rgb = single(rgb)./255;     % FAILED: required single/double
    
    memRGBconversion = memory;
    memRGBconversion
    
    transformedImage = step(hgeotrans, rgb, xtform, roi);
    
    memTransform = memory;
    memTransform
    
    mosaic = step(halphablender, mosaic, transformedImage, ...
        transformedImage(:,:,1)>0);
    
    memBlend = memory;
    memBlend
    
    transform_time(iter) = toc;
    step(hVideo2, mosaic);
    
%    % Visualize corresponding points
%    if isMatching
%        h_Matched = cvexShowMatches(rgb, transformedImage, matchedPoints, matchedPointsPrev, ...
%            'First_Image', 'Second_Image');
%        step(hVideo3,h_Matched);
%    end
end

% release(hsrc);

Total_time = toc(total_start)
% cornerDetect_time
% extractFeatures_time
% matchFeatures_time
% estTform_time
% transform_time

tform_data = struct('delta_x',delta_x,'delta_y',delta_y,'tform_detail',tform_detail,'sum_inlier',sum_inlier);
%%
% The Corners window displays the input video along with the detected
% corners and Mosaic window displays the panorama created from the input
% video.
displayEndOfDemoMessage(mfilename)
