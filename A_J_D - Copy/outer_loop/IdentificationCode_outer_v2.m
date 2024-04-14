StartingPoint = 1150;
u=Data(StartingPoint:end, 1).';
y=Data(StartingPoint:end,2).';
time2 = time(1, StartingPoint:end);
offsetu=6.246; %Operating point
offsety = 2.545; 
SystemOrder=[0 2]; %Number of zeros and of poles (0 and 1), respectively.
sysIdent=IdentifySystem_outer((u-offsetu),y-offsety,SystemOrder,Ts)
%sysRequi = tf([0, 0, 20.99*1.44],[1, 1.872, 1.44] ); 
figure
plot(time2(),y-offsety,'.');
hold on;
lsim(sysIdent,u-offsetu,time2);
hold on; 
%lsim(sysRequi, u-offsetu, time2); 