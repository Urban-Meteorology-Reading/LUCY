function varargout = DataSummary(varargin)
% DATASUMMARY M-file for DataSummary.fig
%      DATASUMMARY, by itself, creates a new DATASUMMARY or raises the existing
%      singleton*.
%
%      H = DATASUMMARY returns the handle to a new DATASUMMARY or the handle to
%      the existing singleton*.
%
%      DATASUMMARY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATASUMMARY.M with the given input arguments.
%
%      DATASUMMARY('Property','Value',...) creates a new DATASUMMARY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DataSummary_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DataSummary_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DataSummary

% Last Modified by GUIDE v2.5 16-Feb-2011 17:55:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DataSummary_OpeningFcn, ...
                   'gui_OutputFcn',  @DataSummary_OutputFcn, ...
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


% --- Executes just before DataSummary is made visible.
function DataSummary_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.

userdata=getuserdir;
tempdir=[userdata filesep 'LUCY' filesep];

load([tempdir 'countryid'])
load([tempdir 'tempday'])
load([tempdir 'tempmonth'])
load([tempdir 'YYYY'])
load([tempdir 'YYYYclose'])
load([tempdir 'mbikestable'])
load([tempdir 'tabdata'])
load([tempdir 'tabdataid'])
load([tempdir 'pop'])

set(handles.text1,'String',['Data Summary for ', num2str(YYYY)])
if tempday==0
    set(handles.text13,'String','Not loaded')
    if tempmonth==1
        set(handles.text15,'String','Available')
    else
        set(handles.text15,'String','Not available. Monthly average temperature data (1970-2000) will be used')
    end
else
    set(handles.text13,'String','Loaded')
    set(handles.text15,'String','Not used')
end
if pop==1
    popdata='GRUMP (v1)';
else
    popdata='GWP (v3)';
end
set(handles.text17,'String',['The ', popdata, ' dataset will be used in the simulation'])
set(handles.text1,'Value',YYYYclose)
set(handles.text9,'String',['Simulations for the year ',num2str(YYYY),' will use population density data from ',num2str(YYYYclose),'.'])
% header=mbikestable.rowheaders

set(handles.uitable1,'Rowname',mbikestable.rowheaders(b))
set(handles.uitable1,'Data',tabdataid(:,1:4))

% Choose default command line output for DataSummary
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DataSummary wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = DataSummary_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% get the main_gui handle (access to the gui)
% tabdata=get(handles.uitable1,'Data');
userdata=getuserdir;
tempdir=[userdata filesep 'LUCY' filesep];

load([tempdir 'tabdata'])

YYYYclose=get(handles.text1,'Value');
mainGUIhandle = LUCY_GUI;       
% get the data from the gui (all handles inside gui_main)
mainGUIdata  = guidata(mainGUIhandle);
 
% change main gui strings
set(mainGUIdata.pushbutton_datasummary, 'Value',YYYYclose);
set(mainGUIdata.pushbutton_datasummary, 'UserData',tabdata);

% save changed data back into main_gui
%this line updates the data of the Main Gui
guidata(LUCY_GUI, mainGUIdata);
 
% close this gui 
close(DataSummary);
