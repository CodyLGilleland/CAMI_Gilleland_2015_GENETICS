function varargout = PlasmidControllerX32Automated2(varargin)
% PLASMIDCONTROLLERX32AUTOMATED2 MATLAB code for PlasmidControllerX32Automated2.fig
%      PLASMIDCONTROLLERX32AUTOMATED2, by itself, creates a new PLASMIDCONTROLLERX32AUTOMATED2 or raises the existing
%      singleton*.
%
%      H = PLASMIDCONTROLLERX32AUTOMATED2 returns the handle to a new PLASMIDCONTROLLERX32AUTOMATED2 or the handle to
%      the existing singleton*.
%
%      PLASMIDCONTROLLERX32AUTOMATED2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLASMIDCONTROLLERX32AUTOMATED2.M with the given input arguments.
%
%      PLASMIDCONTROLLERX32AUTOMATED2('Property','Value',...) creates a new PLASMIDCONTROLLERX32AUTOMATED2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PlasmidControllerX32Automated2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PlasmidControllerX32Automated2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PlasmidControllerX32Automated2

% Last Modified by GUIDE v2.5 27-Apr-2012 12:39:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PlasmidControllerX32Automated2_OpeningFcn, ...
                   'gui_OutputFcn',  @PlasmidControllerX32Automated2_OutputFcn, ...
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


% --- Executes just before PlasmidControllerX32Automated2 is made visible.
function PlasmidControllerX32Automated2_OpeningFcn(hObject, eventdata, handles, varargin)
global Read_matfile_running
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PlasmidControllerX32Automated2 (see VARARGIN)

% Choose default command line output for PlasmidControllerX32Automated2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
Read_matfile_running == 1
StartLoop_pushbutton_Callback(hObject, eventdata, handles);
% UIWAIT makes PlasmidControllerX32Automated2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PlasmidControllerX32Automated2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in StartLoop_pushbutton.
function StartLoop_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to StartLoop_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global PlasmidDispenseTime
global PlasmidVibrateTime
global Read_matfile_running
global Read_matfile
global PlasmidDispenseTimeX32
global PlasmidDispenseTimeX32pause
global PlasmidVibrateTimeX32pause
global PlasmidPulseTimeX32pause
% global C
% global D
% global E
% global F
disp('Start Loop: X32PlasmidController');
Read_matfile_running = 1
%Read_matfile = 0;
%PlasmidVibrate
%PlasmidVibrate
%PlasmidPulse
while (Read_matfile_running == 1);
   try
   
    %pause(1)
    
    %disp('trying really hard');
    load('C:\Users\CodyGilleland\Desktop\CAMIcode_3_07_2012\PlasmidControllerX32DataTransfer.mat','Read_matfile','PlasmidDispenseTimeX32','PlasmidVibrateTimeX32','PlasmidPulseTimeX32','E','F','G','H');
    % disp('File Loaded: PlasmidControllerX32DataTransfer.mat');
    %pause(1)
    Read_matfile = single(Read_matfile);
    %Read_matfile = str2num(Read_matfile);
    if (Read_matfile == 1)
        %disp('Read_matfile = 1. file read');
        %Read_matfile = 0;
            PlasmidDispenseTimeX32pause = single(PlasmidDispenseTimeX32);
            PlasmidVibrateTimeX32pause = single(PlasmidVibrateTimeX32);
            PlasmidPulseTimeX32pause = single(PlasmidPulseTimeX32);
            if (PlasmidDispenseTimeX32pause > 0)
               % disp('dispense');
               PlasmidDispense
            end

            if (PlasmidVibrateTimeX32pause > 0)
               PlasmidVibrate
            end
            
            if (PlasmidPulseTimeX32pause > 0)
               PlasmidPulse
            end
           

            %Reset All Passed Variables
            Read_matfile = 0;
            PlasmidDispenseTimeX32 = 0;
            PlasmidVibrateTimeX32 = 0;
            PlasmidPulseTimeX32 = 0;
            E = 0;
            F = 0;
            G = 0;
            H = 0;
            %save reset variables
            % pause(1)
            %save('PlasmidControllerX32DataTransfer.mat','Read_matfile','PlasmidDispenseTimeX32','PlasmidVibrateTimeX32','PlasmidPulseTimeX32','E','F','G','H');
            save('C:\Users\CodyGilleland\Desktop\CAMIcode_3_07_2012\PlasmidControllerX32DataTransfer.mat','Read_matfile','PlasmidDispenseTimeX32','PlasmidVibrateTimeX32','PlasmidPulseTimeX32','E','F','G','H');            %pause(1); %arbitrary pause to allow file to be read and written without conflicts
            pause(0.05)
    else
        %disp('Read_matfile is OFF');
        pause(0.01)
    end
catch
    disp('Catch: PlasmidControlX32Read');
    pause(0.01)
   end
end






% --- Executes on button press in StopLoop_pushbutton.
function StopLoop_pushbutton_Callback(hObject, eventdata, handles)
global Read_matfile_running
% hObject    handle to StopLoop_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Read_matfile_running = 0;
disp('Stop Loop: X32PlasmidController');




function PlasmidDispense
% hObject    handle to PlasmidDispense_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global PlasmidDispensetimeX32
global stg
global PlasmidDispenseTimeX32pause
%if 
disp('Plasmid Dispense')
if (~isempty(daqfind))
    stop(daqfind)
end
dio = digitalio('nidaq', 'Dev1');
addline(dio, 0:7, 0, 'Out');
%tic
%turned on the vibrate as the last bit
putvalue(dio, [0 0 0 0 0 0 1 1]);
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


function PlasmidVibrate
% hObject    handle to PlasmidVibrate_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global PlasmidVibrateTimeX32pause

if (~isempty(daqfind))
    stop(daqfind)
end
disp('Plasmid Vibrate')
dio = digitalio('nidaq', 'Dev1');
addline(dio, 0:7, 0, 'Out');
%tic
putvalue(dio, [0 0 0 0 0 0 0 1]);
pause(PlasmidVibrateTimeX32pause);
%pause(1)
value1 = getvalue(dio);
putvalue(dio, [0 0 0 0 0 0 0 0]);
value2 = getvalue(dio);
%toc;
delete (dio);
clear dio;
%disp('Plasmid Dispense End')
PlasmidDispenseTimeX32pause = 0;

% --- Executes on button press in PlasmidPulse_pushbutton.
function PlasmidPulse
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
putvalue(dio, [0 0 0 0 0 0 1 1]);
pause(0.1) %default setting
%pause(1)
value1 = getvalue(dio);
putvalue(dio, [0 0 0 0 0 0 0 0]);
value2 = getvalue(dio);
%toc;
delete (dio);
clear dio;
%disp('Plasmid Pulse End')

% --- Executes on button press in PlasmidNudgeTap_pushbutton.
function PlasmidExitWorm
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
