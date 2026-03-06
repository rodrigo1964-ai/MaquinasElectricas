% M-file for Project 5 on some non-zero v_sg conditions in Chapter 6

% m5.m sets up the motor parameters and initial values in
% the MATLAB workspace for the SIMULINK files: s5a.m and s5b.m. 
% It also plots the results of the simulation. 
 
% Load induction motor parameters 

p1hp % load 1 hp three-phase motor parameters from p1hp.m

% set initial condition and simulation parameter
Psiqso = 0; % stator q-axis total flux linkage 
Psipqro = 0; % rotor q-axis total flux linkage 
Psidso = 0; % stator d-axis total flux linkage 
Psipdro = 0; % rotor d-axis total flux linkage 
wrbywbo = 0; % pu rotor speed

tstop = 2; % use 2 sec simultion time for Fig. in text
% Transfer to keyboard for simulation
disp('Set up for running s5a.m or s5b.m');
disp('Perform simulation and type ''return'' for plots');
keyboard
clf;
subplot(3,1,1)
plot(y(:,1),y(:,2),'-')
ylabel('vag in V')
title('stator phase to neutral voltage')
subplot(3,1,2)
plot(y(:,1),y(:,6),'-')
ylabel('vsg in V')
title('stator neutral voltage')
subplot(3,1,3)
plot(y(:,1),y(:,3),'-')
ylabel('ias in A')
title('stator current')

h2=figure;
subplot(3,1,1)
plot(y(:,1),y(:,5),'-')
ylabel('Tem in Nm')
title('developed torque')
subplot(3,1,2)
plot(y(:,1),y(:,4),'-')
ylabel('wr/wb')
xlabel('time in sec')
title('pu rotor speed')
disp('Save plots before typing return to exit') 
keyboard
close (h2)
