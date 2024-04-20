function [indexs] = SC_FindTimestampindatetime(data,timestampdata)
    indexs=[];
    t=datetime(timestampdata,'Format','HH:mm:ss.SSS'); %%SELECT HERE THE TIME OF START%%
    for c1= 1:1:(size(data))
            if(data(c1).Hour==t.Hour && data(c1).Minute==t.Minute)
                if( abs( data(c1).Second - t.Second )<=0.1 ) 
                indexs=c1; %Index is the index of the start timestamp (if found)
                break
                end
            end
    end
end

