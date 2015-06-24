function atlas_test(row_Images)

percent_overlap = .2;
cornerSearch_pixelWidth = 10000;
xtform = eye(3, 'single');
atlas = row_Images{1};
for rowNum = 2:6
    [atlas, xtform,translation] = create_atlas(atlas,row_Images{rowNum},rowNum,xtform,percent_overlap,cornerSearch_pixelWidth);
    translate(rowNum) = translation;
end
% mosaic_fast = fast_row_sweep(frames,2,'right');
% 
% nth_frame = 1;
% [mosaic,tform_data] = video_sweep_calibration(frames,nth_frame);
imshow(atlas)

[filename,pathname] = uiputfile;
save_path = fullfile(pathname,filename);
save(save_path,'-v7.3','mosaic','atlas','translate');