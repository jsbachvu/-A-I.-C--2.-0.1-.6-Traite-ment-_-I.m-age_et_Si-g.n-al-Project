function varargout = MainApplication(varargin)
% MAINAPPLICATION MATLAB code for MainApplication.fig
%      MAINAPPLICATION, by itself, creates a new MAINAPPLICATION or raises the existing
%      singleton*.
%
%      H = MAINAPPLICATION returns the handle to a new MAINAPPLICATION or the handle to
%      the existing singleton*.
%
%      MAINAPPLICATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINAPPLICATION.M with the given input arguments.
%
%      MAINAPPLICATION('Property','Value',...) creates a new MAINAPPLICATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MainApplication_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MainApplication_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MainApplication

% Last Modified by GUIDE v2.5 28-Dec-2016 01:45:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @MainApplication_OpeningFcn, ...
    'gui_OutputFcn',  @MainApplication_OutputFcn, ...
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

% --- Executes just before MainApplication is made visible.
function MainApplication_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MainApplication (see VARARGIN)

% Choose default command line output for MainApplication
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MainApplication wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MainApplication_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in openButton.
function openButton_Callback(hObject, eventdata, handles)
% hObject    handle to openButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fileName,~] = imgetfile;

image = double(imread(fileName));

setappdata(0,'image',image);
setappdata(0,'isDenoise',0);
setappdata(0,'isNoiseCreated',0);
setappdata(0,'methode',1);

axes(handles.imageAxes);
imshow(fileName);title('Original Image');



% --- Executes on button press in saveButton.
function saveButton_Callback(hObject, eventdata, handles)



% --- Executes on selection change in denoiseFunctionMenu.
function denoiseFunctionMenu_Callback(hObject, eventdata, handles)
% Determine the selected data set.
str = get(hObject, 'String');
val = get(hObject,'Value');

switch str{val};
    case 'NLMeans'
        setappdata(0,'methode',1);
    case 'Bilateral'
        setappdata(0,'methode',2);
    case 'Median'
        setappdata(0,'methode',3);
end

% --- Executes during object creation, after setting all properties.
function denoiseFunctionMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to denoiseFunctionMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.



% --- Executes on button press in denoiseButton.
function denoiseButton_Callback(hObject, eventdata, handles)

if getappdata(0,'isNoiseCreated') == 0
    noiseImage = getappdata(0,'image');
    axes(handles.noiseImageAxes);
    noiseImageShow = mat2gray(noiseImage);
    imshow(noiseImageShow);title('Noise Image');
else
    noiseImage = getappdata(0,'noiseImage');
end

if getappdata(0,'methode') == 1
    if getappdata(0,'isDenoise') == 0
        noiseEstimationButton_Callback(hObject, eventdata, handles);
    end
    denoiseImage = getappdata(0,'denoiseImage');
else if getappdata(0,'methode') == 2
        
        denoiseImage = bilateralFilter(noiseImage,3,1,5);
    else if getappdata(0,'methode') == 3
            denoiseImage = medianFilter(noiseImage,5);
        end
    end
end

denoiseImage = mat2gray(denoiseImage);
axes(handles.denoiseImageAxes);
imshow(denoiseImage);title('Denoise Image');

disp('Done DeNoise Estimation');





% --- Executes on button press in createNoiseButton.
function createNoiseButton_Callback(hObject, eventdata, handles)

image = getappdata(0,'image');

[M, N, T] = size(image);

a = getappdata(0,'aCoefficient');
b = getappdata(0,'bCoefficient');
c = getappdata(0,'cCoefficient');

noiseLevelFunction = @(x) a * x.^2 + b * x + c;
noiseImage = image + sqrt(noiseLevelFunction(image)) .* randn(M, N, T);

axes(handles.noiseImageAxes);
noiseImageShow = mat2gray(noiseImage);
imshow(noiseImageShow);title('Noise Image');

setappdata(0,'noiseImage',noiseImage);
setappdata(0,'isNoiseCreated',1);



function aCoefficientEditText_Callback(hObject, eventdata, handles)
setappdata(0,'aCoefficient', str2double(get(hObject,'String')) );


% --- Executes during object creation, after setting all properties.
function aCoefficientEditText_CreateFcn(hObject, eventdata, handles)


function bCoefficientEditText_Callback(hObject, eventdata, handles)
setappdata(0,'bCoefficient', str2double(get(hObject,'String')) );


% --- Executes during object creation, after setting all properties.
function bCoefficientEditText_CreateFcn(hObject, eventdata, handles)


function cCoefficientEditText_Callback(hObject, eventdata, handles)
setappdata(0,'cCoefficient', str2double(get(hObject,'String')) );


% --- Executes during object creation, after setting all properties.
function cCoefficientEditText_CreateFcn(hObject, eventdata, handles)


% --- Executes on button press in noiseEstimationButton.
function noiseEstimationButton_Callback(hObject, eventdata, handles)
% hObject    handle to noiseEstimationButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if getappdata(0,'isNoiseCreated') == 0
    noiseImage = getappdata(0,'image');
    axes(handles.noiseImageAxes);
    noiseImageShow = mat2gray(noiseImage);
    imshow(noiseImageShow);title('Noise Image');
else
    noiseImage = getappdata(0,'noiseImage');
end

[denoiseImage,coefficient] = DenoiseBasedNoiseLevelEstimation(noiseImage);

setappdata(0,'denoiseImage',denoiseImage);

coefficientText = sprintf('NLF(x) = %f x^2 + %f x + %f',coefficient(3),coefficient(2),coefficient(1) );
set(handles.noiseEstimationText, 'String', coefficientText);

setappdata(0,'isDenoise',1);

disp('Done Noise Estimation');
