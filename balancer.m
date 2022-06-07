function varargout = balancer(varargin)
% BALANCER MATLAB code for balancer.fig
%      BALANCER, by itself, creates a new BALANCER or raises the existing
%      singleton*.
%
%      H = BALANCER returns the handle to a new BALANCER or the handle to
%      the existing singleton*.
%
%      BALANCER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BALANCER.M with the given input arguments.
%
%      BALANCER('Property','Value',...) creates a new BALANCER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before balancer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to balancer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help balancer

% Last Modified by GUIDE v2.5 22-Apr-2022 15:48:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @balancer_OpeningFcn, ...
                   'gui_OutputFcn',  @balancer_OutputFcn, ...
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


% --- Executes just before balancer is made visible.
function balancer_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to audio_begin
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to balancer (see VARARGIN)

% Choose default command line output for balancer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes balancer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = balancer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to audio_begin
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in audioload.
function audioload_Callback(hObject, eventdata, handles)
% hObject    handle to audioload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global  w1;
try
    [FileName] = uigetfile('*','Select the audio file');
    [handles.audio , handles.audioFs ] = audioread(FileName) ; 
    N=length(handles.audio);
    Audio_f=abs(fft(handles.audio,N));
    fs=handles.audioFs;
    b = fir1(1000, [3000*2/fs 6000*2/fs]);
    [hn,w1]=freqz(b,1,N);
    plot( handles.audio_begin,w1*fs/(pi),Audio_f); 
     xlim(handles.audio_begin,[0,16000]);
    handles.audioname.String = FileName;
    
    handles.audio_100 = fx_FIR( handles.audioFs, 1 ,100 , handles.audio);
    handles.audio_200 = fx_FIR( handles.audioFs, 100 ,200 , handles.audio);
    handles.audio_500 = fx_FIR( handles.audioFs, 200 ,500 , handles.audio);
    handles.audio_1K = fx_FIR( handles.audioFs, 500 ,1000 , handles.audio);
    handles.audio_2K = fx_FIR( handles.audioFs, 1000 ,2000 , handles.audio);
    handles.audio_4K = fx_FIR( handles.audioFs, 2000 ,4000 , handles.audio);
    handles.audio_8K = fx_FIR( handles.audioFs, 4000 ,8000 , handles.audio);
    handles.audio_16K = fx_FIR( handles.audioFs, 8000 ,16000 , handles.audio);
    
    handles.now_audio = handles.audio_100 + handles.audio_200+ handles.audio_500 + handles.audio_1K + handles.audio_2K+ handles.audio_4K + handles.audio_8K + handles.audio_16K;
    sound( handles.now_audio , handles.audioFs );
    
    Audio_ff = abs( fft( handles.now_audio ) );
    plot( handles.audio_end ,w1*fs/(pi), Audio_ff);
    xlim(handles.audio_end ,[0,16000]);
    
end
% Update handles structure
guidata(hObject, handles);


function audioname_Callback(hObject, eventdata, handles)
% hObject    handle to audioname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of audioname as text
%        str2double(get(hObject,'String')) returns contents of audioname as a double


% --- Executes during object creation, after setting all properties.
function audioname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to audioname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function Freq100_Callback(hObject, eventdata, handles)
% hObject    handle to Freq100 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    a = get(handles.Freq100 , 'Value');
    b = get(handles.Freq200 , 'Value');
    c = get(handles.Freq500 , 'Value');
    d = get(handles.Freq1K , 'Value');
    e = get(handles.Freq2K , 'Value');
    f = get(handles.Freq4K , 'Value');
    g = get(handles.Freq8K , 'Value');
    h = get(handles.Freq16K , 'Value');
    
    handles.Freq100num.String = num2str( a*100 );
    all = get(handles.audiovoice , 'Value');
    handles.now_audio = all*( a*handles.audio_100 + b*handles.audio_200 + c*handles.audio_500 + d*handles.audio_1K + e*handles.audio_2K + f*handles.audio_4K + g*handles.audio_8K + h*handles.audio_16K );
    Audio_ff = abs( fft( handles.now_audio ) );
    global w1;
    plot( handles.audio_end ,w1*handles.audioFs/pi, Audio_ff );
   xlim(handles.audio_end ,[0,16000]);
end
guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Freq100_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Freq100 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider7_Callback(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider8_Callback(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider9_Callback(hObject, eventdata, handles)
% hObject    handle to slider9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider10_Callback(hObject, eventdata, handles)
% hObject    handle to slider10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider11_Callback(hObject, eventdata, handles)
% hObject    handle to slider11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider12_Callback(hObject, eventdata, handles)
% hObject    handle to slider12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider13_Callback(hObject, eventdata, handles)
% hObject    handle to slider13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function audiovoice_Callback(hObject, eventdata, handles)
% hObject    handle to audiovoice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    all = get(handles.audiovoice , 'Value')
    handles.audiovoicenum.String = num2str( all/4*100 );
    handles.now_audio = all * handles.now_audio;
end
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function audiovoice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to audiovoice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function Freq100num_Callback(hObject, eventdata, handles)
% hObject    handle to Freq100num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Freq100num as text
%        str2double(get(hObject,'String')) returns contents of Freq100num as a double


% --- Executes during object creation, after setting all properties.
function Freq100num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Freq100num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Freq200num_Callback(hObject, eventdata, handles)
% hObject    handle to Freq200num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Freq200num as text
%        str2double(get(hObject,'String')) returns contents of Freq200num as a double


% --- Executes during object creation, after setting all properties.
function Freq200num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Freq200num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Freq500num_Callback(hObject, eventdata, handles)
% hObject    handle to Freq500num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Freq500num as text
%        str2double(get(hObject,'String')) returns contents of Freq500num as a double


% --- Executes during object creation, after setting all properties.
function Freq500num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Freq500num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Freq1Knum_Callback(hObject, eventdata, handles)
% hObject    handle to Freq1Knum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Freq1Knum as text
%        str2double(get(hObject,'String')) returns contents of Freq1Knum as a double


% --- Executes during object creation, after setting all properties.
function Freq1Knum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Freq1Knum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Freq2Knum_Callback(hObject, eventdata, handles)
% hObject    handle to Freq2Knum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Freq2Knum as text
%        str2double(get(hObject,'String')) returns contents of Freq2Knum as a double


% --- Executes during object creation, after setting all properties.
function Freq2Knum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Freq2Knum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Freq4Knum_Callback(hObject, eventdata, handles)
% hObject    handle to Freq4Knum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Freq4Knum as text
%        str2double(get(hObject,'String')) returns contents of Freq4Knum as a double


% --- Executes during object creation, after setting all properties.
function Freq4Knum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Freq4Knum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Freq8Knum_Callback(hObject, eventdata, handles)
% hObject    handle to Freq8Knum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Freq8Knum as text
%        str2double(get(hObject,'String')) returns contents of Freq8Knum as a double


% --- Executes during object creation, after setting all properties.
function Freq8Knum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Freq8Knum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Freq16Knum_Callback(hObject, eventdata, handles)
% hObject    handle to Freq16Knum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Freq16Knum as text
%        str2double(get(hObject,'String')) returns contents of Freq16Knum as a double


% --- Executes during object creation, after setting all properties.
function Freq16Knum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Freq16Knum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function audiovoicenum_Callback(hObject, eventdata, handles)
% hObject    handle to audiovoicenum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of audiovoicenum as text
%        str2double(get(hObject,'String')) returns contents of audiovoicenum as a double


% --- Executes during object creation, after setting all properties.
function audiovoicenum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to audiovoicenum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function Freq200_Callback(hObject, eventdata, handles)
% hObject    handle to Freq200 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    a = get(handles.Freq100 , 'Value');
    b = get(handles.Freq200 , 'Value');
    c = get(handles.Freq500 , 'Value');
    d = get(handles.Freq1K , 'Value');
    e = get(handles.Freq2K , 'Value');
    f = get(handles.Freq4K , 'Value');
    g = get(handles.Freq8K , 'Value');
    h = get(handles.Freq16K , 'Value');
    
    handles.Freq200num.String = num2str( b*100 );
    all = get(handles.audiovoice , 'Value');
    handles.now_audio = all*( a*handles.audio_100 + b*handles.audio_200 + c*handles.audio_500 + d*handles.audio_1K + e*handles.audio_2K + f*handles.audio_4K + g*handles.audio_8K + h*handles.audio_16K );
    Audio_ff = abs( fft( handles.now_audio ) );
    global w1;
  plot( handles.audio_end ,w1*handles.audioFs/pi, Audio_ff );
   xlim(handles.audio_end ,[0,16000]);
end
guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Freq200_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Freq200 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Freq500_Callback(hObject, eventdata, handles)
% hObject    handle to Freq500 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    a = get(handles.Freq100 , 'Value');
    b = get(handles.Freq200 , 'Value');
    c = get(handles.Freq500 , 'Value');
    d = get(handles.Freq1K , 'Value');
    e = get(handles.Freq2K , 'Value');
    f = get(handles.Freq4K , 'Value');
    g = get(handles.Freq8K , 'Value');
    h = get(handles.Freq16K , 'Value');
    
    handles.Freq500num.String = num2str( c*100 );
    all = get(handles.audiovoice , 'Value');
    handles.now_audio = all*( a*handles.audio_100 + b*handles.audio_200 + c*handles.audio_500 + d*handles.audio_1K + e*handles.audio_2K + f*handles.audio_4K + g*handles.audio_8K + h*handles.audio_16K );
    Audio_ff = abs( fft( handles.now_audio ) );
    global w1;
  plot( handles.audio_end ,w1*handles.audioFs/pi, Audio_ff );
   xlim(handles.audio_end ,[0,16000]);
end
guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Freq500_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Freq500 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Freq1K_Callback(hObject, eventdata, handles)
% hObject    handle to Freq1K (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    a = get(handles.Freq100 , 'Value');
    b = get(handles.Freq200 , 'Value');
    c = get(handles.Freq500 , 'Value');
    d = get(handles.Freq1K , 'Value');
    e = get(handles.Freq2K , 'Value');
    f = get(handles.Freq4K , 'Value');
    g = get(handles.Freq8K , 'Value');
    h = get(handles.Freq16K , 'Value');
    
    handles.Freq1Knum.String = num2str( d*100 );
    all = get(handles.audiovoice , 'Value');
    handles.now_audio = all*( a*handles.audio_100 + b*handles.audio_200 + c*handles.audio_500 + d*handles.audio_1K + e*handles.audio_2K + f*handles.audio_4K + g*handles.audio_8K + h*handles.audio_16K );
    Audio_ff = abs( fft( handles.now_audio ) );
    global w1;
  plot( handles.audio_end ,w1*handles.audioFs/pi, Audio_ff );
   xlim(handles.audio_end ,[0,16000]);
end
guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Freq1K_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Freq1K (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Freq2K_Callback(hObject, eventdata, handles)
% hObject    handle to Freq2K (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    a = get(handles.Freq100 , 'Value');
    b = get(handles.Freq200 , 'Value');
    c = get(handles.Freq500 , 'Value');
    d = get(handles.Freq1K , 'Value');
    e = get(handles.Freq2K , 'Value');
    f = get(handles.Freq4K , 'Value');
    g = get(handles.Freq8K , 'Value');
    h = get(handles.Freq16K , 'Value');
    
    handles.Freq2Knum.String = num2str( e*100 );
    all = get(handles.audiovoice , 'Value');
    handles.now_audio = all*( a*handles.audio_100 + b*handles.audio_200 + c*handles.audio_500 + d*handles.audio_1K + e*handles.audio_2K + f*handles.audio_4K + g*handles.audio_8K + h*handles.audio_16K );
    Audio_ff = abs( fft( handles.now_audio ) );
    global w1;
  plot( handles.audio_end ,w1*handles.audioFs/pi, Audio_ff );
   xlim(handles.audio_end ,[0,16000]);
end
guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Freq2K_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Freq2K (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Freq4K_Callback(hObject, eventdata, handles)
% hObject    handle to Freq4K (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    a = get(handles.Freq100 , 'Value');
    b = get(handles.Freq200 , 'Value');
    c = get(handles.Freq500 , 'Value');
    d = get(handles.Freq1K , 'Value');
    e = get(handles.Freq2K , 'Value');
    f = get(handles.Freq4K , 'Value');
    g = get(handles.Freq8K , 'Value');
    h = get(handles.Freq16K , 'Value');
    
    handles.Freq4Knum.String = num2str( f*100 );
    all = get(handles.audiovoice , 'Value');
    handles.now_audio = all*( a*handles.audio_100 + b*handles.audio_200 + c*handles.audio_500 + d*handles.audio_1K + e*handles.audio_2K + f*handles.audio_4K + g*handles.audio_8K + h*handles.audio_16K );
    Audio_ff = abs( fft( handles.now_audio ) );
    global w1;
  plot( handles.audio_end ,w1*handles.audioFs/pi, Audio_ff );
   xlim(handles.audio_end ,[0,16000]);
end
guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Freq4K_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Freq4K (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Freq8K_Callback(hObject, eventdata, handles)
% hObject    handle to Freq8K (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    a = get(handles.Freq100 , 'Value');
    b = get(handles.Freq200 , 'Value');
    c = get(handles.Freq500 , 'Value');
    d = get(handles.Freq1K , 'Value');
    e = get(handles.Freq2K , 'Value');
    f = get(handles.Freq4K , 'Value');
    g = get(handles.Freq8K , 'Value');
    h = get(handles.Freq16K , 'Value');
    
    handles.Freq8Knum.String = num2str( g*100 );
    all = get(handles.audiovoice , 'Value');
    handles.now_audio = all*( a*handles.audio_100 + b*handles.audio_200 + c*handles.audio_500 + d*handles.audio_1K + e*handles.audio_2K + f*handles.audio_4K + g*handles.audio_8K + h*handles.audio_16K );
    Audio_ff = abs( fft( handles.now_audio ) );
    global w1;
  plot( handles.audio_end ,w1*handles.audioFs/pi, Audio_ff );
   xlim(handles.audio_end ,[0,16000]);
end
guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Freq8K_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Freq8K (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Freq16K_Callback(hObject, eventdata, handles)
% hObject    handle to Freq16K (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    a = get(handles.Freq100 , 'Value');
    b = get(handles.Freq200 , 'Value');
    c = get(handles.Freq500 , 'Value');
    d = get(handles.Freq1K , 'Value');
    e = get(handles.Freq2K , 'Value');
    f = get(handles.Freq4K , 'Value');
    g = get(handles.Freq8K , 'Value');
    h = get(handles.Freq16K , 'Value');
    
    handles.Freq16Knum.String = num2str( h*100 );
    all = get(handles.audiovoice , 'Value');
    handles.now_audio = all*( a*handles.audio_100 + b*handles.audio_200 + c*handles.audio_500 + d*handles.audio_1K + e*handles.audio_2K + f*handles.audio_4K + g*handles.audio_8K + h*handles.audio_16K );
    Audio_ff = abs( fft( handles.now_audio ) );
    global w1;
  plot( handles.audio_end ,w1*handles.audioFs/pi, Audio_ff );
   xlim(handles.audio_end ,[0,16000]);
end
guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Freq16K_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Freq16K (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in play.
function play_Callback(hObject, eventdata, handles)
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    sound( handles.now_audio , handles.audioFs );
    %audiowrite('a_good_try.wav',handles.now_audio , handles.audioFs);
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function audio_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to audio_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate audio_end


% --- Executes during object creation, after setting all properties.
function audio_begin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to audio_begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate audio_begin


% --- Executes on key press with focus on audiovoice and none of its controls.
function audiovoice_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to audiovoice (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over audiovoice.
function audiovoice_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to audiovoice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
