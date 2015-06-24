
function varargout = PlasmidControlx32(varargin)
% PLASMIDCONTROLX32 M-file for PlasmidControlx32.fig
%      PLASMIDCONTROLX32, by itself, creates a new PLASMIDCONTROLX32 or raises the existing
%      singleton*.
%
%      H = PLASMIDCONTROLX32 returns the handle to a new PLASMIDCONTROLX32 or the handle to
%      the existing singleton*.
%
%      PLASMIDCONTROLX32('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLASMIDCONTROLX32.M with the given input arguments.
%
%      PLASMIDCONTROLX32('Property','Value',...) creates a new PLASMIDCONTROLX32 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PlasmidControlx32_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PlasmidControlx32_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PlasmidControlx32

% Last Modified by GUIDE v2.5 08-Apr-2012 17:40:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PlasmidControlx32_OpeningFcn, ...
                   'gui_OutputFcn',  @PlasmidControlx32_OutputFcn, ...
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


% --- Executes just before PlasmidControlx32 is made visible.
function PlasmidControlx32_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB

ManipulatorEnableStationMoveVariable = 0;


% --- Executes on button press in PlasmidDispense_pushbutton.
function PlasmidDispense_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to PlasmidDispense_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global PlasmidDispensetimeX32
global stg
global PlasmidDispenseTimeX32pause


%if 
%disp('Plasmid Dispense Begin')
if (~isempty(daqfind))
    stop(daqfind)
end
dio = digitalio('nidaq', 'Dev1');
addline(dio, 0:7, 0, 'Out');
%tic
putvalue(dio, [0 1 0 0 0 0 0 0]);
pause(PlasmidDispenseTimeX32pause)
%pause(1)
value1 = getvalue(dio);
putvalue(dio, [0 0 0 0 0 0 0 0]);
value2 = getvalue(dio);
%toc;
delete (dio);
clear dio;
%disp('Plasmid Dispense End')

PlasmidDispenseTimeX32pause = 0;

%I/O Operation Commands
%----------------------
%binvec = dec2binvec(196)
%decimal = binvec2dec([1 0 1 0 1 1])
%putvalue(dio, 3);
%putvalue(dio.Line([ 1 3 ]), [ 1 1 ]);
%putvalue(dio, 5);
%putvalue(dio, [0 0 0 0 0 0 0 0]);
%pause(1)
%value = getvalue(dio)
%value = binvec2dec(getvalue(dio))
%getvalue(dio.Line([ 1 3 ]))


function PlasmidDispense_editText_Callback(hObject, eventdata, handles)
% hObject    handle to PlasmidDispense_editText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of PlasmidDispense_editText as text
%        str2double(get(hObject,'String')) returns contents of PlasmidDispense_editText as a double
global PlasmidDispensetime
input = str2num(get(hObject,'String'));

%checks to see if input is empty. if so, default input1_editText to zero
if (isempty(input))
     set(hObject,'String','0')
end
PlasmidDispensetimeinput = get(handles.PlasmidDispense_editText,'String');
% a and b are variables of Strings type, and need to be converted
% to variables of Number type before they can be added together
PlasmidDispensetime = str2num(PlasmidDispensetimeinput)/1000;
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function PlasmidDispense_editText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PlasmidDispense_editText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PlasmidVibrate_pushbutton.
function PlasmidVibrate_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to PlasmidVibrate_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global PlasmidVibrateTimeX32pause
disp('Vibrate Needle');
if (~isempty(daqfind))
    stop(daqfind)
end

dio = digitalio('nidaq', 'Dev1');
addline(dio, 0:7, 0, 'Out');
%tic
putvalue(dio, [0 1 0 0 0 0 0 0]);
pause(PlasmidDispenseTimeX32pause);
%pause(1)
value1 = getvalue(dio);
putvalue(dio, [0 0 0 0 0 0 0 0]);
value2 = getvalue(dio);
%toc;
delete (dio);
clear dio;
%disp('Plasmid Dispense End')

PlasmidDispenseTimeX32pause = 0;


function PlasmidVibrate_editText_Callback(hObject, eventdata, handles)
% hObject    handle to PlasmidVibrate_editText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of PlasmidVibrate_editText as text
%        str2double(get(hObject,'String')) returns contents of PlasmidVibrate_editText as a double
global PlasmidVibratetime
input = str2num(get(hObject,'String'));

%checks to see if input is empty. if so, default input1_editText to zero
if (isempty(input))
     set(hObject,'String','0')
end
PlasmidVibratetimeinput = get(handles.PlasmidVibrate_editText,'String');
% a and b are variables of Strings type, and need to be converted
% to variables of Number type before they can be added together
PlasmidVibratetime = str2num(PlasmidVibratetimeinput)/1000;
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function PlasmidVibrate_editText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PlasmidVibrate_editText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in PlasmidTest2_pushbutton.
function PlasmidTest2_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to PlasmidTest2_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Read_matfile_running
Read_matfile_running = 1

% --- Executes on button press in PlasmidTest3_pushbutton.
function PlasmidTest3_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to PlasmidTest3_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Read_matfile_running
Read_matfile_running = 0

% --- Executes on button press in PlasmidTest4_pushbutton.
function PlasmidTest4_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to PlasmidTest4_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in PlasmidTest1_pushbutton.
function PlasmidTest1_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to PlasmidTest1_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 global PlasmidDispenseTime
 global PlasmidVibrateTime
 global Read_matfile_running
 global Read_matfile
 global PlasmidDispenseTimeX32
 global PlasmidDispenseTimeX32pause
 global PlasmidVibrateTimeX32pause
 % global C
% global D
% global E
% global F

%Read_matfile = 0;
while (Read_matfile_running == 1);
   try
    %pause(1)
    
    %disp('trying really hard');
    load('PlasmidControllerX32DataTransfer.mat','Read_matfile','PlasmidDispenseTimeX32','PlasmidVibrateTimeX32','D','E','F','G','H');
    %disp('File Loaded: PlasmidControllerX32DataTransfer.mat');
    %pause(1)
    Read_matfile = single(Read_matfile);
    %Read_matfile = str2num(Read_matfile);
    if (Read_matfile == 1)
        %disp('Read_matfile = 1. file read')
        %Read_matfile = 0;
            PlasmidDispenseTimeX32pause = single(PlasmidDispenseTimeX32);
            PlasmidVibrateTimeX32pause = single(PlasmidVibrateTimeX32);
            if (PlasmidDispenseTimeX32pause > 0)
               % disp('dispense');
               PlasmidDispense_pushbutton_Callback;
            end

            if (PlasmidVibrateTimeX32pause > 0)
               PlasmidVibrate_pushbutton_Callback;
            end

           

            %Reset All Passed Variables
            Read_matfile = 0;
            %PlasmidDispenseTimeX32 = 0;
            %PlasmidVibrateTimeX32 = 0;
            D = 0;
            E = 0;
            F = 0;
            G = 0;
            H = 0;
            %save reset variables
           % pause(1)
            save('PlasmidControllerX32DataTransfer.mat','Read_matfile','PlasmidDispenseTimeX32','PlasmidVibrateTimeX32','D','E','F','G','H');
            %pause(1); %arbitrary pause to allow file to be read and written without conflicts
            pause(0.05)
    else
        %disp('Read_matfile is OFF');
        pause(0.05)
    end
catch
    %disp('Catch: PlasmidControlX32Read');
    pause(0.05)
end
end 


% --- Executes on button press in PlasmidTest6_pushbutton.
function PlasmidTest6_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to PlasmidTest6_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in PlasmidTest7_pushbutton.
function PlasmidTest7_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to PlasmidTest7_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in PlasmidTest8_pushbutton.
function PlasmidTest8_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to PlasmidTest8_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in PlasmidTest5_pushbutton.
function PlasmidTest5_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to PlasmidTest5_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in PlasmidPulse_pushbutton.
function PlasmidPulse_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to PlasmidPulse_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%global stg
%fprintf(stg,'GR,-2,0');
%fscanf(stg);
disp('Plasmid Pulse')
if (~isempty(daqfind))
    stop(daqfind)
end

dio = digitalio('nidaq', 'Dev1');
addline(dio, 0:7, 0, 'Out');
%tic
putvalue(dio, [0 1 0 0 0 0 0 0]);
pause(0.1)
%pause(1)
value1 = getvalue(dio);
putvalue(dio, [0 0 0 0 0 0 0 0]);
value2 = getvalue(dio);
%toc;
delete (dio);
clear dio;
%disp('Plasmid Pulse End')


% --- Executes on button press in PlasmidNudgeTap_pushbutton.
function PlasmidNudgeTap_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to RotationTest6_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in SetTemperature_pushbutton.
global NikonTiScope
global stg
%disp('Nudge + Tap begin');
%fprintf(stg,'GR,5,0');
%fscanf(stg);
%PlasmidVibrate_pushbutton_Callback(hObject, eventdata, handles)

%pause(0.1)
%!D:\MATLAB2010a\bin\matlab.exe -nodesktop -automation -r PlasmidNudgeTap32
%pause(0.1)

disp('Plasmid Nudge + Tap')
PlasmidVibrate_pushbutton_Callback;
 %disp('Nudge + Tap end')

% --- Executes on button press in PlasmidNudgeTap_pushbutton.
function PlasmidExitWorm_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to RotationTest6_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in SetTemperature_pushbutton.
%global NikonTiScope
%global stg
%disp('Nudge + Tap begin');
%fprintf(stg,'GR,5,0');
%fscanf(stg);
%PlasmidVibrate_pushbutton_Callback(hObject, eventdata, handles)

% if (~isempty(daqfind))
%     stop(daqfind)
% end
% dio = digitalio('nidaq', 'Dev1');
% addline(dio, 0:7, 0, 'Out');
% putvalue(dio, [0 0 1 0 0 0 0 0]);
% pause(0.001)
% value1 = getvalue(dio);
% putvalue(dio, [0 0 0 0 0 0 0 0]);
% value2 = getvalue(dio);
% delete (dio);
% clear dio;
% %disp('Exit Worm End')




% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
