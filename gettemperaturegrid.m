function [datagrid]=gettemperaturegrid(INPUT,dayswithtemp,DOY)

% ncID=netcdf.open(INPUT,'NC_NOWRITE');
% datagrid=netcdf.getVar(ncID,varid);
% netcdf.close(ncID)

ncID=netcdf.open(INPUT,'NC_NOWRITE');
datagrid=netcdf.getVar(ncID,3,[0,0,DOY-dayswithtemp(1)],[8640,3432,DOY-dayswithtemp(1)+1]);
MissVal=str2num(netcdf.getAtt(ncID,netcdf.getConstant('NC_GLOBAL'),'missing_value'));
datagrid(datagrid==MissVal)=NaN;
netcdf.close(ncID)