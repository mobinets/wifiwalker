function varargout = GUIHumanIdentify(varargin)
% GUIHUMANIDENTIFY MATLAB code for GUIHumanIdentify.fig
%      GUIHUMANIDENTIFY, by itself, creates a new GUIHUMANIDENTIFY or raises the existing
%      singleton*.
%
%      H = GUIHUMANIDENTIFY returns the handle to a new GUIHUMANIDENTIFY or the handle to
%      the existing singleton*.
%
%      GUIHUMANIDENTIFY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIHUMANIDENTIFY.M with the given input arguments.
%
%      GUIHUMANIDENTIFY('Property','Value',...) creates a new GUIHUMANIDENTIFY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUIHumanIdentify_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUIHumanIdentify_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUIHumanIdentify

% Last Modified by GUIDE v2.5 07-Feb-2018 16:02:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIHumanIdentify_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIHumanIdentify_OutputFcn, ...
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


% --- Executes just before GUIHumanIdentify is made visible.
function GUIHumanIdentify_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUIHumanIdentify (see VARARGIN)

% Choose default command line output for GUIHumanIdentify
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUIHumanIdentify wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUIHumanIdentify_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 HumanID=get(handles.edit1,'String');
% a2=str2double(get(handles.edit2,'String'));
% aaa=(1:10)';
% bbb=(1:15)';
% set(handles.text5,'String',num2str(dtw(aaa,bbb)));
CreatekNNMdl(HumanID);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
