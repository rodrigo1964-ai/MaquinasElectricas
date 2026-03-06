% MATLAB script file m3.m for Project 3 on field-oriented 
%   motor drive in Chapter 9
% m3.m sets up the machine parameters, simulated disturbances,
%   and also plots the results.
% Changes in machine parameters and simulated disturbances
%  can be made by either editing this file and rerunning it
%  or entering the changes directly in the MALTAB window 
%  after running this file to initialize the workspace.   

clear all % clear workspace

% Parameters of 20 hp machine

p20hp

% Calculation of torque speed curves
vas = Vrated/sqrt(3); % specify rms phasor voltage
we = wb; 		% specify excitation frequency
xls = (we/wb)*xls;  % reactances at exctiation frequency
xplr = (we/wb)*xplr;  % reactances at exctiation frequency
xm = (we/wb)*xm;  % reactances at exctiation frequency

xM = 1/(1/xm + 1/xls + 1/xplr);
xs = xls + xm; % stator self reactance  
xr = xplr + xm; % rotor self reactance
xsprime = xs - xm*xm/xr; % stator transient reactance 

% Thevenin's equivalent
vth = abs((j*xm/(rs + j*(xls + xm)))*vas);
zth = (j*xm*(rs + j*xls)/(rs + j*(xls + xm )));
rth = real(zth);
xth = imag(zth);

% Compute rotor resistances
% rotor resistance for max torque at s=1
rpr1 = sqrt(rth^2 + (xth + xplr)^2);
%rprm = 0.4*sqrt(rth^2 + (xth + xplr)^2);


%set up vector of rotor resistances
%rprv = [rpr rprm rpr1]
rprv = [rpr];
Nrr=length(rprv); 

s = (1:-0.01:0.02);
N=length(s); 

for n=1:N
sn = s(n);
wr(n)=2*we*(1-sn)/P;
for nrr = 1:Nrr
rrn = rprv(nrr);
zin=(rs +j*xls) + j*xm*(rrn/sn + j*xplr)/(rrn/sn + j*(xm + xplr));
ias = vas/zin; 
Sin =3*vas*conj(ias); 
pin = real(Sin);
pfin(nrr,n)=cos(-angle(ias));
iin(nrr,n)=abs(ias);
te(nrr,n)=(3*P/(2*we))*(vth^2*rrn/sn)/((rth + rrn/sn)^2 + (xth + xplr)^2);
pe(nrr,n)=te(nrr,n)*wr(n);
eff(nrr,n)=100*pe(nrr,n)/pin;

end % nrr for loop
end % n for loop

% add in synchronous speed values
size(te);
z=[0];
inl=vas/(rs +j*(xls+xm));
inlm = abs(inl);
inla = cos(-angle(inl));
iin=[iin [inlm]'];
pfin=[pfin [inla]'];
eff=[eff z'];
te=[te z'];
pe=[pe z'];
s=[s 0];
wr=[wr 2*we/P];
% determine the rotor flux at no-load 

eprime = vas - (rs +j*xsprime)*inl; % voltage behind
			% stator transient reactance
lambdadr = real(eprime)*(xr/xm)/we;

% set up speed and flux vectors in lookup table of simulation

speed = [-2: 0.1: 2];
mask = abs(speed)>1.1;
notmask=~mask;
i=find(speed==0); 	%find index of zero speed element
speed(i) = realmin; % and replace it with smallest usable positve number
invspeed = abs(1./speed); % before dividing to avoid divide by zero
% scale flux and speed axis 
lambdadre = lambdadr.*(invspeed.*mask + notmask);
speed = wbm*speed;

N=size(te);
M=size(te);
subplot(2,2,1)
plot(wr,te(1,:),'-')
xlabel('Rotor speed in rad/sec')
ylabel('Torque in Nm')
subplot(2,2,2)
plot(wr,pe(1,:),'-')
xlabel('Rotor speed in rad/sec')
ylabel('Developed power in Watts')
subplot(2,2,3)
plot(wr,iin(1,:),'-')
xlabel('Rotor speed in rad/sec')
ylabel('Stator current in Amps')
subplot(2,2,4)
plot(wr,eff(1,:),'-')
xlabel('Rotor speed in rad/sec')
ylabel('Efficiency in percent')

% setting all initial conditions in SIMULINK simulation to zero
Psiqso = 0;
Psidso = 0;
Psipqro = 0;
Psipdro = 0;
wrbywbo = 0;

tstop = 2.; % run duration in seconds
% set up speed reference signal for load cycling
time_wref=[0 0.5 tstop];
speed_wref=[0 wbm wbm];
% set up Tmech signal for load cycling
time_tmech=[0 0.75 0.75 1.0 1.0 1.25 1.25 1.5 1.5 2];
tmech_tmech=[0 0 -Trated -Trated -Trated/2 -Trated/2 -Trated -Trated 0 0 ];
disp('Simulation set up to start from standstill and ')
disp('load cycling at fixed frequency.')
disp('Run simulation then return for plots')
% Transfer to keyboard for simulation
keyboard

subplot(3,1,1)
plot(y(:,1),y(:,2),'-')
xlabel('Time in sec')
ylabel('wbm* in rad/sec')
subplot(3,1,2)
plot(y(:,1),y(:,3),'-')
xlabel('Time in sec')
ylabel('wbm in rad/sec')
subplot(3,1,3)
plot(y(:,1),y(:,4),'-')
axis([-inf inf -200 200])
xlabel('Time in sec')
ylabel('Vag in V')
H2_fig=figure;
subplot(3,1,1)
plot(y(:,1),y(:,5),'-')
xlabel('Time in sec')
ylabel('Ia in A')
subplot(3,1,2)
plot(y(:,1),y(:,6),'-')
xlabel('Time in sec')
ylabel('Tem in Nm')
subplot(3,1,3)
plot(y(:,1),y(:,7),'-')
xlabel('Time in sec')
ylabel('|Psir| in V')
disp('Save plots before typing return to proceed to next study')
keyboard
close(H2_fig);
 
% set up speed reference signal for speed cycling
time_wref=[0 0.25 0.5 1.0 1.25 1.5];
speed_wref=[0 wbm/2 wbm/2 -wbm/2 -wbm/2 0];
% set up Tmech signal 
time_tmech=[0 tstop];
tmech_tmech=[0 0];
disp('Simulation now set up for speed cycling at no_load')
disp('Run simulation then return for plots')
% Transfer to keyboard for simulation
keyboard

subplot(3,1,1)
plot(y(:,1),y(:,2),'-')
xlabel('Time in sec')
ylabel('wbm* in rad/sec')
subplot(3,1,2)
plot(y(:,1),y(:,3),'-')
xlabel('Time in sec')
ylabel('wbm in rad/sec')
subplot(3,1,3)
plot(y(:,1),y(:,4),'-')
axis([-inf inf -200 200])
xlabel('Time in sec')
ylabel('Vag in V')
H2_fig=figure;
subplot(3,1,1)
plot(y(:,1),y(:,5),'-')
xlabel('Time in sec')
ylabel('Ia in A')
subplot(3,1,2)
plot(y(:,1),y(:,6),'-')
xlabel('Time in sec')
ylabel('Tem in Nm')
subplot(3,1,3)
plot(y(:,1),y(:,7),'-')
xlabel('Time in sec')
ylabel('|Psir| in V')
disp('Save plots before typing return to exit')
keyboard
close(H2_fig);
