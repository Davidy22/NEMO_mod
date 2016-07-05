function varargout = interface1(varargin)
% INTERFACE1 MATLAB code for interface1.fig
%      INTERFACE1, by itself, creates a new INTERFACE1 or raises the existing
%      singleton*.
%
%      H = INTERFACE1 returns the handle to a new INTERFACE1 or the handle to
%      the existing singleton*.
%
%      INTERFACE1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERFACE1.M with the given input arguments.
%
%      INTERFACE1('Property','Value',...) creates a new INTERFACE1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before interface1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop1.  All inputs are passed to interface1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help interface1

% Last Modified by GUIDE v2.5 31-Jul-2015 17:26:34

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @interface1_OpeningFcn, ...
    'gui_OutputFcn',  @interface1_OutputFcn, ...
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


% --- Executes just before interface1 is made visible.
function interface1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to interface1 (see VARARGIN)

global files1
global phase
global cmap
global start1
global finish1
global maxrange1
global current1
global stop1

stop1 = false;

handles.start=varargin{1}{1};
handles.finish=varargin{1}{2};

maxrange1=finish1-start1+1;

contents=dir('DATA');
files1=cell(length(contents),1);

for i=start1:finish1
    filename=['DATA/' num2str(i) '.png'];
    files1{i}=filename;
end
files1=files1(1:i);

% Choose default command line output for interface1
handles.output=hObject;

%get the values from the parameters

set(handles.slider4,'Enable','off')
set(handles.pushbutton6,'Enable','off')
set(handles.pushbutton7,'Enable','on')
set(handles.pushbutton1,'Enable','off')
set(handles.pushbutton2,'Enable','off')
set(handles.pushbutton3,'Enable','off')
set(handles.pushbutton5,'Enable','off')

set(handles.slider4,'Max',maxrange1)
set(handles.slider4,'Min',1)
set(handles.slider4,'Value',maxrange1+1-current1+start1)
set(handles.slider4,'SliderStep',[1/maxrange1,10/maxrange1])

phase=zeros(finish1-start1+1,1);
phase(1)=100;

cmap=zeros(finish1-start1+1,3);
cmap(:,2)=1;

%Set the variables to 0

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes interface1 wait for user response (see UIRESUME)
uiwait
end

% --- Outputs from this function are returned to the command line.
function varargout = interface1_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = 1;

% imshow('') %shows an empty image
end

% --- Executes on button press in Start Button.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global stop1
global f
global r
global o
global files1
global current1
global cmap
global RGB
global maxrange1
global start1

f = true;
r = false;
o = false;

RGB=zeros(maxrange1,round(maxrange1/15),3);

axes(handles.axes3)
set(handles.pushbutton7,'Enable','off')
set(handles.pushbutton6,'Enable','on')
set(handles.pushbutton1,'Enable','off')
set(handles.pushbutton2,'Enable','off')
set(handles.pushbutton3,'Enable','off')
set(handles.pushbutton5,'Enable','off')

while current1<handles.finish
    
    if stop1
        break
    end
    
    axes(handles.axes3)
    current1=current1+1;
    y=[files1{current1}];
    imshow(y)
    
    pause(.1)
    
    if cmap(current1-start1+1,1)==0 && cmap(current1-start1+1,2)==1
        statous = 'Forward';
    elseif cmap(current1-start1+1,1)==1 && cmap(current1-start1+1,2)==1
        statous = 'Reversal';
    elseif cmap(current1-start1+1,1)==1 && cmap(current1-start1+1,2)==0
        statous = 'Omega';
    end
    
    if stop1
        break
    end
    
    axes(handles.axes7)
    for i=1:maxrange1-1
        RGB(i,:,1)=cmap(i,1);
        RGB(i,:,2)=cmap(i,2);
        RGB(i,:,3)=cmap(i,3);
    end
    imshow(RGB)

    if stop1
        break
    end
        
    set(handles.mytext,'String',['Frame number: ' num2str(current1)])
    set(handles.mytext2,'String',['Direction: ' statous])
end

end

% --- Executes on button press in Play/Pause button.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1

global pause
global maxrange1
global current1
global files1
global start1

if(strcmp(get(handles.pushbutton6,'String'),'Pause'))
    set(handles.pushbutton6,'String','Play');
    set(handles.slider4,'Enable','on');
    set(handles.slider4,'Value',maxrange1+1-current1+start1)
    set(handles.pushbutton1,'Enable','on')
    set(handles.pushbutton2,'Enable','on')
    set(handles.pushbutton3,'Enable','on')
    set(handles.pushbutton5,'Enable','on')
    axes(handles.axes5)
        y=[files1{current1}];
        imshow(y)
    axes(handles.axes4)
        if current1==handles.start
            x='';
        else
            x=[files1{current1-1}];
        end
        imshow(x)
    axes(handles.axes6)
        if current1==handles.finish
            z='';
        else
            z=[files1{current1+1}];
        end
        imshow(z)
    axes(handles.axes3)
        imshow(y)
    pause=true;
    uiwait();
else
    uiresume();
    set(handles.pushbutton6,'String','Pause');
    set(handles.slider4,'Enable','off');
    set(handles.pushbutton1,'Enable','off')
    set(handles.pushbutton2,'Enable','off')
    set(handles.pushbutton3,'Enable','off')
    set(handles.pushbutton5,'Enable','off')
end

end

% --- Executes on button press in Forward button.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global f
global o
global r
global phase
global current1
global maxrange1
global cmap
global RGB
global start1

f = true;
r = false;
o = false;

statous='Forward'; 
phase(current1-start1+1)=100;

    cmap(current1-start1+1,:)=[0 1 0];
        for i=2:maxrange1
            if phase(i)==0
                cmap(i,:)=cmap(i-1,:);
            end
        end

axes(handles.axes7)
    for i=1:maxrange1
        RGB(i,:,1)=cmap(i,1);
        RGB(i,:,2)=cmap(i,2);
        RGB(i,:,3)=cmap(i,3);
    end
    imshow(RGB)
    
    
set(handles.mytext2,'String',['Direction: ' statous])
end

% --- Executes on button press in Reversal button.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global o
global f
global r
global phase
global current1
global maxrange1
global cmap
global RGB
global start1

r = true;
f = false;
o = false;

statous='Reversal';
phase(current1-start1+1)=110;

    cmap(current1-start1+1,:)=[1 1 0];
        for i=2:maxrange1
            if phase(i)==0
                cmap(i,:)=cmap(i-1,:);
            end
        end
axes(handles.axes7)
    for i=1:maxrange1
        RGB(i,:,1)=cmap(i,1);
        RGB(i,:,2)=cmap(i,2);
        RGB(i,:,3)=cmap(i,3);
    end
    imshow(RGB)
    
set(handles.mytext2,'String',['Direction: ' statous])
end

% --- Executes on button press in Omega button.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global o
global f
global r
global phase
global current1
global maxrange1
global cmap
global RGB
global start1

f = false;
r = false;
o = true;

statous='Omega';
phase(current1-start1+1)=111;

    cmap(current1-start1+1,:)=[1 0 0];
        for i=2:maxrange1
            if phase(i)==0
                cmap(i,:)=cmap(i-1,:);
            end
        end
        
axes(handles.axes7)
    for i=1:maxrange1
        RGB(i,:,1)=cmap(i,1);
        RGB(i,:,2)=cmap(i,2);
        RGB(i,:,3)=cmap(i,3);
    end
    imshow(RGB)
        
set(handles.mytext2,'String',['Direction: ' statous])
end

% --- Executes on button press in Clear button.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global phase
global current1
global maxrange1
global cmap
global RGB
global start1
global finish1

searcharea=current1-round(maxrange1/40)-start1:current1+round(maxrange1/40)-start1;
searcharea(searcharea<start1)=[];
searcharea(searcharea>finish1)=[];
phase(min(searcharea):max(searcharea))=0;

for i=2:maxrange1
    if phase(i)==0
        cmap(i,:)=cmap(i-1,:);
    end
end
        
axes(handles.axes7)
    for i=1:maxrange1
        RGB(i,:,1)=cmap(i,1);
        RGB(i,:,2)=cmap(i,2);
        RGB(i,:,3)=cmap(i,3);
    end
    imshow(RGB)
    
    if cmap(current1-start1+1,1)==0 && cmap(current1-start1+1,2)==1
        statous = 'Forward';
    elseif cmap(current1-start1+1,1)==1 && cmap(current1-start1+1,2)==1
        statous = 'Reversal';
    elseif cmap(current1-start1+1,1)==1 && cmap(current1-start1+1,2)==0
        statous = 'Omega';
    end
        
set(handles.mytext2,'String',['Direction: ' statous])
end

% --- Executes on button press in DONE button
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global stop1
global maxrange1
global phase

stop1 = true;

%Writes the directions and frame numbers on the file
for i=2:maxrange1
    if phase(i)==0
        phase(i)=phase(i-1);
    end
end

csvwrite('phase.csv',phase)
uiresume

close all
% fclose(fileID); %closes the file

end

% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

global current1
global files1
global maxrange1
global cmap
global RGB
global start1

current1=maxrange1+1-round(get(hObject,'Value'))+start1;
axes(handles.axes7)
    for i=1:maxrange1
        RGB(i,:,1)=cmap(i,1);
        RGB(i,:,2)=cmap(i,2);
        RGB(i,:,3)=cmap(i,3);
    end
    imshow(RGB)
axes(handles.axes5)
    y=[files1{current1}];
    imshow(y)
axes(handles.axes4)
    if current1==handles.start
        x='';
    else
        x=[files1{current1-1}];
    end
    imshow(x)
axes(handles.axes6)
    if current1==handles.finish
        z='';
    else
        z=[files1{current1+1}];
    end
    imshow(z)
axes(handles.axes3)
    imshow(y)
    
    if cmap(current1-start1+1,1)==0 && cmap(current1-start1+1,2)==1
        statous = 'Forward';
    elseif cmap(current1-start1+1,1)==1 && cmap(current1-start1+1,2)==1
        statous = 'Reversal';
    elseif cmap(current1-start1+1,1)==1 && cmap(current1-start1+1,2)==0
        statous = 'Omega';
    end
    
set(handles.mytext,'String',['Frame number: ' num2str(current1)])
set(handles.mytext2,'String',['Direction: ' statous])
    
end

% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end




