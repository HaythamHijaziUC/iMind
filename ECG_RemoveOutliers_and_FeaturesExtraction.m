function [BioSignalPluxFrequency,BioSignalPluxTime]=RemoveOutliers_and_FeaturesExtraction(rpeaks_time,display)
dRp_time = rpeaks_time;
dRp = diff(rpeaks_time);
dRp = [dRp(1);dRp];
[ind_in,ind_out] = RemoveOutliersPupilD(dRp,3,0);%print the outliers in time domain
new_dRp = interp1(dRp_time(ind_in),dRp(ind_in),dRp_time,'linear');
dRp_new_fs = 8;
new_dRp_time_resamp = dRp_time(1):1/dRp_new_fs:dRp_time(end);%resample
new_dRp_resamp = interp1(dRp_time,new_dRp,new_dRp_time_resamp,'spline');
par=0.25;
ord=fix(par*length(new_dRp_resamp));
new_dRp_resamp= ecgLowPass(new_dRp_resamp,dRp_new_fs,1,1,ord);%low pass filter
if display == 1
    for i=1:length(dRp)
    HR(i)=60/dRp(i);  
    end
    HR = reshape(HR',[],1);
    figure
    plot(rpeaks_time,HR)
end
BioSignalPluxFrequency = hrvFrequencyDomain(new_dRp_resamp, 0, 16, 0);
BioSignalPluxTime = hrvTimeDomain(new_dRp_resamp);
end

