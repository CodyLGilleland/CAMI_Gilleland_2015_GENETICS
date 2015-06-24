% Returns the spline of the worm devoid of branches
% Input - @c_elegans is a BW image of the worm
% Output - @end_x are the x-coord of the head and tail
%        - @end_y are the x-coord of the head and tail
%        - @x's are the x-coord of the skeleton of the worm
%        - @y's are the y-coord of the skeleton

function [end_y, end_x, x, y] = skeletonize_worm(c_elegans)
    

    % We erode away the border
    dilObj = strel('disk',3);
    c_elegans2 = imerode(c_elegans, dilObj);
    %hack to be patched up later
    if ~(size(find(c_elegans2)) < 20),
        c_elegans = c_elegans2;
    end
    
    
    % Skeletonize the worm
    skeleton = bwmorph(c_elegans, 'skel', 'Inf');
    % find the endpoints of hte worm
    endpoints = bwmorph(skeleton, 'endpoints');
    
    [end_x end_y] = find(endpoints);
    distances = ones(end_x, end_x);

    % Iterate through to find the distances between 
    % the end points of the worm
    for i = 1:length(end_x)
        for j = i:length(end_x)
            distances(i, j) = (end_x(i)-end_x(j))^2 + (end_y(i)-end_y(j))^2;
        end
    end

    % Find the head and tail of of the worm
    maxDist = max(max(distances));
    [max_row max_col] = find(distances == maxDist, 1);
    head_x = end_x(max_row); head_y = end_y(max_row);
    tail_x = end_x(max_col); tail_y = end_y(max_col);
       
    % iteratively, start pruning the branches
    while length(end_x) ~= 2
        for i=1:length(end_x),
            if (end_x(i) ~= head_x & end_y(i) ~= head_y) | ...
                    (end_x(i) ~= tail_x & end_y(i) ~= tail_y)
                skeleton(end_x(i), end_y(i)) = 0;
            end
        end
        
        % hack, i wonder why this is happening...
        if length(find(skeleton)) == 0,
            end_y = [1];
            end_x=[1];
            x = [];
            y = [];
            return
        end
        endpoints = bwmorph(skeleton, 'endpoints');    
        [end_x end_y] = find(endpoints);
    end
    
    [y x] = find(skeleton);
end