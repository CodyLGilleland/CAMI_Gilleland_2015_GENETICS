function [skel,success,thresh_rec] = get_skel(img, thresholds, count)

hard_max_iters = 500;

    % Thresholds for creating the spline
    pixel_thresh = thresholds(1);
    prune_iters = thresholds(2);
    pixel_reduce = thresholds(3);
    get_skel_limit = thresholds(4);
    
    if 1<count<=get_skel_limit
        pixel_thresh = pixel_thresh * pixel_reduce;
    elseif count >= get_skel_limit
        prune_iters = hard_max_iters+1; 
        pixel_thresh = pixel_thresh * pixel_reduce;
    end
    % package thresholds
    thresholds = [pixel_thresh, prune_iters, pixel_reduce, get_skel_limit];

%% Adjust the contrast
% figure, imshow(img);
    img_adj = imadjust(img);
%     figure, imshow(img_adj);

%% Get the silouhette of the worm
    BW = img_adj < pixel_thresh;
    BW = imfill(BW, 'holes');
    BW_size = size(BW);
%     figure, imshow(BW)
    regions = regionprops(BW, {'FilledArea','Centroid','Perimeter','MajorAxisLength','MinorAxisLength','Image','BoundingBox'});
    maxArea = max([regions.FilledArea]);
    objects_areas = [regions.FilledArea];
    objects_centroids = {regions.Centroid};
    objects_boundingBox = {regions.BoundingBox};
    objects_perimeter = [regions.Perimeter];
    objects_majorAxis = [regions.MajorAxisLength];
    objects_minorAxis = [regions.MinorAxisLength];
    objects_image = {regions.Image};
    
    area_min = 1000;
    area_max = 20000;
    majorAxis_min = 100;
    majorAxis_max = 1000;
    minorAxis_min = 1;
    minorAxis_max = 200;
    perimeter_min = 100;
    perimeter_max = 5000;
    %centroid_min = 
    %centroid_max = 
    %centroid_delta = 100;
    center_coord = floor(BW_size/2)
    
    filtered_by_area = find(objects_areas > area_min & objects_areas < area_max);
    filtered_by_perimeter = find(objects_perimeter > perimeter_min & objects_perimeter < perimeter_max);
    filtered_by_majorAxis = find(objects_majorAxis > majorAxis_min & objects_majorAxis < majorAxis_max);
    filtered_by_minorAxis = find(objects_minorAxis > minorAxis_min & objects_minorAxis < minorAxis_max);
    
    filtered_obj_idx = intersect(intersect(filtered_by_area,filtered_by_perimeter),intersect(filtered_by_majorAxis,filtered_by_minorAxis));
    filtered_obj_centroids = cell(1,length(filtered_obj_idx));
    for i=1:length(filtered_obj_idx)
        filtered_obj_centroids{i} = {filtered_obj_idx(i),objects_centroids{filtered_obj_idx(i)}};
    end
    %filtered_obj_centroids = cellfun(@(obj,idx) obj(idx), objects_centroids, num2cell(filtered_obj_idx));
    pause(1);
    
    filtered_radii = cellfun(@(x) {sqrt( abs(x{2}(1) - center_coord(2))^2 + abs(x{2}(2) - center_coord(1)^2) )},filtered_obj_centroids); 
    [radii_val,radii_idx] = min(cell2mat(filtered_radii));
    obj_selected_idx = filtered_obj_centroids{radii_idx}{1};
    obj_selected_centroid = objects_centroids{obj_selected_idx};
    
    selected_worm = regions(obj_selected_idx)
    %selected_worm.Centroi
    
    img_mask = zeros(cast(size(BW),'int64'));
    bb = cast(objects_boundingBox{cast(obj_selected_idx,'int64')},'int64');
    img_mask(bb(2):bb(2)+bb(4),bb(1):bb(1)+bb(3)) = 1;
    
    BW = BW .* img_mask;
%    BW = bwareaopen(BW, maxArea-1);
%     figure, imshow(BW);

%% Perform morphological operations to produce spline
BW1 = bwmorph(BW,'majority');
% figure, imshow(BW1)

BW2 = bwmorph(BW1,'dilate',30);
% figure, imshow(BW2)

BW3 = bwmorph(BW2,'thin','Inf');
% figure, imshow(BW3)

BW4 = bwmorph(BW3,'skel','Inf');
% figure, imshow(BW4)

BW5 = imfill(BW4,'holes');
% figure, imshow(BW5)

BW6 = bwmorph(BW5,'thin','Inf');
% figure, imshow(BW6)

BW7 = bwmorph(BW6,'skel','Inf');
% figure, imshow(BW7)

skel = BW7;


% figure, imshow(skel)

% fig_skel = figure;
% imshow(skel)

%% Remove any remaining branches
iter = 1;
success = 0;
endpts = bwmorph(skel, 'endpoints');
num_endpts = sum(sum(endpts));
while sum(sum(endpts)) > 2
    skel = skel - endpts;
    endpts = bwmorph(skel, 'endpoints');
%     figure(fig_skel);
%     imshow(skel);
%     pause(.05)
    num_endpts = sum(sum(endpts));
   
    % If pruning continues too long, recursively call get_skel (with
    % adaptive contrast threshold to, hopefully, eliminate obstruction)
    if iter >= hard_max_iters
        success = 0;
        thresh_rec(count,:) = [iter, success];
        return
    elseif iter >= prune_iters
        thresh_rec(count,:) = [iter, success];
        count = count+1;
        [skel,success,thresh_rec] = get_skel(img, thresholds, count);
        if success % if recursion successful, exit all recursions
            return
        elseif size(thresh_rec,1)>=get_skel_limit
            return % if recursion not successful at recursion limit, exit all recursions
        end
    end
    iter = iter+1;
end
success = 1;
thresh_rec(count,:) = [iter, success];

% close(fig_skel);

    
    