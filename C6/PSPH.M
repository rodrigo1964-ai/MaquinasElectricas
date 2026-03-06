% Parameters of single-phase induction motor for Project 6 of Chapter 6 

Sb = 186.5;	% 1/4 hp rating in VA
Prated = 186.5;	% 1/4 hp output power in W
Vrated = 110;	% rated rms voltage in V 
P = 4; 	  	% number of poles
frated = 60;	% rated frequency in Hz
wb = 2*pi*frated;% base electrical frequency
we = wb;
wbm = 2*wb/P;	% base mechanical frequency
Tb = Sb/wbm; 	% base torque
Zb = Vrated*Vrated/Sb;	%base impedance in ohms
Vm = Vrated*sqrt(2);	% magnitude of phase voltage
Vb = Vm; % base rms voltage
Tfactor = P/(2*wb); % torque expression coefficient 

% 1/4 hp, 4 pole, 110 volts capacitor start, capacitor run,
% single-phase induction motor parameters in engineering units from
%
% Krause, P. C. , "Simulation of Unsymmetrical Induction
% Machinery," IEEE Trans. on Power Apparatus,
% Vol.PAS-84, No.11, November 1965.
% Copyright 1965 IEEE

Nq2Nd = 1/1.18;	% Nqs/Nds main to aux wdg turns ratio 
rqs = 2.02;	% main wdg resistance 
xlqs = 2.79;	% main leakage reactance 
rds = 7.14; 	% aux wdg resistance
xlds = 3.22;	% aux leakage reactance 
rpds=(Nq2Nd^2)*rds;% aux wdg resistance referred to main wdg
xplds=(Nq2Nd^2)*xlds;% aux wdg leakage reactance referred to main wdg
xplr = 2.12; 	% rotor leakage reactance referred to main wdg
rpr = 4.12;	% rotor wdg resistance referred to main wdg 
xmq = 66.8;	% magnetizing reactance referred to main wdg
xMq = 1/(1/xmq + 1/xlqs + 1/xplr);
xMd = 1/(1/xmq + 1/xplds + 1/xplr);
J = 1.46e-2;	% rotor inertia in kg m2
H = J*wbm*wbm/(2*Sb); % rotor inertia constant in secs.
Domega = 0; % rotor damping coefficent

zcstart = 3 - j*14.5; % starting capacitor in Ohms
zcrun = 9 - j*172; % running capacitor in Ohms
wrsw = 0.75*wb; % rotor speed to change over from start to run in rev/min
