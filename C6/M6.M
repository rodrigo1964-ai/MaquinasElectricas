% M file for Project 6 on single-phase induction motor  
% in Chapter 6.  It sets the machine parameters and 
% also plots the simulated results when used in conjunction
% with SIMULINK file s6.m.    

clear all % clear workspace

% select machine parameter file to enter into Matlab workspace
disp('Enter filename of machine parameter file without .m')
disp('Example: psph')
setX = input('Input machine parameter filename > ','s')% string s
eval(setX); % evaluate MATLAB command


% Calculation of torque speed curve
Vqs = Vrated + j*0; % rms phasor voltage of main wdg
Vpds = Nq2Nd*(Vrated + j*0);% rms aux wdg voltage referred to main wdg
T = (1/sqrt(2))*[ 1 -j; 1 j ]; % transformation   
V12 = T*[Vqs; Vpds];% transforming  qsds to sequence   

disp('Select with or without capacitor option')
opt_cap = menu('Machine type? ','No capacitor','With start capacitor only','With start and run capacitor')
if (opt_cap == 1) % Split-phase machine, no capacitor
disp(' Split-phase machine')
zpcstart = 0 +j*eps; % zcrun referred to main wdg
zpcrun = 0 +j*eps; % zcrun referred to main wdg
zC = zpcstart;
Capstart = 0; % set flag
Caprun = 0; % set flag
wrswbywb = we; % cutoff speed to disconnect start cpacitor 
end % if 
if (opt_cap == 2) % Capacitor-start machine
disp(' Capacitor-start machine')
zpcstart = (Nq2Nd^2)*zcstart; % zcrun referred to main wdg
zpcrun = 0 +j*eps; % zcrun referred to main wdg
zC = zpcstart;
Capstart = 1; % set flag
Caprun = 0; % set flag
wrswbywb = 0.75; % rotor speed to disconnect start cpacitor 
end % if 
if (opt_cap == 3) % Capacitor-run machine
disp(' Capacitor-run machine')
zpcstart = (Nq2Nd^2)*zcstart; % zcrun referred to main wdg
zpcrun = (Nq2Nd^2)*zcrun; % zcrun referred to main wdg
zC = zpcrun;
Capstart = 0; % set flag
Caprun = 1; % set flag
wrswbywb = 0.75; % rotor speed to changeover from start to run 
end % if 

Rcrun = real(zpcrun); % referred resistance of run capacitor 
Xcrun = imag(zpcrun); % referred reactance of run capacitor
Crun = -1/(wb*Xcrun); % referred capacitance of run capacitor 
Rcstart = real(zpcstart); % referred resistance of start capacitor 
Xcstart = imag(zpcstart); % referred reactance of run capacitor
Cstart = -1/(wb*Xcstart); % referred capacitance of start capacitor 

% network parameters of positive and negative sequence circuit
zqs = rqs + j*xlqs; % self impedance of main wdg  
zcross = 0.5*(rpds + real(zC) - rqs) + j*0.5*(xplds + imag(zC) - xlqs); 


%set up vector of slip values
s = (1:-0.02:0);
N=length(s); 

for n=1:N
s1 = s(n); % positive sequence slip 
s2 = 2-s(n); % negative sequence slip
wr(n)=2*we*(1-s1)/P; % rotor speed in mechanical rad/sec
if abs(s1) < eps; s1 = eps; end;
zp1r = rpr/s1 + j*xplr;
z1s= j*xmq*zp1r/(zp1r + j*xmq);
if abs(s2)< eps; s2 = eps; end;
zp2r = rpr/s2 + j*xplr;
z2s= j*xmq*zp2r/(zp2r + j*xmq);
z11 = zqs + z1s + zcross;
z22 = zqs + z2s + zcross;
zmat = [ z11 -zcross; -zcross z22 ];  
I12 = inv(zmat)*V12;
I1s = I12(1);
I2s = I12(2);
Iqd = inv(T)*[I1s; I2s];
Sin =[Vqs Vpds]*conj(Iqd); 
Pin = real(Sin);
angIq(n) =angle(Iqd(1))*180/pi;
angId(n) =angle(Iqd(2))*180/pi;
magIq(n) =abs(Iqd(1));
magId(n) =abs(Iqd(2));
Ip1r = -j*xmq*I1s/(zp1r + j*xmq);
Ip2r = -j*xmq*I2s/(zp2r + j*xmq);
Tavg(n)=(P/(2*we))*(abs(Ip1r)^2*rpr/s1 - abs(Ip2r)^2*rpr/s2);
Pavg(n)=Tavg(n)*wr(n);
if abs(Pin) < eps; Pin = eps; end;
eff(n)=100*Pavg(n)/Pin;
end % n for loop

N=size(wr);
subplot(3,2,1)
plot(wr,Tavg,'-')
xlabel('Rotor speed in rad/sec')
ylabel('Torque in Nm')
subplot(3,2,2)
plot(wr,Pavg,'-')
xlabel('Rotor speed in rad/sec')
ylabel('Developed power in Watts')
subplot(3,2,3)
plot(wr,magIq,'-')
xlabel('Rotor speed in rad/sec')
ylabel('|Iqs| in A')
subplot(3,2,4)
plot(wr,magId,'-')
xlabel('Rotor speed in rad/sec')
ylabel('|Ipds| in A')
subplot(3,2,5)
plot(wr,eff,'-')
xlabel('Rotor speed in rad/sec')
ylabel('Efficiency in percent')
subplot(3,2,6)
plot(wr,angIq,'-')
hold on
plot(wr,angId,'-.')
xlabel('Rotor speed in rad/sec')
ylabel('Iqs and Ipds angle in degree')
hold off

disp('Displaying steady-state characteristics ')
fprintf('Referred capacitor impedance is %.4g %.4gj Ohms\n', real(zC), imag(zC)) 
disp('type ''return'' to proceed on with simulation');
keyboard

 
% Transfer to keyboard for simulation

disp('Select loading during run up')
opt_load = menu('Loading? ','No-load','With step changes in loading')

% setting all initial conditions in SIMULINK simulation to zero
Psiqso = 0;
Psipdso = 0;
Psipqro = 0;
Psipdro = 0;
wrbywbo = 0; % initial pu rotor speed 

% set up repeating sequence Tmech signal
if (opt_load == 1) % No-load
tstop = 2; % simulation run time
tmech_time =[0 tstop];
tmech_value =[0 0];
end
if (opt_load == 2) % Step changes in loading
tstop = 2.5; % simulation run time
tmech_time =[0 1.5 1.5 1.75 1.75 2.0 2.0 2.25 2.25 2.5];
tmech_value =[0 0 -Tb -Tb -Tb/2 -Tb/2 -Tb -Tb 0 0 ];
end

disp('Set for simulation to start from standstill and ')
disp('load cycling at fixed frequency,')
disp('return for plots after simulation by typing '' return''');
keyboard

% Convert referred values back to actual
Vds = y(:,3)/Nq2Nd;
Ids = y(:,8)*Nq2Nd;
Vcap = y(:,4)/Nq2Nd;
Psids = y(:,7)/Nq2Nd;

disp('Plot results in two figure windows')
h1=gcf;
subplot(5,1,1)
plot(y(:,1),y(:,2),'-')
ylabel('Vqs in V')
subplot(5,1,2)
plot(y(:,1),Vds,'-')
ylabel('Vds in V')
subplot(5,1,3)
plot(y(:,1),y(:,9),'-')
axis([-inf inf -1 1])
ylabel('Tmech in Nm')
subplot(5,1,4)
plot(y(:,1),y(:,10),'-')
ylabel('Tem in Nm')
subplot(5,1,5)
plot(y(:,1),y(:,11),'-')
xlabel('Time in sec')
ylabel('wr/wb in pu')
h2=figure;
subplot(5,1,1)
plot(y(:,1),Vcap,'-')
ylabel('Vcap in V')
subplot(5,1,2)
plot(y(:,1),y(:,5),'-')
ylabel('Psiqs in V')
subplot(5,1,3)
plot(y(:,1),y(:,6),'-')
ylabel('Iqs in A')
subplot(5,1,4)
plot(y(:,1),Psids,'-')
ylabel('Psids in V')
subplot(5,1,5)
plot(y(:,1),Ids,'-')
xlabel('Time in sec')
ylabel('Ids in A')

disp('Save plots in Figs. 1, and 2')
disp('before typing return to exit');
keyboard;
close(h2);
