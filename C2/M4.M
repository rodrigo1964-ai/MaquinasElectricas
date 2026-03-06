% M-file for Exercise 4 series resonant circuit simulation 
% input parameters and initial conditions

R = 12; %R in ohms
L = 0.231e-3; %L in H
C = 0.1082251e-6;%C in Farad 
wo = sqrt(1/(L*C))  % series resonant frequency in rad/sec	
Vdc = 100; % magnitude of ac voltage =  Vdc Volts 
iLo = 0; % initial value of inductor current
vCo = 0; % initial voltage of capacitor voltage 
tf = 10*(2*pi/wo);  % filter time constant
tstop = 25e-4; % stop time for simulation
% set up time and output arrays of repeating sequence for Pref
Pref_time = [ 0 6e-4 11e-4 11e-4 18e-4 18e-4 tstop ];
Pref_value = [ 0 600 600 300 300 600 600 ];

% determine steadystate characteristics of RLC circuit 
we = (0.5*wo: 0.01*wo: 1.5*wo);% set up freq range 
wind = 0 % index for w loop
for w = we; % w for loop to compute admittance
wind = wind + 1;
Y(wind) = 1/(R + j*w*L + 1/(j*w*C));
Irms = (4*Vdc/(pi*sqrt(2)))*abs(Y(wind)); % rms value of i
PR(wind)= Irms*Irms*R;
end; % for w

% plot circuit characteristics
clf;
subplot(2,1,1)
plot(we,abs(Y)); 
xlabel('frequency in rad/sec');
ylabel('admittance in mhos');
subplot(2,1,2)
plot(we,PR); 
xlabel('frequency in rad/sec');
ylabel('power in watts');

disp('run simulation, type ''return'' when ready to continue')
keyboard
clf
subplot(4,1,1)
plot(y(:,1),y(:,2))
title('excitation voltage')
ylabel('Vs in V')
subplot(4,1,2)
plot(y(:,1),y(:,3))
title('load power')
ylabel('PR in W')
subplot(4,1,3)
plot(y(:,1),y(:,4))
title('RLC current')
ylabel('i in A')
subplot(4,1,4)
plot(y(:,1),y(:,5))
xlabel('time in sec')
title('capacitor voltage')
ylabel('VC in V')
