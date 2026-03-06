% M-file for Project 1 on line parameters and circuit models 
%  in Chapter 3

% m1.m determines the RLC parameters of the line from its physical
%  description and then computes
%  the ABCD matrix and the circuit parameters of the 
%  series RL, nominal pi and equivalent pi model of the line. 
% It computes and plot the receiving-end real and reactive power
% circle diagram of the line assuming that the voltage magnitude
% at the sending- and receiving-end are kept constant.

% input constant
epso = 8.854e-12; % permittivity of free space in F/m 
muo = 4e-7*pi; % permeability of free space in H/m 
we = 2*pi*60 ; % system frequency in rad/sec

% input conductor spacings, length, and resistance
D12p = 7.772; % conductor spacing in m
D1p2 = 6.858; % conductor spacing in m
radc = 4.4755e-2/2; % envelope radius of conductor in m
GMRc = 1.6276e-2; % GMR of conductor in m
d = 160 % length of line in m

s = (D12p- D1p2)/2; % conductor spacing of bundle in m
D12 = D12p+s; % conductor spacing in m
D12eq = (D12*D12*D12p*D1p2)^(1/4);
D23eq = D12eq;
D13eq = ((D12+D1p2)*(D12+D12p)*(D12p+D1p2)^2)^(1/4);
GMD = (D12eq*D23eq*D13eq)^(1/3);
GMR = sqrt(GMRc*s);
GMR1 = sqrt(radc*s);

% RLC per m of line
r = 0.02896e-3/2 % resistance per meter length of phase bundle
l = (muo/2*pi)*log(GMD/GMR) % inductance per meter length
c = 2*pi*epso/log(GMD/GMR1) % capacitance per meter length

% series RL circuit model parameters 
R = r*d;
L = l*d;
Z = R + j*we*L;
ABCD_RL = [ 1  Z; 0. 1 ] 

% nominal pi circuit model parameters 
Cby2 = c*(d/2); 
Yby2 = j*we*Cby2; 
Y = j*we*Cby2*2; 
ABCD_nompi = [ (1 + Z*Yby2) Z; Y*(1+Z*Y/4) (1+Z*Yby2)] 

% equivalent pi circuit model parameters
gamma = sqrt((r + j*we*l)*j*we*c);
Zc = sqrt((r + j*we*l)/(j*we*c));
gammad = gamma*d;
ABCD_eqpi=[cosh(gammad) Zc*sinh(gammad);sinh(gammad)/Zc cosh(gammad)]

% receiving-end condition
PR = 120e6/3; % per phase receiving-end power in W
VR = 345e3/sqrt(3); % receiving-end phase voltage in rms V used as ref
pfR = 0.9; % pf of load at receiving end  
sinphiR = -sqrt(1-pfR*pfR);%sine of pf angle, neg for lagging 
SR = PR*(1 - j*sinphiR/pfR)% per phase complex load power
IR = conj(SR/VR) % receiving-end current

% compute sending-end condition
VIS_RL = ABCD_RL*[VR; IR]
SS_RL = VIS_RL(1)*conj(VIS_RL(2)) % per phase sending-end complex power
pfS_RL  = cos(angle(SS_RL))
VS_RL = abs(VIS_RL(1))
IS_RL = abs(VIS_RL(2))
VIS_nompi = ABCD_nompi*[VR; IR]
SS_nompi = VIS_nompi(1)*conj(VIS_nompi(2)) % per phase complex power
pfS_nompi  = cos(angle(SS_nompi))
VS_nompi = abs(VIS_nompi(1))
IS_nompi = abs(VIS_nompi(2))
VIS_eqpi = ABCD_eqpi*[VR; IR]
SS_eqpi = VIS_eqpi(1)*conj(VIS_eqpi(2)) % per phase complex power
pfS_eqpi  = cos(angle(SS_eqpi))
VS_eqpi = abs(VIS_eqpi(1))
IS_eqpi = abs(VIS_eqpi(2))

% Locus of PQ at receiving-end with changing angle of VS 
% while the magnitude of VS and VR held fixed 
% using mag of previous condition as base, and +- 3% about base  
clf; clear figure window
VS_mag = (0.94:0.06:1.06)*real(VIS_eqpi(1));% create VS angle array
del_VS = (-1:1/180:1)*pi; % create row array for VS angle
inmag = 0 % initialize magnitude index
indel = 0 % initialize angle index
for VSm = VS_mag % external for loop to step through VS mag values
inmag = inmag + 1;
for del = del_VS % internal for loop to step through VS angle values 
indel = indel + 1;
VS = VSm*exp(j*del); % compose fixed magnitude VS phasor 
IR = (VS - ABCD_eqpi(1,1)*VR)/ABCD_eqpi(1,2);
SR(inmag,indel) = VR*conj(IR); % save complex power value for plotting
end % end of for del loop
end % end of for Vsm loop

% plot PQ locus
plot(real(SR(1,:)),imag(SR(1,:)),'-.', real(SR(2,:)),imag(SR(2,:)),'-', real(SR(3,:)), imag(SR(3,:)),':'); 
title('Loci of receiving-end P+jQ')
xlabel('P in W');
ylabel('Q in Var');
axis('square'); % set for square plot
axis('equal'); % equal scaling for both axis 
