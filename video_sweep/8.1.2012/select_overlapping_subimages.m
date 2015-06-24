function [subimage1,subimage2,origTrans1,origTrans2] = select_overlapping_subimages(sizeImages,horiz_shift_fraction,vert_shift_fraction)

origTrans1 = [0,0];
origTrans2 = [0,0];

subimage1_orig = [1,1];
subimage2_orig = [1,1];

width = (1 - abs(horiz_shift_fraction))*sizeImages(2);
height = (1 - abs(vert_shift_fraction))*sizeImages(1);

if horiz_shift_fraction > 0
    origTrans1(2) = (sizeImages(2) - width);
    subimage1_orig(2) = subimage1_orig(2) + origTrans1(2);
elseif horiz_shift_fraction < 0
    origTrans2(2) = (width - sizeImages(2));
    subimage2_orig(2) = subimage2_orig(2) + (sizeImages(2) - width);
end

if vert_shift_fraction > 0
    origTrans1(1) = (sizeImages(1) - height);
    subimage1_orig(1) = subimage1_orig(1) + origTrans1(1);
elseif horiz_shift_fraction < 0
    origTrans2(1) = (height - sizeImages(1));
    subimage2_orig(1) = subimage2_orig(1) + (sizeImages(1) - height);
end

subimage1 = [subimage1_orig; subimage1_orig(1) + (height - 1), subimage1_orig(2) + (width - 1)];
subimage2 = [subimage2_orig; subimage2_orig(1) + (height - 1), subimage2_orig(2) + (width - 1)];

end