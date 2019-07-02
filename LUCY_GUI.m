function varargout = LUCY_GUI(varargin)

% A graphical user interface to run LUCY
% Fredrik Lindberg
% fredrikl@gvc.gu.se


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @LUCY_GUI_OpeningFcn, ...
    'gui_OutputFcn',  @LUCY_GUI_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before LUCY_GUI is made visible.
function LUCY_GUI_OpeningFcn(hObject, ~, handles, varargin)

% Choose default command line output for LUCY_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = LUCY_GUI_OutputFcn(hObject, eventdata, handles)

% Get default command line output from handles structure
varargout{1} = handles.output;

function ChangeDate_Callback(hObject, ~, handles)
selectedDate = uical([2005 01 01],'en');
set(handles.date,'Value',selectedDate)
guidata(hObject, handles);
if selectedDate>767010 || selectedDate<693962
    msgboxText{1} =  'Choose a date between 01/01/1900 and 31/12/2099';
    msgbox(msgboxText,'Date has to be between 01/01/1900 and 31/12/2099', 'error');
end
set(handles.date, 'String', datestr(selectedDate, 24));
% set(handles.pushbutton_Run,'Enable','off')

function edit_NOD_Callback(hObject, ~, handles)
input = str2double(get(hObject,'String'));
input=floor(input);
if input>366 || input<0
    msgboxText{1} =  'Choose a new number between 1 and 365';
    msgbox(msgboxText,'Number has to be between 1 and 365', 'error');
end
startdate=get(handles.date,'Value');
YYYY=datevec(startdate);
YYYY=YYYY(1);
DOY=datenum(startdate)+1-datenum(YYYY,1,1);
if input+DOY-1>365
    msgboxText{1} =  ['The LUCY model is only able to run days';
        'belonging to the same year.            ';
        'Devide your execution in two or more   ';
        'parts, one for each year.              '];
    msgbox(msgboxText,'Time period runs over more than 1 year', 'error');
end
guidata(hObject, handles);

function edit_NOD_CreateFcn(hObject, ~, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_P_Callback(hObject, ~, handles)
input = str2double(get(hObject,'String'));
if input>1 || input<0
    msgboxText{1} =  'Choose a decimal number between 0 and 1';
    msgbox(msgboxText,'Number has to be between 0 and 1', 'error');
end
guidata(hObject, handles);

function edit_P_CreateFcn(hObject, ~, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu_SP_Callback(hObject, ~, handles)
contents = get(hObject,'String');
contents{get(hObject,'Value')};
guidata(hObject, handles);

function popupmenu_SP_CreateFcn(hObject, ~, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pushbutton_region_Callback(hObject, ~, handles)
WD=pwd;
load([WD,filesep,'Data',filesep,'countriesforgui.mat']);
% countries2=zeros((size(countries,1)/4),(size(countries,2)/4));
% for i=1:(size(countries,1)/4)
%     for j=1:(size(countries,2)/4)
%         countries2(i,j)=countries(i*4,j*4);
%     end
% end
screensize=get(0,'ScreenSize');
screenwidth=screensize(3);
screenheight=screensize(4);
%The figure takes the 70% of the screen
figure('Position',[(screenwidth-0.85*screenwidth) (screenheight-0.85*screenheight) (screenwidth*0.7) (screenheight*0.7)]);
imagesc(countries), axis image,title('Click at SOUTHWEST corner of region of interest'), hold on
set(gca,'Ytick',[],'Xtick',[])
A=ginput(1);
W=-180+((floor(A(1,1)))*(10/60));
S=85-((floor(A(1,2)))*(10/60));
plot(A(1,1),A(1,2),'r +');
title('Click at NORTHEAST corner of region of interest')
B=ginput(1);
E=-180+((floor(B(1,1)))*(10/60));
N=85-((floor(B(1,2)))*(10/60));
hold off
close
clear countries
tid=now;
set(handles.pushbutton_region, 'UserData', [E N S W tid]);
guidata(hObject, handles);
% uiwait()
Regionname();

% Selection of lat/lon coordinates for model domain
function pushbutton_coord_Callback(hObject, ~, handles)
LatLongSelection();
guidata(hObject, handles);
% uiwait()
% Regionname();

% Selection of country for model domain
function pushbutton_country_Callback(hObject, ~, handles)
CountrySelection();
guidata(hObject, handles);

% Selection of population dataset
function popupmenu_pop_Callback(hObject, eventdata, handles)
% pop = get(hObject,'String');
pop=get(hObject,'Value');
if pop==2
    set(handles.popupmenu_res,'Enable','off')
    set(handles.popupmenu_res,'String','2.5 arc-minute')
    set(handles.checkbox_temp,'Enable','on')
end
if pop==1
    set(handles.popupmenu_res,'Enable','on')
    inter={'30 arc-seconds';'1 arc-minute';'2.5 arc-minutes';'5 arc-minutes';
        '10 arc-minutes';'20 arc-minutes';'Half degree'};
    set(handles.popupmenu_res,'String',inter)
end
guidata(hObject, handles);

function popupmenu_pop_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Specifying resolution if GRUMP data is used.
function popupmenu_res_Callback(hObject, ~, handles)
res = get(hObject,'String');
res{get(hObject,'Value')};
guidata(hObject, handles);

function popupmenu_res_CreateFcn(hObject, ~, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Pushbutton for specifying output folder
function pushbutton_getfolder_Callback(hObject, ~, handles)
folder=uigetdir;
set(handles.edit_regionfoldername,'String',folder)
guidata(hObject, handles)

% box that specifies outputfolder name
function edit_regionfoldername_Callback(hObject, ~, handles)
get(hObject,'String');
guidata(hObject, handles);

function edit_regionfoldername_CreateFcn(hObject, ~, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Option to use daily temperature netcdf grid
function checkbox_temp_Callback(hObject, ~, handles)
get(hObject,'Value');
% if (get(handles.checkbox_temp,'Value'))==1
%     set(handles.pushbutton_browse_temp,'Visible','on')
% else
%     set(handles.pushbutton_browse_temp,'Visible','off')
% end
guidata(hObject, handles);

% Pushbutton for specifying netcdf file for daily temperature grid
function pushbutton_browse_temp_Callback(hObject, ~, handles)
[INPUT lista]=readgrid_v2;
nc_energy=struct('ncpath',INPUT);
set(handles.pushbutton_browse_temp,'UserData',nc_energy)
guidata(hObject, handles);

% Option for showing images during execution
function checkbox_showimage_Callback(hObject, ~, handles)
get(hObject,'Value');
guidata(hObject, handles);

% Option for only considering urban areas
function checkbox_onlyurban_Callback(hObject, ~, handles)
get(hObject,'Value');
guidata(hObject, handles);

% Option for saving as ERSIASCII grid
function checkbox_esri_Callback(hObject, ~, handles)
get(hObject,'Value');
guidata(hObject, handles);

% Option for saving population density grid
function checkbox_pop_Callback(hObject, ~, handles)
get(hObject,'Value');
guidata(hObject, handles);

% Bringing up the data summary window
function pushbutton_datasummary_Callback(hObject, ~, handles)
% startdate=get(handles.date,'Value');
% use_opt=get(handles.checkbox_temp,'Value');
% pop=get(handles.popupmenu_pop,'Value');
% WD=pwd;datafolder='Data';
% LUCY_datasummary_v2(startdate,use_opt,WD,datafolder,pop);
% % set(handles.pushbutton_datasummary,'Value',YYYYclose)
% set(handles.pushbutton_Run,'Enable','on')
% guidata(hObject, handles);

function pushbutton_Run_Callback(hObject, ~, handles)
WD=pwd;
outputfolder=get(handles.edit_regionfoldername,'String');
datafolder='Data';
userdata=getuserdir;
tempdir=[userdata filesep 'LUCY' filesep];
if exist(tempdir,'dir')
    if exist([tempdir 'tabdata.mat'],'file')
        delete([tempdir 'tabdata.mat'],[tempdir 'mbikestable.mat'],[tempdir 'YYYYclose.mat']...
            ,[tempdir 'YYYY.mat'],[tempdir 'tempday.mat'],[tempdir 'tempmonth.mat']);
    end
else
    mkdir(tempdir);
end
startdate=get(handles.date,'Value');
NOD = str2double(get(handles.edit_NOD,'String'));
SP = (get(handles.popupmenu_SP,'Value'));
F = str2double(get(handles.edit_P,'String'));
if SP==1,SP=48; elseif SP==2,SP=16; elseif SP==3,SP=24; elseif SP==4,SP=32;...
elseif SP==5,SP=40; elseif SP==6,SP=48; elseif SP==7,SP=56; elseif SP==8,SP=64;end
C=[];% C = get(handles.pushbutton_city,'UserData');
Co= get(handles.pushbutton_country,'UserData');
posCoord = get(handles.pushbutton_coord,'UserData');
posRegion= get(handles.pushbutton_region,'UserData');
showimage = (get(handles.checkbox_showimage,'Value'));
onlyurban= get(handles.checkbox_onlyurban,'Value');
pop=get(handles.popupmenu_pop,'Value');
res=get(handles.popupmenu_res,'Value');
if res==1,res=30; elseif res==2,res=60; elseif res==3,res=150; elseif res==4,res=300;...
elseif res==5,res=600; elseif res==6,res=1200; elseif res==7,res=1800;end
if pop==2, res=150;end
% slowexec = (get(handles.checkbox_memory,'Value'));

asciigrid=get(handles.checkbox_esri,'Value');
asciipopgrid=get(handles.checkbox_pop,'Value');
Citytime=0;% Citytime=get(handles.pushbutton_city,'Value');
if length(posRegion)==5
    Regiontime=posRegion(5);
else
    Regiontime=0;
end
Coordtime=get(handles.pushbutton_coord, 'Value');
Countrytime=get(handles.pushbutton_country, 'Value');

if isempty(C) && isempty(posCoord) && isempty(posRegion) && isempty(Co)
    msgboxText{1} =  'Choose one of the four region selection options in STEP 2';
    msgbox(msgboxText,'No spatial region choosen', 'error');
elseif isempty(outputfolder)
    msgboxText{1} =  'Specify outputfolder in STEP 4';
    msgbox(msgboxText,'No outputfolder specified', 'error');
else
    
    %Region specified by city number (Choice 1)
    if Citytime>Coordtime && Citytime>Regiontime && Citytime>Countrytime
        load([WD,filesep,'Data',filesep,'citygrid.mat']);
        citygrid(citygrid~=C)=0;
        longi=find(sum(citygrid));
        W=min(longi);
        E=max(longi);
        lati=find(sum(citygrid,2));
        N=min(lati);
        S=max(lati);
        clear citygrid
        fid=fopen([WD,filesep,'Data',filesep,'CityID.txt']);
        C_data=textscan(fid, '%d%s%s%f%f%d','delimiter', ';');
        fclose(fid);
        pos=C_data{6}==C;
        cityname=C_data{1,2};
        cityname=cityname{pos};
        statreg=[0 0];
    end
    
    %Region specified by country name (Choice 2)
    if Countrytime>Coordtime && Countrytime>Regiontime && Countrytime>Citytime
        WD=pwd;
        fid = fopen([WD,filesep,'Data',filesep,'CountryID.txt']);
        C_data=textscan(fid, '%d%s%d','delimiter', ';');
        fclose(fid);
        Co=Co-1;
        pos=C_data{3};
        pos=pos(Co);
        
        load([WD,filesep,'Data',filesep,'countriesforgui.mat']);
        countries(countries~=pos)=0;
        longi=find(sum(countries));
        W=min(longi);
        E=max(longi);
        lati=find(sum(countries,2));
        N=min(lati);
        S=max(lati);
        
        lonmin=-180+((floor(W))*(10/60));
        latmin=85-((floor(S))*(10/60));
        lonmax=-180+((floor(E))*(10/60));
        latmax=85-((floor(N))*(10/60));
        
        clear countries
        cityname=get(handles.text_countryname,'String');
        statreg=[1 Co];
    end
    
    %Region specified by world map  (Choice 3)
    if Regiontime>Coordtime && Regiontime>Citytime && Regiontime>Countrytime
        cityname=get(handles.text_cityname,'String');
        lonmax=posRegion(1);latmax=posRegion(2);latmin=posRegion(3);lonmin=posRegion(4);
        statreg=[0 0];
    end
    
    %Region specified by lat/lon  (Choice 4)
    if Coordtime>Regiontime && Coordtime>Citytime && Coordtime>Countrytime
        cityname=get(handles.text_cityname,'String');
        lonmin=posCoord(1);latmax=posCoord(2);latmin=posCoord(3);lonmax=posCoord(4);
        statreg=[0 0];
    end
    
    if showimage==1
        showimage='y';
    end
    
    % Optional temperature data information
    use_opt=get(handles.checkbox_temp,'Value');
    opt_path=[];
%     opt_path.temp=get(handles.pushbutton_browse_temp,'UserData');
    
    % data summary
    use_opt=LUCY_datasummary_v2(startdate,use_opt,WD,datafolder,pop,latmax,latmin,lonmin,lonmax);
    YYYYclose = (get(handles.pushbutton_datasummary,'Value'));
    YYYYtabdata = (get(handles.pushbutton_datasummary,'UserData'));
    
    % Core
    if pop==2 %GWP data
        [W,S]=WGS84toLUCY(latmin,lonmin);
        [E,N]=WGS84toLUCY(latmax,lonmax);
        popgrid=LUCY_4_core(startdate,SP,F,N,S,W,E,WD,NOD,cityname,showimage,use_opt,...
            opt_path,YYYYclose,YYYYtabdata,statreg,onlyurban,outputfolder);
    else %GRUMP data
        popgrid=LUCY_2013b_core(startdate,SP,F,latmax,latmin,lonmin,lonmax,WD,NOD,cityname,showimage,use_opt,...
            opt_path,YYYYclose,YYYYtabdata,statreg,onlyurban,res,datafolder,outputfolder);
    end
    %% Creating Esri ascii header
    [latmin,latmax,lonmin,lonmax]=adjextent(latmin,latmax,lonmin,lonmax,res);
    DELIMITER = ' ';
    HEADERLINES = 6;
    header = importdata([WD,filesep,'Data',filesep,'EsriAsciiHeader.txt'], DELIMITER, HEADERLINES);
    for i=1:6
        [cell,rest]=strtok(header{i},' ');
        headernum(i,:)=cellstr(rest);
        headername(i,:)=cellstr(cell);
    end
    headernumnew{1}=num2str(abs(lonmax-lonmin)/(res/3600));
    headernumnew{2}=num2str(abs(latmax-latmin)/(res/3600));
    headernumnew{3}=num2str(lonmin);
    headernumnew{4}=num2str(latmin);
    headernumnew{5}=num2str(double(res/3600));
    headernumnew{6}=num2str(-9999);
    
    % option to save as ESRI ascii grid
    if asciigrid==1
        y=dir([outputfolder filesep 'Grids']);
        for i=3:length(y)
            grids=importdata([outputfolder filesep 'Grids' filesep y(i).name]);
            
            fn2=fopen([outputfolder filesep 'Grids' filesep y(i).name],'w');
            for p=1:6
                fprintf(fn2,'%5s ', headername{p});
                fprintf(fn2,'%10.15s ', char(headernumnew{1,p}));
                fprintf(fn2,'\r\n');
            end
            for p=1:size(grids,1)            
                fprintf(fn2,'%.1f ',grids(p,:));
                fprintf(fn2,'\r\n');
            end            
            fclose(fn2);
%             save([outputfolder filesep 'Grids' filesep y(i).name],'grids','-append','-ASCII')
%             dlmwrite([outputfolder filesep 'Grids' filesep y(i).name],grids,'-append', 'delimiter',' ','precision', '%.2f');
        end
    else
        fn2=fopen([outputfolder,filesep,'EsriAsciiHeader_' (cityname) '.txt'],'w');
        for p=1:6
            fprintf(fn2,'%5s ', headername{p});
            fprintf(fn2,'%10.15s ', char(headernumnew{1,p}));
            fprintf(fn2,'\r\n');
        end
        fclose(fn2);
    end
    if asciipopgrid==1
        fn2=fopen([outputfolder filesep 'Grids' filesep 'popdens.asc'],'w');
        for p=1:6
            fprintf(fn2,'%5s ', headername{p});
            fprintf(fn2,'%10.15s ', char(headernumnew{1,p}));
            fprintf(fn2,'\r\n');
        end
        for p=1:size(grids,1)            
            fprintf(fn2,'%.1f ',popgrid(p,:));
            fprintf(fn2,'\r\n');
        end
        fclose(fn2);
%         save([outputfolder filesep 'Grids' filesep 'popdens.asc'],'popgrid','-append','-ASCII')
    end
end

% Menues
% --------------------------------------------------------------------
function File_Callback(hObject, ~, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function Exit_Callback(hObject, ~, handles)
% hObject    handle to Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all

% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, ~, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function About_Callback(hObject, eventdata, handles)
% hObject    handle to About (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
WELCOME()

% --------------------------------------------------------------------
function Help_Callback(hObject, eventdata, handles)
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
open([pwd ,filesep,'data',filesep,'LUCY-UserManual.pdf'])
