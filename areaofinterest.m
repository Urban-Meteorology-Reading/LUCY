
function [gridout]=areaofinterest(latmin,latmax,lonmin,lonmax,gridin,res)
% To get difference in lat& lon btw files and AOI
% To low adopted from tile pick
tolowlon=mod(lonmin,5);
tolowlat=mod((latmin+3),5);

% To high used to find diff in max values
% tohighlon=5- mod(abs(lonmax),5); %abs???
tohighlon=5- mod((lonmax),5);
tohighlat=5- mod((latmax+3),5);  

%latminadj & lonminadj used to crop the output
% 
% latminadj=latmin-tolowlat;
% lonminadj=lonmin-tolowlon;

diflonmin=round(tolowlon/res);
diflatmin=round(tolowlat/res);
diflonmax=round(tohighlon/res);
diflatmax=round(tohighlat/res);

% To get area of interest based 

% gridout=gridin(1+diflatmin:size(gridin,1)-diflatmax,1+diflonmin:size(gridin,2)-diflonmax);
gridout=gridin(1+diflatmax:size(gridin,1)-diflatmin,1+diflonmin:size(gridin,2)-diflonmax);
end



