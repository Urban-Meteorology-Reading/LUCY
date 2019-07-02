function [balancegrid,HDDgrid,CDDgrid]=populatecountrygridHDDCDD_v1(countries,WD,datafolder,YYYY)

countrystatustable=importdata([WD,filesep,datafolder,filesep,'CountriesEconomicStatus.txt']);
countrystatustable=countrystatustable.data;
datatable3=countrystatustable(2:size(countrystatustable,1),:);
% datatable3=countrystatustable(2:232,:);
countrystatusyeartab=findclosestyear(datatable3,YYYY);
ecostattab1=countrystatusyeartab-1900+1;

currentcountries=unique(countries);
currentcountries=currentcountries(currentcountries>0);
IDtable=importdata([WD,filesep,datafolder,filesep,'IDcomp.txt']);
IDtable=IDtable.data;
foundcountries=IDtable(currentcountries,:);

for i=1:231
    if isnan(ecostattab1(i))
        ecostattab2(i)=NaN;
    else
        ecostattab2(i)=countrystatustable(i+1,ecostattab1(i));
    end
end
ecostattab2=[ecostattab2';NaN];

weightmatrix=importdata([WD,filesep,datafolder,filesep,'ChangeEnergyperCDDHDD.txt']);
weightmatrix=weightmatrix.data;
noncooling=importdata([WD,filesep,datafolder,filesep,'CountriesSummerCooling.txt']);
noncooling=[noncooling.data;NaN];

balancepoint=ecostattab2;
HDDincrease=ecostattab2;
CDDincrease=ecostattab2;
for i=1:4
    balancepoint(balancepoint==i)=weightmatrix(i,1);
    HDDincrease(HDDincrease==i)=weightmatrix(i,2);
    CDDincrease(CDDincrease==i)=weightmatrix(i,3);
end
CDDincrease=CDDincrease.*noncooling;%Removing countries with no summer cooling
balancegrid=countries;
HDDgrid=countries;
CDDgrid=countries;

%Populating each country with balancepoint, HDD and CDD
for i=1:size(foundcountries,1)
    balancegrid(balancegrid==foundcountries(i,1))=balancepoint(foundcountries(i,2));
    HDDgrid(HDDgrid==foundcountries(i,1))=HDDincrease(foundcountries(i,2));
    CDDgrid(CDDgrid==foundcountries(i,1))=CDDincrease(foundcountries(i,2));
end


% balancegrid(:)=balancepoint(balancegrid);%Populating each country with balancepoint
% HDDgrid(:)=HDDincrease(HDDgrid);%Populating each country with balancepoint
% CDDgrid(:)=CDDincrease(CDDgrid);%Populating each country with balancepoint
