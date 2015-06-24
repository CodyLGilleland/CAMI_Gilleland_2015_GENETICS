function [gonad_x, gonad_y, ord_skel] = traverse_skel(skel, endpts, frac)


    [skel_y skel_x] = find(skel);
%      figure,imshow(skel)
     [rows cols] = find(endpts);
%     hold on
%     plot(cols, rows, 'ro');
%     hold off
    
    current_row = rows(1);
    current_col = cols(1);
    
    nxtPt = 0;
    updown = 0;
    ord_skel = [];
%     size(skel)
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
        
%         for dc = -1:1:1
%             for dr = -1:1:1
%                 % add checks later
%                 if skel(current_row+dr, current_col+dc) == 1 
%                     current_row = current_row + dr;
%                     current_col = current_col + dc;
%                     nxtPt = 1;
%                     break;
%                     
%                 end
%             end
%             
%             if nxtPt == 1
%                 nxtPt = 0;
%                 break;
%             end
%         end
        
    end
    
gonad_x = [ord_skel(round(length(ord_skel)*frac), 2) ord_skel(round(length(ord_skel)*(1-frac)), 2)];
gonad_y = [ord_skel(round(length(ord_skel)*frac), 1) ord_skel(round(length(ord_skel)*(1-frac)), 1)];
    
    