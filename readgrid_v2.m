function [INPUT lista]=readgrid_v2
% program to read KUMA netcdf grid files for LUCY input
% simone kotthaus, 06/10/2010
% fredrik lindberg, 13/10/2010

clear
% open ncdf file
[inputfile directory]=uigetfile('*.nc');
INPUT=fullfile(directory,inputfile);
ncID=netcdf.open(INPUT,'NC_NOWRITE');

% general information -----------------------------------------------------
% ndims = number of dimensions
% nvars = number of variables
% ngatts= number global attributes
% unlimited = id of unlimited 'time' dimension
[ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncID);

% get names of all global attributes
gAttNames=cell(1,ngatts);
gAtt=cell(1,ngatts);
for v=1:ngatts
    gAttNames{v}=netcdf.inqAttName(ncID,netcdf.getConstant('NC_GLOBAL'),v-1);
    gAtt{v}=netcdf.getAtt(ncID,netcdf.getConstant('NC_GLOBAL'),char(gAttNames{v}));
end

% get Info on first variable in file
% Name = name of variable
% dimids  = id of dimensions
% xtype   = data type
% natts   = number of variable attributes
[Name,xtype,dimids,natts]=netcdf.inqVar(ncID,ndims);
%  disp(['[',num2str(ndims),']  ',Name]);
% list all other variable names in the file
lista{1}=' ';
if nvars-ndims>1
    index=2;
    for v=ndims:(nvars-1)
        varname=netcdf.inqVar(ncID,v);
        lista{index}=(['[',num2str(v),']  ',varname]);
        index=index+1;
    end
else
    varname=netcdf.inqVar(ncID,3);
    lista{2}=['[',num2str(3),']  ',varname];
end
lista=lista';
% varid=input('select variable: ');
netcdf.close(ncID)
% retrieve data for that variable -----------------------------------------
% DATA=netcdf.getVar(ncID,varid);
% plot data to check if map is alright
% imagesc(DATA'); figure(gcf)

% get attributes for this variable
% vAttNames=cell(1,natts);
% vAtt=cell(1,natts);
% for v=1:natts
%     vAttNames{v}=netcdf.inqAttName(ncID,varid,v-1);
%     vAtt{v}=netcdf.getAtt(ncID,varid,char(vAttNames{v}));
% end