function [SDSD_E4_window_CS,RMSSD_E4_window_CS,SDNN_E4_window_CS,MEAN_E4_window_CS,number_of_windows_used,racio_E4_window_CS,CS_BSP_featureswithoutwindow] = BiosignaltxtToFeatures(window_secs, biosignalpluxs,TSbegin,TSend,Fs_BSP)

timestamp=datetime(date)+table2array(biosignalpluxs(:,3));
 
indexsa = BSP_FindTimestampindatetime(timestamp,TSbegin);
indexso = BSP_FindTimestampindatetime(timestamp,TSend);

biosignalplux=biosignalpluxs(indexsa:indexso,:);%HR cuted with the acording timestamps

[N_BSP,t_totalG1,t_BSP,data_BSP] = Processing_BSP(biosignalplux);

%Remove outliers
[waves_found] = ECG_Segmentation(data_BSP,Fs_BSP);
rpeaks_time = t_BSP(waves_found(:,6));
rpeaks_data = data_BSP(waves_found(:,6));
dRp_time = rpeaks_time;
dRp = diff(rpeaks_time);
dRp = [dRp(1);dRp];
[ind_in,ind_out] = RemoveOutliersPupilD(dRp,3,0);%print the outliers in time domain
new_dRp = interp1(dRp_time(ind_in),dRp(ind_in),dRp_time,'linear');

%Filtering and resample 
dRp_new_fs = 8;
new_dRp_time_resamp = dRp_time(1):1/dRp_new_fs:dRp_time(end);%resample
new_dRp_resamp = interp1(dRp_time,new_dRp,new_dRp_time_resamp,'spline');
par=0.25;
ord=fix(par*length(new_dRp_resamp));
new_dRp_resamp= ecgLowPass(new_dRp_resamp,dRp_new_fs,1,1,ord);%low pass filter
CS_BSP_featureswithoutwindow.FitbitSFrequency = hrvFrequencyDomain(new_dRp_resamp, 0, 16, 0);%
CS_BSP_featureswithoutwindow.FitbitSTime = hrvTimeDomain(new_dRp_resamp);
%features with hanning window
[number_of_windows_used,HRV_freq_features,HRV_time_domain_features,window_samp] = ...
    featureswithwindowsample(new_dRp_resamp,new_dRp_time_resamp,dRp_new_fs,window_secs);

%frequency
LF = reshape((HRV_freq_features.RaP(2,:))',[],1);
HF = reshape((HRV_freq_features.RaP(3,:))',[],1);
for i=1:(length(HF))
    racio_E4_window_CS(i,1)=LF(i,1)/HF(i,1);%%%%%%%%racio of sum of power values in that band divided by the total area a.k.a. the sum of all power values
end

%Time
SDSD_E4_window_CS=HRV_time_domain_features.sdsdRR;%%%%%%%SDSD
RMSSD_E4_window_CS=HRV_time_domain_features.rmssd;%%%%%%%RMSSD
SDNN_E4_window_CS=HRV_time_domain_features.sdnnRR;%%%%%%%SDNN
for i=1:(length(HRV_time_domain_features.mRR))
        MEAN_E4_window_CS(i,1)=60/HRV_time_domain_features.mRR(i,1);%%%%%%%MEAN HR
    end
end

