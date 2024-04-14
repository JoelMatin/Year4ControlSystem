[num, den] = tfdata(sysIdent); 
sysIdentZOH = tf(num,den,'InputDelay',Ts);
margin(sysIdentZOH) ;