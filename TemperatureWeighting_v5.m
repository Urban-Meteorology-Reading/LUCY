function avtemp=TemperatureWeighting_v5(DOY,N,S,W,E,WD,use_opt,opt_path,startdate,do,balancegrid,HDDgrid,CDDgrid,res)
% This version use economic status and CDD/HDD to calculate temperature
% wheighting
%
%INPUTS
% DOY           - Day of Year
% N,S,W,E       - Spatial extent
% WD            - Working directory
% use_opt       - Option to use daily temperture data
% use_path      - Path to daily temperture netcdf-file
% startdate      - Julian day of start
% do            - days from start of run
% balancegrid   - Fraction of energy use at balance temperature, 12degrees
% HDDgrid       - Increase in ennergy use by HDD
% CDDgrid       - Increase in ebergy use by CDD

YYYY=datevec(startdate);
YYYY=YYYY(1);
monthname=['jan';'feb';'mar';'apr';'may';'jun';'jul';'aug';'sep';'oct';'nov';'dec'];
mon=month(startdate+do);
datafolder='Data';
if use_opt(1)==1 % Checking and loading daily temperature data (if available)
%     INPUT=char(struct2cell(opt_path.temp));
%     [dayswithtemp] =readgrid_Temperature_V2(INPUT);
    if exist([WD filesep datafolder filesep 'temperature' filesep 'Dailytemp_',...
            num2str(YYYY),'_',num2str(DOY),'.mat'],'file')>0
%     if find(DOY==dayswithtemp) > 0
        load([WD filesep datafolder filesep 'temperature' filesep 'Dailytemp_',...
            num2str(YYYY),'_',num2str(DOY),'.mat']);
%         avtemp=gettemperaturegrid(INPUT,dayswithtemp,DOY);
%         avtemp=avtemp';
    else
        msgboxText{1} =  'The current day is not found in daily temperature file';
        msgbox(msgboxText,'Daily file not correct', 'error');
    end
else % looking for Willmot montly data
    if exist([WD,'\Data\temperature\air_temp.',num2str(YYYY)],'file')>0
        avtemp=ImportWillmot_v4(startdate,do,WD,datafolder);
    else %Loading original Monthly temperature data
        load ([WD,filesep,datafolder,filesep','temperature',filesep,'avtemp_',monthname(mon,:),'70_00.mat']);
    end
    avtemp=avtemp(5*2+1:360-((90-58)*2),:); %cropping to fit GPW grid
    avtemp=imresize(avtemp,0.5/res,'nearest'); %resizing to user resolution
end

avtemp=avtemp(N:S,W:E);

%% New Temperature Wheighting Scheme - 20120508
bal=12;
monthlength=[31 28.35 31 30 31 30 31 31 30 31 30 31];

if exist('CDD','var')==0
    CDD=avtemp;
    CDD=bal-CDD;
    CDD(CDD>0)=0;
    CDD=abs(CDD*monthlength(mon));
    HDD=avtemp;
    HDD=bal-HDD;
    HDD(HDD<0)=0;
    HDD=abs(HDD*monthlength(mon));
end

% Scaling HDD in the cooldest latitiudes (20120802)
% HDD2=HDD;HDD3=HDD;
% HDD2(HDD2<=800)=0;
% HDD3(HDD3>800)=0;
% HDD2=-0.00024*HDD2.^2+1.07*HDD2+100;
% HDD2(HDD2==100)=0;
% HDD=HDD3+HDD2;

HDD2=HDD;HDD3=HDD;
HDD2(HDD2<=600)=0;
HDD3(HDD3>600)=0;
HDD2=-0.0002*HDD2.^2+0.8458*HDD2+164.4;
HDD2(HDD2==164.4)=0;
HDD=HDD3+HDD2;

CDDincrease=CDD.*CDDgrid;
HDDincrease=HDD.*HDDgrid;

avtemp=balancegrid+CDDincrease+HDDincrease;
          
%% Old Temperature Wheighting Scheme
% % Input parameters
% % percentage of total energy depending on average monthly temperature
% bal=12;
% multfac=0.7;
% e_increase=0.03;
% 
% % Loading temperature weighting 
% mon=['jan';'feb';'mar';'apr';'may';'jun';'jul';'aug';'sep';'oct';'nov';'dec'];
% load ([WD,'\Data\temperature\','tempweightmin_',mon(month(startdate),:),'.mat']);
% tempweightmin=tempweightmin(N:S,W:E);
% 
% % Scaling data Latitude sensitive
% % Energy consuption by decreasing temperature
% avtemp(avtemp<=bal)=multfac+(bal-avtemp(avtemp<=bal)).*tempweightmin(avtemp<=bal);
% 
% % Energy consuption by increasing temperature
% avtemp(avtemp>bal)=multfac+(avtemp(avtemp>bal)-bal)*e_increase;

