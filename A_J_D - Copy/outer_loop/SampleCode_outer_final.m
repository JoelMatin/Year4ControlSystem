%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Control System Design Lab: Sample Code Outer Loop 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; close all; clc;
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

openinout; %Open the ports of the analog computer.
Ts=1/200;%Set the sampling time.
lengthExp=10; %Set the length of the experiment (in seconds).
N0=lengthExp/Ts; %Compute the number of points to save the datas.
Data=zeros(N0,1); %Vector saving the datas. If there are several datas to save, change "1" to the number of outputs.
sample_debut = 800;
sample_stabilisation = 500;
sample_step = 190;
sample_end=N0 - sample_debut - sample_stabilisation-sample_step;

voltage_stabilisation = 6.2; %6.2V Pr la position on est en zone linéaire 2600tours / min
voltage_debut = 7.5; 
voltage_step = 6.7; % 8 V = 3600 tours / min
DataCommands= [ones(sample_debut,1)* voltage_debut ; ones(sample_stabilisation, 1) * voltage_stabilisation; ones(sample_step, 1) * voltage_step;ones(sample_end, 1) * voltage_step] ; %Vector storing the input sent to the plant.
cond=1; %Set the condition variable to 1.
i=1; %Set the counter to 1.
tic %Begins the first strike of the clock.
time=0:Ts:(N0-1)*Ts; %Vector saving the time steps.
omega_ref = 10; 
u0 = 1.83;
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
K =10; 
e_motor = 0;
u_motor = 0; 
velocity_old = 0; 
% Ajouté par moi 
ref = [ones(sample_debut,1)* voltage_debut ; ones(sample_stabilisation, 1) * voltage_stabilisation; ones(sample_step, 1) * voltage_step;ones(sample_end, 1) * voltage_step] ; %Vector storing the input sent to the plant.

while cond==1    
    [velocity,position,in3,in4,in5,in6,in7,in8]=anain; %Acquisition of the measurements.
    %ref=omega_ref; %Input of the system.
    Data(i,1)=velocity; %Save one of the measurements (in1).
    Data(i,2)=position;  
    e_motor = ref(i) - velocity;
    u_motor = K*e_motor + u0;

     
    anaout(u_motor,0); %Command to send the input to the analog computer.
    DataCommands(i,:) = u_motor;
    

    t=toc; %Second strike of the clock.
    if t>i*Ts
        disp('Sampling time too small');%Test if the sampling time is too small.
    else
        while toc<=i*Ts %Does nothing until the second strike of the clock reaches the sampling time set.
        end
    end
    if i==N0 %Stop condition.
        cond=0;
    end
    i=i+1;
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

closeinout %Close the ports.

figure %Open a new window for plot.
plot(time,Data(:,1),time,Data(:,2)); %Plot the experiment (input and output).