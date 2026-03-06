% M-file for Project 2 on starting of dc motor in Chapter 8 
% loads the following machine parameters of dc machine
% and plot results of simulation
% 
Prated = 10*746;  
Vrated = 220;
Iarated = Prated/Vrated;
wmrated = 1490*(2*pi)/60; 
Trated = Prated/wmrated;
Ra = 0.3;
Laq =  0.012; 
J = 2.5; % rotor inertia in kgm2
D= 0.0; % damping factor
disp('run simulation then type in return when ready for plot')
keyboard % 
clf;
subplot(3,1,1)
plot(y(:,1),y(:,2))
title('Internal voltage Ea')
ylabel('Ea in V')
subplot(3,1,2)
plot(y(:,1),y(:,3))
title('Armature current Ia')
ylabel('Ia in A')
subplot(3,1,3)
plot(y(:,1),y(:,4))
title('Rotor speed')
xlabel('time in sec')
ylabel('wm in rad/sec')

