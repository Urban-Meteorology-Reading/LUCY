function YYYYclose=LUCY_datasummary_v1(startdate,use_opt)
WD=pwd;
YYYY=datevec(startdate);
YYYY=YYYY(1);

% Temperature
if use_opt==1
    tempday=1;
    tempmonth=0;
else
    tempday=0;
    if exist([WD,'\Data\temperature\air_temp.',num2str(YYYY)],'file')>0
        tempmonth=1;
    else
        tempmonth=0;
    end
end

% Population
for i=1900:2099
    pop(i)=exist([WD,'\Data\population\popcell_',num2str(i),'.mat'],'file');
end
avail=find(pop>0);
clos=abs(avail-YYYY);
tmp=min(clos);
pos=clos==tmp;
    if sum(pos)>1
        postmp=find(pos==1,1);
        pos(:,:)=0;
        pos(postmp)=1;
    end
YYYYclose=avail(pos);

% Energy
energytable=importdata([WD,'\Data\','energy.txt']);
energytable=energytable.data;
datatable1=energytable(2:232,:);
energyyeartab=findclosestyear(datatable1,YYYY);
% energytab=energytable(2:232,YYYY-1900+1);

% Traffic
carstable=importdata([WD,'\Data\','Cars.txt']);
carstable=carstable.data;
datatable2=carstable(2:232,:);
carsyeartab=findclosestyear(datatable2,YYYY);
% carstab=carstable(2:232,YYYY-1900+1);

freightstable=importdata([WD,'\Data\','Freights.txt']);
freightstable=freightstable.data;
datatable3=freightstable(2:232,:);
freightsyeartab=findclosestyear(datatable3,YYYY);
% freightstab=freightstable(2:232,YYYY-1900+1);

mbikestable=importdata([WD,'\Data\','Motorbikes.txt']);
mbikestable=mbikestable.data;
datatable4=mbikestable(2:232,:);
mbikesyeartab=findclosestyear(datatable4,YYYY);
% mbikestab=mbikestable(2:232,YYYY-1900+1);

tabdata=[energyyeartab carsyeartab freightsyeartab mbikesyeartab];
mbikestable=importdata([WD,'\Data\','Motorbikes.txt']);
mbikestable.rowheaders=mbikestable.rowheaders(2:232);
save('tempday','tempday')
save('tempmonth','tempmonth')
save('YYYY','YYYY')
save('YYYYclose','YYYYclose')
save('mbikestable','mbikestable')
save('tabdata','tabdata')
DataSummary()
