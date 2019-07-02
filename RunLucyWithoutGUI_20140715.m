%%%%%%%%%%%%%%%%%%%%%%
% Anthropogenic heat flux model
% Lucy Allen, July 2009
% Department of Geography, King's College London, UK
% [Large scale Urban Consumption of energY] - LUCY
%
% --SIGNIFICANT UPDATES--
% 2010-02-04;   Modified by Fredrik Lindberg to run without changing the
%               core code
% 2010-08-07;   Designed to run with the LUCY GUI
% 2010-09-05;   Update to new version 2.0 to include temperature changes
% 2010-11-03;   Update to V2.1 to reduce the number of grids used as inputdata
% 2011-01-05;   LUCY_21_core_large.m created to cope with large modeldomains
% 2011-02-11;   Update to version 3 to include year variable
% 2013-04-01;   Update to 2013a
% 2013-05-18;   Update to 2013b
% 2014-06-14;   Update to 2014a

%% Inputdata
% startdate - datenumber ('Jan-1-0000 = 1)
% SP  - average speed of vehicles,
% F   - factor multiplying total vehicles to get number of vehicles on road
% WD  - Working directory
% NOD - number of days to run
% cityname - string that will be included in foldername
% showimage - show image during execution
% use_opt - option to use optional daily temperature grids (optional)
% opt_path - Location of netcdf file (optional)
% statreg - Used in GUI (not needed)
% onlyurban - Only consider pixels classified as urban (0 or 1)
% latmin
% lonmin
% latmax
% lonmax
% res - GRUMP resolution in arcseconds; tested:30,60,150,300,600,1200 and 1800
% pop - 1=GRUMP (spatially dynamic) or 2=GWP (fixed at 2.5 arc-minutes(150 sec));
% outputfolder 
% asciigrid - option to save as ESRI ascii grid

%% Start program
clear
startdate = datenum([2000 02 14]);
SP=48;
F=0.8;
WD=pwd;
NOD=1;
showimage='y';
cityname='trial1';
use_opt=0;
opt_path=[];
statreg=[0 0];
onlyurban=1;

% %London
latmin=51.25;
lonmin=-0.60;
latmax=51.75;
lonmax=0.40;

%WestEurope
% latmin=50.11;
% lonmin=-0.9;
% latmax=52.0;
% lonmax=5.0;

res=30;%arcseconds
pop=1;%1=GRUMP (spatially dynamic) or 2=GWP (fixed at 2.5 arc-minutes)';
datafolder='Data';
outputfolder='C:\temp\output\';
asciigrid=0;% option to save as ESRI ascii grid

% Check statistic tables for available data
[use_opt,YYYYclose,YYYYtabdata]=LUCY_datasummary_v2cmd(startdate,use_opt,WD,datafolder,pop,latmax,latmin,lonmin,lonmax);

%% Main core
if pop==2 %GWP data
    res=150;%arcseconds
    [W,S]=WGS84toLUCY(latmin,lonmin);
    [E,N]=WGS84toLUCY(latmax,lonmax);
    popgrid=LUCY_4_core(startdate,SP,F,N,S,W,E,WD,NOD,cityname,showimage,use_opt,...
        opt_path,YYYYclose,YYYYtabdata,statreg,onlyurban,outputfolder);
else %GRUMP data
    popgrid=LUCY_2013b_core(startdate,SP,F,latmax,latmin,lonmin,lonmax,WD,NOD,cityname,showimage,use_opt,...
        opt_path,YYYYclose,YYYYtabdata,statreg,onlyurban,res,datafolder,outputfolder);
end

%% Creating Esri ascii header
[ latmin,latmax,lonmin,lonmax ] = adjextent( latmin,latmax,lonmin,lonmax,res );
DELIMITER = ' ';
HEADERLINES = 6;
header = importdata([WD,filesep,'Data',filesep,'EsriAsciiHeader.txt'], DELIMITER, HEADERLINES);
for i=1:6
    [cell,rest]=strtok(header{i},' ');
    headernum(i,:)=cellstr(rest);
    headername(i,:)=cellstr(cell);
end

headernumnew{1}=num2str((abs(lonmax-lonmin)/(res/3600)));
headernumnew{2}=num2str((abs(latmax-latmin)/(res/3600)));
headernumnew{3}=num2str(lonmin);
headernumnew{4}=num2str(latmin);
headernumnew{5}=num2str(double(res/3600));
headernumnew{6}=num2str(-9999);

% option to save as ESRI ascii grid
if asciigrid==1
    y=dir([outputfolder filesep 'Grids']);
    for i=3:length(y)
        grids=importdata([outputfolder filesep 'Grids' filesep y(i).name]);
        
        fn2=fopen([outputfolder filesep 'Grids' filesep filesep y(i).name],'w');
        for p=1:6
            fprintf(fn2,'%5s ', headername{p});
            fprintf(fn2,'%10.15s ', char(headernumnew{1,p}));
            fprintf(fn2,'\r\n');
        end
        fclose(fn2);
        save([outputfolder filesep 'Grids' filesep filesep y(i).name],'grids','-append','-ASCII')
    end
else
    fn2=fopen([outputfolder,filesep,'EsriAsciiHeader_' (cityname) '.txt'],'w');
    for p=1:6
        fprintf(fn2,'%5s ', headername{p});
        fprintf(fn2,'%10.15s ', char(headernumnew{1,p}));
        fprintf(fn2,'\r\n');
    end
    fclose(fn2);
end
