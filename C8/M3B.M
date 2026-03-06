% This M-file, m3b.m, is for the regenerative braking part of Project 3 
% on methods of braking of separately-excited dc motor in Chapter 8
% It is to be used in conjunction with the Simulink file s3b.m.
% The M-file m3a.m is for the other part of the project on 
% plugging and dynamic braking. 
%
% loads the following machine parameters of dc machine
% and plots results from simulation


Prated = 2*746;  
Vrated = 125;
Iarated = 16;
wmrated = 1750*(2*pi)/60; 
Trated = Prated/wmrated;
Ra = 0.14;
Rf = 111;
Rrh = 25; % ext field rheostat resistance
Laq =  0.018; 
Lf = 10;
D = 0; % damping
J = 0.5; % rotor inertia in kgm2
wraise=wmrated
wlower=-wmrated/3
disp('Run simulation and return for plots') 
keyboard
clf;
subplot(4,1,1)
plot(y(:,1),y(:,5))
title('Rotor speed')
ylabel('wm in rad/sec')
subplot(4,1,2)
plot(y(:,1),y(:,3))
title('Armature current')
ylabel('Ia in A')
subplot(4,1,3)
plot(y(:,1),y(:,4))
title('Electrical torque')
ylabel('Tem in Nm')
subplot(4,1,4)
plot(y(:,1),y(:,2))
title('Armature voltage')
ylabel('Va in V')
xlabel('time in sec')
disp('Displaying results in Fig. 1') 
