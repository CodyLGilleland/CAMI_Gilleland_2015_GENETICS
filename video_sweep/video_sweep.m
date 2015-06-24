function [frames,timing_data] = video_sweep(stg,vid_obj,FPT,start_pos,end_pos,pause_time)


% Should probably query current position and determine length of pause
% based on expected move time:
fprintf(stg,[ 'G,' num2str(start_pos(1)) ', ' num2str(start_pos(2)) ',0']);
pause(pause_time); % *************************************

if ~isrunning(vid_obj)
    start(vid_obj);
else
    stop(vid_obj);
    pause(.1);
    start(vid_obj);
end
preview(vid_obj);
trigger(vid_obj);
fprintf(stg,[ 'G,' num2str(end_pos(1)) ', ' num2str(end_pos(2)) ',0']);

pause(5);
[frames time meta] = getdata(vid_obj,FPT,'uint8','cell');

timing_data = struct('time',time,'meta',meta);

stoppreview(vid_obj);
stop(vid_obj);

end