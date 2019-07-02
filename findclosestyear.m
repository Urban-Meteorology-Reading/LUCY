function yeartab=findclosestyear(datatable,YYYY)
yeartab=[];
for i=1:231
    for j=1:200
        findnum(i,j)=isnan(datatable(i,j));
    end
end
findnum=findnum*-1+1;
y=YYYY-1900+1;

for i=1:231
    countryYY=findnum(i,:);
    avail=find(countryYY>0);
    clos=abs(avail-y);
    tmp=min(clos);
    pos=clos==tmp;
    if sum(pos)>1
        postmp=find(pos==1,1);
        pos(:,:)=0;
        pos(postmp)=1;
    end
    if isempty(pos)
        yeartab(i)=NaN;
    else
        yeartab(i)=avail(pos);
    end
end

yeartab=yeartab';
yeartab=yeartab+1900-1;