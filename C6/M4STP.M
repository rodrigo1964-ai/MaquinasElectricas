% M-file for the last part of Project 4 on linearized 
%  analysis in Chapter 6
% m4stp.m sets up the system parameters for a simulation
% using the SIMULINK file s4stp  
% to obtain a simulated response of
% the motor speed to a unit disturbance in Vqse  

% load machine parameters for simulation  

p20hp % use 20 hp three-phase motor parameters

% specify initial value variables

Psiqso = Vm;
Psipqro = Vm;
Psidso = 0;
Psipdro = 0;
wrbywbo = 1;

% Transfer to keyboard for simulation
disp('Using M4STP.M to set up')
disp('Run simulation and type ''return'' for the plot')
keyboard
clf;
plot(y(:,1),y(:,2))
title('Response to one volt step')
xlabel('time in sec')
ylabel('pu speed wr/wb')
axis square  % for square plot 
