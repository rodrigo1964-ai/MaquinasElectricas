% Parameters of machine used in Projects 1 and 3 of Chapter 6 

Sb = 750;	% rating in VA
Prated = 750;	% output power in W
Vrated = 200;	% rated line to line voltage in V 
pf = 0.8;
Irated = Sb/(sqrt(3)*Vrated*pf); % rated rms current
P = 4; 	  	% number of poles
frated = 60;	% rated frequency in Hz
wb = 2*pi*frated;	% base electrical frequency
we = wb;
wbm = 2*wb/P;	% base mechanical frequency
Tb = Sb/wbm; 	% base torque
Zb = Vrated*Vrated/Sb;	%base impedance in ohms
Vm = Vrated*sqrt(2/3);	% magnitude of phase voltage
Vb = Vm; % base voltage
Tfactor = (3*P)/(4*wb); % factor for torque expression

rs = 3.35;	% stator wdg resistance in ohms
xls = 6.94e-3*wb;% stator leakage reactance in ohms
xplr = xls; 	% rotor leakage reactance
xm = 163.73e-3*wb;	%stator magnetizing reactance
rpr = 1.99;	% referred rotor wdg resistance in ohms
xM = 1/(1/xm + 1/xls + 1/xplr);
J = 0.1;		% rotor inertia in kg m2
H = J*wbm*wbm/(2*Sb); % rotor inertia constant in secs.
Domega = 0; % rotor damping coefficent
