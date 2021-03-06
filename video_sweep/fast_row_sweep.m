function mosaic = fast_row_sweep(frames,objective,direction)
start_time = tic;

classToUse = 'single';

sizeFrame = size(frames{1});
total_frames = size(frames,1);

    roi = int32([0 0 sizeFrame(2) sizeFrame(1)]);

if objective == 2
    nth_frame = 10;
    delta_x = 2238;
    delta_y = 5;
end

if strcmp(direction,'left')
    delta_x = delta_x * -1;
    delta_y = delta_y * -1;
end

tform = [1 0; 0 1; delta_x delta_y];
sizePano = [sizeFrame(1), sizeFrame(2) + delta_x * ceil(total_frames/nth_frame)];
origPano = [0 0];

if strcmp(direction,'left')
    origPano(2) = sizePano(2) - sizeFrame(2);
end


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
% Create VideoPlayer System object to draw the panorama.
hVideo1 = vision.VideoPlayer('Name', 'fast_Mosaic');
hVideo1.Position(1) = hVideo1.Position(1) - 350;
hVideo1.Position(2) = hVideo1.Position(2) - 100; 
hVideo1.Position([3 4]) = [2200 1600];

is_Initialized = 0;
iter = 1;
current_frame = 1;

while current_frame < total_frames - 45
    reg_start = tic;
    
    current_frame = (iter * nth_frame) + 1;
    if current_frame > total_frames
        break;
    end
    iter = iter + 1;

    rgb = frames{current_frame};
    
    if is_Initialized
        xtform = xtform * [tform, [0 0 1]'];
    else
        xtform = eye(3, classToUse);
        mosaic = zeros([sizePano,3], classToUse);
        is_Initialized = 1;
    end        
        
    % Warp the current image onto the mosaic image
    rgb = single(rgb)./255;     % FAILED: required single/double
    transformedImage = step(hgeotrans, rgb, xtform, roi);
    mosaic = step(halphablender, mosaic, transformedImage, ...
        transformedImage(:,:,1)>0);
    
    register(iter) = toc(reg_start)
    
    step(hVideo1, mosaic);
end

total_time = toc(start_time)

end