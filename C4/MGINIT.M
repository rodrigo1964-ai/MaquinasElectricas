% M-file to obtain the instantaneous 
% flux linkage versus current curve 
% from the rms open-circuit curve.

clear all
we = 377; % excitation frequency 
% Enter Vrms and Irms of open-circuit curve
V = [ 0.00 7.40 20.50 37.30 47.31 57.12 68.85 72.80 81.19 87.82 95.46 100.7 107.04 112.37 116.04 119.75 121.92 125.61 127.92 130.25 132.53 134.85 136.1 137.5 ];
I = [ 0 0.0112 0.0310 0.0585 0.0740 0.0895 0.1084 0.1153 0.1308 0.1437 0.1583 0.1686 0.1841 0.2004 0.2142 0.2331 0.2477 0.2753 0.2933 0.3131 0.3381 0.3639 0.3828 0.4000];
psi = sqrt(2).*V; % peak psi array
npts = length(V);
K(1) = I(2)*sqrt(2)/psi(2); 
i(1) = 0.; 
theta(1) = 0;
for k = 2:1:npts
for j = 2:k
theta(j) = asin(psi(j)/psi(k)); 
theta(j-1) = asin(psi(j-1)/psi(k));
t(j) = theta(j) - theta(j-1);
s(j) = (sin(2*theta(j)) - sin(2*theta(j-1)))/2;
g(j) = cos(theta(j)) - cos(theta(j-1));
d(j) = t(j)*i(j-1)^2;
B(j) = -2*i(j-1)*(psi(k)*g(j) + psi(j-1)*t(j)); 
A(j) = (psi(k)^2)*(t(j) - s(j))/2 + 2*psi(k)*psi(j-1)*g(j) + psi(j-1)^2*t(j); 
end;
C(k) = d(k) - pi*I(k)^2/2; 
for j = 1:(k-1);
C(k) = C(k) + K(j)^2*A(j) + K(j)*B(j) + d(j);
end;
K(k) = (- B(k) + sqrt(B(k)^2 - 4*A(k)*C(k)))/(2*A(k));
i(k) = 0;
for j = 2:k;
i(k) = i(k) + K(j)*(psi(j) - psi(j-1)); 
end;
end;

% set up the full saturation curve 

Vud = flipud(V'); % flip the column array of V's upside down
nV = length(Vud); % get length
Vud(nV) = []; % collapse array by one to eliminate 
		% duplicate value at origin
Vfull = sqrt(2).*[-1.*Vud' V]; % full negative to full positive
Iud = flipud(I'); % flip the column array of I's upside down
nI = length(Iud); % get length
Iud(nI) = []; % collapse array by one to eliminate 
		% duplicate value at origin
Ifull = sqrt(2).*[-1.*Iud' I]; % full negative to full positive
psiud = flipud(psi'); % flip the column array of psi's upside down
npsi = length(psiud); % get length
psiud(npsi) = []; % collapse array by one to eliminate 
		% duplicate value at origin
psifull = [-1.*psiud' psi]; % full negative to full positive
iud = flipud(i'); % flip the column array of i's uide down
ni = length(iud); % get length
iud(ni) = []; % collapse array by one to eliminate 
		% duplicate value at origin
ifull = [-1.*iud' i]; % full negative to full positive

% set up variable amplitude sinusoidal voltage source 

Vmaxrms = V(nV-1); % set maximum rms of run below max value 
tstop = 3.5;%run period same as period of amplitude variation 
disp('ready for simulation of smg.m')
