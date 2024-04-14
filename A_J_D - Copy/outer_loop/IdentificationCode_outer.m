u=DataCommands(sample_debut + sample_stabilisation+100:N0, 1).';
y=Data(sample_debut + sample_stabilisation+100:N0,1).';
time2 = time(1, sample_debut + sample_stabilisation+100:N0);
offsetu=1.85; %Operating point
offsety = 2.58; 
SystemOrder=[0 2]; %Number of zeros and of poles (0 and 1), respectively.
sysIdent=IdentifySystem_outer(u-offsetu,y-offsety,SystemOrder,Ts);
%sysRequi = tf([0, 0, 20.99*1.44],[1, 1.872, 1.44] ); 
figure
plot(time2(),y-offsety,'.');
hold on;
lsim(sysIdent,u-offsetu,time2);
hold on; 
%lsim(sysRequi, u-offsetu, time2); 