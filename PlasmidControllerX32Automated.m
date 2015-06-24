 %global PlasmidDispenseTime
 %global PlasmidVibrateTime
 %global Read_matfile_running
 %global Read_matfile
 % global C
% global D
% global E
% global F

%Read_matfile = 0;

Read_matfile_running = 1;
while (Read_matfile_running == 1);
   try
    pause(1)
    disp('trying really hard');
    load('PlasmidControllerX32DataTransfer.mat','Read_matfile','PlasmidDispenseTimeX32','PlasmidVibrateTimeX32','D','E','F','G','H');
    disp('File Loaded: PlasmidControllerX32DataTransfer.mat');
    pause(1)
    %Read_matfile = str2num(Read_matfile);
    if (Read_matfile == 1)
        disp('Read_matfile = 1. file read')
        %Read_matfile = 0;
            PlasmidDispenseTime = PlasmidDispenseTimeX32;
            PlasmidVibrateTime = PlasmidVibrateTimeX32;
            if (PlasmidDispenseTime > 0)
               PlasmidDispense_pushbutton_Callback;
            end

            if (PlasmidVibrateTime > 0)
               PlasmidVibrate_pushbutton_Callback;
            end

           

            %Reset All Passed Variables
            Read_matfile = 0;
            PlasmidDispenseTimeX32 = 0;
            PlasmidVibrateTimeX32 = 0;
            D = 0;
            E = 0;
            F = 0;
            G = 0;
            H = 0;
            %save reset variables
            pause(1)
            save('PlasmidControllerX32DataTransfer.mat','Read_matfile','PlasmidDispenseTimeX32','PlasmidVibrateTimeX32','D','E','F','G','H');
            pause(1); %arbitrary pause to allow file to be read and written without conflicts
    else
        disp('Read_matfile is OFF');
        pause(1)
    end
catch
    disp('Catch: PlasmidControlX32Read');
    pause(1)
end
end 

PlasmidDispense


function PlasmidDispense
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

