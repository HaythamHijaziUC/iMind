function [number_of_windows_used,HRV_freq_features,HRV_time_domain_features,window_samp] = featureswithwindowsample(new_dRp_resamp,new_dRp_time_resamp,dRp_new_fs,window_secs)
typePsd = 0; %% burg
display = 0; %%no display
window_samp =  floor(window_secs * dRp_new_fs);
jump_secs = 1;
jump_samp = floor(jump_secs*dRp_new_fs);
freq_vec = 0:0.01:10;
freq_bands = [0 0.04 0.15 0.4]; %VLF(0-0.4) ,LF(0.04-0.15), HF(0.15-0.4)
psd_analysis_vars.typePsd = typePsd; 
psd_analysis_vars.window_secs = window_secs; 
psd_analysis_vars.jump_secs = jump_secs; 
psd_analysis_vars.freq_vec = freq_vec; 
psd_analysis_vars.freq_bands = freq_bands;

%frequency domain analyses
[HRV_freq_features] = TimeVariant_FreqAnalysis(new_dRp_time_resamp,new_dRp_resamp,dRp_new_fs,psd_analysis_vars.typePsd,psd_analysis_vars.freq_vec,psd_analysis_vars.freq_bands, window_samp,jump_samp,display);

%time domain analyses
[tdfeat.T, tdfeat.mRR, tdfeat.sdnnRR, tdfeat.sdsdRR, tdfeat.rmssd, tdfeat.nn50RR,...
    tdfeat.pnn50RR,tdfeat.ApEn_value,tdfeat.SD1,tdfeat.SD2] = ...
    TimeVariant_hrv_TimeAnalysis2(new_dRp_time_resamp,new_dRp_resamp,window_samp,jump_samp);
HRV_time_domain_features = tdfeat;

N_data = length(new_dRp_resamp);
half_window_samp = floor(window_samp/2)-1;
number_of_windows_used=length(1+half_window_samp:dRp_new_fs:N_data-half_window_samp);%this represents the number of windows useds     
end

