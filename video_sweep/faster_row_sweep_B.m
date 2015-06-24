function mosaic = faster_row_sweep_B(frames,objective,direction,rowNum,img_correction)

start_time = tic;


% classToUse = 'single';
classToUse = 'uint8';

sizeFrame = size(frames{1});
total_frames = size(frames,1);


if objective == 2
    nth_frame = 10;
    delta_x = 2172;
    delta_y = 0;
end


% tform = [1 0; 0 1; delta_x delta_y];
sizePano = [sizeFrame(1), (sizeFrame(2) + delta_x * 16)+1];
origPano = [1 1];

if strcmp(direction,'left')
%     origPano(1) = 150;
    origPano(2) = sizePano(2) - sizeFrame(2);
    
    delta_x = delta_x * -1;
    delta_y = delta_y * -1;
end

% if strcmp(direction,'left')
%     delta_x = delta_x * -1;
%     delta_y = delta_y * -1;
% end

%%
% Create VideoPlayer System object to draw the panorama.
% hVideo1 = vision.VideoPlayer('Name', 'faster_Mosaic');
% hVideo1.Position(1) = hVideo1.Position(1) - 350;
% hVideo1.Position(2) = hVideo1.Position(2) - 600; 
% hVideo1.Position([3 4]) = [2200 1600];

is_Initialized = 0;
iter = 1;
current_frame = 1;

while current_frame < total_frames - 55
    reg_start = tic;
    
    current_frame = (iter * nth_frame) + 1;
    if current_frame > total_frames
        break;
    end
    iter = iter + 1;

    rgb = frames{current_frame};

    
    rgb = uint8(double(rgb) + img_correction);

%     figure, imshow(rgb);
    

    if is_Initialized
%         xtform = xtform * [tform, [0 0 1]'];
        upperLeft(1) = upperLeft(1) + delta_y;
        upperLeft(2) = upperLeft(2) + delta_x;
    else
%         xtform = eye(3, classToUse);
        mosaic = zeros([sizePano,3], classToUse);
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
    
    register(iter) = toc(reg_start);
%     register(iter)
    
%     step(hVideo1, mosaic);
end

total_time = toc(start_time)
% class(mosaic);
% figure,imshow(mosaic,'InitialMagnification',100);
if rowNum <= 2
    mosaic_check = imresize(mosaic, .02);
    figure, imshow(mosaic_check);
end

end