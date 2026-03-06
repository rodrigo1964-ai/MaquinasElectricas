% M-file for Exercise 2 RLC circuit simulation 
% input parameters and initial conditions
% and plot results of simulation
Rs = 50; %Rs = 50 ohms
L = 0.1; %L = 0.1 Henry
C = 1000e-6;  % C = 1000 uF
VS_mag = 100; % magnitude of step voltage Vs in Volts 
tdelay = 0.05; % initial delay of step voltage in sec
vCo = 0; % initial value of capacitor voltage 
iLo = 0; % initial value of inductor current
tstop = 0.5; % stop time for simulation
disp('run simulation, type ''return'' when ready to return')
keyboard
subplot(3,1,1)
plot(y(:,1),y(:,2))
title('source current')
ylabel('iS in A')
subplot(3,1,2)
plot(y(:,1),y(:,3))
title('capacitor voltage')
ylabel('vC in V')
subplot(3,1,3)
plot(y(:,1),y(:,4))
title('inductor current')
xlabel('time in sec.')
ylabel('iL in A')
