% M-file for Project 4 on three-phase transformers in Chapter 4
% It sets up the parameter for the three two-winding units  
% and plots some variables of the unit. 

clear all;

% Set up identical circuit parameters and mag. curve 
% for the three single phase transformers

Vrated = 120; % rms rated voltage
Srated = 1500; % rated VA
Frated = 60; % rated frequency in Hz
Zb = Vrated^2/Srated; % base impedance
wb = 2*pi*Frated; % base frequency
Vpk = Vrated*sqrt(2); % peak rated voltage
NpbyNs = 120/240; % nominal turns ratio 
r1 = 0.25; % resistance of wdg 1 in ohms
rp2 = 0.134; % referred resistance of wdg 2 in ohms
xl1 = 0.056; % leakage reactance of wdg 1 in ohms
xpl2 = 0.056; % leakage reactance of wdg 1 in ohms
xm = 708.8; % unsaturated magnetizing reactance in ohms
xM = 1/(1/xm + 1/xl1 + 1/xpl2);

% mag. curve Dpsi versus psisat

Dpsi=[ -2454.6 -2412.6 -2370.5 -2328.5 -2286.4 -2244.4 -2202.3 ... 
-2160.3 -2118.2 -2076.1 -2034.1 -1992.0 -1950.0 -1907.9 -1865.9 ... 
-1823.8 -1781.8 -1739.7 -1697.7 -1655.6 -1613.6 -1571.5 -1529.5 ...
-1487.4 -1445.3 -1403.3 -1361.2 -1319.2 -1277.1 -1235.1 -1193.0 ...
-1151.0 -1108.9 -1066.9 -1024.8 -982.76 -940.71 -898.65 -856.60 ...
-814.55 -772.49 -730.44 -688.39 -646.43 -604.66 -562.89 -521.30 ...
-479.53 -438.14 -396.75 -355.35 -313.96 -272.56 -231.17 -192.60 ...
-154.04 -116.41 -81.619 -46.822 -19.566 0.0000 0.0000 0.0000 0.0000 ...
0.0000 0.0000 19.566 46.822 81.619 116.41 154.04 192.60 231.17 ...
272.56 313.96 355.35 396.75 438.14 479.53 521.30 562.89 604.66 ...
646.43 688.39 730.44 772.49 814.55 856.60 898.65 940.71 982.76 ...
1024.8 1066.9 1108.9 1151.0 1193.0 1235.1 1277.1 1319.2 1361.2 ...
1403.3 1445.3 1487.4 1529.5 1571.5 1613.6 1655.6 1697.7 1739.7 ...
1781.8 1823.8 1865.9 1907.9 1950.0 1992.0 2034.1 2076.1 2118.2 ...
2160.3 2202.3 2244.4 2286.4 2328.5 2370.5 2412.6 2454.6 ];

psisat=[ -170.21 -169.93 -169.65 -169.36 -169.08 -168.80 -168.52 ...
-168.23 -167.95 -167.67 -167.38 -167.10 -166.82 -166.54 -166.25 ...
-165.97 -165.69 -165.40 -165.12 -164.84 -164.56 -164.27 -163.99 ...
-163.71 -163.43 -163.14 -162.86 -162.58 -162.29 -162.01 -161.73 ... 
-161.45 -161.16 -160.88 -160.60 -160.32 -160.03 -159.75 -159.47 ...
-159.18 -158.90 -158.62 -158.34 -157.96 -157.39 -156.83 -156.07 ...
-155.51 -154.57 -153.62 -152.68 -151.74 -150.80 -149.85 -146.08 ...
-142.31 -137.60 -130.06 -122.52 -107.44 -84.672 -42.336 0.0000 ...
0.0000 42.336 84.672 107.44 122.52 130.06 137.60 142.31 146.08 ...
149.85 150.80 151.74 152.68 153.62 154.57 155.51 156.07 156.83 ...
157.39 157.96 158.34 158.62 158.90 159.18 159.47 159.75 160.03 ...
160.32 160.60 160.88 161.16 161.45 161.73 162.01 162.29 162.58 ...
162.86 163.14 163.43 163.71 163.99 164.27 164.56 164.84 165.12 ...
165.40 165.69 165.97 166.25 166.54 166.82 167.10 167.38 167.67 ...
167.95 168.23 168.52 168.80 169.08 169.36 169.65 169.93 170.21 ]; 

% set up simulation parameters  
tstop = 1.2; % stop time 
Psi1o = 0; % initial value of wdg l flux linkage
Psip2o = 0; % initial value of wdg 2 flux  linkage
Rload = 120^2/1500 % referred impedance to primary side of  
	           % the 1.5 kVA, unity power factor load 
                   % connected across each secondary winding

repeat_run = 'Y'; % set up repeat run flag  
while repeat_run == 'Y'

disp('Setting up transformer simulation with m4.m')
Rn = input('Enter ohmic value of neutral to ground resistor Rn > ');
disp('Run simulation and return for plots')
keyboard
clf;
subplot(4,1,1)
plot(y(:,1),y(:,2),'-')
ylabel('vAB in V')
title('primary line voltage')
subplot(4,1,2)
plot(y(:,1),y(:,3),'-')
ylabel('vab in V')
title('secondary line voltage')
subplot(4,1,3)
plot(y(:,1),y(:,4),'-')
ylabel('iA in A')
title('primary line current')
subplot(4,1,4)
plot(y(:,1),y(:,5),'-')
ylabel('ia in A')
title('secondary line current')
h2=figure;
subplot(4,1,1)
plot(y(:,1),y(:,6),'-')
ylabel('(iAB+iBC+iCA)/3 in A')
subplot(4,1,2)
plot(y(:,1),y(:,7),'-')
ylabel('(ia+ib+ic)/3 in A')
subplot(4,1,3)
plot(y(:,1),y(:,8),'-')
ylabel('vnG in V')
title('Secondary neutral to ground voltage')
xlabel('Time in sec')
disp('Save plots before typing return')
keyboard
close(h2)

% prompt for repeat with new system condition
repeat_run =  input('Repeat with new system condition? Y/N: ','s');
if isempty(repeat_run) % if empty return a No to terminate
repeat_run = 'N';
end

end % while repeat_run

