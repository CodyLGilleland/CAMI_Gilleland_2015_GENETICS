function [tform_data,reliability_data,timing_data,cornerImage] = estimate_translation(image1,image2,pyramid_layer,varargin)
frames = {image1,image2}; % quick fix...should correct later

total_frames = 2;
nth_frame = 1;
sizeFrame = size(image1);

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

%% Initialization
%____________________________________________
% Use these next sections of code to initialize parameters for later System object initialization.
featWinLen   = 15;            % Length of feature window 
maxNumPoints = int32(100);    % Maximum number of points 
IntensityThreshold = 0.2;
CornerThreshold = 0.001;
NeighborhoodSize = [11 11];

sizePano     = [ceil(2*sizeFrame(1)), ceil(1.25*sizeFrame(2))];
origPano     = [ceil(.1*sizeFrame(1)), ceil(.1*sizeFrame(2))];
classToUse   = 'single';

error_param = 2;

% The following parameters can be passed into this function using
% 'varargin'
for n = 1:nargin-3
    if isequal(varargin{n},'maxNumPoints')
        maxNumPoints = varargin{n+1};
    elseif isequal(varargin{n},'featWinLen')
        featWinLen = varargin{n+1};
    elseif isequal(varargin{n},'IntensityThreshold')
        IntensityThreshold = varargin{n+1};
    elseif isequal(varargin{n},'CornerThreshold')
        CornerThreshold = varargin{n+1};
    elseif isequal(varargin{n},'NeighborhoodSize')
        NeighborhoodSize = varargin{n+1};
    elseif isequal(varargin{n},'nth_frame')
        nth_frame = varargin{n+1};
    elseif isequal(varargin{n},'error_param')
        error_param = varargin{n+1};
    end
end

% Use these next sections of code to initialize the required System objects.

%%
% Create a ColorSpaceConverter System object to convert the RGB image to
% intensity format.
hcsc = vision.ColorSpaceConverter('Conversion', 'RGB to intensity');

%%
% Create a CornerDetector System object to identify the corner locations of
% current and the previous video frames. 
 hcornerdet = vision.CornerDetector( ...
    'Method', 'Local intensity comparison (Rosten & Drummond)', ...
    'IntensityThreshold', IntensityThreshold, 'MaximumCornerCount', maxNumPoints, ...
    'CornerThreshold', CornerThreshold, 'NeighborhoodSize', NeighborhoodSize);
                
%%
% Create an GeometricTransformEstimator System object to implement the
% RANSAC (RANdom SAmple Consensus) algorithm. This System object verifies
% that the corners have been properly identified. It also calculates the
% transformation matrix that maps the corner positions in the current frame
% to the corner positions in previous frame.
hestgeotform = vision.GeometricTransformEstimator;
    
%%
% Create a GeometricTransformer System object.
% hgeotrans = vision.GeometricTransformer( ...
%     'OutputImagePositionSource', 'Property', 'ROIInputPort', true, ...
%     'OutputImagePosition', [-origPano sizePano]);

%%
% Create a MarkerInserter System object to draw the corner locations in each
% video frame.
hdrawmarkers = vision.MarkerInserter('Shape', 'Circle', ...
    'BorderColor', 'Custom', 'CustomBorderColor', [255 0 0]);           
                        
%%
% Create two VideoPlayer System objects, one to display the corners of each
% frame and other to draw the panorama.

% hVideo1 = vision.VideoPlayer('Name', 'Corners');
% hVideo1.Position(1) = hVideo1.Position(1) - 400;    
% hVideo1.Position(2) = hVideo1.Position(2) - 400; 
% hVideo1.Position([3 4]) = [1200 200];

% hVideo2 = vision.VideoPlayer('Name', 'Mosaic');
% hVideo2.Position(1) = hVideo1.Position(1) + 1200;
% hVideo2.Position([3 4]) = [1200 600];

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
while current_frame <= total_frames
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
%     roi = int32([1 1 size(I, 2)-1 size(I, 1)-1]);

    % Detect corners in the image
    tic
    cornerPoints = step(hcornerdet, I);
%     cornerPoints = cast(cornerPoints, classToUse);  FAILED: required int.
    cornerDetect_time(iter) = toc;
    
    % Extract the features for the corners
%     tic
    [features, points] = extractFeatures(I, ...
        cornerPoints, 'BlockSize', featWinLen);
    features = cast(features, classToUse);
%     extractFeatures_time(iter) = toc;
    
    % Match features computed from the current and the previous images
    tic
    indexPairs = matchFeatures(features, featuresPrev);
    matchFeatures_time(iter) = toc;
    
    % Check if there are enough corresponding points in the current and the
    % previous images
    isMatching = false;
    % and initialize translation parameters and data output for later
    % recording
    tform_detail = {-1 -1;-1 -1;0 0};
    sum_inlier = 0;
    ratio_inliers = 0;
    delta_x = 0;
    delta_y = 0;
    error_metric = -10;
    reliability_score = ratio_inliers - double(error_metric);
%     isMatching
    if size(indexPairs, 1) > 2
        matchedPoints = points(indexPairs(:, 1), :);
        matchedPointsPrev = pointsPrev(indexPairs(:, 2), :);
        
        % Find corresponding points in the current and the previous images,
        % and compute a geometric transformation from the corresponding
        % points
%         tic
        [tform, inlier] = step(hestgeotform, matchedPoints, matchedPointsPrev);
        tform_detail{iter,1} = tform;
        sum_inlier = double(sum(inlier));
        ratio_inliers = sum_inlier/double(maxNumPoints);
        
%         tform = [1 0;0 1;round(tform(3,1)) round(tform(3,2))];
        delta_x = tform(3,1) * floor(2^(pyramid_layer - 1));
%         delta_x
        delta_y = tform(3,2) * floor(2^(pyramid_layer - 1));
%         delta_y
%         estTform_time(iter) = toc;
        
        error_metric = error_param * (abs(tform(1,1)-1) + abs(tform(2,2)-1) + abs(tform(1,2)) + abs(tform(2,1)));
        reliability_score = ratio_inliers - double(error_metric);
        
        if abs(delta_x) + abs(delta_y) < .2
            reliability_score = reliability_score - 1;
        end
%         sum_inlier
        ratio_inliers;
%         error_metric
        reliability_score;
%         tform_detail
        
        if sum(inlier) >= 8
            % If there are at least 8 corresponding points, we declare the
            % current and the previous images matching
            isMatching = true;
        end
    end
    

%======================================================
%======================================================
%     if isMatching
%         % If the current image matches with the previous one, compute the
%         % transformation for mapping the current image onto the mosaic
%         % image
%         xtform = xtform * [tform, [0 0 1]'];
%         xtform
%     else
%         % If the current image does not match the previous one, reset the
%         % transformation and the mosaic image
% %         xtform = xtform * [last_tform, [0 0 1]'];
%         xtform = eye(3, classToUse);
%         mosaic = zeros([sizePano,3], classToUse);
% 
%     end
%     last_tform = tform;
%=======================================================

% Nevermind below: just eliminate and perform outside function, but before
% creating the full mosaic.

% Need to insert verification function for translation estimate to avoid
% indexing errors when building the mosaic below.

%     tic
    is_Initialized = isMatching;
    if is_Initialized && upperLeft(1) + delta_y > 0 && upperLeft(2) + delta_x > 0
%         xtform = xtform * [tform, [0 0 1]'];
        upperLeft(1) = upperLeft(1) + round(delta_y);        % quick fix...should be changed!
        upperLeft(2) = upperLeft(2) + round(delta_x);
    else
%         xtform = eye(3, classToUse);
%         mosaic = zeros([sizePano,3], classToUse);
        mosaic = zeros([sizePano,3], 'uint8');
        upperLeft(1) = origPano(1);
        upperLeft(2) = origPano(2);
        is_Initialized = 1;
    end        
        
    % Warp the current image onto the mosaic image
%     rgb = single(rgb)./255;     % FAILED: required single/double
    lowerRight(1) = upperLeft(1) + sizeFrame(1) - 1;
    lowerRight(2) = upperLeft(2) + sizeFrame(2) - 1;
    
%     upperLeft(1) = single(upperLeft(1))
%     upperLeft(2) = single(upperLeft(2))
%     lowerRight(1) = single(lowerRight(1))
%     lowerRight(2) = single(lowerRight(2))
%     size(rgb)

%     upperLeft
%     lowerRight
%     size(rgb)
    mosaic(upperLeft(1):lowerRight(1),upperLeft(2):lowerRight(2),:) = rgb;
%     mosaic_time = toc;
%======================================================
%======================================================
    % Display the current image and the corner points
    tic
    cornerImage{iter} = step(hdrawmarkers, rgb, cornerPoints);
%     step(hVideo1, cornerImage);
%     figure, imshow(cornerImage{iter});
    cornerImage_time = toc;
    % Warp the current image onto the mosaic image
%     tic
% %     rgb = single(rgb)./255;     % FAILED: required single/double
%     rgb = single(rgb);
%     transformedImage = step(hgeotrans, rgb, xtform, roi);
%     mosaic = step(halphablender, mosaic, transformedImage, ...
%         transformedImage(:,:,1)>0);
%     transform_time(iter) = toc;
%     step(hVideo2, mosaic);
%===================================================    

end
Total_time = toc(total_start);
% mosaic = mosaic./255;

% figure, imshow(mosaic);
Total_time;
% cornerDetect_time
% matchFeatures_time

%==================================================
% Add these as output variables to save in a data array for future tuning:
% Total_time
% cornerDetect_time
% matchFeatures_time

% maxNumPoints
% sum_inlier    these two necessary for error checking
% error_metric
%==================================================
timing_data = struct('Total_time',Total_time,'cornerDetect_time',cornerDetect_time,'matchFeatures_time',matchFeatures_time,'pyramid_layer',pyramid_layer,'maxNumPoints',maxNumPoints,'featWinLen',featWinLen,'NeighborhoodSize',NeighborhoodSize);
tform_data = struct('delta_x',delta_x,'delta_y',delta_y,'tform_detail',tform_detail);
reliability_data = struct('reliability_score',reliability_score,'error_metric',error_metric,'sum_inlier',sum_inlier,'maxNumPoints',maxNumPoints,'ratio_inliers',ratio_inliers);


% figure, imshow(cornerImage{1});
% figure, imshow(cornerImage{2});
tform_data;
% tform_data.delta_x

%%
% The Corners window displays the input video along with the detected
% corners and Mosaic window displays the panorama created from the input
% video.
% displayEndOfDemoMessage(mfilename)