function varargout = LatLongSelection(varargin)
% LATLONGSELECTION M-file for LatLongSelection.fig
%      LATLONGSELECTION, by itself, creates a new LATLONGSELECTION or raises the existing
%      singleton*.
%
%      H = LATLONGSELECTION returns the handle to a new LATLONGSELECTION or the handle to
%      the existing singleton*.
%
%      LATLONGSELECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LATLONGSELECTION.M with the given input arguments.
%
%      LATLONGSELECTION('Property','Value',...) creates a new LATLONGSELECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LatLongSelection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LatLongSelection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LatLongSelection

% Last Modified by GUIDE v2.5 06-Mar-2013 11:35:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LatLongSelection_OpeningFcn, ...
                   'gui_OutputFcn',  @LatLongSelection_OutputFcn, ...
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


% --- Executes just before LatLongSelection is made visible.
function LatLongSelection_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for LatLongSelection
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LatLongSelection wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LatLongSelection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function edit_maxlat_Callback(hObject, eventdata, handles)
input = str2double(get(hObject,'String'));
if input>85 || input<-58
    msgboxText{1} =  'Choose a new number between 85 and -58'; 
    msgbox(msgboxText,'Number has to be between 85 and -58', 'error');
end

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_maxlat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_maxlat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_minlong_Callback(hObject, eventdata, handles)
input = str2double(get(hObject,'String'));
if input>180 || input<-180
    msgboxText{1} =  'Choose a new number between 180 and -180'; 
    msgbox(msgboxText,'Number has to be between 180 and -180', 'error');
end

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit_minlong_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_minlong (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_maxlong_Callback(hObject, eventdata, handles)
input = str2double(get(hObject,'String'));
if input>180 || input<-180
    msgboxText{1} =  'Choose a new number between 180 and -180'; 
    msgbox(msgboxText,'Number has to be between 180 and -180', 'error');
end

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit_maxlong_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_maxlong (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_minlat_Callback(hObject, eventdata, handles)
input = str2double(get(hObject,'String'));
if input>85 || input<-58
    msgboxText{1} =  'Choose a new number between 85 and -58'; 
    msgbox(msgboxText,'Number has to be between 85 and -58', 'error');
end

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_minlat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_minlat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton_latlong.
function pushbutton_latlong_Callback(hObject, eventdata, handles)
% get the main_gui handle (access to the gui)
latmin=str2double(get(handles.edit_minlat, 'String'));
lonmin=str2double(get(handles.edit_minlong, 'String'));
latmax=str2double(get(handles.edit_maxlat, 'String'));
lonmax=str2double(get(handles.edit_maxlong, 'String'));
% [W,S]=WGS84toLUCY(latmin,longmin);
% [E,N]=WGS84toLUCY(latmax,longmax);
% if W==0,W=1;end;if S==0,S=1;end
% if E==0,E=1;end;if N==0,N=1;end
if isnan(latmin) || isnan(latmax) || isnan(lonmin) || isnan(lonmax)
    msgboxText{1} =  'All four boxes must include values';
    msgbox(msgboxText,'Error', 'error');
end

if lonmin>=lonmax
    msgboxText{1} =  'Minimum longitude must be less or equal to maximum longitude';
    msgbox(msgboxText,'Error', 'error');
elseif latmax<=latmin
    msgboxText{1} =  'Minimum latitude must be less or equal to maximum latitude';
    msgbox(msgboxText,'Error', 'error');
else
mainGUIhandle = LUCY_GUI;       
% get the data from the gui (all handles inside gui_main)
mainGUIdata  = guidata(mainGUIhandle);
 
% change main gui strings
set(mainGUIdata.pushbutton_coord, 'UserData', [lonmin latmax latmin lonmax]);
set(mainGUIdata.pushbutton_coord, 'Value', now);

% save changed data back into main_gui
%this line updates the data of the Main Gui
guidata(LUCY_GUI, mainGUIdata);
 
% close this gui 
close(LatLongSelection);
% uiwait()
Regionname();

end
