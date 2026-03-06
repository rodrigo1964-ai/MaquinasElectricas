% M-file for Exercise 3 RL circuit simulation 
% input parameters and initial conditions

R = 0.4; %R = 0.4 ohm
L = 0.04; %L = 0.04 Henry
we = 314;  % excitation frequency in rad/sec	
Vac_mag = 100; % magnitude of ac voltage Vac in Volts 
iLo = 0; % initial value of inductor current
tstop = 0.5; % stop time for simulation
disp('run simulation, type ''return'' when ready to return')
keyboard
subplot(2,1,1)
plot(y(:,1),y(:,2))
title('ac excitation voltage')
ylabel('Vac in V')
subplot(2,1,2)
plot(y(:,1),y(:,3))
title('mesh current')
xlabel('time in sec.')
ylabel('i in A')
