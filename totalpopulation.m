function totalpopu=totalpopulation(popcell,countries,N,S,W,E)
areaofinterest=countries(N:S,W:E);
totalpopu=countries;
for i=1:231
    if isempty(isnan(find(areaofinterest==i)))==1
%         countpopu(i)=NaN;
    else
%         countpopu(i)=nansum(popcell(countries==i));
        totalpopu(totalpopu==i)=nansum(popcell(countries==i));
    end
end