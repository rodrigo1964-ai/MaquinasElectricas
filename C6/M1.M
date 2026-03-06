% M-file for projects 1 and 3 on induction machine in Chapter 6
% It sets up the motor parameters, initial conditions, and
% mechanical loading in the MATLAB workspace for simulation,
% and plots the results of the simulation.
 
% Load three-phase induction motor parameters 

p1hp % load 1 hp motor parameters from p1hp.m

% initialize to start from standstill with machine unexcited

Psiqso = 0; % stator q-axis total flux linkage 
Psipqro = 0; % rotor q-axis total flux linkage 
Psidso = 0; % stator d-axis total flux linkage 
Psipdro = 0; % rotor d-axis total flux linkage 
wrbywbo = 0; % pu rotor speed
tstop = 2; % use 2 sec simultion time for Fig. in text

% program time and output arrays of repeating sequence signal for Tmech

tmech_time = [0 0.8 0.8 1.2 1.2 1.6 1.6 tstop];  
tmech_value = [0 0 -0.5 -0.5 -1. -1. -0.5 -0.5]*Tb;  

% Transfer to keyboard for simulation
disp('Set up for running s1.m or s3.m');
disp('Perform simulation then type return for plots');
keyboard
clf;
subplot(4,1,1)
plot(y(:,1),y(:,2),'-')
ylabel('vag in V')
title('stator phase to neutral voltage')
subplot(4,1,2)
plot(y(:,1),y(:,3),'-')
ylabel('ias in A')
axis([-inf inf -25 25]);
title('stator current')
subplot(4,1,3)
plot(y(:,1),y(:,5),'-')
ylabel('Tem in Nm')
title('developed torque')
subplot(4,1,4)
plot(y(:,1),y(:,4),'-')
axis([-inf inf 0 1.2]);
ylabel('wr/wb')
xlabel('time in sec')
title('pu rotor speed')
