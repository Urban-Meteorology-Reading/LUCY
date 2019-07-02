function varargout = CitySelection(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CitySelection_OpeningFcn, ...
                   'gui_OutputFcn',  @CitySelection_OutputFcn, ...
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

% --- Executes just before CitySelection is made visible.
function CitySelection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CitySelection (see VARARGIN)

% Choose default command line output for CitySelection
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CitySelection wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CitySelection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_city_Callback(hObject, eventdata, handles)
% loading CityID
WD=pwd;
fid = fopen([WD,'\Data\','CityID.txt']);
C_data=textscan(fid, '%d%s%s%f%f%d','delimiter', ';');
fclose(fid);

C=str2double(get(hObject,'String'));
pos= C_data{6}==C;
test=double(pos);
if max(test)==1
    cityname=C_data{1,2};
    cityname=cityname{pos};
    country=C_data{1,3};
    country=country{pos};
    set(handles.text_city,'String',cityname);
    set(handles.text_country,'String',country);
else
    msgboxText{1} =  'Choose another City ID number'; 
    msgbox(msgboxText,'No  City ID was found', 'error');
    set(handles.text_city,'String','empty');
end

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_city_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_city (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton_OK.
function pushbutton_OK_Callback(hObject, eventdata, handles)

% get the main_gui handle (access to the gui)
mainGUIhandle = LUCY_GUI;       
% get the data from the gui (all handles inside gui_main)
mainGUIdata  = guidata(mainGUIhandle);
 
% change main gui strings
set(mainGUIdata.pushbutton_city, 'UserData', str2double(get(handles.edit_city, 'String')));
set(mainGUIdata.pushbutton_city, 'Value', now);
set(mainGUIdata.edit_regionname, 'String',get(handles.text_city,'String'));

% save changed data back into main_gui
%this line updates the data of the Main Gui
guidata(LUCY_GUI, mainGUIdata);
 
% close this gui 
close(CitySelection);
