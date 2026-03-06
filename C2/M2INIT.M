% M-file for Exercise 2 RLC circuit simulation 
% input parameters and initial conditions

Rs = 50; %Rs = 50 ohms
L = 0.1; %L = 0.1 Henry
C = 1000e-6;  % C = 1000 uF
VS_mag = 100; % magnitude of step voltage Vs in Volts 
tdelay = 0.05; % initial delay of step voltage in sec
vCo = 0; % initial value of capacitor voltage 
iLo = 0; % initial value of inductor current
tstop = 0.5; % stop time for simulation

disp('S2 is set up for running') 
disp(' Run S2 then double click M2plot ')
disp(' masked block for plots')
