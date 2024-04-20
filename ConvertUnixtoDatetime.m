function [HRaf,timestamp] = ConvertUnixtoDatetime(HR,offset)
HRa=HR(3:end,:);
HRa(1,2)=0;
HRa(1,3)=HR(1,1);
v=datetime(HRa(1,3),'ConvertFrom','epochtime','Format','HH:mm:ss.SSS');%convert UNIX to date %posixtime() %converts date to UNIX

%converting excel unix to data for matlab
v1(1,1)=v+hours(1);
for c= 1:1:(size(HRa)-1)
    HRa((c+1),2)=c;
    HRa((c+1),3)=c./HR(2,1)+HR(1,1);
    unix=HRa((c+1),3);
    v=datetime(unix,'ConvertFrom','epochtime','Format','HH:mm:ss.SSS');%convert UNIX to date
    v1(c+1,1)=v+hours(offset)+seconds(0.1); %%adding one hours because of dst offset right now%%
end

HRaf=HRa(:,1); %HR
timestamp=v1(:,1); %timestamp
end

