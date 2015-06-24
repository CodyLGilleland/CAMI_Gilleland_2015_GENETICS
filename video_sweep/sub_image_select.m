function [sub_image_1,sub_image_2,sub_orig_1,sub_orig_2] = sub_image_select(image_1,image_2,percent_overlap,direction)



smaller_mosaic{1} = mosaic{1}(150:1752,10000:16000,:);
figure, imshow(smaller_mosaic{1})

smaller_mosaic{2} = mosaic{2}(150:1752,10000:16000,:);
figure, imshow(smaller_mosaic{2})

smaller_mosaic{3} = mosaic{3}(150:1752,10000:16000,:);
figure, imshow(smaller_mosaic{3})

smaller_mosaic{4} = mosaic{4}(150:1752,10000:16000,:);
figure, imshow(smaller_mosaic{4})

[atlas,tform_data] = atlas_row_registration_Slow((smaller_mosaic(1:4))',.5);