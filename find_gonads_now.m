function [gonad_x, gonad_y, success, thresh_rec] = find_gonads_now(c_elegans_img, display,skelFig)
    
    frac = .25; % fraction from ends of spline: used to identify gonad locations
    
    % Thresholds for creating the spline
    pixel_thresh = 130;
    prune_iters = 70;
    pixel_reduce = .8;
    get_skel_limit = 10;
    % package thresholds
    thresholds = [pixel_thresh, prune_iters, pixel_reduce, get_skel_limit];
    
    % Get the skeleton of the worm
    [skel, success, thresh_rec] = get_skel(c_elegans_img, thresholds, 1);
    if ~success
        offset = 20;
        center_y = size(c_elegans_img,1);
        center_x = size(c_elegans_img,2);
        gonad_x = [center_x, center_x + offset];
        gonad_y = [center_y, center_y + offset];
    else
%     skel = skel_Adam; %=============================================
    endpts = bwmorph(skel, 'endpoints');
    [gonad_x, gonad_y, ord_skel] = traverse_skel(skel, endpts, frac);
    %===========================================================
    end
    

% Display the results
    if display
        figure(skelFig);
        imshow(c_elegans_img);
        sumSkel = sum(sum(skel));
        sizeOrd_Skel = size(ord_skel);
        hold on
        plot(ord_skel(:, 2), ord_skel(:,1), 'r');
        plot(gonad_x(1), gonad_y(1), 'yo');
        plot(gonad_x(2), gonad_y(2), 'yo');
        hold off
    end
    
end