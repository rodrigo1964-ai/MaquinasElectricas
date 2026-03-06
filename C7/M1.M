% MATLAB script file m1.m file for Projects 1 and 5 on
%  operating characteristics of synchronous machine 
%  in Chapter 7

% m1.m does the following: 
% 	loads machine parameters
% 	set up study condition for s1.m 
% clear workspace of all variables

clear variables;

% select machine parameter file to enter into Matlab workspace
disp('Enter filename of machine parameter file without .m')
disp('Example: set1 or set3c')
setX = input('Input machine parameter filename > ','s')% string s
eval(setX); % evaluate MATLAB command


% Calculate base quantities
we = 2*pi*Frated;
wbase = 2*pi*Frated;
wbasem = wbase*(2/Poles);
Sbase = Prated/Pfrated;
Vbase = Vrated*sqrt(2/3); % Use peak values as base quantites 
Ibase = sqrt(2)*(Sbase/(sqrt(3)*Vrated));
Zbase = Vbase/Ibase;
Tbase = Sbase/wbasem;

% Calculate dq0 equivalent circuit parameters

if(xls ==0) xls = x0 % assume leakage reactance = zero_sequence
end

xmq = xq - xls;
xmd = xd - xls;

xplf = xmd*(xpd - xls)/(xmd - (xpd-xls));

xplkd = xmd*xplf*(xppd-xls)/(xplf*xmd - ...
         (xppd-xls)*(xmd+xplf));

xplkq = xmq*(xppq - xls)/(xmq - (xppq-xls));

rpf = (xplf + xmd)/(wbase*Tpdo);

rpkd = (xplkd + xpd - xls)/(wbase*Tppdo);

rpkq = (xplkq + xmq)/(wbase*Tppqo);

% Convert to per unit dqo circuit parameters

if(Perunit == 0) % parameters given in Engineering units
fprintf('Dq0 circuit paramters in per unit\n')

H = 0.5*J_rotor*wbasem*wbasem/Sbase;
rs = rs/Zbase;
xls = xls/Zbase;

xppd = xppd/Zbase;
xppq = xppq/Zbase;
xpd = xpd/Zbase;
xpq = xpq/Zbase;

x2 = x2/Zbase;
x0 = x0/Zbase;

xd = xd/Zbase;
xq = xq/Zbase;

xmd = xmd/Zbase;
xmq = xmq/Zbase;

rpf = rpf/Zbase;
rpkd = rpkd/Zbase;
rpkq = rpkq/Zbase;

xplf = xplf/Zbase;
xplkd = xplkd/Zbase;
xplkq = xplkq/Zbase;

end
%****************************************************
% Establish initial conditions for starting simulation

wb=wbase;
xMQ = (1/xls + 1/xmq + 1/xplkq)^(-1);
xMD = (1/xls + 1/xmd + 1/xplf + 1/xplkd)^(-1);

% Specify desired operating condition lists

P = 1.0;% specify range and increment of real 
Q = 0; 	% and reactive output power, 
			% P is negative for motoring  
Vt = 1. + 0*j;         	% specify terminal voltage
thetaeo = angle(Vt); % initial value of voltage angle  
Vm = abs(Vt);
St = P+Q*j;	% generated complex power
  

% Use steady-state phasor equations to determine
% steady-state values of fluxes, etc to establish good 
% initial starting condition for simulation
%  - or good estimates for the trim function

%    It - phasor current of generator
%    St - complex output power of generator
%    Vt - terminal voltage phasor
%    Eq - Voltage behind q-axis reactance 
%    I  - d-q current with q axis align with Eq

  It = conj(St/Vt);
  Eq = Vt + (rs + j*xq)*It; 
  delt = angle(Eq);          % angle Eq leads Vt

% compute q-d steady-state variables

  Eqo = abs(Eq);
  I = It*(cos(delt) - sin(delt)*j);% same as I = (conj(Eq)/Eqo)*It;
  Iqo = real(I);
  Ido = -imag(I);        % when the d-axis lags the q-axis
  Efo = Eqo + (xd-xq)*Ido;
  Ifo = Efo/xmd;

  Psiado = xmd*(-Ido + Ifo);
  Psiaqo = xmq*(-Iqo);

  Psiqo = xls*(-Iqo) + Psiaqo;
  Psido = xls*(-Ido) + Psiado;
  Psifo = xplf*Ifo + Psiado;
  Psikqo = Psiaqo;
  Psikdo = Psiado;

  Vto = Vt*(cos(delt) - sin(delt)*j);
  Vqo = real(Vto);
  Vdo = -imag(Vto);
  Sto = Vto*conj(I);
  Eqpo = Vqo + xpd*Ido + rs*Iqo;
  Edpo = Vdo - xpq*Iqo + rs*Ido;
  
  delto = delt;% initial value of rotor angle
  thetaro = delto+thetaeo;% thetar(0) in variable frequency oscillator
  Pemo = real(Sto);
  Qemo = imag(Sto);
  Tmech = Pemo;

T2piby3 = 2*pi/3; % phase angle of bus phase voltages

% set up loop for repeating multiple cases using the same 
% starting condition

repeat_option = 2 ; % set initially to 2 to repeat yes for more cases
while repeat_option  == 2

% prompt for choice of disturbance 
disp('Choices of disturbance')
opt_dist = menu('Your choice of disturbances? ','Step change in Eex', 'Step change in Tmech','Step change in Vm')

if (opt_dist == 1) % step change in Eex
tstop = 5; % run time
Vm_time = [0 tstop];
Vm_value = [1 1]*Vm; % Bus voltage kept constant
tmech_time = [0 tstop];
tmech_value = [1 1]*Tmech; % Tmech kept constant 
Ex_time = [0 0.2 0.2 tstop];
Ex_value = [1 1 1.1 1.1]*Efo; % step change in Eex 
disp(' Disturbance sequence in Eex is ')
Ex_time  
Ex_value
end % if for step change in Eex

if (opt_dist == 2) % step change in Tmech
tstop = 5; % run time
Vm_time = [0 tstop];
Vm_value = [1 1]*Vm; % Bus voltage kept constant
tmech_time = [0 0.5 0.5 3 3 tstop];
tmech_value = [1 1 0 0 -1 -1]*Tmech; % step change in Tmech 
Ex_time = [0 tstop];
Ex_value = [1 1]*Efo; % Eex kept constant 
disp(' Disturbance sequence in Tmech is ')
tmech_time
tmech_value
end % if for step change in Tmech

if (opt_dist == 3) % step change in Vm
tstop = 1.5; % run time
tmech_time = [0 tstop];
tmech_value = [1 1]*Tmech; % step change in Tmech 
Ex_time = [0 tstop];
Ex_value = [1 1]*Efo; % Eex kept constant 
disp('Three phase terminal short-circuit fault')
disp('will be applied at 0.1 second into the simulation')
ncycle = input('Enter in the number of cycles desired > ')
tfault = ncycle/Frated; % fault time
tfstart = 0.1; % set fault to begin at 0.1 sec into simulation
Vm_time = [0 tfstart tfstart (tfstart+tfault) (tfstart+tfault) tstop];
Vm_value = [1 1 0 0 1 1]*Vm; % Vm is zero during short circuit
disp(' Disturbance sequence in Vm is ')
Vm_time % print array
Vm_value % print array
end % if for step change in Vm

% Transfer to keyboard for simulation
disp('Simulation s1.m is now ready for running,');
disp(' You may still enter changes to parameters or input values')
disp('  via the MATLAB window before running s1')
disp('Ater running s1, type ''return'' for plots');
keyboard
clf;

subplot(4,1,1)
plot(y(:,1),y(:,2),'-')
ylabel('|Vt| in pu')
axis([-inf inf 0.9 1.1])
title('stator voltage magnitude')
subplot(4,1,2)
plot(y(:,1),y(:,3),'-')
ylabel('|It| in pu')
axis([-inf inf 0 inf])
title('stator current magnitude')
subplot(4,1,3)
plot(y(:,1),y(:,4),'-')
ylabel('Pgen in pu')
title('Real power generated')
subplot(4,1,4)
plot(y(:,1),y(:,5),'-')
ylabel('Qgen in pu')
xlabel('time in sec')
title('Reactive power generated')

h2=figure;
subplot(4,1,1)
plot(y(:,1),y(:,6),'-')
ylabel('Delta in rad')
title('Power angle delta')
subplot(4,1,2)
plot(y(:,1),y(:,7),'-')
ylabel('Tem in pu')
title('Instantaneous electrical torque')
subplot(4,1,3)
plot(y(:,1),y(:,8),'-')
ylabel('If in pu')
title('Field current')
subplot(4,1,4)
plot(y(:,1),y(:,9),'-')
ylabel('ia in pu')
xlabel('time in sec')
title('Instantaneous phase a current')

disp('Save plots array before typing return to exit')
keyboard
close (h2)
% prompt for options to repeat over with determination of Ipm
% for  new terminal condition or
% just with new parameters, eg  inertia or loading.
repeat_option = menu('Repeat run?,','Quit','Repeat run');
if isempty(repeat_option) % if empty return a 1 to terminate
repeat_option = 1;
end % if isempty
end % while repeat for another runs

