% global A
% global B
% global C
% global D
% global E
% global F
global Read_matfile
Read_matfile = 0;
while (Read_matfile == 0);
   try
    load('abcdef.mat','A','B','C','D','E','F');
    %do stuff
    PlasmidTestPulsetime = A
    
    if A>0
     PlasmidPulse_pushbutton_Callback
    end 
    
    if B>0
     PlasmidDispensetime = B
     PlasmidDispense_pushbutton_Callback;
    end
    
    if D>0
     PlasmidVibratetime = C
    PlasmidVibrate_pushbutton_Callback;
    
    %D 
    %E 
    %F 
    
    %set variables to zero
    A = 0;
    B = 0;
    C = 0;
    D = 0;
    E = 0;
    F = 0;
    save('abcdef.mat','A','B','C','D','E','F');
    %pause(0.05)
catch
    disp('Catch: PlasmidControlX32Read');
end
end 

