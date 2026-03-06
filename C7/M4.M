% MATLAB script file m4.m is for Project 4 on permanent magnet
%   synchronous motor in Chapter 7.

% m4.m does the following: 
%   loads machine parameters of the permanent magnet motor
%   set up initial  operating condition 
% clear workspace of all variables
clear variables;

% Enter into MATLAB workspace the per unit parameter of 
% 230 V, 4 hp, 2-pole, 60 Hz, three-phase line-start 
% permanent magnet synchronous motor given in

Frated = 60; % 60 Hz. source
Poles = 2; % 2 pole machine
Vrated = 230; % 230 V rms line to line  
we = 2*pi*Frated;
wbase = 2*pi*Frated;
wbasem = wbase*(2/Poles);
%Sbase = Prated;
%Vbase = Vrated*sqrt(2/3); % Use peak values as base quantites 
%Ibase = sqrt(2)*(Sbase/(sqrt(3)*Vrated));
%Zbase = Vbase/Ibase;
%Tbase = Sbase/wbasem;

% QD0 equivalent circuit parameters in per unit
Domega = 0 % rotor damping coefficient

fprintf('QD0 circuit paramters in per unit\n')

H = 0.3;
rs = 0.017;
xls = 0.065;
x0 = xls;
xd = 0.543;
xq = 1.086;
xmq = xq - xls;
xmd = xd - xls;
rpkd = 0.054;
rpkq = 0.108;
xplkd = 0.132;
xplkq = 0.132;

%****************************************************
% Compute settings for variables in simulation

wb=wbase
xMQ = (1/xls + 1/xmq + 1/xplkq)^(-1);
xMD = (1/xls + 1/xmd + 1/xplkd)^(-1);

% Specify desired operating condition lists

% ****** BEGIN KEYBOARD ENTRY OF DESIRED OPERATING CONDITION *********

% set choice to initialize simulation 
% for starting runs, initialize with zeros  

disp('Choice of initial values for simulation')  

opt_initial = menu('Option to use ss condition to initialize? ',...
'Initialize with ss condition','Initialize with zeros') 

% set up loop for repeating multiple cases in which 
% the magnet strength has to be determined from terminal operating
% condition 

repeat_option = 3 ; % set initially to 3 to repeat yes for more cases

while repeat_option  == 3
   

Vt = input('Enter pu terminal voltage, e.g 1+j*0, Vt = ')
Vm = abs(Vt);

disp(' Enter your choice to specify magnet excitation') 
opt_magnet = menu('Option to specify i_m ? ', 'Will specify delta and i_m directly','Compute im for desired operating condition')

if (opt_magnet == 1) % enter i'm and delta 
Ipm = input('Enter pu value of Ipm , e.g 1.8, Ipm = ')
delt = input('Enter value of delta in radians, e.g. -1.2, delta = ')
Emo = Ipm*xmd % pm excitation voltage
Ido = (Vm*cos(delt) - Emo)/xd;
Iqo = -Vm*sin(delt)/xq;
end % opt-magnet ==1

if (opt_magnet == 2) % determine i'm from given operating condition 
% Steady-state calculations to help determine the required
% equivalent magnetizing current, i'm,  of permanent magnets 
% when lambda'm is not specified. 

Sm = input('Enter pu complex power into motor, e.g 1+j*0, Sm = ')

% ************* END OF INPUT BLOCK ***************

  

% Use steady-state phasor equations to determine
% steady-state values of fluxes, etc to establish the 
% initial starting condition for simulation

%    It - pu phasor current of motor
%    Sm - pu complex input power of motor
%    Vt - pu terminal voltage phasor
%    Eq - pu voltage behind q-axis reactance 
%    I  - pu rotor qd current with q axis align with Eq

  It = conj(Sm/Vt); % It = (Iqe - j*Ide) in pu
  Eq = Vt - (rs + j*xq)*It; % Eq = Eqe - j*Ede in pu 
  delt = angle(Eq);  % angle Eq leads Vt

% compute rotor qd steady-state variables

  Eqo = abs(Eq);
  I = It*(cos(delt) - sin(delt)*j);% same as I = (conj(Eq)/Eqo)*It;
  Iqo = real(I); 
  Ido = -imag(I); % d-axis lags q-axis
  Emo = Eqo - (xd-xq)*Ido; % pm excitation voltage 
disp('Per unit magnetizing current of magnet, Ipm, is')  
  Ipm = Emo/xmd %equiv. magnetizing current of permanent magnet
end % if opt_magnet == 2

disp('Computing and plotting steady-state curve next')
% plot steady-state torque versus angle curve for motor, 
% using above Ipm and parameters
% but neglecting stator resistance 

mdel = (0:-0.1:-(pi +0.1));
N=length(mdel);
texcm = Vm*Ipm*xmd/xd;
trelm = Vm*Vm*(1/xq -1/xd)/2;
for n=1:N
mdeln = mdel(n);
texc(n) = - texcm*sin(mdeln);
trel(n) = - trelm*sin(2*mdeln);
tres(n) = texc(n) + trel(n); % ignoring stator resistance
end
clf;
plot(mdel(:), trel(:),'--', mdel(:), texc(:),':',mdel(:), tres(:),'-') 
ylabel('torque in pu')
xlabel('delta in radians')
axis square;
title('Steady-state torque vs. angle curves')

if (opt_initial == 1) % initialize integrators with ss condition
  Psiado = xmd*(Ido + Ipm);
  Psiaqo = xmq*(Iqo);
  Psiqo = xls*(Iqo) + Psiaqo;
  Psido = xls*(Ido) + Psiado;
  Psikqo = Psiaqo;
  Psikdo = Psiado;
  wrslipo = 0; %when wr = we, (wr-we)/we is zero 
  delto = delt; % here delto = thetar(0)- thetae(0)
  temo = (xd -xq)*Ido*Iqo + xmd*Ipm*Iqo;
end % if opt_initial == 1

if (opt_initial == 2) % initialize integrators with zeros
  Psiado = xmd*Ipm; % permanent field excitation always on
  Psiaqo = 0;
  Psiqo =  Psiaqo;
  Psido =  Psiado;
  Psikqo = Psiaqo;
  Psikdo = Psiado;
  wrslipo = -1; % at standstill, wr = 0,(wr-we)/we is -1 
  delto = 0; % here delto = thetar(0)- thetae(0)
  temo = 0; % 
end % if opt_initial == 2

repeat_option  = 2 % reset to enter next loop

% set up loop for repeating runs with different external 
% parameters, such as rotor inertia, loading

while repeat_option  == 2

tstop = 1.5 % run time of simulation 
H % inertia constant of rotor assembly

% program time and output arrays of repeating sequence
% signal for input mechanical torque, Tmech, (negative for motoring load 
% and equivalent magnetizing current of magnet, Ipm. 

tmech_time = [0 tstop]
tmech_value = [-1 -1]*temo % Tmech is negative for motoring load

disp('Save steady-state plot and enter desired changes')
disp('  in parameters or loading now via MATLAB window')
disp('e.g. 	tstop - stop time for simulation') 
disp('  		H - the inertia constant of rotor assembly')
disp('  		tmech_value - values of Tmech') 
disp('Perform simulation then type ''return'' for plots');

keyboard
clf;


% plots of Figure No.1
subplot(3,1,1)
plot(y(:,1),y(:,2),'-')
ylabel('Pm in pu')
title('Real input power')
subplot(3,1,2)
plot(y(:,1),y(:,3),'-')
ylabel('Qm in pu')
title('Reactive input power')
subplot(3,1,3)
plot(y(:,1),y(:,6),'-')
ylabel('Delta in rad')

h1=figure;
title('Power angle delta')
subplot(3,1,1)
plot(y(:,1),y(:,7),'-')
ylabel('wr/wb in pu')
axis([-inf inf -1. 1.5])
title('per unit speed')
subplot(3,1,2)
plot(y(:,1),y(:,9),'-')
ylabel('ia in pu')
xlabel('Time in sec')
title('Instantaneous phase a current')

% compute induction torque component
% and plot torque components with torque in Figure 2
Tinduction = y(:,8) - y(:,4) - y(:,5);

h2=figure;
subplot(4,1,1)
plot(y(:,1),y(:,8),'-')
ylabel('Tem in pu')
title('Instantaneous electrical torque')
subplot(4,1,2)
plot(y(:,1),y(:,4),'-')
ylabel('Trel in pu')
title('Reluctance component')
subplot(4,1,3)
plot(y(:,1),Tinduction,'-')
ylabel('Tind in pu')
title('Induction component')
subplot(4,1,4)
plot(y(:,1),y(:,5),'-')
ylabel('Texc in pu')
title('Excitation component')
xlabel('Time in sec')

% put delta in principal value between -pi and pi
% and plot principal value delta 

deltp = angle(exp(j*y(:,6)));

h3=figure;
subplot(1,1,1)
plot(y(:,1),deltp,'-')
ylabel('Delta in rad')
title('Power angle delta')
disp('Results displayed in four figure windows')
disp('Save plots before typing ''return'' to continue');
keyboard
close(h1)
close(h2)
close(h3)

% prompt for options to repeat over with determination of Ipm
% for  new terminal condition or 
% just with new parameters, eg  inertia or loading.
repeat_option = menu('Repeat what options?,','Quit','Just new parameters', 'Recalculate Ipm for new condition');
if isempty(repeat_option) % if empty return a 1 to terminate
repeat_option = 1;
end % if isempty
end % while repeat_option for new parameters
end % while repeat_option for new case


