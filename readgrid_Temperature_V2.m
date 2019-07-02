function [dayswithtemp] =readgrid_Temperature_V2(INPUT) 
% program to read KUMA netcdf grid files for LUCY input
% simone kotthaus, 06/10/2010

% clear
% open ncdf file
% [inputfile directory]=uigetfile('*.nc');
% INPUT=fullfile(directory,inputfile);
ncID=netcdf.open(INPUT,'NC_NOWRITE');

% general information -----------------------------------------------------
% [dimnamelon, dimlenlon] = netcdf.inqDim(ncID,0);
% [dimnamelat, dimlenlat] = netcdf.inqDim(ncID,1);
% get length of time axis
% [dimnametime, dimlentime] = netcdf.inqDim(ncID,2);
% timeUnits         = netcdf.getAtt(ncID,2,'units');
% get time values, stored reletive to reference time
timeVar           = netcdf.getVar(ncID,2);
dayswithtemp=timeVar+1;
% convert relative time axis to absolute time axis
% [timeAxis]        = rel2absTime(timeVar,timeUnits);

% first     =datevec(timeAxis(1));
% last      =datevec(timeAxis(length(timeAxis)));
% [firstDOY]=date2julian(first(1),first(2),first(3));
% [lastDOY] =date2julian(last(1),last(2),last(3));
% disp(['year = ',int2str(first(1))])
% DOY=input(['choose start date as DOY between ',sprintf('%03d',firstDOY),' and ',sprintf('%03d',lastDOY),':']);
% ndays=input('number of days to be processed:');
% disp('loading data, please be patient ...')
% DATA      =netcdf.getVar(ncID,3,[0,0,DOY-firstDOY],[dimlenlon,dimlenlat,(DOY-firstDOY)+(ndays-1)]);

% MissVal   =str2num(netcdf.getAtt(ncID,netcdf.getConstant('NC_GLOBAL'),'missing_value'));
% DATA(DATA==MissVal)=NaN;
% DailyDATA =cell(1,ndays);
% for n=1:ndays; DailyDATA{n} = DATA(:,:,n)'; end
netcdf.close(ncID)





