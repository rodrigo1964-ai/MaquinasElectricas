% M-file for Project 2 on switching transients 
%  of a distributed parameter line in Chapter 3.  

% m2.m sets up the parameters and initial condition
%   for the simulation in SIMULINK file s2.m. 
% It also plots the results of the simulation. 

% Source voltage magnitude, frequency, and inductance
Vrated = 500e3;  % rated line to line 3-phase rms voltage 
Epk = Vrated*sqrt(2/3); % Peak value of phase voltage
we = 2*pi*60;  	% 60 Hz supply
Te = 1/60; 	% period of source voltage in secs. 
Ls = 0.1;  	% source inductance, Henry
tstop = 15*Te;   % simulation run time

% Distributed line parameters
d = 100;  % 100 miles long
R = 0.15; % resistance of line, Ohm per mile
L = 2.96e-3; % inductance of line, Henry per mile
C = 0.017e-6; % capacitance of line, Farad per mile
Zc = sqrt(L/C) % characteristic impedance in ohms 
tdelay = d*sqrt(L*C) % one-way propagation time delay in seconds
atten = exp(-(R/2)*sqrt(C/L)*d) % one-way attenuation
buffer_size = 20000; % buffer size of delay module 

% Load parameters
SL =  30e6*(0.8 +j*0.6) % 30 MVA, 0.8 pf lagging
ZL = Vrated^2/conj(SL) % per phase load impedance in Ohms
RL = real(ZL) % series RL load model resistance
LL = imag(ZL)/we % series RL load model inductance

% Breaker's parameter
tc = 1/60 % one cycle closing time
Rc = 1000; % closing resistance in Ohms
to = 1/60 % one cycle opening time
Ro = 1000; % opening resistance in Ohms

disp('Run simulation and return for plots')
keyboard
clf;
subplot(3,1,1)
plot(y(:,1),y(:,2),'-')
ylabel('e in V')
title('Source voltage')
subplot(3,1,2)
plot(y(:,1),y(:,3),'-')
ylabel('Vb in V')
title('Breaker voltage')
subplot(3,1,3)
plot(y(:,1),y(:,4),'-')
ylabel('IS in A')
title('Sending end current')

h2=figure;
subplot(3,1,1)
plot(y(:,1),y(:,5),'-')
ylabel('VS in V')
title('Sending end voltage')
subplot(3,1,2)
plot(y(:,1),y(:,7),'-')
ylabel('IR in A')
title('Receiving end current')
subplot(3,1,3)
plot(y(:,1),y(:,6),'-')
ylabel('VR in V')
xlabel('Time in sec')
title('Load terminal voltage')

disp('Save plots before typing return to exit')
keyboard
close (h2)

