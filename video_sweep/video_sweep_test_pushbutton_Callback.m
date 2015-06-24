% --- Executes on button press in video_sweep_test.
function video_sweep_test_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to video_sweep_test_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stg
global AVT_Vid
% global ulcoord
% global stitched_image
% global src
global wellnumber
global NikonTiScope
% global img_off

stg.timeout =0.1;
fscanf(stg)
pause(1)
% Resets the exposure time, frame rate for montage building

tic
Objective2X_pushbutton_Callback(hObject, eventdata, handles);
disp('Please bring view into focus. Then press any key.');
Temp = waitforbuttonpress;

% img_off = 0;



%set(AVT_Vid, 'FrameRate', '30');
%fprintf(stg,'SMS,200'); %XY max speed, u sets to microns per second speed
%fscanf(stg);
fprintf(stg,'encoder,1');
fscanf(stg);
% Calibrated so our montage speed works out well
fprintf(stg,'SMS,195'); 
stagespeed195R = fscanf(stg)


% Initialize video
triggerconfig(AVT_Vid, 'manual');
AVT_Vid.ReturnedColorspace = 'rgb';
FPT = 280;
% add RGB to triggerconfig **********************************************
% change FPT to estimate FPT from distance to travel (below) ******
set(AVT_Vid, 'FramesPerTrigger', FPT);
AVT_Vid.ROIPosition = [0 0 1752 2236];

%well1_ulcoord = [110270 71746];
%well2_ulcoord = [110270 54280];
%well3_ulcoord = [110270 36404];
%well4_ulcoord = [110270 18292];

switch wellnumber
    case 1 
        currentY = 71746;       % change to support adaptive region selection*********
    case 2
        currentY = 54280;
    case 3
        currentY = 36404;
    case 4
        currentY = 18292;
    otherwise
    disp('This is not a valid well selection');    
end

vert_offset = 9000;
left_side = 35777;
right_side = 111050;

start_pos(1) = left_side;
start_pos(2) = currentY - vert_offset;
end_pos(1) = right_side;
end_pos(2) = start_pos(2);

row_image_data = video_sweep(AVT_Vid,start_pos,end_pos);

nth_frame = 8;
[mosaic,tform_data] = video_sweep_calibration(row_image_data.frames,nth_frame);

[filename,pathname] = uiputfile;
save_path = fullfile(pathname,filename);
save(save_path,'-v7.3',mosaic,tform_data,row_image_data,nth_frame);

AVT_Vid.ReturnedColorspace = 'grayscale';

end
