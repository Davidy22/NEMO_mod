function varargout = GUIDE(varargin)
% GUIDE MATLAB code for GUIDE.fig
%      GUIDE, by itself, creates a new GUIDE or raises the existing
%      singleton*.
%
%      H = GUIDE returns the handle to a new GUIDE or the handle to
%      the existing singleton*.
%
%      GUIDE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIDE.M with the given input arguments.
%
%      GUIDE('Property','Value',...) creates a new GUIDE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUIDE_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUIDE_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUIDE

% Last Modified by GUIDE v2.5 06-May-2016 17:55:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIDE_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIDE_OutputFcn, ...
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

% --- Executes just before GUIDE is made visible.
function GUIDE_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUIDE (see VARARGIN)

% Choose default command line output for GUIDE
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUIDE wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = GUIDE_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% ----------------------------------------------------------------- %

% Begin by assuming default settings for analysis
% assignin('base','twoD',1);
% assignin('base','highRes', 1);
% assignin('base','pixCoords', 1);
% assignin('base','darkField', 1);
% assignin('base','adultW', 1);
% assignin('base','testType', 'freemotion');
% assignin('base','FPS', 30);
% assignin('base','pxpMM', 320);
% assignin('base','startFrame', 1);
% assignin('base','endFrame', 2);
% assignin('base','segNum', 20);
% assignin('base','isFrames', 1);


% ------------------------------------------------------------------ %

% ----- YES 2D RADIOB CALLBACK
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% Hint: get(hObject,'Value') returns toggle state of radiobutton1
if (get(hObject,'Value') == get(hObject,'Max'))
    assignin('base','twoD',1);
end

% ------ NOT 2D RADIOB CALLBACK
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% Hint: get(hObject,'Value') returns toggle state of radiobutton1
if (get(hObject,'Value') == get(hObject,'Max'))
    assignin('base','twoD',0);
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

% ----- YES PIXCOORDS RADIOB CALLBACK
function radiobutton9_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton9 (see GCBO)
if (get(hObject,'Value') == get(hObject,'Max'))
    assignin('base','pixCoords',1);
end

% ---- NO PIXCOORDS RADIOB CALLBACK
function radiobutton10_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton9 (see GCBO)
if (get(hObject,'Value') == get(hObject,'Max'))
    assignin('base','pixCoords',0);
end

% ----- DARKFIELD RADIOB CALLBACK
function radiobutton12_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton9 (see GCBO)
if (get(hObject,'Value') == get(hObject,'Max'))
    assignin('base','darkField',1);
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
if (segNum > 40)
    set(handles.slider1,'Value',40);
    set(hObject,'String',40);
else
    set(handles.slider1,'Value',segNum);
    set(hObject,'String',segNum);
end
assignin('base','segNum',segNum);

% ----- SEGMENTS SLIDER CALLBACK (coupled with text)
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles = guidata(hObject);
sliderValue = get(handles.slider1,'Value');
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
    startFrame = round(str2double(get(handles.edit2,'String'))) - 1;
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
    endFrame = round(str2double(get(handles.edit1,'String'))) + 1;
end
set(hObject,'String',endFrame);
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

% ----- YES FRAMES RADIOB CALLBACK
function radiobutton30_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radiobutton30
if (get(hObject,'Value') == get(hObject,'Max'))
    assignin('base','isFrames',1);
end

% ----- NOT FRAMES RADIOB CALLBACK
function radiobutton31_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radiobutton31
if (get(hObject,'Value') == get(hObject,'Max'))
    assignin('base','isFrames',0);
end


% ----------------------------------------------------------------- %


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
