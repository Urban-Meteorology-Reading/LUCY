function varargout = mat2ascGUI(varargin)
% MAT2ASCGUI MATLAB code for mat2ascGUI.fig
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mat2ascGUI

% Last Modified by GUIDE v2.5 09-Mar-2013 09:31:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mat2ascGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @mat2ascGUI_OutputFcn, ...
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


% --- Executes just before mat2ascGUI is made visible.
function mat2ascGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.

% Choose default command line output for mat2ascGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mat2ascGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = mat2ascGUI_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;


%%%%%%%%%%%%%%%% EXPORT GPW %%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on selection change in popupmenu_datasetGPW.
function popupmenu_datasetGPW_Callback(hObject, eventdata, handles)
grids=get(hObject,'Value');
if grids==2
    set(handles.popupmenu_exportGPWYYYY,'Enable','on')
    years=ls([pwd filesep 'Data' filesep 'DataGPW' filesep 'population']);
    howmany=size(years,1)-2;
    string={' '};
    for i=1:howmany
        [~, remain]=strtok(years(i+2,:),'_');
        string{i+1}=remain(2:5);
    end
    set(handles.popupmenu_exportGPWYYYY,'String',string)%,{' ';'2000';'2005'})% should be changed
end
if grids>2 || grids==1
    set(handles.popupmenu_exportGPWYYYY,'Enable','off')
    set(handles.pushbutton_exportGPW,'Enable','on')
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_datasetGPW_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_exportGPWYYYY.
function popupmenu_exportGPWYYYY_Callback(hObject, eventdata, handles)
contents = cellstr(get(hObject,'String'));
YYYY=contents{get(hObject,'Value')};
set(handles.popupmenu_exportGPWYYYY,'UserData',YYYY)
set(handles.pushbutton_exportGPW,'Enable','on')
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_exportGPWYYYY_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton_exportGPW.
function pushbutton_exportGPW_Callback(hObject, eventdata, handles)
YYYY=(get(handles.popupmenu_exportGPWYYYY,'UserData'));
datas=(get(handles.popupmenu_datasetGPW,'Value'));
if datas==2
    typeofdata='population\popcell_';
    typename='popcell';
elseif datas==3
    typeofdata='countries';
    typename='countries';
elseif datas==4
    typeofdata='citygrid';
    typename='citygrid';
end
exportGWP(YYYY,typeofdata,typename)


%%%%%%%%%%%%%%%%%%%%%% IMPORT GPWv3 population %%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in pushbutton_selectGPW.
function pushbutton_selectGPW_Callback(hObject, eventdata, handles)
[inputfile directory]=uigetfile('*.asc');
set(handles.pushbutton_selectGPW,'UserData',[directory inputfile])
set(handles.edit_popGWPYYYY,'Enable','on')
set(handles.pushbutton_importGPW,'Enable','on')
guidata(hObject, handles);

function edit_popGWPYYYY_Callback(hObject, eventdata, handles)
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_popGWPYYYY_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton_importGPW.
function pushbutton_importGPW_Callback(hObject, eventdata, handles)
datafile=get(handles.pushbutton_selectGPW,'UserData');
YYYY=str2double(get(handles.edit_popGWPYYYY,'String'));

if isnan(YYYY) || YYYY<1900 || YYYY>2100
    msgboxText{1} =  'Choose an interger number between 1900 and 2100';
    msgbox(msgboxText,'Program terminated', 'error');
else
    h=PleaseWait();
    if(exist([pwd filesep 'ImportedDataSets'],'dir')==0)
        mkdir([pwd filesep 'ImportedDataSets']);
    end
    popcell=dlmread(datafile,' ',6,0);
    popcell(popcell==-9999)=NaN;
    popcell=popcell(1:3432,1:8640);
    save([pwd filesep 'ImportedDataSets' filesep 'popcell_',num2str(YYYY),'.mat'],'popcell');
    close(h)
end


%%%%%%%%%%%%%%%%%%%% EXPORT GRUMPv1 tiles %%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on selection change in popupmenu_datasetGRUMP.
function popupmenu_datasetGRUMP_Callback(hObject, ~, handles)
grids=get(hObject,'Value');
if grids==2
    set(handles.popupmenu_exportGRUMPYYYY,'Enable','on')
    set(handles.popupmenu_tileGRUMP,'Enable','on')
    years=ls([pwd filesep 'Data' filesep 'population']);
    howmany=size(years,1)-2;
    string={' '};
    for i=1:howmany
        [~, remain]=strtok(years(i+2,:),'_');
        string{i+1}=remain(2:5);
    end
    set(handles.popupmenu_exportGRUMPYYYY,'String',string)%{' ';'2000'})% should be changed
    years=get(handles.popupmenu_exportGRUMPYYYY,'Value');
    set(handles.popupmenu_exportGRUMPYYYY,'Userdata',string(years))
elseif grids>2
    set(handles.popupmenu_exportGRUMPYYYY,'Enable','off')
    set(handles.popupmenu_tileGRUMP,'Enable','on')
elseif grids==1
    set(handles.popupmenu_exportGRUMPYYYY,'Enable','off')
    set(handles.popupmenu_tileGRUMP,'Enable','off')
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_datasetGRUMP_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_tileGRUMP.
function popupmenu_tileGRUMP_Callback(hObject, eventdata, handles)
contents = cellstr(get(hObject,'String'));
tile=contents{get(hObject,'Value')};
set(handles.popupmenu_tileGRUMP,'UserData',tile)
set(handles.pushbutton_exportGRUMP,'Enable','on')
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_tileGRUMP_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_exportGRUMPYYYY.
function popupmenu_exportGRUMPYYYY_Callback(hObject, eventdata, handles)
contents = cellstr(get(hObject,'String'));
YYYY=contents{get(hObject,'Value')};
set(handles.popupmenu_exportGRUMPYYYY,'UserData',YYYY)
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_exportGRUMPYYYY_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton_exportGRUMP.
function pushbutton_exportGRUMP_Callback(hObject, eventdata, handles)
datas=(get(handles.popupmenu_datasetGRUMP,'Value'));
YYYY=get(handles.popupmenu_exportGRUMPYYYY,'UserData');
tile=get(handles.popupmenu_tileGRUMP,'UserData');
likamed=strfind(tile,'=');
blank=strfind(tile,' ');
lat=str2double(tile(likamed(1)+1:blank(1)));
lon=str2double(tile(likamed(2)+1:size(tile,2)));

if datas==2
    typeofdata='population';
    typename='population';
elseif datas==3
    typeofdata='countries';
    typename='countries';
elseif datas==4
    typeofdata='urban';
    typename='urban';
end
exportGRUMP(YYYY,typeofdata,typename,lat,lon)
set(handles.edit_popGRUMPYYYY,'Enable','off')
set(handles.popupmenu_tileGRUMPpop,'Enable','off')
set(handles.popupmenu_tileGRUMPpop,'Value',1)
set(handles.pushbutton_importGRUMPpop,'Enable','off')


%%%%%%%%%%%%%%%%%%% IMPORT GRUMPv1 population %%%%%%%%%%%%%%%%%%%
% --- Executes on button press in pushbutton_selectGRUMPpop.
function pushbutton_selectGRUMPpop_Callback(hObject, eventdata, handles)
[inputfile directory]=uigetfile('*.asc');
set(handles.pushbutton_selectGRUMPpop,'UserData',[directory inputfile])
set(handles.edit_popGRUMPYYYY,'Enable','on')
set(handles.popupmenu_tileGRUMPpop,'Enable','on')
set(handles.pushbutton_importGRUMPpop,'Enable','on')
guidata(hObject, handles);

function edit_popGRUMPYYYY_Callback(hObject, eventdata, handles)
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_popGRUMPYYYY_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_tileGRUMPpop.
function popupmenu_tileGRUMPpop_Callback(hObject, eventdata, handles)
contents = cellstr(get(hObject,'String'));
tile=contents{get(hObject,'Value')};
set(handles.popupmenu_tileGRUMPpop,'UserData',tile)
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_tileGRUMPpop_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton_importGRUMPpop.
function pushbutton_importGRUMPpop_Callback(hObject, eventdata, handles)
datafile=get(handles.pushbutton_selectGRUMPpop,'UserData');
YYYY=str2double(get(handles.edit_popGRUMPYYYY,'String'));
tile=get(handles.popupmenu_tileGRUMPpop,'UserData');
likamed=strfind(tile,'=');
blank=strfind(tile,' ');
lat=str2double(tile(likamed(1)+1:blank(1)));
lon=str2double(tile(likamed(2)+1:size(tile,2)));

if isnan(YYYY) || YYYY<1900 || YYYY>2100
    msgboxText{1} =  'Choose an interger number between 1900 and 2100';
    msgbox(msgboxText,'ERROR', 'error');
else
    h=PleaseWait();
    if(exist([pwd filesep 'Data' filesep 'population' filesep 'population_' num2str(YYYY)],'dir')==0)
        mkdir([pwd filesep 'Data' filesep 'population' filesep 'population_' num2str(YYYY)]);
    end
    data=Solweig_10_loaddem(datafile);
    data=single(data);
    save([pwd filesep 'Data' filesep 'population' filesep 'population_' num2str(YYYY)...
        filesep 'population' num2str(lat) '_' num2str(lon) '.mat'],'data');
    close(h)
    set(handles.edit_popGRUMPYYYY,'Enable','off')
    set(handles.popupmenu_tileGRUMPpop,'Enable','off')
    set(handles.popupmenu_tileGRUMPpop,'Value',1)
    set(handles.pushbutton_importGRUMPpop,'Enable','off')
end


%%%%%%%%%%%%%%%%%%%%55 IMPORT GPW Daily Temperature %%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in pushbutton_selectGPWtemp.
function pushbutton_selectGPWtemp_Callback(hObject, eventdata, handles)
[inputfile directory]=uigetfile('*.asc');
set(handles.pushbutton_selectGPWtemp,'UserData',[directory inputfile])
set(handles.edit_tempGPWYYYY,'Enable','on')
set(handles.edit_tempGPWDOY,'Enable','on')
set(handles.pushbutton_importGPWtemp,'Enable','on')
guidata(hObject, handles);

function edit_tempGPWYYYY_Callback(hObject, eventdata, handles)
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_tempGPWYYYY_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_tempGPWDOY_Callback(hObject, eventdata, handles)
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_tempGPWDOY_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton_importGPWtemp.
function pushbutton_importGPWtemp_Callback(hObject, eventdata, handles)
datafile=get(handles.pushbutton_selectGPWtemp,'UserData');
YYYY=str2double(get(handles.edit_tempGPWYYYY,'String'));
DOY=str2double(get(handles.edit_tempGPWDOY,'String'));
che=1;

if isnan(YYYY) || YYYY<1900 || YYYY>2100
    che=0;
    msgboxText{1} =  'Choose an interger number between 1900 and 2100';
    msgbox(msgboxText,'Program terminated', 'error');
end
if isnan(DOY) || DOY<1 || DOY>365
    che=0;
    msgboxText{1} =  'Choose an interger number between 1 and 365';
    msgbox(msgboxText,'Program terminated', 'error');
end

if che==1
    h=PleaseWait();
    avtemp=dlmread(datafile,' ',6,0);
    avtemp(avtemp==-9999)=NaN;
    avtemp=avtemp(1:3432,1:8640);
    avtemp=single(avtemp);
    save([pwd filesep 'Data' filesep 'temperature' filesep ...
        'Dailytemp_' num2str(YYYY) '_' num2str(DOY) '.mat'],'avtemp');
    close(h)
end


%%%%%%%%%%%%%%%%%%%%55 EXPORT Temperature %%%%%%%%%%%%%%%%%%%%%
% --- Executes on selection change in popupmenu_exportTEMP_cat.
function popupmenu_exportTEMP_cat_Callback(hObject, eventdata, handles)
grids=get(hObject,'Value');
if grids==2 % Average 70-00
    set(handles.popupmenu_exportTEMPMONTH,'Enable','on')
    set(handles.popupmenu_exportTEMPYYYY,'Enable','off')
    set(handles.popupmenu_exportTEMPDOY,'Enable','off')
elseif grids==3 %Observed Monthy
    set(handles.popupmenu_exportTEMPYYYY,'Enable','on')
    set(handles.popupmenu_exportTEMPMONTH,'Enable','off')
    years=ls([pwd filesep 'Data' filesep 'temperature']);
    howmany=size(years,1)-2;
    string={' '};index=1;
    for i=1:howmany
        [token, remain]=strtok(years(i+2,:),'_');
        if strcmp(token,'air')
            string{index+1}=remain(7:10);
            index=index+1;
        end
    end
    set(handles.popupmenu_exportTEMPYYYY,'String',string)
    years=get(handles.popupmenu_exportTEMPYYYY,'Value');
    set(handles.popupmenu_exportTEMPYYYY,'Userdata',string(years))
elseif grids==4 %Observed Daily
    set(handles.popupmenu_exportTEMPMONTH,'Enable','off')
    set(handles.popupmenu_exportTEMPYYYY,'Enable','on')
    years=ls([pwd filesep 'Data' filesep 'temperature']);
    howmany=size(years,1)-2;
    string={' '};
    for i=1:howmany
        [token, remain]=strtok(years(i+2,:),'_');
        if strcmp(token,'Dailytemp')
            string{i+1}=remain(2:5);
        end
    end
    set(handles.popupmenu_exportTEMPYYYY,'String',string)%{' ';'2000'})% should be changed
%     years=get(handles.popupmenu_exportTEMPYYYY,'Value');
%     set(handles.popupmenu_exportTEMPYYYY,'Userdata',string(years))
elseif grids==1
    set(handles.popupmenu_exportTEMP_cat,'Enable','on')
    set(handles.popupmenu_exportTEMPMONTH,'Enable','off')
    set(handles.popupmenu_exportTEMPYYYY,'Enable','off')
    set(handles.popupmenu_exportTEMPDOY,'Enable','off')
    set(handles.popupmenu_exportTEMPYYYY,'Value',1)
    set(handles.popupmenu_exportTEMPDOY,'Value',1)
end
set(handles.pushbutton_exportTEMP,'UserData',grids)
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_exportTEMP_cat_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_exportTEMPYYYY.
function popupmenu_exportTEMPYYYY_Callback(hObject, eventdata, handles)
grids=get(handles.pushbutton_exportTEMP,'UserData');
if grids==4 %Observed Daily
    set(handles.popupmenu_exportTEMPDOY,'Enable','on')
    whe=get(handles.popupmenu_exportTEMPYYYY,'String');
    whatyear=whe(get(handles.popupmenu_exportTEMPYYYY,'Value'));
    years=ls([pwd filesep 'Data' filesep 'temperature']);
    howmany=size(years,1)-2;
    string={' '};index=1;
    for i=1:howmany
        [token, remain]=strtok(years(i+2,:),'.');
        if strncmp(token,['Dailytemp_' whatyear{1}],14)
            [token, remain]=strtok(token,'_');
            string{i+1}=remain(7:size(remain,2));
            index=index+1;
        end
    end
    set(handles.popupmenu_exportTEMPDOY,'String',string)%{' ';'2000'})% should be changed
elseif grids==3
    
    set(handles.popupmenu_exportTEMPMONTH,'Enable','on')
end
years=get(handles.popupmenu_exportTEMPYYYY,'Value');
string=get(handles.popupmenu_exportTEMPYYYY,'String');
set(handles.popupmenu_exportTEMPYYYY,'Userdata',string(years))
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_exportTEMPYYYY_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_exportTEMPMONTH.
function popupmenu_exportTEMPMONTH_Callback(hObject, eventdata, handles)
set(handles.pushbutton_exportTEMP,'Enable','on')
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_exportTEMPMONTH_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_exportTEMPDOY.
function popupmenu_exportTEMPDOY_Callback(hObject, eventdata, handles)
set(handles.pushbutton_exportTEMP,'Enable','on')
days=get(handles.popupmenu_exportTEMPDOY,'Value');
string=get(handles.popupmenu_exportTEMPDOY,'String');
set(handles.popupmenu_exportTEMPDOY,'Userdata',string(days))
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_exportTEMPDOY_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton_exportTEMP.
function pushbutton_exportTEMP_Callback(hObject, eventdata, handles)
grids=get(handles.pushbutton_exportTEMP,'UserData');
YYYY=get(handles.popupmenu_exportTEMPYYYY,'UserData');
DOY=get(handles.popupmenu_exportTEMPDOY,'UserData');
MM=get(handles.popupmenu_exportTEMPMONTH,'Value')-1;
MMstring=get(handles.popupmenu_exportTEMPMONTH,'String');

h=PleaseWait();
WD=pwd;
if(exist([WD filesep 'ExportedDatasets'],'dir')==0)
    mkdir([WD filesep 'ExportedDatasets']);
end

DELIMITER = ' ';
HEADERLINES = 6;
header = importdata([WD,filesep,'Data',filesep,'EsriAsciiHeader.txt'], DELIMITER, HEADERLINES);
for i=1:6
    [cell,rest]=strtok(header{i},' ');
    headernum(i,:)=cellstr(rest);
    headername(i,:)=cellstr(cell);
end

if grids==2 %Average 70-00
    MMstr=MMstring(MM); MMstr=MMstr{1};
    load([WD filesep 'Data' filesep 'temperature' filesep 'avtemp_' MMstr '70_00.mat']);
    fn2=fopen([WD,'\ExportedDatasets\AveregareMonthlyTemperature1970_2000_' MMstr,'.asc'],'w');
    avtemp(isnan(avtemp))=-9999;
    headernumnew{1}=num2str(720);
    headernumnew{2}=num2str(360);
    headernumnew{3}=num2str(-180);
    headernumnew{4}=num2str(-90);
    headernumnew{5}=num2str(double(1800/3600));
    headernumnew{6}=num2str(-9999);
    for p=1:6
        fprintf(fn2,'%5s ', headername{p});
        fprintf(fn2,'%10.15s ', char(headernumnew{1,p}));
        fprintf(fn2,'\r\n');
    end
    for p=1:size(avtemp,1)
        fprintf(fn2,'%6.4f ',avtemp(p,:));
        fprintf(fn2,'\r\n');
    end
elseif grids==3%Observed monthly
    YYYY=str2num(YYYY{1});
    startdate=datenum([YYYY MM 1]);
    MMstr=MMstring(MM); MMstr=MMstr{1};
    avtemp=ImportWillmot_v4(startdate,1,WD,'Data');
    fn2=fopen([WD,'\ExportedDatasets\ObservedMonthlyTemperature_' num2str(YYYY) '_' MMstr,'.asc'],'w');
    avtemp(isnan(avtemp))=-9999;
    headernumnew{1}=num2str(720);
    headernumnew{2}=num2str(360);
    headernumnew{3}=num2str(-180);
    headernumnew{4}=num2str(-90);
    headernumnew{5}=num2str(double(1800/3600));
    headernumnew{6}=num2str(-9999);
    for p=1:6
        fprintf(fn2,'%5s ', headername{p});
        fprintf(fn2,'%10.15s ', char(headernumnew{1,p}));
        fprintf(fn2,'\r\n');
    end
    for p=1:size(avtemp,1)
        fprintf(fn2,'%6.4f ',avtemp(p,:));
        fprintf(fn2,'\r\n');
    end
    
elseif grids==4%Observed daily
    YYYY=str2num(YYYY{1});
    DOY=str2num(DOY{1});
    load([WD filesep 'Data' filesep 'temperature' filesep 'Dailytemp_' num2str(YYYY) '_' num2str(DOY) '.mat']);
    avtemp(isnan(avtemp))=-9999;
    fn2=fopen([WD,'\ExportedDatasets\DailyTemperature_' num2str(YYYY) '_' num2str(DOY),'.asc'],'w');
    for p=1:6
        fprintf(fn2,'%6s', header{p});
        fprintf(fn2,'\r\n');
    end
    for p=1:size(avtemp,1)
        fprintf(fn2,'%6.4f ',avtemp(p,:));
        fprintf(fn2,'\r\n');
    end
    close(h)
end
fclose(fn2);
close(h)













% 
% % --- Executes on selection change in popupmenu2.
% function popupmenu2_Callback(hObject, eventdata, handles)
% % hObject    handle to popupmenu2 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
% %        contents{get(hObject,'Value')} returns selected item from popupmenu2
% 
% 
% % --- Executes during object creation, after setting all properties.
% function popupmenu2_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to popupmenu2 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: popupmenu controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
% 
% % --- Executes on selection change in popupmenu_exportDOY.
% function popupmenu_exportDOY_Callback(hObject, eventdata, handles)
% % hObject    handle to popupmenu_exportDOY (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_exportDOY contents as cell array
% %        contents{get(hObject,'Value')} returns selected item from popupmenu_exportDOY
% 
% 
% % --- Executes during object creation, after setting all properties.
% function popupmenu_exportDOY_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to popupmenu_exportDOY (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: popupmenu controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% % --- Executes on selection change in popupmenu10.
% function popupmenu10_Callback(hObject, eventdata, handles)
% % hObject    handle to popupmenu10 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: contents = cellstr(get(hObject,'String')) returns popupmenu10 contents as cell array
% %        contents{get(hObject,'Value')} returns selected item from popupmenu10
% 
% 
% % --- Executes during object creation, after setting all properties.
% function popupmenu10_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to popupmenu10 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: popupmenu controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
% 
% 
% % --- Executes on button press in pushbutton_extentimport.
% function pushbutton_extentimport_Callback(hObject, eventdata, handles)
% % hObject    handle to pushbutton_extentimport (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % --- Executes on selection change in popupmenu11.
% function popupmenu11_Callback(hObject, eventdata, handles)
% % hObject    handle to popupmenu11 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: contents = cellstr(get(hObject,'String')) returns popupmenu11 contents as cell array
% %        contents{get(hObject,'Value')} returns selected item from popupmenu11
% 
% 
% % --- Executes during object creation, after setting all properties.
% function popupmenu11_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to popupmenu11 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: popupmenu controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
% 
% 
% % --- Executes on selection change in popupmenu12.
% function popupmenu12_Callback(hObject, eventdata, handles)
% % hObject    handle to popupmenu12 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: contents = cellstr(get(hObject,'String')) returns popupmenu12 contents as cell array
% %        contents{get(hObject,'Value')} returns selected item from popupmenu12
% 
% 
% % --- Executes during object creation, after setting all properties.
% function popupmenu12_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to popupmenu12 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: popupmenu controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
% 
% 
% % --- Executes on selection change in popupmenu13.
% function popupmenu13_Callback(hObject, eventdata, handles)
% % hObject    handle to popupmenu13 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: contents = cellstr(get(hObject,'String')) returns popupmenu13 contents as cell array
% %        contents{get(hObject,'Value')} returns selected item from popupmenu13
% 
% 
% % --- Executes during object creation, after setting all properties.
% function popupmenu13_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to popupmenu13 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: popupmenu controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
% 
% 
% 
% 
% 
% % --- Executes on selection change in popupmenu14.
% function popupmenu14_Callback(hObject, eventdata, handles)
% % hObject    handle to popupmenu14 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: contents = cellstr(get(hObject,'String')) returns popupmenu14 contents as cell array
% %        contents{get(hObject,'Value')} returns selected item from popupmenu14
% 
% 
% % --- Executes during object creation, after setting all properties.
% function popupmenu14_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to popupmenu14 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: popupmenu controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
