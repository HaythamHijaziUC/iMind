function [SCL, SCR,Peakrate,numberofEDApeaks] = EDAToFeatures(new_EDA,window_secs,ttime_CS) 

     totaltimewatch = ttime_CS;%total time
     NEDA = length(new_EDA);% total number of samples
     FsEDA = 4;                
     TsEDA = 1/FsEDA; % sampling period
     tEDA= 0: TsEDA: totaltimewatch-TsEDA;% definition of time axes
    timeEDA = reshape(tEDA',[],1);
    k=0;fs=4;
    N_data=length(new_EDA(:,1));
    window_samp =  window_secs * fs;
    half_window_samp = floor(window_samp/2)-1;
    
    baselineY = sgolayfilt(new_EDA, 3, 35);
    
    for i = 1 : length(new_EDA)
    
        SC(i) = new_EDA(i) - baselineY(i);
        
    end
%     figure
%     plot(new_EDA)
%     title("EDA and baseline(made with sgolayfilt)")
%     hold on
%     plot(baselineY)
%     
%     figure
%     plot(new_EDA)
%     findpeaks(SC,fs,'MinPeakProminence',0.01)
%     title("EDA-Baseline with find peaks")
    
    %[pks,ind_x] = findpeaks(EDAaf,fs,'MinPeakHeight',0.15);%treshhold
    jump_secs = 1;
    jump_samp = floor(jump_secs*fs);
    for i=1:jump_samp:N_data-half_window_samp
        k=k+1;
        ind_b = i-half_window_samp; 
        ind_a = i+half_window_samp;
         if ind_b<1 
            ind_b=1; end
        if ind_a>N_data 
            ind_a=N_data; end
        SCL(k,1) = mean(baselineY(ind_b:ind_a));
        [SCRi,~] = findpeaks(SC(ind_b:ind_a),fs,'MinPeakProminence',0.01);
        set=size(SCRi);
        Peakrate(k,1)=set(1)/window_samp;
        SCR(k,1)=mean(SCRi);
    end
    [~,xA] = findpeaks(SC,fs,'MinPeakProminence',0.01);
    numberofEDApeak=size(xA);
    numberofEDApeaks=numberofEDApeak(1);
    SCR=get_feature_transforms(SCR);
    Peakrate=get_feature_transforms(Peakrate);
    SCL =get_feature_transforms(SCL);
    save("coisonew.mat")
%     cutoff=0.08;
% fs=4;
% wn=cutoff/(fs/2);
% [b,a]=butter(2,wn);
% tonic=filtfilt(b,a,new_EDA)
% phasic=new_EDA-tonic;
end


