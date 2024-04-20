function [SCL, SCR,Peakrate,numberofEDApeaks] = NewE4EDAToFeatures(new_EDA,ttime_CS,r) 
    flag=0;
    fs=4;
    yn=new_EDA;
    [~, ~, t, ~, ~, ~ , ~]=cvxEDA(yn, 0.25);% separation of the tonic component
    
% Regarding the data separation:    
% "sparsEDA" did not work and in manual the cut frequency band needed to be changed for 
%every volunteer "cvxEDA" works but it shows irregularities in the phasic component, 
%also it recommends normalising the data but the results get worse with it.
    

    tn=t;% tonic with white gausian noise
    SC=zeros(size(tn));% memory alocation
    for i = 1 : length(tn)
        SC(i) = yn(i) - tn(i);% SC without tonic and noise
        if SC(i)<0
            SC(i)=0;
        end
    end
    
    
    
     


    threshold=0.05;
    [pks,~]=findpeaks(SC,fs,'MinPeakProminence',threshold);% SCR Peaks
    s=length(pks);% number of EDA peaks
    Peakrate=s/ttime_CS;
    count1=0;count2=0;count=0;
    while Peakrate>0.05 || s<=3 || Peakrate<0.0166
        if Peakrate>0.05 && threshold<0.05
            if(count2>0)
                break
            end
            if threshold==0.01
                threshold=0.03;
            else
                threshold=threshold+0.01; 
            end
            [pks,~]=findpeaks(SC,fs,'MinPeakProminence',threshold);
            s=length(pks);
            Peakrate=s/ttime_CS;
            
            count1=count1+1; 
            %2*1
        end
        if threshold>=0.02 && Peakrate<0.0166
            if threshold==0.03
                threshold=0.01;
            else
                threshold=threshold-0.01;
            end
            [pks,~]=findpeaks(SC,fs,'MinPeakProminence',threshold);
            s=length(pks);
            Peakrate=s/ttime_CS;
             if(count1>0)
                break
            end
            count2=count2+1; 
            %0.5*1
        end
        if count>5
            break
        end
        count=count+1;
    end
    
    if (s>4)
        pks = reshape(pks',[],1);
        [ind_in1,~] = RemoveOutliersPupilD(pks,3,0);% the second parameter limits 
                                                    %up/down if outliers are detected, 
                                                    %eg.: 3 is extreme outliers.
        set=length(ind_in1);
        SCR=pks(ind_in1);
        SCL =t;
    else
        set=length(pks);
        SCR=(pks); 
        SCL=t;
    end
    

%     figure
%     plot(t)
%     title("EDA tonic - SCL")
%     figure
%     plot(SC)
%     findpeaks(SC,fs,'MinPeakProminence',threshold)% 0.0050 treshold
%     title("EDA phasic - SCR")
%     ylim([0.9*threshold 1.1*max(SC)])
%     xlim([0 inf])
%     figure
%     plot(yn)
%     title("EDA raw data")
 
        
    numberofEDApeaks=set;
    Peakrate=numberofEDApeaks/ttime_CS;
%save("edatime.mat")


% threshold
end


