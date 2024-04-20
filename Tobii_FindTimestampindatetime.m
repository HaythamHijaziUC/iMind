function [indexs1,indexs2] = Tobii_FindTimestampindatetime(data,t1,t2)
    indexs1=[];indexs2=[];
    for c1= 1:1:(size(data))
            if(data(c1).Hour==t1.Hour && data(c1).Minute==t1.Minute)
                if( abs( data(c1).Second - t1.Second )<=0.01 ) 
                indexs1=c1; %Index is the index of the start timestamp (if found)
                break
                end
            end
    end
    for c1= indexs1:1:(size(data))
            if(data(c1).Hour==t2.Hour && data(c1).Minute==t2.Minute)
                if( abs( data(c1).Second - t2.Second )<=0.01 ) 
                indexs2=c1; %Index is the index of the start timestamp (if found)
                break
                end
            end
    end
end

