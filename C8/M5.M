% M-file m5.m  is for Project 5 on series dc machine hoist in Chapter 8

% m5.m loads the following dc machine parameters
% and plots results of simulation 

Prated = 1500;  
Vrated = 125;
Iarated = 13.2;
wmrated = 1425*(2*pi)/60; 
Trated = Prated/wmrated;
Ra = 0.24;
Rse = 0.2;
Laq =  0.018; 
Lse = 0.044;
J = 0.5; % rotor inertia in kgm2

% Enter magnetization curve data
wmo = 1200*(2*pi)/60; % speed at which mag. curve data was taken
% load voltage values of mag. curve
SEVP5 = [-160 -155 -150 -145 -140 -135 -130 -125 -120 -115 ...
-110 -105 -100 -90 -80 -70 -60 -50 -40 -30 -20 -10 0 ...
10 20 30 40 50 60 70 80 90 100 105 110 115 120 125 130 135 ...
140 145 150 155 160 ];

% load main field current values of mag. curve
SEIP5 = [-27.224 -23.547 -20.624 -18.739 -17.560 -16.617 ...
 -15.627 -14.826 -13.977 -13.317 -12.643 -11.969 -11.290 ...
-10.041 -8.886 -7.613 -6.576 -5.647 -4.643 -3.582 -2.521 ...
-1.423 -0.400  0.623  1.721  2.782  3.843  4.847  5.776  ...
6.813  8.086  9.241 10.490 11.169 11.843 12.517 13.177 14.026 ...
14.827 15.817 16.760 17.939 19.824 22.747 26.424 ];
% plotting of machine characteristics
plot_option = menu('Plot machine characteristics?', 'Yes' ,'No');
if plot_option == 1,
clf;
plot(SEIP5,SEVP5); % plot mag curve measured at wmo
xlabel('Armature current Ia in A')
ylabel('Armature voltage Ea in V')
axis('square')
grid on
% Transfer to keyboard for actions (e.g. printing) on above plot
disp('Displaying Mag characteristics, return for simulation');
keyboard
end % if plot_option

hseriesV = SEVP5(24:1:45); % obtain positive half of E_awithout
			% zero value 
hseriesI = SEIP5(24:1:45); % obtain positive half of I_a 
kaphi = (hseriesV)/(wmo);
tem = (kaphi.*hseriesI);
%plot(tem,kaphi,'+') % check smoothness of kaphi curve
%keyboard		

% Compute speed-torque characteristic with rated supply voltage  
% and no external resistor

Vmotor = Vrated-2; % provide for 2 volt of brush drop
Rtotal = Ra + Rse;
E = Vmotor - hseriesI.*Rtotal;
wm = E./kaphi;
pem = E.*hseriesI; % tem.*wm;

% Case of Vbrake = Vmotor % only insert Rbrake
Vbrake = Vmotor
% Compute braking resistor to limit speed to wbrake with Tload=Trated
wbrake = -400*2*pi/60 % braking speed to rad/sec
Iabrake = interp1(tem,hseriesI,Trated) % interpolate for Trated
kaphibrake = interp1(hseriesI,kaphi,Iabrake)
Rbrake =  (Vbrake - kaphibrake*wbrake)/Iabrake - Ra - Rse
Rtotal = Ra + Rse + Rbrake;
E1 = Vbrake - hseriesI.*Rtotal;
wm1 = E1./kaphi;

% Transferring to keyboard to simulate the case of braking 
% with Va = Vrated 
disp('Run simulation of braking with Va=Vrated, before returning')
keyboard
% Plotting results. Save and return   
clf;
subplot(4,1,1)
plot(y(:,1),y(:,5))
title('Rotor speed')
ylabel('wm in rad/sec')
subplot(4,1,2)
plot(y(:,1),y(:,4))
axis([-inf inf -200 200])
title('Braking Torque Tem with Va=Vrated')
ylabel('Tem in Nm')
subplot(4,1,3)
plot(y(:,1),y(:,3))
title('Armature current')
ylabel('Ia in A')
subplot(4,1,4)
plot(y(:,1),y(:,2))
title('Internal voltage Ea')
ylabel('Ea in V')
xlabel('time in sec')
disp('Displaying results of simulation in Fig. 1')
disp('Return next for plot of braking characteristics');
keyboard
% Case of Vbrake = 0
Vbrake = 0
Rbrake =  (Vbrake - kaphibrake*wbrake)/Iabrake - Ra - Rse
Rtotal = Ra + Rse + Rbrake;
E2 = Vbrake - hseriesI.*Rtotal;
wm2 = E2./kaphi;
% Plot braking performance with Va = 0 and Vrated along with 
% motoring char. with rated voltage  
clf;
plot(tem,wm,'-',tem,wm1,'-.',tem,wm2,'--')
axis([-inf 20 -50 300])
axis('square')
xlabel('Torque in Nm')
ylabel('Rotor speed in rad/sec')
% Transfer to keyboard for simulating the braking with Va = 0
disp('Displaying braking characteristics in Fig. 1');
disp('Run simulation of braking with Va=0 before returning')
keyboard
clf;
subplot(4,1,1)
plot(y(:,1),y(:,5))
title('Rotor speed')
ylabel('wm in rad/sec')
subplot(4,1,2)
plot(y(:,1),y(:,4))
axis([-inf inf -200 200])
title('Braking Torque Tem with Va=0')
ylabel('Tem in Nm')
subplot(4,1,3)
plot(y(:,1),y(:,3))
title('Armature current')
ylabel('Ia in A')
subplot(4,1,4)
plot(y(:,1),y(:,2))
title('Internal voltage Ea')
ylabel('Ea in V')
xlabel('time in sec')
