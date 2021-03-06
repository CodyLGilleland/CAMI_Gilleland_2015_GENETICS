function [gonadx, gonady] = find_gonads(c_elegans, display)
%This function inputs a worm image and returns gonad locations


    % Contrast threshold for c_elegans
    thresh = 240;
    % Branch size
    branch_thres = 50;
    
    
    % Get only the outline of the worm
    BW_outline = c_elegans < thresh;
    BW_outline = imfill(BW_outline, 'holes');
    regions = regionprops(BW_outline, {'FilledArea'});
    maxArea = max([regions.FilledArea]);
    BW_outline = bwareaopen(BW_outline, maxArea-1);

    % Get the skeleton of the worm
    skel = bwmorph(BW_outline, 'skel', 'Inf');
    [skel_y skel_x] = find(skel);
    
     figure,imshow(skel)
    
    % Get rid of all the branches
    endpts = bwmorph(skel, 'endpoints');
    while sum(sum(endpts)) ~= 2
        skel = skel - endpts;
        endpts = bwmorph(skel, 'endpoints');
    end
    
%     figure,imshow(skel)
     [rows cols] = find(endpts)
%     hold on
%     plot(cols, rows, 'ro');
%     hold off
    
    current_row = rows(1);
    current_col = cols(1);
    
    nxtPt = 0;
    updown = 0;
    ord_skel = [];
    size(skel)
    % Traverse the skeleton 
    while ~(current_row == rows(2) && current_col == cols(2))
        ord_skel = [ord_skel; current_row, current_col];
        skel(current_row, current_col) = 0;
        
        updown = 0;
        
        % Try up, down, left, right first
        for dc=-1:1:1
            
            if dc==0
                
                for dr=-1:2:1
                    if skel(current_row+dr, current_col+dc) == 1 
                        current_row = current_row + dr;
                        current_col = current_col + dc;
                        nxtPt = 1;
                        break;
                    
                    end

                end
                
            else
                
                if skel(current_row, current_col+dc) == 1 
                    current_row = current_row;
                    current_col = current_col + dc;
                    nxtPt = 1;
                    break;
                end

                
            end
            
            if nxtPt == 1
                nxtPt = 0;
                updown = 1;
                break;
            end

            
        end
        
        % Try diagonals
        if ~updown
            
            for dc = [-1 1]
                for dr = [-1 1]
                    % add checks later
                    if skel(current_row+dr, current_col+dc) == 1 
                        current_row = current_row + dr;
                        current_col = current_col + dc;
                        nxtPt = 1;
                        break;

                    end
                end

                if nxtPt == 1
                    nxtPt = 0;
                    break;
                end
            end

        end
        
        
    end
    %output the gonad X,Y coordinates
    %here we are selecting 1/4 and 3/4 lengths along the spline for gonad
    %region of interest
    gonadx = [ord_skel(round(length(ord_skel)/4), 2) ord_skel(round(3*length(ord_skel)/4), 2)];
    gonady = [ord_skel(round(length(ord_skel)/4), 1) ord_skel(round(3*length(ord_skel)/4), 1)];
    
    %if display is ON then output the images to the screen
    if display
    figure, imshow(c_elegans)
    sum(sum(skel))
    size(ord_skel)
    hold on
    plot(ord_skel(:, 2), ord_skel(:,1), 'r')
    plot(ord_skel(round(length(ord_skel)/4), 2),ord_skel(round(length(ord_skel)/4), 1), 'yo')
    plot(ord_skel(round(3*length(ord_skel)/4), 2),ord_skel(round(3*length(ord_skel)/4), 1), 'yo') 
    hold off
    end
    
end