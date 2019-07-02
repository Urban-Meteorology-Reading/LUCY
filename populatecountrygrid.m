function [gridout,foundcountries]=populatecountrygrid(countries,WD,datafolder,statdatafile,YYYYtabdata)

table1=importdata([WD,filesep,datafolder,filesep,statdatafile]);
table1=table1.data;
table1=table1(2:size(table1,1),:);
gridout=countries;
tab1=YYYYtabdata-1900+1;

currentcountries=unique(countries);
currentcountries=currentcountries(currentcountries>0);

IDtable=importdata([WD,filesep,datafolder,filesep,'IDcomp.txt']);
IDtable=IDtable.data;

foundcountries=IDtable(currentcountries,:);

for i=1:size(foundcountries,1)
    if isnan(tab1(foundcountries(i,2)))
        gridout(gridout==foundcountries(i,1))=NaN;
    else
        gridout(gridout==foundcountries(i,1))=table1(foundcountries(i,2),tab1(foundcountries(i,2)));
    end
end

% for i=1:231
%     if isnan(energytab1(i))
%         energytab2(i)=NaN;
%     else
%         energytab2(i)=energytable(i+1,energytab1(i));
%     end
% end
% energytab2=[energytab2';NaN];
% 
% energy(:)=energytab2(energy);%Populating each country with energy



