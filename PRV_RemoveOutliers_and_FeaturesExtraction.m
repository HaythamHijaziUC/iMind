function [FitbitSFrequency,FitbitSTime,new_dRp_resamp,new_dRp_time_resamp,dRp_new_fs,ind_out]=PRV_RemoveOutliers_and_FeaturesExtraction(dRp,timeHR)
c=0.358875149433782;
dRp_time = zeros(1,(length(dRp)+1));
for i=1:length(dRp)
    dRp_time(i+1)=c+dRp(i);
    c=dRp_time(i+1);
end
dRp_time = reshape(dRp_time',[],1);
dRp = [dRp(1);dRp];

[ind_in,ind_out] = RemoveOutliersPupilD(dRp,3,0);%o segundo parametro o limiar acima(ou abaixo) do qual os outliers são detetados, ex.: 3 é extreme outliers"
new_dRp = interp1(dRp_time(ind_in),dRp(ind_in),dRp_time,'linear');
dRp_new_fs = 8;
new_dRp_time_resamp = dRp_time(1):1/dRp_new_fs:timeHR(end);%resample
new_dRp_time_resamp = reshape(new_dRp_time_resamp',[],1);
new_dRp_resamp = interp1(dRp_time,new_dRp,new_dRp_time_resamp,'spline');
par=0.25;
ord=fix(par*length(new_dRp_resamp));
new_dRp_resamp= ecgLowPass(new_dRp_resamp,dRp_new_fs,1,1,ord);%low pass filter
FitbitSFrequency = hrvFrequencyDomain(new_dRp_resamp, 0, 16, 0);%
FitbitSTime = hrvTimeDomain(new_dRp_resamp);
end

