% MATLAB M-file m3.m is for the generator with 
%	series capacitor compensated case of Project 3 on
% 	subsynchronous resonance in Chapter 10.
% It is to be used with the SIMULINK files : s3.m and s3eig.m.
% The SIMULINK file s3eig.m is being used in conjunction 
% 	with the trim and linmod functions of this script 
%

% m3.m sets up the condition for the SIMULINK file S3.m;
% the tasks performed by m3.m are as follow: 
%   (a)	loads parameters of generator, network and torsional system; 
%   (b)	estimates operating condition  
%   	(i)	uses Simulink trim function to determine 
% 		steady-state of s3eig.m 
%  	(ii)	uses Matlab linmod to determine A,B,C, and D;
%	(iii)	determines system eigenvalues.
%   (c)	plots result

% clear workspace of all variables

clear all;

%	********Begin input section************
% load synchronous machine parameters given in
% Table 1 of  First Benchmark Model for Computer 
% Simulation of Subsynchronous Resonance
% IEEE Trans on PAS, Vol. 1, PAS -96, Sept/Oct 1977, 
% pp. 1565-1572.
% Copyright 1977 IEEE

Frated = 60;
wb = 2*pi*Frated; % base electrical freq
rs = 0.000;
rpf = 0.53/wb;
xplf = 0.062;
rpkd = 1.54/wb;
xplkd = 0.0055;
xmd = 1.66
xls = 0.13;
rpkq2 = 5.3/wb;
xplkq2 = 0.326;
rpkq = 3.1/wb;
xplkq = 0.095;
xmq = 1.58;
xd = xls + xmd;
xq = xls + xmq;
Domega = 0.0; % damping of mode 0

% Input network parameters
xc(1) = - 0.371; % pu series capacitance between buses 2 and 3
xc(2) = - 50;   % pu bus to ground capacitance at bus 1   
r(1) = 0.02;   % net series resistance between buses 1 and 4
xl(1) = 0.14 + 0.5 + 0.06;% net series reactance between buses 1 and 4

% Enter inertias of mass 1 thru n_mass in MW-sec/MVA
h = [0.092897 0.155589 0.85867 0.884215 0.868495 0.0342165];
% Create diagonal inertia matrix from row vector h
H = diag(h)
% Enter stiffness of shaft sections 
% from 1-2, 2-3, ...(n-1)-n in per unit torque/electrical rad
k = [19.303 34.929 52.038 70.858 2.822]; 
% Enter fractions of mechanical input torque to each mass 
tmechv = [0.3; 0.26; 0.22; 0.22; 0.; 0.];% column vector
% Identify the mass number of the generator rotor 
n_gen = 5;
% Set mask for Tem input to modal equations 
temmask = [0; 0; 0; 0; 1; 0]; % column vector
% Total externally applied torque for estimating initial modal angles 
Tmech = 0.9;
% Enter decrement factor - by order of increasing modal frequency
sigma = [0.0 0.05 0.11 0.028 0.028 0.0];

%	*********End of input section********************

n_mass = length(h);
n_mode = n_mass;
nm1 = n_mass - 1;
fprintf('Torsional Modes of a %3.0f mass inertia system\n', n_mass)
fprintf('Generator rotor is mass number %3.0f\n', n_gen)
fprintf('Base frequency is %6.1f rad/sec\n', wb )

% Compute net torque to generator 
tdisk = Tmech*tmechv;
tsum = sum(tdisk);
tdisk(n_gen) = - tsum;

% Set up diagonal elements of tridiagonal stiffnes matrix
K(1,1) = k(1);
    if(n_mass>2) 
     for irow = 2:nm1
     K(irow,irow) = k(irow-1) + k(irow);
     end
    end;
K(n_mass,n_mass) = k(nm1);
    
% Set up off-diagonal elements of tridiagonal H_inv*K matrix
for irow = 2:n_mass
    K(irow,irow-1) = -k(irow-1);
    K(irow-1,irow) = K(irow,irow-1);
end
fprintf('Stiffness matrix')
K

% Compute matrix Hinv*K
for irow = 1:n_mass
    H_invK(irow,:) = K(irow,:)/h(irow);
end

% Compute eigenvalues and eigenvectors using eig function
% H_invK is in general a nonsymmetric tridiagonal matrix
% columns of Q are already scaled unit length eigenvectors
% rows of Q ~ lumped masses, cols of Q ~  vibration modes  
% D is a diagonal matrix of the corresponding eigenvalues 

Sys_matrix = (wb/2)*H_invK;
[Q,D] = eig(Sys_matrix);

% Sort eigenvalues and eigenvectors in ascending order of eigenvalues
% Lambda is a column vector; kk is an index vector
[Lambda,kk] = sort(diag(D));
fprintf('natural or modal frequencies in rad/sec and in Hertz')
omega_m = sqrt(Lambda)
freq_m = omega_m/(2*pi)
Q = Q(:,kk);

% Normalize the eigenvectors in accordance to a chosen option
% Echo menu options for weighting options
% option = menu('Choose a weighting option','to element of generator mass', 'to largest element of eigenvector', 'to unit length vectors' )

option = 2 % use option 2 for this application
format short e
if option == 1 % divide each row by generator mass element 
		% of that row 
R = diag(1./Q(n_gen,:)) 
elseif option == 2 % divide by the maximum of each column
R = diag(1./max(abs(Q)))
elseif option ==3
R = diag(1./sqrt(sum(Q.^2)))% given by Matlab eig directly
end % if option

% Compute angle of twist. Since K is almost singular,
% not advisable to solve [K]theta=tdisk.
% First compute twist angles using mass 1 as reference
theta(1) = 0.;
tsum = 0.;
for imass = 2:n_mass
tsum = tsum + tdisk(imass-1);
theta(imass) = theta(imass-1) - tsum/k(imass-1);
end

% Shift angles of masses so that generator mass's angle is zero
theta = theta - theta(n_gen);
     
fprintf('Scaled mode shape matrix' )
Qbar=Q*R
% Plot mode shape vector against its row index
for jmode = 1:n_mass
subplot(6,1,jmode), plot(Qbar(:,jmode)) 
ystring=['mode' num2str(jmode-1)];
ylabel(ystring)
end

% Compute initial modal angles
fprintf('Mode angles for applied torque')
theta_m = Qbar\theta'

% Write modal inertias
fprintf('Modal inertia matrix')
H_m = Qbar'*H*Qbar;
diag(H_m)
      
% Computes modal damping coefficients, D vector
for jmode = 1:n_mass
D_m(jmode) =(4/wb)*H_m(jmode,jmode)*sigma(jmode);
end
fprintf('Modal damping coefficients' )
D_m

% ******* Set up matrices used in simulation *******
Qbart = Qbar'; 
% natural frequencies and damping for modes2,3,...,6
wmi = omega_m(2:n_mode) % omega_m is column vector
for jmode = 2:n_mode
wmi_xi_2t(jmode-1) = 2*sigma(jmode);
tdisk2m(jmode-1,:)=(wb/(2*H_m(jmode,jmode)))*Qbart(jmode,:);
end
wmi_wmi = wmi.*wmi % squaring
wmi_xi_2 = wmi_xi_2t' % wmi_xi_2 is column vector
% transformation for partial sum of modal speed 2 thru 6
omegam2to6 = Qbar(n_gen,2:n_mode)./wb; % row vector
% initial values of modal angles 2 to 6
thetam2to6o = theta_m(2:6);
for i = 1:n_mass
    H_invK(i,:) = K(i,:)/h(i);
end

%****************************************************
% Compute settings for variables in simulation

xMQ = (1/xls + 1/xmq + 1/xplkq + 1/xplkq2)^(-1)
xMD = (1/xls + 1/xmd + 1/xplf + 1/xplkd)^(-1)

% Specify desired operating condition lists
Pgen = 0.9;	% generator power 0.9 pu
Qgen = Pgen*tan(acos(0.9)); 	% 0.9 pf lagging, 
			% P is negative for motoring  
Vt = 1. + 0*j;         	% specify terminal voltage
Vm = abs(Vt);
St = Pgen + Qgen*j;	% generated complex power
  
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

% qd steady-state variables in rotor reference frame

  Eqo = abs(Eq);
  I = It*(cos(delt) - sin(delt)*j);
  Iqo = real(I);
  Ido = -imag(I);  % d-axis lags the q-axis
  Efo = Eqo + (xd-xq)*Ido;
  Ifo = Efo/xmd;

  Psimdo = xmd*(-Ido + Ifo);
  Psimqo = xmq*(-Iqo);

  Psiqo = xls*(-Iqo) + Psimqo;
  Psido = xls*(-Ido) + Psimdo;
  Psifo = xplf*Ifo + Psimdo;
  Psikqo = Psimqo;
  Psikdo = Psimdo;
  Psikq2o = Psimqo;

  Vto = Vt*(cos(delt) - sin(delt)*j);
  Vqo = real(Vto);
  Vdo = -imag(Vto);
  Sto = Vto*conj(I)
  Pemo = real(Sto);
  Qemo = imag(Sto);
  Tmech = Pemo;

% Estimate qd voltages at buses 3 and 4 in rotor reference

V4 = Vto - (r(1) + j*(xl(1) + xc(1)))*I;
delta4 =  atan2(-imag(V4), real(V4)) % bus 4 angle wrt to q rotor; 
% transfer from generator qd to synchronous qd with bus 4 as
% reference
delio= delta4;
Iq = Iqo*cos(delio) + Ido*sin(delio);
Id = - Iqo*sin(delio) + Ido*cos(delio);
Vq1 = Vqo*cos(delio) + Vdo*sin(delio);
Vd1 = - Vqo*sin(delio) + Vdo*cos(delio);
V1 =abs(Vto); 
Vq4o = real(V4);
Vd4o = -imag(V4);
Vq4 = Vq4o*cos(delio) + Vd4o*sin(delio);
Vd4 = - Vq4o*sin(delio) + Vd4o*cos(delio);
 % QD voltages across series capacitor 
VqCs = Id*xc(1);
VdCs = - Iq*xc(1);

% Use Simulink trim function to determine the steady-state values
% at the desired operating point and linmod the linear system
% The ordering of state, x, is dependent on how Simulink assembles
% the system equation, the current ordering of the state 
% variables by your computer must be determined using 

[sizes,x0,xstr] = s3eig([], [], [], 0)

% On mine this command yields  xstr =

%\s3eig/ShuntCap/vq          
%\s3eig/ShuntCap/vd          
%\s3eig/gen/Rotor/delta_mode0 
%\s3eig/gen/Rotor/modal angles
%\s3eig/gen/Rotor/modal angles
%\s3eig/gen/Rotor/modal angles
%\s3eig/gen/Rotor/modal angles
%\s3eig/gen/Rotor/modal angles
%\s3eig/gen/q_cct/psiq_       
%\s3eig/gen/q_cct/psipkq2_    
%\s3eig/gen/q_cct/psipkq_     
%\s3eig/gen/d_cct/psid_       
%\s3eig/gen/d_cct/psipf_      
%\s3eig/gen/d_cct/psipkd_     
%\s3eig/gen/Rotor/modal_speed 
%\s3eig/gen/Rotor/modal_speed 
%\s3eig/gen/Rotor/modal_speed 
%\s3eig/gen/Rotor/modal_speed 
%\s3eig/gen/Rotor/modal_speed 
%\s3eig/gen/Rotor/slip        
%\s3eig/Cap/vq                
%\s3eig/Cap/vd                
%\s3eig/seriesRL/iq           
%\s3eig/seriesRL/id        

% Input guesses
u = [Vq4; 0; Efo; Tmech ];
x = [Vq1; Vd1; delio; thetam2to6o;
Psiqo; Psikqo; Psikq2o; Psido; Psifo; Psikdo; 
0; 0; 0; 0; 0; 0; Iq; Id; VqCs; VdCs] 
% must be in accordance with ordering of xstr
y =[V1; Pemo; Qemo;0];  

% use index variables to specify which of the above 
% input in the initial guess should be held fixed
 
iu=[1; 2; 4] % Infinite bus voltage and Tmech held fixed
ix = [1] % all state variables can vary
iy = [1;2;3;4] % Gen bus voltage mag., Pgen, Qgen, and slip held fixed 

% Use Simulink trim function to determine the desired 
% steady-state operating point. For more details
% type help trim after the matlab prompt.
% Output from trim should be carefully checked before 
% proceeding on. 

[x,u,y,dx] = trim('s3eig',x,u,y,ix,iu,iy)

% Use Matlab linmod function to determine the state-space
% representation at the chosen operating point
%
%	dx/dt = [A] x + [B] u
%	    y = [C] x + [D] u

[A, B, C, D] = linmod('s3eig', x, u); 

eig(A)

disp('Run simulation in s3.m and return for plots')
keyboard
clf;
subplot(3,1,1)
plot(yout(:,1),yout(:,2),'-')
title('Capacitor phase a voltage')
subplot(3,1,2)
plot(yout(:,1),yout(:,3),'-')
title('Generator phase a voltage')
subplot(3,1,3)
plot(yout(:,1),yout(:,4),'-')
title('Generator electrical torque')

h2=figure;
subplot(3,1,1)
plot(yout(:,1),yout(:,5),'-')
title('Shaft torque, LPA-LPB')
subplot(3,1,2)
plot(yout(:,1),yout(:,5),'-')
xlabel('Time in sec')
title('Shaft torque, Gen-Exc')
disp('Save plots before typing return to exit') 
keyboard
close (h2) % close second figure window
