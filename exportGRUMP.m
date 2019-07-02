function []=exportGRUMP(YYYY,typeofdata,typename,lat,lon)

h=PleaseWait();

WD=pwd;
if(exist([WD filesep 'ExportedDatasets'],'dir')==0)
    mkdir([WD filesep 'ExportedDatasets']);
end

DELIMITER = ' ';
HEADERLINES = 6;
header = importdata([WD,filesep,'Data',filesep,'EsriAsciiHeader.txt'], DELIMITER, HEADERLINES);
for i=1:6
    [cell,rest]=strtok(header{i},' ');
    headernum(i,:)=cellstr(rest);
    headername(i,:)=cellstr(cell);
end
headernumnew{1}=num2str(abs(600));
headernumnew{2}=num2str(abs(600));
headernumnew{3}=num2str(lon);
headernumnew{4}=num2str(lat);
headernumnew{5}=num2str(double(30/3600));
headernumnew{6}=num2str(-9999);

% option to save as ESRI ascii grid
if strcmp(typename,'population')
    load([WD filesep 'Data' filesep typeofdata filesep typeofdata '_' YYYY filesep ...
        typename num2str(lat) '_' num2str(lon) '.mat']);
    fn2=fopen([WD,'\ExportedDatasets\popcellGRUMP_',num2str(YYYY) '_lat' num2str(lat) ...
        '_lon' num2str(lon),'.asc'],'w');
elseif strcmp(typename,'countries')
    load([WD filesep 'Data' filesep typeofdata filesep typename num2str(lat) '_' num2str(lon) '.mat']);
    fn2=fopen([WD,'\ExportedDatasets\countriesGRUMP_lat' num2str(lat) '_lon' num2str(lon) '.asc'],'w');
elseif strcmp(typename,'urban')
    load([WD filesep 'Data' filesep typeofdata filesep typename num2str(lat) '_' num2str(lon) '.mat']);
    fn2=fopen([WD,'\ExportedDatasets\urbanGRUMP_lat' num2str(lat) '_lon' num2str(lon) '.asc'],'w');
end
data(isnan(data))=-9999;

for p=1:6
    fprintf(fn2,'%5s ', headername{p});
    fprintf(fn2,'%10.15s ', char(headernumnew{1,p}));
    fprintf(fn2,'\r\n');
end
for p=1:size(data,1)
    fprintf(fn2,'%6.4f ',data(p,:));
    fprintf(fn2,'\r\n');
end
fclose(fn2);
close(h)