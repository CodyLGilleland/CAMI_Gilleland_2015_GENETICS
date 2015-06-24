function [best_estimate,best_matches,isVerified] = verify_est_translation(estimates,row,pyramid_layer,num_layers,num_estimates,maxPixels_off);

required_matches = 3;
isVerified = 0;
best_estimate = [];
best_matches = 0;

[ordered_reliability_scores,reliability_index] = sort(estimates{row}(:,1),1,'descend');
% ordered_reliability_scores
format('longE')
ordered_estimates = [estimates{row}(reliability_index,:)];


for i = 1:num_estimates
    num_matches = 0;
    for j = 1:num_estimates
        if ~isequal(i,j)
            if abs(ordered_estimates(i,2) - ordered_estimates(j,2)) <= maxPixels_off  && abs(ordered_estimates(i,3) - ordered_estimates(j,3)) <= maxPixels_off
                num_matches = num_matches + 1;
                if isequal(num_matches,required_matches)
                    best_estimate = ordered_estimates(i,2:3);
                    best_matches = num_matches;
                    isVerified = 1;
                    ordered_estimates
                    best_estimate
                    return
                elseif num_matches > best_matches
                    best_estimate = ordered_estimates(i,2:3);
                    best_matches = num_matches;
                end
            end
        end
    end
end
format('short')
end

