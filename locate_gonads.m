% Returns location of viable gonads, sorted to minimize distance traveled
% Input - @montage is the montage of the plate 
%       - @params is an array of the top left corner of the montage, 
%         pixel-coordinate conversion, and current stage location
% Returns - @gonads include the coordinates of the gonad location

function gonads = locate_gonads(montage, ulcoord_x, ulcoord_y, pix2stage, scale, current_x, current_y)
    
    % Nested function to find the gonad of a worm based on an isolated
    % image
    %[ulcoord_x ulcoord_y pix2stage scale current_x current_y] = [params];
    
    function [gonad_x, gonad_y] = find_gonad(worm, x, y)
        
        thresh = 180;
        
        [height width] = size(worm);
        for a=1:height
            for b=1:width
                if worm(a,b) < thresh,
                    worm(a, b) = 0;
                end
            end
        end
        
        % Finding the gonad now
        worm2 = worm > 0;
        gonad_radius = 100;
        regions = regionprops(worm2, {'FilledArea', 'Centroid'});
        
        gonad_x = [];
        gonad_y = [];
        for j=1:2
            area = [];
            
            for c=1:length(regions),
                if ((regions(c).Centroid(1)-x(j))^2 + (regions(c).Centroid(2)-y(j))^2)^(.5) <= gonad_radius
                    area = [area; regions(c).FilledArea c];
                end
            end
            
            if length(regions) == 0 | length(area) == 0,
                continue;
            end
            
            area2 = (area(:, 1));
            max_indx = find(area2 == max(area2));
            max_indx = max_indx(1);
            region_indx = area(max_indx, :);
            region_indx = region_indx(2);
            gonad_x = [gonad_x; regions(region_indx).Centroid(1)];
            gonad_y = [gonad_y; regions(region_indx).Centroid(2)];
            
            
        end
    end

    % We need to rank by distance to travel 
    function opt_path = sort_gonads(gonads)
        %dist = [];
        unvisited_gonads = gonads;
        path = [];
        
        currentloc = [current_x current_y];   
        loop_length = length(unvisited_gonads(:, 1));
        for j = 1:loop_length
            dist = [];
            for k = 1:length(unvisited_gonads(:, 1))
                dist = [dist; sum((currentloc-unvisited_gonads(k, :)).^2)];
            end
            maxIndex = find(dist == min(dist));
            maxIndex = maxIndex(1);
            path = [path; unvisited_gonads(maxIndex, :)];
            currentloc = unvisited_gonads(maxIndex, :);
            unvisited_gonads(maxIndex, :) = [];
        end
        
        opt_path = path;
    end
    
    
    % Detecting worm locations
    montage2 = montage < 225;

    figure,imshow(montage2)
    
%     % Parameters for probability distribution
%     mu = 8000;
%     sigma = 1000;
%     cutoff = 4;
% 
%     % Parameters for mean intensity
%     mu2 = 150;
%     sigma2 = 10;
%     cutoff2 = 2;

    montage2 = bwareaopen(montage2, 3000);
    
    figure,imshow(montage2)

    objects = regionprops(montage2, montage, {'Area', 'BoundingBox', 'Centroid', 'MeanIntensity'});
    global_loc = [];
    figure, imshow(montage)
    hold on
    for i=1:length(objects)
        %if abs(mu - objects(i).Area) <= cutoff*sigma & ...
        %    abs(mu2 - objects(i).MeanIntensity) <= cutoff2*sigma2,
            rect = rectangle('Position', objects(i).BoundingBox, ...
                          'EdgeColor','g', 'LineWidth', 1, 'Visible', 'off'); 
            rect = get(rect, 'Position');
            plot(objects(i).Centroid(1), objects(i).Centroid(2), 'r*');
            worm = imcrop(montage, rect);  
            [worm_cut xcoord ycoord] = truncate_head_and_tail(worm);
            if ~isempty(worm_cut)
                [x1 y1] = find_gonad(worm_cut, xcoord, ycoord);
                % Get pixel coordinates
                global_loc = [global_loc; x1+rect(1) y1+rect(2)];
            end
        %end
    end
    hold off

    % Convert the image coord to stage coords
    gonads = round((600-global_loc./scale)./1200*pix2stage); 
    for i=1:length(gonads(:, 1))
        gonads(i, :) = [ulcoord_x ulcoord_y] + gonads(i, :);
    end
    
    gonads = sort_gonads(gonads);
    
    formatted_loc = [];
    for i=1:length(gonads(:, 1))
        formatted_loc = [formatted_loc gonads(i, :)];
    end
    
    global_loc = sort_gonads(global_loc);
    figure, imshow(montage)
    hold on
    for z = 1:length(global_loc(:, 1))-1
        line([global_loc(z, 1), global_loc(z+1, 1)], [global_loc(z,2), global_loc(z+1, 2)]);
    end
    hold off
    
    %gonads = formatted_loc;
    disp('Gonads Located!!');
end