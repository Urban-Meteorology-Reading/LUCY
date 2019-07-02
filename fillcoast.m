function avtempfilled=fillcoast(avtemp)
avtempfilled=avtemp;
for i=2:size(avtemp,1)-1
    for j=2:size(avtemp,2)-1
        if isnan(avtemp(i,j))
            kernel=avtemp(i-1:i+1,j-1:j+1);
%             kernel2=kernel(kernel>0);
%             if isempty(kernel2)
%             else
                avtempfilled(i,j)=nanmean(kernel(:));
%             end
        else
            avtempfilled(i,j)=avtemp(i,j);
        end
    end
end