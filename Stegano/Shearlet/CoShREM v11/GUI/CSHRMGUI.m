function varargout = CSHRMGUI(varargin)
% SHEARLETEDGEGUI MATLAB code for CSHRMGUI.fig
%      SHEARLETEDGEGUI, by itself, creates a new SHEARLETEDGEGUI or raises the existing
%      singleton*.
%
%      H = SHEARLETEDGEGUI returns the handle to a new SHEARLETEDGEGUI or the handle to
%      the existing singleton*.
%
%      SHEARLETEDGEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SHEARLETEDGEGUI.M with the given input arguments.
%
%      SHEARLETEDGEGUI('Property','Value',...) creates a new SHEARLETEDGEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CSHRMGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CSHRMGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CSHRMGUI

% Last Modified by GUIDE v2.5 02-Oct-2015 17:30:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CSHRMGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @CSHRMGUI_OutputFcn, ...
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


% --- Executes just before CSHRMGUI is made visible.
function CSHRMGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command ridge arguments to CSHRMGUI (see VARARGIN)

% Choose default command ridge output for CSHRMGUI
set(hObject,'units','normalized','outerposition',[0 0 1 1]);
handles.output = hObject;
handles.state = CSHRMGUIstate;
handles.state.lastDir = pwd();
handles = readGUIData(handles);
handles = checkIfShearletSystemIsUpToDate(handles);

dcm_obj = datacursormode(hObject);
set(dcm_obj,'UpdateFcn',@myDataCursorUpdateFct)

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CSHRMGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command ridge.
function varargout = CSHRMGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command ridge output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function menuFile_Callback(hObject, eventdata, handles)
% hObject    handle to menuFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuOpenImage_Callback(hObject, eventdata, handles)
% hObject    handle to menuOpenImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uigetfile('*.*','Select an image',handles.state.lastDir);
if filename == 0
    return;
end
handles.state.lastDir = pathname;
[dummy,handles.state.imageName,fileExt] = fileparts(filename);
if strcmp(fileExt,'.txt')
    handles.state.image = double(dlmread([pathname, filename]));
else
    info = imfinfo([pathname, filename]);
    if isequal(info.ColorType,'grayscale')
        handles.state.image = double(imread([pathname, filename]));
    elseif isequal(info.ColorType,'truecolor')
       handles.state.image = double(rgb2gray(imread([pathname, filename])));
    elseif isequal(info.ColorType,'indexed')
       handles.state.image = double(rgb2gray(imread([pathname, filename])));
    else
        handles.state.image = double(imread([pathname, filename]));
    end
end
handles = updateAxesImage(handles,0);
handles = checkIfShearletSystemIsUpToDate(handles);
guidata(handles.figure1,handles);



% --------------------------------------------------------------------
function menuLoadConfiguration_Callback(hObject, eventdata, handles)
% hObject    handle to menuLoadConfiguration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uigetfile('*.mat','Load configuration ...',handles.state.lastDir);
if filename == 0
    return;
end
handles.state.lastDir = pathname;
config = load([pathname,filename]);
if isfield(config,'detectLines')
    handles.state.detectRidges = config.detectLines;
else
    handles.state.detectRidges = config.detectRidges;
end
handles.state.waveletEffSupp = config.waveletEffSupp ;
handles.state.gaussianEffSupp = config.gaussianEffSupp ;
handles.state.scalesPerOctave = config.scalesPerOctave;
if isfield(config,'orientations')
    handles.state.shearLevel = log2(config.orientations);
else
    handles.state.shearLevel = config.shearLevel;
end
handles.state.alpha = config.alpha ;
handles.state.octaves = config.octaves;
handles.state.minContrast = config.minContrast;
handles.state.offset = config.offset ;
if isfield(config,'scalesUsedForPivotSearch')
    handles.state.scalesUsedForPivotSearch = config.scalesUsedForPivotSearch;
else
    handles.state.scalesUsedForPivotSearch = 'all';
end
if isfield(config,'onlyPositiveOrNegativeRidges')
    handles.state.onlyPositiveOrNegativeRidges = config.onlyPositiveOrNegativeRidges;
else
    handles.state.onlyPositiveOrNegativeRidges = 0;
end
handles = updateGUI(handles);
handles = checkIfShearletSystemIsUpToDate(handles);
guidata(handles.figure1,handles);


function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editWaveletEffSupp_Callback(hObject, eventdata, handles)
% hObject    handle to editWaveletEffSupp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editWaveletEffSupp as text
%        str2double(get(hObject,'String')) returns contents of editWaveletEffSupp as a double
handles = readGUIData(handles);
handles = checkIfShearletSystemIsUpToDate(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function editWaveletEffSupp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editWaveletEffSupp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editGaussianEffSupp_Callback(hObject, eventdata, handles)
% hObject    handle to editGaussianEffSupp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editGaussianEffSupp as text
%        str2double(get(hObject,'String')) returns contents of editGaussianEffSupp as a double
handles = readGUIData(handles);
handles = checkIfShearletSystemIsUpToDate(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function editGaussianEffSupp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editGaussianEffSupp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editScalesPerOctave_Callback(hObject, eventdata, handles)
% hObject    handle to editScalesPerOctave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editScalesPerOctave as text
%        str2double(get(hObject,'String')) returns contents of editScalesPerOctave as a double
handles = readGUIData(handles);
handles = checkIfShearletSystemIsUpToDate(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function editScalesPerOctave_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editScalesPerOctave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupOrientations.
function popupOrientations_Callback(hObject, eventdata, handles)
% hObject    handle to popupOrientations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupOrientations contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupOrientations
handles = readGUIData(handles);
handles = checkIfShearletSystemIsUpToDate(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupOrientations_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupOrientations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editMinContrast_Callback(hObject, eventdata, handles)
% hObject    handle to editMinContrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMinContrast as text
%        str2double(get(hObject,'String')) returns contents of editMinContrast as a double
handles = readGUIData(handles);
handles = checkIfShearletSystemIsUpToDate(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function editMinContrast_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMinContrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editAlpha_Callback(hObject, eventdata, handles)
% hObject    handle to editAlpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editAlpha as text
%        str2double(get(hObject,'String')) returns contents of editAlpha as a double
handles = readGUIData(handles);
handles = checkIfShearletSystemIsUpToDate(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function editAlpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editAlpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editOctaves_Callback(hObject, eventdata, handles)
% hObject    handle to editOctaves (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editOctaves as text
%        str2double(get(hObject,'String')) returns contents of editOctaves as a double
handles = readGUIData(handles);
handles = checkIfShearletSystemIsUpToDate(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function editOctaves_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editOctaves (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buttonDetect.
function buttonDetect_Callback(hObject, eventdata, handles)
% hObject    handle to buttonDetect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = checkIfShearletSystemIsUpToDate(handles);
if ~handles.state.shearletSystemIsUpToDate
    h = waitbar(0.5,'The shearlet system is being computed ...','windowstyle', 'modal');
    set(h,'windowstyle','normal');

    if handles.state.detectRidges
        handles.state.shearletSystem = CSHRMgetContRidgeSystem(size(handles.state.image,1),size(handles.state.image,2),handles.state.waveletEffSupp,handles.state.gaussianEffSupp,handles.state.scalesPerOctave,handles.state.shearLevel,handles.state.alpha,1:floor(handles.state.octaves*handles.state.scalesPerOctave));
    else
        handles.state.shearletSystem = CSHRMgetContEdgeSystem(size(handles.state.image,1),size(handles.state.image,2),handles.state.waveletEffSupp,handles.state.gaussianEffSupp,handles.state.scalesPerOctave,handles.state.shearLevel,handles.state.alpha,1:floor(handles.state.octaves*handles.state.scalesPerOctave));
    end
    handles.state.currScale = 1;
    handles.state.currOrientation = 1;
    handles.state.shearletSystemIsUpToDate = 1;
    handles = updatePopupPivotScales(handles);
    handles = updateAxesAtoms(handles);        

    close(h);
end
if handles.state.detectRidges
    h = waitbar(0.5,'Ridges are being detected ...','windowstyle', 'modal');
else
    h = waitbar(0.5,'Edges are being detected ...','windowstyle', 'modal');
end
set(h,'windowstyle','normal');
if handles.state.detectRidges
    [handles.state.detectedEdges,handles.state.detectedOrientations,handles.state.detectedWidths,handles.state.detectedHeights] = CSHRMgetRidges(handles.state.image,handles.state.shearletSystem,handles.state.minContrast,handles.state.offset,handles.state.onlyPositiveOrNegativeRidges);
else        
    [handles.state.detectedEdges,handles.state.detectedOrientations] = CSHRMgetEdges(handles.state.image,handles.state.shearletSystem,handles.state.minContrast,handles.state.offset,handles.state.scalesUsedForPivotSearch);
end
handles = thinEdgesToLines(handles);
handles.state.detectedCurvature = CSHRMgetCurvatureMex(handles.state.thinnedOrientations);
handles = updateAxesEdges(handles);

close(h);
guidata(hObject,handles);
% --- Executes on button press in buttonGenerateSystem.

% --- Executes on button press in buttonScaleDec.
function buttonScaleDec_Callback(hObject, eventdata, handles)
% hObject    handle to buttonScaleDec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.state.currScale = max(handles.state.currScale - 1,1);
handles = updateAxesAtoms(handles);
guidata(hObject,handles);


% --- Executes on button press in buttonScaleInc.
function buttonScaleInc_Callback(hObject, eventdata, handles)
% hObject    handle to buttonScaleInc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.state.currScale = min(handles.state.currScale + 1,handles.state.octaves*handles.state.scalesPerOctave);
handles = updateAxesAtoms(handles);
guidata(hObject,handles);

% --- Executes on button press in buttonOriDec.
function buttonOriDec_Callback(hObject, eventdata, handles)
% hObject    handle to buttonOriDec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.state.currOrientation = max(handles.state.currOrientation - 1,1);
handles = updateAxesAtoms(handles);
guidata(hObject,handles);


% --- Executes on button press in buttonOriInc.
function buttonOriInc_Callback(hObject, eventdata, handles)
% hObject    handle to buttonOriInc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.state.currOrientation = min(handles.state.currOrientation + 1,(2^handles.state.shearLevel+2));
handles = updateAxesAtoms(handles);
guidata(hObject,handles);

% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1



function editOffset_Callback(hObject, eventdata, handles)
% hObject    handle to editOffset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editOffset as text
%        str2double(get(hObject,'String')) returns contents of editOffset as a double
handles = readGUIData(handles);
handles = checkIfShearletSystemIsUpToDate(handles);
guidata(hObject, handles);

% --- Executes on selection change in popupPivotScales.
function popupPivotScales_Callback(hObject, eventdata, handles)
% hObject    handle to popupPivotScales (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupPivotScales contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupPivotScales

handles = readGUIData(handles);
handles = checkIfShearletSystemIsUpToDate(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function editOffset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editOffset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuEdgesOrRidges.
function popupmenuEdgesOrRidges_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuEdgesOrRidges (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuEdgesOrRidges contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuEdgesOrRidges
handles = readGUIData(handles);
handles = updateGUI(handles);
handles = checkIfShearletSystemIsUpToDate(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenuEdgesOrRidges_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuEdgesOrRidges (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --------------------------------------------------------------------
function menuSaveConfiguration_Callback(hObject, eventdata, handles)
% hObject    handle to menuSaveConfiguration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uiputfile('*.mat','Save configuration ...',handles.state.lastDir);
if filename == 0
    return;
end
handles.state.lastDir = pathname;
configuration.detectRidges = handles.state.detectRidges;
configuration.onlyPositiveOrNegativeRidges = handles.state.onlyPositiveOrNegativeRidges;
configuration.waveletEffSupp = handles.state.waveletEffSupp ;
configuration.gaussianEffSupp = handles.state.gaussianEffSupp ;
configuration.scalesPerOctave = handles.state.scalesPerOctave ;
configuration.shearLevel = handles.state.shearLevel ;
configuration.alpha = handles.state.alpha ;
configuration.octaves = handles.state.octaves ;
configuration.minContrast = handles.state.minContrast ;
configuration.offset = handles.state.offset ;
configuration.scalesUsedForPivotSearch = handles.state.scalesUsedForPivotSearch;

save([pathname,filename],'-struct','configuration');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% user defined functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function handles = updateAxesImage(handles,overlay)
if isempty(handles.state.image)
    return;
end
axes(handles.axesImage);
img = handles.state.image;
if overlay
    if handles.state.showThinned
        imgRgb = CSHRMgetOverlay(img,handles.state.thinnedEdges);
    else
        imgRgb = CSHRMgetOverlay(img,handles.state.detectedEdges);
    end;
else
    imgRgb = ind2rgb(gray2ind(mat2gray(img),256),gray(256));
end
hImg = image(imgRgb);
hTitle = title(handles.state.imageName);
set(hTitle,'interpreter','none');
set(hImg,'UserData',img);

axis equal;
axis tight;
set(handles.axesImage,'XTick',[1,size(handles.state.image,2)]);
set(handles.axesImage,'YTick',[1,size(handles.state.image,1)]);

function handles = updateAxesEdges(handles)
if isempty(handles.state.detectedEdges)
    return;
end

axes(handles.axesEdges);
if handles.state.showOrientationsWidhtsOrHeightsOrCurvature == 1
    if handles.state.showThinned
        img = (handles.state.thinnedOrientations);
        imgRgb = CSHRMrgbFromOrientations(handles.state.thinnedOrientations);
    else
        img = (handles.state.detectedOrientations);
        imgRgb = CSHRMrgbFromOrientations(handles.state.detectedOrientations);
    end
elseif handles.state.showOrientationsWidhtsOrHeightsOrCurvature == 2 && handles.state.detectRidges
        cmap = jet(max(handles.state.detectedWidths(:)));
        cmap = [[0,0,0];cmap];
        if handles.state.showThinned
            img = uint8(handles.state.thinnedWidths);
            imgRgb = ind2rgb(handles.state.thinnedWidths+1,cmap);
        else
            img = uint8(handles.state.detectedWidths);
            imgRgb = ind2rgb(handles.state.detectedWidths+1,cmap);
        end
        
elseif handles.state.showOrientationsWidhtsOrHeightsOrCurvature == 3 && handles.state.detectRidges
    cmap = jet(256);
    if handles.state.showThinned
        img = handles.state.thinnedHeights;
        imgRgb = ind2rgb(gray2ind(mat2gray(handles.state.thinnedHeights),256),cmap);
    else
        img = handles.state.detectedHeights;
        imgRgb = ind2rgb(gray2ind(mat2gray(handles.state.detectedHeights),256),cmap);
    end
elseif handles.state.showOrientationsWidhtsOrHeightsOrCurvature == 4
    cmap = jet(256);
    cmap = [[0,0,0];cmap];
    img = (handles.state.detectedCurvature);
    imgRgb = CSHRMrgbFromCurvature(img,15);
else
    if handles.state.showThinned
        img = handles.state.thinnedEdges;
    else
        img = handles.state.detectedEdges;
    end
    imgRgb = ind2rgb(gray2ind(mat2gray(img),256),gray(256));
end
hImg = image(imgRgb);
set(hImg,'UserData',img);
if handles.state.detectRidges
    if handles.state.onlyPositiveOrNegativeRidges == 1
        hTitle = title([handles.state.imageName,': positive ridges']);
    elseif handles.state.onlyPositiveOrNegativeRidges == -1
        hTitle = title([handles.state.imageName,': negative ridges']);
    else
        hTitle = title([handles.state.imageName,': ridges']);
    end
else
    hTitle = title([handles.state.imageName,': edges']);
end
set(hTitle,'interpreter','none');
axis equal;
axis tight;
set(handles.axesEdges,'XTick',[1,size(handles.state.image,2)]);
set(handles.axesEdges,'YTick',[1,size(handles.state.image,1)]);
handles = updateAxesImage(handles,handles.state.overlay);


function handles = updateAxesAtoms(handles)

axes(handles.axesEvenAtom);
shearletIdx = handles.state.currOrientation*(1+handles.state.detectRidges)-handles.state.detectRidges + (handles.state.currScale-1)*(2^handles.state.shearLevel+2)*(1+handles.state.detectRidges);
img = real(fftshift(ifft2(ifftshift(handles.state.shearletSystem.shearlets(:,:,shearletIdx)))));
imgRgb = ind2rgb(gray2ind(mat2gray(img),256),jet(256));
hImg = image(imgRgb);
set(hImg,'UserData',img);
ctr = floor(size(handles.state.image)/2) +1;
l = floor(max(handles.state.waveletEffSupp,handles.state.gaussianEffSupp)/2);
axis(handles.axesEvenAtom,[ctr(2)-l,ctr(2)+l,ctr(1)-l,ctr(1)+l]);
set(handles.axesEvenAtom,'XTick',[ctr(2)-l,ctr(2)+l]);
set(handles.axesEvenAtom,'YTick',[ctr(1)-l,ctr(1)+l]);
axis(handles.axesEvenAtom,'square');
set(handles.textCurrScale,'String',['scale: ',num2str(handles.state.currScale)]);
axes(handles.axesOddAtom);
img = imag(fftshift(ifft2(ifftshift(handles.state.shearletSystem.shearlets(:,:,shearletIdx)))));
imgRgb = ind2rgb(gray2ind(mat2gray(img),256),jet(256));
hImg = image(imgRgb);
set(hImg,'UserData',img);
axis(handles.axesOddAtom,[ctr(2)-l,ctr(2)+l,ctr(1)-l,ctr(1)+l]);
set(handles.axesOddAtom,'XTick',[ctr(2)-l,ctr(2)+l]);
set(handles.axesOddAtom,'YTick',[ctr(1)-l,ctr(1)+l]);
axis(handles.axesOddAtom,'square');

set(handles.textCurrOri,'String',['ori: ',num2str(handles.state.currOrientation)]);

function [handles, firstScale] = updatePopupPivotScales(handles)

nScales =  floor(handles.state.octaves*handles.state.scalesPerOctave) - floor(handles.state.offset*handles.state.scalesPerOctave);

oldStr = get(handles.popupPivotScales,'String');
for k = 1:(nScales + 3)
    if k < 4
        newStr{k} = oldStr{k};
    else
        if (k==4),firstScale = k-3+floor(handles.state.offset*handles.state.scalesPerOctave); end
        newStr{k} = num2str(k-3+floor(handles.state.offset*handles.state.scalesPerOctave));
    end
end
set(handles.popupPivotScales,'String',newStr);

function handles = readGUIData(handles)

handles.state.waveletEffSupp = (str2num(get(handles.editWaveletEffSupp,'String')));
handles.state.gaussianEffSupp = (str2num(get(handles.editGaussianEffSupp,'String')));
handles.state.scalesPerOctave = (str2num(get(handles.editScalesPerOctave,'String')));
handles.state.shearLevel = 1+get(handles.popupOrientations,'Value');
handles.state.alpha = str2double(get(handles.editAlpha,'String'));
handles.state.octaves = (str2num(get(handles.editOctaves,'String')));
handles.state.detectRidges = get(handles.popupmenuEdgesOrRidges,'Value') > 1;
if get(handles.popupmenuEdgesOrRidges,'Value') == 3
    handles.state.onlyPositiveOrNegativeRidges = 1;
elseif get(handles.popupmenuEdgesOrRidges,'Value') == 4
    handles.state.onlyPositiveOrNegativeRidges = -1;
else
    handles.state.onlyPositiveOrNegativeRidges = 0;
end
handles.state.minContrast = str2double(get(handles.editMinContrast,'String'));
handles.state.offset = (str2num(get(handles.editOffset,'String')));
handles.state.scalesUsedForPivotSearch = get(handles.popupPivotScales,'String');
handles.state.scalesUsedForPivotSearch = handles.state.scalesUsedForPivotSearch{get(handles.popupPivotScales,'Value')};
handles = updatePopupPivotScales(handles);
if all(isstrprop(handles.state.scalesUsedForPivotSearch,'digit'))
    handles.state.scalesUsedForPivotSearch = str2num(handles.state.scalesUsedForPivotSearch);
end
handles.state.overlay = get(handles.toggleOverlay,'Value') == 1;
handles.state.showOrientationsWidhtsOrHeightsOrCurvature = get(handles.toggleShowOrientations,'Value') + 2*(get(handles.toggleShowWidths,'Value')) + 3*(get(handles.toggleShowHeights,'Value')) + 4*(get(handles.toggleShowCurvature,'Value'));
handles.state.showThinned = get(handles.toggleShowThinned,'Value') == 1;
handles.state.thinningThreshold = str2double(get(handles.editThinningThreshold,'String'));

function handles = updateGUI(handles)

if handles.state.detectRidges
    set(handles.toggleShowWidths,'Enable','on');
    set(handles.toggleShowHeights,'Enable','on');
    set(handles.popupPivotScales,'Enable','off');
    set(handles.textPivotScales,'Enable','off');
    set(handles.textPivotScales2,'Enable','off');
else
    set(handles.toggleShowWidths,'Enable','off');
    set(handles.toggleShowHeights,'Enable','off');
    set(handles.popupPivotScales,'Enable','on');    
    set(handles.textPivotScales,'Enable','on');
    set(handles.textPivotScales2,'Enable','on');
end

set(handles.editWaveletEffSupp,'String', num2str(handles.state.waveletEffSupp));
set(handles.editGaussianEffSupp,'String',num2str(handles.state.gaussianEffSupp));
set(handles.editScalesPerOctave,'String',num2str(handles.state.scalesPerOctave));
set(handles.popupOrientations,'Value',handles.state.shearLevel-1);
set(handles.editAlpha,'String',num2str(handles.state.alpha));
set(handles.editOctaves,'String',num2str(handles.state.octaves));
if handles.state.detectRidges
    if handles.state.onlyPositiveOrNegativeRidges == -1
        set(handles.popupmenuEdgesOrRidges,'Value',4);
    elseif handles.state.onlyPositiveOrNegativeRidges == 1
        set(handles.popupmenuEdgesOrRidges,'Value',3);
    else
        set(handles.popupmenuEdgesOrRidges,'Value',2);
    end
else
    set(handles.popupmenuEdgesOrRidges,'Value',1);
end

set(handles.editMinContrast,'String',num2str(handles.state.minContrast));
set(handles.editOffset,'String',num2str(handles.state.offset));
[handles,firstScale] = updatePopupPivotScales(handles);
if ischar(handles.state.scalesUsedForPivotSearch)
    switch handles.state.scalesUsedForPivotSearch
        case 'all'
            set(handles.popupPivotScales,'Value',1);
        case 'highest'                
            set(handles.popupPivotScales,'Value',3);
        case 'lowest'                
            set(handles.popupPivotScales,'Value',2);
        otherwise
            set(handles.popupPivotScales,'Value',1);
    end
else
    set(handles.popupPivotScales,'Value',handles.state.scalesUsedForPivotSearch-firstScale+4);
end

function handles = checkIfShearletSystemIsUpToDate(handles)
    handles.state.shearletSystemIsUpToDate = 1;
    if isstruct(handles.state.shearletSystem)
        if      handles.state.waveletEffSupp ~= handles.state.shearletSystem.waveletEffSupp ||...
                handles.state.gaussianEffSupp ~=handles.state.shearletSystem.gaussianEffSupp ||...
                handles.state.scalesPerOctave ~=handles.state.shearletSystem.scalesPerOctave ||...
                handles.state.shearLevel ~= handles.state.shearletSystem.shearLevel ||...
                floor(handles.state.octaves*handles.state.scalesPerOctave) ~= length(handles.state.shearletSystem.scales)||...
                handles.state.alpha ~= handles.state.shearletSystem.alpha ||...
                handles.state.detectRidges ~= handles.state.shearletSystem.detectRidges || ...
                ~isequal(size(handles.state.image),handles.state.shearletSystem.size)            
            handles.state.shearletSystemIsUpToDate = 0;
        end
    else
        handles.state.shearletSystemIsUpToDate = 0;
    end
    
function handles = thinEdgesToLines(handles)

    handles.state.thinnedEdges = CSHRMthinToLines(handles.state.detectedEdges,handles.state.thinningThreshold);
    handles.state.thinnedOrientations = handles.state.detectedOrientations;
    handles.state.thinnedOrientations(~handles.state.thinnedEdges) = -1;
    if handles.state.detectRidges
        handles.state.thinnedWidths = handles.state.detectedWidths;
        handles.state.thinnedWidths(~handles.state.thinnedEdges) = 0;
        handles.state.thinnedHeights = handles.state.detectedHeights;
        handles.state.thinnedHeights(~handles.state.thinnedEdges) = 0;
    end
    
        
function txt = myDataCursorUpdateFct(empt,event_obj)
% Customizes text of data tips
pos = event_obj.Position;
data = get(event_obj.Target,'UserData');
txt = {['Index: [',num2str(pos(1)),',',num2str(pos(2)),']'],...
	      ['Value: ',num2str(data(pos(2),pos(1)))]};
      
      
      

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in toggleOverlay.
function toggleOverlay_Callback(hObject, eventdata, handles)
% hObject    handle to toggleOverlay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggleOverlay
handles = readGUIData(handles);
handles = checkIfShearletSystemIsUpToDate(handles);
handles = updateAxesEdges(handles);
guidata(hObject, handles);


% --- Executes on button press in toggleShowOrientations.
function toggleShowOrientations_Callback(hObject, eventdata, handles)
% hObject    handle to toggleShowOrientations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggleShowOrientations
if get(hObject,'Value') == 1
    set(handles.toggleShowWidths,'Value',0);
    set(handles.toggleShowHeights,'Value',0);    
    set(handles.toggleShowCurvature,'Value',0);
end
handles = readGUIData(handles);
handles = checkIfShearletSystemIsUpToDate(handles);
handles = updateAxesEdges(handles);
guidata(hObject, handles);

% --- Executes on button press in toggleShowCurvature.
function toggleShowCurvature_Callback(hObject, eventdata, handles)
% hObject    handle to toggleShowCurvature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value') == 1
    set(handles.toggleShowWidths,'Value',0);
    set(handles.toggleShowHeights,'Value',0);
    set(handles.toggleShowOrientations,'Value',0);
end
handles = readGUIData(handles);
handles = checkIfShearletSystemIsUpToDate(handles);
handles = updateAxesEdges(handles);
guidata(hObject, handles);

% --- Executes on button press in toggleShowWidths.
function toggleShowWidths_Callback(hObject, eventdata, handles)
% hObject    handle to toggleShowWidths (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggleShowWidths
if get(hObject,'Value') == 1
    set(handles.toggleShowOrientations,'Value',0);
    set(handles.toggleShowHeights,'Value',0);
    set(handles.toggleShowCurvature,'Value',0);
end
handles = readGUIData(handles);
handles = checkIfShearletSystemIsUpToDate(handles);
handles = updateAxesEdges(handles);
guidata(hObject, handles);

% --- Executes on button press in toggleShowHeights.
function toggleShowHeights_Callback(hObject, eventdata, handles)
% hObject    handle to toggleShowHeights (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggleShowHeights
if get(hObject,'Value') == 1
    set(handles.toggleShowWidths,'Value',0);
    set(handles.toggleShowOrientations,'Value',0);
    set(handles.toggleShowCurvature,'Value',0);
end
handles = readGUIData(handles);
handles = checkIfShearletSystemIsUpToDate(handles);
handles = updateAxesEdges(handles);
guidata(hObject, handles);

% --------------------------------------------------------------------
function menuExport_Callback(hObject, eventdata, handles)
% hObject    handle to menuExport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuExportEdges_Callback(hObject, eventdata, handles)
% hObject    handle to menuExportEdges (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
suffix = '_edges';
if handles.state.detectRidges
    suffix = '_ridges';
end
if handles.state.showThinned
    suffix = [suffix,'_thinned'];
end
[filename,pathname] = uiputfile({'*.png','Export as Image (*.png)';'*.mat','Export as MAT-File (*.mat)'},'Export Edges',[handles.state.lastDir,handles.state.imageName,suffix]);
if filename == 0
    return;
end
handles.state.lastDir = pathname;
[dummy,dummy,fileExt] = fileparts(filename);
if isequal(fileExt,'.mat')
    if handles.state.showThinned
        detectedEdges = handles.state.thinnedEdges;
    else
        detectedEdges = handles.state.detectedEdges;
    end;
    save([pathname,filename],'detectedEdges');
elseif isequal(fileExt,'.png')
    if handles.state.showThinned
        imwrite(handles.state.thinnedEdges,[pathname,filename]);
    else
        imwrite(handles.state.detectedEdges,[pathname,filename]);
    end;
end
guidata(hObject,handles);

% --------------------------------------------------------------------
function menuExportImageAndEdges_Callback(hObject, eventdata, handles)
% hObject    handle to menuExportImageAndEdges (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
suffix = '_img_edges';
if handles.state.detectRidges
    suffix = '_img_ridges';
end
if handles.state.showThinned
    suffix = [suffix,'_thinned'];
end
[filename,pathname] = uiputfile({'*.png','Export as Image (*.png)';'*.mat','Export as MAT-File (*.mat)'},'Export Image and Edges',[handles.state.lastDir,handles.state.imageName,suffix]);
if filename == 0
    return;
end
handles.state.lastDir = pathname;
[dummy,dummy,fileExt] = fileparts(filename);
if isequal(fileExt,'.mat')
    if handles.state.showThinned
        detectedEdges = handles.state.thinnedEdges;
    else
        detectedEdges = handles.state.detectedEdges;
    end;
    img = handles.state.image;
    save([pathname,filename],'detectedEdges','img');
elseif isequal(fileExt,'.png')
    if handles.state.showThinned
        img = imfuse(handles.state.image,handles.state.thinnedEdges,'montage');
    else
        img = imfuse(handles.state.image,handles.state.detectedEdges,'montage');
    end;
    imwrite(img,[pathname,filename]);
end
guidata(hObject,handles);

% --------------------------------------------------------------------
function menuExportImageAndEdgesAndOrientations_Callback(hObject, eventdata, handles)
% hObject    handle to menuExportImageAndEdgesAndOrientations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
suffix = '_img_edges_oris';
if handles.state.detectRidges
    suffix = '_img_ridges_oris';
end
if handles.state.showThinned
    suffix = [suffix,'_thinned'];
end
[filename,pathname] = uiputfile({'*.png','Export as Image (*.png)';'*.mat','Export as MAT-File (*.mat)'},'Export Image, Edges and Orientations',[handles.state.lastDir,handles.state.imageName,suffix]);
if filename == 0
    return;
end
handles.state.lastDir = pathname;
[dummy,dummy,fileExt] = fileparts(filename);
if isequal(fileExt,'.mat')
    if handles.state.showThinned
        detectedEdges = handles.state.thinnedEdges;
    else
        detectedEdges = handles.state.detectedEdges;
    end;
    if handles.state.showThinned
        detectedOrientations = handles.state.detectedOrientations;
        detectedOrientations(~handles.state.thinnedEdges) = -1;
    else
        detectedOrientations = handles.state.detectedOrientations;
    end
    img = handles.state.image;
    save([pathname,filename],'detectedEdges','img','detectedOrientations');
elseif isequal(fileExt,'.png')
    ncmap = 181;
    cmap = squeeze(hsv2rgb(cat(3,0:1/(ncmap-1):1,ones(1,ncmap),ones(1,ncmap))));
    cmap = [[0,0,0];cmap];

    %img = imfuse(handles.state.image,handles.state.thinnedEdges,'montage');
    detectedOrientations = handles.state.detectedOrientations;
    detectedOrientations(~handles.state.thinnedEdges) = -1;
    imgOris = ind2rgb(int16(detectedOrientations)+1,cmap);
    
%         imgOris = ind2rgb(int16(handles.state.detectedOrientations)+1,cmap);
    
    img = imfuse(handles.state.image,handles.state.detectedEdges,'montage');
    img = imfuse(img,imgOris,'montage');
    img = img(:,1:(size(handles.state.image,2)+size(handles.state.detectedEdges,2)+size(imgOris,2)),:);
    imwrite(img,[pathname,filename]);
end
guidata(hObject,handles);

% --------------------------------------------------------------------
function menuExportImageEdgesOrientationsAndCurvature_Callback(hObject, eventdata, handles)
% hObject    handle to menuExportImageEdgesOrientationsAndCurvature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
suffix = '_img_edges_oris_curvature';
if handles.state.detectRidges
    suffix = '_img_ridges_oris_curvature';
end
[filename,pathname] = uiputfile({'*.png','Export as Image (*.png)';'*.mat','Export as MAT-File (*.mat)'},'Export Image, Edges, Orientations and Curvature',[handles.state.lastDir,handles.state.imageName,suffix]);
if filename == 0
    return;
end
handles.state.lastDir = pathname;
[~,~,fileExt] = fileparts(filename);
if isequal(fileExt,'.mat')
    detectedEdges = handles.state.thinnedEdges;
    detectedOrientations = handles.state.thinnedOrientations;
    img = handles.state.image;
    curvature = handles.state.detectedCurvature;
    save([pathname,filename],'detectedEdges','img','detectedOrientations','curvature');
elseif isequal(fileExt,'.png')
    ncmap = 181;
    cmap = squeeze(hsv2rgb(cat(3,0:1/(ncmap-1):1,ones(1,ncmap),ones(1,ncmap))));
    cmap = [[0,0,0];cmap];

    detectedOrientations = handles.state.thinnedOrientations;
    imgOris = ind2rgb(int16(detectedOrientations)+1,cmap);
    
    imgCurv = CSHRMrgbFromCurvature(handles.state.detectedCurvature,15);
    
    
    img = imfuse(handles.state.image,handles.state.detectedEdges,'montage');
    img2 = imfuse(imgOris,imgCurv,'montage');
    img = imfuse(img,img2,'montage');
    imwrite(img,[pathname,filename]);
end
guidata(hObject,handles);

% --------------------------------------------------------------------
function menuExportOverlay_Callback(hObject, eventdata, handles)
% hObject    handle to menuExportOverlay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
suffix = '_edges_overlay';
if handles.state.detectRidges
    suffix = '_ridges_overlay_oris';
end
if handles.state.showThinned
    suffix = [suffix,'_thinned'];
end
[filename,pathname] = uiputfile({'*.png','Export as Image (*.png)'},'Export Overlay and Orientations',[handles.state.lastDir,handles.state.imageName,suffix]);
if filename == 0
    return;
end
handles.state.lastDir = pathname;
if handles.state.showThinned
    red = cat(3,handles.state.thinnedEdges,zeros(size(handles.state.thinnedEdges)),zeros(size(handles.state.thinnedEdges)));
    img = mat2gray(handles.state.image).*(1-handles.state.thinnedEdges);
else
    red = cat(3,handles.state.detectedEdges,zeros(size(handles.state.detectedEdges)),zeros(size(handles.state.detectedEdges)));
    img = mat2gray(handles.state.image).*(1-handles.state.detectedEdges);
end;
img = cat(3,img,img,img);
img = img + red;

imwrite(img,[pathname,filename]);
guidata(hObject,handles);


% --------------------------------------------------------------------
function menuExportOverlayAndOrientations_Callback(hObject, eventdata, handles)
% hObject    handle to menuExportOverlayAndOrientations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
suffix = '_edges_overlay_oris';
if handles.state.detectRidges
    suffix = '_ridges_overlay';
end
if handles.state.showThinned
    suffix = [suffix,'_thinned'];
end
[filename,pathname] = uiputfile({'*.png','Export as Image (*.png)'},'Export Overlay',[handles.state.lastDir,handles.state.imageName,suffix]);
if filename == 0
    return;
end
handles.state.lastDir = pathname;
if handles.state.showThinned
    red = cat(3,handles.state.thinnedEdges,zeros(size(handles.state.thinnedEdges)),zeros(size(handles.state.thinnedEdges)));
    img = mat2gray(handles.state.image).*(1-handles.state.thinnedEdges);
else
    red = cat(3,handles.state.detectedEdges,zeros(size(handles.state.detectedEdges)),zeros(size(handles.state.detectedEdges)));
    img = mat2gray(handles.state.image).*(1-handles.state.detectedEdges);
end;
img = cat(3,img,img,img);
img = img + red;
ncmap = 180;
cmap = squeeze(hsv2rgb(cat(3,0:1/(ncmap-1):1,ones(1,ncmap),ones(1,ncmap))));
cmap = [[0,0,0];cmap];

if handles.state.showThinned
    detectedOrientations = handles.state.detectedOrientations;
    detectedOrientations(~handles.state.thinnedEdges) = -1;
    imgOris = ind2rgb(detectedOrientations+2,cmap);
else
    imgOris = ind2rgb(handles.state.detectedOrientations+2,cmap);
end; 
img = imfuse(img,imgOris,'montage');
imwrite(img,[pathname,filename]);
guidata(hObject,handles);


% --- Executes on button press in toggleShowThinned.
function toggleShowThinned_Callback(hObject, eventdata, handles)
% hObject    handle to toggleShowThinned (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggleShowThinned
handles = readGUIData(handles);
handles = checkIfShearletSystemIsUpToDate(handles);
handles = updateAxesEdges(handles);
guidata(hObject, handles);



function editThinningThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to editThinningThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editThinningThreshold as text
%        str2double(get(hObject,'String')) returns contents of editThinningThreshold as a double
handles = readGUIData(handles);
handles = checkIfShearletSystemIsUpToDate(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function editThinningThreshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editThinningThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buttonEnlargeEdges.
function buttonEnlargeEdges_Callback(hObject, eventdata, handles)
% hObject    handle to buttonEnlargeEdges (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hFigure = figure; % Open a new figure with handle f1
hAxes = copyobj(handles.axesEdges,hFigure); % Copy axes object h into figure f1
set(hAxes,'Units','normalized');
set(hAxes,'Position',[0.1 0.1 0.8 0.8]);
set(hFigure,'units','normalized','outerposition',[0 0 1 1]);

% --- Executes on button press in buttonEnlargeImage.
function buttonEnlargeImage_Callback(hObject, eventdata, handles)
% hObject    handle to buttonEnlargeImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hFigure = figure; % Open a new figure with handle f1
hAxes = copyobj(handles.axesImage,hFigure); % Copy axes object h into figure f1
set(hAxes,'Units','normalized');
set(hAxes,'Position',[0.1 0.1 0.8 0.8]);
set(hFigure,'units','normalized','outerposition',[0 0 1 1]);




% --- Executes during object creation, after setting all properties.
function popupPivotScales_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupPivotScales (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editWaveletEffSupp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%  Copyright (c) 2016. Rafael Reisenhofer
%
%  Part of CoShREM Toolbox v1.1
%  Built Mon, 11/01/2016
%  This is Copyrighted Material
