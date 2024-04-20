function [SDSD_E4_window_CS,RMSSD_E4_window_CS,SDNN_E4_window_CS,MEAN_E4_window_CS,number_of_windows_used,CS_featureswithoutwindow,racio_E4_window_CS,ind_out,SD12_window_CS] = E4HRcsvToFeatures(new_HR,window_secs,ttime_CS)
    %processing from HR to dRp
    [dRp,timeHR] = PRV_Processing(new_HR,ttime_CS);
   %2.1.a Features Without window
    %Removing outlier and extracting fitbit without moving window sample
    [EmpaticaFrequency,EmpaticaTime,new_dRp_resamp,new_dRp_time_resamp,dRp_new_fs,ind_out]=PRV_RemoveOutliers_and_FeaturesExtraction(dRp,timeHR);
    %Features of time domain
    CS_featureswithoutwindow.SDSD_E_G=EmpaticaTime.SDSD;
    CS_featureswithoutwindow.SDNN_E=EmpaticaTime.SDNN;
    CS_featureswithoutwindow.RMSSD_E=EmpaticaTime.RMSSD;
    CS_featureswithoutwindow.MEAN_E=60/EmpaticaTime.mean;
    %Features of frequency domain
    CS_featureswithoutwindow.racio_E=EmpaticaFrequency.pLF/EmpaticaFrequency.pHF;%racio of max values of Low and High frequencies

    
   %2.1.b Features with hanning window
    [number_of_windows_used,HRV_freq_features,HRV_time_domain_features,window_samp] = featureswithwindowsample(new_dRp_resamp,new_dRp_time_resamp,dRp_new_fs,window_secs);
    
    %frequency
    LF = reshape((HRV_freq_features.RaP(2,:))',[],1);                
    HF = reshape((HRV_freq_features.RaP(3,:))',[],1);
    racio_E4_window_CS=zeros(length(HRV_freq_features.RaP(3,:)),1);
    for i=1:(length(HF))
        racio_E4_window_CS(i,1)=LF(i,1)/HF(i,1);%%%%%%%%racio of sum of power values in that band divided by the total area a.k.a. the sum of all power values
    end
                                     
    %Time
    SDSD_E4_window_CS=HRV_time_domain_features.sdsdRR;%%%%%%%SDSD
                                     
    RMSSD_E4_window_CS=HRV_time_domain_features.rmssd;%%%%%%%RMSSD
                                     
    SDNN_E4_window_CS=HRV_time_domain_features.sdnnRR;%%%%%%%SDNN
                                     
    MEAN_E4_window_CS=zeros(length(HRV_time_domain_features.mRR),1);
    for i=1:(length(HRV_time_domain_features.mRR))
        MEAN_E4_window_CS(i,1)=60/HRV_time_domain_features.mRR(i,1);%%%%%%%MEAN HR
    end
                                      
    SD12_window_CS=zeros( size(HRV_time_domain_features.SD1) );
    for i=1:(length(HRV_time_domain_features.SD1))
        SD12_window_CS(i,1)=HRV_time_domain_features.SD1(i,1)/HRV_time_domain_features.SD2(i,1);%%%%%%%SD ratio
    end
                                      
    
     
%      figure()
%     plot(SDSD_E4_window_CS)
%     title("SDSD")
%      figure()
%     plot(RMSSD_E4_window_CS)
%     title("RMSSD")
%      figure()
%     plot(SDNN_E4_window_CS)
%     title("SDNN")
%      figure()
%     plot(MEAN_E4_window_CS)
%     title("HR")
%      figure()
%     plot(racio_E4_window_CS)
%     title("racio of High/low frequencies")
%      figure()
%     plot(SD12_window_CS)
%     title("racio of Poincare")
 TT=reshape((HRV_time_domain_features.T)',[],1);
 FT=reshape((HRV_freq_features.psd_time)',[],1);
%save("HrTime.mat","TT","FT");
    
end

