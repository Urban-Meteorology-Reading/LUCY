%
%Anthropogenic heat flux model
%Lucy Allen, July 2009
%Department of Geography, King's College London, UK
%
% --SIGNIFICANT UPDATES--
% 2010-02-04;   Modified by Fredrik Lindberg to run without changing the
%               core code
% 2010-08-07;   Designed to run with the LUCY GUI
% 2010-09-05;   Update to new version 2.0 to include temperature changes
% 2010-11-03;   Update to V2.1 to reduce the number of grids used as inputdata
% 2011-01-05;   LUCY_21_core_large.m created to cope with large modeldomains
% 2011-02-11;   Updat to version 3 to include year variable
% 2012-06-30;   New version (4.0 BETA) including new temperature wheighting
%               based on CDDHDD
% 2012-12-12;   New version for dynamic scale calculations

function [popcell] = LUCY_2013b_core(startdate,SP,F,latmax,latmin,lonmin,lonmax,WD,NOD,cityname,showimage,use_opt,opt_path,YYYYclose,YYYYtabdata,statreg,onlyurban,res,datafolder,outputfolder)
% Inputdata
% DOY - day of year,
% SP  - average speed of vehicles,
% F   - factor multiplying total vehicles to get number of vehicles on road
% latmax,latmin,lonmin,lonmax - bounds of study region in decimal degree
% WD  - Working directory
% NOD - number of days to run
% cityname - name of city
% showimage - show image during execution
% use_opt - option to use optional grids
% opt_path - Location of netcdf file
% opt_varid - variable number in netcdf file
% YYYYclose - Closest year in time where stat. data is available
% YYYYtabdata - Tabledata of statistics
% statreg - 
% onlyurban - option for only including urban areas (1=Yes, 0=No)
% res - resolution in arc-seconds
% datafolder - location of data folder in relation to WD
% outputfolder - Saving directory

h=PleaseWait();

foldername=[outputfolder,filesep,'Grids'];
if(exist(foldername,'dir')==0)
    mkdir(foldername);
end
ahfLondon=[];
%% Constant parameters
YYYY=datevec(startdate);
YYYY=YYYY(1);
DOY=datenum(startdate)+1-datenum(YYYY,1,1);
[ latmin,latmax,lonmin,lonmax ] = adjextent( latmin,latmax,lonmin,lonmax,res );% To convert latitude and longitude divisable by input resolution
res=res/3600; %converting from seconds to decimal dergree

% Country grid for generating other grids in main loop
gridname='countries';
[countries,latmintile,latmaxtile,lonmintile,lonmaxtile]=tilepick_v1(latmin,latmax,lonmin,lonmax,gridname,WD,datafolder,YYYYclose);
countries(countries==220)=101;% Integrating Vatican into Italy
if res~=30/3600 % To skip resampling function if input resolution is 30arc second
countries=resample_lucy_v1(countries,res,gridname); %resampling to desired resolution
end
countries=areaofinterest(latmin,latmax,lonmin,lonmax,countries,res);

%Population density
gridname='population';
popcell=tilepick_v1(latmin,latmax,lonmin,lonmax,gridname,WD,datafolder,YYYYclose);
if res~=30/3600
popcell=resample_lucy_v1(popcell,res,gridname);
end
popcell=areaofinterest(latmin,latmax,lonmin,lonmax,popcell,res);

% total population
[totalpopu,foundcountries]=populatecountrygrid(countries,WD,datafolder,'PopulationByCountry.txt',YYYYtabdata(:,5));
totalpopu=totalpopu*1000;

% Urbanareas
if onlyurban==1
    gridname='urban';
    urbanareas=tilepick_v1(latmin,latmax,lonmin,lonmax,gridname,WD,datafolder,YYYYclose);
    if res~=30/3600
        urbanareas=resample_lucy_v1(urbanareas,res,gridname);
    end
    urbanareas=areaofinterest(latmin,latmax,lonmin,lonmax,urbanareas,res);
else
    urbanareas=ones([size((countries),1),size((countries),2)]);
end

if statreg(1)==1
    IDtable=importdata([WD,filesep,datafolder,filesep,'IDcomp.txt']);
    IDtable=IDtable.data;
    statreg(2)=find(IDtable(:,2)==statreg(2));
    mask=zeros(size(countries));
    mask(countries==statreg(2))=1;
    mask(mask==0)=NaN;
else
    mask=ones(size(countries));
end

% Textfiles (2005) of: Fixed public holidays, Metabolism and Traffic
fixedpublicholidays=importdata([WD,filesep,datafolder,filesep,'fixedpublicholidays.txt']);
metabolismhour=importdata([WD,filesep,datafolder,filesep,'Metabolism.txt']);
weekdayhour=importdata([WD,filesep,datafolder,filesep,'weekdayhours.txt']);
weekendhour=importdata([WD,filesep,datafolder,filesep,'weekendhours.txt']);
weekendday=importdata([WD,filesep,datafolder,filesep,'weekenddays.txt']);

% Cellsize reduction based in latitude and longitude
cellsize_km2_reduc=1; % Not needed but kept

% Energy for each country taken from the clostest year in time where
% statistics are present
energy=populatecountrygrid(countries,WD,datafolder,'Energy.txt',YYYYtabdata(:,1));

% Economicstatus for cooling and heating
[balancegrid,HDDgrid,CDDgrid]=populatecountrygridHDDCDD_v1(countries,WD,datafolder,YYYY);

% Cars for each country
cars=populatecountrygrid(countries,WD,datafolder,'Cars.txt',YYYYtabdata(:,2));
carscell=(((cars*24)*F) .* (popcell/1000));

% Freights for each country
freight=populatecountrygrid(countries,WD,datafolder,'Freights.txt',YYYYtabdata(:,3));
freightcell=(((freight*24)*F) .* (popcell/1000));

% Motorbikes for each country
mbikes=populatecountrygrid(countries,WD,datafolder,'Motorbikes.txt',YYYYtabdata(:,4));
mbikescell=(((mbikes*24)*F) .* (popcell/1000));

%calculate average electricity consumption per person
energy_pp=energy./totalpopu;
%calculate electricity consumption in each cell
energy_cell=energy_pp.*popcell;
%calculate average consumption (from kwh - divide by 1000)
%8.76 is average hourly consumption (number of hours in year/1000)
energy_w=energy_cell/8.76;

ahfmean=zeros(size(countries,1),size(countries,2));
countries(isnan(countries))=0;
% b=unique(countries);% Used for plotting
close(h)

if showimage=='y'
    screensize=get(0,'ScreenSize');
    screenwidth=screensize(3);
    screenheight=screensize(4);
    %The figure takes the 50% of the screen
    figure('Position',[(screenwidth-0.85*screenwidth) (screenheight-0.85*screenheight) (screenwidth*0.5) (screenheight*0.5)]);
end
barlength=NOD*24;index=0;do=0;

%% Open statisticsfile
statisticsfile=[outputfolder,filesep,'Statistics_AHF_',num2str(YYYY),'_',num2str(DOY),'_',cityname,'_',num2str(SP),'_',num2str(F),'.txt'];
fn=fopen(statisticsfile,'w');
fprintf(fn,'%9s','DOY','hour','QmMean','QmMin','QmMax','QmMed','QmStd','QmIqr',...
    'QvMean','QvMin','QvMax','QvMed','QvStd','QvIqr','QbMean','QbMin','QbMax','QbMed','QbStd','QbIqr',...
    'AHFMean','AHFMin','AHFMax','AHFMed','AHFStd','AHFIqr');
fprintf(fn,'\r\n');
stats=zeros(1,6);

%% Main loop
for DOY=DOY:DOY+NOD-1
    % calculate day of week (Monday-Sunday=1-7).
    % bugfix 20120414, -1 because weekday.m use Sunday as first day of week
    D=weekday(startdate+do-1);
    
    % creating holidaygrid (day_DOY)
    holidaygrid=countries;
    holidays=[fixedpublicholidays(:,DOY);NaN];
    for i=1:size(foundcountries,1)%Populating each country with holiday=0 or workday=1
        holidaygrid(holidaygrid==foundcountries(i,1))=holidays(foundcountries(i,2));
    end
    
    % Loading and scaling temperature dataset (moved out from hour loop)
    avtemp=TemperatureWeighting_v6(DOY,latmax,latmin,lonmin,lonmax,WD,...
        use_opt,opt_path,startdate,do,balancegrid,HDDgrid,CDDgrid,res,...
        datafolder,latmintile,latmaxtile,lonmintile,lonmaxtile);
    
    for H=0:23
        %Show the progressbar if the images are not shown
        if showimage ~= 'y'
            progressbar(index/barlength,0);
        end
        fprintf(fn,'%9.3f',DOY,H);
        
        % CALCULATE METABOLIC HEAT
        Hour_people=countries;
        metahour=[metabolismhour(:,H+1);NaN];
        for i=1:size(foundcountries,1)%Populating each country with W per person
            Hour_people(Hour_people==foundcountries(i,1))=metahour(foundcountries(i,2));
        end
        %Hour_people is 75 Watts per person at night, 175 W during daytime and 125 W in %transition hours
        metab = popcell.*Hour_people;
        % divide total W from people in cell by m2 to get Wm-2:
        metab_wm2city = metab./(cellsize_km2_reduc*1000000);
        
        % CALCULATE TRAFFIC HEAT
        D2=countries;
        wkendday=[weekendday(:,D);NaN];
        for i=1:size(foundcountries,1)%Populating each country with weekday(0) or weekend(1)
            D2(D2==foundcountries(i,1))=wkendday(foundcountries(i,2));
        end
        
        daysoff=D2+holidaygrid;
        daysoff(daysoff==2)=1;
        
        Hour_wkend=countries;
        wkendhour=[weekendhour(:,H+1);NaN];
        for i=1:size(foundcountries,1)%Populating each country with hour traffic fraction
            Hour_wkend(Hour_wkend==foundcountries(i,1))=wkendhour(foundcountries(i,2));
        end
        H2city=Hour_wkend.*daysoff;
        daysoff(daysoff==1)=2; daysoff(daysoff==0)=1; daysoff(daysoff==2)=0;
        
        Hour_wkday=countries;
        wkdayhour=[weekdayhour(:,H+1);NaN];
        for i=1:size(foundcountries,1)%Populating each country with hour traffic fraction
            Hour_wkday(Hour_wkday==foundcountries(i,1))=wkdayhour(foundcountries(i,2));
        end
        H3city=Hour_wkday.*daysoff;
        H4city=H2city+H3city;
        
        %calculate heat emissions depending on vehicle type and speed
        %EC is car energy (petrol cars), EF is freight energy and EM is motorbike energy in Wm-1
        if SP==16
            EC=41.21;
            EF=162.13;
            EM=22.01;
        elseif SP==24
            EC=35.4;
            EF=141.21;
            EM=18.805;
        elseif SP==32
            EC=29.59;
            EF=120.29;
            EM=15.6;
        elseif SP==40
            EC=27.755;
            EF=114.355;
            EM=14.38;
        elseif SP==48
            EC=25.92;
            EF=108.42;
            EM=13.16;
        elseif SP==56
            EC=25.33;
            EF=106.685;
            EM=14.815;
        elseif SP==64
            EC=24.74;
            EF=104.95;
            EM=16.47;
        end
        
        %cars
        carcellenergy= carscell .* H4city * EC * (SP*1000);
        carenergytotal=carcellenergy./(cellsize_km2_reduc*1000000);
        carenergymeancity=carenergytotal/3600;
        %freight
        freightcellenergy= freightcell .* H4city * EF * (SP*1000);
        freightenergytotal=freightcellenergy./(cellsize_km2_reduc*1000000);
        freightenergymeancity=freightenergytotal/3600;
        %motorbikes
        mbikescellenergy= mbikescell .* H4city * EM * (SP*1000);
        mbikesenergytotal=mbikescellenergy./(cellsize_km2_reduc*1000000);
        mbikesenergymeancity=mbikesenergytotal/3600;
        private_vehicles=mbikesenergymeancity+carenergymeancity;
        %add all vehicle energy together
        vehiclestotal=private_vehicles+freightenergymeancity;
        H2city(H2city>0)=0.8; H2city(H2city==0)=1;
        vehicles_wm2city=vehiclestotal.*H2city;
        
        % CALCULATE BUILDING HEAT
        energy_hour=(Hour_wkend)/(1/24);
        %calculate hourly consumption of energy by multiplying to get daily total
        %and then multiplying by percentage
        energy_whourscaled=energy_w.*energy_hour;
        
        energy_w_temp=energy_whourscaled.*avtemp;
        %final energy calculation
        energy_wm2city=energy_w_temp./(cellsize_km2_reduc*1000000);
        
        % CALCULATE TOTAL AHF
        ahf=energy_wm2city+metab_wm2city+vehicles_wm2city;
        ahf=ahf.*urbanareas;
        ahfmean=ahfmean+ahf;
        
        % Londonyear matfile
        ahfLondon(:,:,index+1)=ahf;
        
        % Use for plotting
        if showimage=='y'
            set(clf,'color',[1 1 1])
            imagesc(ahf, [0 80]),colorbar,axis image
            hold on
            imcontour(countries,foundcountries(:,1),':k');
            hold off
            title(['Anthropogenic Heat Flux for ',cityname, ' on ',datestr(startdate+do),' at ',num2str(H+1), ' (W m^{-2})']);
            pause(0.1);
        end
        
        % CALCULATE STATISTICS
        metab_wm2city=metab_wm2city.*mask;
        stats(1)=nanmean(metab_wm2city(:));
        stats(2)=nanmin(metab_wm2city(:));
        stats(3)=nanmax(metab_wm2city(:));
        stats(4)=nanmedian(metab_wm2city(:));
        stats(5)=nanstd(metab_wm2city(:));
        stats(6)=iqr(metab_wm2city(:));
        vehicles_wm2city=vehicles_wm2city.*mask;
        stats(7)=nanmean(vehicles_wm2city(:));
        stats(8)=nanmin(vehicles_wm2city(:));
        stats(9)=nanmax(vehicles_wm2city(:));
        stats(10)=nanmedian(vehicles_wm2city(:));
        stats(11)=nanstd(vehicles_wm2city(:));
        stats(12)=iqr(vehicles_wm2city(:));
        energy_wm2city=energy_wm2city.*mask;
        stats(13)=nanmean(energy_wm2city(:));
        stats(14)=nanmin(energy_wm2city(:));
        stats(15)=nanmax(energy_wm2city(:));
        stats(16)=nanmedian(energy_wm2city(:));
        stats(17)=nanstd(energy_wm2city(:));
        stats(18)=iqr(energy_wm2city(:));
        ahf=ahf.*mask;
        stats(19)=nanmean(ahf(:));
        stats(20)=nanmin(ahf(:));
        stats(21)=nanmax(ahf(:));
        stats(22)=nanmedian(ahf(:));
        stats(23)=nanstd(ahf(:));
        stats(24)=iqr(ahf(:));
        fprintf(fn,'%9.3f',stats);
        fprintf(fn,'\r\n');
        
        % Saving AHF grid
        ahf(isnan(ahf))=-9999;
        ahf=double(ahf);
        ahffilename=['AHF_',num2str(cityname),'_',num2str(H),'_',num2str(D),'_',num2str(DOY),'_',num2str(SP),'_',num2str(F),'.asc'];
        save([foldername,filesep,ahffilename],'ahf','-ASCII');
        
        index=index+1;
    end
    if H==24
        H=0;
    end
    do=do+1;
end

%% Saving AHFmean grid
ahfmean=double(ahfmean/(NOD*24));
ahfmean(isnan(ahfmean))=-9999;
ahffilename=['AHFmean_',num2str(cityname),'_',num2str(H),'_',num2str(D),'_',num2str(DOY),'_',num2str(SP),'_',num2str(F),'.asc'];
save([foldername,filesep,ahffilename],'ahfmean','-ASCII');
fclose(fn);
%% Close the progressbar
if showimage ~= 'y'
    progressbar(1,0);
end
pause(2)
if showimage=='y'
    close
end

