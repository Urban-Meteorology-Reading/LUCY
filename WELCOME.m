function varargout = WELCOME(varargin)
% WELCOME M-file for WELCOME.fig
%      WELCOME, by itself, creates a new WELCOME or raises the existing
%      singleton*.
%
%      H = WELCOME returns the handle to a new WELCOME or the handle to
%      the existing singleton*.
%
%      WELCOME('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WELCOME.M with the given input arguments.
%
%      WELCOME('Property','Value',...) creates a new WELCOME or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before WELCOME_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to WELCOME_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help WELCOME

% Last Modified by GUIDE v2.5 04-Nov-2010 14:22:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @WELCOME_OpeningFcn, ...
                   'gui_OutputFcn',  @WELCOME_OutputFcn, ...
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


% --- Executes just before WELCOME is made visible.
function WELCOME_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to WELCOME (see VARARGIN)

% Choose default command line output for WELCOME
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes WELCOME wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = WELCOME_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_continue.
function pushbutton_continue_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_continue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume
close(WELCOME)
