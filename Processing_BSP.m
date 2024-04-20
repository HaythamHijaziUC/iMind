function [N,t_total,Mat2,data] = Processing_BSP(biosignalplux)
    samples =  table2array(biosignalplux(:,1)); 
    samples=1:1:length(samples);%counter
    samples = reshape(samples',[],1);
    
    data = table2array(biosignalplux(:,2)); %ECG
    
    timestamps = table2array(biosignalplux(:,3));%timestamps in duration data
    timestampsSeconds=seconds(timestamps);%timestamps in double
    
    t_total=seconds(timestamps(end)-timestamps(1));%total time
    
    
    N = length(data);               % total number of samples
    Fs=N/t_total;
    Ts = 1/Fs;                      % sampling period
    t= 0: Ts: t_total-Ts;           % definition of time axes  
    Mat2 = reshape(t',[],1);
end

