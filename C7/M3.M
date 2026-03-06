% MATLAB script file m3.m for Project 3 on linearized analysis
% of a synchronous generator in Chapter 7. 

% m3.m does the following: 
%   (a)	loads parameters and rating of the synchronous machine; 
%   (b)	set up Pgen and Qgen lists for tasks (i) thru (iv) 
%   	(i)	uses Simulink trim function to determine 
% 		steady-state of a desired operating point of the 
% 		Simulink system given in s3eig.m; 
%  	(ii)	uses Matlab linmod to determine A,B,C, and D;
%	(iii)	uses Matlab ss2tf to determine 
% 		the speed-torque transfer function 
%  	(iv)	uses Matlab tf2zp to determine the poles and zeros 
%		of the speed-torque transfer function 
%   (c)	generates root locus plots

% clear workspace of all variables

clear variables;

% put synchronous machine set 1 parameters in Matlab workspace 

set1

% Calculate base quantities
we = 2*pi*Frated
wbase = 2*pi*Frated
wbasem = wbase*(2/Poles)
Sbase = Prated/Pfrated
Vbase = Vrated*sqrt(2/3) % Use peak values as base quantites 
Ibase = sqrt(2)*(Sbase/(sqrt(3)*Vrated))
Zbase = Vbase/Ibase
Tbase = Sbase/wbasem

% Calculate dq0 equivalent circuit parameters

if(xls ==0) xls = x0 % assume leakage reactance = zero_sequence
end

xmq = xq - xls
xmd = xd - xls

xplf = xmd*(xpd - xls)/(xmd - (xpd-xls))

xplkd = xmd*xplf*(xppd-xls)/(xplf*xmd - (xppd-xls)*(xmd+xplf))

xplkq = xmq*(xppq - xls)/(xmq - (xppq-xls))

rpf = (xplf + xmd)/(wbase*Tpdo)

rpkd = (xplkd + xpd - xls)/(wbase*Tppdo)

rpkq = (xplkq + xmq)/(wbase*Tppqo)

% Convert to per unit dqo circuit parameters

if(Perunit == 0) % parameters given in Engineering units
fprintf('Dq0 circuit paramters in per unit\n')

H = 0.5*J_rotor*wbasem*wbasem/Sbase
rs = rs/Zbase
xls = xls/Zbase

xppd = xppd/Zbase
xppq = xppq/Zbase
xpd = xpd/Zbase
xpq = xpq/Zbase

x2 = x2/Zbase
x0 = x0/Zbase

xd = xd/Zbase
xq = xq/Zbase

xmd = xmd/Zbase
xmq = xmq/Zbase

rpf = rpf/Zbase
rpkd = rpkd/Zbase
rpkq = rpkq/Zbase

xplf = xplf/Zbase
xplkd = xplkd/Zbase
xplkq = xplkq/Zbase

end
%****************************************************
% Compute settings for variables in simulation

wb=wbase
xMQ = (1/xls + 1/xmq + 1/xplkq)^(-1)
xMD = (1/xls + 1/xmd + 1/xplf + 1/xplkd)^(-1)

% Specify desired operating condition lists

P = [0:0.2:0.8];	% specify range and increment of real 
Q = [0:0.15:0.6]; 		% and reactive output power, 
			% P is negative for motoring  
Vt = 1. + 0*j;         	% specify terminal voltage
Vm = abs(Vt);
St = P(1)+Q(1)*j;	% generated complex power
  

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
  Sto = Vto*conj(I)
  Eqpo = Vqo + xpd*Ido + rs*Iqo;
  Edpo = Vdo - xpq*Iqo + rs*Ido;
  
  delto = delt;
  Pemo = real(Sto);
  Qemo = imag(Sto);
  Tmech = Pemo;

% Use Simulink trim function to determine a desired 
% operating point for s3eig.m or s3.m
% Need to make initial guess of the state (x), the input (u), 
% and output (y). 
% From the diagram of s3eig.m, we see that
% u = [vqe; vde; Ef; Tmech]
% y = [pgen; qgen; delta; Tem; (wr-we)/wb]
% The ordering, however, is dependent on how Simulink assembles
% the system equation, the current ordering of the state 
% variables by your computer must be determined using 

[sizes,x0,xstr] = s3eig([], [], [], 0)

% On mine this command yields  xstr =

%/s3eig/Rotor/del 
%/s3eig/q_cct/psiq_      
%/s3eig/q_cct/psipkq_    
%/s3eig/d_cct/psid_      
%/s3eig/d_cct/psipf_     
%/s3eig/d_cct/psipkd_    
%/s3eig/Rotor/slip    
% or  x = [del; psiq; psikq; psid; psif; psikd; (wr-we)/wb] 

% Input guesses

ug = [Vm; 0; Efo; Tmech ];
xg = [delto; Psiqo; Psikqo; Psido; Psifo; Psikdo; 0.] % must be in accordance with
					% ordering of xstr
yg =[Pemo; Qemo; delto; -Tmech; 0];  

% For loop to compute the desired transfer functions 
% over the list of specified operating conditions 

index = 0;
for Pgen = P 
index = index + 1;    % update index to Pgen  

u=[Vm; 0; ug(3); P(index)];
x=xg;
y=[P(index); Q(index); yg(3); yg(4); 0];

% use index variables to specify which of the above 
% input in the initial guess should be held fixed
 
iu=[1; 2] % only input voltages held fixed
ix = [] % all state variables can vary
iy = [1;2; 5] % Pgen, Qgen and slip speed held fixed 

% Use Simulink trim function to determine the desired 
% steady-state operating point. For more details
% type help trim after the matlab prompt.
% Output from trim should be carefully checked before 
% proceeding on. 

[x,u,y,dx] = trim('s3eig',x,u,y,ix,iu,iy)

xg = x; % store current steady-state to use as guesses for next
yg = y; % increment in loading
ug = u;

% Use Matlab linmod function to determine the state-space
% representation at the chosen operating point
%
%	dx/dt = [A] x + [B] u
%	    y = [C] x + [D] u

[A, B, C, D] = linmod('s3eig', x, u); 

% For transfer function (DPgen)/DTmech

bt=B(:,4); % select Tmech column input
ct=C(1,:); % select Pgen row output
dt=D(1,4); % select Pgen row and Tmech column input
 
% Use Matlab ss2tf to determine transfer function 
% of the system at the chosen operating point.

[numt(index,:),dent(index,:)] = ss2tf(A,bt,ct,dt,1);

 printsys(numt(index,:),dent(index,:),'s') % print tf

% Use Matlab tf2zp to determine the poles and zeros
% of system transfer function
 
[zt(:,index),pt(:,index),kt(index)] = tf2zp(numt(index,:),dent(index,:)); 
% z,p column vectors
% For transfer function (DQgen)/DEf

bv=B(:,3); % select only Ef column input
cv=C(2,:); % select Qgen row output
dv=D(2,3); % select Qgen row and Ef column
 
% Use Matlab ss2tf to determine transfer function 
% of the system at the chosen operating point.


[numE(index,:),denE(index,:)] = ss2tf(A,bv,cv,dv,1);

printsys(numE(index,:),denE(index,:),'s')

% Use Matlab tf2zp to determine the poles and zeros
% of system transfer function
 
[zv(:,index),pv(:,index),kv(index)] = tf2zp(numE(index,:),denE(index,:));
% z,p column vectors

end % end of for Power loop

% Print loading level and corresponding gain,zeros, and poles
% of (DPgen)/DTmech

index = 0;
for Pgen = P 
	index = index + 1;

fprintf('\n(DPgen)/DTmech \n\n')
fprintf('Output P+jQ = %4g+j%-4g\n',P(index), Q(index))
fprintf('Gain is %10.2e\n',kt(index))
[mzero,nzero] = size(zt);
fprintf('\nZeros are: \n')
	for m = 1:mzero
	fprintf('%12.3e %12.3ei\n',real(zt(m,index)), imag(zt(m,index)))
	end
[mpole,npole] = size(pt);
fprintf('\nPoles are: \n')
	for m = 1:mpole
	fprintf('%12.3e %12.3ei\n',real(pt(m,index)), imag(pt(m,index)))
	end
end

% Print loading level and corresponding gain,zeros, and poles
% of (DQgen)/DEf

index = 0;
for Pgen = P 
	index = index + 1;

fprintf('\n(DQgen)/DEf \n\n')
fprintf('Output P+jQ = %4g+j%-4g\n',P(index), Q(index))
fprintf('Gain is %10.2e\n',kv(index))
[mzero,nzero] = size(zv);
fprintf('\nZeros are: \n')
	for m = 1:mzero
	fprintf('%12.3e %12.3ei\n',real(zv(m,index)), imag(zv(m,index)))
	end
[mpole,npole] = size(pv);
fprintf('\nPoles are: \n')
	for m = 1:mpole
	fprintf('%12.3e %12.3ei\n',real(pv(m,index)), imag(pv(m,index)))
	end
end

clf;
index = 4; 		% pick the rated torque condition 
fprintf('\nRoot Locus plot for DQgen/Def at \n P+jQ = %10.2e %10.2ei\n\n',P(index), Q(index) )
numG = numE(index,:); 	% numerator of (DQgen)/DEf  
denG = denE(index,:);   % denominator of (DQgen)/DEf  
k=logspace(0,5,1000); % define gain array
[r,k]= rlocus(numG,denG,k); % store loci

% customize plot over the region of interest 
ymax = 400;
xmax = 200; 
plot(r,'-') % plot loci using a black continuous line
title('Root Locus of (DQgen/DEf)')
xlabel('real axis')  
ylabel('imag axis')  
hold on;
grid on;
axis('square')	%equal scaling for both axis
axis([-xmax,xmax/10,-ymax/10,ymax]) % resize 
plot(real(r(1,:)), imag(r(1,:)),'x') % mark poles with x's 
hold off
% Transfer to keyboard for printing of plot
% disp('Save plot before typing ''return''');
% keyboard
% In keyboard mode, that is K >>, you can use the Matlab command 
% kk = rlocfind(numGH,denGH) and the mouse to determine 
% the gain of any point on the root locus.  
