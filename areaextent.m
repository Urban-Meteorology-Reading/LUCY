function [ k] = areaextent(lat1, lat2, lon1,lon2, res)
% finding the number of grids in lat and long based on input resolution
nogla=round((lat2-lat1)./res);
noglon=round((lon2-lon1)./res);

%Calculating area of each grid cells

b=deg2rad(lat2);
a=deg2rad(res);
r=6378.135;
c=b-a;

% Loop for calculation of grid cell values
for i=1:nogla
    area= a*(sin(b)-sin(c))*(r)^2;
    for j=1:noglon
        k(i,j)=area;
    end
    b=b-a;
    c=c-a;
end
end