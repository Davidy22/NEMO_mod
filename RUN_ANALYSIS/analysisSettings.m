function varargout = analysisSettings(varargin)
% analysisSettings MATLAB code for analysisSettings.fig
%      analysisSettings, by itself, creates a new analysisSettings or raises the existing
%      singleton*.
%
%      H = analysisSettings returns the handle to a new analysisSettings or the handle to
%      the existing singleton*.
%
%      analysisSettings('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in analysisSettings.M with the given input arguments.
%
%      analysisSettings('Property','Value',...) creates a new analysisSettings or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before analysisSettings_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to analysisSettings_OpeningFcn via varargin.
%
%      *See GUI Options on analysisSettings's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: analysisSettings, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help analysisSettings

% Last Modified by analysisSettings v2.5 06-May-2016 17:55:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @analysisSettings_OpeningFcn, ...
                   'gui_OutputFcn',  @analysisSettings_OutputFcn, ...
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

% --- Executes just before analysisSettings is made visible.
function analysisSettings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to analysisSettings (see VARARGIN)

% Choose default command line output for analysisSettings
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes analysisSettings wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = analysisSettings_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% ------------------------------------------------------------------ %


% ----- YES 2D RADIOB CALLBACK
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% Hint: get(hObject,'Value') returns toggle state of radiobutton1
if (get(hObject,'Value') == get(hObject,'Max'))
    assignin('base','twoD',1);
    set(handles.edit6,'Value',320);
    set(handles.edit6,'String',320);
    assignin('base','pxpMM',get(handles.edit6,'Value'));
    set([handles.text11,handles.text12,handles.edit12,handles.edit13,...
        handles.pushbutton4,handles.pushbutton5],'Enable','off');
end

% ------ NOT 2D RADIOB CALLBACK
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% Hint: get(hObject,'Value') returns toggle state of radiobutton1
handles = guidata(hObject);
if (get(hObject,'Value') == get(hObject,'Max'))
    assignin('base','twoD',0);
    set(handles.edit6,'Value',227); % automatically sets pxpmm default for 3D
    set(handles.edit6,'String',227);
    assignin('base','pxpMM',get(handles.edit6,'Value'));
    set([handles.text11,handles.text12,handles.edit12,handles.edit13,...
        handles.pushbutton4,handles.pushbutton5],'Enable','on');
end

% ----- YES HI RES RADIOB CALLBACK
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
if (get(hObject,'Value') == get(hObject,'Max'))
    assignin('base','highRes',1);
end

% ----- NOT HI RES RADIOB CALLBACK
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
if (get(hObject,'Value') == get(hObject,'Max'))
    assignin('base','highRes',0);
end

% % ----- YES PIXCOORDS RADIOB CALLBACK
% function radiobutton9_Callback(hObject, eventdata, handles)
% % hObject    handle to radiobutton9 (see GCBO)
% if (get(hObject,'Value') == get(hObject,'Max'))
%     assignin('base','pixCoords',1);
% end
% 
% % ----- NO PIXCOORDS RADIOB CALLBACK
% function radiobutton10_Callback(hObject, eventdata, handles)
% % hObject    handle to radiobutton9 (see GCBO)
% if (get(hObject,'Value') == get(hObject,'Max'))
%     assignin('base','pixCoords',0);
% end

% % ----- DARKFIELD RADIOB CALLBACK
% function radiobutton12_Callback(hObject, eventdata, handles)
% % hObject    handle to radiobutton9 (see GCBO)
% if (get(hObject,'Value') == get(hObject,'Max'))
%     assignin('base','darkField',1);
% end

% ----- LASER APPARENT CALLBACK
function radiobutton33_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
if (get(hObject,'Value') == get(hObject,'Max'))
    assignin('base','laserHalo',1);
    set(handles.checkbox1,'Enable','on');
    set(handles.checkbox1,'Value',1);
    assignin('base','is405',1);
end

% ----- LASER NOT APPARENT CALLBACK
function radiobutton34_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
if (get(hObject,'Value') == get(hObject,'Max'))
    assignin('base','laserHalo',0);
    set(handles.checkbox1,'Enable','off');
    set(handles.checkbox1,'Value',0);
    assignin('base','is405',0);
end

% ----- BEGIN ANALYSIS PUSHBUTTON CALLBACK
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close

% ----- SEGMENTS TEXT (coupled with slider)
function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
handles = guidata(hObject);
segNum = round(str2num(get(hObject,'String')));
if (segNum > 40 || segNum < 1)
    set(handles.slider1,'Value',40);
    set(hObject,'String',40);
else
    set(handles.slider1,'Value',segNum);
    set(hObject,'String',segNum);
end
assignin('base','segNum',get(hObject,'String'));

% ----- SEGMENTS SLIDER CALLBACK (coupled with text)
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles = guidata(hObject);
sliderValue = round(get(handles.slider1,'Value'));
set(handles.edit3,'String',num2str(sliderValue));
assignin('base','segNum',sliderValue);

% ----- START FRAME CALLBACK
function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
handles = guidata(hObject);
startFrame = round(str2double(get(hObject,'String')));
if startFrame > round(str2double(get(handles.edit2,'String')))
    startFrame = round(str2double(get(handles.edit2,'String')));
elseif startFrame <= 0
    startFrame = 1;
end
set(hObject,'String',startFrame);   
assignin('base','startFrame',startFrame);

% ----- END FRAME CALLBACK
function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
handles = guidata(hObject);
endFrame = round(str2double(get(hObject,'String')));
if endFrame < round(str2double(get(handles.edit1,'String')))
    endFrame = round(str2double(get(handles.edit1,'String')));
end

% if box left empty, endFrame set to 9999 (code to evaluate all frames)
check = get(hObject, 'String');
if isempty(check)
  % Nothing in there, so set value2 = value1.
  % First, retrieve value1 string.
    endFrame = 9999;
end

if endFrame ~= 9999
    set(hObject,'String',endFrame);
end
assignin('base','endFrame',endFrame);

% ----- PIXPMM CALLBACK
function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double
pixpMM = round(str2double(get(hObject,'String')));
if pixpMM <= 0;
    pixpMM = 1;
end
set(hObject,'String',pixpMM);
assignin('base','pxpMM',pixpMM);

% ----- FPS CALLBACK
function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
FPS = round(str2double(get(hObject,'String')));
if FPS <= 0
    FPS = 1;
end
set(hObject,'String',FPS);
assignin('base','FPS',FPS);

% ----- ADULT WORMTYPE RADIOB CALLBACK
function radiobutton15_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radiobutton15
if (get(hObject,'Value') == get(hObject,'Max'))
    assignin('base','adultW',1);
end

% ----- L1 WORMTYPE RADIOB CALLBACK
function radiobutton16_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radiobutton16
if (get(hObject,'Value') == get(hObject,'Max'))
    assignin('base','adultW',0);
end

% ----- FREEMOTION RADIOB CALLBACK
function radiobutton19_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton19
if (get(hObject,'Value') == get(hObject,'Max'))
    assignin('base','testType','freemotion');
end

% ----- PHOTOTAXIS RADIOB CALLBACK
function radiobutton20_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton20
if (get(hObject,'Value') == get(hObject,'Max'))
    assignin('base','testType','phototaxis');
end

% ----- ELECTROTAXIS RADIOB CALLBACK
function radiobutton21_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton21
if (get(hObject,'Value') == get(hObject,'Max'))
    assignin('base','testType','electrotaxis');
end

% ----- THERMOTAXIS RADIOB CALLBACK
function radiobutton32_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton32
if (get(hObject,'Value') == get(hObject,'Max'))
    assignin('base','testType','thermotaxis');
end

% ----- YES FRAMES RADIOB CALLBACK
function radiobutton30_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radiobutton30
handles = guidata(hObject);
if (get(hObject,'Value') == get(hObject,'Max'))
    set(handles.edit9,'String','');
    assignin('base','isFrames',1);
    set(handles.text8,'String','Select frames folder:');
    set(handles.text11,'String','Side 1 frames:');
    set(handles.text12,'String','Side 2 frames:');
end

% ----- NOT FRAMES RADIOB CALLBACK
function radiobutton31_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radiobutton31
if (get(hObject,'Value') == get(hObject,'Max'))
    set(handles.edit9,'String','');
    assignin('base','isFrames',0);
    set(handles.text8,'String','Select video file:');
    set(handles.text11,'String','Side 1 video:');
    set(handles.text12,'String','Side 2 video:');
end

% ----- SELECT DATA EDIT BOX CALLBACK
function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double
set(hObject,'String','');

% ----- SELECT DATA BROWSE BUTTON CALLBACK
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% ----------------------------------------------------------------- %
handles = guidata(hObject);
if (get(handles.radiobutton30,'Value') == get(handles.radiobutton30,'Max'))
    inFolderFrames = uigetdir('C:\', 'Select folder with frame data');
    set(handles.edit9,'String',inFolderFrames);
    assignin('base','inFolderFrames',inFolderFrames);
else
    [movFilename, movPathname] = uigetfile( ...
        {'*.avi;*.mpg;*.mpeg','Video Files (*.avi,*.mpg,*.mpeg)';
        '*.*',  'All Files (*.*)'}, ...
        'Select video data file');
    vidFilePath = fullfile(movPathname,movFilename);
    set(handles.edit9,'String',vidFilePath);
    assignin('base','vidFilePath',vidFilePath);
end

if ~isempty(get(handles.edit10,'String')) && ...
        ~isempty(get(handles.edit11,'String'))
    set(handles.pushbutton1,'Enable','on');
end

% ----- SELECT .TXT EDIT BOX CALLBACK
function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'String','');

% ----- SELECT .TXT BROWSE BUTTON CALLBACK
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
[txtName, txtDir] = uigetfile('*.txt*','Select .txt file with offset information');
txtPath = fullfile(txtDir,txtName);
set(handles.edit10,'String',txtPath);
assignin('base','txtPath',txtPath);
if ~isempty(get(handles.edit9,'String')) && ...
        ~isempty(get(handles.edit11,'String'))
    set(handles.pushbutton1,'Enable','on');
end

% ----- GELATIN CONCENTRATION EDIT CALLBACK
function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gelatinCon = str2double(get(hObject,'String'));
if gelatinCon <= 0 || isnan(gelatinCon)
    gelatinCon = 1;
end
set(hObject,'String',gelatinCon);
assignin('base','gelatinCon',gelatinCon);
if ~isempty(get(handles.edit9,'String')) && ...
        ~isempty(get(handles.edit10,'String'))
    set(handles.pushbutton1,'Enable','on');
end

% ----- XZ PLANE EDIT CALLBACK
function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% ----- YZ PLANE EDIT CALLBACK
function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% ----- SIDE 1 DATA SELECT BUTTON CALLBACK
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.radiobutton30,'Value') == get(handles.radiobutton30,'Max'))
    SIDE1inFolderFrames = uigetdir('C:\', 'Select folder with side 1 frame data');
    set(handles.edit12,'String',SIDE1inFolderFrames);
    assignin('base','SIDE1inFolderFrames',SIDE1inFolderFrames);
else
    [movFilename, movPathname] = uigetfile( ...
        {'*.avi;*.mpg;*.mpeg','Video Files (*.avi,*.mpg,*.mpeg)';
        '*.*',  'All Files (*.*)'}, ...
        'Select video data file');
    SIDE1vidFilePath = fullfile(movPathname,movFilename);
    set(handles.edit12,'String',SIDE1vidFilePath);
    assignin('base','SIDE1vidFilePath',SIDE1vidFilePath);
end

% ----- SIDE 2 DATA SELECT BUTTON CALLBACK
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.radiobutton30,'Value') == get(handles.radiobutton30,'Max'))
    SIDE2inFolderFrames = uigetdir('C:\', 'Select folder with side 2 frame data');
    set(handles.edit13,'String',SIDE2inFolderFrames);
    assignin('base','SIDE2inFolderFrames',SIDE2inFolderFrames);
else
    [movFilename, movPathname] = uigetfile( ...
        {'*.avi;*.mpg;*.mpeg','Video Files (*.avi,*.mpg,*.mpeg)';
        '*.*',  'All Files (*.*)'}, ...
        'Select side 2 video data file');
    SIDE2vidFilePath = fullfile(movPathname,movFilename);
    set(handles.edit13,'String',SIDE2vidFilePath);
    assignin('base','SIDE1vidFilePath',SIDE2vidFilePath);
end

% ----- IS 405nm APPARENT LASER
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    assignin('base','is405',1);
elseif (get(hObject,'Value') == get(hObject,'Min'))
    assignin('base','is405',0);
end


% 'Create' functions
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
set(hObject,'SliderStep',[1/(40-1),1/(40-1)]);
%set(hObject,'Max',40);
%set(hObject,'Min',1);
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
  
end
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
