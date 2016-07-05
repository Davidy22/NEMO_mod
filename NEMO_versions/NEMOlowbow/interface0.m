function varargout = interface0(varargin)
% interface0 MATLAB code for interface0.fig
%      interface0, by itself, creates a new interface0 or raises the existing
%      singleton*.
%
%      H = interface0 returns the handle to a new interface0 or the handle to
%      the existing singleton*.
%
%      interface0('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in interface0.M with the given input arguments.
%
%      interface0('Property','Value',...) creates a new interface0 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before interface0_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop2.  All inputs are passed to interface0_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help interface0

% Last Modified by GUIDE v2.5 31-Jul-2015 17:26:34

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @interface0_OpeningFcn, ...
    'gui_OutputFcn',  @interface0_OutputFcn, ...
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



end


% --- Executes just before interface0 is made visible.
function interface0_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to interface0 (see VARARGIN)

global mainOutFolder
global files0
global maxrange0
global current0
global stop0

stop0 = false;

numberOfFrames=varargin{1};
maxrange0=numberOfFrames;

contents=dir(fullfile(mainOutFolder,'binarized_frames'));
files0=cell(length(contents),1);

for i=1:numberOfFrames
    filename=fullfile(mainOutFolder,'binarized_frames',['frame' num2str(i) '.tif']);
    files0{i}=filename;
end

axes(handles.axes1)
    y=[files0{1}];
    imshow(y)
    
current0=1;

% Choose default command line output for interface0
handles.output=hObject;

set(handles.slider1,'Max',maxrange0)
set(handles.slider1,'Min',1)
set(handles.slider1,'Value',1)
set(handles.slider1,'SliderStep',[1/maxrange0,10/maxrange0])
set(handles.edit1,'String','1')
set(handles.pushbutton1,'String','START')
set(handles.pushbutton2,'String','END')
set(handles.pushbutton3,'Enable','Off')


%get the values from the parameters

%Set the variables to 0

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes interface0 wait for user response (see UIRESUME)
uiwait

end

% --- Outputs from this function are returned to the command line.
function varargout = interface0_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%%% OutputFCN

global start0
global finish0

varargout{1}=start0;
varargout{2}=finish0;

end

% --- Executes on button press in Start Button.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global current0
global start0

start0=current0;
    
set(handles.pushbutton1,'String',num2str(start0))

if strcmpi(get(handles.pushbutton1,'String'),'START')==0 && strcmpi(get(handles.pushbutton2,'String'),'END')==0
    set(handles.pushbutton3,'Enable','On')
end

end

% --- Executes on button press in Finish Button.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global current0
global finish0

finish0=current0;
    
set(handles.pushbutton2,'String',num2str(finish0))

if strcmpi(get(handles.pushbutton1,'String'),'START')==0 && strcmpi(get(handles.pushbutton2,'String'),'END')==0
    set(handles.pushbutton3,'Enable','On')
end

end


% --- Executes on button press in DONE button
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global stop0

stop0 = true;
uiresume

%Writes the directions and frame numbers on the file

close all
% fclose(fileID); %closes the file

end

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

global current0
global files0

current0=round(get(handles.slider1,'Value'));

axes(handles.axes1)
    y=[files0{current0}];
    imshow(y)
    
set(handles.edit1,'String',num2str(current0))
    
end

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents as double

global current0
global files0

current0=round(str2double(get(handles.edit1,'String')));

axes(handles.axes1)
    y=[files0{current0}];
    imshow(y)
    
set(handles.slider1,'Value',current0)
    
end

