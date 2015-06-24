
function varargout = CAMIvideoAVT(varargin)
% CAMIVIDEOAVT M-file for CAMIvideoAVT.fig
%      CAMIVIDEOAVT, by itself, creates a new CAMIVIDEOAVT or raises the existing
%      singleton*.
%
%      H = CAMIVIDEOAVT returns the handle to a new CAMIVIDEOAVT or the handle to
%      the existing singleton*.
%
%      CAMIVIDEOAVT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CAMIVIDEOAVT.M with the given input arguments.
%
%      CAMIVIDEOAVT('Property','Value',...) creates a new CAMIVIDEOAVT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CAMIvideoAVT_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CAMIvideoAVT_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CAMIvideoAVT

% Last Modified by GUIDE v2.5 19-Sep-2012 19:17:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CAMIvideoAVT_OpeningFcn, ...
                   'gui_OutputFcn',  @CAMIvideoAVT_OutputFcn, ...
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


% --- Executes just before CAMIvideoAVT is made visible.
function CAMIvideoAVT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CAMIvideoAVT (see VARARGIN)
% Choose default command line output for CAMIvideoAVT
global frames
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes CAMIvideoAVT wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CAMIvideoAVT_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
guidata(hObject, handles);


% --- Executes on button press in InitializeAll_pushbutton.
function InitializeAll_pushbutton_Callback(hObject, eventdata, handles)
%This pushbutton sets up communication with all hardware components

% hObject    handle to InitializeAll_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%set path
path(path,'C:\Users\CodyGilleland\Desktop\CAMIcode_3_07_2012') %set directory folder to access this file
openAVTvideo_pushbutton_Callback(hObject, eventdata, handles);
pause(1)
InitializeStage_pushbutton_Callback(hObject, eventdata, handles);
pause(1)
InitializeNikonTiScope_pushbutton_Callback(hObject, eventdata, handles);
pause(1)
InitializeSutterManipulator_pushbutton_Callback(hObject, eventdata, handles)
pause(1)
InitializePowerSupply_pushbutton_Callback(hObject, eventdata, handles)
pause(1)

% Start the X32 bit matlab version to run the digital output code
% This file reads a variable written
 !D:\MATLAB2010a\bin\matlab.exe -nodesktop -automation -r PlasmidControllerX32Automated2
pause(1)
disp('Initialized All')


% --- Executes on button press in UninitializeAll_pushbutton.
function UninitializeAll_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to UninitializeAll_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('Uninitialized All');
disp(0.1)
closeAVTvideo_pushbutton_Callback(hObject, eventdata, handles)
pause(1)
ReleaseNikonTiScope_pushbutton_Callback(hObject, eventdata, handles)
pause(1)
ReleaseStage_pushbutton_Callback(hObject, eventdata, handles)
pause(1)
ReleaseSutterManipulator_pushbutton_Callback(hObject, eventdata, handles)
pause(1)
ReleasePowerSupply_pushbutton_Callback(hObject, eventdata, handles)
pause(1)



function displayCenterMark(OBJ, EVENT, hImage)
 %This function displays a center mark on the screen by changing
 %the displayed pixels of the live image to black and white
 %The crosshair dynamically adapts as the digital zoom and magnification
 %change
    global objective
    global toggle
    global digital_zoom
    global crosshair_pos
    global gui_dim
    global gui_display_scale
    
    gui_dim = 1200;
    y_offset_2X = 37;
    x_offset_2X = 74;

    test_array = EVENT.Data;
    if test_array(1:3,1:3,1)==[255 0 255; 0 255 0; 255 0 255];
        new_image = 0;
    else
        new_image = 1;
    end
    
    
    if isequal(objective,1)
        if isequal(new_image,1)
            sizeTest_Array = size(test_array);
            shift_array = uint8(zeros(sizeTest_Array));
            shift_array(y_offset_2X+1:sizeTest_Array(1),1:sizeTest_Array(2)-x_offset_2X,1) = test_array(1:sizeTest_Array(1)-y_offset_2X,x_offset_2X+1:sizeTest_Array(2),1);
            test_array = shift_array;
        end
    end
    
    if isequal(digital_zoom,1)
        sizeTest_Array = size(test_array);
        if sizeTest_Array(2) > gui_dim || sizeTest_Array(1) > gui_dim
            center = [floor(size(test_array,1)/2), floor(size(test_array,2)/2)];
            upper_left = [center(1) - ceil(gui_dim/2), center(2) - ceil(gui_dim/2)];
            upper_left = cast(upper_left,'int32');
            size(test_array);
            test_array = test_array((upper_left(1)+1):(upper_left(1) + gui_dim),(upper_left(2)+1):(upper_left(2)+gui_dim),1);
            gui_display_scale = 1;

        end
    else
        sizeTest_Array = size(test_array);
        if sizeTest_Array(2) > gui_dim || sizeTest_Array(1) > gui_dim
            maxDim = max(sizeTest_Array(1),sizeTest_Array(2));
            new_scale = (gui_dim-1)/maxDim;
            test_array = imresize(test_array,new_scale);
            gui_display_scale = new_scale;
        end
    end
    

    if toggle,
       vert_center = floor(size(test_array,1)/2);
       horiz_center = floor(size(test_array,2)/2);
       crosshair_pos = [vert_center, horiz_center];
       radius = 1;
       diameter = 2*radius;
       light = 255;
       dark = 0;
       
       
       % Draw top square
       top_coord = [vert_center - (diameter+1), horiz_center];
       test_array(top_coord(1) - radius:top_coord(1) + radius,top_coord(2) - radius:top_coord(2) + radius,1) = light;
       
       % Draw bottom square
       bottom_coord = [vert_center + (diameter+1), horiz_center];
       test_array(bottom_coord(1) - radius:bottom_coord(1) + radius,bottom_coord(2) - radius:bottom_coord(2) + radius,1) = light;
       
       % Draw left square
       left_coord = [vert_center, horiz_center - (diameter+1)];
       test_array(left_coord(1) - radius:left_coord(1) + radius,left_coord(2) - radius:left_coord(2) + radius,1) = light;
       
       % Draw right square
       right_coord = [vert_center, horiz_center + (diameter+1)];
       test_array(right_coord(1) - radius:right_coord(1) + radius,right_coord(2) - radius:right_coord(2) + radius,1) = light;
       
       % Draw center black piece
       center_coord = [vert_center, horiz_center];
       test_array(center_coord(1) - radius:center_coord(1) + radius,center_coord(2) - radius:center_coord(2) + radius,1) = dark;
       

        
    end
    test_array(1:3,1:3,1) = [255 0 255; 0 255 0; 255 0 255];
    set(hImage, 'cdata', test_array);
    

% --- Executes on button press in openAVTvideo_pushbutton.
function openAVTvideo_pushbutton_Callback(hObject, eventdata, handles)
global AVT_Vid
global AVT_Vid_params
global vid_objects
global src
global cameraBinning
global CameraInformation
global img
global h
global toggle
global wormLoc
global wormIndex
global imageDIRECTORYNAME
global Adams_Dir
global montagevidsettings
global ch
global HIMAGE
global previewHandlesImage
global previewHandles
global CenterMarkHandlesImage
global digial_zoom


Adams_Dir = 'D:\Adam\CAMI_operation';


% hObject    handle to openAVTvideo_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

digital_zoom = 0; % toggle digital zoom to OFF

cameraBinning =2; 

if cameraBinning==2
    Binning='MONO16_1024x1024';
elseif cameraBinning==4
    Binning='MONO16_512x512';
elseif cameraBinning==8
    Binning='MONO16_256x256';
else
    Binning='MONO16_2048x2048';
end


CameraInformation = imaqhwinfo('avtmatlabadaptor64_r2009b');
%MATLAB image acquisition toolbox

AVT_Vid = videoinput('avtmatlabadaptor64_r2009b', 1, 'Mono8_2336x1752_Binning_1x1');
AVT_Vid_params = struct('binning',[1,1]);

src = getselectedsource(AVT_Vid)
pause(.1)
src.Shutter = 1500
imaqmem(10000000000); %essentially unlimiited memory allocated
AVT_Vid.FramesPerTrigger = 1; 

AVT_Vid.ROIPosition = [0 0 2336 1752];   %Select region of interest

AVT_Vid.ReturnedColorspace = 'grayscale';

h = CAMIvideoAVT
ch = get(h,'children')

previewHandles = findobj(ch,'tag','VideoAxesCAMI')

previewHandlesImage = image(zeros(1200),'parent',previewHandles)

set(previewHandlesImage,'cdata',255*ones(1200))

set(h,'WindowScrollWheelFcn',@ScrollWheelZ);
get(h,'WindowScrollWheelFcn');
%Cody removed to speed up centerclick function
set(h,'WindowButtonDownFcn',@MouseWindowClick);
CenterMarkHandlesImage = previewHandlesImage;
wormLoc = [];
toggle = true;
wormIndex = 0;
%=========================================================
% Initialize all video objects
[vid_2x2,vid_2x2_params] = create_vidobj(6);

[vid_4x4,vid_4x4_params] = create_vidobj(11);

[vid_8x8,vid_8x8_params] = create_vidobj(16);
                  
vid_objects = [{AVT_Vid},{AVT_Vid_params};
                      {vid_2x2},{vid_2x2_params};
                      {vid_4x4},{vid_4x4_params};
                      {vid_8x8},{vid_8x8_params}];
                  
%============================================================

preview(AVT_Vid, CenterMarkHandlesImage)
% preview(AVT_Vid, previewHandlesImage)
% preview(vid_objects{4,1}, vid_objects{4,3})
HIMAGE = preview(AVT_Vid, CenterMarkHandlesImage);
setappdata(HIMAGE, 'UpdatePreviewWindowFcn', @displayCenterMark);

% Set directory automatically with today's date
% hObject    handle to SetDirectory_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetDirectoryTITLE     = 'Set Image Directory';
SetDirectorySTARTPATH = 'D:\CAMI_SAVED_IMAGES'; %initial saved image oath
% Make the date
mkdir(SetDirectorySTARTPATH, date);
imageDIRECTORYNAME    = [SetDirectorySTARTPATH '\' date];
% montagevidsettings = get(src);


function MouseWindowClick(hObject, eventdata, handles)
%function MouseWindowClick(src,evnt)
%(hObject, eventdata, handles)
global stg
global NikonTiScope
global CAMImode
global h
global handle
global CurrentClickScreenX
global CurrentClickScreenY
global DesiredPositionX
global DesiredPositionY
global ClickScreenX
global ClickScreenY
global wormLoc
global wormIndex
global stg

%detect mouse click and position and store in variables
MouseClickPosition  = get(gca,'CurrentPoint');
MouseClickPositionX = round(MouseClickPosition(1,1));
MouseClickPositionY = round(MouseClickPosition(1,2));

%MODE OF OPERATION
%Depending on the mode of operation 'CAMImode' the user interface will repond
%in a unique way for each mouse click operation that is performed
%this allows the user to quickly click on the live image feed and 
%save time from having to click on the buttons for control

if (MouseClickPositionY < 1200)
     if (MouseClickPositionX < 1200)
         MouseClickInput = get(h,'SelectionType') %detect click type
         CAMImode %output the mode to the terminal screen  
         
         %logic for CAMImode and click type 
         switch CAMImode
                 case 1 %Needle Calibration
                            switch MouseClickInput
                                      case 'normal'
                                           disp('Left Click');
                                      case 'alt'
                                           disp('Right-Click');
                                      case 'open'
                                            disp('Double-Click')
                            end   
            
                 case 2 %GonadDetection
                             switch MouseClickInput
                                     case 'normal'
                                         disp('Left Click');
                                     case 'alt'
                                         disp('Right-Click');
                                     case 'open'
                                         disp('Double-Click')
                             end        
                
                 case 3 %NextWorm
                               switch MouseClickInput
                                     case 'normal'
                                         disp('Left Click');                                    
                                         CAMImode = 5; %FocusGonad
                                    case 'alt'
                                         disp('Right-Click');
                                         NextWorm_pushbutton_Callback(hObject, eventdata, handle);
                                    case 'open'
                                         disp('Double-Click')
                                      
                                   otherwise 
                                          disp('Please click within the window');
                               end     
           
                  case 4 %Center Click
                            switch MouseClickInput
                                    case 'normal'
                                        disp('Left Click');
                                    case 'alt'
                                        disp('Right-Click');
                                    case 'open'
                                        disp('Double-Click')  
                   end
       
                 case 5 %FocusGonad, here are performing fine XYZ gonad adjustment
                     switch MouseClickInput
                         case 'normal'
                                     disp('Left Click');                                    
                         case 'alt'
                                     disp('Right-Click');
                                     %engage the needle to bring it into
                                     %the image plane and penetrate the
                                     %gonad
                                   
                                     ManipulatorEngageNeedle_pushbutton_Callback(hObject, eventdata, handles);
                         case 'open'
                             disp('Double-Click')                            
                     end
                 
                 %Here the needle is penetrated and the clicking operations are used to finely adjust the needle position
                 %and pulse/dispense the plasmid
                 
                 case 6 %NeedleEngaged
                     EngageModeX = MouseClickPositionX;
                     EngageModeY = MouseClickPositionY;
                     switch MouseClickInput
                         case 'normal'
                             disp('Left ClickA');
                             
                             if (EngageModeY <= 1200)
                                 
                                 if (EngageModeX <= 600)
                                     %move needle down to the left in small
                                     %increment (3 micron)
                                     PlasmidDiagLeft_pushbutton_Callback();
                                     pause(0.1);
                                 end
                                 
                                 % Plasmid Pulse
                                 if (EngageModeX > 600)
                                     
                                     PlasmidDiagRight_pushbutton_Callback();
                                     
                                     pause(0.1)
                                 end
                             end
                         case 'alt'
                             disp('Right-Click');
                             %right-click
                             %Plasmid Dispense
                             if (EngageModeY <= 1200)
                                 if (EngageModeX <= 600)
                                     PlasmidPulse_pushbutton_Callback();
                                     pause(0.1);
                                 end
                                 % PlasmidExitWorm
                                 if (EngageModeX >= 600)
                                     PlasmidDispense_pushbutton_Callback();
                                 end
                             end
                         case 'open' 
                              if (EngageModeY <= 1200)
                                 % Nudge + Tap
                                 if (EngageModeX <= 600)
                                   
                                     pause(0.1);
                                 end
                                 
                                 % Plasmid Pulse
                                 if (EngageModeX > 600)
                                   
                                     pause(0.1)
                                 end
                             end 
                     end
             end      
     end     
end
%}


%This function controls the function of the mouse scroll wheel
function ScrollWheelZ(src,evnt)
global stg
global NikonTiScope
global NeedleEngagedFlag
global h

%We decided that performing small diagonal iterations of the needle served a better
%purpose

FastScroll =  evnt.VerticalScrollCount

if (NeedleEngagedFlag == 1)      
   %Speed up Scroll Wheel by adding multiplier for multiple scroll clicks   
  switch FastScroll
    case 1
            PlasmidDiagRight_pushbutton_Callback;
    case 2
            PlasmidDiagRight_pushbutton_Callback;
    case -1
            PlasmidDiagLeft_pushbutton_Callback;
    case -2
            PlasmidDiagLeft_pushbutton_Callback;   
    otherwise
        disp('Error Reading Scroll Wheel: Slow Your Roll - The Rock')        
  end
end

%FOCUS WITH MOUSE SCROLL WHEEL
%The scroll wheel can be used for focusing of the Z objective. The code for
%using the mouse scroll wheel to move the Z objective can be found
%commented out below in case future work would like to include this feature


% ZScrolldistance1xOBJ = 800;
% ZScrolldistance4xOBJ = ZScrolldistance1xOBJ/4;
% %ZScrolldistance10xOBJ = ZScrolldistance1xOBJ/10;  
% ZScrolldistance10xOBJ = ZScrolldistance1xOBJ/40;  
% ZScrolldistance20xOBJ = ZScrolldistance1xOBJ/40;
% ZScrolldistance50xOBJ = ZScrolldistance1xOBJ/50;
% ObjectiveCalibration = NikonTiScope.Nosepiece.Position.RawValue;
% pause(0.1);

% switch ObjectiveCalibration
%     case 1
%          ZScrolldistanceOBJcurrent = ZScrolldistance1xOBJ;
%     case 2
%          ZScrolldistanceOBJcurrent = ZScrolldistance4xOBJ;
%     case 3
%          ZScrolldistanceOBJcurrent = ZScrolldistance10xOBJ;
%     case 6
%          ZScrolldistanceOBJcurrent = ZScrolldistance20xOBJ;     
%     case 5 
%          ZScrolldistanceOBJcurrent = ZScrolldistance1xOBJ; 
%     case 4
%          ZScrolldistanceOBJcurrent = ZScrolldistance50xOBJ;    
%     otherwise
%         disp('Error Reading Correct Objective for Center Click Calibration');
% end


% evnt.VerticalScrollCount;
%       if evnt.VerticalScrollCount > 0 
%          zd = -1;
%          evnt.VerticalScrollCount;
%          ZScrolldistanceOBJcurrent = (ZScrolldistanceOBJcurrent*evnt.VerticalScrollCount)
%          NikonTiScope.ZDrive.MoveRelative(ZScrolldistanceOBJcurrent);
%          %NikonTiScope.
%          
%          
%       elseif evnt.VerticalScrollCount < 0 
%          zd = 1;
%          ZScrolldistanceOBJcurrent = (ZScrolldistanceOBJcurrent*evnt.VerticalScrollCount)
%          NikonTiScope.ZDrive.MoveRelative(ZScrolldistanceOBJcurrent);

%%%%%FastScroll =  evnt.VerticalScrollCount
% % % % 
% % % %       
% % % %    %Speed up Scroll Wheel by adding multiplier for multiple scroll clicks   
% % % %   switch FastScroll
% % % %     case 1
% % % %           ZScrolldistanceMultiplier = 1;
% % % %     case 2
% % % %           ZScrolldistanceMultiplier = 1.5;
% % % %     case 3
% % % %            ZScrolldistanceMultiplier = 2;
% % % %     case 4
% % % %            ZScrolldistanceMultiplier = 2.5;
% % % %     case 5
% % % %           ZScrolldistanceMultiplier = 3;   
% % % %     case 6
% % % %           ZScrolldistanceMultiplier = 3.5;
% % % %     case 7
% % % %           ZScrolldistanceMultiplier = 4;   
% % % %     case 8
% % % %           ZScrolldistanceMultiplier = 4.5;     
% % % %     case -1
% % % %            ZScrolldistanceMultiplier = -1;
% % % %     case -2
% % % %            ZScrolldistanceMultiplier = -1.5;
% % % %     case -3
% % % %           ZScrolldistanceMultiplier = -2;
% % % %     case -4
% % % %           ZScrolldistanceMultiplier = -2.5;   
% % % %     case -5
% % % %           ZScrolldistanceMultiplier = -3;   
% % % %     case -6
% % % %           ZScrolldistanceMultiplier = -3.5;
% % % %      case -7
% % % %           ZScrolldistanceMultiplier = -4;   
% % % %     case -8
% % % %           ZScrolldistanceMultiplier = -4.5;      
% % % %      otherwise
% % % %         disp('Error Reading Scroll Wheel')
% % % %         ZScrolldistanceMultiplier =0;
% % % % end
% % % % % ZScrolldistanceFast = (ZScrolldistanceOBJcurrent*ZScrolldistanceMultiplier);
% % % % 
% % % %  %NikonTiScope.ZDrive.MoveRelative(ZScrolldistanceFast);
% % % % %RotationDegreesValueConvertStr = num2str(round(ZScrolldistanceFast)); 
% % % % fprintf(stg,'SMA,100'); % Max speed, 4
% % % % fscanf(stg);
% % % % fprintf(stg,'SAA,100'); % Max acceleration
% % % % fscanf(stg);
% % % % fprintf(stg,'SSA,1'); % index
% % % % fscanf(stg);
% % % % 
% % % % RotationDegreesValueConvertStr = num2str(round(FastScroll*ZScrolldistanceMultiplier*0.7031*520.875*(-1.25)));   
% % % % 
% % % % % clear_stage_buffer();
% % % % fprintf(stg,['CW,',RotationDegreesValueConvertStr]); % Rotate Clockwise
% % % % fscanf(stg);
% % % %  %pause(0.1)

function [CurrentClickScreenX, CurrentClickScreenY] = CurrentClickScreenCoordinates(hObject, eventdata, handles)
%This function allows the user to clickon the screen and it will return the
%XY screen coordinates and the XY coordinates that correlate to the
%motorized stage

global clickx
global clicky
global movex
global movey
global movexstr
global moveystr
global stg
global COM
global NikonTiScope
global h
global ClickScreenX
global ClickScreenY


pointer1click = get(gca,'CurrentPoint');
clickx = pointer1click(1,1);
clicky = pointer1click(1,2);
set(gcf,'Pointer','arrow');

segmentdistance1xOBJ = 4398;%4446;
segmentdistance2xOBJ = 4398/2;
segmentdistance4xOBJ = segmentdistance1xOBJ/4;
segmentdistance10xOBJ = segmentdistance1xOBJ/10;
segmentdistance20xOBJ = segmentdistance1xOBJ/20;
segmentdistance50xOBJ = segmentdistance1xOBJ/50;
ObjectiveCalibration = NikonTiScope.Nosepiece.Position.RawValue;

switch ObjectiveCalibration
    case 1
         segmentdistanceOBJcurrent = segmentdistance2xOBJ;
    case 2
         segmentdistanceOBJcurrent = segmentdistance4xOBJ;
    case 3
         segmentdistanceOBJcurrent = segmentdistance10xOBJ;
    case 6
         segmentdistanceOBJcurrent = segmentdistance20xOBJ;     
    case 5 
        % segmentdistanceOBJcurrent = segmentdistance1xOBJ; 
    case 4
         segmentdistanceOBJcurrent = segmentdistance50xOBJ;    
    otherwise
        disp('Error Reading Correct Objective for Center Click Calibration')
end

centerx = 600;
centery = 600;

if (clickx < 1200) && (clicky <1200)    
    movex = ((centerx - clickx)/1200)*segmentdistanceOBJcurrent;
    movey = ((centery - clicky)/1200)*segmentdistanceOBJcurrent;
    movexstr = num2str(movex);
    moveystr = num2str(movey);
    clear_stage_buffer();
    fprintf(stg, 'P');
    CurrentPosition = str2num(fscanf(stg));
    CurrentClickScreenX = round(CurrentPosition(1) + movex);
    CurrentClickScreenY = round(CurrentPosition(2) + movey);
    disp(['The CurrentClickScreenCoordinate is at position (X,Y): ',num2str(ClickScreenX) ,', ',num2str(ClickScreenY) ])
else disp('Please click within the window')
end

function SetExposure_EditText_Callback(hObject, eventdata, handles)
%Camera exposure input text
global SetExposureInputTime

% Hints: get(hObject,'String') returns contents of SetExposure_EditText as text
%        str2double(get(hObject,'String')) returns contents of
%        SetExposure_EditText as a double

input = str2num(get(hObject,'String'));
%checks to see if input is empty. if so, default input1_editText to zero
if (isempty(input))
     set(hObject,'String','0')
end
SetExposureInput = get(handles.SetExposure_EditText,'String');
SetExposureInputTime = str2num(SetExposureInput);
    % a and b are variables of Strings type, and need to be converted
% to variables of Number type before they can be added together

%SetExposureInputTime = str2num(SetExposureInput)/1000;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function SetExposure_EditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SetExposure_EditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in closeAVTvideo_pushbutton.
function closeAVTvideo_pushbutton_Callback(hObject, eventdata, handles)
global AVT_Vid

% hObject    handle to closeAVTvideo_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stoppreview(AVT_Vid);
clear AVT_Vid;


% --- Executes on button press in setexposure_pushbutton.
function SetExposure_pushbutton_Callback(hObject, eventdata, handles)
%set camera exposure with pushbutton
global AVT_Vid
global SetExposureInputTime
global src
% hObject    handle to setexposure_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetExposureInputTimeStr  = num2str(SetExposureInputTime); 
if (1 <= SetExposureInputTime) && (SetExposureInputTime <= 4095)
src.Shutter = SetExposureInputTime; %Shutter 1 -> 4095 range
SetExposureInputTimeStr  = num2str(SetExposureInputTime);
disp(['Exposure is set to ' ,SetExposureInputTimeStr]) 
else disp('Please enter a value between 1 and 4095.')
end    


% --- Executes on button press in saveimage_pushbutton.
function saveimage_pushbutton_Callback(hObject, eventdata, handles)
%save image to disk
%a custom name is given tomimage by time and date
global AVT_Vid
global imageDIRECTORYNAME
global src
global cameraBinning
global CameraInformation
global img
global previewHandlesImage

% hObject    handle to saveimage_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

triggerconfig(AVT_Vid, 'manual');
set(AVT_Vid,  'FramesPerTrigger', 1);
start(AVT_Vid);
trigger(AVT_Vid);
dt = datestr(now, 'mmmm_dd_yyyy_HH_MM_SS_FFF_AM');
img_AVT = getdata(AVT_Vid);
imwrite(img_AVT,[imageDIRECTORYNAME, '\worm_imageAVT_', dt '.tif'],'tiff');
disp(['Image Saved: worm_imageAVT_' dt])


% --- Executes on button press in CenterClick_pushbutton.
function CenterClick_pushbutton_Callback(hObject, eventdata, handles)
%this function allows the user to click on an object on the live screen and
%the stage will automatically XY translate to move that object to the center of the screen
global stg
global NikonTiScope
global AVT_Vid
global objective
global digital_zoom
global crosshair_pos
global ratio_stg2X
global gui_display_scale
global NeedleDiagEngagedFlag
global NeedleEngagedFlag
global CAMImode
CAMImode = 4; %Center Click

if (NeedleEngagedFlag == 0)
    % hObject    handle to CenterClick_pushbutton (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    stg.timeout = 0.1;
 
    tic
    clear_stage_buffer();
    time_stgBuff = toc
    tic
    fprintf(stg, 'PX');
    CCcurrentPositionX = str2num(fscanf(stg));

    fprintf(stg, 'PY');
    CCcurrentPositionY = str2num(fscanf(stg));
    time_stgPos = toc
    set(gcf,'Pointer','crosshair');

    
    tic
    k = waitforbuttonpress;
    time_waitforClick = toc
    
    tic
    pointer1click = get(gca,'CurrentPoint');
    CCclickx = round(pointer1click(1,1));
    CCclicky = round(pointer1click(1,2));
    time_clickPos = toc
    set(gcf,'Pointer','arrow');

    tic
    ratio_stg2X = 1.89154;
    CCcenterx = crosshair_pos(2);
    CCcentery = crosshair_pos(1);
    height = crosshair_pos(1)*2;
    width = crosshair_pos(2)*2;

    ratio_2Xto20X = .1;
    ratio_objective = 1/gui_display_scale;
    
    if objective==6
        ratio_objective = ratio_2Xto20X/gui_display_scale
    end
    time3B = toc
    if (CCclickx < 1200) && (CCclicky <1200)    
        tic
        CCmovex = ((CCcenterx - CCclickx) * ratio_objective * ratio_stg2X); % fudge factor
        CCmovey = ((CCcentery - CCclicky) * ratio_objective * ratio_stg2X);
        CCAbsolutePosMoveX = CCcurrentPositionX + CCmovex;
        CCAbsolutePosMoveY = CCcurrentPositionY + CCmovey;
        CCmovexstr = num2str(round(CCAbsolutePosMoveX));
        CCmoveystr = num2str(round(CCAbsolutePosMoveY));
        digital_zoom=1; %turn on the digital zoom feature
        fprintf(stg,[ 'G,' CCmovexstr ', ' CCmoveystr ',0']);
        responseR = fscanf(stg);
        time4 =toc
    else
        disp('Please click within the window');
    end

else
    disp('Cannot Move to CenterClick with Needle Engaged');  
end 


% get the coordinates where the mouse is clicked on the screen
function [ClickScreenX, ClickScreenY] = ClickScreenCoordinates(hObject, eventdata, handles)
global clickx
global clicky
global movex
global movey
global movexstr
global moveystr
global stg
global COM
global NikonTiScope
global h
global ClickScreenX
global ClickScreenY

% hObject    handle to CenterClick_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gcf,'Pointer','crosshair');
k = waitforbuttonpress;

pointer1click = get(gca,'CurrentPoint');
clickx = pointer1click(1,1);
clicky = pointer1click(1,2);
set(gcf,'Pointer','arrow');
segmentdistance1xOBJ = 4398; %number of stage coorindates in one field of view 
segmentdistance2xOBJ = 4398/2;
segmentdistance4xOBJ = segmentdistance1xOBJ/4;
segmentdistance10xOBJ = segmentdistance1xOBJ/10;
segmentdistance20xOBJ = segmentdistance1xOBJ/20;
segmentdistance50xOBJ = segmentdistance1xOBJ/50;
ObjectiveCalibration = NikonTiScope.Nosepiece.Position.RawValue;

switch ObjectiveCalibration
    case 1
         segmentdistanceOBJcurrent = segmentdistance2xOBJ;
    case 2
         segmentdistanceOBJcurrent = segmentdistance4xOBJ;
    case 3
         segmentdistanceOBJcurrent = segmentdistance10xOBJ;
    case 6
         segmentdistanceOBJcurrent = segmentdistance20xOBJ;     
    case 5 
        % segmentdistanceOBJcurrent = segmentdistance1xOBJ; %1X objective
        % removed because the 2X objective fit our mapping needs much
        % better
    case 4
         segmentdistanceOBJcurrent = segmentdistance50xOBJ;    
    otherwise
        disp('Error Reading Correct Objective for Center Click Calibration')
end

%centerx = 600;
%centery = 600;

centerx = 600;
centery = 600;
if (clickx < 1200) && (clicky <1200)    
    movex = ((centerx - clickx)/1200)*segmentdistanceOBJcurrent;
    movey = ((centery - clicky)/1200)*segmentdistanceOBJcurrent;
    movexstr = num2str(movex);
    moveystr = num2str(movey);
    fprintf(stg, 'P');
    CurrentPosition = str2num(fscanf(stg));
    ClickScreenX = round(CurrentPosition(1) + movex);
    ClickScreenY = round(CurrentPosition(2) + movey);
    disp(['The Click Screen Coordinate is at position (X,Y): ',num2str(ClickScreenX) ,', ',num2str(ClickScreenY) ])
else disp('Please click within the window')
end


% --- Executes on button press in InitializeStage_pushbutton.
function [stg] = InitializeStage_pushbutton_Callback(hObject, eventdata, handles)
%initialize stage by serial connection
global stg
global stgCOM

stgCOM=5; %serial port connected to Prior ProscanII Stage
stg = serial(['COM' num2str(stgCOM)],'Terminator','CR');
fopen(stg)
pause(1)
disp('Prior Stage Initialized')



% --- Executes on button press in Objective1X_pushbutton.
function Objective1X_pushbutton_Callback(hObject, eventdata, handles)
%Switch to 1X magnification objective
%This function sets the new camera settings and Z height control depending on
%which objective was previously used to keep the object in focus

global NikonTiScope
global src
global AVT_Vid

currentObjective = NikonTiScope.Nosepiece.Position.RawValue;
src.Shutter = 30; %Shutter 1 -> 4095 range
src.Gain = 1;
src.ExtendedShutter = 10;
src.Autoexposure = 50;
src.ExtendedShutter = 600;

NikonTiScope.CondenserCassette.Position = 1;
currentPos = NikonTiScope.ZDrive.Position.RawValue;
AVT_Vid.ROIPosition = [545 325 1200 1200];

%adjusts the Z height of the objective to keep the object in focus from the previous objective 

switch currentObjective
    case 1
            disp('1X Objective already selected')
            
    case 2
        if (currentPos > 4000*40)    
           NikonTiScope.ZDrive.Value = 4000*40;
        end    
       
    case 3
           if (currentPos > 4000*40)    
              NikonTiScope.ZDrive.Value = 4000*40;
              pause(1)
           end
          
    case 4
            if (currentPos > 4000*40)    
               NikonTiScope.ZDrive.Value = 4000*40;
               pause(1)
            end
        
    case 5
            if (currentPos > 4000*40)    
               NikonTiScope.ZDrive.Value = 4000*40;
               pause(1)
            end 
            
    case 6
            disp('No objective is loaded')
            
    otherwise
            disp('There is an error loading the 1X objective')
end

NikonTiScope.Nosepiece.Position = 1;
NikonTiScope.ZDrive.Value = 1488*40;

disp('Lowering Objectives: 1X Loading')


% --- Executes on button press in Objective2X_pushbutton.
function Objective2X_pushbutton_Callback(hObject, eventdata, handles)
%Switch to 2X magnification objective
%This function sets the new camera settings and Z height control depending on
%which objective was previously used to keep the object in focus
global NikonTiScope
global src
global AVT_Vid
global objective

currentObjective = NikonTiScope.Nosepiece.Position.RawValue;
BrightField_pushbutton_Callback(hObject, eventdata, handles);

NikonTiScope.CondenserCassette.Position = 1;
src.Shutter = 50 %Shutter 1 -> 4095 range

currentPos = NikonTiScope.ZDrive.Position.RawValue;
AVT_Vid.ROIPosition = [0 0 2336 1752];

switch currentObjective
    case 1
            disp('2X Objective already selected')
            pause(0.1);
            
    case 2
        if (currentPos > 4000*40)    
           NikonTiScope.ZDrive.Value = 4000*40;
           pause(1)
        end
           NikonTiScope.ZDrive.MoveRelative(-88*40);
           pause(0.1);
             
    case 3
           if (currentPos > 8000*40)    
              NikonTiScope.ZDrive.Value = 4000*40;
              pause(1)
           end
           NikonTiScope.ZDrive.MoveRelative(-146*40);
           pause(0.1)
           
    case 4
            if (currentPos > 8000*40)    
               NikonTiScope.ZDrive.Value = 4000*40;
               pause(1)
            end
            NikonTiScope.ZDrive.MoveRelative(-73*40);
            pause(0.1);
            
    case 5
            disp('No objective is loaded')
            
    case 6
            NikonTiScope.ZDrive.MoveRelative(-1312*40);
            pause(0.1);
            disp('Objective 20X Plan Apo DIC Loaded')
    otherwise
            disp('There is an error loading the 2X objective')
end

pause(0.1);
NikonTiScope.Nosepiece.Position = 1;
objective = 1;
pause(0.1)
disp('Objective: 2X Loading')


% --- Executes on button press in Objective4X_pushbutton.
function Objective4X_pushbutton_Callback(hObject, eventdata, handles)
%Switch to 4X magnification objective
%This function sets the new camera settings and Z height control depending on
%which objective was previously used to keep the object in focus

global NikonTiScope
global src
global AVT_Vid

currentObjective = NikonTiScope.Nosepiece.Position.RawValue;
pause(0.1);
disp('Adjusting Objective Height: 4X Loading')
NikonTiScope.CondenserCassette.Position = 1;
pause(0.1);

src.Shutter = 200; %Shutter 1 -> 4095 range
src.Gain = 1;
src.ExtendedShutter = 10;
src.Autoexposure = 50;
src.ExtendedShutter = 600;
src.Shutter = 200; %Shutter 1 -> 4095 range
currentPos = NikonTiScope.ZDrive.Position.RawValue;
pause(0.1);

AVT_Vid.ROIPosition = [510 262 1200 1200];
switch currentObjective
    case 1
            NikonTiScope.ZDrive.MoveRelative(88*40);
            pause(0.1);
            
    case 2
            disp('4X Objective already selected') 
            
    case 3
            NikonTiScope.ZDrive.MoveRelative(-58*40);
            pause(0.1);
            
    case 6
            NikonTiScope.ZDrive.MoveRelative(-15*40); 
            pause(0.1);
            
    case 5
            %NikonTiScope.ZDrive.MoveAbsolute(currentPos + 445*40);       
            disp('No objective is selected')
            
    case 4
            disp('No objective is selected')
            
    otherwise
            disp('There is an error loading the 4X objective')
            
end
NikonTiScope.Nosepiece.Position = 2;
pause(0.1);


% --- Executes on button press in Objective10X_pushbutton.
function Objective10X_pushbutton_Callback(hObject, eventdata, handles)
%Switch to 10X magnification objective
%This function sets the new camera settings and Z height control depending on
%which objective was previously used to keep the object in focus
global NikonTiScope
global src
global AVT_Vid

tic
currentObjective = NikonTiScope.Nosepiece.Position.RawValue;
pause(0.1);

src.ExtendedShutter = 10;
src.Gain = 1;
src.Autoexposure = 50;
src.ExtendedShutter = 600;
src.Shutter = 300 %Shutter 1 -> 4095 range

NikonTiScope.CondenserCassette.Position = 1;
pause(0.1);
NikonTiScope.Nosepiece.Position = 3;
pause(0.1);
currentPos = NikonTiScope.ZDrive.Value.RawValue;
pause(0.1);

disp('Adjusting Objective Height: 10X Loading')
AVT_Vid.ROIPosition = [482 253 1200 1200];



switch currentObjective
    case 1
            NikonTiScope.ZDrive.MoveRelative(146*40);
            pause(0.1);
    case 2
            NikonTiScope.ZDrive.MoveRelative(58*40);
            pause(0.1);
    case 3
            disp('10X Objective already selected')    
    case 6
            NikonTiScope.ZDrive.MoveRelative(73*40); 
            pause(0.1);
    case 5
            disp('No objective is selected')
    case 4
            disp('No objective is selected')
    otherwise
            disp('There is an error loading the 10X objective')
end
disp(toc)



% --- Executes on button press in Objective20X_pushbutton.
function Objective20X_pushbutton_Callback(hObject, eventdata, handles)

%Switch to 20X magnification objective NO DIC
%This function sets the new camera settings and Z height control depending on
%which objective was previously used to keep the object in focus
global NikonTiScope
global stg
global AVT_Vid
global src
global AVT_Vid


tic
currentObjective = NikonTiScope.Nosepiece.Position.RawValue;
pause(0.1);
NikonTiScope.CondenserCassette.Position = 1;
pause(0.1);
NikonTiScope.Nosepiece.Position = 6;
pause(0.1);
currentPos = NikonTiScope.ZDrive.Value.RawValue;
pause(0.1);
src.ExtendedShutter = 10;
src.Gain = 1;
src.Autoexposure = 50;
src.ExtendedShutter = 600;
src.Shutter = 500; %Shutter 1 -> 4095 range
AVT_Vid.ROIPosition = [568 276 1200 1200];

switch currentObjective
    case 1
        NikonTiScope.ZDrive.MoveRelative(73*40); 
        pause(0.1);
    case 2
        NikonTiScope.ZDrive.MoveRelative(15*40); 
        pause(0.1);
    case 3
        NikonTiScope.ZDrive.MoveRelative(-73*40);
        pause(0.1);
    case 6
            disp('20X Objective already selected')    
    case 5
            disp('No objective is selected')
    case 4
            disp('No objective is selected')
    otherwise
            disp('There is an error loading the 20X objective')
end
disp(toc)
get(src)


% --- Executes on button press in Objective20XFluor_pushbutton.
function Objective20XFluor_pushbutton_Callback(hObject, eventdata, handles)
%Swith to new objective, this is a space saver for a new objective that can
%be added later

%Switch to 2X magnification objective
%This function sets the new camera settings and Z height control depending on
%which objective was previously used to keep the object in focus

%Switch to 20X magnification objective
%This function sets the new camera settings and Z height control depending on
%which objective was previously used to keep the object in focus
global NikonTiScope
global stg
global src
global AVT_Vid

NikonTiScope.Nosepiece.Position = 2;

pause(0.1);
pause(0.1);
src.Gain = 1;
src.Autoexposure = 50;
src.ExtendedShutter = 600;
src.Shutter = 1550; %Shutter 1 -> 4095 range
currentObjective = NikonTiScope.Nosepiece.Position.RawValue
pause(0.1);
disp('Adjusting Objective Height: 20X Loading')
clear_stage_buffer();
fprintf(stg,'SMZ,200'); %Z max speed
fscanf(stg);
AVT_Vid.ROIPosition = [568 276 1200 1200];

switch currentObjective
    case 1
            %adjust when new objective is loaded
    case 2
            %adjust when new objective is loaded        
    case 3
            %adjust when new objective is loaded
    case 4
            %adjust when new objective is loaded
    case 5
            disp('No objective is selected')
    case 6
            disp('20XFluor Objective already selected')    
    otherwise
            disp('There is an error loading the 20X objective')
end


% --- Executes on button press in BrightField_pushbutton.
function BrightField_pushbutton_Callback(hObject, eventdata, handles)
% Enable brightfield imaging
% Close shutters and open light path for illumination
% move motorize filter to empty position to allow 

global NikonTiScope

NikonTiScope.FilterBlockCassette1.Position = 1;
pause(0.1);
NikonTiScope.DiaShutter.Open
pause(0.1);
NikonTiScope.EpiShutter.Close
pause(0.1);


% --- Executes on button press in GFP_pushbutton.
function GFP_pushbutton_Callback(hObject, eventdata, handles)
%move filterblock to GFP position cube
global NikonTiScope

NikonTiScope.FilterBlockCassette1.Position = 4;
pause(0.1);
NikonTiScope.DiaShutter.Close;
pause(0.1);
NikonTiScope.EpiShutter.Open;
pause(0.1);


% --- Executes on button press in RFP_pushbutton.
function RFP_pushbutton_Callback(hObject, eventdata, handles)
%move filterblock to RFP position cube
global NikonTiScope

NikonTiScope.FilterBlockCassette1.Position = 3;
pause(0.1);
NikonTiScope.DiaShutter.Close;
pause(0.1);
NikonTiScope.EpiShutter.Open;
pause(0.1);
src.Gain = 34;
src.Autoexposure = 100;
src.ExtendedShutter = 600000;
src.Shutter = 4095;


% --- Executes on button press in ReleaseStage_pushbutton.
function ReleaseStage_pushbutton_Callback(hObject, eventdata, handles)
%release serial communication to XY motorized Prior Proscan II stage
global stg
global stgCOM
stgCOM=6;
%stg = serial(['COM' num2str(stgCOM)],'Terminator','CR');
fclose(stg);
pause(1)
disp('Prior Stage Released')


% --- Executes on button press in ReleaseNikonTiScope_pushbutton.
function ReleaseNikonTiScope_pushbutton_Callback(hObject, eventdata, handles)
%Release communication to NikonTi microscope over USB
global NikonTiScope
global microscopeCOM
global portStr

NikonTiScope.release %case sensitive! no cap in 'release'
pause(1);
disp('NikonTi Released')


% --- Executes on button press in InitializeNikonTiScope_pushbutton.
function InitializeNikonTiScope_pushbutton_Callback(hObject, eventdata, handles)
%Initialize communication to NikonTi microscope over USB
global NikonTiScope
global microscopeCOM
global portStr
global zvalue
global PFSSetOffset 

NikonTiScope = actxserver('Nikon.TiScope.NikonTi')
pause(1);
zvalue = 0;
% Open the shutter
BrightField_pushbutton_Callback(hObject, eventdata, handles);
%set PFSOffset to give an initial value when it is turned on
PFSSetOffset = 5817;
disp('Nikon Ti Scope Initialized')


% --- Executes on button press in InitializeSutterManipulator_pushbutton.
function InitializeSutterManipulator_pushbutton_Callback(hObject, eventdata, handles)
%start communication to Sutter Manipulator over serial port
manipControl('initialize')
pause(1)


% --- Executes on button press in ReleaseSutterManipulator_pushbutton.
function ReleaseSutterManipulator_pushbutton_Callback(hObject, eventdata, handles)
%release communication to Sutter Manipulator over serial port
manipControl('uninitialize')
pause(1)


% --- Executes on button press in ManipulatorEngageNeedle_pushbutton.
function ManipulatorEngageNeedle_pushbutton_Callback(hObject, eventdata, handles)
%This button brings the needle into the field of view and calibrated to
%bring the needle directly to the image focal plane for micron-precision
%injections. This feature also includes safety measures to prevent breaking
%of needles
global ManipulatorSetVariable
global SetEngageNeedlePositionZ_10XObj
global SetEngageNeedlePositionZ_20XObj
global SetHoverNeedlePositionTest
global ZDriveHoverRawValue_10XObj
global ZDriveHoverRawValue_20XObj
global NikonTiScope
global NeedleEngagedFlag
global CAMImode
global SetEngageNeedlePositionX
global SetEngageNeedlePositionY
global SetEngageNeedlePositionZ
global SetHoverNeedlePositionY
global NeedleHomeFlag

  if (NeedleHomeFlag == 1) %prevent new needdle from being brought in and damaged all the way from the HOME position
     disp('Needle Must be in HOVER position before engaging');
  else
        NeedleEngagedFlag = 1;
        NeedleHomeFlag = 0;
        CAMImode = 6; %NeedleEngaged
        ObjectiveCalibration = double(NikonTiScope.Nosepiece.Position.RawValue); % determine objective
        pause(0.1);
        CurrentImageFocusZRawValue = double(NikonTiScope.ZDrive.Value.RawValue/40) % Where we currently are at
        pause(0.1);
        DeltaManipulatorTravel_10XObj = (double(ZDriveHoverRawValue_10XObj) - (CurrentImageFocusZRawValue));
        DeltaManipulatorTravel_20XObj = (double(ZDriveHoverRawValue_20XObj) - CurrentImageFocusZRawValue);
        ZDriveHoverRawValue_10XObj;
        ZDriveHoverRawValue_20XObj;
        PlasmidPulse_pushbutton_Callback(hObject, eventdata, handles); 
         if (ManipulatorSetVariable == 1)
             disp('Engage Needle does not have a SET function. Please ensure it is calibrated by pressing SET then HOVER NEEDLE buttons')
         end


                 switch ObjectiveCalibration; %Engage Needle based up 10X or 20X objective height
                              case 1
                                       disp('Please switch to 10x or 20X objectives to engage the needle');
                              case 2
                                       disp('Please switch to 10x or 20X objectives to engage the needle');
                              case 3
                                        disp('Needle Engaged: 10X Objective');
                                       SetEngageNeedlePositionX = SetHoverNeedlePositionTest(1)
                                       SetEngageNeedlePositionY = SetHoverNeedlePositionTest(2)
                                       SetEngageNeedlePositionZ = SetEngageNeedlePositionZ_10XObj + double((16*DeltaManipulatorTravel_10XObj)-(0*16)) %16um fudge factor removed
                                       if  SetEngageNeedlePositionZ < (24999*16) % prevent gross errors in Z height
                                           manipControl('changePosition',0,1,SetEngageNeedlePositionX,SetEngageNeedlePositionY,SetEngageNeedlePositionZ);
                                           pause(0.25);
                                       else
                                           disp('The Z height will result in broken needle. Please check needle height calibration.')  
                                      end

                               case 6
                                       disp('Needle Engaged: 20X Objective');
                                       SetEngageNeedlePositionX = SetHoverNeedlePositionTest(1) 
                                       SetEngageNeedlePositionY = SetHoverNeedlePositionTest(2)
                                       SetEngageNeedlePositionZ = SetEngageNeedlePositionZ_20XObj + double((16*DeltaManipulatorTravel_20XObj)-(0*16)) %16um fudge factor removed
                                       if  SetEngageNeedlePositionZ < (24999*16) % prevent gross errors in Z height
                                            Approach = 40; %move from HOVER and get very close and stop to prevent overshoot 
                                                           %then proceed overa smaller distant to prevent damage from overshoot and backlash of fast moving needle 
                                            
                                            %small adjustment in XY before moving axially to target               
                                            manipControl('changePosition',0,1,SetEngageNeedlePositionX-(600*16),SetEngageNeedlePositionY,SetEngageNeedlePositionZ -(600*16));
                                            pause(0.5);                                    
                                            %move axially toward the target
                                            %location and stop a short
                                            %distance before 
                                            %(approach~40um)
                                  
                                            manipControl('changePosition',0,1,SetEngageNeedlePositionX-(Approach*16),SetEngageNeedlePositionY,SetEngageNeedlePositionZ -(Approach*16));
                                            pause(0.5);
                                            
                                            %vibrate the needle and
                                            %puncture the worm to enter
                                            %gonad axially
                                            PlasmidVibrate_pushbutton_Callback(hObject, eventdata, handles); 
                                            manipControl('changePosition',0,1,SetEngageNeedlePositionX,SetEngageNeedlePositionY,SetEngageNeedlePositionZ);
                                            pause(0.5);

                                       else
                                            disp('The Z height will result in broken needle. Please check needle height calibration.')  
                                       end
                               case 5
                                       disp('Please switch to 10x or 20X Objectives to engage the needle');
                               case 4
                                       disp('Please switch to 10x or 20X Objectives to engage the needle');
                     otherwise
                                       disp('Error Reading Correct Objective for Calibration')
                 end
end

 
 
 
 
 
% --- Executes on button press in ManipulatorHoverNeedle_pushbutton.
function ManipulatorHoverNeedle_pushbutton_Callback(hObject, eventdata, handles)
%This button brings the needle into the hover position that is 45deg angle
%above the previous set target and it the start point before a new target
%it engaged with the needle. The Z height is just above the gel to allow
%the needle to move to the next target without dragging through the hydrogel.
%To prevent needlge clogs the needle pressure is pulsed to remove any hydrogel from the tip 

global ManipulatorSetVariable
global SetHoverNeedlePositionTest
global SetEngageNeedlePositionX
global SetEngageNeedlePositionY
global SetEngageNeedlePositionZ_10XObj
global SetEngageNeedlePositionZ_20XObj
global ZDriveHoverRawValue_10XObj
global ZDriveHoverRawValue_20XObj
global NikonTiScope
global NeedleEngagedFlag
global SetHoverNeedlePositionY
global NeedleDiagHoveredFlag
global NeedleDiagEngagedFlag
global NeedleDiagEngageApproval
global NeedleHomeFlag

NeedleEngagedFlag = 0;
ObjectiveCalibration = NikonTiScope.Nosepiece.Position.RawValue;
pause(0.1);

 if (ManipulatorSetVariable == 1) % check for SET button activated    
      SetHoverNeedlePositionTest = (manipControl('getPosition',0,1));    
      if  ((SetHoverNeedlePositionTest(3) < (24999*16)) &&  (SetHoverNeedlePositionTest(2) < (24999*16)) && (SetHoverNeedlePositionTest(1) < (24999*16)) )  % prevent gross errors in Z height 
           
             switch ObjectiveCalibration; %Set Engage Needle based up 10X or 20X objective height
                      case 1
                               disp('Please switch to 10x or 20X objectives to engage the needle');
                      case 2
                               disp('Please switch to 10x or 20X objectives to engage the needle');
                      case 3
                               disp('Engage Needle Calibrated: 10X Objective');
                               SetEngageNeedlePositionX = SetHoverNeedlePositionTest(1);
                               SetEngageNeedlePositionY = SetHoverNeedlePositionTest(2);
                               SetEngageNeedlePositionZ_10XObj = SetHoverNeedlePositionTest(3); 
                               ZDriveHoverRawValue_10XObj = double(NikonTiScope.ZDrive.Value.RawValue)/40; % Divide by 40 to get in microns
                               pause(0.25);
                       case 6
                               disp('Engage Needle Calibrated: 20X Objective');
                               SetEngageNeedlePositionX = SetHoverNeedlePositionTest(1);
                               SetEngageNeedlePositionY = SetHoverNeedlePositionTest(2);
                               SetEngageNeedlePositionZ_20XObj = SetHoverNeedlePositionTest(3);                   
                               SetEngageNeedlePositionZ = SetHoverNeedlePositionTest(3); 
                               ZDriveHoverRawValue_20XObj = round(double(NikonTiScope.ZDrive.Value.RawValue)/40); % Divide by 40 to get in microns
                               pause(0.25);
                       case 5
                               disp('Please switch to 10x or 20X Objectives to engage the needle');
                       case 4
                               disp('Please switch to 10x or 20X Objectives to engage the needle');
             otherwise
                               disp('Error Reading Correct Objective for Calibration')
            end
      else
               disp('The Z height will result in broken needle. Cannot Set EngageNeedleZ here. Please check needle height calibration.') 
      end
 else
     
       disp('Hover Needle');
       SetHoverNeedlePositionX = SetHoverNeedlePositionTest(1)
       SetHoverNeedlePositionY = SetHoverNeedlePositionTest(2)
       SetEngageNeedlePositionZ_20XObj
       SetEngageNeedlePositionZ = SetHoverNeedlePositionTest(3);
       
       if (NeedleHomeFlag == 1)
       %prevent damage to needle by making it move over the hover location
       %in XY before moving down
        manipControl('changePosition',0,1,2000*16, 23000*16,4000*16);
        pause(2.5)
        manipControl('changePosition',0,1,2000*16, SetHoverNeedlePositionY,4000*16);
        pause(2.5)
     
       end
       
       manipControl('changePosition',0,1,SetEngageNeedlePositionX - (600*16),SetEngageNeedlePositionY,SetEngageNeedlePositionZ - (600*16)); %Notice Z value is hardcoded

       NeedleDiagEngagedFlag = 0; % Flag for determining if needle is engaged

       NeedleHomeFlag = 0; %flag to determin needle is not in HOME position for error prevention
       pause(0.25)
       
       %pulse the plasmid to prevent dry gel from clogging the needle
       PlasmidPulse_pushbutton_Callback(hObject, eventdata, handles);            
 end


% --- Executes on button press in ManipulatorExchangeNeedle_pushbutton.
function ManipulatorExchangeNeedle_pushbutton_Callback(hObject, eventdata, handles)
%move the manipulator to an XYZ position that allows the needle to be exhanged

% hObject    handle to ManipulatorExchangeNeedle_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%manipControl('changePosition',0,1,12500*16,12500*16,12500*16)
global NeedleHoveredFlag
global NeedleEngagedFlag
global NeedleEngageApproval
global NeedleHomeFlag
global SetHoverNeedlePositionY

NeedleHomeFlag = 1;
NeedleHoveredFlag = 0;
NeedleEngagedFlag = 0;
NeedleEngageApproval = 0;
  
      HomeNeedlePositionTest = (manipControl('getPosition',0,1));
      pause(0.5)
      if  (HomeNeedlePositionTest(3) > (4100*16)) % prevent gross errors in Z height 
        manipControl('changePosition',0,1,2000*16, SetHoverNeedlePositionY,4000*16);
        pause(4)
    
      else
               disp('The Z height will result in broken needle. Cannot move needle to HOME. Please check needle height calibration.') 
      end

        disp('Home/Exchange Needle');
        manipControl('changePosition',0,1,2000*16,23000*16,0000*16);
        pause(2.5)
        PlasmidPulse_pushbutton_Callback(hObject, eventdata, handles);


% --- Executes on button press in ManipulatorBleachStation_pushbutton.
function ManipulatorBleachStation_pushbutton_Callback(hObject, eventdata, handles)
% This function allows users to preset location of stations for the
% manipulator to travel to complete different tasks such as needle washing
% in bleach

global ManipulatorSetVariable
global SetBleachStationNeedlePosition
global ManipulatorEnableStationMoveVariable 

 if (ManipulatorSetVariable == 1)
    SetBleachStationNeedlePosition = (manipControl('getPosition',0,1))
    pause(0.5)
    disp('Bleach Station has been set to current location')
 end
 
 if (ManipulatorEnableStationMoveVariable == 1) 
 SetBleachStationNeedlePositionX = SetBleachStationNeedlePosition(1);
 SetBleachStationNeedlePositionY = SetBleachStationNeedlePosition(2);
 SetBleachStationNeedlePositionZ = SetBleachStationNeedlePosition(3);
 manipControl('changePosition',0,1,SetBleachStationNeedlePositionX,SetBleachStationNeedlePositionY,SetBleachStationNeedlePositionZ)
 pause(0.5)
 else if (ManipulatorSetVariable == 0)
      disp('Enable Station Move button must be pressed')
 
      end
 end



% --- Executes on button press in ManipulatorRinseStation_pushbutton.
function ManipulatorRinseStation_pushbutton_Callback(hObject, eventdata, handles)
% This function allows users to preset location of stations for the
% manipulator to travel to complete different tasks such as needle rinsing
global ManipulatorSetVariable
global SetRinseStationNeedlePosition
global ManipulatorEnableStationMoveVariable

 if (ManipulatorSetVariable == 1)
    SetRinseStationNeedlePosition = (manipControl('getPosition',0,1))
    pause(0.5)
    disp('Rinse Station has been set to current location')
 end
 
 if (ManipulatorEnableStationMoveVariable == 1) 
 SetRinseStationNeedlePositionX = SetRinseStationNeedlePosition(1);
 SetRinseStationNeedlePositionY = SetRinseStationNeedlePosition(2);
 SetRinseStationNeedlePositionZ = SetRinseStationNeedlePosition(3);
 manipControl('changePosition',0,1,SetRinseStationNeedlePositionX,SetRinseStationNeedlePositionY,SetRinseStationNeedlePositionZ)
 pause(0.5)
 else if (ManipulatorSetVariable == 0)
     disp('Enable Station Move button must be pressed') 
     end
 end

 
% --- Executes on button press in ManipulatorPlasmidStation1_pushbutton.
function ManipulatorPlasmidStation1_pushbutton_Callback(hObject, eventdata, handles)
% This function allows users to preset location of stations for the
% manipulator to travel to complete different tasks such as loading new
% plasmid

global ManipulatorSetVariable
global SetPlasmidStation1NeedlePosition
global ManipulatorEnableStationMoveVariable

 if (ManipulatorSetVariable == 1)
    SetPlasmidStation1NeedlePosition = (manipControl('getPosition',0,1))
    pause(0.5)
    disp('Plasmid Station #1 has been set to current location')
 end
 
 if (ManipulatorEnableStationMoveVariable == 1) 
 SetPlasmidStation1NeedlePositionX = SetPlasmidStation1NeedlePosition(1);
 SetPlasmidStation1NeedlePositionY = SetPlasmidStation1NeedlePosition(2);
 SetPlasmidStation1NeedlePositionZ = SetPlasmidStation1NeedlePosition(3);
 manipControl('changePosition',0,1,SetPlasmidStation1NeedlePositionX,SetPlasmidStation1NeedlePositionY,SetPlasmidStation1NeedlePositionZ)
 pause(0.5)
 else if (ManipulatorSetVariable == 0)
     disp('Enable Station Move button must be pressed')
     end
 end

 
% --- Executes on button press in ManipulatorPlasmidStation2_pushbutton.
function ManipulatorPlasmidStation2_pushbutton_Callback(hObject, eventdata, handles)
% This function allows users to preset location of stations for the
% manipulator to travel to complete different tasks such as loading new
% plasmid

global ManipulatorSetVariable
global SetPlasmidStation2NeedlePosition
global ManipulatorEnableStationMoveVariable
% hObject    handle to ManipulatorEngageNeedle_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 if (ManipulatorSetVariable == 1)
    SetPlasmidStation2NeedlePosition = (manipControl('getPosition',0,1))
    pause(0.5) 
    disp('Plasmid Station #2 has been set to current location')
 end
 
 if (ManipulatorEnableStationMoveVariable == 1) 
 SetPlasmidStation2NeedlePositionX = SetPlasmidStation2NeedlePosition(1);
 SetPlasmidStation2NeedlePositionY = SetPlasmidStation2NeedlePosition(2);
 SetPlasmidStation2NeedlePositionZ = SetPlasmidStation2NeedlePosition(3);
 manipControl('changePosition',0,1,SetPlasmidStation2NeedlePositionX,SetPlasmidStation2NeedlePositionY,SetPlasmidStation2NeedlePositionZ)
 pause(0.5)
 else if (ManipulatorSetVariable == 0)
     disp('Enable Station Move button must be pressed')
 
     end
 end
 
 
 
% --- Executes on button press in ManipulatorPlasmidStation3_pushbutton.
function ManipulatorPlasmidStation3_pushbutton_Callback(hObject, eventdata, handles)
% This function allows users to preset location of stations for the
% manipulator to travel to complete different tasks such as loading new
% plasmid

global ManipulatorSetVariable
global SetPlasmidStation3NeedlePosition
global ManipulatorEnableStationMoveVariable 
% hObject    handle to ManipulatorEngageNeedle_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 if (ManipulatorSetVariable == 1)
    SetPlasmidStation3NeedlePosition = (manipControl('getPosition',0,1));
    pause(0.5) 
    disp('Plasmid Station #2 has been set to current location')
 end
 
 if (ManipulatorEnableStationMoveVariable == 1)  
 SetPlasmidStation3NeedlePositionX = SetPlasmidStation3NeedlePosition(1);
 SetPlasmidStation3NeedlePositionY = SetPlasmidStation3NeedlePosition(2);
 SetPlasmidStation3NeedlePositionZ = SetPlasmidStation3NeedlePosition(3);
 manipControl('changePosition',0,1,SetPlasmidStation3NeedlePositionX,SetPlasmidStation3NeedlePositionY,SetPlasmidStation3NeedlePositionZ)
 pause(0.5)
 else if (ManipulatorSetVariable == 0)
     disp('Enable Station Move button must be pressed')
     end
 end
 
 
% --- Executes on button press in ManipulatorInjectionApproach_pushbutton.
function ManipulatorInjectionApproach_pushbutton_Callback(hObject, eventdata, handles)
%This feature allows the user to move the needle to a new location by
%clicking on the screen

global ch
global VideoAxesCAMI
global stg
global NikonTiScope

% hObject    handle to ManipulatorInjectionApproach_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%segmentdistance1xOBJ = 10140; original value from Retiga4000DC
%segmentdistance1xOBJ = 10140; original value from Retiga4000DC

%1. Left Click on Needle Tip and draw polyline to endpoint
%Option A. Double-Left-Click on endpoint
%Option B. Right-Click on endpoint
%Option C. Left-Click then Press 'Enter'
%Option D. Remove last click by pressing 'Backspace' or 'Delete'
segmentdistance1xOBJ = 4386;
segmentdistance2xOBJ = 4386/2; %size of screen in pixels wide
segmentdistance4xOBJ  = segmentdistance1xOBJ/4;
segmentdistance10xOBJ = segmentdistance1xOBJ/10;
segmentdistance20xOBJ = segmentdistance1xOBJ/20;
segmentdistance50xOBJ = segmentdistance1xOBJ/50;
ObjectiveCalibration = NikonTiScope.Nosepiece.Position.RawValue;
pause(0.1);

switch ObjectiveCalibration;
    case 1
         segmentdistanceOBJcurrent = segmentdistance2xOBJ;
    case 2
         segmentdistanceOBJcurrent = segmentdistance4xOBJ;
    case 3
         segmentdistanceOBJcurrent = segmentdistance10xOBJ;
    case 6
         segmentdistanceOBJcurrent = segmentdistance20xOBJ;  
    case 5
         segmentdistanceOBJcurrent = segmentdistance1xOBJ;
    case 4
         segmentdistanceOBJcurrent = segmentdistance50xOBJ;    
    otherwise
        disp('Error Reading Correct Objective for Center Click Calibration')
end

set(gcf,'Pointer','crosshair');
k = waitforbuttonpress;
Needlepointer1click = round(get(gca,'CurrentPoint'))
NeedleClickX1 = Needlepointer1click(1,1);
NeedleClickY1 = Needlepointer1click(1,2);
set(gcf,'Pointer','crosshair');

v = waitforbuttonpress;
Needlepointer2click = round(get(gca,'CurrentPoint'));
NeedleClickX2 = Needlepointer2click(1,1);
NeedleClickY2 = Needlepointer2click(1,2);
set(gcf,'Pointer','arrow');

NeedleClickDifferenceX = NeedleClickX1 - NeedleClickX2;
NeedleClickDifferenceY = NeedleClickY1 - NeedleClickY2;
NeedleClickDifferenceXMicrons = (NeedleClickDifferenceX/1200) * (segmentdistanceOBJcurrent);
NeedleClickDifferenceYMicrons = (NeedleClickDifferenceY/1200) * (segmentdistanceOBJcurrent);
NEEDLE_POSITION = (manipControl('getPosition',0,1))/16; %positions in microns
pause(0.5)
manipx = NEEDLE_POSITION(1);
manipy = NEEDLE_POSITION(2);
manipz = NEEDLE_POSITION(3);

RelativeManipMoveX = NEEDLE_POSITION(1) + NeedleClickDifferenceXMicrons;
RelativeManipMoveY = NEEDLE_POSITION(2) + NeedleClickDifferenceYMicrons;
%RelativeManipMoveZ = NEEDLE_POSITION(3) - NeedleClickDifferenceZMicrons

manipControl('changePosition',0,1,round(RelativeManipMoveX*16),round(RelativeManipMoveY*16),(NEEDLE_POSITION(3))*16)
pause(0.5)

% --- Executes on button press in SetDirectory_pushbutton.
function SetDirectory_pushbutton_Callback(hObject, eventdata, handles)
%set the directory for saving new images
global imageDIRECTORYNAME
% hObject    handle to SetDirectory_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetDirectoryTITLE = 'Set Image Directory';
SetDirectorySTARTPATH = 'D:\CAMI_SAVED_IMAGES';
imageDIRECTORYNAME = uigetdir(SetDirectorySTARTPATH, SetDirectoryTITLE)




% --- Executes on button press in ManipulatorSet_pushbutton.
function ManipulatorSet_pushbutton_Callback(hObject, eventdata, handles)
%This 'set' button is used to set the target position of the needle to
%calibrate with image plane. For example: to calibrate the XYZ position of the
%needle with the center of the image place, click 'set' then click 'Hover to calibrate.
%The 'set' button is active for 3 seconds. 
global ManipulatorSetVariable
% hObject    handle to ManipulatorSet_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ManipulatorSetVariable = 1;
disp('Manipulator Set Position Activated for 3 seconds.')
pause(3)
ManipulatorSetVariable = 0;
disp('Manipulator Set Position De-activated.')


% --- Executes on button press in ImageScanStitch_pushbutton.
function ImageScanStitch_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to ImageScanStitch_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AVT_Vid
global imageDIRECTORYNAME
global src
global cameraBinning
global CameraInformation
global img
global previewHandlesImage
global NikonTiScope
global stg

triggerconfig(AVT_Vid, 'manual');

segmentdistance1xOBJ = 4386;
segmentdistance4xOBJ = segmentdistance1xOBJ/4;
segmentdistance10xOBJ = segmentdistance1xOBJ/10;
segmentdistance20xOBJ = segmentdistance1xOBJ/20;
segmentdistance50xOBJ = segmentdistance1xOBJ/50;
ObjectiveCalibration = NikonTiScope.Nosepiece.Position.RawValue
pause(0.1);

switch ObjectiveCalibration
    case 1
         segmentdistanceOBJcurrent = segmentdistance1xOBJ;
    case 2
         segmentdistanceOBJcurrent = segmentdistance4xOBJ;
    case 3
         segmentdistanceOBJcurrent = segmentdistance10xOBJ;
    case 6
         segmentdistanceOBJcurrent = segmentdistance20xOBJ;     
    case 4
         segmentdistanceOBJcurrent = segmentdistance50xOBJ;    
    otherwise
        disp('Error Reading Correct Objective for Center Click Calibration')
end


stitchsizeX = 3; %define the size of the stitched area
stitchsizeY = 3; %define the size of the stitched area 
stitchsizeXstr = num2str(stitchsizeX);
stitchsizeYstr = num2str(stitchsizeY);
segmentdistance = segmentdistanceOBJcurrent; % 
segmentdistancestr = num2str(segmentdistance);
%img=0;
M=1;
N=1;
%imcatrow1 =0;
for N=1:1:stitchsizeY-1 
        
        for M=1:1:stitchsizeX-1
            clear_stage_buffer();
            fprintf(stg,'P');
            Current_Location = fscanf(stg)
            start(AVT_Vid);
            %triggerconfig(AVT_Vid, 'manual');
            
            trigger(AVT_Vid);
            img_AVT = getdata(AVT_Vid);

            Mstr = num2str(M);
            Nstr = num2str(N);
            eval(['image' Nstr, Mstr ' = img_AVT;']);
            %imwrite(img,['C:\Documents and Settings\cgilleland\Desktop\CAMI_ImageProcessing\worm_image', Nstr,Mstr '.tif'],'tiff');
            %pause(1)
            %segmentdistance;
            clear_stage_buffer();
            fprintf(stg,['GR, ', segmentdistancestr, ',0']);
            response = fscanf(stg);
            %pause(1);
            %img[1] 
            if M==1  
                imgcatrow1 = img;
                M
            end
            if M>1
                %previous_imgcatrow_str = num2str(M-1); 
                previous_imgcatrow_str = num2str(M-1); 
                M
               % eval(['imgcatrow' Mstr ' = cat(2,imgcatrow' previous_imgcatrow_str ',img);'])
                eval(['imgcatrow' Mstr ' = cat(2,img, imgcatrow' previous_imgcatrow_str ');']);
                %eval(['imgcatcolumn' Nstr ' = cat(1,imgcatrow' Nstr ', imgcatcolumn' previous_imgcatcolumn_str ');']);
            end
        end

     % imwrite(imgcatrow' stitchsizeXstr ,[filenametext '\catrow', Nstr,Mstr '.tif'],'tiff');

%should be imgcatrow5
            
            if N==1
             imgcatcolumn1 = imgcatrow1;
            end
            if N>1
             previous_imgcatcolumn_str = num2str(N-1);
            
             %should be Mstr at ;the end
             eval(['imgcatcolumn' Nstr ' = cat(1,imgcatcolumn' previous_imgcatcolumn_str ', imgcatrow' stitchsizeXstr ');']);
       %     eval(['imgcatcolumnstr = imgcatcolumn' Nstr ';' ]);  
            %num2str(
            
           % eval(['imgcatrow' Mstr ' = cat(2,img, imgcatrow' previous_imgcatrow_str ');']);
           %  eval(['imgcatcolumn' Nstr ' = cat(1, imgcatrow' Nstr ', imgcatcolumn' previous_imgcatcolumn_str ');']);
            end
            %eval(['imgcat' Nstr, Mstr ' = cat(2, image' Nstr, Mstr;')']);
            nextrowstr = num2str(stitchsizeX*segmentdistance);
             
            
            clear_stage_buffer();
            fprintf(stg,['GR,-' nextrowstr ',-' segmentdistancestr]);
            response = fscanf(stg)
            pause(5)

end



%for K =1:1:stitchsize
%  eval(['imread(catrow' Nstr , Mstr ', 'C:\Documents and Settings\cgilleland\Desktop\CAMI_ImageProcessing\catrow', Nstr,Mstr '.tif'],'tiff'  

  
  %{


%}
%imgcatfinal = imgcatcolumn;


%imgcatfinal = cat(1, imgcat11, imgcat21, imgcat31, imgcat41, imgcat51);


filenametext = 'C:\Documents and Settings\cgilleland\Desktop\CAMI_ImageProcessing\';
%{
imwrite(imgcat11,['C:\Documents and Settings\cgilleland\Desktop\CAMI_ImageProcessing\stitchedcat11.tif'],'tiff');
imwrite(imgcat21,['C:\Documents and Settings\cgilleland\Desktop\CAMI_ImageProcessing\stitchedcat21.tif'],'tiff');
imwrite(imgcat31,['C:\Documents and Settings\cgilleland\Desktop\CAMI_ImageProcessing\stitchedcat31.tif'],'tiff');
imwrite(imgcat41,['C:\Documents and Settings\cgilleland\Desktop\CAMI_ImageProcessing\stitchedcat41.tif'],'tiff');
imwrite(imgcat51,['C:\Documents and Settings\cgilleland\Desktop\CAMI_ImageProcessing\stitchedcat51.tif'],'tiff');
%}

%{
%good code
  eval(['imgstitched = imgcatcolumn' Nstr ';']);
  imwrite(imgstitched,['C:\Documents and Settings\cgilleland\Desktop\CAMI_ImageProcessing\stitched.tif'],'tiff');
 %}  
   
   %imgcat2 = imread('C:\Documents and Settings\cgilleland\Desktop\CAMI_ImageProcessing\glass_image2021222324cat.tif', 'tiff');
%figure,
%imshow(imgcat2)
%end

imwrite(img_AVT,[imageDIRECTORYNAME, '\worm_imageAVT_', dt '.tif'],'tiff');
disp(['Image Saved: worm_imageAVT_' dt])







% --- Executes on button press in ImageWormDetection_pushbutton.
function ImageWormDetection_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to ImageWormDetection_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in AutoFocus_pushbutton.
function AutoFocus_pushbutton_Callback(hObject, eventdata, handles)
global stg
global src
global NikonTiScope
global AVT_Vid
global AVT_Vid_params
global vid_objects
global imageDIRECTORYNAME
global previewHandles
global previewHandlesImage
global CenterMarkHandlesImage
global h
global ch
global HIMAGE
global VideoAxesCAMI
global CAMIvideoAVT
Autofocus

%We use the perfect focus unit for almost instantaneous autofocusing and
%will keep the below code for reference. This code below acquired a fast
%video as the objective traveled a certain duration then processed to see
%where the image was in-focus and a mathematical model for the movement of
%the Z travel with the images acquired to determine location of best
%in-focus Z height.

% Older version of Autofocus
% 
% global dish_num
% global worm
% global worm_count
% global worm_num
% dish_num = 1;
% worm_count = 10;
% worm_num = 1;
% autofocus = struct('iter',0);
% worm = repmat(struct('autofocus',autofocus,'imageData',[],'params',[]),worm_count,1);
% 
% % hObject    handle to AutoFocus_pushbutton (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% af_data_dir = 'D:\Adam\CAMI_Data\autofocus';
% 
% src_before = src;
% [current_vidobj,current_vidobj_params] = switch_vidobj(AVT_Vid,vid_objects{3,1},vid_objects{3,2});  % ,vid_objects{4,3}
% src_switch1 = getselectedsource(current_vidobj);
% AF_testRun(current_vidobj,current_vidobj_params,af_data_dir);
% [current_vidobj,current_vidobj_params] = switch_vidobj(current_vidobj,AVT_Vid,AVT_Vid_params);  % ,CenterMarkHandlesImage
% src_switch2 = getselectedsource(current_vidobj);
% AVT_Vid = current_vidobj;
% src_end = getselectedsource(AVT_Vid);
% % preview(current_vidobj,previewHandles)
% dumbo = zeros(5,1);
% dumbo(1,1) = isequal(src, src_before);
% dumbo(2,1) = isequal(src, src_switch1);
% dumbo(3,1) = isequal(src, src_switch2);
% dumbo(4,1) = isequal(src, src_end);
% dumbo(5,1) = isequal(src_before, src_end);
% dumbo
% pause(.5)
% 
% 
% 
% % h = CAMIvideoAVT
% % ch = get(h,'children')
% % previewHandles = findobj(ch,'tag','VideoAxesCAMI')
% % previewHandlesImage = image(zeros(1200),'parent',previewHandles)
% % set(previewHandlesImage,'cdata',ones(1200))
% % set(h,'WindowScrollWheelFcn',@ScrollWheelZ)
% % get(h,'WindowScrollWheelFcn')
% % set(h,'WindowButtonDownFcn',@MouseWindowClick)
% % CenterMarkHandlesImage = previewHandlesImage;
% % wormLoc = [];
% % toggle = true;
% % wormIndex = 0;
% % preview(AVT_Vid, CenterMarkHandlesImage);
% % HIMAGE = preview(AVT_Vid, CenterMarkHandlesImage);
% % setappdata(HIMAGE, 'UpdatePreviewWindowFcn', @displayCenterMark);




% --- Executes on button press in pushbutton41.
function pushbutton41_Callback(hObject, eventdata, handles)
global stg
% hObject    handle to pushbutton41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in PreviousWorm_pushbutton.
function PreviousWorm_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to PreviousWorm_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global wormLoc
global wormIndex
global stg
global NeedleEngagedFlag
global NeedleDiagEngagedFlag 
global digital_zoom
global wormData
global gonadNum     % NEED TO INITIALIZE GONAD#
global Gonad1_Loc
global Gonad2_Loc
         

          
digital_zoom=0; % turn off digital zoom to get full view of worm

clear_stage_buffer();
fprintf(stg,'O,100'); %XY joystick max speed conversion
fscanf(stg);
fprintf(stg,'SAS,100'); % XY acceleration
fscanf(stg);
fprintf(stg,'SMS,200'); %XY max speed
fscanf(stg);
fprintf(stg,'SCS,100'); %XY S-curve, rate of change of acceleration
fscanf(stg);
fprintf(stg,'BLSH, 0')%XY Backlash, 0=off, 1=n
backlash = fscanf(stg);

if NeedleEngagedFlag == 1 | NeedleDiagEngagedFlag==1
    ManipulatorHoverNeedle_pushbutton_Callback(hObject, eventdata, handles)
    pause(0.5)
end


move = false;
if wormIndex > 1 && gonadNum==1
    wormIndex = wormIndex - 1;
    gonadNum = 2;
    move = true;
elseif wormIndex >=1 && gonadNum==2
    gonadNum = 1;
    move = true;
end

if move
    if gonadNum==1
        moveTo = Gonad1_Loc(wormIndex,:);
    elseif gonadNum==2
        moveTo = Gonad2_Loc(wormIndex,:);
    end
    disp(['Moving.'])
    disp(['Move to: ']);
    moveTo
   
    fprintf(stg,[ 'G,' num2str(moveTo(1)) ', ' num2str(moveTo(2)) ',0']);
    responseR = fscanf(stg);
    set(handles.currentWorm, 'String', num2str(wormIndex));
    
    CenterClick_pushbutton_Callback(hObject, eventdata, handles)
    CenterClick_pushbutton_Callback(hObject, eventdata, handles)
end
      
disp('Previous complete.');

function WormNumber_editText_Callback(hObject, eventdata, handles)
% hObject    handle to WormNumber_editText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of WormNumber_editText as text
%        str2double(get(hObject,'String')) returns contents of WormNumber_editText as a double


% --- Executes during object creation, after setting all properties.
function WormNumber_editText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WormNumber_editText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in NextWorm_pushbutton.
function NextWorm_pushbutton_Callback(hObject, eventdata, handles)

global wormLoc
global wormIndex
global stg
global stitched_image
global wormMapHandle
global currentWormHandle
global wormBoundingBox
global NeedleEngagedFlag
global NeedleDiagEngagedFlag 
global NikonTiScope
global CAMImode
global handle
global digital_zoom
global wormData
global gonadNum     % NEED TO INITIALIZE GONAD#
global Gonad1_Loc
global Gonad2_Loc



CAMImode = 3; %nextworm mode
digital_zoom=0; %turn off digital zoom to get full view of worm
%  To allow maximum travel
% SetHoverNeedlePosition = (manipControl('getPosition',0,1));
% CurrentPositionX = SetHoverNeedlePosition(1);
% CurrentPositionY = SetHoverNeedlePosition(2);
% CurrentPositionZ = SetHoverNeedlePosition(3);
% manipControl('changePosition',0,1,CurrentPositionX,CurrentPositionY,0);
% pause(2);
% %pause(1);

clear_stage_buffer();
fprintf(stg,'O,100');      %XY joystick max speed conversion
fscanf(stg);
fprintf(stg,'SAS,100');  % XY acceleration
fscanf(stg);
fprintf(stg,'SMS,200'); %XY max speed
fscanf(stg);
fprintf(stg,'SCS,100');  %XY S-curve, rate of change of acceleration
fscanf(stg);
fprintf(stg,'BLSH, 0');%XY Backlash, 0=off, 1=n
backlash = fscanf(stg);

% Create worm image
if isempty(wormMapHandle)
    %wormMapHandle = figure, imshow(stitched_image);
end
 

if NeedleEngagedFlag==1 | NeedleDiagEngagedFlag == 1
ManipulatorHoverNeedle_pushbutton_Callback();    

pause(0.5)
end

move = false;
wormIndex
wormLoc
length(wormLoc)
gonadNum

if wormIndex < length(wormLoc) && gonadNum==2
    wormIndex = wormIndex + 1;
    gonadNum = 1;
    move = true;
elseif wormIndex <= length(wormLoc) && gonadNum==1
    gonadNum = 2;
    move = true;
end

if move
    if gonadNum==1
        moveTo = Gonad1_Loc(wormIndex,:);
    elseif gonadNum==2
        moveTo = Gonad2_Loc(wormIndex,:);
    end
    disp(['Moving.'])
    disp(['Move to: ']);
    moveTo
       
    fprintf(stg,[ 'G,' num2str(moveTo(1)) ', ' num2str(moveTo(2)) ',0']);
    responseR = fscanf(stg);
    set(handles.currentWorm, 'String', num2str(wormIndex)); 
    CenterClick_pushbutton_Callback(hObject, eventdata, handles);
end
            
           

disp('Next complete.')

% --- Executes on button press in ManipulatorEnableStationMove_pushbutton.
function ManipulatorEnableStationMove_pushbutton_Callback(hObject, eventdata, handles)
global ManipulatorEnableStationMoveVariable
% hObject    handle to ManipulatorSet_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ManipulatorEnableStationMoveVariable = 1;
pause(3)
ManipulatorEnableStationMoveVariable = 0;


% --- Executes on button press in PlasmidDispense_pushbutton.
function PlasmidDispense_pushbutton_Callback(hObject, eventdata, handles)
%Pushbutton dispenses plasmid from the needle tip for the duration set in
%the input field of the GUI typically 100ms @ 60psi

%The 32bit version of Matlab supports digital outputs but the x64bit
%version does not so we had to make a work-around. We used the x64 version
%to write a variable to a *.mat file that is constantly parsed by the x32
%bit version with a 10ms delay to allow digital output operation. This code
%was developed before the wide adoption of raspberry pi and arduino that
%do this operation well. 
global PlasmidDispensetime
global stg

Read_matfile = 1;
PlasmidDispenseTimeX32 = PlasmidDispensetime %Here we input plasmid dispense time from text field on gui
PlasmidVibrateTimeX32 = 0;
PlasmidPulseTimeX32 = 0;

%we assign all other inputs to zero exept for the 

E = 0;
F = 0;
G = 0;
H = 0;
save('C:\Users\CodyGilleland\Desktop\CAMIcode_3_07_2012\PlasmidControllerX32DataTransfer.mat','Read_matfile','PlasmidDispenseTimeX32','PlasmidVibrateTimeX32','PlasmidPulseTimeX32','E','F','G','H');
disp('saved PlasmidControllerX32DataTransfer.mat');
%pause(0.1)
Read_matfile = 0;
PlasmidDispenseTimeX32 = 0;
PlasmidVibrateTimeX32 = 0;
PlasmidPulseTimeX32 = 0;
E = 0;
F = 0;
G = 0;
H = 0;



%pause(0.05)
%load('abcdef.mat','A','B','C','D','E','F');
%old code to control 
% disp('Plasmid Dispense Begin')
% if (~isempty(daqfind))
%     stop(daqfind)
% end
% dio = digitalio('nidaq', 'Dev1');
% addline(dio, 0:7, 0, 'Out');
% tic
% putvalue(dio, [0 1 0 0 0 0 0 0]);
% pause(PlasmidDispensetime)
% value1 = getvalue(dio);
% putvalue(dio, [0 0 0 0 0 0 0 0]);
% value2 = getvalue(dio);
% toc;
% delete (dio);
% clear dio;
% disp('Plasmid Dispense End')
% dio = digitalio('nidaq', 'Dev1');
% addline(dio, 0:7, 0, 'Out');

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




% --- Executes on button press in PlasmidUptake_pushbutton.
function PlasmidUptake_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to PlasmidUptake_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




function PlasmidUptake_editText_Callback(hObject, eventdata, handles)
% hObject    handle to PlasmidUptake_editText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PlasmidUptake_editText as text
%        str2double(get(hObject,'String')) returns contents of PlasmidUptake_editText as a double
global PlasmidUptaketime
input = str2num(get(hObject,'String'));

%checks to see if input is empty. if so, default input1_editText to zero
if (isempty(input))
     set(hObject,'String','0')
end
PlasmidUptaketimeinput = get(handles.PlasmidUptake_editText,'String');
% a and b are variables of Strings type, and need to be converted
% to variables of Number type before they can be added together
PlasmidUptaketime = str2num(PlasmidUptaketimeinput)/1000;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function PlasmidUptake_editText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PlasmidUptake_editText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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
%Pushbutton vibrates the needle tip for the duration set in
%the input field of the GUI typically 50ms 

%The 32bit version of Matlab supports digital outputs but the x64bit
%version does not so we had to make a work-around. We used the x64 version
%to write a variable to a *.mat file that is constantly parsed by the x32
%bit version with a 10ms delay to allow digital output operation. This code
%was developed before the wide adoption of raspberry pi and arduino that
%do this operation well. 
global PlasmidVibratetime
global PlasmidDispensetime
global stg

disp('Plasmid Vibrate');
Read_matfile = 1;
PlasmidDispenseTimeX32 = 0;
PlasmidVibrateTimeX32 = PlasmidVibratetime;
PlasmidPulseTimeX32 = 0; %default setting 
%disp('Plasmid Vibrate')

E = 0;
F = 0;
G = 0;
H = 0;
save('C:\Users\CodyGilleland\Desktop\CAMIcode_3_07_2012\PlasmidControllerX32DataTransfer.mat','Read_matfile','PlasmidDispenseTimeX32','PlasmidVibrateTimeX32','PlasmidPulseTimeX32','E','F','G','H');
disp('saved PlasmidControllerX32DataTransfer.mat');
%pause(0.1)
Read_matfile = 0;
PlasmidDispenseTimeX32 = 0;
PlasmidVibrateTimeX32 = 0;
PlasmidPulseTimeX32 = 0;
E = 0;
F = 0;
G = 0;
H =0;


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


% --- Executes on button press in pushbutton49.
function pushbutton49_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton49 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton50.
function pushbutton50_Callback(hObject, eventdata, handles)
global stg
% hObject    handle to pushbutton50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton51.
function pushbutton51_Callback(hObject, eventdata, handles)
global NikonTiScope
% hObject    handle to pushbutton51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%set(NikonTiScope)
NikonTiScope.CondenserCassette.Position = 3
pause(0.1);

%NikonTiScope function calls 
%{
 ComPort: {}
                Database: {}
                  ZDrive: {}
               Nosepiece: {}
       CondenserCassette: {}
             OpticalPath: {}
     FilterBlockCassette: {}
         ExcitationWheel: {}
            BarrierWheel: {}
          AuxFilterWheel: {}
                Analyzer: {}
                    Lamp: {}
              EpiShutter: {}
         UniblitzShutter: {}
          ExternalDevice: {}
              ControlPad: {}
                     Hub: {}
                ComPort2: {}
               Database2: {}
    FilterBlockCassette2: {}
                   Lamp2: {}
              Nosepiece2: {}
                 ZDrive2: {}
%}


% --- Executes on button press in Objective10XHoffman_pushbutton.
function Objective10XHoffman_pushbutton_Callback(hObject, eventdata, handles)
%Loads 10x Hoffman objective
global NikonTiScope
global stg
global AVT_Vid
global src
global AVT_Vid

% hObject    handle to Objective20XFluor_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic
currentObjective = NikonTiScope.Nosepiece.Position.RawValue;
pause(0.1);
NikonTiScope.CondenserCassette.Position = 3;
pause(0.1);
NikonTiScope.Nosepiece.Position = 3;
pause(0.1);
currentPos = NikonTiScope.ZDrive.Value.RawValue;
pause(0.1);

src.Shutter = 1500; %Shutter 1 -> 4095 range
AVT_Vid.ROIPosition = [473 270 1200 1200];

switch currentObjective
    case 1
        NikonTiScope.ZDrive.MoveRelative(152*40);
        pause(0.1);
 
    case 2
        NikonTiScope.ZDrive.MoveRelative(60*40);
        pause(0.1);
       
    case 3
            disp('10X Objective already selected')    
    case 6
         NikonTiScope.ZDrive.MoveRelative(80*40);
         pause(0.1);

    case 5
        NikonTiScope.ZDrive.MoveAbsolute(currentPos + 73*40 + 445*40);
        pause(0.1);
           
            disp('No objective is selected')
    case 4
            disp('No objective is selected')
    otherwise
            disp('There is an error loading the 10X objective')
end


% --- Executes on button press in Objective20XHoffman_pushbutton.
function Objective20XHoffman_pushbutton_Callback(hObject, eventdata, handles)
%loads 20X hoffman objective
global NikonTiScope
global stg
global AVT_Vid
global src
global AVT_Vid

tic
currentObjective = NikonTiScope.Nosepiece.Position.RawValue;
pause(0.1);
NikonTiScope.CondenserCassette.Position = 2;
pause(0.2);
NikonTiScope.Nosepiece.Position = 6;
pause(0.1);
currentPos = NikonTiScope.ZDrive.Value.RawValue;
pause(0.1);

src.Shutter = 1700; %Shutter 1 -> 4095 range
AVT_Vid.ROIPosition = [568 276 1200 1200];

switch currentObjective
    case 1
            NikonTiScope.ZDrive.MoveRelative(95*40);
            pause(0.1);
    case 2
            NikonTiScope.ZDrive.MoveRelative(15*40);       
            pause(0.1);
    case 3
            NikonTiScope.ZDrive.MoveRelative(-80*40);   
            pause(0.1);
    case 6
            disp('20X Objective already selected')    
    case 5     
            disp('No objective is selected')
    case 4
            disp('No objective is selected')  
    otherwise
            disp('There is an error loading the 20X objective')
end
disp(toc)


% --- Executes on button press in RotationClockwise_pushbutton.
function RotationClockwise_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to RotationClockwise_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in RotationCounterClockwise_pushbutton.
function RotationCounterClockwise_pushbutton_Callback(hObject, eventdata, handles)
global RotationDegreesValue
global stg
global RotationAccumulation
global NeedleEngagedFlag


if (NeedleEngagedFlag == 1)
    ManipulatorHoverNeedle_pushbutton_Callback(hObject, eventdata, handles);
    pause(1);
end

RotationAccumulation = RotationAccumulation + (360-RotationDegreesValue)
RotationDegreesValueStr = num2str(round(360-RotationDegreesValue));
RotationDegreesValueConvertStr = num2str(round((360-RotationDegreesValue)*520.95));


%{
fprintf(stg,'SMA,100'); % Max speed
fscanf(stg)
fprintf(stg,'SAA,100'); % Max acceleration
fscanf(stg)
fprintf(stg,'SSA,1'); % index
fscanf(stg)

%}
clear_stage_buffer();
fprintf(stg,['CW,',RotationDegreesValueConvertStr]); % Rotate Clockwise
fscanf(stg)



disp(['Clockwise Rotation by ', RotationDegreesValueStr ,' degrees'])




function RotationDegrees_editText_Callback(hObject, eventdata, handles)
% hObject    handle to RotationDegrees_editText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RotationDegrees_editText as text
%        str2double(get(hObject,'String')) returns contents of RotationDegrees_editText as a double
global RotationDegreesValue
input = str2num(get(hObject,'String'));

%checks to see if input is empty. if so, default input1_editText to zero
if (isempty(input))
     set(hObject,'String','0')
end
RotationDegreesInput = get(handles.RotationDegrees_editText,'String');
% a and b are variables of Strings type, and need to be converted
% to variables of Number type before they can be added together
RotationDegreesValue = str2num(RotationDegreesInput);
guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function RotationDegrees_editText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RotationDegrees_editText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RotationToggleJoystick_pushbutton.
function RotationToggleJoystick_pushbutton_Callback(hObject, eventdata, handles)
global stg
% hObject    handle to pushbutton50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clear_stage_buffer();
fprintf(stg,'TYA');
fscanf(stg);
disp('Toggle Joystick Rotation Control')

% --- Executes on button press in RotationZeroPosition_pushbutton.
function RotationZeroPosition_pushbutton_Callback(hObject, eventdata, handles)
% 





    

% --- Executes on button press in RotationPosition1_pushbutton.
function RotationPosition1_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to RotationPosition1_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ManipulatorSetVariable
global SetHoverNeedlePosition
% hObject    handle to ManipulatorEngageNeedle_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 if (ManipulatorSetVariable == 1)
    SetHoverNeedlePosition = (manipControl('getPosition',0,1))
    pause(0.5)
 else
 SetHoverNeedlePositionX = SetHoverNeedlePosition(1);
 SetHoverNeedlePositionY = SetHoverNeedlePosition(2);
 SetHoverNeedlePositionZ = SetHoverNeedlePosition(3);
 manipControl('changePosition',0,1,SetHoverNeedlePositionX,SetHoverNeedlePositionY,SetHoverNeedlePositionZ)
 pause(0.5)
 end





% --- Executes on button press in RotationSet_pushbutton.
function RotationSet_pushbutton_Callback(hObject, eventdata, handles)

% --- Executes on button press in RotationPosition2_pushbutton.
function RotationPosition2_pushbutton_Callback(hObject, eventdata, handles)



% --- Executes on button press in RotationPosition3_pushbutton.
function RotationPosition3_pushbutton_Callback(hObject, eventdata, handles)


% Figuring out how to use angle and magnitude to get somewhere
function moveTo
global NikonTiScope
global stg
global AVT_Vid
global h
global ClickScreenX 
global ClickScreenY 


CenterRotationX = 61018;
CenterRotationY = 38965;

clear_stage_buffer();
fprintf(stg,['G,', num2str(CenterRotationX), ', ' , num2str(CenterRotationY) , ' ']);
fscanf(stg);

ClickScreenCoordinates();

%%%%%%%%%%%%-------------------------------
InitialWormLocationX = ClickScreenX%CurrentPositionX + movex1
InitialWormLocationY = ClickScreenY%CurrentPositionY + movey1

%convert to polar coordinates
RotationApproachXDelta = CenterRotationX - InitialWormLocationX;
RotationApproachYDelta = InitialWormLocationY - CenterRotationY;

% Find angle from coordinate
Magnitude = sqrt(RotationApproachXDelta^2 + RotationApproachYDelta^2);
Theta = acos(dot([RotationApproachXDelta RotationApproachYDelta], [1 0])/ ...
    Magnitude);

if RotationApproachYDelta < 0,
    Theta = -Theta;
end
ThetaFinalDegrees = Theta*(180/pi);

% Deconstruct to coordinates
RelativePositionX = Magnitude*cos(Theta);
RelativePositionY = Magnitude*sin(Theta);

if ThetaFinalDegrees >= 90 && ThetaFinalDegrees <= 180
    disp('2nd Quadrant');
    ProjectedX =  abs(RelativePositionX) + CenterRotationX
    ProjectedY =  abs(RelativePositionY) + CenterRotationY
elseif ThetaFinalDegrees >= 0 && ThetaFinalDegrees < 90
    disp('1st Quadrant');
    ProjectedX =  -abs(RelativePositionX) + CenterRotationX
    ProjectedY =  abs(RelativePositionY) + CenterRotationY
elseif ThetaFinalDegrees >= -90 && ThetaFinalDegrees < 0
    disp('3rd Quadrant');
    ProjectedX =  -abs(RelativePositionX) + CenterRotationX
    ProjectedY =  -abs(RelativePositionY) + CenterRotationY
elseif ThetaFinalDegrees >= -180 && ThetaFinalDegrees < -90
    disp('4th Quadrant');
    ProjectedX =  abs(RelativePositionX) + CenterRotationX
    ProjectedY =  -abs(RelativePositionY) + CenterRotationY
else
    disp('Error: Cannot X,Y from rotation');
    ProjectedX = CenterRotationX;
    ProjectedY = CenterRotationY;
end   
['G,', num2str(round(ProjectedX)), ', ' , num2str(round(ProjectedY)) , ' ']
clear_stage_buffer();
fprintf(stg,['G,', num2str(round(ProjectedX)), ', ' , num2str(round(ProjectedY)) , ' ']);
fscanf(stg);


function red = calculate_rotate_position(x_worm, y_worm, x_approach, y_approach)
global NikonTiScope
global stg
global AVT_Vid
global h
global ClickScreenX 
global ClickScreenY 
global CenterRotationX
global CenterRotationY

clc
%ClickScreenCoordinates();
DesiredPositionX = x_worm;%CurrentPositionX + movex1;
DesiredPositionY = y_worm;%CurrentPositionY + movey1;

%ClickScreenCoordinates();
ApproachPositionX = x_approach;%CurrentPositionX + movex;
ApproachPositionY = y_approach;%CurrentPositionY + movey;

%Normalize about respective origin
DesiredPositionX = CenterRotationX - DesiredPositionX;
DesiredPositionY = DesiredPositionY - CenterRotationY;
ApproachPositionX = CenterRotationX - ApproachPositionX;
ApproachPositionY = ApproachPositionY - CenterRotationY; 
DesiredPositionMagnitude = sqrt(DesiredPositionX^2 + DesiredPositionY^2);

% Find angles
alpha = dot([DesiredPositionX DesiredPositionY], [1 0])/DesiredPositionMagnitude;
alpha = acos(alpha);
if DesiredPositionY < 0
    alpha = -alpha;
end

% Find delta by which we rotate by
delta = dot([ApproachPositionX - DesiredPositionX, ApproachPositionY - DesiredPositionY], [1 0]);
delta = acos(delta/sqrt(...
    (ApproachPositionX - DesiredPositionX)^2 + (ApproachPositionY - DesiredPositionY)^2));
deltaDegrees = delta*(180/pi);

% Rotate
if ApproachPositionY - DesiredPositionY > 0
    ThetaFinal = alpha - delta;
%     thetaStr = num2str(round(439.0040*deltaDegrees));
%     fprintf(stg,['CW,',thetaStr]); % Rotate Clockwise
%     fscanf(stg);
else
    ThetaFinal = alpha + delta;
%     thetaStr = num2str(round(-439.0040*deltaDegrees));
%     fprintf(stg,['CW,',thetaStr]);
%     fscanf(stg);
end

ThetaFinalDegrees = ThetaFinal * (180/pi);
if ThetaFinalDegrees > 180
    ThetaFinalDegrees = ThetaFinalDegrees - 360;
elseif ThetaFinalDegrees < -180
    ThetaFinalDegrees = ThetaFinalDegrees + 360;
end

% Translate
RelativePositionX = DesiredPositionMagnitude*cos(ThetaFinal);
RelativePositionY = DesiredPositionMagnitude*sin(ThetaFinal);

if ThetaFinalDegrees >= 90 && ThetaFinalDegrees <= 180
    NewPositionX =  abs(RelativePositionX) + CenterRotationX;
    NewPositionY =  abs(RelativePositionY) + CenterRotationY;
elseif ThetaFinalDegrees >= 0 && ThetaFinalDegrees < 90
    NewPositionX =  -abs(RelativePositionX) + CenterRotationX;
    NewPositionY =  abs(RelativePositionY) + CenterRotationY;
elseif ThetaFinalDegrees >= -90 && ThetaFinalDegrees < 0
    NewPositionX =  -abs(RelativePositionX) + CenterRotationX;
    NewPositionY =  -abs(RelativePositionY) + CenterRotationY;
elseif ThetaFinalDegrees >= -180 && ThetaFinalDegrees < -90
    NewPositionX =  abs(RelativePositionX) + CenterRotationX;
    NewPositionY =  -abs(RelativePositionY) + CenterRotationY;
else
    %NewPositionX = CenterRotationX;
    %NewPositionY = CenterRotationY;
end   

% Check if new position is in our bounds
if ((NewPositionX < 76331) && (NewPositionX > 57897)) && ...
        ((NewPositionY < 49844) && (NewPositionY > 29547))
    red = 0;
else
    red = 1;
end

function RotateAndTranslate(hObject, eventdata, handles);

  
% Test helper function
function MoveToCoord(x,y)
global stg
    
FinalPositionXStr = num2str(round(x));
FinalPositionYStr = num2str(round(y));
clear_stage_buffer();
fprintf(stg,['G, ' FinalPositionXStr ', ' FinalPositionYStr ',0']);
fscanf(stg)
disp('Move to Coordinate: Done')

% --- Executes on button press in RotationTest1_pushbutton.
function RotationTest1_pushbutton_Callback(hObject, eventdata, handles)
global AVT_Vid
global stg
global stitched_image
global ulcoord
global ratio_stg2X
global wellnumber

ratio_stg2X = 1.89154;

% Have an assertion to test if montage is built
clear_stage_buffer();
pause(0.25);
Objective2X_pushbutton_Callback(hObject, eventdata, handles);
pause(0.1);

fprintf(stg,'SAS,100'); % XY acceleration
fscanf(stg);
fprintf(stg,'SMS,195'); 
stagespeed195R = fscanf(stg);
fprintf(stg,'SCS,100'); %XY S-curve, rate of change of acceleration
fscanf(stg);

% Get image, it has to be high detail 
triggerconfig(AVT_Vid, 'manual');
%AVT_Vid.ROIPosition = [0 0 2336 1752];
set(AVT_Vid,  'FramesPerTrigger', 1);
start(AVT_Vid);
trigger(AVT_Vid);
screen = getdata(AVT_Vid);

ScreenSizeX_stage_coord = 4398;
%ScreenSizeX_stage_coord = 1752*ratio_stg2X;

ScreenSizeY_stage_coord = 4398*(1752/2336);
stitch_pause = 1;



switch wellnumber
    case 1 
        Well1_UpperLeftX_stage_coord = 112279;
        Well1_UpperLeftY_stage_coord = 62924;
    case 2
        Well1_UpperLeftX_stage_coord = 73561;
        Well1_UpperLeftY_stage_coord = 62924;
    case 3
        Well1_UpperLeftX_stage_coord = 34490;
        Well1_UpperLeftY_stage_coord = 62924;
    case 4
        Well1_UpperLeftX_stage_coord = 112279;
        Well1_UpperLeftY_stage_coord = 23400;
    case 5
        Well1_UpperLeftX_stage_coord = 73561;
        Well1_UpperLeftY_stage_coord = 23400;
    case 6
        Well1_UpperLeftX_stage_coord = 34490;
        Well1_UpperLeftY_stage_coord = 23400;
    otherwise
        disp('This is not a valid well selection');    
end


 filename1 = 'C:\Users\CodyGilleland\Desktop\CAMIcode_3_07_2012\condensorB.tif';

 condensor_img = imread(filename1);
 

 white_image = ones(length(condensor_img(:, 1)), length(condensor_img(1, :)));
 white_image(:, :) = 255; %works
 condensor_img_avg = mean(mean(double(condensor_img))); 
 image_correction = (condensor_img_avg - double(condensor_img));

 norm_img = ((double(white_image) - double(condensor_img)) ./ double(white_image)); 

 norm_img_uint8 = uint8(norm_img); 



%First Row: Left to Right

fprintf(stg,[ 'G,' num2str(Well1_UpperLeftX_stage_coord) ',' num2str(Well1_UpperLeftY_stage_coord) ',0']);
fscanf(stg);
pause(8)
start(AVT_Vid);
trigger(AVT_Vid);
screen1_1 = getdata(AVT_Vid);
%figure, imshow(screen1_1)
% row_img = [double(screen1_1(:, :, 1)).*norm_img];
%change ./ to +
screen1_1normalized = double(screen1_1) - double(condensor_img) + mean(mean(double(condensor_img)));
%figure, imshow(uint8(screen1_1diff));


fprintf(stg,[ 'G,' num2str(Well1_UpperLeftX_stage_coord-ScreenSizeX_stage_coord ) ',' num2str(Well1_UpperLeftY_stage_coord) ',0']);
fscanf(stg);
pause(stitch_pause)
start(AVT_Vid);
trigger(AVT_Vid);
screen1_2 = getdata(AVT_Vid);
screen1_2normalized = double(screen1_2) - double(condensor_img) + mean(mean(double(condensor_img)));



fprintf(stg,[ 'G,' num2str(Well1_UpperLeftX_stage_coord-(2*ScreenSizeX_stage_coord) ) ',' num2str(Well1_UpperLeftY_stage_coord) ',0']);
fscanf(stg);
pause(stitch_pause)
start(AVT_Vid);
trigger(AVT_Vid);
screen1_3 = getdata(AVT_Vid);
screen1_3normalized = double(screen1_3) - double(condensor_img) + mean(mean(double(condensor_img)));

% Second Row: Right to Left

fprintf(stg,[ 'G,' num2str(Well1_UpperLeftX_stage_coord-(2*ScreenSizeX_stage_coord) ) ',' num2str(Well1_UpperLeftY_stage_coord-ScreenSizeY_stage_coord) ',0']);
fscanf(stg);
pause(stitch_pause)
start(AVT_Vid);
trigger(AVT_Vid);
screen2_3 = getdata(AVT_Vid);
screen2_3normalized = double(screen2_3) - double(condensor_img) + mean(mean(double(condensor_img)));

fprintf(stg,[ 'G,' num2str(Well1_UpperLeftX_stage_coord-(1*ScreenSizeX_stage_coord) ) ',' num2str(Well1_UpperLeftY_stage_coord-ScreenSizeY_stage_coord) ',0']);
fscanf(stg);
pause(stitch_pause)
start(AVT_Vid);
trigger(AVT_Vid);
screen2_2 = getdata(AVT_Vid);
screen2_2normalized = double(screen2_2) - double(condensor_img) + mean(mean(double(condensor_img)));


fprintf(stg,[ 'G,' num2str(Well1_UpperLeftX_stage_coord-(0*ScreenSizeX_stage_coord) ) ',' num2str(Well1_UpperLeftY_stage_coord-ScreenSizeY_stage_coord) ',0']);
fscanf(stg);
pause(stitch_pause)
start(AVT_Vid);
trigger(AVT_Vid);
screen2_1 = getdata(AVT_Vid);
screen2_1normalized= double(screen2_1) - double(condensor_img) + mean(mean(double(condensor_img)));

%Third Row: Left to Right
fprintf(stg,[ 'G,' num2str(Well1_UpperLeftX_stage_coord) ',' num2str(Well1_UpperLeftY_stage_coord-(2*ScreenSizeY_stage_coord)) ',0']);
fscanf(stg);
pause(stitch_pause)
start(AVT_Vid);
trigger(AVT_Vid);
screen3_1 = getdata(AVT_Vid);
screen3_1normalized = double(screen3_1) - double(condensor_img) + mean(mean(double(condensor_img)));

fprintf(stg,[ 'G,' num2str(Well1_UpperLeftX_stage_coord-ScreenSizeX_stage_coord ) ',' num2str(Well1_UpperLeftY_stage_coord-(2*ScreenSizeY_stage_coord)) ',0']);
fscanf(stg);
pause(stitch_pause)
start(AVT_Vid);
trigger(AVT_Vid);
screen3_2 = getdata(AVT_Vid);
screen3_2normalized = double(screen3_2) - double(condensor_img) + mean(mean(double(condensor_img)));


fprintf(stg,[ 'G,' num2str(Well1_UpperLeftX_stage_coord-(2*ScreenSizeX_stage_coord) ) ',' num2str(Well1_UpperLeftY_stage_coord-(2*ScreenSizeY_stage_coord)) ',0']);
fscanf(stg);
pause(stitch_pause)
start(AVT_Vid);
trigger(AVT_Vid);
screen3_3 = getdata(AVT_Vid);
screen3_3normalized = double(screen3_3) - double(condensor_img) + mean(mean(double(condensor_img)));
% FourthRow: Right to Left

fprintf(stg,[ 'G,' num2str(Well1_UpperLeftX_stage_coord-(2*ScreenSizeX_stage_coord) ) ',' num2str(Well1_UpperLeftY_stage_coord-(3*ScreenSizeY_stage_coord)) ',0']);
fscanf(stg);
pause(stitch_pause)
start(AVT_Vid);
trigger(AVT_Vid);
screen4_3 = getdata(AVT_Vid);
screen4_3normalized = double(screen4_3) - double(condensor_img) + mean(mean(double(condensor_img)));

fprintf(stg,[ 'G,' num2str(Well1_UpperLeftX_stage_coord-(1*ScreenSizeX_stage_coord) ) ',' num2str(Well1_UpperLeftY_stage_coord-(3*ScreenSizeY_stage_coord)) ',0']);
fscanf(stg);
pause(stitch_pause)
start(AVT_Vid);
trigger(AVT_Vid);
screen4_2 = getdata(AVT_Vid);
screen4_2normalized= double(screen4_2) - double(condensor_img) + mean(mean(double(condensor_img)));

fprintf(stg,[ 'G,' num2str(Well1_UpperLeftX_stage_coord-(0*ScreenSizeX_stage_coord) ) ',' num2str(Well1_UpperLeftY_stage_coord-(3*ScreenSizeY_stage_coord)) ',0']);
fscanf(stg);
pause(stitch_pause)
start(AVT_Vid);
trigger(AVT_Vid);
screen4_1 = getdata(AVT_Vid);
screen4_1normalized= double(screen4_1) - double(condensor_img) + mean(mean(double(condensor_img)));

stitched_image_trial = [screen1_1normalized screen1_2normalized screen1_3normalized ; screen2_1normalized screen2_2normalized screen2_3normalized ; screen3_1normalized screen3_2normalized screen3_3normalized ; screen4_1normalized screen4_2normalized screen4_3normalized];
grayImage = stitched_image_trial;
%figure, imshow(stitched_image_trial);
normalizedMontage = uint8(255*mat2gray(grayImage));
stitched_image = normalizedMontage;
figure, imshow(stitched_image);
stitched_image_trial_uint8 = uint8(stitched_image_trial);
wait_mat2grayy = 1;
%figure, imshow(stitched_image_trial_uint8);
%Set location for Montage Registration
fprintf(stg,[ 'G,' num2str(Well1_UpperLeftX_stage_coord-(2*ScreenSizeX_stage_coord)+1000 ) ',' num2str(Well1_UpperLeftY_stage_coord-(3*ScreenSizeY_stage_coord) +1000) ',0']);
fscanf(stg);
pause(2);
MontageRegistration_pushbutton_Callback(hObject, eventdata, handles);




%figure(screen)
disp('worked');


function score = normalized_variance(img)

% Convert image so that we can do computations to it
img = double(img)./255;

% Get the dimensions of the image
[l w h] = size(img);
meanIntensity = sum(sum(img))/(l*w);

% normalized_variance score
score = 0;

for i=1:l,
    for j=1:w
        score = score + (img(i, j)-meanIntensity)^2;
    end
end

score = (1/(l*w*meanIntensity))*score;

function Autofocus
global AVT_Vid
global NikonTiScope

% Get current objective
currentObjective = NikonTiScope.Nosepiece.Position.RawValue;

% flag to continue to focus
focusing = 1;

% Amount by which we move
switch currentObjective
    case 1
        delta = 1600;
        disp('2x')
    case 2
        delta = 3000;
    case 3
        delta = 3000/3;
    case 6
        delta = 3000/6;
end

% Initialization 
triggerconfig(AVT_Vid, 'manual');
direction_sign = 1;


% Get Current Focus Score and current height
start(AVT_Vid);
trigger(AVT_Vid);
img = getdata(AVT_Vid);
img = img(550:650, 550:650);
focus_scores = [normalized_variance(img)];
zheight = [NikonTiScope.ZDrive.Position.RawValue];
currentHeight = zheight(1);

while focusing == 1
    currentHeight = currentHeight + direction_sign*delta;
    NikonTiScope.ZDrive.Position = currentHeight;

    start(AVT_Vid);
    trigger(AVT_Vid);
    img = getdata(AVT_Vid);
    img = img(550:650, 550:650);
    
    focus_scores = [focus_scores normalized_variance(img)];
    zheight = [zheight NikonTiScope.ZDrive.Position.RawValue];

    if focus_scores(end) < focus_scores(end-1) && direction_sign == -1,
        NikonTiScope.ZDrive.Position = currentHeight + delta;
        focusing = 0;
    elseif focus_scores(end) < focus_scores(end-1),
        direction_sign = -direction_sign;
    end
end
disp('Done Autofocusing');


% --- Executes on button press in RotationTest2_pushbutton.
function RotationTest2_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to RotationTest2_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%test button for calibrating manipulator hardware position
global stitched_image
global AVT_Vid
global NikonTiScope
global src
global stg

pause(1)
manipControl('changePosition',0,2,12500*16, 12500*16,12500*16);
pause(1)
pause(0)
manipControl('changePosition',0,1,12500*16, 12500*16,12500*16);
pause(5)
pause(0)
manipControl('changePosition',0,2,12000*16, 12500*16,12500*16);
pause(1)
pause(0)
manipControl('changePosition',0,1,12000*16, 12500*16,12500*16);
pause(1)


% --- Executes on button press in RotationTest3_pushbutton.
function RotationTest3_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to RotationTest3_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ulcoord
global stitched_image
global wormLoc
global wormIndex
global wormBoundingBox
global scale
% Hardcoded values
ulcoord = [74439 49592];
urcoord = [46302 49592];
llcoord = [74439 27213];
lrcoord = [46302 27213];

% For now, we will load in the image of the worm
%stitched_image = imread('montage_imageAVT_October_12_2011_ 9_26_58_531_PM.tif');
scale = 0.5;
montage2 = stitched_image < 230;
%montage2 = montage2 < 150;

% Parameters for probability distribution
%{
mu = 4000;
sigma = 250;
cutoff = 2;
%}
mu = 8000;
sigma = 1000;
cutoff = 4;

% Parameters for mean intensity
mu2 = 150;
sigma2 = 10;
cutoff2 = 2;

% Format the coordinates
wormLoc = [];
wormIndex = 0;
centerx = 600;
centery= 600;

objects = regionprops(montage2,  stitched_image, {'Area', 'BoundingBox', 'Centroid', 'MeanIntensity'});
figure, imshow(stitched_image)

numWorms = 0;
hold on


for i=1:length(objects)
    if abs(mu - objects(i).Area) <= cutoff*sigma& ...
                abs(mu2 - objects(i).MeanIntensity) <= cutoff2*sigma2,
        x = objects(i).BoundingBox;
        rect = rectangle('Position', x, ...
                      'EdgeColor','g', 'LineWidth', 1); 
        if numWorms==0,
            wormBoundingBox = [x(1:4)];
        else
            wormBoundingBox = [wormBoundingBox; x(1:4)];
        end
        worm = imcrop(stitched_image, get(rect, 'Position'));
        [gonadx, gonady] = detectgonads(worm, x(1), x(2), 2)
        plot(gonadx, gonady, 'r*');
        % convert to stage coordinates
        if gonadx ~= 0 & gonady ~=0,
            movex = round((centerx-(gonadx/scale))/1200*4398/2);
            movey = round((centery-(gonady/scale))/1200*4398/2);
            wormLoc = [wormLoc ulcoord(1)+movex, ulcoord(2)+movey];
            numWorms = numWorms + 1;
        end
    end
end
hold off
set(handles.totalWorm, 'String', num2str(numWorms));
set(handles.currentWorm, 'String', num2str(wormIndex));

function [gonadx, gonady] = detectgonads(worm, cx, cy,  rule)
        gonadx = 0;
        gonady = 0;
        c_elegans = imadjust(worm);
        BWs = edge(c_elegans);

        % dilate the image
         se90 = strel('line', 3, 90);
         se0 = strel('line', 3, 0);
         BWsdil = imdilate(BWs, [se90, se0]);

        % fill in the gaps
        BWfinal = imfill(BWsdil, 'holes');

        % Below here we cancel out noise, defined as single points
        regions = regionprops(BWfinal, {'FilledArea', 'BoundingBox'});

        % We filter image to get online the silhouette of the worm
        areas = [regions.FilledArea];
        maxArea = max(areas);
        BWfinal = bwareaopen(BWfinal, maxArea-1);
        
        % We erode away the border
        dilObj = strel('octagon',3);
        BWfinal = imerode(BWfinal, dilObj);
        
        % We prune possible regions of the worm
        filtered_worm = ((double(BWfinal).*double(c_elegans)));
        mask = filtered_worm>1;
        mask = bwareaopen(mask, 100);
        objects = regionprops(mask,filtered_worm, {'Area', 'BoundingBox', 'Centroid', 'Perimeter', 'MeanIntensity'});
        
        if isempty(objects)
            return
        end

        % Possible gonad indices
        gonad_indices = [];
        
        if rule == 1,
            % We are using binary hypothesis, assuming that the
            % distribution is gaussian. Using MAP, our rule is if the mean
            % intensity is greater than 90, it is a gonad
            region_intensities = [objects.MeanIntensity];
            gonad_indices = find(region_intensities > 90);
        elseif rule == 2,
            % We are using a linear differentiator to distinguish gonad and
            % junk regions
            
            w = [-.0009 .0052 .0056]';
            j = [-.0005 .0034 .0096]';
            d = [[objects.Area]' [objects.Perimeter]' [objects.MeanIntensity]'];
            results = abs(1-d*j) > abs(1-d*w);
            possible_gonads = find(results);

            if numel(possible_gonads) > 1,
                scores = abs(1-d(possible_gonads, 1:end)*j);
                gonad_loc = find(scores == max(scores));
                gonad_indices = possible_gonads(gonad_loc);
            else
                gonad_indices = possible_gonads;
            end
             
        elseif rule == 3,
            data = open('worm_parameters.mat');
            X = [data.gonad_area' data.gonad_perimeter' data.gonad_intens'; ...
                data.junk_area' data.junk_perimeter' data.junk_intens'];
            Y = [[objects.Area]' [objects.Perimeter]' [objects.MeanIntensity]'];
            K = 3;
            neighbors = knnsearch(X, Y, 'K', K);
            
            gonad_indices = find(sum(neighbors <= length(data.gonad_area), 2) >= ceil(K/2));
        end
        
        if ~isempty(gonad_indices)
            centroid = objects(gonad_indices(1)).Centroid;
            gonadx = cx+centroid(1);
            gonady = cy+centroid(2);
        end
                
        


% --- Executes on button press in RotationApproach_pushbutton.
function RotationApproach_pushbutton_Callback(hObject, eventdata, handles)
RotateAndTranslate(hObject, eventdata, handles);
pause(0.1)

function detectWorms(currentX, currentY)
global AVT_Vid
global stg
global wormLoc
global wormStats
global junkStats

% Capure image of plane to do image processing
triggerconfig(AVT_Vid, 'manual');
start(AVT_Vid);
trigger(AVT_Vid);
img = getdata(AVT_Vid);
% Find the location of worms we want
if length(wormStats) ~= 0 && length(junkStats) ~= 0,
   worm_loc = worm_tracker_with_info(img, wormStats, junkStats);
else
   worm_loc = worm_tracker_3(img);
end
centerx = 600;
centery = 600;

for i=1:length(worm_loc)/2
    clickx = worm_loc(2*i - 1);
    clicky = worm_loc(2*i);
    movex = ((centerx - clickx)/1200)*4446;
    movey = ((centery - clicky)/1200)*4446;
    
    wormLoc = [wormLoc currentX+movex currentY+movey]
end

function detectWorms2(currentX, currentY, img)
global AVT_Vid
global stg
global wormLoc
global wormStats
global junkStats

if length(wormStats) ~= 0 && length(junkStats) ~= 0,
   worm_loc = worm_tracker_with_info(img, wormStats, junkStats);
else
   worm_loc = worm_tracker_3(img);
end
centerx = 600;
centery = 600;

for i=1:length(worm_loc)/2
    clickx = worm_loc(2*i - 1);
    clicky = worm_loc(2*i);

    movex = ((centerx - clickx)/1200)*4446;
    movey = ((centery - clicky)/1200)*4446;
    
    wormLoc = [wormLoc currentX+movex currentY+movey]
end

% update our fields 'totalWorm' and 'currentWorm'

% --- Executes on button press in detectWorms.
function detectWorms_Callback(hObject, eventdata, handles)
% hObject    handle to detectWorms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stg
global wormLoc
global wormIndex

clear_stage_buffer();
fprintf(stg, 'P');
currentPosition = fscanf(stg)

commas = find(currentPosition == ',');
currentX = str2num(currentPosition(1:commas(1)-1))
currentY = str2num(currentPosition(commas(1)+1:commas(2)-1))

detectWorms(currentX, currentY);
set(handles.totalWorm, 'String', num2str(length(wormLoc)/2));
set(handles.currentWorm, 'String', num2str(wormIndex));

function crosshair_Callback(hObject, eventdata, handles)
% hObject    handle to crosshair (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global toggle
toggle = ~toggle;

% --- Executes on button press in getCoord.
function getCoord_Callback(hObject, eventdata, handles)
% hObject    handle to getCoord (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AVT_Vid
global stg
clear_stage_buffer();
fprintf(stg, 'PX');
currentPositionX = fscanf(stg)
fprintf(stg, 'PY');
currentPositionY = fscanf(stg)

% --- Executes on button press in BuildMontage_pushbutton.
function BuildMontage_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to PlasmidTest5_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% % --- Executes on button press in video_sweep_test.
% function video_sweep_test_pushbutton_Callback(hObject, eventdata, handles)
% % hObject    handle to video_sweep_test_pushbutton (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
global stg
global AVT_Vid
global stitched_image
global wellnumber
global NikonTiScope
global atlas
global Adams_Dir
global objective

if ~isequal(objective, 1) %if 2Xobjective is not loaded  then swith to 2X objective 
    Objective2X_pushbutton_Callback(hObject, eventdata, handles);
end

data = load([Adams_Dir,'\img_correction.mat']);
img_correction = data.img_rectify;

atlas = [];
stg.timeout =0.1;
clear_stage_buffer();


tic
disp('Please bring view into focus. Then press any key.');
%ensure that worm is in focus in 2X, plate planarity is crucial to ensure
%that all worms are view as the plate scans
Temp = waitforbuttonpress; %press any key after worms is brought into focus

fprintf(stg,'encoder,1');
fscanf(stg);
% Calibrated so our montage speed works out well

fprintf(stg,'SAS,100'); % XY acceleration
fscanf(stg);
fprintf(stg,'SMS,195'); %stage speed
stagespeed195R = fscanf(stg);
fprintf(stg,'SCS,100'); %XY S-curve, rate of change of acceleration
fscanf(stg);

% Initialize video
stop(AVT_Vid);
stoppreview(AVT_Vid);
triggerconfig(AVT_Vid, 'manual');
AVT_Vid.ReturnedColorspace = 'rgb';
FPT = 220;
% add RGB to triggerconfig **********************************************
% change FPT to estimate FPT from distance to travel (below) ******
set(AVT_Vid, 'FramesPerTrigger', FPT);
AVT_Vid.ROIPosition = [0 0 2336 1752];

%This is setup for a 3 well system with long rectangular troughs
switch wellnumber % select well from gui interface determines XY start coordinates for mapping
    case 1 
        currentY = 69114;
    case 2
        currentY = 42600;
    case 3
        currentY = 16000;
    case 4
        disp('This is not a valid well selection');   
    otherwise
        disp('This is not a valid well selection');    
end

vert_shift_fraction = .5;
horiz_shift_fraction = 0;
vert_offset = 3209;
horiz_offset = -5000;
left_side = 111050 + horiz_offset;
right_side = 35777 + horiz_offset;
pause_time = 8;      % This allows the stage to move from anywhere to the proper starting location
total_rows = 6; % number of row that should be aquired per scan of a well
%Start from beginning position and take images as the stage is translated
%to form a large montage of the rows
for rowNum = 1:total_rows
    %the following 'if' statement determines if the stage is scanning right
    %or left side
    if mod(rowNum,2)==1
        start_pos(1) = left_side; %start from left side, user defined
        end_pos(1) = right_side; %end position, user defined
    else
        start_pos(1) = right_side; %start from right and go left
        end_pos(1) = left_side;
    end
    start_pos(2) = currentY - ((rowNum-1) * vert_offset * (vert_shift_fraction)); % move down one row to begin next row acquisition
    end_pos(2) = start_pos(2); % define new end position from previous start location

    [frames,timing_data] = video_sweep(stg,AVT_Vid,FPT,start_pos,end_pos,pause_time); %acquire video as the stage is scanning
   
    if mod(rowNum,2)==1
        row_image = faster_row_sweep_B(frames,2,'right',rowNum,img_correction); % assemble frames into a row by via stage speed calibration
        unregistered_rows{rowNum,1} = row_image; % make new variable for the assembled row
    else
        row_image = faster_row_sweep_B(frames,2,'left',rowNum,img_correction); % assemble frames into a row by via stage speed calibration
        unregistered_rows{rowNum,1} = row_image; % make new variable for the assembled row
    end
    memory % output memory status to terminal
    pause_time = 2; % wait 2 seconds for acquisition and processing
end

translations = calc_translations(unregistered_rows,horiz_shift_fraction,vert_shift_fraction); %determine the amount of horizontal and vertical shift for 
translations{:,3}; 

size_rowFrames = size(row_image); %get size for space allocation of new variable later
row_origin_coords(1:total_rows,1:2) = 1; 
origin_offset = [0 0];

%set rown coordinates and round the positions so that they can be used in
%stage coordinates
for row = 2:total_rows
    row_origin_coords(row,1) = round(row_origin_coords(row-1,1) + translations{row,1}(1) + translations{row,2}(1) + translations{row,3}(1));
    row_origin_coords(row,2) = round(row_origin_coords(row-1,2) + translations{row,1}(2) + translations{row,2}(2) + translations{row,3}(2));
end

%determine the size of the new atlas
atlasLeft = min(row_origin_coords(:,2));
atlasRight = max(row_origin_coords(:,2));
atlasTop = min(row_origin_coords(:,1));
atlasBottom = max(row_origin_coords(:,1));
sizeAtlas = [atlasBottom - atlasTop, atlasRight - atlasLeft];
if atlasTop < 1
    origin_offset(1) = -atlasTop +1;
end
if atlasLeft < 1
    origin_offset(2) = -atlasLeft + 1;
end
row_origin_coords(:,1) = row_origin_coords(:,1) + origin_offset(1);
row_origin_coords(:,2) = row_origin_coords(:,2) + origin_offset(2);

atlas = zeros(sizeAtlas,3,'uint8'); %allocate new array of zeros with size of the atlas

%assemble the rows to form the large atlas
for row = 1:total_rows %for each row
    row_origin_coords(row,1);
    row_origin_coords(row,1) + size_rowFrames(1)-1;
    row_origin_coords(row,2);
    row_origin_coords(row,2) + size_rowFrames(2)-1;
    size(unregistered_rows{row});
    atlas(row_origin_coords(row,1):row_origin_coords(row,1) + size_rowFrames(1)-1,row_origin_coords(row,2):row_origin_coords(row,2) + size_rowFrames(2)-1,1:3) = unregistered_rows{row};
end

%display the atlas
figure, imshow(atlas);

%set the live camera display back to normal viewing settings
AVT_Vid.ReturnedColorspace = 'grayscale';
AVT_Vid.ROIPosition = [0 0 2336 1752];
preview(AVT_Vid)

%use as global variable to pass into other functions
stitched_image = atlas;

%reset the stage to prevent any errors in communication
ReleaseStage_pushbutton_Callback(hObject, eventdata, handles);
pause(1);
[stg] = InitializeStage_pushbutton_Callback(hObject, eventdata, handles);
pause(1);


function make_condensor_avg()
global stg
global AVT_Vid
global ulcoord
global condensor_avg
global wellnumber
global NikonTiScope
global img_off
global Adams_Dir

clc
stg.timeout =0.1;
fscanf(stg)
pause(1)
% Resets the exposure time, frame rate for montage building

tic

pause(0.5)

img_off = 0;

% NikonTiScope.ZDrive.Position = 4600*40;
% pause(.5);

clear_stage_buffer();
fprintf(stg,'encoder,1');
fscanf(stg);
% Calibrated so our montage speed works out well
fprintf(stg,'SMS,195'); 
stagespeed195R = fscanf(stg)


% Initialize video
triggerconfig(AVT_Vid, 'manual');
FPT = 220; %144;%80;%132;%144;
set(AVT_Vid, 'FramesPerTrigger', FPT);
AVT_Vid.ROIPosition = [0 0 2336 1752];

switch wellnumber
    case 1 
        currentY = 71746;
    case 2
        currentY = 54280;
    case 3
        currentY = 36404;
    case 4
        currentY = 18292;
    otherwise
    disp('This is not a valid well selection');    
end


% Initialize the stage so we know how much to go
currentX = 111050;
ulcoord = [currentX-2199 currentY];
currentY = currentY - 2*2199;
fprintf(stg,[ 'G,' num2str(111050) ', ' num2str(currentY) ',0']);


% Arbritray long pause
pause(8);

condensor_avg = [];

if ~isrunning(AVT_Vid)
    start(AVT_Vid);
else
    stop(AVT_Vid);
    pause(.1);
    start(AVT_Vid);
end

fprintf(stg,[ 'G,' num2str(35777) ', ' num2str(currentY) ',0']);        

trigger(AVT_Vid);
pause(8);
[frames timestamps] = getdata(AVT_Vid);
% size(frames);

f_start = 129;   f_range = 20;  f_end = f_start + f_range;

for col=f_start:f_end
    if isempty(condensor_avg)
        condensor_avg = double(frames(:, :, 1, col));
    else
        condensor_avg = condensor_avg + double(frames(:, :, 1, col));
    end
end

condensor_avg = condensor_avg / length(f_start:f_end);
img_mean = mean(mean(condensor_avg));
img_correction = img_mean - condensor_avg;
for i = 1:3
    img_rectify(:,:,i) = img_correction;
end

img_condensor = uint8(condensor_avg);
figure, imshow(img_condensor); % , 'Visualization of illumination distortion.'
imwrite(condensor_avg,[Adams_Dir, '\condensor.tif'],'tiff');

img_adj = uint8(img_mean + img_correction);
figure, imshow(img_adj); % , 'Visualization of adjustment to be applied.'
save([Adams_Dir, '\img_correction'], 'img_rectify');

% white_image = double(255*ones(length(condensor_avg(:, 1)), length(condensor_avg(1, :))));
% norm_img = uint8((white_image ./ condensor_avg) - 255);
img_proof = uint8(condensor_avg + img_correction);
figure, imshow(img_proof); % , 'Proof adjustment corrects illumination distortion.'

implay(frames(:,:,1,f_start:f_end))




function register_rows

global stitched_image

montage = imresize(stitched_image, .02);
figure, imshow(montage);
[rows cols] = size(montage);
row1 = rows/7;

row1to2 = montage(1:2*row1, :);
test1 = align2(row1to2);
row2to3 = [test1(end/2+1:end, :); montage(row1+1:2*row1, :)];
test2 = align2(row2to3);
row3to4 = [test2(end/2+1:end, :); montage(row1*2+1:3*row1, :)];
test3 = align2(row3to4);
row4to5 = [test3(end/2+1:end, :); montage(row1*3+1:4*row1, :)];
test4 = align2(row4to5);
row5to6 = [test4(end/2+1:end, :); montage(row1*4+1:5*row1, :)];
test5 = align2(row5to6);
row6to7 = [test5(end/2+1:end, :); montage(row1*5+1:6*row1, :)];
test6 = align2(row6to7);
row7to8 = [test6(end/2+1:end, :); montage(row1*6+1:7*row1, :)];
test7 = align2(row7to8);


figure, imshow([test1(1:end/2, :) ; test2(end/2+1:end, :); test3(end/2+1:end, :); ...
   test4(end/2+1:end, :); test5(end/2+1:end, :); test6(end/2+1:end, :); test7(end/2+1:end, :)])

% global AVT_Vid
% global stg
% global wormLoc
% global wormIndex
% global stitched_image
% global RotationSetVariable
% global scale
% global ulcoord
% global NikonTiScope
% global imageDIRECTORYNAME
% global previewHandlesImage
% global img
% global CameraInformation
% global src
% global cameraBinning
% global RotationAccumulation
% global handle
%      
% handle = handles;
% 
% fprintf(stg,'O,100'); %XY joystick max speed conversion
% fscanf(stg);
% fprintf(stg,'SAS,100'); % XY acceleration
% fscanf(stg);
% fprintf(stg,'SMS,200,u'); %XY max speed, u sets to microns per second speed
% fscanf(stg);
% fprintf(stg,'SCS,100'); %XY S-curve, rate of change of acceleration
% fscanf(stg);
% fprintf(stg,'BLSH, 0')%XY Backlash, 0=off, 1=n
% backlash = fscanf(stg);
% 
% % Eventually we will incorporate worm tracking with montage
% wormLoc = [];
% %wormIndex = 0;
% wormIndex = 40; %move to 40th worm, edited by cody
% %screensize = 4398;
% screensize = 4398/2; 
% 
% % Move Manipulator to home position
% manipControl('changePosition',0,1,0,16*24994,0)
% pause(3)
% disp('Move Manipulator to Home Position')
% % Sets objective to 2x - build montage only in 2x
% Objective2X_pushbutton_Callback(hObject, eventdata, handles)
% %NikonTiScope.Nosepiece.Position = 1;
% NikonTiScope.ZDrive.Position = 2000*40;
% 
% %hardcoded values
% %previous values for rotation dish
% %{
% ulcoord = [74439 49592];
% urcoord = [46302 49592];
% llcoord = [74439 27213];
% lrcoord = [46302 27213];
% %}
% RotationAccumulation = 0; %reset rotation
% %values for plate
% % ulcoord = [92473 72118];
% % urcoord = [46302 72118];
% % llcoord = [92473 60574];
% % lrcoord = [46302 60574];
% 
% %UL ,72118,0
% %LL  92424,,
% %LR 69130,62514
% %UR 65995,70782
% 
% ulcoord = [110270 71746];
% urcoord = [36771 72794];
% lrcoord = [36269 45076];
% llcoord = [110262 45076];
% % Start at upper left corner
% fprintf(stg,[ 'G,' num2str(ulcoord(1)) ', ' num2str(ulcoord(2)) ',0']);
% fscanf(stg);
% pause(3);
% 
% % We want to scale down each frame of the montage, for speed
% %scale = .1; %.1 works
% %scale = .25; %.25 works, 10MB image
% scale = 1; %.5 works, 40MB image
% % Image normalization - that is to eliminate sharp edges that
% % result from the condensor lighting
% 
% %norm_img = double(imresize(imread('Condensor.tif'), scale));
% %worm_imageAVT_October_12_2011_12_10_12_343_AM
% %norm_img = double(imresize(imread('worm_imageAVT_October_12_2011_12_10_12_343_AM.tif'), scale));
% condenser_img = double(imresize(imread('worm_imageAVT_October_15_2011_ 4_27_30_984_PM.tif'), scale));
% white_image = ones(length(condenser_img(:, 1)), length(condenser_img(1, :)));
% white_image(:, :) = 255; %works
% %white_image(:, :) = 1; % produces all black montage
% % We multiply this image with all the frames in the montage
% norm_img = white_image ./ condenser_img; %white_image ./ norm_img;
% 
% % Initialize camera for image capture
% triggerconfig(AVT_Vid, 'manual');
% 
% %Generate pathway using coordinate information
% currentX = ulcoord(1);
% currentY = ulcoord(2);
% stitched_image = [];
% 
% % Iterate through the region of interest
% for y=1:ceil((ulcoord(2)-llcoord(2))/screensize),
%     stitched_f_image = [];
%     stitched_r_image = [];
%     for x=1:ceil((ulcoord(1)-urcoord(1))/screensize),
%         
%         pause(0.4);%changed this value from 1 to speed montage
%         start(AVT_Vid);
%         trigger(AVT_Vid);
%         
%         % Apply mask to image by entry wise multiplication
%         img = double(imresize(getdata(AVT_Vid), scale)) .* norm_img;
%         img = uint8(img);
% 
%         % Deciding whether to go right or left
%         if (-1)^(y) == 1,
%             currentX = currentX + screensize;
%             stitched_f_image = [img stitched_f_image];
%         else
%             currentX = currentX - screensize;
%             stitched_r_image = [stitched_r_image img];
%         end
%         
%         % Handles edge case where the ROI is just a row
%         if ceil((ulcoord(1)-urcoord(1))/screensize)~=1,
%             fprintf(stg,[ 'G,' num2str(currentX) ', ' num2str(currentY) ',0']);
%             fscanf(stg);
%         else
%             if (-1)^(y) == 1,
%                 currentX = currentX - screensize;
%             else
%                 currentX = currentX + screensize;
%             end          
%             break;
%         end
%         
%       % We do not want to skip the last frame
%       if x==ceil((ulcoord(1)-urcoord(1))/screensize),
%             pause(1);
%             start(AVT_Vid);
%             trigger(AVT_Vid);
%             img = double(imresize(getdata(AVT_Vid), scale)) .* norm_img;
%             img = uint8(img);
%             
%             if (-1)^(y) == 1,
%                 stitched_f_image = [img stitched_f_image];
%             else
%                 stitched_r_image = [stitched_r_image img];
%             end
%        end
%     end
% 
%     % Combine frames to form row
%     % Save original version to file
%     imwrite([stitched_f_image; stitched_r_image],[imageDIRECTORYNAME, '\worm_imageAVT_', num2str(y) '.tif'],'tiff');
%     if isempty(stitched_f_image)
%            %stitched_image = [stitched_image;  imresize(stitched_r_image, .5)];
%             save(['row' num2str(y)] , 'stitched_r_image');
%     else
%            %stitched_image = [stitched_image;  imresize(stitched_f_image, .5)];
%             save(['row' num2str(y)] , 'stitched_f_image');
%     end
%     currentY = currentY-screensize;
%     fprintf(stg,[ 'G,' num2str(currentX) ', ' num2str(currentY) ',0']);
%     fscanf(stg);
% end
% 
% % for y=1:ceil((ulcoord(2)-llcoord(2))/screensize)
% %     a = load(['row' num2str(y) '.mat']);
% %     if (-1)^(y) == 1,
% %         stitched_image = [stitched_image a.stitched_f_image];
% %     else
% %         stitched_image = [stitched_image a.stitched_r_image];
% %     end
% % end
% 
% 
% 
% % Will become relevant when we detect worms in the montage
% set(handles.totalWorm, 'String', num2str(length(wormLoc)/2));
% set(handles.currentWorm, 'String', num2str(wormIndex));
% 
% % Set zero position for approach angle code
% RotationSetVariable = 1;
% RotationZeroPosition_pushbutton_Callback(hObject, eventdata, handles);
% RotationSetVariable = 0;
% 
% fprintf(stg,'O,100'); %XY joystick max speed conversion
% fscanf(stg);
% fprintf(stg,'SAS,75'); % XY acceleration
% fscanf(stg);
% fprintf(stg,'SMS,75'); %XY max speed
% fscanf(stg);
% fprintf(stg,'SCS,75'); %XY S-curve, rate of change of acceleration
% fscanf(stg);
% fprintf(stg,'BLSH, 0')%XY Backlash, 0=off, 1=n
% backlash = fscanf(stg);
% 
% disp('Montage Complete!')
% 
% 
% 
% dt = datestr(now, 'mmmm_dd_yyyy_HH_MM_SS_FFF_AM');
% %img_montage = stitched_image;
% %imwrite(img_montage,[imageDIRECTORYNAME, '\montage_imageAVT_', dt '.tif'],'tiff');
% %figure, imshow(img_montage)
% %disp(['Image Saved: montage_imageAVT_' dt])
% 


% --- Executes on button press in ClearWorm_pushbutton.
function ClearWorm_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to ClearWorm_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global wormLoc
global wormIndex

wormLoc = [];
wormIndex = 0;
set(handles.totalWorm, 'String', num2str(0));
set(handles.currentWorm, 'String', num2str(0));

% --- Executes on button press in WorldMap_pushbutton.
function WorldMap_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to WorldMap_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stg
global RotationSetVariable
global stitched_image
global ulcoord
global scale

scale = 1;
h = figure, imshow(stitched_image);
set(gcf,'Pointer','crosshair');
k = waitforbuttonpress;
pointer1click = get(gca,'CurrentPoint')
clickx = pointer1click(1,1)*(1/scale)
clicky = pointer1click(1,2)*(1/scale)
set(gcf,'Pointer','arrow');
close(h);

centerx = 600;
centery = 600;
movex = (((centerx - clickx))/1200)*4398*(0.5)%divided by 2 for 2X
movey = ((centery - clicky)/1200)*4398*(0.5)%divided by 2 for 2X
movex = round(movex);
movey = round(movey);


clear_stage_buffer();
fprintf(stg,[ 'G,' num2str(ulcoord(1)+movex) ', ' num2str(ulcoord(2)+movey) ',0']);
fscanf(stg);
  
% --- Executes on button press in BuildInjectionPath_pushbutton.
function BuildInjectionPath_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to BuildInjectionPath_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stg
global stitched_image
global ulcoord
global doneSelecting
global delLast
global wormLoc
global wormIndex
global scale
global atlas
global ratio_stg2X
% global clickx

% Adam added following assignment to test atlas
% stitched_image = atlas;

% Indicators used for selecting positions
delLast = false;
doneSelecting = false;

% Stores the location of the worms, in addition to handles
% of labels created
points = [];
wormLoc = [];
wormIndex = 0;

%Cody changed to match montage image
scale = 1;
%scale = 1;


% Creates pop-out gui
h = figure('Toolbar','none',...
              'Menubar','none','Position',[20 50 2350 1820]);
hlm = imshow(stitched_image);
hSP = imscrollpanel(h,hlm);

set(hSP,'Units','normalized',...
        'Position',[0 .1 1 .9])
set(h,'Position',[20 50 2350 1820])
button1 = uicontrol(h, 'Style', 'pushbutton', 'String', 'Finish', ...
    'Position', [25 25 50 20], 'Callback', @save_coord)
button2 = uicontrol(h, 'Style', 'pushbutton', 'String', 'Delete Last Point', ...
    'Position', [0 0 100 20], 'Callback', @delete_point)

hMagBox = immagbox(h,hlm);
pos = get(hMagBox,'Position');
set(hMagBox,'Position',[0 0 pos(3) pos(4)])
imoverview(hlm)
api = iptgetapi(hSP);
%Get the current magnification and position.

mag = api.getMagnification();
r = api.getVisibleImageRect();
%View the top left corner of the image.

api.setVisibleLocation(0.5,0.5)
%Change the magnification to the value that just fits.

api.setMagnification(api.findFitMag())
%Zoom in to 1600% on the dark spot.

%api.setMagnificationAndCenter(0.25,306,800)
api.setMagnificationAndCenter(0.5,306,800)
set(h,'Pointer','crosshair');

hold on
clicks = [];
while ~doneSelecting
    k = waitforbuttonpress;
    pause(.1);     
    pointer1click = get(gca,'CurrentPoint');
    clickx = pointer1click(1,1)
    clicky = pointer1click(1,2)
    clicks = [clicks; clickx clicky];
    % Ensure we click within the world map
    if clickx > 0 && clickx <= length(stitched_image(1, :)) && ...
            clicky > 0 && clicky <= length(stitched_image(:, 1))
        points(length(points)+1) = ...
             text(clickx, clicky, sprintf('%d', length(points)+1), ...
            'EdgeColor', 'b', 'Color', 'r');
    end

    % We are done selecting worms
    if doneSelecting && k == 0,
        break;
    end
    
    % Deselect worms within the map by deleting the handle
    if delLast && length(points) > 0 && k==0,
        delete(points(end));
        if length(points) > 1,
            points = points(1:end-1);
        else
            points = [];
        end
    end
    delLast = false;
end
hold off

x_offset = 142;
y_offset = -62;

for i=1:length(points)
    centerx =2336/2;
    centery = 1752/2;
    clickx = clicks(i, 1);
    clicky = clicks(i, 2);
    movex = (centerx - clickx )*ratio_stg2X   % 1.8325 is the per-pixel conversion to stage movement
    movey = (centery - clicky )*ratio_stg2X
    
    wormLoc = [wormLoc ulcoord(1)+movex+x_offset  ulcoord(2)+movey+y_offset];
end

wormLoc
set(handles.totalWorm, 'String', num2str(length(wormLoc)/2));
set(handles.currentWorm, 'String', num2str(wormIndex));

% Close the gui
set(gcf,'Pointer','arrow');
close(h)

function save_coord(hObj, eventdata)
global doneSelecting
doneSelecting = true;

function delete_point(hObj, eventdata)
global delLast
delLast = true;

% Method used to move the needle tip from its location on the screen
% to the center of the screen
function MoveNeedleToCoord(x, y)
global ManipulatorSetVariable
global NikonTiScope

segmentdistance1xOBJ = 4398; %size of screen in pixels wide
segmentdistance2xOBJ = 4398/2;
segmentdistance4xOBJ  = segmentdistance1xOBJ/4;
segmentdistance10xOBJ = segmentdistance1xOBJ/10;
segmentdistance20xOBJ = segmentdistance1xOBJ/20;
segmentdistance50xOBJ = segmentdistance1xOBJ/50;
ObjectiveCalibration = NikonTiScope.Nosepiece.Position.RawValue;

switch ObjectiveCalibration;
    case 1
         segmentdistanceOBJcurrent = segmentdistance2xOBJ;
    case 2
         segmentdistanceOBJcurrent = segmentdistance4xOBJ;
    case 3
         segmentdistanceOBJcurrent = segmentdistance10xOBJ;
    case 6
         segmentdistanceOBJcurrent = segmentdistance20xOBJ;  
    case 5
         segmentdistanceOBJcurrent = segmentdistance20xOBJ;
    case 4
         segmentdistanceOBJcurrent = segmentdistance50xOBJ;    
    otherwise
        disp('Error Reading Correct Objective for Center Click Calibration')
end

NeedleClickX1 = x;
NeedleClickY1 = y;

NeedleClickX2 = 600;
NeedleClickY2 = 600;

NeedleClickDifferenceX = NeedleClickX1 - NeedleClickX2;
NeedleClickDifferenceY = NeedleClickY1 - NeedleClickY2;
NeedleClickDifferenceXMicrons = (NeedleClickDifferenceX/1200) * (segmentdistanceOBJcurrent);
NeedleClickDifferenceYMicrons = (NeedleClickDifferenceY/1200) * (segmentdistanceOBJcurrent);
NEEDLE_POSITION = (manipControl('getPosition',0,1))/16;
pause(0.5)
%positions in microns
manipx = NEEDLE_POSITION(1);
manipy = NEEDLE_POSITION(2);
manipz = NEEDLE_POSITION(3);

RelativeManipMoveX = NEEDLE_POSITION(1) + NeedleClickDifferenceXMicrons;
RelativeManipMoveY = NEEDLE_POSITION(2) + NeedleClickDifferenceYMicrons;
%RelativeManipMoveZ = NEEDLE_POSITION(3) - NeedleClickDifferenceZMicrons

manipControl('changePosition',0,1,round(RelativeManipMoveX*16),round(RelativeManipMoveY*16),(NEEDLE_POSITION(3))*16)
pause(0.5)

function focusNeedleTip(size)
global AVT_Vid
global NikonTiScope
global ManipulatorSetVariable
global SetHoverNeedlePosition 
global ZDriveHoverRawValue
global src

currentObjective = NikonTiScope.Nosepiece.Position.RawValue;
switch currentObjective
    case 1
        focusing = 0;
    case 2
        delta = 2500;
        step = 600*16;
    case 3
        delta = 2500/3;
        step = 200*16;
    case 6
        delta = 2500/5;
        step = 120*16;
end

SetHoverNeedlePosition = (manipControl('getPosition',0,1));
pause(0.5)
CurrentPositionX = SetHoverNeedlePosition(1);
CurrentPositionY = SetHoverNeedlePosition(2);
CurrentPositionZ = SetHoverNeedlePosition(3);

% Get full image
start(AVT_Vid);
trigger(AVT_Vid);
full_image = getdata(AVT_Vid);

% Get background image
manipControl('changePosition',0,1,CurrentPositionX-step, CurrentPositionY,CurrentPositionZ);
pause(2);
start(AVT_Vid);
trigger(AVT_Vid);
background = getdata(AVT_Vid);

% mask
mask = double(background- full_image);
mask = mask > 10;
mask = imfill(mask, 'holes');

regions = regionprops(mask, {'BoundingBox'});
rect = rectangle('Position', regions(1).BoundingBox, ...
              'EdgeColor','y', 'LineWidth', 3, 'Visible', 'off');    
rect = get(rect, 'Position');
rect(3) = 25;
rect(2) = rect(2) + rect(4)/2 - size/2;
rect(4) = size;   

% Return back to normal position
manipControl('changePosition',0,1,CurrentPositionX, CurrentPositionY,CurrentPositionZ);
pause(2);

% flag to continue to focus
focusing = 1;

% Initialization 
triggerconfig(AVT_Vid, 'manual');
direction_sign = 1;

% Get Current Focus Score and current height
start(AVT_Vid);
trigger(AVT_Vid);
img = getdata(AVT_Vid);
img =imcrop(img, rect);
focus_scores = [normalized_variance(img)];
zheight = [NikonTiScope.ZDrive.Position.RawValue];
currentHeight = zheight(1);

while focusing == 1
    currentHeight = currentHeight + direction_sign*delta;
    NikonTiScope.ZDrive.Position = currentHeight;

    start(AVT_Vid);
    trigger(AVT_Vid);
    img = getdata(AVT_Vid);
    img = imcrop(img, rect);
    
    focus_scores = [focus_scores normalized_variance(img)];
    zheight = [zheight NikonTiScope.ZDrive.Position.RawValue];

    if focus_scores(end) < focus_scores(end-1) && direction_sign == -1,
        NikonTiScope.ZDrive.Position = currentHeight + delta;
        focusing = 0;
    elseif focus_scores(end) < focus_scores(end-1),
        direction_sign = -direction_sign;
    end
end

disp('Needle Tip is now in focus');

% --- Executes on button press in RotationTest4_pushbutton.
function RotationTest4_pushbutton_Callback(hObject, eventdata, handles)
global stg
global AVT_Vid

clear_stage_buffer();
fprintf(stg,'SMS,200'); %XY max speed, u sets to microns per second speed
fscanf(stg);

% Initialize video
triggerconfig(AVT_Vid, 'manual');
FPT = 144;%80;%132;%144;
set(AVT_Vid, 'FramesPerTrigger', FPT);


% Initialize the stage so we know how much to go
fprintf(stg,[ 'G,' num2str(92963) ', ' num2str(41861) ',0']);
fscanf(stg);
% Arbritray long pause
pause(5);

% Calibrated so our montage speed works out well
fprintf(stg,'SMS,195'); 
fscanf(stg);

% Mark's advice on helping to fix serial COM
try
    fread(stg, stg.BytesAvailable);
catch
    disp('No!');
end

currentX = 55580;
currentY = 41861;
montage = [];

for row=1:10
    
    start(AVT_Vid);
    row_img = [];
    if mod(row,2) ~= 0
        
        clear_stage_buffer();
        fprintf(stg,[ 'G,' num2str(55580) ', ' num2str(currentY) ',0']);
        fscanf(stg);
        trigger(AVT_Vid);
        %pause(FPT/30);
        [frames timestamps] = getdata(AVT_Vid);
        
        for col=9:8:FPT-8%min(17*8,80)
            row_img = [row_img frames(:, :, 1, col)];
        end
        
        currentX = 55580;
        
    else
        clear_stage_buffer();
        fprintf(stg,[ 'G,' num2str(92963) ', ' num2str(currentY) ',0']);
        fscanf(stg);
        
        trigger(AVT_Vid);
        %pause(FPT/30);
        [frames timestamps] = getdata(AVT_Vid);
        for col=9:8:FPT-8%136
            row_img = [frames(:, :, 1, col) row_img];
        end  
        
        currentX = 92963;
    end

    
    currentY = currentY - 2199;

    if mod(row, 2) ~= 0
        montage = [montage; row_img];
    else
        %shift everything over
        %offset = 150+36;
        offset = 150+36;
        row_img = [zeros(length(row_img(:, 1)),offset) row_img(:, 1:end-offset)];
        montage = [montage; row_img];
    end
    clear_stage_buffer();
    fprintf(stg,[ 'G,' num2str(currentX) ', ' num2str(currentY) ',0']);
    fscanf(stg);
    pause(1);
end

figure, imshow(montage);

% --- Executes on button press in RotationTest5_pushbutton.
function RotationTest5_pushbutton_Callback(hObject, eventdata, handles)
global stg
global AVT_Vid
global ulcoord
global stitched_image
global src
global wellnumber

% Resets the exposure time, frame rate for montage building

tic

%set(AVT_Vid, 'FrameRate', '30');
clear_stage_buffer();
fprintf(stg,'SMS,200'); %XY max speed, u sets to microns per second speed
fscanf(stg);

% Initialize video
triggerconfig(AVT_Vid, 'manual');
FPT = 280; %144;%80;%132;%144;
set(AVT_Vid, 'FramesPerTrigger', FPT);
AVT_Vid.ROIPosition = [568 276 1200 1200];
%AVT_Vid.TriggerRepeat = inf;
%start(AVT_Vid);

%well1_ulcoord = [110270 71746];
%well2_ulcoord = [110270 54280];
%well3_ulcoord = [110270 36404];
%well4_ulcoord = [110270 18292];

switch wellnumber
    case 1 
        currentY = 71746;
    case 2
        currentY = 54280;
    case 3
        currentY = 36404;
    case 4
        currentY = 18292;
    otherwise
    disp('This is not a valid well selection');    
end

% Initialize the stage so we know how much to go
currentX = 111050;
%currentY = 72118;
ulcoord = [currentX-2199 currentY];

fprintf(stg,[ 'G,' num2str(currentX) ', ' num2str(currentY) ',0']);
fscanf(stg);
% Arbritray long pause
pause(8);

% Calibrated so our montage speed works out well
fprintf(stg,'SMS,195'); 
%fprintf(stg,'SMS,15000,u'); 
%10000 close
fscanf(stg);

% Mark's advice on helping to fix serial COM
try
    fread(stg, stg.BytesAvailable);
catch
    disp('No!');
end


montage = [];

for row=1:7
    %7 rows means 7 screen sizes and it does 2 plate well rows
    
    start(AVT_Vid);
    row_img = [];
    if mod(row,2) ~= 0
         
        clear_stage_buffer();
        fprintf(stg,[ 'G,' num2str(35777) ', ' num2str(currentY) ',0']);
        fscanf(stg);
        trigger(AVT_Vid);
        %pause(FPT/30);
        [frames timestamps] = getdata(AVT_Vid);
        size(frames);
        for col=9:8:FPT-8%min(17*8,80)
            row_img = [row_img frames(:, :, 1, col)];
        end
        
        currentX = 35777;
        
    else
        clear_stage_buffer();
        fprintf(stg,[ 'G,' num2str(111050) ', ' num2str(currentY) ',0']);
        fscanf(stg);
        
        trigger(AVT_Vid);
        %pause(FPT/30);
        [frames timestamps] = getdata(AVT_Vid);
        for col=9:8:FPT-8%136
            row_img = [frames(:, :, 1, col) row_img];
        end  
        
        currentX = 111050;
    end

    
    currentY = currentY - 2199;

    if mod(row, 2) ~= 0
        montage = [montage; row_img];
    else
        %shift everything over
       % offset = 620-50+520+290+2;
        offset = 550;
       row_img = [zeros(length(row_img(:, 1)),offset) row_img(:, 1:end-offset)];
        montage = [montage; row_img];
    end
    clear_stage_buffer();
    fprintf(stg,[ 'G,' num2str(currentX) ', ' num2str(currentY) ',0']);
    fscanf(stg);
    pause(1);
end

stitched_image = montage;
figure, imshow(stitched_image);
disp(toc);
ulcoord(1) = ulcoord(1) + 2199/2;



% --- Executes on button press in RotationTest6_pushbutton.
function RotationTest6_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to RotationTest6_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in SetTemperature_pushbutton.
%global NikonTiScope
%global stg

ulcoord = [110270 71746];
urcoord = [36771 72794];
lrcoord = [36269 45076];
llcoord = [110262 45076];
screensize = 4398/2; 

well1_ulcoord = [110270 71746];
well2_ulcoord = [110270 54280];
well3_ulcoord = [110270 36404];
well4_ulcoord = [110270 18292];

screensize = 4398/2; 

stitched_image = []; %zeros(600*1, 2*21000);
for y=1:7%ceil((ulcoord(2)-llcoord(2))/screensize)
    a = load(['row' num2str(y) '.mat']);
    if (-1)^(y) == 1,
        %stitched_image((y-1)*600+1:y*600, :) =  (a.stitched_f_image);%[stitched_image; a.stitched_f_image];
        stitched_image = [stitched_image; imresize(a.stitched_f_image, .5)];
    else
        %stitched_image((y-1)*600*2+1:y*600*2, :) =  (a.stitched_r_image);
        stitched_image = [stitched_image; imresize(a.stitched_r_image, .5)];
    end
end
montage1 = stitched_image;

stitched_image = []; %zeros(600*1, 2*21000);
for y=6:10%ceil((ulcoord(2)-llcoord(2))/screensize)
    a = load(['row' num2str(y) '.mat']);
    if (-1)^(y) == 1,
        %stitched_image((y-1)*600+1:y*600, :) =  (a.stitched_f_image);%[stitched_image; a.stitched_f_image];
        stitched_image = [stitched_image; imresize(a.stitched_f_image, .5)];
    else
        %stitched_image((y-1)*600*2+1:y*600*2, :) =  (a.stitched_r_image);
        stitched_image = [stitched_image; imresize(a.stitched_r_image, .5)];
    end
end
montage2 = stitched_image;

stitched_image = []; %zeros(600*1, 2*21000);
for y=11:13%ceil((ulcoord(2)-llcoord(2))/screensize)
    a = load(['row' num2str(y) '.mat']);
    if (-1)^(y) == 1,
        %stitched_image((y-1)*600+1:y*600, :) =  (a.stitched_f_image);%[stitched_image; a.stitched_f_image];
        stitched_image = [stitched_image; imresize(a.stitched_f_image, .5)];
    else
        %stitched_image((y-1)*600*2+1:y*600*2, :) =  (a.stitched_r_image);
        stitched_image = [stitched_image; imresize(a.stitched_r_image, .5)];
    end
end
montage3 = stitched_image;


figure, imshow(montage1);
figure, imshow(montage2);
figure, imshow(montage3);




function SetTemperatureInputValue(voltageNum)
global power_supply

%voltage = (get(handles.Voltage_edit,'String'));
voltageStr = num2str(voltageNum) 
Vn = class(voltageNum)
Vs = class(voltageStr)
voltageNum

if voltageStr == '0'
    clear_stage_buffer();
    fprintf(power_supply, '%s\r', 'SOUT001');
    fscanf(power_supply);
    set(handles.Voltage_edit, 'String', num2str(0)); 
elseif length(voltageStr) == 1,
    clear_stage_buffer();
    fprintf(power_supply, '%s\r', ['VOLT000' voltageStr '0']);
    fscanf(power_supply);
    fprintf(power_supply, '%s\r', 'SOUT000');
    fscanf(power_supply);
%    set(handles.Voltage_edit, 'String', num2str(voltageNum));
elseif length(voltageStr) == 2 && str2double(voltageStr) <= 60,
    clear_stage_buffer();
    fprintf(power_supply, '%s\r', ['VOLT00' voltageStr '0']);
    fscanf(power_supply);
    fprintf(power_supply, '%s\r', 'SOUT000');
    fscanf(power_supply);
  %  set(handles.Voltage_edit, 'String', num2str(11));
    %set(handles.currentWorm, 'String', num2str(wormIndex));
else
    disp('Voltages can only go up to 60 volts!');
end






% --- Executes on button press in ChangeDish_pushbutton.
function ChangeDish_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to ChangeDish_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in StopEverything_pushbutton.
function StopEverything_pushbutton_Callback(hObject, eventdata, handles)
global stg
% hObject    handle to StopEverything_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear_stage_buffer();
fprintf(stg,'I'); %stop all stage movement in controlled manner, acted on immediately
TR = fscanf(stg)

disp('STOP Everything');

% Find the approximate location 
function MoveNeedleTipToCenter(x, y, z)
global AVT_Vid

% Move to start position
manipControl('changePosition',0,1,x(1),y(1),z(1));
pause(4);

% Take picture
triggerconfig(AVT_Vid, 'manual');
start(AVT_Vid);
trigger(AVT_Vid);
background = getdata(AVT_Vid);

% Move to second location, also predetermined
manipControl('changePosition',0,1,x(2),y(2),z(2));
pause(4);

% Take picture, subtract background to get location of the needle
start(AVT_Vid);
trigger(AVT_Vid);
newNeedlePosition = getdata(AVT_Vid);

% Find the difference
needle_img = background - newNeedlePosition;
img = needle_img > 10;
[needle_y needle_x] = find(img);

needleTipIndex = [find(needle_x == min(needle_x) )];
needleTipX = needle_x(needleTipIndex(1))
needleTipY = needle_y(needleTipIndex(1))

% Move to center
MoveNeedleToCoord(needleTipX, needleTipY);
pause(2);

% --- Executes on button press in CalibrateNeedle_pushbutton.
function CalibrateNeedle_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to CalibrateNeedle_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global NikonTiScope
global stg
global src
global AVT_Vid
global h
global ClickScreenX
global ClickScreenY
global SetHoverNeedlePositionTest
global SetEngageNeedlePositionZ_10XObj
global SetEngageNeedlePositionZ_20XObj
global ZDriveHoverRawValue_10XObj
global ZDriveHoverRawValue_20XObj
global NikonTiScope
global NeedleEngagedFlag
global CAMImode
global NeedleHomeFlag 
   
NeedleHomeFlag = 0;
NeedleEngagedFlag = 1;

CAMImode = 1%CalibrateNeedle


ObjectiveCalibration = NikonTiScope.Nosepiece.Position.RawValue;
pause(0.1);

Objective2X_pushbutton_Callback(hObject, eventdata, handles)
pause(0.1);
% NikonTiScope.ZDrive.Position = 6500*40; %above gel to get XY position
%============Adam changed from above to below========================
disp(['Please bring worm into focus in 2X. Then press any button.']);
waitforbuttonpress();
focused_2X = NikonTiScope.ZDrive.Position.RawValue;
NikonTiScope.ZDrive.Position = focused_2X + (500*40);
pause(0.25)
% manipControl('changePosition',0,1,9855*16, 22865*16,16343*16);
%============Adam changed from above to below========================
%get needle into position
manipControl('changePosition',0,1,2000*16, 23000*16,4000*16);
pause(2.5)
manipControl('changePosition',0,1,2000*16, 17826*16,4000*16);
pause(2.5)
manipControl('changePosition',0,1,18080*16, 13885*16,18000*16);
pause(2.5)


disp('Press ENTER key when needle is centered');
K=waitforbuttonpress

%============Adam changed from above to below========================
NikonTiScope.ZDrive.Position = focused_2X + (100*40);
pause(0.25)
disp('Press ENTER key when needle is brough into focus in 2X');
L=waitforbuttonpress
NikonTiScope.ZDrive.Position = focused_2X;
Objective20XDIC_pushbutton_Callback(hObject, eventdata, handles)
disp('Bring Needle into focus in 20X_DIC');
disp('Press the Diagonal Toggle button on the ROE-200 controller: Diag Mode')
disp('Calibrate the needle height by clicking: SET + Diagonal_Hover')



% --- Executes on button press in CenterRotation_pushbutton.
function CenterRotation_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to CenterRotation_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in CleanNeedle_pushbutton.
function CleanNeedle_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to CleanNeedle_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in SaveInjectionRecord_pushbutton.
function SaveInjectionRecord_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveInjectionRecord_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global wormIndex
global LogDirectory
global LoggingOn
global AVT_Vid
global LogFile

if LoggingOn == true,
    triggerconfig(AVT_Vid, 'manual');
    start(AVT_Vid);
    trigger(AVT_Vid);
    dt = datestr(now, 'mmmm_dd_yyyy_HH_MM_SS_FFF_AM');
    img_AVT = getdata(AVT_Vid);
    imwrite(img_AVT,[LogDirectory, '\worm', num2str(wormIndex), '_', dt '.tif'],'tiff');
    dt = datestr(now, 'mmmm_dd_yyyy_HH_MM_SS_FFF_AM');
    
    % Prompt user for what's going on
    activity = char(inputdlg('Please Enter a Description:'));
    if length(activity) == 0
        activity = 'Activity not specified';
    end
    
    fprintf(LogFile, '%s\r\n', [dt ' ' (activity) ' on Worm ' num2str(wormIndex)]);
    disp(['Image Saved: worm_imageAVT_' dt]);
else
    disp('Logging Not Initalized');
end

% --- Executes on button press in StartLogging_pushbutton.
function StartLogging_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to StartLogging_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global LogDirectory
global LoggingOn
global LogFile

if isempty(LoggingOn) == 1,
    SetDirectoryTITLE = 'Set Logging Directory';
    SetDirectorySTARTPATH = 'C:\Documents and Settings\cgilleland\Desktop\CAMI_ImageProcessing';
    LogDirectory = uigetdir(SetDirectorySTARTPATH, SetDirectoryTITLE);

    LoggingOn = true;

    % Get Log File
    LogFile = fopen([LogDirectory '\log.txt'], 'a');
    dt = datestr(now, 'mmmm_dd_yyyy_HH_MM_SS_FFF_AM');
    fprintf(LogFile, '%s\r\n', [dt ' Logging Started...']);
else
    disp('Logging is already on!!')
end


function Voltage_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Voltage_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Voltage_edit as text
%        str2double(get(hObject,'String')) returns contents of Voltage_edit as a double


% --- Executes during object creation, after setting all properties.
function Voltage_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Voltage_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SetTemperature_pushbutton.
function SetTemperature_pushbutton_Callback(hObject, eventdata, handles)
global power_supply
% hObject    handle to SetTemperature_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%fopen(power_supply);
voltage = (get(handles.Voltage_edit,'String'));
if voltage == '0'
    clear_stage_buffer();
    fprintf(power_supply, '%s\r', 'SOUT001');
    fscanf(power_supply);
elseif length(voltage) == 1,
    clear_stage_buffer();
    fprintf(power_supply, '%s\r', ['VOLT000' voltage '0']);
    fscanf(power_supply);
    fprintf(power_supply, '%s\r', 'SOUT000');
    fscanf(power_supply);
elseif length(voltage) == 2 && str2double(voltage) <= 60,
    clear_stage_buffer();
    fprintf(power_supply, '%s\r', ['VOLT00' voltage '0']);
    fscanf(power_supply);
    fprintf(power_supply, '%s\r', 'SOUT000');
    fscanf(power_supply);
else
    disp('Voltages can only go up to 60 volts!');
end



% --- Executes on button press in TemperatureProgram1_pushbutton.
function TemperatureProgram1_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to TemperatureProgram1_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%voltage = (get(handles.Voltage_edit,'String'));
disp('Temperature Program1 is running: 5Volts for 180 seconds')
SetTemperatureInputValue(5); %about 4 Amps, calibrate for each new peltier
pause(180)
SetTemperatureInputValue(0)
disp('Alarm: Remove worms from gel. 60 min has passed')
sound



% --- Executes on button press in TemperatureProgram2_pushbutton.
function TemperatureProgram2_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to TemperatureProgram2_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in InitializePowerSupply_pushbutton.
function InitializePowerSupply_pushbutton_Callback(hObject, eventdata, handles)
global power_supply
% hObject    handle to InitializePowerSupply_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
power_supply = serial('COM3'); %used to be com4
fopen(power_supply);
power_supply.Timeout = 3;
fprintf(power_supply, '%s\r', 'SOUT001'); %set to 0V
fscanf(power_supply)
disp('Power Supply is Initialized and set to 0V.');


% --- Executes on button press in ReleasePowerSupply_pushbutton.
function ReleasePowerSupply_pushbutton_Callback(hObject, eventdata, handles)
global power_supply
% hObject    handle to ReleasePowerSupply_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fprintf(power_supply, '%s\r', 'SOUT001'); %set to 0V
fscanf(power_supply)
disp('Power Supply is Released and set to 0V.');
fclose(power_supply);
delete(power_supply);
clear power_supply;


% --- Executes on button press in LocateWorms_pushbutton.
function LocateWorms_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to LocateWorms_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global ulcoord
global stitched_image
global wormLoc
global wormIndex
global wormBoundingBox
global scale
global stg
global LocateWormsArea
global LocateWormsStdDev
global ratio_stg2X
global wormData
global gonadNum
global stopSearch
global Gonad1_Loc
global Gonad2_Loc

wormLoc    = [];
wormIndex  = 0;
wormData   = [];
wormBoundingBox = [];
gonadNum   = 1;
stopSearch = 0;
Gonad1_Loc = [];
Gonad2_Loc = [];

disp('Locating gonads');

scale     = 1;
montage2  = imadjust(stitched_image(:,:,1));
montage2  = montage2 < 200; %threshold for intensity
figure, imshow(montage2) %display image
disp('threshold'); %output to terminal

% Parameters for probability distribution of worm area
cutoff    = 2; %determines tightness of threshold for area, cutoff*sigma
mu        = LocateWormsArea; %input from GUI
sigma     = LocateWormsStdDev; %input from GUI

% Format the coordinates
wormLoc   = []; %clear worm locations
wormIndex = 0; % start indexing from zero
centerx   = 2336/2; %determined from screen size of camera
centery   = 1752/2; %determined from screen size of camera

objects = regionprops(montage2, {'Area', 'BoundingBox', 'Centroid'}); %declare region properites of the 
figure, imshow(stitched_image(:,:,1)) %show figure of large stitched image from montage 
numWorms = 0; % reset number of worms to zero
hold on % hold the screen on to process current figure

% Offsets to shift the 2X view so it aligns with the 20X
% When the objectives swith the alignment is not perfect so we adjust with
% an offset
x_offset = 142;  
y_offset = -62; 

% Here we process each object 
for i=1:length(objects)
    if abs(mu - objects(i).Area) <= cutoff*sigma %Does object fit within area cutoff requirements for being a worm?
        numWorms = numWorms + 1; % increment worm number
        x = objects(i).BoundingBox; % define a bounding box around the object
        rect = rectangle('Position', x, ...
                      'EdgeColor','g', 'LineWidth', 1);  %draw a green box on the screen as bounding box
        if numWorms==1,
            wormBoundingBox = [x(1:4)];% if this is first worm set bounding box to first position
        else
            wormBoundingBox = [wormBoundingBox; x(1:4)]; %append each bounding box to the array to store them all for later processing    
        end
   
        movex = round((centerx - (objects(i).Centroid(1)/scale))*ratio_stg2X); % determine the relative X position of the centroid in stage coordinates in the subimage
        movey = round((centery - (objects(i).Centroid(2)/scale))*ratio_stg2X); % determine the relative Y position of the centroid in stage coordinates in the subimage

        wormLoc = cat(1, wormLoc, [ulcoord(1)+movex+x_offset, ulcoord(2)+movey+y_offset]); % calculate and store each actual X,Y worm location in stage coordinates
    end
end
disp('finished worm loc')
sub_img_width = 800; 
sub_img_height = 800;

numWorms = 0;
sub_stg_UpLf = [];


for i=1:length(objects)

     if abs(mu - objects(i).Area) <= cutoff*sigma
         montage_H = size(stitched_image,1)
         montage_W = size(stitched_image,2)
         L = round(objects(i).Centroid(1)/scale - sub_img_width/2);
         R = round(objects(i).Centroid(1)/scale + sub_img_width/2);
         T = round(objects(i).Centroid(2)/scale - sub_img_height/2);
         B = round(objects(i).Centroid(2)/scale + sub_img_height/2);
         [T,B,L,R,adjusted,subSize] = verify_subImage(T,B,L,R,size(stitched_image));
         
         movex = round((centerx - L/scale)*ratio_stg2X); 
         movey = round((centery - T/scale)*ratio_stg2X); 
         sub_stg_UpLf = [ulcoord(1)+movex+x_offset, ulcoord(2)+movey+y_offset]; % Adam
       
         numWorms = numWorms + 1
         w = numWorms
         worm_img{w,1} = stitched_image(T:B,L:R,1);
         pixel = struct('box',[T,B,L,R],'adjusted',adjusted,'subSize',subSize);
         stage = struct('Centroid',wormLoc(w,:),'sub_UpLf',sub_stg_UpLf);
         worm_coords(w,1) = struct('pixel',pixel,'stage',stage);
     end    
end

head_width    = 150;
head_height   = 150;
dtime         = 123; 
mutant_ID     = 001; 
plasmid_ID    = 01; 
wormData.meta = struct('numWorms',numWorms,'DateTime',dtime,'Mutant',mutant_ID,'Plasmid',plasmid_ID)
wormData.data = repmat(struct('img',[],'isWorm',0,'head',[]),numWorms,1);

w = 0;
wormFig = figure;
skelFig = figure;
for i = 1:numWorms

    figure(wormFig);
    imshow(worm_img{i,1});
    response = 0;
    button   = 0;
    isWorm   = 0;
    while response==0
        set(gcf,'Pointer','crosshair');
        k = waitforbuttonpress;

        if k==0
            pointClick = round(get(gca,'CurrentPoint'));
            click_x = pointClick(1,1);
            click_y = pointClick(1,2);
            response = 1;
            isWorm = 1;
            set(gcf,'Pointer','arrow');  
            
            Th = round(click_y-(head_height/2));
            Bh = round(click_y-(head_height/2)) + head_height;
            Lh = round(click_x-(head_width/2));
            Rh = round(click_x-(head_width/2)) + head_width;
            [Th,Bh,Lh,Rh,adjusted_h,subSize_h] = verify_subImage(Th,Bh,Lh,Rh,size(worm_img{i,1}));

            box_h = [Lh, Th, subSize_h(2), subSize_h(1)];
            rect = rectangle('Position', box_h,'EdgeColor','g', 'LineWidth', 1); 
            pause(.5)
 
            head_img = worm_img{i,1}(Th:Bh,Lh:Rh,1);
            wormData.data(i,1).head = struct('img',head_img,'loc',[click_y,click_x],'box',box_h);
            pause(0.1)
        elseif k==1
            response = 1
            isWorm = 0;
            set(gcf,'Pointer','arrow'); 
        else
            disp('If image contains a whole worm, left-click its head. Otherwise, right-click.')
        end
    end
    wormData.data(i,1).isWorm = isWorm;
    wormData.data(i,1).img = worm_img{i,1};
    gonad_width = 150;
    gonad_height = 150;

    display = 1;
    box = cell(2,1);
    gonad_img = cell(2,1);
    if isWorm==1 % or just:     if isWorm
        w = w+1;
        disp('Finding gonads')
        [gonad_x, gonad_y, success, thresh_rec] = find_gonads_now(wormData.data(i,1).img, display,skelFig);
        disp('Gonad search complete')
        Tg1 = round(gonad_y(1)-(gonad_height/2));
        Bg1 = round(gonad_y(1)-(gonad_height/2)) + gonad_height;
        Lg1 = round(gonad_x(1)-(gonad_width/2));
        Rg1 = round(gonad_x(1)-(gonad_width/2)) + gonad_width;
        [Tg1,Bg1,Lg1,Rg1,adjusted_g1,subSize_g1] = verify_subImage(Tg1,Bg1,Lg1,Rg1,size(worm_img{i,1}));
        
        Tg2 = round(gonad_y(2)-(gonad_height/2));
        Bg2 = round(gonad_y(2)-(gonad_height/2)) + gonad_height;
        Lg2 = round(gonad_x(2)-(gonad_width/2));
        Rg2 = round(gonad_x(2)-(gonad_width/2)) + gonad_width;
        [Tg2,Bg2,Lg2,Rg2,adjusted_g2,subSize_g2] = verify_subImage(Tg2,Bg2,Lg2,Rg2,size(worm_img{i,1}));

        box{1} = [Lg1, Tg1, subSize_g1(2), subSize_g1(1)];
        box{2} = [Lg2, Tg2, subSize_g2(2), subSize_g2(1)];
        gonad_img{1} = worm_img{i,1}(Tg1:Bg1,Lg1:Rg1,1);
        gonad_img{2} = worm_img{i,1}(Tg2:Bg2,Lg2:Rg2,1);
        wormData.data(i,1).gonadSearch = struct('success',success,'thresh_rec',thresh_rec);
 
        Pix = worm_coords(i,1).pixel.box;
        centerx; %  = 2336/2; % half of screen width
        centery; %  = 1752/2; % half of screen height
        movex1 = round((centerx - (Pix(3)+gonad_x(1))/scale)*ratio_stg2X); % Adam
        movey1 = round((centery - (Pix(1)+gonad_y(1))/scale)*ratio_stg2X); % Adam
        movex2 = round((centerx - (Pix(3)+gonad_x(2))/scale)*ratio_stg2X); % Adam
        movey2 = round((centery - (Pix(1)+gonad_y(2))/scale)*ratio_stg2X); % Adam
        Gonad1_Loc = cat(1, Gonad1_Loc, [ulcoord(1)+movex1+x_offset, ulcoord(2)+movey1+y_offset]); 
        Gonad2_Loc = cat(1, Gonad2_Loc, [ulcoord(1)+movex2+x_offset, ulcoord(2)+movey2+y_offset]); 

        wormData.data(i,1).Gonads(1) = struct('img',gonad_img{1},'pixel_loc',[gonad_y(1),gonad_x(1)],'box',box{1});
        wormData.data(i,1).Gonads(2) = struct('img',gonad_img{2},'pixel_loc',[gonad_y(2),gonad_x(2)],'box',box{2});
        
        rect = rectangle('Position', box{1},'EdgeColor','g', 'LineWidth', 1);
        rect = rectangle('Position', box{2},'EdgeColor','g', 'LineWidth', 1); 
        key = waitforbuttonpress;
    end
    %=================
end
close(skelFig)
close(wormFig)

% Save only objects verified to be worms by user into wormData.worms
% and wormData.coords
real_idx = find(cat(1,wormData.data.isWorm));
worms = cat(1,wormData.data(real_idx,1));
wormData.worms = worms;

worm_centroid = wormLoc(real_idx,:);

gonad1 = Gonad1_Loc;
gonad2 = Gonad2_Loc;
wormData.coords = struct('worm_centroid',worm_centroid,'gonad1',gonad1,'gonad2',gonad2);

set(handles.totalWorm, 'String', num2str(length(worms)));
wormIndex = 0;
gonadNum = 2;
set(handles.currentWorm, 'String', num2str(wormIndex));

% Save file with worm/gonad data
format shortg
datetime = fix(clock);
format short
dir = 'D:\Adam\CAMI_Data\DataCapture\wormData\';
fname = num2str(datetime,'wormData_%i-%i-%i_%02i-%02i-%02i.mat');
save([dir,fname],'wormData','-v7.3');
disp('Locate gonads complete')


%This function moves the needles back and forth diagonally as it pulses to
%prevent clogging and assist with dispense of plasmid
% --- Executes on button press in WiggleDispense_pushbutton.
function WiggleDispense_pushbutton_Callback(hObject, eventdata, handles)
global stg
global NikonTiScope
global handle
global h
% hObject    handle to WiggleDispense_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles function PlasmidDispense_pushbutton_Callback(hObject, eventdata, handles)

PlasmidDiagLeft_pushbutton_Callback(hObject, eventdata, handles);
PlasmidDiagRight_pushbutton_Callback(hObject, eventdata, handles);
PlasmidDispense_pushbutton_Callback(hObject, eventdata, handles); %dispense
PlasmidDiagLeft_pushbutton_Callback(hObject, eventdata, handles);
PlasmidDiagRight_pushbutton_Callback(hObject, eventdata, handles);
PlasmidDiagRight_pushbutton_Callback(hObject, eventdata, handles);
PlasmidDiagLeft_pushbutton_Callback(hObject, eventdata, handles);
PlasmidDiagRight_pushbutton_Callback(hObject, eventdata, handles);
PlasmidDiagLeft_pushbutton_Callback(hObject, eventdata, handles);
PlasmidDiagRight_pushbutton_Callback(hObject, eventdata, handles);
PlasmidDiagRight_pushbutton_Callback(hObject, eventdata, handles);




function PlasmidPulse_pushbutton_Callback(hObject, eventdata, handles)
%This function dispenses plasmid via pushbutton for the duration of the
%user defined time in milliseconds, here we set default to 100ms
% --- Executes on button press in PlasmidPulse_pushbutton.

%Pushbutton dispenses plasmid from the needle tip for the duration set in
%the input field of the GUI typically 100ms @ 60psi

%The 32bit version of Matlab supports digital outputs but the x64bit
%version does not so we had to make a work-around. We used the x64 version
%to write a variable to a *.mat file that is constantly parsed by the x32
%bit version with a 10ms delay to allow digital output operation. This code
%was developed before the wide adoption of raspberry pi and arduino that
%do this operation well.     
    
global stg
global PlasmidPulseTimeX32 % This variable is used to transfer a value from X64 bit matlab to X32 bit matlab via a saved variable

disp('Plasmid Pulse Begin')
Read_matfile = 1;
PlasmidDispenseTimeX32 = 0;
PlasmidVibrateTimeX32 = 0.00;
PlasmidPulseTimeX32 = 0.1; %default setting 
E = 0;
F = 0;
G = 0;
H = 0;
%save a variable that is then read in X32 bit matlab to output a digital
%signal to the valve
save('C:\Users\CodyGilleland\Desktop\CAMIcode_3_07_2012\PlasmidControllerX32DataTransfer.mat','Read_matfile','PlasmidDispenseTimeX32','PlasmidVibrateTimeX32','PlasmidPulseTimeX32','E','F','G','H');
disp('saved PlasmidControllerX32DataTransfer.mat');
%pause(0.1)
Read_matfile = 0;
PlasmidDispenseTimeX32 = 0;
PlasmidVibrateTimeX32 = 0;
PlasmidPulseTimeX32 = 0;
D = 0;
E = 0;
F = 0;
G = 0;
H = 0;
%PlasmidVibrate_pushbutton_Callback(hObject, eventdata, handles)


% --- Executes on button press in PlasmidNudgeTap_pushbutton.
function PlasmidNudgeTap_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to RotationTest6_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function Well1Strain_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Well1Strain_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Well1Strain_edit as text
%        str2double(get(hObject,'String')) returns contents of Well1Strain_edit as a double

% --- Executes during object creation, after setting all properties.
function Well1Strain_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Well1Strain_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Well1Plasmid_Callback(hObject, eventdata, handles)
% hObject    handle to Well1Plasmid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Well1Plasmid as text
%        str2double(get(hObject,'String')) returns contents of Well1Plasmid as a double


% --- Executes during object creation, after setting all properties.
function Well1Plasmid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Well1Plasmid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Well2Strain_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Well2Strain_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Well2Strain_edit as text
%        str2double(get(hObject,'String')) returns contents of Well2Strain_edit as a double


% --- Executes during object creation, after setting all properties.
function Well2Strain_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Well2Strain_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Well2Plasmid_Callback(hObject, eventdata, handles)
% hObject    handle to Well2Plasmid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Well2Plasmid as text
%        str2double(get(hObject,'String')) returns contents of Well2Plasmid as a double


% --- Executes during object creation, after setting all properties.
function Well2Plasmid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Well2Plasmid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Well3Strain_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Well3Strain_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Well3Strain_edit as text
%        str2double(get(hObject,'String')) returns contents of Well3Strain_edit as a double


% --- Executes during object creation, after setting all properties.
function Well3Strain_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Well3Strain_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Well3Plasmid_Callback(hObject, eventdata, handles)
% hObject    handle to Well3Plasmid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Well3Plasmid as text
%        str2double(get(hObject,'String')) returns contents of Well3Plasmid as a double


% --- Executes during object creation, after setting all properties.
function Well3Plasmid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Well3Plasmid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Well4Strain_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Well4Strain_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Well4Strain_edit as text
%        str2double(get(hObject,'String')) returns contents of Well4Strain_edit as a double


% --- Executes during object creation, after setting all properties.
function Well4Strain_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Well4Strain_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Well4Plasmid_Callback(hObject, eventdata, handles)
% hObject    handle to Well4Plasmid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Well4Plasmid as text
%        str2double(get(hObject,'String')) returns contents of Well4Plasmid as a double


% --- Executes during object creation, after setting all properties.
function Well4Plasmid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Well4Plasmid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function WellPlateID_edit_Callback(hObject, eventdata, handles)
% hObject    handle to WellPlateID_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of WellPlateID_edit as text
%        str2double(get(hObject,'String')) returns contents of WellPlateID_edit as a double


% --- Executes during object creation, after setting all properties.
function WellPlateID_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WellPlateID_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in Well1_checkbox.
function Well1_checkbox_Callback(hObject, eventdata, handles)
%This function allows the user to select the well of interest in the well
%plate. The 'wellnumber' global variable is then use to select the proper
%start and endpoints for each well plate 

global wellnumber

% hObject    handle to Well1_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


get(hObject,'Value')
% Hint: get(hObject,'Value') returns toggle state of checkbox3

if (get(hObject,'Value') == get(hObject,'Max'))
   
    disp('well1 box checked')
    wellnumber = 1   
else
    disp('well1 box unchecked')
    %handles.answer=0;
end
guidata(hObject,handles);



% --- Executes on button press in well2_checkbox.
function well2_checkbox_Callback(hObject, eventdata, handles)
%This function allows the user to select the well of interest in the well
%plate. The 'wellnumber' global variable is then use to select the proper
%start and endpoints for each well plate 
global wellnumber
% hObject    handle to well2_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
get(hObject,'Value')
% Hint: get(hObject,'Value') returns toggle state of checkbox3

if (get(hObject,'Value') == get(hObject,'Max'))
    %handles.answer=1;
    disp('well2 box checked')
    wellnumber = 2
else
    disp('well2 box unchecked')
    %handles.answer=0;
end
guidata(hObject,handles);


% --- Executes on button press in well3_checkbox.
function well3_checkbox_Callback(hObject, eventdata, handles)
%This function allows the user to select the well of interest in the well
%plate. The 'wellnumber' global variable is then use to select the proper
%start and endpoints for each well plate 
global wellnumber
% hObject    handle to well3_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
get(hObject,'Value')
% Hint: get(hObject,'Value') returns toggle state of checkbox3

if (get(hObject,'Value') == get(hObject,'Max'))
    %handles.answer=1;
    disp('well3 box checked')
    wellnumber = 3
else
    disp('well3 box unchecked')
    %handles.answer=0;
end
guidata(hObject,handles);



% Hint: get(hObject,'Value') returns toggle state of well3_checkbox
% --- Executes on button press in well4_checkbox.
function well4_checkbox_Callback(hObject, eventdata, handles)
%This function allows the user to select the well of interest in the well
%plate. The 'wellnumber' global variable is then use to select the proper
%start and endpoints for each well plate 
global wellnumber
% hObject    handle to well4_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of well4_checkbox
get(hObject,'Value')
% Hint: get(hObject,'Value') returns toggle state of checkbox3

if (get(hObject,'Value') == get(hObject,'Max'))
    %handles.answer=1;
    disp('well4 box checked')
    wellnumber = 4
else
    disp('well4 box unchecked')
    %handles.answer=0;
end
guidata(hObject,handles);



function edit25_Callback(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit25 as text
%        str2double(get(hObject,'String')) returns contents of edit25 as a double


% --- Executes during object creation, after setting all properties.
function edit25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in AutomatedSetup_pushbutton.
function AutomatedSetup_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to AutomatedSetup_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in RotationTest8_pushbutton.
function RotationTest8_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to RotationTest8_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AVT_Vid
global src
global cameraBinning
global CameraInformation
global img
global previewHandlesImage
global h
global toggle
global wormLoc
global wormIndex
global imageDIRECTORYNAME
global montagevidsettings
global ch
global previewHandlesImage
global previewHandles


% hObject    handle to openAVTvideo_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cameraBinning =2;
if cameraBinning==2
    Binning='MONO16_1024x1024';
elseif cameraBinning==4
    Binning='MONO16_512x512';
elseif cameraBinning==8
    Binning='MONO16_256x256';
else
    Binning='MONO16_2048x2048';
end

%CameraInformation = imaqhwinfo('avtmatlabadaptor_r2010a');
CameraInformation = imaqhwinfo('avtmatlabadaptor64_r2009b');
%AVT_Vid = videoinput('avtmatlabadaptor_r2010a', 1, 'Mono8_2336x1752_Binning_1x1');
AVT_Vid = videoinput('avtmatlabadaptor64_r2009b', 1, 'Mono8_2336x1752_Binning_1x1');


src = getselectedsource(AVT_Vid);
imaqmem(10000000000);
AVT_Vid.FramesPerTrigger = 1;
AVT_Vid.ROIPosition = [568 276 1200 1200];
%AVT_Vid.ROIPosition = [1 1 2334 1750];
%AVT_Vid.ROIPosition = [0 0 1168 876];
AVT_Vid.ReturnedColorspace = 'grayscale';

h = CAMIvideoAVT
ch = get(h,'children')
previewHandles = findobj(ch,'tag','VideoAxesCAMI')
%previewHandlesImage = image(zeros(1024),'parent',previewHandles)
%set(previewHandlesImage,'cdata',ones(1024))
previewHandlesImage = image(zeros(1200),'parent',previewHandles)
%previewHandlesImage = image(zeros(2334,1750),'parent',previewHandles)

%previewHandlesImage(600,600) = 255;
set(previewHandlesImage,'cdata',ones(1200))
%set(previewHandlesImage,'cdata',ones(2334,1750))

set(h,'WindowScrollWheelFcn',@ScrollWheelZ)
get(h,'WindowScrollWheelFcn')


%set(h,'WindowButtonDownFcn',@MouseWindowClick)

CenterMarkHandlesImage = previewHandlesImage;
wormLoc = [];
toggle = true;
wormIndex = 0;
preview(AVT_Vid, CenterMarkHandlesImage)
HIMAGE = preview(AVT_Vid, CenterMarkHandlesImage);
setappdata(HIMAGE, 'UpdatePreviewWindowFcn', @displayCenterMark);

% Set directory automatically with today's date
% hObject    handle to SetDirectory_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetDirectoryTITLE = 'Set Image Directory';
SetDirectorySTARTPATH = 'C:\Documents and Settings\cgilleland\Desktop\CAMI_ImageProcessing';
% Make the date
mkdir(SetDirectorySTARTPATH, date);
imageDIRECTORYNAME = [SetDirectorySTARTPATH '\' date];
montagevidsettings = get(src);


% --- Executes on button press in RotationTest13_pushbutton.
function RotationTest13_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to RotationTest13_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in RotationTest14_pushbutton.
function RotationTest14_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to RotationTest14_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Video Mosaicking
% Video mosaicking is the process of stitching video frames together to
% form a comprehensive view of the scene. The resulting mosaic image is a
% compact representation of the video data, which is often used in video
% compression and surveillance applications.

%   Copyright 2004-2010 The MathWorks, Inc.
%   $Revision: 1.1.6.7.2.1 $  $Date: 2011/07/14 20:48:51 $
global frames
%% Introduction
% This demo illustrates how to use the CornerDetector System object, the
% GeometricTransformEstimator System object, the AlphaBlender System object,
% and the GeometricTransformer System object to create a mosaic image from a
% video sequence. First, the demo identifies the corners in the first
% (reference) and second video frame. Then, it calculates the projective
% transformation matrix that best describes the transformation between
% corner positions in these frames. Finally, the demo overlays the second
% image onto the first image. The demo repeats this process to create a
% mosaic image of the video scene.

%% Initialization
% Use these next sections of code to initialize the required System objects.
featWinLen   = 9;            % Length of feature window 
maxNumPoints = int32(75);    % Maximum number of points 
sizePano     = [400 680];
origPano     = [5 60];
classToUse   = 'single';

%%
% Create a VideoFileReader System object to read video from a file. 
% hsrc = vision.VideoFileReader('vipmosaicking.avi', 'ImageColorSpace', ...
%     'RGB', 'PlayCount', 1);

% hsrc = vision.VideoFileReader('frames', 'ImageColorSpace', ...
%     'RGB', 'PlayCount', 1);
hsrc = frames;


%%
% Create a ColorSpaceConverter System object to convert the RGB image to
% intensity format.
hcsc = vision.ColorSpaceConverter('Conversion', 'RGB to intensity');

%%
% Create a CornerDetector System object to identify the corner locations of
% current and the previous video frames. 
 hcornerdet = vision.CornerDetector( ...
    'Method', 'Local intensity comparison (Rosen & Drummond)', ...
    'IntensityThreshold', 0.1, 'MaximumCornerCount', maxNumPoints, ...
    'CornerThreshold', 0.001, 'NeighborhoodSize', [21 21]);
                
%%
% Create an GeometricTransformEstimator System object to implement the
% RANSAC (RANdom SAmple Consensus) algorithm. This System object verifies
% that the corners have been properly identified. It also calculates the
% transformation matrix that maps the corner positions in the current frame
% to the corner positions in previous frame.
hestgeotform = vision.GeometricTransformEstimator;
    
%%
% Create a GeometricTransformer System object.
hgeotrans = vision.GeometricTransformer( ...
    'OutputImagePositionSource', 'Property', 'ROIInputPort', true, ...
    'OutputImagePosition', [-origPano sizePano]);

%%
% Create a AlphaBlender System object to overlay the consecutive video
% frames to produce the panorama.
halphablender = vision.AlphaBlender( ...
    'Operation', 'Binary mask', 'MaskSource', 'Input port');

%%
% Create a MarkerInserter System object to draw the corner locations in each
% video frame.
hdrawmarkers = vision.MarkerInserter('Shape', 'Circle', ...
    'BorderColor', 'Custom', 'CustomBorderColor', [1 0 0]);           
                        
%%
% Create two VideoPlayer System objects, one to display the corners of each
% frame and other to draw the panorama.

hVideo1 = vision.VideoPlayer('Name', 'Corners');
hVideo1.Position(1) = hVideo1.Position(1) - 350;                        

hVideo2 = vision.VideoPlayer('Name', 'Mosaic');
hVideo2.Position(1) = hVideo1.Position(1) + 400;
hVideo2.Position([3 4]) = [750 500];

%% Stream Processing Loop
% Create a processing loop to create panorama from the input video. This
% loop uses the System objects you instantiated above.

points   = zeros([0 2], classToUse);
features = zeros([0 featWinLen^2], classToUse);

while ~isDone(hsrc)
    % Save the points and features computed from the previous image
    pointsPrev   = points;
    featuresPrev = features;
    
    % To speed up mosaicking, select and process every 5th image
    for i = 1:5
        rgb = step(hsrc);
        if isDone(hsrc)
            break;
        end
    end
    I = step(hcsc, rgb);
    roi = int32([2 2 size(I, 2)-2 size(I, 1)-2]);

    % Detect corners in the image
    cornerPoints = step(hcornerdet, I);
    cornerPoints = cast(cornerPoints, classToUse);
    
    % Extract the features for the corners
    [features, points] = extractFeatures(I, ...
        cornerPoints, 'BlockSize', featWinLen);
    
    % Match features computed from the current and the previous images
    indexPairs = matchFeatures(features, featuresPrev);
    
    % Check if there are enough corresponding points in the current and the
    % previous images
    isMatching = false;
    if size(indexPairs, 1) > 2
        matchedPoints     = points(indexPairs(:, 1), :);
        matchedPointsPrev = pointsPrev(indexPairs(:, 2), :);
        
        % Find corresponding points in the current and the previous images,
        % and compute a geometric transformation from the corresponding
        % points
        [tform, inlier] = step(hestgeotform, matchedPoints, matchedPointsPrev);
          
        if sum(inlier) >= 4
            % If there are at least 4 corresponding points, we declare the
            % current and the previous images matching
            isMatching = true;
        end
    end
    
    if isMatching
        % If the current image matches with the previous one, compute the
        % transformation for mapping the current image onto the mosaic
        % image
        xtform = xtform * [tform, [0 0 1]'];
    else
        % If the current image does not match the previous one, reset the
        % transformation and the mosaic image
        xtform = eye(3, classToUse);
        mosaic = zeros([sizePano,3], classToUse);
    end

    % Display the current image and the corner points
    cornerImage = step(hdrawmarkers, rgb, cornerPoints);
    step(hVideo1, cornerImage);
    
    % Warp the current image onto the mosaic image
    transformedImage = step(hgeotrans, rgb, xtform, roi);
    mosaic = step(halphablender, mosaic, transformedImage, ...
        transformedImage(:,:,1)>0);
    step(hVideo2, mosaic);
end

release(hsrc);

%%
% The Corners window displays the input video along with the detected
% corners and Mosaic window displays the panorama created from the input
% video.

%displayEndOfDemoMessage(mfilename)


% --- Executes on button press in RotationTest7_pushbutton.
function RotationTest7_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to RotationTest7_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stg
global AVT_Vid
global NikonTiScope
global plate

% Resets the exposure time, frame rate for montage building

tic
Objective2X_pushbutton_Callback();
pause(0.5)

NikonTiScope.ZDrive.Position = 1820*40;
pause(.5);

clear_stage_buffer();
fprintf(stg,'SMS,200'); %XY max speed, u sets to microns per second speed
fscanf(stg);

% Initialize video
triggerconfig(AVT_Vid, 'manual');
FPT = 280; 
set(AVT_Vid, 'FramesPerTrigger', FPT);
AVT_Vid.ROIPosition = [568 276 1200 1200];

% Default to well1
currentY = 71746;
currentX = 111050;

clear_stage_buffer();
fprintf(stg,[ 'G,' num2str(currentX) ', ' num2str(currentY) ',0']);
fscanf(stg);
% Arbritray long pause
pause(8);

% Calibrated so our montage speed works out well
fprintf(stg,'SMS,195'); 
%fprintf(stg,'SMS,15000,u'); 
%10000 close
fscanf(stg);

% Mark's advice on helping to fix serial COM
try
    fread(stg, stg.BytesAvailable);
catch
    disp('No!');
end


montage = [];

for row=1:7
    %7 rows means 7 screen sizes and it does 2 plate well rows
    
    start(AVT_Vid);
    row_img = [];
    if mod(row,2) ~= 0
                
        clear_stage_buffer();
        fprintf(stg,[ 'G,' num2str(35777) ', ' num2str(currentY) ',0']);
        fscanf(stg);
        trigger(AVT_Vid);
        %pause(FPT/30);
        [frames timestamps] = getdata(AVT_Vid);
        size(frames);
        for col=9:8:FPT-8%min(17*8,80)
            row_img = [row_img frames(:, :, 1, col)];
        end
        
        currentX = 35777;
        
    else
        clear_stage_buffer();
        fprintf(stg,[ 'G,' num2str(111050) ', ' num2str(currentY) ',0']);
        fscanf(stg);
        
        trigger(AVT_Vid);
        %pause(FPT/30);
        [frames timestamps] = getdata(AVT_Vid);
        for col=9:8:FPT-8%136
            row_img = [frames(:, :, 1, col) row_img];
        end  
        
        currentX = 111050;
    end

    
    currentY = currentY - 2199;

    montage = [montage; row_img];
    
    clear_stage_buffer();
    fprintf(stg,[ 'G,' num2str(currentX) ', ' num2str(currentY) ',0']);
    fscanf(stg);
    pause(1);
end

% Do some processing
figure,imshow(montage)
plate = imresize(montage, .02);


% --- Executes on button press in RotationTest10_pushbutton.
function RotationTest10_pushbutton_Callback(hObject, eventdata, handles)
global plate
global img_off
% hObject    handle to RotationTest10_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plate3 = plate(10:end-10, 10:end-10);

plate2 = double(plate3);
plate2 = plate2 < 230;

figure,imshow(plate);
%figure, imshow(plate3)
%figure,imshow(plate2);

% Show top and bottom halves
[w h] = size(plate2);
top_plate = plate2(1:ceil(w/2), :);
top_plate = bwareaopen(top_plate, 10);
bot_plate = plate2(ceil(w/2)+1:end, :);
bot_plate = bwareaopen(bot_plate, 10);

%figure,imshow(top_plate);
%figure, imshow(bot_plate);

% find left most on both top and bottom plate
[top_row top_col] = find(top_plate==1);
top_most_left = min(top_col);
top_most_left = top_most_left(end)

[bot_row bot_col] = find(bot_plate==1);
bot_most_left = min(bot_col);
bot_most_left = bot_most_left(end)

% Test to see which direction we have to shift
aligned_image = zeros(w, h);
if top_most_left < bot_most_left
    aligned_image(1:ceil(w/2), :) = double(plate3(1:ceil(w/2), :));
    aligned_image(ceil(w/2)+1:end, :) = [double(plate3(ceil(w/2)+1:end, bot_most_left-top_most_left+3:end)) zeros(length(plate3(ceil(w/2)+1:end, 1)), bot_most_left-top_most_left+2)]; 
elseif top_most_left > bot_most_left
    aligned_image(1:ceil(w/2), :) = double(plate3(1:ceil(w/2), :));
    aligned_image(ceil(w/2)+1:end, :) = [zeros(length(plate3(ceil(w/2)+1:end, 1)), top_most_left-bot_most_left) double(plate3(ceil(w/2)+1:end, 1:end-(top_most_left-bot_most_left)))]; 
    img_off = top_most_left-bot_most_left;
    img_off = img_off * 100/2;
else
    aligned_img = plate3;
end

figure,imshow(uint8(aligned_image));

% --- Executes on button press in RotationTest15_pushbutton.
function RotationTest15_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to RotationTest15_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in RotationTest16_pushbutton.
function RotationTest16_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to RotationTest16_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






% --- Executes on button press in RotationTest9_pushbutton.
function RotationTest9_pushbutton_Callback(hObject, eventdata, handles)



% --- Executes on button press in RotationTest12_pushbutton.
function RotationTest12_pushbutton_Callback(hObject, eventdata, handles)


% --- Executes on button press in RotationTest11_pushbutton.
function RotationTest11_pushbutton_Callback(hObject, eventdata, handles)


% --- Executes on button press in ChangeWellPlate_pushbutton.
function ChangeWellPlate_pushbutton_Callback(hObject, eventdata, handles)
%This function allows the user to remove/insert the well plate
%The manipulator is moved to the home position and the stage is moved
%toward the user for easy removal. This is key to ensure that the needle is
%not broken

% hObject    handle to ChangeWellPlate_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global NikonTiScope
global stg
global AVT_Vid
global h
global ClickScreenX
global ClickScreenY
global ChangeDishFlag
ChangeDishFlag = 1
clear_stage_buffer();
fprintf(stg,'O,100'); %XY joystick max speed conversion
fscanf(stg);
fprintf(stg,'SAS,100'); % XY acceleration
fscanf(stg);
fprintf(stg,'SMS,200'); %XY max speed
fscanf(stg);
fprintf(stg,'SCS,100'); %XY S-curve, rate of change of acceleration
fscanf(stg);
fprintf(stg,'BLSH, 0')%XY Backlash, 0=off, 1=n
backlash = fscanf(stg);

% Move Manipulator to home position
CheckManipZ = manipControl('getPosition',0,1);
pause(0.5)
if (CheckManipZ(3) > 4000*16) 
    manipControl('changePosition',0,1,2000*16,24000*16,16*4000)
    pause(5)
   else
    manipControl('changePosition',0,1,2000,16*24000,4000*16)
    pause(0.5)
end

% Move stage to appropriate corner
clear_stage_buffer();
fprintf(stg,[ 'G,' num2str(114798) ', ' num2str(71447) ',0']);%lower XY to prevent hitting encoder limits
fscanf(stg);

%reset stage to normal settings
fprintf(stg,'O,100');  %XY joystick max speed conversion
fscanf(stg);
fprintf(stg,'SAS,75'); % XY acceleration
fscanf(stg);
fprintf(stg,'SMS,75'); %XY max speed
fscanf(stg);
fprintf(stg,'SCS,75'); %XY S-curve, rate of change of acceleration
fscanf(stg);
fprintf(stg,'BLSH, 0') %XY Backlash, 0=off, 1=n
backlash = fscanf(stg);



function LocateWormsStdDev_editText_Callback(hObject, eventdata, handles)
% hObject    handle to LocateWormsStdDev_editText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LocateWormsStdDev_editText as text
%        str2double(get(hObject,'String')) returns contents of LocateWormsStdDev_editText as a double
global LocateWormsStdDev

input = str2num(get(hObject,'String'));

%checks to see if input is empty. if so, default input1_editText to zero
if (isempty(input))
     set(hObject,'String','0');
end
LocateWormsStdDevinput = get(handles.LocateWormsStdDev_editText,'String');
% a and b are variables of Strings type, and need to be converted
% to variables of Number type before they can be added together
LocateWormsStdDev = str2num(LocateWormsStdDevinput)
guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function LocateWormsStdDev_editText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LocateWormsStdDev_editText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function LocateWormsArea_editText_Callback(hObject, eventdata, handles)
% hObject    handle to LocateWormsArea_editText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LocateWormsArea_editText as text
%        str2double(get(hObject,'String')) returns contents of LocateWormsArea_editText as a double
global LocateWormsArea

input = str2num(get(hObject,'String'));

%checks to see if input is empty. if so, default input1_editText to zero
if (isempty(input))
     set(hObject,'String','0');
end
LocateWormsAreainput = get(handles.LocateWormsArea_editText,'String');
% a and b are variables of Strings type, and need to be converted
% to variables of Number type before they can be added together
LocateWormsArea = str2num(LocateWormsAreainput)
guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function LocateWormsArea_editText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LocateWormsArea_editText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PlasmidTest1_pushbutton.
function PlasmidTest1_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to PlasmidTest1_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in PlasmidTest2_pushbutton.
function PlasmidTest2_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to PlasmidTest2_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in PlasmidTest3_pushbutton.
function PlasmidTest3_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to PlasmidTest3_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in PlasmidTest4_pushbutton.
function PlasmidTest4_pushbutton_Callback(hObject, eventdata, handles)


% --- Executes on button press in PlasmidTest5_pushbutton.
function PlasmidTest5_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to PlasmidTest5_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% % --- Executes on button press in video_sweep_test.
% function video_sweep_test_pushbutton_Callback(hObject, eventdata, handles)
% % hObject    handle to video_sweep_test_pushbutton (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
%data = load([Adams_Dir,'\img_correction.mat']);

global ulcoord
global stitched_image
global wormLoc
wormLoc = [];
global wormIndex
wormIndex = 0;
global wormBoundingBox
wormBoundingBox = [];
global scale
global stg
global LocateWormsArea
global LocateWormsStdDev
global ratio_stg2X

global wormData
global gonadNum
global stopSearch
global Gonad1_Loc
global Gonad2_Loc
wormData = [];
gonadNum = 1;
stopSearch = 0;
Gonad1_Loc = [];
Gonad2_Loc = [];


disp('Locating gonads');
%data = load('C:\Users\CodyGilleland\Desktop\JAMES_montage_image_9_10_2012.mat');
%montage_gonads = imread('montage_imageAVT_October_12_2011_ 9_26_58_531_PM.tif');

%stitched_image = data.stitched_image;

%disp('testvar');
%figure, imshow(montage_gonads(:,:,1))

% data = load('atlas_041.mat');
%data.atlas;
scale = 1;
% montage2 = data.atlas(:,:,1);
% montage2 = imadjust(montage2);
montage2 = imadjust(stitched_image(:,:,1));
montage2 = montage2 < 200;
% figure, imshow(montage2)

% Parameters for probability distribution
%{
mu = 4000;
sigma = 250;
cutoff = 2;
%}

% 
% mu = 9000;
% sigma = 2000;
cutoff = 2;
mu = LocateWormsArea;
sigma = LocateWormsStdDev;


% Format the coordinates
wormLoc = [];
wormIndex = 0; %
% centerx = 600;
% centery= 600;
centerx =2336/2; % Adam
centery = 1752/2; % Adam

objects = regionprops(montage2, {'Area', 'BoundingBox', 'Centroid'});
figure, imshow(stitched_image(:,:,1))
% figure, imshow(data.atlas(:,:,1));

numWorms = 0;
hold on

% Offsets to shift the 2X view so it aligns with the 20X
x_offset = 142; % Adam
y_offset = -62; % Adam


for i=1:length(objects)
    if abs(mu - objects(i).Area) <= cutoff*sigma
        numWorms = numWorms + 1;
        x = objects(i).BoundingBox;
        rect = rectangle('Position', x, ...
                      'EdgeColor','g', 'LineWidth', 1); 
        if numWorms==1,
            wormBoundingBox = [x(1:4)];
        else
            wormBoundingBox = [wormBoundingBox; x(1:4)];    
        end
 
        movex = round((centerx - (objects(i).Centroid(1)/scale))*ratio_stg2X); % Adam
        movey = round((centery - (objects(i).Centroid(2)/scale))*ratio_stg2X); % Adam

        wormLoc = cat(1, wormLoc, [ulcoord(1)+movex+x_offset, ulcoord(2)+movey+y_offset]); % Adam
    end
end
disp('finished worm loc')
sub_img_width = 800;
sub_img_height = 800;

numWorms = 0;
sub_stg_UpLf = [];
% worm_img = cell(3,3);
for i=1:length(objects)
%     disp('getting images');
     if abs(mu - objects(i).Area) <= cutoff*sigma
         montage_H = size(stitched_image,1)
         montage_W = size(stitched_image,2)
         L = round(objects(i).Centroid(1)/scale - sub_img_width/2);
         R = round(objects(i).Centroid(1)/scale + sub_img_width/2);
         T = round(objects(i).Centroid(2)/scale - sub_img_height/2);
         B = round(objects(i).Centroid(2)/scale + sub_img_height/2);
         [T,B,L,R,adjusted,subSize] = verify_subImage(T,B,L,R,size(stitched_image));
         
         movex = round((centerx - L/scale)*ratio_stg2X); % Adam
         movey = round((centery - T/scale)*ratio_stg2X); % Adam

         %sub_stg_UpLf = cat(1,sub_stg_UpLf, [ulcoord(1)+movex+x_offset, ulcoord(2)+movey+y_offset]); % Adam
         sub_stg_UpLf = [ulcoord(1)+movex+x_offset, ulcoord(2)+movey+y_offset]; % Adam

         
         numWorms = numWorms + 1
         w = numWorms
         worm_img{w,1} = stitched_image(T:B,L:R,1);
         pixel = struct('box',[T,B,L,R],'adjusted',adjusted,'subSize',subSize);
         stage = struct('Centroid',wormLoc(w,:),'sub_UpLf',sub_stg_UpLf);
         worm_coords(w,1) = struct('pixel',pixel,'stage',stage);
%          figure, imshow(worm_img{w,1});
     end    
    % [gonadxtest, gonadytest] = find_gonads(stitched_image((objects(i).Centroid(1)/scale -centerx,(objects(i).Centroid(1)/scale-centery, (objects(i).Centroid(1)/scale+centerx, (objects(i).Centroid(1)/scale+centery) (,1)
     %numworms = 
     %gonadlocations(i) =  [gonadxtest, gonadytest]
end




head_width = 150;
head_height = 150;

dtime = 123; %===========? replace
mutant_ID = 001; %===========? replace
plasmid_ID = 01; %===========? replace
wormData.meta = struct('numWorms',numWorms,'DateTime',dtime,'Mutant',mutant_ID,'Plasmid',plasmid_ID)
wormData.data = repmat(struct('img',[],'isWorm',0,'head',[]),numWorms,1);




w = 0;
wormFig = figure;
skelFig = figure;
for i = 1:numWorms
%     if stopSearch
%         stopNum = i;
%         break
%     end
    figure(wormFig);
    imshow(worm_img{i,1});
    response = 0;
    button = 0;
    isWorm = 0;
    while response==0
        set(gcf,'Pointer','crosshair');
%         [click_x, click_y, button] = ginput(1);
        k = waitforbuttonpress;
%         if stopSearch
%             stopNum = i;
%             break
%         end
        if k==0
            pointClick = round(get(gca,'CurrentPoint'));
            click_x    = pointClick(1,1);
            click_y    = pointClick(1,2);
            response   = 1;
            isWorm     = 1;
            set(gcf,'Pointer','arrow');  
            
            Th = round(click_y-(head_height/2));
            Bh = round(click_y-(head_height/2)) + head_height;
            Lh = round(click_x-(head_width/2));
            Rh = round(click_x-(head_width/2)) + head_width;
            [Th,Bh,Lh,Rh,adjusted_h,subSize_h] = verify_subImage(Th,Bh,Lh,Rh,size(worm_img{i,1}));

            box_h = [Lh, Th, subSize_h(2), subSize_h(1)];
            rect = rectangle('Position', box_h,'EdgeColor','g', 'LineWidth', 1); 
            pause(.5)
           
            head_img = worm_img{i,1}(Th:Bh,Lh:Rh,1);
            wormData.data(i,1).head = struct('img',head_img,'loc',[click_y,click_x],'box',box_h);
            pause(0.1)
        elseif k==1
            response = 1
            isWorm = 0;
            set(gcf,'Pointer','arrow'); 
        else
            disp('If image contains a whole worm, left-click its head. Otherwise, right-click.')
        end
    end
    wormData.data(i,1).isWorm = isWorm;
    wormData.data(i,1).img = worm_img{i,1};

    
    % Should be incorporated into above loop ---->> Turn into function call
    %=================
    gonad_width  = 150;
    gonad_height = 150;
    display      = 1;
    box          = cell(2,1);
    gonad_img    = cell(2,1);
    if isWorm==1 % or just:     if isWorm
        w = w+1;
        disp('Finding gonads')
        [gonad_x, gonad_y, success, thresh_rec] = find_gonads_now(wormData.data(i,1).img, display,skelFig);
        disp('Gonad search complete')
        Tg1 = round(gonad_y(1)-(gonad_height/2));
        Bg1 = round(gonad_y(1)-(gonad_height/2)) + gonad_height;
        Lg1 = round(gonad_x(1)-(gonad_width/2));
        Rg1 = round(gonad_x(1)-(gonad_width/2)) + gonad_width;
        [Tg1,Bg1,Lg1,Rg1,adjusted_g1,subSize_g1] = verify_subImage(Tg1,Bg1,Lg1,Rg1,size(worm_img{i,1}));
        
        Tg2 = round(gonad_y(2)-(gonad_height/2));
        Bg2 = round(gonad_y(2)-(gonad_height/2)) + gonad_height;
        Lg2 = round(gonad_x(2)-(gonad_width/2));
        Rg2 = round(gonad_x(2)-(gonad_width/2)) + gonad_width;
        [Tg2,Bg2,Lg2,Rg2,adjusted_g2,subSize_g2] = verify_subImage(Tg2,Bg2,Lg2,Rg2,size(worm_img{i,1}));
   
        box{1} = [Lg1, Tg1, subSize_g1(2), subSize_g1(1)];
        box{2} = [Lg2, Tg2, subSize_g2(2), subSize_g2(1)];
        gonad_img{1} = worm_img{i,1}(Tg1:Bg1,Lg1:Rg1,1);
        gonad_img{2} = worm_img{i,1}(Tg2:Bg2,Lg2:Rg2,1);
        wormData.data(i,1).gonadSearch = struct('success',success,'thresh_rec',thresh_rec);
        
        Pix = worm_coords(i,1).pixel.box;
        centerx; %  = 2336/2; % Adam
        centery; %  = 1752/2; % Adam
        movex1 = round((centerx - (Pix(3)+gonad_x(1))/scale)*ratio_stg2X); % Adam
        movey1 = round((centery - (Pix(1)+gonad_y(1))/scale)*ratio_stg2X); % Adam
        movex2 = round((centerx - (Pix(3)+gonad_x(2))/scale)*ratio_stg2X); % Adam
        movey2 = round((centery - (Pix(1)+gonad_y(2))/scale)*ratio_stg2X); % Adam
        Gonad1_Loc = cat(1, Gonad1_Loc, [ulcoord(1)+movex1+x_offset, ulcoord(2)+movey1+y_offset]); 
        Gonad2_Loc = cat(1, Gonad2_Loc, [ulcoord(1)+movex2+x_offset, ulcoord(2)+movey2+y_offset]); 
        wormData.data(i,1).Gonads(1) = struct('img',gonad_img{1},'pixel_loc',[gonad_y(1),gonad_x(1)],'box',box{1});
        wormData.data(i,1).Gonads(2) = struct('img',gonad_img{2},'pixel_loc',[gonad_y(2),gonad_x(2)],'box',box{2});
        
   

        rect = rectangle('Position', box{1},'EdgeColor','g', 'LineWidth', 1);
        rect = rectangle('Position', box{2},'EdgeColor','g', 'LineWidth', 1); 
        key = waitforbuttonpress;
    end
    %=================
end
close(skelFig)
close(wormFig)

% Save only objects verified to be worms by user into wormData.worms
% and wormData.coords
real_idx = find(cat(1,wormData.data.isWorm));
worms = cat(1,wormData.data(real_idx,1));
wormData.worms = worms;
worm_centroid = wormLoc(real_idx,:);
gonad1 = Gonad1_Loc;
gonad2 = Gonad2_Loc;
wormData.coords = struct('worm_centroid',worm_centroid,'gonad1',gonad1,'gonad2',gonad2);

set(handles.totalWorm, 'String', num2str(length(worms)));
wormIndex = 0;
gonadNum = 2;
set(handles.currentWorm, 'String', num2str(wormIndex));

% Save file with worm/gonad data
format shortg
datetime = fix(clock);
format short
dir = 'D:\Adam\CAMI_Data\DataCapture\wormData\';
fname = num2str(datetime,'wormData_%i-%i-%i_%02i-%02i-%02i.mat');
save([dir,fname],'wormData','-v7.3');

disp('Locate gonads complete')




% --- Executes on button press in PlasmidTest6_pushbutton.
function PlasmidTest6_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to PlasmidTest6_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in PlasmidTest7_pushbutton.
function PlasmidTest7_pushbutton_Callback(hObject, eventdata, handles)


% --- Executes on button press in PlasmidTest8_pushbutton.
function PlasmidTest8_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to PlasmidTest8_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%global stg
% fprintf(stg,'GR,1000,1000');
%fscanf(stg);
% test resolution of the encoders
%fprintf(stg,'pe,?');
%fscanf(stg)

global stg
global stitched_image
global ulcoord
global doneSelecting
global delLast
global wormLoc
global wormIndex
global scale

% Indicators used for selecting positions
delLast = false;
doneSelecting = false;

% Stores the location of the worms, in addition to handles
% of labels created
points = [];
wormLoc = [];
wormIndex = 0;

%Cody changed to match montage image
scale = 1;
%scale = 1;


% Creates pop-out gui
h = figure('Toolbar','none',...
              'Menubar','none','Position',[20 50 2350 1820]);
hlm = imshow(stitched_image);
hSP = imscrollpanel(h,hlm);

set(hSP,'Units','normalized',...
        'Position',[0 .1 1 .9])
set(h,'Position',[20 50 2350 1820])
button1 = uicontrol(h, 'Style', 'pushbutton', 'String', 'Finish', ...
    'Position', [25 25 50 20], 'Callback', @save_coord)
button2 = uicontrol(h, 'Style', 'pushbutton', 'String', 'Delete Last Point', ...
    'Position', [0 0 100 20], 'Callback', @delete_point)

hMagBox = immagbox(h,hlm);
pos = get(hMagBox,'Position');
set(hMagBox,'Position',[0 0 pos(3) pos(4)])
imoverview(hlm)
api = iptgetapi(hSP);
%Get the current magnification and position.

mag = api.getMagnification();
r = api.getVisibleImageRect();
%View the top left corner of the image.

api.setVisibleLocation(0.5,0.5)
%Change the magnification to the value that just fits.

api.setMagnification(api.findFitMag())
%Zoom in to 1600% on the dark spot.

api.setMagnificationAndCenter(0.25,200,200)
% pause(2)
% r1 = api.getVisibleImageRect()
% api.setMagnificationAndCenter(0.25,1400,400)
% pause(2)
% r2 = api.getVisibleImageRect()
% api.setMagnificationAndCenter(0.25,2600,600)
% pause(2)
% r3 = api.getVisibleImageRect()
% api.setMagnificationAndCenter(0.25,3800,800)
api.setVisibleLocation(500,500)
r4 = api.getVisibleImageRect()
   k = waitforbuttonpress;
set(h,'Pointer','crosshair');

hold on
clicks = [];
while ~doneSelecting
    k = waitforbuttonpress;
    pause(.1);     
    pointer1click = get(gca,'CurrentPoint');
    clickx = pointer1click(1,1)
    clicky = pointer1click(1,2)
    clicks = [clicks; clickx clicky];
    % Ensure we click within the world map
    if clickx > 0 && clickx <= length(stitched_image(1, :)) && ...
            clicky > 0 && clicky <= length(stitched_image(:, 1))
        points(length(points)+1) = ...
             text(clickx, clicky, sprintf('%d', length(points)+1), ...
            'EdgeColor', 'b', 'Color', 'r');
    end

    % We are done selecting worms
    if doneSelecting && k == 0,
        break;
    end
    
    % Deselect worms within the map by deleting the handle
    if delLast && length(points) > 0 && k==0,
        delete(points(end));
        if length(points) > 1,
            points = points(1:end-1);
        else
            points = [];
        end
    end
    delLast = false;
end
hold off

% Convert the selections into points on the stage
for i=1:length(points)
    centerx =600;
    centery = 600;
    %click = get(points(i), 'Position')*(1/scale);
    clickx = clicks(i, 1);
    clicky = clicks(i, 2);
    % movex -415
    % movey -80
    %Cody added fudge factors to correct for mismatch in actual map
    movex = ((centerx - clickx )/1200)*4398*(0.5); %divide by 2 for 2X objective
    movey = ((centery - clicky )/1200)*4398*(0.5)%+14; %divide by 2 for 2X objective
    
    wormLoc = [wormLoc ulcoord(1)+movex ulcoord(2)+movey];
end
wormLoc
set(handles.totalWorm, 'String', num2str(length(wormLoc)/2));
set(handles.currentWorm, 'String', num2str(wormIndex));

% Close the gui
set(gcf,'Pointer','arrow');
close(h)







function AutofocusZCenter_editText_Callback(hObject, eventdata, handles)
% hObject    handle to AutofocusZCenter_editText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AutofocusZCenter
% Hints: get(hObject,'String') returns contents of AutofocusZCenter_editText as text
%        str2double(get(hObject,'String')) returns contents of AutofocusZCenter_editText as a double

global AutofocusZCenter

input = str2num(get(hObject,'String'));

%checks to see if input is empty. if so, default input1_editText to zero
if (isempty(input))
     set(hObject,'String','0');
end
AutofocusZCenterinput = get(handles.AutofocusZCenter_editText,'String');
% a and b are variables of Strings type, and need to be converted
% to variables of Number type before they can be added together
AutofocusZCenter = str2num(AutofocusZCenterinput)*40;
guidata(hObject, handles);





% --- Executes during object creation, after setting all properties.
function AutofocusZCenter_editText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AutofocusZCenter_editText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AutofocusZTravel_editText_Callback(hObject, eventdata, handles)
% hObject    handle to AutofocusZTravel_editText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AutofocusZTravel_editText as text
%        str2double(get(hObject,'String')) returns contents of AutofocusZTravel_editText as a double
global AutofocusZTravel

input = str2num(get(hObject,'String'));

%checks to see if input is empty. if so, default input1_editText to zero
if (isempty(input))
     set(hObject,'String','0');
end
AutofocusZTravelinput = get(handles.AutofocusZTravel_editText,'String');
% a and b are variables of Strings type, and need to be converted
% to variables of Number type before they can be added together
AutofocusZTravel = str2num(AutofocusZTravelinput)*40;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function AutofocusZTravel_editText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AutofocusZTravel_editText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Objective20XDIC_pushbutton.
function Objective20XDIC_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Objective20XDIC_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global NikonTiScope
global stg
global AVT_Vid
global src
global PFSSetOffset
global objective

% hObject    handle to Objective20XFluor_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic
currentObjective = NikonTiScope.Nosepiece.Position.RawValue;
pause(0.1);
NikonTiScope.FilterBlockCassette1.Position = 2;
pause(0.1);
NikonTiScope.CondenserCassette.Position = 5;
pause(0.2);
NikonTiScope.Nosepiece.Position = 6;
objective = 6;
pause(0.1);
pause(0.1);
src.Shutter = 2000; %Shutter 1 -> 4095 range
AVT_Vid.ROIPosition = [0 0 2336 1752];

 switch currentObjective
     case 1
                 NikonTiScope.ZDrive.MoveRelative(1312*40);
             pause(0.1);
%     case 2
%            NikonTiScope.ZDrive.MoveRelative(15*40);       
%             pause(0.1);
%     case 3
%             NikonTiScope.ZDrive.MoveRelative(-80*40);   
%             pause(0.1);
    case 6
            disp('20X Objective already selected')    
%     case 5     
%             disp('No objective is selected')
%     case 4
%             disp('No objective is selected')  
     otherwise
             disp('There is an error loading the 20X objective')
 end
% disp(toc)

currentObjective = NikonTiScope.Nosepiece.Position.RawValue;
pause(0.1);

NikonTiScope.Nosepiece.Position = 6;
pause(0.1);
currentPos = NikonTiScope.ZDrive.Value.RawValue;
pause(0.1);


if ((currentObjective == 6) && (currentPos < 8500*40))
            disp('Perfect Focus: Enabled')
            set(NikonTiScope.PFS.IsEnabled,'RawValue',1)
            set(NikonTiScope.PFS.Position,'RawValue',PFSSetOffset)
            PFS_Enabled = 1   
%             disp('Perfect Focus: Disabled')
%             set(NikonTiScope.PFS.IsEnabled,'RawValue',0)
%             PFS_Enabled = 0       
else
    disp('PFS Error: Please switch to 20X Objective');
end    




function edit32_Callback(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit32 as text
%        str2double(get(hObject,'String')) returns contents of edit32 as a double


% --- Executes during object creation, after setting all properties.
function edit32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%perfect focus unit: set the distance above the glass
function PFSSetOffset_editText_Callback(hObject, eventdata, handles)
% hObject    handle to PFSSetOffset_editText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PFSSetOffset_editText as text
%        str2double(get(hObject,'String')) returns contents of PFSSetOffset_editText as a double
global PFSSetOffset

input = str2num(get(hObject,'String'));

%checks to see if input is empty. if so, default input1_editText to zero
if (isempty(input))
     set(hObject,'String','0');
end
PFSSetOffsetinput = get(handles.PFSSetOffset_editText,'String');
% a and b are variables of Strings type, and need to be converted
% to variables of Number type before they can be added together
PFSSetOffset = str2num(PFSSetOffsetinput)
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function PFSSetOffset_editText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PFSSetOffset_editText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PFSEnabled_checkbox.
function PFSEnabled_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to PFSEnabled_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global PFS_Enabled
global NikonTiScope
global PFSSetOffset
% Hint: get(hObject,'Value') returns toggle state of PFSEnabled_checkbox
currentObjective = NikonTiScope.Nosepiece.Position.RawValue;
pause(0.1);

NikonTiScope.Nosepiece.Position = 6;
pause(0.1);
currentPos = NikonTiScope.ZDrive.Value.RawValue;
pause(0.1);


if ((currentObjective == 6) && (currentPos < 8500*40))
         if (get(hObject,'Value') == get(hObject,'Max'))
            %handles.answer=1;
            disp('Perfect Focus: Enabled')
            set(NikonTiScope.PFS.IsEnabled,'RawValue',1)
            %get(NikonTiScope.PFS.Position,'RawValue')
            set(NikonTiScope.PFS.Position,'RawValue',PFSSetOffset)
            PFS_Enabled = 1   
        else
            disp('Perfect Focus: Disabled')
            set(NikonTiScope.PFS.IsEnabled,'RawValue',0)
            PFS_Enabled = 0   
         end
else
    disp('PFS Error: Please switch to 20X Objective');
end    
guidata(hObject,handles);




% --- Executes on button press in PFSSetOffset_pushbutton.
function PFSSetOffset_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to PFSSetOffset_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global PFSSetOffset
global NikonTiScope

%125units per micron
PFSSetOffset = get(NikonTiScope.PFS.Position,'RawValue')
set(NikonTiScope.PFS.Position,'RawValue',PFSSetOffset)
%set(NikonTiScope.PFS.Position,'RawValue', PFSSetOffset*125)


% --- Executes on button press in CFP_pushbutton.
function CFP_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to CFP_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('CFP Filter Cube');

% --- Executes on button press in YFP_pushbutton.
function YFP_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to YFP_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('YFP Filter Cube');


% --- Executes on button press in StopVideo_pushbutton_pushbutton.
function StopVideo_pushbutton_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to StopVideo_pushbutton_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in StartVideo_pushbutton.
function StartVideo_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to StartVideo_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function StartTimedVideo_editText_Callback(hObject, eventdata, handles)
% hObject    handle to StartTimedVideo_editText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StartTimedVideo_editText as text
%        str2double(get(hObject,'String')) returns contents of StartTimedVideo_editText as a double


% --- Executes during object creation, after setting all properties.
function StartTimedVideo_editText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StartTimedVideo_editText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in StartTimedVideo_pushbutton.
function StartTimedVideo_pushbutton_Callback(hObject, eventdata, handles)
global AVT_Vid
global TimedVideoFrames
global TimedVideoTimeStamps
StartTimedVideoSeconds = (get(handles.StartTimedVideo_editText,'String'));
triggerconfig(AVT_Vid, 'manual');
%FPT = 280; %144;%80;%132;%144;
FPT = str2num(StartTimedVideoSeconds)*28 
set(AVT_Vid, 'FramesPerTrigger', FPT);
start(AVT_Vid);
tic
trigger(AVT_Vid);

[TimedVideoFrames TimedVideoTimeStamps] = getdata(AVT_Vid);
toc
%figure, imshow(TimedVideoFrames(:,:,10));
%figure, imshow(TimedVideoFrames(:,:,100));
%figure, imshow(TimedVideoFrames(:,:,200));
figure
  imshow(TimedVideoFrames(1:1000,1:1000),'InitialMagnification',100);

  %for G=1:FPT-1
  
    
 %   imshow(TimedVideoFrames(:,:,G),'InitialMagnification',67);
 %   pause(0.0175)
%end

% 
% stoppreview(AVT_Vid);
% stop(AVT_Vid);
% AVT_Vid.FramesPerTrigger = inf;
% start(AVT_Vid);
% pause(4)
% stoppreview(AVT_Vid);
% stop(AVT_Vid);
% 
% testvid1D = getdata(AVT_Vid);
% figure, imshow(testvid1D(:,:,10))
% preview(AVT_Vid);
%testvideoGUI1D = getdata(vid);
%save('testvideoGUI1A.mat', 'testvideoGUI1B');
%clear testvideoGUI1B;

% 
% preview(vid);
% 
% start(vid);
% 
% stoppreview(vid);
% 
% stop(vid);
% 
% preview(vid);
% start(vid);
% pause(4)
% stoppreview(vid);
% stop(vid);
% testvid2A = getdata(vid);
% implay(testvid2A);


% --- Executes on button press in ExportVideo_pushbutton.
function ExportVideo_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to ExportVideo_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in PlasmidDiagRight_pushbutton.
function PlasmidDiagRight_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to PlasmidDiagRight_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stg
global SetEngageNeedlePositionX
global SetEngageNeedlePositionY
global SetEngageNeedlePositionZ
global NeedleEngagedFlag
global NikonTiScope
 
%diagonal needle movement
% NEEDLE_POSITION_Diag = (manipControl('getPosition',0,1));
% %pause(0.3)
% %positions in microns
% manipPositionDiagRightX = NEEDLE_POSITION_Diag(1);
% manipPositionDiagRightY = NEEDLE_POSITION_Diag(2);
% manipPositionDiagRightZ = NEEDLE_POSITION_Diag(3);
% increment = 3; %in Z direction
% 
% manipPositionDiagRightX = round(manipPositionDiagRightX  - (increment*16));
% manipPositionDiagRightZ = round(manipPositionDiagRightZ  - (increment*16));
% manipControl('changePosition',0,1,manipPositionDiagRightX,manipPositionDiagRightY, manipPositionDiagRightZ)
% %pause(0.3)


% RotationDegreesValueConvertStr = num2str(round(1*0.7031*520.875));    
% % clear_stage_buffer();
% fprintf(stg,['CW,',RotationDegreesValueConvertStr]); % Rotate Clockwise
% fscanf(stg);

increment = 3; %in Z direction
%manipPositionDiagLeftX = SetEngageNeedlePositionX;

%manipPositionDiagLeftZ = SetEngageNeedlePositionZ;


% NikonTiScope.ZDrive.MoveRelative(1*increment*40);
if (NeedleEngagedFlag == 1)
     
     %%%%%vibrate command%%%%%%%%%%%%%%
     Read_matfile = 1;
        PlasmidDispenseTimeX32 = 0;
        PlasmidVibrateTimeX32 = .5;
        PlasmidPulseTimeX32 = 0;

        E = 0;
        F = 0;
        G = 0;
        H = 0;
        save('C:\Users\CodyGilleland\Desktop\CAMIcode_3_07_2012\PlasmidControllerX32DataTransfer.mat','Read_matfile','PlasmidDispenseTimeX32','PlasmidVibrateTimeX32','PlasmidPulseTimeX32','E','F','G','H');
        disp('saved PlasmidControllerX32DataTransfer.mat');
        %pause(0.1)
        Read_matfile = 0;
        PlasmidDispenseTimeX32 = 0;
        PlasmidVibrateTimeX32 = 0;
        PlasmidPulseTimeX32 = 0;
        E = 0;
        F = 0;
        G = 0;
        H = 0;
     
     %%%%%vibrate command%%%%%%%%%%
     
     SetEngageNeedlePositionX = round(SetEngageNeedlePositionX  - (increment*16));
     %SetEngageNeedlePositionY = SetEngageNeedlePositionY;
     SetEngageNeedlePositionZ = round(SetEngageNeedlePositionZ  - (increment*16));
     manipControl('changePosition',0,1,SetEngageNeedlePositionX,SetEngageNeedlePositionY, SetEngageNeedlePositionZ)
     pause(0.5)
     
     
else
    disp('ERROR: Needle is not engaged');
end


% --- Executes on button press in PlasmidDiagLeft_pushbutton.
function PlasmidDiagLeft_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to PlasmidDiagLeft_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stg
global SetEngageNeedlePositionX
global SetEngageNeedlePositionY
global SetEngageNeedlePositionZ
global NeedleEngagedFlag
global NikonTiScope
%diagonal needle movement

increment = 3; %in Z direction(microns) 

if (NeedleEngagedFlag == 1) % check to see if needle is engaged
       Read_matfile = 1;
        PlasmidDispenseTimeX32 = 0;
        PlasmidVibrateTimeX32 = .5;
        PlasmidPulseTimeX32 = 0;

        E = 0;
        F = 0;
        G = 0;
        H = 0;
        save('C:\Users\CodyGilleland\Desktop\CAMIcode_3_07_2012\PlasmidControllerX32DataTransfer.mat','Read_matfile','PlasmidDispenseTimeX32','PlasmidVibrateTimeX32','PlasmidPulseTimeX32','E','F','G','H');
        disp('saved PlasmidControllerX32DataTransfer.mat');
        %pause(0.1)
        Read_matfile = 0;
        PlasmidDispenseTimeX32 = 0;
        PlasmidVibrateTimeX32 = 0;
        PlasmidPulseTimeX32 = 0;
        E = 0;
        F = 0;
        G = 0;
        H = 0;
     
     %%%%%vibrate command%%%%%%%%%%
   
     SetEngageNeedlePositionX = round(SetEngageNeedlePositionX  + (increment*16));
     %SetEngageNeedlePositionY = SetEngageNeedlePositionY;
     SetEngageNeedlePositionZ = round(SetEngageNeedlePositionZ  + (increment*16));
     manipControl('changePosition',0,1,SetEngageNeedlePositionX,SetEngageNeedlePositionY, SetEngageNeedlePositionZ)
     pause(0.5)
else
    disp('ERROR: Needle is not engaged');
end


% --- Executes on button press in DiagonalEngage_pushbutton.
function DiagonalEngage_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to DiagonalEngage_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in DiagonalHover_pushbutton.
function DiagonalHover_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to DiagonalHover_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in ReStartAVTVideo_pushbutton.
function ReStartAVTVideo_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to ReStartAVTVideo_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AVT_Vid

stoppreview(AVT_Vid);
disp('Stoppreview: AVT_Vid')
pause(.1);
preview(AVT_Vid);
disp('Startpreview: AVT_Vid')

% --- Executes on button press in StopAVTVideo_pushbutton.
function StopAVTVideo_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to StopAVTVideo_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Troubleshoot_pushbutton.
function Troubleshoot_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Troubleshoot_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Adams_Dir
global stitched_image
global wormIndex
global gonadNum
global stopSearch
global NeedleDiagEngagedFlag 

NeedleDiagEngagedFlag = 0;
disp('End Troubleshoot.')

i=0
for i = 1:10
manipControl('changePosition',0,1,25000*16,25000*16,25000*16);
pause(10)
manipControl('changePosition',0,1,0*16,0*16,0*16);
pause(10)
end


% --- Executes on button press in DigitalZoomToggle_pushbutton.
function DigitalZoomToggle_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to DigitalZoomToggle_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global digital_zoom

if (digital_zoom==1)
    digital_zoom = 0;
    disp('Digital Zoom: Off');
else
    digital_zoom = 1;
    disp('Digital Zoom: On');
end

function clear_stage_buffer()
% clears the buffer for the stage to prevent errors due to invalid stage
global stg

stg.timeout = .1;
clear_stg_buff = fscanf(stg);
while ~isequal(clear_stg_buff,'')
    clear_stg_buff = fscanf(stg);
end


% --- Executes on button press in MontageRegistration_pushbutton.
function MontageRegistration_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to MontageRegistration_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global AVT_Vid
global stg
global stitched_image
global ulcoord
global ratio_stg2X

ratio_stg2X = 1.89154;
% Have an assertion to test if montage is built

% Get image, it has to be high detail 
triggerconfig(AVT_Vid, 'manual');
%AVT_Vid.ROIPosition = [0 0 2336 1752];
set(AVT_Vid,'FramesPerTrigger', 1);
start(AVT_Vid);
trigger(AVT_Vid);
screen = getdata(AVT_Vid);

clear_stage_buffer();
pause(0.25);
fprintf(stg, 'P')
CurrentPosition = fscanf(stg);
CurrentPosition = str2num(CurrentPosition);

% original stage_trans/pixel = 1.8325
 disp('OK, Im calibrating...this will take a while.');
 ulcoord = (map_coord(stitched_image, screen, CurrentPosition, 1752*ratio_stg2X,2336*ratio_stg2X))
 disp('OK, Im done');


% --- Executes on button press in continue_pushbutton.
function continue_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to continue_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function [gonadx, gonady] = find_gonads(c_elegans, display)

    % Contrast threshold for c_elegans
    thresh = 240;
    % Branch size
    branch_thres = 50;
    
    
    % Get only the outline of the worm
    BW_outline = c_elegans < thresh;
    BW_outline = imfill(BW_outline, 'holes');
    regions = regionprops(BW_outline, {'FilledArea'});
    
    %this is the problem here. It selects the max area and not the one in
    %the center
    maxArea = max([regions.FilledArea]);
    BW_outline = bwareaopen(BW_outline, maxArea-1);

    % Get the skeleton of the worm
    skel = bwmorph(BW_outline, 'skel', 'Inf');
    [skel_y skel_x] = find(skel);
    
     figure,imshow(skel)
    
    % Get rid of all the branches
    endpts = bwmorph(skel, 'endpoints');
    while sum(sum(endpts)) ~= 2
        skel = skel - endpts;
        endpts = bwmorph(skel, 'endpoints');
    end
    
     [rows cols] = find(endpts)

    
    current_row = rows(1);
    current_col = cols(1);
    
    nxtPt = 0;
    updown = 0;
    ord_skel = [];
    size(skel);
    % Traverse the skeleton 
    while ~(current_row == rows(2) && current_col == cols(2))
        ord_skel = [ord_skel; current_row, current_col];
        skel(current_row, current_col) = 0;
        
        updown = 0;
        
        % Try up, down, left, right first
        for dc=-1:1:1
            
            if dc==0
                
                for dr=-1:2:1
                    if skel(current_row+dr, current_col+dc) == 1 
                        current_row = current_row + dr;
                        current_col = current_col + dc;
                        nxtPt = 1;
                        break;
                    
                    end

                end
                
            else
                
                if skel(current_row, current_col+dc) == 1 
                    current_row = current_row;
                    current_col = current_col + dc;
                    nxtPt = 1;
                    break;
                end

                
            end
            
            if nxtPt == 1
                nxtPt = 0;
                updown = 1;
                break;
            end

            
        end
        
        % Try diagonals
        if ~updown
            
            for dc = [-1 1]
                for dr = [-1 1]
                    % add checks later
                    if skel(current_row+dr, current_col+dc) == 1 
                        current_row = current_row + dr;
                        current_col = current_col + dc;
                        nxtPt = 1;
                        break;

                    end
                end

                if nxtPt == 1
                    nxtPt = 0;
                    break;
                end
            end

        end
        
    end
    
    gonadx = [ord_skel(round(length(ord_skel)/4), 2) ord_skel(round(3*length(ord_skel)/4), 2)];
    gonady = [ord_skel(round(length(ord_skel)/4), 1) ord_skel(round(3*length(ord_skel)/4), 1)];
    
    if display
    figure, imshow(c_elegans);
    sum(sum(skel));
    size(ord_skel);
    hold on
    plot(ord_skel(:, 2), ord_skel(:,1), 'r')
    plot(ord_skel(round(length(ord_skel)/4), 2),ord_skel(round(length(ord_skel)/4), 1), 'yo')
    plot(ord_skel(round(3*length(ord_skel)/4), 2),ord_skel(round(3*length(ord_skel)/4), 1), 'yo') 
    hold off
    end
    


% --- Executes on selection change in StrainIDwell1_popupmenu.
function StrainIDwell1_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to StrainIDwell1_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns StrainIDwell1_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from StrainIDwell1_popupmenu


% --- Executes during object creation, after setting all properties.
function StrainIDwell1_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StrainIDwell1_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in StrainIDwell2_popupmenu.
function StrainIDwell2_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to StrainIDwell2_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns StrainIDwell2_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from StrainIDwell2_popupmenu


% --- Executes during object creation, after setting all properties.
function StrainIDwell2_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StrainIDwell2_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in StrainIDwell3_popupmenu.
function StrainIDwell3_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to StrainIDwell3_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns StrainIDwell3_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from StrainIDwell3_popupmenu


% --- Executes during object creation, after setting all properties.
function StrainIDwell3_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StrainIDwell3_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in StrainIDwell4_popupmenu.
function StrainIDwell4_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to StrainIDwell4_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns StrainIDwell4_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from StrainIDwell4_popupmenu


% --- Executes during object creation, after setting all properties.
function StrainIDwell4_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StrainIDwell4_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in PlasmidIDwell1_popupmenu.
function PlasmidIDwell1_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to PlasmidIDwell1_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PlasmidIDwell1_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PlasmidIDwell1_popupmenu


% --- Executes during object creation, after setting all properties.
function PlasmidIDwell1_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PlasmidIDwell1_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in PlasmidIDwell2_popupmenu.
function PlasmidIDwell2_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to PlasmidIDwell2_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PlasmidIDwell2_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PlasmidIDwell2_popupmenu


% --- Executes during object creation, after setting all properties.
function PlasmidIDwell2_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PlasmidIDwell2_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in PlasmidIDwell3_popupmenu.
function PlasmidIDwell3_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to PlasmidIDwell3_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PlasmidIDwell3_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PlasmidIDwell3_popupmenu


% --- Executes during object creation, after setting all properties.
function PlasmidIDwell3_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PlasmidIDwell3_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in PlasmidIDwell4_popupmenu.
function PlasmidIDwell4_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to PlasmidIDwell4_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PlasmidIDwell4_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PlasmidIDwell4_popupmenu


% --- Executes during object creation, after setting all properties.
function PlasmidIDwell4_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PlasmidIDwell4_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
