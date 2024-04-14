u=DataCommands(800:end, 1).';
y=Data(800:end,1).';
time2 = time(1, 800:end);
offsetu=1.83; %Operating point
offsety = 6.22; 
SystemOrder=[0 1]; %Number of zeros and of poles (0 and 1), respectively.
Ts = 1/200; 
sysIdent=IdentifySystem(u-offsetu,y-offsety,SystemOrder,Ts);
[numSysIdent, denSysIdent] = tfdata(sysIdent); 
sysIdentDelayed = tf(numSysIdent, denSysIdent, 'InputDelay', Ts); 
%plot(time2,y-offsety,'.');
%plot(time2,u-offsetu,'-'); 
%lsim(sysIdent,u-offsetu,time2);

margin(sysIdentDelayed); 