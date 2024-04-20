function [feat_transforms] = get_feature_transforms(features)


transf = {'mean', 'std', 'max', 'min', 'median','quantile'};

quantiles = [0.50 0.75 0.85 0.95];

feat_transforms = [];

for i=1:size(features,2)
    l=0;
    feat_i = features(:,i);
    feat_i_transf = [];
    for j=1:length(transf)
        if j==3 || j==4
            feat_i_transf = nan;
            eval(cell2mat(["feat_i_transf = " transf{j} "(feat_i,[],'omitnan');"]))
            l=l+1;
            if ~isempty(feat_i_transf)
            feat_transforms(l,i) = feat_i_transf;
                        else
            feat_transforms(l,i) = nan;    
            end
            
        elseif j==6
            for k=1:length(quantiles)
                feat_i_transf = nan;
                eval(cell2mat(["feat_i_transf = " transf{j} "(feat_i," quantiles(k) ");"]))
                l=l+1;
                if ~isempty(feat_i_transf)
                feat_transforms(l,i) = feat_i_transf;
                            else
               feat_transforms(l,i) = nan; 
            end
            end
        else
            feat_i_transf = nan;
            eval(cell2mat(["feat_i_transf = " transf{j} "(feat_i,'omitnan');"]))
            l=l+1;
            if ~isempty(feat_i_transf)
            feat_transforms(l,i) = feat_i_transf;
            else
                feat_transforms(l,i) = nan;
            end
        end
    end

end
