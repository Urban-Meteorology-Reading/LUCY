function avtemp=ImportWillmot_v2(startdate,do)
WD=pwd;
YYYY=datevec(startdate+do);
YYYY=YYYY(1);
mon=month(startdate+do);

data=importdata([WD,'\Data\temperature\air_temp.',num2str(YYYY)]);
lon=data(:,1);
lat=data(:,2);
lonpos=ceil((lon+180)*2);
latpos=ceil((lat+90)*2);
Z=nan(360,720);
% [Z,refvec] = nanm([-90,90],[-180,180],2);

for i=1:size(lon)
    Z(latpos(i),lonpos(i))=data(i,mon+2);
end
Z=flipud(Z);

Z=Z(5*2+1:360-((90-58)*2),:);

avtempfilled=fillcoast(Z);

avtemp = imresize(avtempfilled, 12,'nearest');