function data_out = vs_data_vis(tform_data,timing_data,low_score,high_score)

tform_len = size(tform_data,2) - 1;
timing_len = size(timing_data.time,1);

for i = 1:tform_len
detail{i} = tform_data(i+1).tform_detail;
end
detail = detail';

timing = timing_data.time;
timing_dif = diff(timing);

for i = 1:tform_len
score(i) = abs(tform_data(i+1).tform_detail(1,1)) + abs(tform_data(i+1).tform_detail(2,1)) + abs(tform_data(i+1).tform_detail(1,2)) + abs(tform_data(i+1).tform_detail(2,2));
end
score = score';

for i = 1:tform_len
    if score(i,1)>low_score && score(i,1)<high_score
        clean.timing(i,1) = timing_dif(i,1);% + timing_dif(4*i-1,1) + timing_dif(4*i-2,1) + timing_dif(4*i-3,1); % 3rd frame
        clean.score(i,1) = score(i,1);
        clean.detail{i,1} = detail{i,1};
        clean.delta_x(i,1) = detail{i,1}(3,1);
        clean.delta_y(i,1) = detail{i,1}(3,2);
    else
        clean.timing(i,1) = [0];
        clean.score(i,1) = [0];
        clean.detail{i,1} = [0];
        clean.delta_x(i,1) = [0];
        clean.delta_y(i,1) = [0];
    end
end

iter = 1;
for i = ceil(10):floor(174)  % 4th frame   ceil(10/4):floor(174/4)
    if clean.timing(i,1)>0 && clean.delta_x(i,1)>100
        reduced.timing(iter,1) = clean.timing(i,1);
        reduced.score(iter,1) = clean.score(i,1);
        reduced.detail{iter,1} = clean.detail{i,1};
        reduced.delta_x(iter,1) = clean.delta_x(i,1);
        reduced.delta_y(iter,1) = clean.delta_y(i,1);
        iter = iter + 1;
    end
end

raw = struct('detail',detail,'timing_dif',timing_dif,'score',score);
data_out = struct('raw',raw,'clean',clean,'reduced',reduced);

figure, plot(tform_data(1).delta_x)
figure, plot(score)
figure, scatter(reduced.timing,reduced.delta_x)

end