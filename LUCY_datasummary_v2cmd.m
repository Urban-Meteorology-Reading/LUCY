function [use_opt,YYYYclose,tabdata]=LUCY_datasummary_v2cmd(startdate,use_opt,WD,datafolder,pop,latmax,latmin,lonmin,lonmax)

YYYY=datevec(startdate);
YYYY=YYYY(1);
userdata=getuserdir;
tempdir=[userdata filesep 'LUCY' filesep];

% Temperature
if use_opt==1
    %     tempmonth=0;
    DOY=startdate-(datenum(YYYY,1,1)-1);
    if exist([WD filesep datafolder filesep 'temperature' filesep 'Dailytemp_',...
            num2str(YYYY),'_',num2str(DOY),'.mat'],'file')>0
        tempday=1;
    else
        tempday=0;
        use_opt=0;
        if exist([WD filesep datafolder filesep 'temperature' filesep 'air_temp.',num2str(YYYY)],'file')>0
            tempmonth=1;
        else
            tempmonth=0;
        end
    end
else
    tempday=0;
    if exist([WD filesep datafolder filesep 'temperature' filesep 'air_temp.',num2str(YYYY)],'file')>0
        tempmonth=1;
    else
        tempmonth=0;
    end
end

% Population density
if pop==1
    for i=1900:2099
        popi(i)=exist([WD filesep datafolder filesep 'population' filesep 'population_' ,num2str(i)],'dir');
    end
else
    for i=1900:2099
        popi(i)=exist([WD filesep 'Data' filesep 'DataGPW' filesep 'population' filesep 'popcell_',num2str(i),'.mat'],'file');
    end
end
avail=find(popi>0);
clos=abs(avail-YYYY);
tmp=min(clos);
pos=clos==tmp;
if sum(pos)>1
    postmp=find(pos==1,1);
    pos(:,:)=0;
    pos(postmp)=1;
end
YYYYclose=avail(pos);

% Identifying countries within model domain
load([WD,filesep,'Data',filesep,'countriesforgui.mat']);
S=floor(abs(latmin-85)/0.1667);
N=floor(abs(latmax-85)/0.1667);
W=floor((180+lonmin)/0.1667);
E=floor((180+lonmax)/0.1667);
countries=countries(N:S,W:E);
b=unique(countries);c=isnan(b);
b=b(c==0);
% Energy
energytable=importdata([WD filesep datafolder filesep 'Energy.txt']);
energytable=energytable.data;
datatable1=energytable(2:232,:);
energyyeartab=findclosestyear(datatable1,YYYY);
% energytab=energytable(2:232,YYYY-1900+1);

% Traffic
carstable=importdata([WD filesep datafolder filesep 'Cars.txt']);
carstable=carstable.data;
datatable2=carstable(2:232,:);
carsyeartab=findclosestyear(datatable2,YYYY);

freightstable=importdata([WD filesep datafolder filesep 'Freights.txt']);
freightstable=freightstable.data;
datatable3=freightstable(2:232,:);
freightsyeartab=findclosestyear(datatable3,YYYY);

mbikestable=importdata([WD filesep datafolder filesep 'Motorbikes.txt']);
mbikestable=mbikestable.data;
datatable4=mbikestable(2:232,:);
mbikesyeartab=findclosestyear(datatable4,YYYY);

% Total population
poptable=importdata([WD filesep datafolder filesep 'PopulationByCountry.txt']);
poptable=poptable.data;
datatable1=poptable(2:232,:);
popyeartab=findclosestyear(datatable1,YYYYclose);

tabdata=[energyyeartab carsyeartab freightsyeartab mbikesyeartab popyeartab];
tabdataid=tabdata(b,:);
mbikestable=importdata([WD,filesep,'Data',filesep,'Motorbikes.txt']);
mbikestable.rowheaders=mbikestable.rowheaders(2:232);
save([tempdir 'countryid'],'b')
save([tempdir 'tempday'],'tempday')
save([tempdir 'tempmonth'],'tempmonth')
save([tempdir 'YYYY'],'YYYY')
save([tempdir 'YYYYclose'],'YYYYclose')
save([tempdir 'mbikestable'],'mbikestable')
save([tempdir 'tabdata'],'tabdata')
save([tempdir 'tabdataid'],'tabdataid')
save([tempdir 'pop'],'pop')
%h=DataSummary();
%uiwait(h)
