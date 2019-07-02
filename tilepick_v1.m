function [grid,latmintile,latmaxtile,lonmintile,lonmaxtile]=tilepick_v1(latmin,latmax,lonmin,lonmax,gridname,WD,datafolder,YYYYclose)
row=[];
grid=[];
tolowlon=mod(lonmin,5);
tolowlat=mod(latmin+3,5);
%tohighlat=mod(latmax,5);

% latminadj and lonmin adj introduced to cut ROI 
latminadj=latmin-tolowlat;
lonminadj=lonmin-tolowlon;


if strcmp(gridname,'countries')==1 || strcmp(gridname,'urban')==1
    % countries and urban
    for i=latminadj:5:latmax
        for j=lonminadj:5:lonmax
            if(exist([WD filesep datafolder filesep gridname filesep gridname num2str(i) '_' num2str(j) '.mat'],'file')==0)
                data=zeros([600,600],'single');%Create empty matrix
            else
                load([WD filesep datafolder filesep gridname filesep gridname num2str(i) '_' num2str(j) '.mat']);
            end
            row=[row data];
        end
        grid=[row; grid];
        row=[];
    end
    grid(grid==0)=NaN;
else
    % population
    for i=latminadj:5:latmax
        for j=lonminadj:5:lonmax
            if(exist([WD filesep datafolder filesep gridname filesep gridname '_' num2str(YYYYclose) filesep gridname num2str(i) '_' num2str(j) '.mat'],'file')==0)
                data=zeros([600,600],'single');%Create empty matrix
            else
                load([WD filesep datafolder filesep gridname filesep gridname '_' num2str(YYYYclose) filesep gridname num2str(i) '_' num2str(j) '.mat']);
            end
            row=[row data];
        end
        grid=[row; grid];
        row=[];
    end
    grid(grid==0)=NaN;
end

latmintile=latminadj;
latmaxtile=i+5;
lonmintile=lonminadj;
lonmaxtile=j+5;