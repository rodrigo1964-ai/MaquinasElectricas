% M-file for Project 4 on linearized analysis in Chapter 6
% To be used in the same directory containing the SIMULINK 
% file, s4eig, of an induction machine in the synchronous
% reference frame

% It does the following: 

%   (a)	loads parameters and rating of machine; 
%
%   (b)	set up Tmech loading levels in T vector for tasks (i) thru (iv) 
 
%
%   (i)	uses Simulink trim function to determine 
% 	steady-state of a desired operating point of the 
% 	Simulink system s4eig; 

%  (ii)	uses Matlab linmod to determine A,B,C, and D;

% (iii)	uses Matlab ss2tf to determine 
% 	the speed-torque transfer function 

%  (iv)	uses Matlab tf2zp to determine 
% 	the poles and zeros of the speed-torque transfer function 

%   (c)	generates a plot of poles for changing 
%	Tmech  

% Enter script file to load parameters and rating of motor

p20hp % parameters of 20 hp three-phase induction motor 

% After initializing the parameters of the imwe 
% in the Matlab workspace, make initial guess of all
% values in the state (x), input (u), and output (y) 
% vectors. From the diagram of imwe, we see that
% u = [vqe; vde; Tmech]
% y = [iqse; idse; Tem; wr/wb]

% Since the ordering is dependent on how Simulink assembles
% the system equation, the current ordering of the state 
% variables can be determined using 

% define all initial value variables  
Psiqso = Vm;  
Psipqro = Vm;
Psidso = 0; 
Psipdro = 0;
wrbywbo = 1; 

[sizes,x0,xstr] = s4eig([], [], [], 0)

% which yields xstr =

%/s4eig/Daxis/psids_             
%/s4eig/Daxis/psidr'_            
%/s4eig/Qaxis/psiqs_             
%/s4eig/Qaxis/psiqr'_            
%/s4eig/Rotor/1/s 

% or  x = [ psids; psipdr; psiqs; psipqr; wr/wb ]  

% Input the following guesses

Vm = Vrated*sqrt(2/3) % peak voltage per phase  
T = [0:-Tb:-Tb]% specify range and increment of 
				% external mech torque, negative for
				% motoring  
xg = [Psidso; Psipdro; Psiqso; Psipqro; wrbywbo];
		% IMPORTANT!! must update xg in accordance with
		% actual ordering of state variables 
yg=[0; 0; -0; 1];  

index = 0;

% For loop to compute transfer function at various levels 
% of Tmech loading specified in T vector 

for Tmech = T 
index = index + 1;    % set index 

u = [Vm; 0; Tmech];
x=xg;
y=yg;

% use index variables to specify which of the above 
% input in the initial guess should be held fixed
 
iu=[1; 2; 3]; % all input variables held fixed
ix = []; % all state variables can vary
iy = []; % all output free  

% Use Simulink trim function to determine the desired 
% steady-state operating point. For more details
% type help trim after the matlab prompt.
% Results from trim has to be verfied. 

[x,u,y,dx] = trim('s4eig',x,u,y,ix,iu,iy);

xg = x; % store current steady-state to use as guesses for next
yg = y; % increment in loading

% Use Matlab linmod function to determine the state-space
% representation at the chosen operating point
%
%	dx/dt = [A] x + [B] u
%	    y = [C] x + [D] u

[A, B, C, D] = linmod('s4eig', x, u); 

% For transfer function (Dwr/wb)/DTmech

bt=B(:,3); % select third column input
ct=C(4,:); % select fourth row output
dt=D(4,3); % select fourth row and third column
 
% Use Matlab ss2tf to determine transfer function 
% of the system at the chosen operating point.
% If desired, transfer function can be printed using

[numt(index,:),dent(index,:)] = ss2tf(A,bt,ct,dt,1);

 printsys(numt(index,:),dent(index,:),'s')

% Use Matlab tf2zp to determine the poles and zeros
% of system transfer function
 
[zt(:,index),pt(:,index),kt(index)] = tf2zp(numt(index,:),dent(index,:)); 

% z,p column vectors
% For transfer function (Dwr/wb)/Dvqse

bv=B(:,1); % select third column input
cv=C(4,:); % select fourth row output
dv=D(4,1); % select fourth row and third column
 
% Use Matlab ss2tf to determine transfer function 
% of the system at the chosen operating point.


[numv(index,:),denv(index,:)] = ss2tf(A,bv,cv,dv,1);

printsys(numv(index,:),denv(index,:),'s')

% Use Matlab tf2zp to determine the poles and zeros
% of system transfer function
 
[zv(:,index),pv(:,index),kv(index)] = tf2zp(numv(index,:),denv(index,:));
% z,p column vectors

end % end of for Tmech loop

% Print loading level and corresponding gain,zeros, and poles
% of (Dwr/wb)/DTmech

index = 0;
for Tmech = T 
	index = index + 1;

fprintf('\n (Dwr/wb)/DTmech \n')
fprintf('Tmech loading is %10.2e\n',Tmech )
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
% of (Dwr/wb)/Dvqse

index = 0;
for Tmech = T 
	index = index + 1;

fprintf('\n (Dwr/wb)/Dvqse \n')
fprintf('Tmech loading is %10.2e\n',Tmech )
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

% Root Locus Plot of (Dwr/wb)/Dvqse with a sensor TF of
% 1/(0.05s+1) 
clf;
index =2 		% pick the rated torque condition 
numG = numv(index,:); 	% numerator of (Dwr/wb)/Dvqse  
denG = denv(index,:);   % denominator of (Dwr/wb)/Dvqse  
numH = 1; 		% numerator of sensor's TF
denH = [0.05 1];	% denominator of sensor's TF 
[numGH,denGH] = series(numG,denG,numH,denH);  
k=logspace(0,5,600); % define gain array
[r,k]= rlocus(numGH,denGH,k); % store loci

% customize plot over the region of interest 
ymax = 400;
xmax = 400; 
plot(r,'-') % plot loci using a black continuous line
title('Root Locus of (Dwr/wb)/Dvqse')
xlabel('real axis')  
ylabel('imag axis')  
axis square; % equal length axis
hold on;
grid on;
axis('equal')	%equal scaling for both axis
axis([-xmax,xmax/10,-ymax/10,ymax]) % resize 
plot(real(r(1,:)), imag(r(1,:)),'x') % mark poles with x's 
hold off
% Transfer to keyboard for printing of plot
% disp('When ready to return to program type ''return''');
% keyboard
% In keyboard mode, that is K >>, you can use the Matlab command 
% kk = rlocfind(numGH,denGH) and the mouse to determine 
% the gain of any point on the root locus.  
