% MATLAB M-file m2.m is for Project 2 on 
%    multimachines systems in Chapter 10 
% m2.m iS to be used to in conjunction with s2eig.m.
%    and for setting up the parameters and initial condition 
%    in the SIMULINK file s2.m 

clear all

% m2.m performs the following tasks:

% 	set up the parameters and approximate operating
% 	conditions of generators, and network representation. 

% 	use trim function to determine the 
%		desired steady state of s2eig.m 
%	use linmod function to determine linear model 
%		about the operating point
% 	determines system eigenvalues of linear system 

%	set up to perform step changes in torque of gen 1
%		about the operating point
% 	and fault near bus 3

%       plot machine variables of torque stepping and fault runs

% *********Setting up machine parameters*************
tstop = 30 % stop time for simulation
wb = 2*pi*60;
Sys_Sbase = 1000;, % System's S base in MVA
		% network parameters are on system base

n_unit = 2; % number of generators

% input per unit parameters of generators

% parameters of set 1 synchronous generator
list_A = [1] % list of buses with a machine having these parameters
if isempty(list_A)
else
for bus = list_A
Sbratio(bus) = 1000/920.35;%ratio of system to machine base VA  
rs(bus) = 0.0048;
xd(bus) = 1.790;
xq(bus) = 1.660;
xls(bus) = 0.215;
xpd(bus) = 0.355;
xpq(bus) = 0.570;
Tpdo(bus) = 7.9;
Tpqo(bus) = 0.410;
H(bus) = 3.77;
Domega(bus) = 2; % mechanical damping coeff
KA(bus) = 50; %nominal value
%KA(bus) = 200; %high gain value for case 5
TA(bus) = 0.06;
VRmax(bus) = 1;
VRmin(bus) = -1;
TE(bus) = 0.052;
KE(bus) = -0.0465;
TF(bus) = 1.0;
KF(bus) = 0.0832;
AEx(bus) = 0.0012; 
BEx(bus) = 1.264;
end % for list_A
end % if isempty(list_A)

% parameters of set 2 synchronous generator
list_B = [2] % list of buses with a machine having these parameters
if isempty(list_B)
else
for bus = list_B
Sbratio(bus) = 1000/911;%ratio of system to machine base VA  
rs(bus) = 0.001;
xd(bus) = 2.040;
xq(bus) = 1.960;
xls(bus) = 0.154;
xpd(bus) = 0.266;
xpq(bus) = 0.262;
Tpdo(bus) = 6.000;
Tpqo(bus) = 0.900;
H(bus) = 2.5;
Domega(bus) = 2; % mechanical damping coeff
% Parameters of an alternator-Rectifier Excitation System
KA(bus) = 50;
TA(bus) = 0.060;
VRmax(bus) = 1.0;
VRmin(bus) = -1.0;
TE(bus) = 0.440;
KE(bus) = -0.0393;
TF(bus) = 1.0;
KF(bus) = 0.07;
AEx(bus) = 0.0013; 
BEx(bus) = 1.156;
end % for list_B
end % if isempty(list_B)

% *********Setting up approximate operating condition*************
% Determine initial guess for Matlab trim function
% using approximate terminal operating condition 

 Vt(1) = 1.0+0*j; 
 Vt(2) = 1.0+0*j; 
 St(1) = 0.8 + 0.6*j; % positive for generating
 St(2) = 0.8 + 0.6*j; % negative for motoring

% select voltage regulation type for each generator
% Exc_sw = 1 for ac voltage reg; Exc_sw = 0 for dc voltage reg

Exc_sw(1) = 1;
Exc_sw(2) = 1;

for nu = 1:n_unit

% Determine the rest of the variables for the given 
% operating condition
%    It - phasor current of generator
%    St - complex output power of generator
%    Vt - terminal voltage phasor
%    Eq - Voltage behind q-axis reactance 
%    Vi - Infinite bus voltage phasor 
%    I  - d-q current with q axis align with Eq

  It(nu) = conj(St(nu)/Vt(nu));
  Eq(nu) = Vt(nu) + (rs(nu) +j*xq(nu))*It(nu); 
  delt(nu) = angle(Eq(nu));      % angle Eq leads Vt

% qd variables in generator rotor reference frame

  I(nu) = It(nu)*(cos(delt(nu)) - sin(delt(nu))*j);
  Iqo(nu) = real(I(nu));
  Ido(nu) = -imag(I(nu));        % when the d-axis lags the q-axis
  Efo(nu) = abs(Eq(nu)) + (xd(nu)-xq(nu))*Ido(nu);
  Vto(nu) = Vt(nu)*(cos(delt(nu)) - sin(delt(nu))*j);
  Vqo(nu) = real(Vto(nu));
  Vdo(nu) = -imag(Vto(nu));
  Sto(nu) = Vto(nu)*conj(I(nu));
  Eqpo(nu) = Vqo(nu) + xpd(nu)*Ido(nu) + rs(nu)*Iqo(nu);
  Edpo(nu) = Vdo(nu) - xpd(nu)*Iqo(nu) + rs(nu)*Ido(nu);
  Pemo(nu) = real(Sto(nu));
  Qemo(nu) = imag(Sto(nu));
  Tmech(nu) = Pemo(nu);
  delio(nu) = delt(nu);

  if (Exc_sw(nu)==0) % if dc voltage regulated
  KA(nu) = 0.1; % reset regular gain to avoid saturation 
              % of regulator, reduces iteration in trim 
  KE(nu) = 1; % reset positive to avoid instability
	     % of exciter output
  end

end % for nu loop

% *********Setting up network representation*************
% compute Y bus of network with transient impdeance of machines

Y= zeros(4); % set aside memory locations to improve speed 
Hmod= zeros(4); 

y14=1/(0.004+j*0.1 + (rs(1)+j*xpd(1))*Sbratio(1)); % 1/z14
y24=1/(0.004+j*0.1 + ((rs(2)+j*xpd(2))*Sbratio(2))); % 1/z24
% base VA of gen 2 may not be the same as base system VA  
y34=1/(0.008+j*0.3); % 1/z14
%y34=1/(0.002+j*0.1); % increase network strength, cases 3,4,5   
y40=1.2 -j*0.6; % conj(Pload + jQload)/|Vload|^2
Y(1,1) = y14 ;
Y(1,2) = 0;
Y(1,3) = 0;
Y(1,4) = -y14;
Y(2,1) = 0;
Y(2,2) = y24;
Y(2,3) = 0;
Y(2,4) = -y24;
Y(3,1) = 0;
Y(3,2) = 0;
Y(3,3) = y34;
Y(3,4) = -y34;
Y(4,1) = -y14;
Y(4,2) = -y24;
Y(4,3) = -y34;
Y(4,4) = y40+y14+y24+y34;


% Modify Y bus, gyrate row 4 and column 4

gbus=4; % row and column to be gyrated 
ix = [1 2 3 ]; % index vector 
Hmod(gbus,gbus)=1/Y(gbus,gbus);
Hmod(ix,gbus)=Y(ix,gbus)/Y(gbus,gbus);
Hmod(gbus,ix)=-Y(gbus,ix)/Y(gbus,gbus);
Hmod(ix,ix) = Y(ix,ix) - (Y(ix,gbus)*Y(gbus,ix))/Y(gbus,gbus);

RZ = real(Hmod);
IZ = imag(Hmod);

% *********Determining system eigenvalues*************

% Input guesses to trim function
% Initial values in simulation s2eig.m 

vqe3=1;
vde3=0;
iqe4=0;
ide4=0;

for nu = 1:n_unit
slip(nu) = 0;
Eqp(nu) = Eqpo(nu);
Edp(nu) = Edpo(nu);
Ef(nu) = Efo(nu);
VR(nu) = KE(nu)*Efo(nu);
Vs(nu) = Efo(nu)*KF(nu)/TF(nu);
end;

% Use Simulink trim function to determine a desired 
% operating point for s2eig.m 
% Need to make initial guess of the state (x), the input (u), 
% and output (y). 
% From the diagram of s2eig.m, we see that
% u = [Vref1;Tmech1;Vref2; Tmech2;vqe3;vde3;iqe4;ide4]
% y = [|Vt1|; Pgen1; Qgen2;|Vt2|; Pgen2; Qgen2]
% The ordering, however, is dependent on how Simulink assembles
% the system equation, the current ordering of the state 
% variables by your computer must be determined using 

[sizes,x0,xstr] = s2eig([], [], [], 0) 


% On mine this command yields  xstr =

%/s2eig/tmodel/Eqp                 
%/s2eig/tmodel/Edp                 
%/s2eig/tmodel/Rotor/delta         
%/s2eig/tmodel1/Eqp                
%/s2eig/tmodel1/Edp                
%/s2eig/tmodel1/Rotor/delta        
%/s2eig/tmodel/Rotor/slip          
%/s2eig/tmodel/exciter/Ef          
%/s2eig/tmodel/exciter/Vs          
%/s2eig/tmodel/exciter/VR          
%/s2eig/tmodel1/exciter/Ef         
%/s2eig/tmodel1/exciter/Vs         
%/s2eig/tmodel1/exciter/VR         
%/s2eig/tmodel1/Rotor/slip     


% x =[Eqp(1);Edp(1);delta(1);Eqp(2);Edp(2);delta(2);
% Ef(1);slip(1);Vs(1);VR(1);Ef(2);slip(2);Vs(2);VR(2)]


% If all units are dc field regulated 
u = [Efo(1);Tmech(1);Efo(2);Tmech(2);vqe3;vde3;iqe4;ide4];
if(Exc_sw(1)) % Exc_sw(1) =1 unit 1 ac voltage regulated
u(1) = abs(Vto(1));
elseif(Exc_sw(2))
u(3) = abs(Vto(2)); %unit 2 ac regulated
end

% order of variables in array x has to agree with that
% of xstr

x =[Eqp(1);Edp(1);delio(1);Eqp(2);Edp(2);delio(2);Ef(1);slip(1);Vs(1);VR(1);Ef(2);slip(2);Vs(2);VR(2)];
y =[abs(Vto(1));Pemo(1);Qemo(1);abs(Vto(2));Pemo(2);Qemo(2)];  


% Use index variables to specify which of the above 
% input in the initial guess should be held fixed
% In this instance, we like to specify the 
% Pgen, Qgen, and the infinite bus voltage, vqe3, at 1pu

iu=[5;6;7;8] % vqe3,vde3,iqe4,ide4 held fixed
ix = [] % all state variables can vary
iy = [2;3;5;6] %  Pgen and Qgen held fixed 

% Use Simulink trim function to determine the desired 
% steady-state operating point. For more details
% type help trim after the matlab prompt.
% Output from trim has to be carefully verified 
% before proceeding forth. 

[x,u,y,dx] = trim('s2eig',x,u,y,ix,iu,iy)

% Update steady-state value for initializing simulation 

% Set reference voltage according to whether it is ac or dc
% voltage regulated 
if(Exc_sw(1)) % unit 1 ac voltage regulated
vref(1) = y(1); 
else
vref(1) = u(1); % unit 1 dc regulated 
end;
if(Exc_sw(2)) % unit 2 ac voltage regulated
vref(2) = y(4); 
else % unit 2 dc field regulated 
vref(2) = u(3); 
end;
% Initialize signal generators and integrators
% x =[Eqp(1);Edp(1);delta(1);Eqp(2);Edp(2);delta(2);
% slip(1);Ef(1);Vs(1);VR(1);Ef(2);Vs(2);VR(2);slip(2)]
Tmech(1) = u(2);
Tmech(2) = u(4);
Eqpo(1) = x(1);
Edpo(1) = x(2);
Eqpo(2) = x(4);
Edpo(2) = x(5);
delio(1) = x(3);
delio(2) = x(6);
Ef(1) = x(7);
Vs(1) = x(9);
VR(1) = x(10);
Ef(2) = x(11);
Vs(2) = x(13);
VR(2) = x(14);

% Use Matlab linmod function to determine the state-space
% representation at the chosen operating point
%
%       dx/dt = [A] x + [B] u
%           y = [C] x + [D] u

[A, B, C, D] = linmod('s2eig', x, u);

lambda=eig(A); % determine system eigenvalues

% Print eigenvalues
[mpole,npole] = size(A);
fprintf('\nSystem eigenvalues\n\n')
if(Exc_sw) % Exc_sw =1 when ac voltage regulated
fprintf('\nAC voltage regulated case\n\n')
else % Exc_sw =0 when it is dc field regulated 
fprintf('\nDC voltage regulated case\n\n')
end
	for m = 1:mpole
	fprintf('%12.3e %12.3ei\n',real(lambda(m)), imag(lambda(m)))
	end


% Transfer to keyboard for simulation
disp('Simulation set by m2.m to perform tmech1 cycling');
% set up Tmech1 signal for load cycling
time_tmech1=[0 7.5 7.5 15 15 22.5 22.5 30];
tmech_tmech1=[Tmech(1) Tmech(1) (Tmech(1)+0.1) (Tmech(1)+0.1) (Tmech(1)-0.1) (Tmech(1)-0.1) Tmech(1) Tmech(1)];
% set up iq4e and id4e signal generators  
time_iq4e=[0 30];
iq_iq4e=[0 0 ]; 
time_id4e=[0 30];
id_id4e=[0 0 ]; 

disp('Perform simulation and type return for plots')
keyboard
h1=figure;
subplot(3,1,1)
plot(y1(:,1),y1(:,2),'-')
axis([0,inf,0.6,1.2]) % resize yaxis
xlabel('Time in sec')
ylabel('|Vt|')
subplot(3,1,2)
plot(y1(:,1),y1(:,3),'-')
xlabel('Time in sec')
ylabel('|It|')
subplot(3,1,3)
plot(y1(:,1),y1(:,4),'-')
xlabel('Time in sec')
ylabel('Pgen')
h2=figure;
subplot(3,1,1)
plot(y1(:,1),y1(:,5),'-')
axis([0,inf,0.4,1.0]) % resize yaxis
xlabel('Time in sec')
ylabel('Qgen')
subplot(3,1,2)
plot(y1(:,1),y1(:,6),'-')
xlabel('Time in sec')
ylabel('delta')
subplot(3,1,3)
plot(y1(:,1),y1(:,7),'-')
xlabel('Time in sec')
ylabel('Tem')

h3=figure;
subplot(3,1,1)
plot(y2(:,1),y2(:,2),'-')
axis([0,inf,0.6,1.2]) % resize yaxis
xlabel('Time in sec')
ylabel('|Vt|')
subplot(3,1,2)
plot(y2(:,1),y2(:,3),'-')
xlabel('Time in sec')
ylabel('|It|')
subplot(3,1,3)
plot(y2(:,1),y2(:,4),'-')
xlabel('Time in sec')
ylabel('Pgen')
h4=figure;
subplot(3,1,1)
plot(y2(:,1),y2(:,5),'-')
axis([0,inf,0.4,1.0]) % resize yaxis
xlabel('Time in sec')
ylabel('Qgen')
subplot(3,1,2)
plot(y2(:,1),y2(:,6),'-')
xlabel('Time in sec')
ylabel('delta')
subplot(3,1,3)
plot(y2(:,1),y2(:,7),'-')
xlabel('Time in sec')
ylabel('Tem')
h5=figure;
subplot(3,1,1)
plot(y1(:,1),y1(:,6)-y2(:,6),'-')
xlabel('Time in sec')
ylabel('delta1-delta2')
disp('Save plots and type return to continue')

keyboard

tstop = 15
% Transfer to keyboard for simulation
disp('Simulation now set to perform fault current injection');
% set up Tmech1 signal for load cycling
time_tmech1=[0 15];
tmech_tmech1=[0.8 0.8];
% set up iq4e and id4e signal generators  
time_iq4e=[0 5 5 5.5 5.5 15];
iq_iq4e=[0 0 -2. -2. 0 0]; % negative fault current leaving bus 
time_id4e=[0 5 5 5.5 5.5 15];
id_id4e=[0 0 -2. -2. 0 0]; 

disp('Perform simulation again and return for fault plots')
keyboard
figure(h1) % make figure 1 current window
clf % clear content of current window
subplot(3,1,1)
plot(y1(:,1),y1(:,2),'-')
axis([0,inf,0.6,1.2]) % resize yaxis
xlabel('Time in sec')
ylabel('|Vt|')
subplot(3,1,2)
plot(y1(:,1),y1(:,3),'-')
xlabel('Time in sec')
ylabel('|It|')
subplot(3,1,3)
plot(y1(:,1),y1(:,4),'-')
xlabel('Time in sec')
ylabel('Pgen')

figure(h2); % make figure 2 the current window
clf;
subplot(3,1,1)
plot(y1(:,1),y1(:,5),'-')
axis([0,inf,0.4,1.0]) % resize yaxis
xlabel('Time in sec')
ylabel('Qgen')
subplot(3,1,2)
plot(y1(:,1),y1(:,6),'-')
xlabel('Time in sec')
ylabel('delta')
subplot(3,1,3)
plot(y1(:,1),y1(:,7),'-')
xlabel('Time in sec')
ylabel('Tem')

figure(h3); % make figure 3 the current window
clf;
subplot(3,1,1)
plot(y2(:,1),y2(:,2),'-')
axis([0,inf,0.6,1.2]) % resize yaxis
xlabel('Time in sec')
ylabel('|Vt|')
subplot(3,1,2)
plot(y2(:,1),y2(:,3),'-')
xlabel('Time in sec')
ylabel('|It|')
subplot(3,1,3)
plot(y2(:,1),y2(:,4),'-')
xlabel('Time in sec')
ylabel('Pgen')
figure(h4); % make figure 4 the current window
clf;
subplot(3,1,1)
plot(y2(:,1),y2(:,5),'-')
axis([0,inf,0.4,1.0]) % resize yaxis
xlabel('Time in sec')
ylabel('Qgen')
subplot(3,1,2)
plot(y2(:,1),y2(:,6),'-')
xlabel('Time in sec')
ylabel('delta')
subplot(3,1,3)
plot(y2(:,1),y2(:,7),'-')
xlabel('Time in sec')
ylabel('Tem')
figure(h5);
subplot(3,1,1)
plot(y1(:,1),y1(:,6)-y2(:,6),'-')
xlabel('Time in sec')
ylabel('delta1-delta2')
disp('Save plots and return to exit')
keyboard
close all; % closing all windows
