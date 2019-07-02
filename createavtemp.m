
WD='D:';
do=1;
monthname={'jan';'feb';'mar';'apr';'may';'jun';'jul';'aug';'sep';'oct';'nov';'dec'};
for j=1:12
    avtempmon=zeros(360,720);
    for i=1971:2000
        startdate=datenum(i,j,do);
        avtemp=ImportWillmot_v4(startdate,do,WD);
%         imagesc(avtemp,[-50 40]),axis image,colorbar,pause(0.1)
        avtempmon=avtempmon+avtemp;
        i
        j
    end
    avtemp=avtempmon/30;
    avtemp=single(avtemp);
    save(['avtemp_' monthname{j} '70_00.mat'],'avtemp')
end