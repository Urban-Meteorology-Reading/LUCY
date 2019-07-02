function [out] = resample_lucy_v1(a,res,gridname)
% This function to change pixel resolution
%30 arc seconds = 0.00833333333
% size of the matrix s
a(a==0)=NaN;
s=round(res/0.00833333333);
m=1;
n=s;
out=zeros( );
if strcmp(gridname,'countries')
    
    for i=1:size(a,1)/s;
        o=1;
        p=s;
        for j=1:size(a,2)/s;
            x=a(m:n,o:p);
            
            if sum(sum(isnan(x)))<=((s*s)*(2/3))
                k1=mode(x(:));
            else
                k1=NaN;
            end
            out(i,j)=k1;
            o=o+s;
            p=p+s;
        end
        clear x
        m=m+s;
        n=n+s;
    end
    
elseif strcmp(gridname,'urban')
    for i=1:size(a,1)/s;
        o=1;
        p=s;
        for j=1:size(a,2)/s;
            x=a(m:n,o:p);
            
            if sum(sum(isnan(x)))<=((s*s)*(2/3))
                k1=mode(x(:));
            else
                k1=NaN;
            end
            out(i,j)=k1;
            o=o+s;
            p=p+s;
        end
        clear x
        m=m+s;
        n=n+s;
    end
elseif strcmp(gridname,'population')
    for i=1:size(a,1)/s;
        o=1;
        p=s;
        for j=1:size(a,2)/s;
            x=a(m:n,o:p);
            
            if sum(sum(isnan(x)))<=((s*s)*(2/3))
                k1=nanmean(x(:));
            else
                k1=NaN;
            end
            out(i,j)=k1;
            o=o+s;
            p=p+s;
        end
         clear x
        m=m+s;
        n=n+s;
    end
end

