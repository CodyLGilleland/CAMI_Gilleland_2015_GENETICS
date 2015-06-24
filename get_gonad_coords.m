% images in the form of cell array, later region props
function coords = get_gonad_coords(montage, scale, ulcoord, conversion)
    
    coords = [];

    disp_ptr = [];
    
    screen_size = get(0, 'ScreenSize');
    
    upper_x = ulcoord(1);
    
    upper_y = ulcoord(2);
    
    montage2 = imresize(montage, scale);
    blur_kern = fspecial('gaussian', [20*(scale/.02) 20*(scale/.02)]);
    % Parameters may need to be changed
    montage2_bw = bwareaopen(imclearborder(imfilter(montage2, blur_kern) < 200), 30*(scale/.02));
    
    worms = regionprops(montage2_bw, montage2, {'Area', 'BoundingBox', 'Centroid', 'MeanIntensity'});
    
    
    
    for i=1:length(worms)
        
        
        rect = rectangle('Position', worms(i).BoundingBox, ...
                      'EdgeColor','g', 'LineWidth', 1, 'Visible', 'off'); 
        rect = get(rect, 'Position')*1/scale;
        
        gray_img = imcrop(montage, rect);
        img = cat(3, gray_img, gray_img, gray_img);
        
        if isempty(disp_ptr)
            disp_ptr =  figure, imshow(img);
        else
            close(disp_ptr);
            disp_ptr = [];
            disp_ptr = figure,imshow(img);
        end
        
        title([num2str(i) ' out of ' num2str(length(worms))]);
        
        k = waitforbuttonpress
        
        if k == 1
            break
        end
        
        if strcmp(get(gcf, 'SelectionType'), 'normal')
            current_click = get(gca, 'CurrentPoint');
            
            % Convert centroid location into gonads
            cent_x = worms(i).Centroid(1)*1/scale;
            cent_y = worms(i).Centroid(2)*1/scale;
            
            cent_stag_x = upper_x + (600-cent_x)/1200*conversion
            cent_stag_y = upper_y + (600-cent_y)/1200*conversion
            
            [w l] = size(gray_img)
            
            img_centerx = l/2;
            img_centery = w/2;
            clickx  =  current_click(1, 1)
            clicky = current_click(1, 2)
            
            coords = [coords cent_stag_x cent_stag_y];
            %coords = [coords cent_stag_x-(img_centerx-clickx)/1200*conversion ...
            %    cent_stag_y+(img_centery-clicky)/1200*conversion];
        end
        
    end
    
    close
    

end