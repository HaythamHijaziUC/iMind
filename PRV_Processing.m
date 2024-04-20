function [dRp,timeHR] = PRV_Processing(new_HR,ttime_CS)
   totaltimewatch = ttime_CS;%total time
   NHR = length(new_HR);% total number of samples
   FsHR = 1;                
   TsHR = 1/FsHR; % sampling period
   tHR= 0: TsHR: totaltimewatch-TsHR;% definition of time axes
   timeHR = reshape(tHR',[],1);

    for i=1:NHR
    dRpempatica(i)=60/new_HR(i);
    end
    dRp = reshape(dRpempatica',[],1);

end

