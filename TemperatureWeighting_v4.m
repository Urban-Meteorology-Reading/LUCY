function avtemp=TemperatureWeighting_v4(DOY,N,S,W,E,WD,use_opt,opt_path,startdate,do)

%INPUTS
% DOY        -   Day of Year
% bal        -   Balance temperature
% e_increase -   Procentage of energy increase with Ta>bal
% e_decrease -   Procentage of energy increase with Ta<bal
% upper      -   Upper limit of temperature range
% lower      -   Lower range of temperature range
% N,S,W,E    -   Spatial extent

% Input parameters
%percentage of total energy depending on average monthly temperature
bal=12;
multfac=0.7;
e_increase=0.03;
YYYY=datevec(startdate);
YYYY=YYYY(1);

if use_opt(1)==1 % Checking and loading daily temperature data (if available)
    INPUT=char(struct2cell(opt_path.temp));
    [dayswithtemp] =readgrid_Temperature_V2(INPUT);
    if find(DOY==dayswithtemp) > 0
        avtemp=gettemperaturegrid(INPUT,dayswithtemp,DOY);
        avtemp=avtemp';
    else
        msgboxText{1} =  'The current day is not found in daily temperature file';
        msgbox(msgboxText,'Daily file not correct', 'error');
    end
else % looking for Willmot montly data
    if exist([WD,'\Data\temperature\air_temp.',num2str(YYYY)],'file')>0
        avtemp=ImportWillmot_v2(startdate,do);
    else %Loading original Monthly temperature data
        if(DOY>=1)&&(DOY<=31)
            load ([WD,'\Data\temperature\','avtemp_jan.mat']);
        elseif(DOY>=32)&&(DOY<=59)
            load ([WD,'\Data\temperature\','avtemp_feb.mat']);
        elseif(DOY>=60)&&(DOY<=90)
            load ([WD,'\Data\temperature\','avtemp_mar.mat']);
        elseif(DOY>=91)&&(DOY<=120)
            load ([WD,'\Data\temperature\','avtemp_apr.mat']);
        elseif(DOY>=121)&&(DOY<=151)
            load ([WD,'\Data\temperature\','avtemp_may.mat']);
        elseif(DOY>=152)&&(DOY<=181)
            load ([WD,'\Data\temperature\','avtemp_jun.mat']);
        elseif(DOY>=182)&&(DOY<=212)
            load ([WD,'\Data\temperature\','avtemp_jul.mat']);
        elseif(DOY>=213)&&(DOY<=243)
            load ([WD,'\Data\temperature\','avtemp_aug.mat']);
        elseif(DOY>=244)&&(DOY<=273)
            load ([WD,'\Data\temperature\','avtemp_sep.mat']);
        elseif(DOY>=274)&&(DOY<=304)
            load ([WD,'\Data\temperature\','avtemp_oct.mat']);
        elseif(DOY>=305)&&(DOY<=334)
            load ([WD,'\Data\temperature\','avtemp_nov.mat']);
        elseif(DOY>=335)&&(DOY<=365)
            load ([WD,'\Data\temperature\','avtemp_dec.mat']);
        end
    end
end
avtemp=avtemp(N:S,W:E);

% Loading temperature weighting 
mon=['jan';'feb';'mar';'apr';'may';'jun';'jul';'aug';'sep';'oct';'nov';'dec'];
load ([WD,'\Data\temperature\','tempweightmin_',mon(month(startdate),:),'.mat']);
tempweightmin=tempweightmin(N:S,W:E);

%% Scaling data Latitude sensitive
% Energy consuption by decreasing temperature
avtemp(avtemp<=bal)=multfac+(bal-avtemp(avtemp<=bal)).*tempweightmin(avtemp<=bal);

% Energy consuption by increasing temperature
avtemp(avtemp>bal)=multfac+(avtemp(avtemp>bal)-bal)*e_increase;

