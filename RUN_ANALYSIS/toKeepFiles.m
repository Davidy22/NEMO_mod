function varargout = toKeepFiles(varargin)
% TOKEEPFILES MATLAB code for toKeepFiles.fig
%      TOKEEPFILES, by itself, creates a new TOKEEPFILES or raises the existing
%      singleton*.
%
%      H = TOKEEPFILES returns the handle to a new TOKEEPFILES or the handle to
%      the existing singleton*.
%
%      TOKEEPFILES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TOKEEPFILES.M with the given input arguments.
%
%      TOKEEPFILES('Property','Value',...) creates a new TOKEEPFILES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before toKeepFiles_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to toKeepFiles_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help toKeepFiles

% Last Modified by GUIDE v2.5 23-Jun-2016 14:05:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @toKeepFiles_OpeningFcn, ...
                   'gui_OutputFcn',  @toKeepFiles_OutputFcn, ...
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


% --- Executes just before toKeepFiles is made visible.
function toKeepFiles_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to toKeepFiles (see VARARGIN)

% Choose default command line output for toKeepFiles
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes toKeepFiles wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = toKeepFiles_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% ----------------------------------------------------------------%


% --- BINARIZED FRAMES
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
if (get(hObject,'Value') == get(hObject,'Max'))
    assignin('base','keepBinarizedFrames',1);
else
    assignin('base','keepBinarizedFrames',0); 
end


% --- BINARIZED MOVIE
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
if (get(hObject,'Value') == get(hObject,'Max'))
    assignin('base','makeBinarizedMovie',1);
else
    assignin('base','makeBinarizedMovie',0); 
end


% --- SKELETON DATA
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3 
if (get(hObject,'Value') == get(hObject,'Max'))
    assignin('base','keepSkelCoords',1);
else
    assignin('base','keepSkelCoords',0); 
end


% --- PIXEL COORDINATES
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4

if (get(hObject,'Value') == get(hObject,'Max'))
    assignin('base','keepPixCoords',1);
else
    assignin('base','keepPixCoords',0);
end


% --- PLATFORM OFFSET DATA
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5
if (get(hObject,'Value') == get(hObject,'Max'))
    assignin('base','keepExcelOffsetData',1);
else
    assignin('base','keepExcelOffsetData',0); 
end


% --- INTERPOLATED PLATFORM OFFSET DATA
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6
if (get(hObject,'Value') == get(hObject,'Max'))
    assignin('base','keepExcelOffsetDataInterp',1);
else
    assignin('base','keepExcelOffsetDataInterp',0); 
end


% --- PLOTS
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7
if (get(hObject,'Value') == get(hObject,'Max'))
    assignin('base','keepPlots',1);
else
    assignin('base','keepPlots',0);
end


% --- SAVE BUTTON
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close

% below is not used
% --- Executes during object creation, after setting all properties.
function checkbox4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
