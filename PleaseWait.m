function varargout = PleaseWait(varargin)
% PLEASEWAIT M-file for PleaseWait.fig
%      PLEASEWAIT, by itself, creates a new PLEASEWAIT or raises the existing
%      singleton*.
%
%      H = PLEASEWAIT returns the handle to a new PLEASEWAIT or the handle to
%      the existing singleton*.
%
%      PLEASEWAIT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLEASEWAIT.M with the given input arguments.
%
%      PLEASEWAIT('Property','Value',...) creates a new PLEASEWAIT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PleaseWait_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PleaseWait_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PleaseWait

% Last Modified by GUIDE v2.5 15-Aug-2010 15:03:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PleaseWait_OpeningFcn, ...
                   'gui_OutputFcn',  @PleaseWait_OutputFcn, ...
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


% --- Executes just before PleaseWait is made visible.
function PleaseWait_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PleaseWait (see VARARGIN)

% Choose default command line output for PleaseWait
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PleaseWait wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PleaseWait_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
