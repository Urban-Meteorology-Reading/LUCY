function varargout = CountrySelection(varargin)
% COUNTRYSELECTION M-file for CountrySelection.fig
%      COUNTRYSELECTION, by itself, creates a new COUNTRYSELECTION or raises the existing
%      singleton*.
%
%      H = COUNTRYSELECTION returns the handle to a new COUNTRYSELECTION or the handle to
%      the existing singleton*.
%
%      COUNTRYSELECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COUNTRYSELECTION.M with the given input arguments.
%
%      COUNTRYSELECTION('Property','Value',...) creates a new COUNTRYSELECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CountrySelection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CountrySelection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CountrySelection

% Last Modified by GUIDE v2.5 10-Sep-2010 11:45:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CountrySelection_OpeningFcn, ...
                   'gui_OutputFcn',  @CountrySelection_OutputFcn, ...
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


% --- Executes just before CountrySelection is made visible.
function CountrySelection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CountrySelection (see VARARGIN)

% Choose default command line output for CountrySelection
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CountrySelection wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CountrySelection_OutputFcn(hObject, ~, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;

function popupmenu_country_Callback(hObject, ~, handles)

contents = get(hObject,'String');
name=contents{get(hObject,'Value')};
guidata(hObject, handles);
set(handles.text_country,'String',name);

function popupmenu_country_CreateFcn(hObject, ~, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function pushbutton_save_Callback(hObject, ~, handles)

% get the main_gui handle (access to the gui)
mainGUIhandle = LUCY_GUI;       
% get the data from the gui (all handles inside gui_main)
mainGUIdata  = guidata(mainGUIhandle);
 
% change main gui strings
set(mainGUIdata.pushbutton_country, 'UserData', get(handles.popupmenu_country, 'Value'));
set(mainGUIdata.pushbutton_country, 'Value', now);
% set(mainGUIdata.edit_regionname, 'String',get(handles.text_country,'String'));
set(mainGUIdata.text_countryname, 'String',get(handles.text_country,'String'));

% save changed data back into main_gui
%this line updates the data of the Main Gui
guidata(LUCY_GUI, mainGUIdata);
 
% close this gui 
close(CountrySelection);
