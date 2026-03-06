% M file for Project 1 on induction motor drive 
% with open loop control in Chapter 9
% It sets the machine parameters and also plots the simulated
% results when used in conjunction with s1open.m    

clear all % clear workspace

% Parameters of 20 hp machine 

p20hp

srated=0.0287; % rated slip
Nrated = 1748.3; % rated speed in rev/min
wmrated=2*pi*Nrated/60; % rated speed in rad/sec
Trated = Sb/wmrated; % rated torque
vasb = 220/sqrt(3); % phase rms voltage
iasb= 49.68; % rated rms phase current


% Calculation of torque speed curves
vas = Vrated/sqrt(3); % specify rms phasor voltage
we = wb; 		% specify excitation frequency
xls = (we/wb)*xls;  % reactances at excitation frequency
xplr = (we/wb)*xplr;  % reactances at excitation frequency
xm = (we/wb)*xm;  % reactances at excitation frequency

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
% determine smaxt for fixed voltage supply case
smaxt = rpr/rpr1;

%set up vector of rotor resistances
%rprv = [rpr rprm rpr1]
rprv = [rpr];
Nrr=length(rprv); 

s = (1:-0.02:0.02);
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


N=size(wr);
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
disp('Displaying Operating Characteristics in Fig. 1')
disp(' type '' return'' to continue');
keyboard

% determine the volts per hertz table for the machine using 
% the modified method giving the torque-speed curve of F10.10 
 
%set up vector of excitation frequency 
w = (-400:4:400); % for lookup table, w has 
		%to be monotonically increasing 
emb = j*iasb*xm;
f = w/(2*pi);
N = length(w);
for n = 1:N
we = w(n);
%volts per hertz with low frequency boost
% for positive slip speed
%    	if(we > 0) %motoring in positive direction
%    	vrms(n) = -11.625*exp(-we/40) + 24 + 0.415*we;
%	else % generating in opposite direction
%    	vrms(n) = 24.83*exp(we/48) - 14 - 0.412*we;
%	end
em = abs(we)*emb/wb;
zs = rs + j*(abs(we)/wb)*xls;
vrms(n) = abs(em + iasb*zs);
end
vrms_vf = vrms; 
we_vf = w;
clf;
plot(f(:),vrms(:),'-')
ylabel('Rms stator phase voltage in V')
xlabel('Excitation frequency in Hz.')
disp('Displaying Volts/Hertz curve, type '' return'' to continue');
keyboard

% Transfer to keyboard for simulation
disp('Set for simulation to start from standstill and ')
disp('load cycling at fixed frequency,')
disp('return for plots after simulation by typing '' return''');
% setting all initial conditions in SIMULINK simulation to zero
Psiqso = 0;
Psidso = 0;
Psipqro = 0;
Psipdro = 0;
wrbywbo = 0; 

% set up speed reference signal for load cycling
time_wref=[0 0.5 4];
speed_wref=[0 1 1]; % speed in per unit
% set up Tmech signal for load cycling
time_tmech=[0 0.75 0.75 1.0 1.0 1.25 1.25 1.5 1.5 2];
tmech_tmech=[0 0 -Trated -Trated -Trated/2 -Trated/2 -Trated -Trated 0 0 ];
 tstop = 2
keyboard

disp('Plot results in two figure windows')
h1=gcf
subplot(3,1,1)
plot(y(:,1),y(:,2),'-')
xlabel('Time in sec')
ylabel('Vag in V')
subplot(3,1,2)
plot(y(:,1),y(:,3),'-')
axis([-inf inf 0 1.2])
xlabel('Time in sec')
ylabel('wr/wb in pu')
subplot(3,1,3)
plot(y(:,1),y(:,4),'-')
xlabel('Time in sec')
ylabel('Tem in Nm')
h2=figure;
subplot(3,1,1)
plot(y(:,1),y(:,7),'-')
xlabel('Time in sec')
ylabel('Ias in A')
subplot(3,1,2)
plot(y(:,1),y(:,6),'-')
xlabel('Time in sec')
ylabel('|Psis| in V')
subplot(3,1,3)
plot(y(:,1),y(:,5),'-')
xlabel('Time in sec')
ylabel('|Psir| in V')

disp('Save plots in Figures 1 and 2')
disp('return to exit');
keyboard;
close(h2);
