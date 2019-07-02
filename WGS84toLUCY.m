function [x,y]=WGS84toLUCY(lat,long)

%Latitude
pixel=24;
y=round((85-(lat))*pixel);
x=round((180+long)*pixel);

