function []=exportGWP(YYYY,typeofdata,typename)

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

load([WD filesep 'Data' filesep 'DataGPW' filesep typeofdata YYYY '.mat']);
if strcmp(typename,'popcell')
    eval('data=popcell;')
    fn2=fopen([WD,'\ExportedDatasets\popcell_',num2str(YYYY),'.asc'],'w');
elseif strcmp(typename,'countries')
    eval('data=countries;')
    fn2=fopen([WD,'\ExportedDatasets\countries.asc'],'w');
elseif strcmp(typename,'citygrid')
    eval('data=citygrid;')
    fn2=fopen([WD,'\ExportedDatasets\urbanareas.asc'],'w');
end
data(isnan(data))=-9999;

for p=1:6
    fprintf(fn2,'%6s', header{p});
    fprintf(fn2,'\r\n');
end
for p=1:size(data,1)
    fprintf(fn2,'%6.4f ',data(p,:));
    fprintf(fn2,'\r\n');
end
fclose(fn2);
close(h)