% MATLAB M-file m5.m is for Project 5 on
% 	self-controlled	permanent magnet motor drive of Chapter 10
% It is to be used with the SIMULINK file s5.m 

% m5.m does the following: 
% (1) loads machine parameters of the permanent magnet motor
%     determine the steady-state characteristics of the motor
%     where torque output is linearly varying with stator current
%     amplitude,
% (2) sets up the initial operating condition for 
%     simulation of s5.m, and
% (3) plots results from simulation
% ************************************************************   

% clear workspace of all variables

clear all;

% put permanent magnet synchronous motor parameters in
% in Matlab workspace 

% Machine data from
% Bose, B. K., "A High-Performance Inverter-Fed Drive System of 
% an Interior Permanent Magnet Synchronous Machine,"
% IEEE Trans. on Industry Applications, Vol. 24, 
% Vol. 6, Nov/Dec 1988, pp. 996
% Copyright 1988 IEEE

Frated = 710.48/(2*pi); % base speed in elect rad/sec 
Poles = 4; % 4 pole machine
Prated = 70*746; % 70 hp motor 
Vrated = 58.5*sqrt(3); % given rms phase to neutral value
Em = 40.2*sqrt(3);% wb*lambda'm - magnet's excitation voltage
we = 2*pi*Frated;
wb = 2*pi*Frated;
wbm = wb*(2/Poles);
Sb = Prated;
Vb = Vrated*sqrt(2/3); % Use peak values as base quantites 
Ib = sqrt(2)*(Sb/(sqrt(3)*Vrated));
Zb = Vb/Ib;
Tb = Sb/wbm;

% QD0 equivalent circuit parameters in engineering units

xls = 0.0189;  
x0 = xls;  
xmq = 0.1747;
xmd = 0.0785;
xq = xls + xmq;
xd = xls + xmd;
rs = 0.00443;
J_rotor = .292; % in Nmsec^2( approx a tenth of estimated value) 
Domega = 1. % rotor damping coefficient 
	%Domega = 1 to 2 when damper windings are not simulated 

% Convert to per unit qdo circuit parameters

fprintf('QD0 circuit paramters in per unit\n')

H = 0.5*J_rotor*wbm*wbm/Sb
rs = rs/Zb
xls = xls/Zb
x0 = x0/Zb
xd = xd/Zb
xq = xq/Zb
xmd = xmd/Zb
xmq = xmq/Zb
Em = Em*sqrt(2/3)/Vb % convert line-to-line to per unit
Ipm = Em/xmd; % equivalent magnet field excitation current

%****************************************************
% Compute settings for variables in simulation

xMQ = (1/xls + 1/xmq )^(-1)
xMD = (1/xls + 1/xmd )^(-1)


% Want torque to be proportional to stator current magnitude 
% and underexcited (that is Vs > Em) motoring and generating conditions
% the phasor Is is kept within the phasors Em and Vs 
% underexcited motoring -> leading internal power factor  
% 		but lagging terminal power factor
% underexcited generating -> lagging internal power factor  
% 		but leading terminal power factor

Temo = 1;
Tem = [Temo:-0.05:-Temo]; 
N=length(Tem);
for n=1:N
Is = Tem(n)/Temo; % Is to be proportional to output torque
if Is == 0;
sing = 0;
else
options = [0, 1.e-6]; % tolerance
sing = fmin('m5torqi',-0.8,0.8,options,Tem(n),Em,Is,xd,xq);
end % if Is
cosg = sqrt(1 - sing*sing);
gamma(n) = atan(sing/cosg);
Iq(n) = Is*cosg;
Id(n) = Is*sing;
Vd(n) = - Iq(n)*xq; 
Vq(n) = Em + Id(n)*xd;
Vs(n) = sqrt(Vd(n)*Vd(n) + Vq(n)*Vq(n));
delta(n) = Vd(n)/Vs(n); % negative for motoring
phi(n) = delta(n) - gamma(n); 
Iqe(n) = Is*cos(phi(n)); 
Ide(n) = Is*sin(phi(n)); 
Q(n) = Vq(n)*Id(n) - Vd(n)*Iq(n); 
P(n) = Vq(n)*Iq(n) + Vd(n)*Id(n);

% plot steady state torque versus angle curve for motor with
% above Ipm and parameters

if Tem(n) <= 0 
mdel = (0:0.1:(pi +0.1));
else 
mdel = (0:-0.1:-(pi +0.1));
end % if Tem
Ndel=length(mdel);
texcm = Vs(n)*Em/xd;
trelm = Vs(n)*Vs(n)*(1/xq -1/xd)/2;
for m=1:Ndel
mdeln = mdel(m);
tres(m) = - texcm*sin(mdeln) - trelm*sin(2*mdeln);
end % for m loop


subplot(2,2,1)
plot(mdel(:), tres(:),'-') 
hold on
ylabel('torque in pu')
xlabel('delta in radians')
axis square;
title('Steady-state torque vs. angle curves')
end % for n major loop

%Perform curve fitting for simulating the following relationships 
% that are not monotonic ( can not be represented by Lookup tables)  
% 	Ide versus Iqe
% 	Vs   versus Tem
IdeIqe = polyfit(Iqe',Ide',2); 
VsTem = polyfit(Tem',Vs',2); 

hold off
subplot(2,2,2)
plot(Tem,Vs,'-')
xlabel('Tem in pu')
ylabel('Vs in pu')
axis square;
title('Stator voltage vs. torque')
subplot(2,2,3)
plot(Iqe,Ide,'-')
xlabel('Iqe in pu')
ylabel('Ide in pu')
axis square;
title('Ide vs. Iqe' )
subplot(2,2,4)
plot(Tem,Iqe,'-',Tem,Ide,'--')
xlabel('Tem in pu')
ylabel('Iqe and Ide in pu')
axis square;
title('Iqe and Ide vs. torque' )
h1=figure;
subplot(2,2,1)
plot(Tem,Vq,'-',Tem,Vd,'--')
xlabel('Tem in pu')
ylabel('Vq and Vd in pu')
axis square;
title('Vq and Vd vs. torque' )
subplot(2,2,2)
plot(Tem,Iq,'-', Tem, Id,'--')
xlabel('Tem in pu')
ylabel('Iq and Id in pu')
axis square;
title('Iq and Id vs. torque' )
subplot(2,2,3)
plot(Tem,gamma,'-',Tem,phi,'k:',Tem, delta,'--')
xlabel('Tem in pu')
ylabel('Gamma, phi, and delta in rad')
axis square;
title('Gamma, phi, and delta vs torque')
subplot(2,2,4)
plot(P,Q,'-')
xlabel('Pmotor in pu')
ylabel('Qmotor in pu')
axis square;
title('Reactive vs. active power')
disp('Save steady-state plots and return for simulation')
keyboard
close(h1)

% Specify desired operating condition lists

% ****** BEGIN KEYBOARD ENTRY OF DESIRED OPERATING CONDITION *********

% set choice to initialize simulation 
% for starting runs, initialize with zeros  

disp('Choice of initial values for simulation')  

opt_initial = menu('Initial condition for simulation? ','Initialize with ss condition','Initialize with zeros') 

% set up loop for repeating multiple cases in which 
% the magnet strength has to be determined from terminal operating
% condition 

repeat_option = 3 ; % set initially to 3 to repeat yes for more cases

while repeat_option  == 3

if (opt_initial == 1) % initialize integrators with ss condition
disp(' Waiting for keyboard entry of desired')
disp('   Temo and Vso in per unit.') 
disp('   Example: enter Temo = 1.0; Vso = 1.0')
disp('    and then enter ''return'' to continue');

keyboard % keyboard entry of Temo and Vs

% ************* END OF INPUT BLOCK ***************

sindo = fmin('m5torqv',-0.2,-2,[],Temo,Em,Vso,xd,xq);
Vdo = Vso*sindo; 
cosdo = sqrt(1 - sindo*sindo);
delo = atan(sindo/cosdo); % also the power factor angle 
Vqo = Vso*cosdo;
Iqo = -Vdo/xq; 
Ido = (Vqo-Em)/xd;
Iso = sqrt(Iqo*Iqo + Ido*Ido)
cosgo = Iqo/Iso; % cos of gamma, internal power factor angle
singo = Ido/Iso;
gammao = atan(singo/cosgo); % internal power factor angle

Psiado = xmd*(Ido + Ipm);
Psiaqo = xmq*(Iqo);
Psiqo = xls*(Iqo) + Psiaqo;
Psido = xls*(Ido) + Psiado;
wrbywbo = 1; %when wr = wb,
tmecho = (xd -xq)*Ido*Iqo + xmd*Ipm*Iqo;
end % if opt_initial == 1

if (opt_initial == 2) % initialize integrators with zeros
Psiado = xmd*Ipm; % non-zero permanent magnet field 
Psiaqo = 0;
Psiqo =  Psiaqo;
Psido =  Psiado;
wrbywbo = 0; % at standstill, wr = 0
end % if opt_initial == 2

repeat_option  = 2 % reset to enter next loop

% set up loop for repeating runs with different external 
% parameters, such as rotor inertia, loading

while repeat_option  == 2

disp('Parameters and initial condition are in Matlab workspace')
disp('Transfering to keyboard mode to run simulation')

tstop = 3 % display run time of simulation 
H % display inertia constant of rotor assembly

% program time and output arrays of repeating sequence

tref_time = [0 1 1 1.2 1.2 2.2 2.2 tstop]
tref_value = [1 1 0 0 -1 -1 1 1] % negative for motoring load
tmech_time = [0  tstop]
tmech_value = [0 0] % negative for motoring load

disp('Type in any change in parameters or torque command')
disp('in Matlab workspace before performing simulation')
disp('  tstop =  - stop time for simulation') 
disp('  H - the inertia constant of rotor assembly')
disp('  tmech_value - values of repeating sequence signal for Tmech') 
disp('Perform simulation(s). When ready to plot results type ''return''');

keyboard
clf;

% plots of Figure No.1
subplot(4,1,1)
plot(y(:,1),y(:,2),'-')
ylabel('Tem* in pu')
axis([-inf inf -1.5 1.5])
title('Torque command')
subplot(4,1,2)
plot(y(:,1),y(:,7),'-')
ylabel('Tem in pu')
axis([-inf inf -1.5 1.5])
title('Output torque')
subplot(4,1,3)
plot(y(:,1),y(:,3),'-')
ylabel('Iq* in pu')
axis([-inf inf -1.5 1.5])
title('Rotor reference Iq command')
subplot(4,1,4)
plot(y(:,1),y(:,4),'-')
title('Rotor reference Id command')
ylabel('Id* in pu')
axis([-inf inf -1.5 1.5])
xlabel('Time in sec')

h1=figure;
subplot(4,1,1)
plot(y(:,1),y(:,8),'-')
ylabel('wr/wb in pu')
title('Rotor speed in pu')
subplot(4,1,2)
plot(y(:,1),y(:,5),'-')
ylabel('Psis in pu')
title('Stator flux')
subplot(4,1,3)
plot(y(:,1),y(:,6),'-')
ylabel('Vs in pu')
axis([-inf inf -1.5 1.5])
title('Phase a voltage')
subplot(4,1,4)
plot(y(:,1),y(:,9),'-')
ylabel('Is in pu')
axis([-inf inf -1.5 1.5])
title('Phase a current')
xlabel('Time in sec')

disp('Transfer to keyboard mode for saving of results')
disp('type ''return'' to continue next run or quit');
keyboard
close(h1)

% prompt for options to repeat over with determination of Ipm
% for  new terminal condition or 
% just with new parameters, eg  inertia or loading.
repeat_option = menu('Repeat what options?,','Quit','Repeat run');
if isempty(repeat_option) % if empty return a 1 to terminate
repeat_option = 1;
end % if isempty
end % while repeat for another runs
end % while repeat for study
