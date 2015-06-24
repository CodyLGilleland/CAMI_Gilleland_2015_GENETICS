function translations = calc_translations(image_rows,horiz_shift_fraction,vert_shift_fraction)

%%
% translations: [num_rows,3] cell array. Columns 1 and 2 contain the origin
% translation for the overlapping portions relative to the respective row_image
% containing it; column 3 contains the translation necessary to register
% the two overlapping portions.

% estimates: [1,num_rows] cell array. Each cell contains a
% [num_estimates,3] matrix. num_estimates is the number of registrations
% attempted before satisfying the verification conditions. Column 1 is the
% reliability metric and columns 2 and 3 are the vertical and horizontal
% translation estimates, respectively.

% est_translation: [row,max_num_layers,num_regions,4] cell array.
%             est_translation{row,pyramid_layer,region,1} = tform_data;
%             est_translation{row,pyramid_layer,region,2} = reliability_data;
%             est_translation{row,pyramid_layer,region,3} = timing_data;
%             est_translation{row,pyramid_layer,region,4} = cornerImage;


num_rows = size(image_rows,1);
num_layers = 1; % this value is variable depending on the size of the row_image
total_regions = 5;
sizeImages = size(image_rows{1});

translations = cell(num_rows,3);
estimates(1:num_rows) = {[]};
est_translation = cell(num_rows,num_layers,1,4);
verification = cell(num_rows,2);

for row = 2:num_rows
    disp('====================================================')
    row
    row
    row
%     row
%     row
%     row
%     row
%     row
    disp('====================================================')

    [sub_image1_coords,sub_image2_coords,origTrans1,origTrans2] = select_overlapping_subimages(sizeImages,horiz_shift_fraction,vert_shift_fraction);
    translations{row,1} = origTrans1;
    translations{row,2} = origTrans2;
    
    image1_overlap = image_rows{row-1}(sub_image1_coords(1,1):sub_image1_coords(2,1),sub_image1_coords(1,2):sub_image1_coords(2,2),:);
    image2_overlap = image_rows{row}(sub_image2_coords(1,1):sub_image2_coords(2,1),sub_image2_coords(1,2):sub_image2_coords(2,2),:);
    
    pyr_start = tic;
    image_pyramid = create_image_pyramid(image1_overlap,image2_overlap);
    pyramid_time = toc(pyr_start);
    
    max_num_layers = num_layers;
    num_layers = size(image_pyramid,1);
    if num_layers > max_num_layers
        max_num_layers = num_layers;
    end
%====================     
    est_translation(num_rows,max_num_layers,total_regions,4) = {[]};
    isVerified = 0;
    num_estimates = 0;
    
    for pyramid_layer = num_layers:-1:1
        
        % For each layer in the image pyramid, select subregions to produce
        % multiple translation estimates before proceeding to a higher
        % resolution layer in the pyramid. This allows for translation
        % verification without sacrificing the speed improvements gained
        % from using the image pyramid. Below, I use the full row images
        % followed by the full row split into nonoverlapping quarters.
        
        registration_image = cell(total_regions,2);
        
        Left = 1;
        Right = size(image_pyramid{pyramid_layer,1},2);
        Top = 1;
        Bottom = size(image_pyramid{pyramid_layer,1},1);
        Vert_Middle = floor(size(image_pyramid{pyramid_layer,1},1)/2);
        Horiz_Middle = floor(size(image_pyramid{pyramid_layer,1},2)/2);
        
        lowRes_overlap1 = image_pyramid{pyramid_layer,1};
        lowRes_overlap2 = image_pyramid{pyramid_layer,2};
        
        registration_image{1,1} = lowRes_overlap1;
        registration_image{1,2} = lowRes_overlap2;
        registration_image{2,1} = lowRes_overlap1(Top:Vert_Middle,Left:Horiz_Middle,1:3);
        registration_image{2,2} = lowRes_overlap1(Top:Vert_Middle,Left:Horiz_Middle,1:3);
        registration_image{3,1} = lowRes_overlap1(Top:Vert_Middle,Horiz_Middle+1:Right,1:3);
        registration_image{3,2} = lowRes_overlap2(Top:Vert_Middle,Horiz_Middle+1:Right,1:3);
        registration_image{4,1} = lowRes_overlap1(Vert_Middle+1:Bottom,Left:Horiz_Middle,1:3);
        registration_image{4,2} = lowRes_overlap2(Vert_Middle+1:Bottom,Left:Horiz_Middle,1:3);
        registration_image{5,1} = lowRes_overlap1(Vert_Middle+1:Bottom,Horiz_Middle+1:Right,1:3);
        registration_image{5,2} = lowRes_overlap2(Vert_Middle+1:Bottom,Horiz_Middle+1:Right,1:3);
        

        for region = 1:total_regions
            % depending on image sizes, may want to add further subimage
            % selection function with or without additional loop
            est_trans_start = tic;

%             figure,imshow(registration_image{row,1});
%             figure,imshow(registration_image{row,2});

%             [tform_data,reliability_data,timing_data,cornerImage] = estimate_translation(image_pyramid{pyramid_layer,1}(region_coords{region,1}),image_pyramid{pyramid_layer,2}(region_coords{region,1}),pyramid_layer);
            [tform_data,reliability_data,timing_data,cornerImage] = estimate_translation(registration_image{region,1},registration_image{region,2},pyramid_layer);
            num_estimates = num_estimates + 1;
            
%             reliability_data.reliability_score
%             tform_data.delta_x
%             tform_data.delta_y
            estimates{row}(num_estimates,1) = reliability_data.reliability_score;
            estimates{row}(num_estimates,2) = tform_data.delta_y;
            estimates{row}(num_estimates,3) = tform_data.delta_x;
            
            estimate_translation_time = toc(est_trans_start);

            est_translation{row,pyramid_layer,region,1} = tform_data;
            est_translation{row,pyramid_layer,region,2} = reliability_data;
            est_translation{row,pyramid_layer,region,3} = timing_data;
            est_translation{row,pyramid_layer,region,4} = cornerImage;
    %====================        
            if pyramid_layer < num_layers
                % Should add parameter for maxNumPixel_range 
                maxPixels_off = 6;
                [current_trans_est,num_matches,isVerified] = verify_est_translation(estimates,row,pyramid_layer,num_layers,num_estimates,maxPixels_off);
                if isVerified
                    translations{row,3} = current_trans_est;
%                     filename = uiputfile;
%                     save(filename,'est_translation','translations','estimates','current_trans_est','num_matches','isVerified');
                    break
                end
            end
            if pyramid_layer == 1
                translations{row,3} = current_trans_est; % verify_est_translation should return best estimate
                disp(['Estimated translation for row ', row, ' is uncertain.']) % Should also disp certainty stats
            end
        end
        if isVerified
            break
        end
    %====================     
    end
    verification{row} = [isVerified num_matches];
end
%%=======Data Save for Translation Estimate Procedure=========%%
% filename = uiputfile;
% save(filename,'est_translation','translations','estimates','verification');
%%===================================================%%
end
    