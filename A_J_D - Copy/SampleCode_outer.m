%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Control System Design Lab: Sample Code
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
sample_debut = 600;
sample_stabilisation = 700;
sample_step = 100;
sample_end=N0 - sample_debut - sample_stabilisation-sample_step;

voltage_stabilisation = 1.83; 
voltage_debut = 2.3; 
voltage_step = 5;
DataCommands= [ones(sample_debut,1)* voltage_debut ; ones(sample_stabilisation, 1) * voltage_stabilisation; ones(sample_step, 1) * voltage_step;ones(sample_end, 1) * voltage_stabilisation] ; %Vector storing the input sent to the plant.
cond=1; %Set the condition variable to 1.
i=1; %Set the counter to 1.
tic %Begins the first strike of the clock.
time=0:Ts:(N0-1)*Ts; %Vector saving the time steps.
omega_ref = 10; 
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
K =10; 
e_motor = 0;
u_motor = 0; 
velocity_old = 0; 

while cond==1    
    [velocity,in2,in3,in4,in5,in6,in7,in8]=anain; %Acquisition of the measurements.
    ref=omega_ref; %Input of the system.
    Data(i,1)=velocity; %Save one of the measurements (in1).
    Data(i,2)=in2;  
    
    if i >= sample_stabilisation + sample_debut && i<N0-sample_end 
        e_motor = ref - velocity;
        u_motor = K*e_motor + u0; 
    elseif i < sample_debut
        u_motor = voltage_debut; 
    elseif i <sample_stabilisation + sample_debut
        u_motor = voltage_stabilisation; 
    else 
        u_motor = voltage_stabilisation; 
    end
    
    anaout(u_motor,0); %Command to send the input to the analog computer.
    DataCommands(i,:) = u_motor;
    
%     if i>sample_debut+sample_stabilisation
%        e_motor = ref-velocity; 
%        u_motor = K*e_motor+1.83; 
%     else
%        u_motor = DataCommands(i);  
%     end
%     
%     anaout(u_motor,0); %Command to send the input to the analog computer.

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