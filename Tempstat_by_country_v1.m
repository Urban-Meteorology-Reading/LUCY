% This m-file calculates CDD and HDD by country using 60-91 temperature
% data. Only gridcells over urban areas are used.

clear all

%% Constants
WD=pwd;
datafolder='Data';
monthname=['jan';'feb';'mar';'apr';'may';'jun';'jul';'aug';'sep';'oct';'nov';'dec'];
monthlength=[31 28 31 30 31 30 31 31 30 31 30 31];
do=0;
tempbal=12;

%% Load Spatial data
load([WD,'\',datafolder,'\countries.mat']);

load([WD,'\',datafolder,'\citygrid.mat']);
citygrid(citygrid==-9999)=NaN;
citygrid(citygrid>0)=1;

courban=citygrid.*countries;

clear countries citygrid

%% Loop for calculating mean tempreature for country using Willmot data
% for i=1980:2008
%     for j=1:12
%         startdate=datenum([i j 1]);
%         avtemp=ImportWillmot_v2(startdate,do);
%         
%         disp([num2str(i),' ', num2str(monthname(j,:))])
%         for k=1:231 %looping through every country
%             
%             temp=avtemp(courban==k);
%             tempstats(k,j,i-1979)=nanmean(temp);
%             
%         end
%         
%     end
% end
% clear temp
% load tempstat

% Loop for calculating CDD and HDD
% CDD=zeros(231,29);HDD=CDD;
% for i=1:29 %Years
%     for j=1:231 %looping through every country
%         for k=1:12 %Months
%             temp=abs(tempbal-tempstats(j,k,i));
%             if tempstats(j,k,i)>12
%                 CDD(j,i)=temp*monthlength(k)+CDD(j,i);
%             else
%                 HDD(j,i)=temp*monthlength(k)+HDD(j,i);
%             end
%         end
%         
%     end
% end

%% Loop for calculating mean tempreature for country using 61-90 data

    for j=1:12
        
        load ([WD,'\Data\temperature\avtemp_',monthname(j,:),'.mat']);
        
        disp(num2str(monthname(j,:)))
        for k=1:231 %looping through every country
            
            temp=avtemp(courban==k);
            tempstats(k,j)=nanmean(temp);
            
        end
        
    end

clear temp

CDD=zeros(231,12);HDD=CDD;

    for j=1:231 %looping through every country
        for k=1:12 %Months
            temp=abs(tempbal-tempstats(j,k));
            if tempstats(j,k)>12
                CDD(j,k)=temp*monthlength(k)+CDD(j,k);
            else
                HDD(j,k)=temp*monthlength(k)+HDD(j,k);
            end
        end
        
    end

%% plotting
textCountry=importdata([WD,'\Data\CountryID.txt'],';');
index=1;plotnr=1;
for i=1:10
    for j=1:5
        for k=1:5
            subplot(5,5,plotnr),plot(CDD(index,:)),hold on
            plot(HDD(index,:),'r')
            set(gca,'ylim',[0 1000],'xlim',[1 12],'FontSize',6),axis square
            title([textCountry.textdata(index,2),'  HDD/CDD= ' num2str(sum(HDD(index,:))/sum(CDD(index,:)))]...
                ,'fontsize',6)
            index=index+1;plotnr=plotnr+1;
            if plotnr==26,plotnr=1;pause;hold off;close; end
        end
    end
end

%     plot(CDD(i,:)),hold on
%     plot(HDD(i,:),'r')
%     set(gca,'ylim',[0 1000],'xlim',[1 12])
%     legend('CDD','HDD')
%     close
% end

%% Calculating totalpopulation   
for k=1:231 %looping through every country
    temp=totalpopu(countries==k);
    popstats(k,1)=nanmean(temp);
end
        

