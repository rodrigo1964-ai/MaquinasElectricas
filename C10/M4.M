% MATLAB script file m4.m is for Project 4 on
%	power system stabilizer in Chapter 10
% It is to be used with the SIMULINK file s4.m 

% m4.m determines the steady-state values for initializing
% 	the Simulink simulation s4.m and computes the 
% 	the transfer functions for designing a PSS   
% 	with slip as the input signal.

%  ************* INPUT BLOCK **************************
% Computed transfer function is dependent on system parameters 
%       and operating condition:
% Inputs required:
% 	pu parameters of generator and ac network Thevenin's equiv,
% 	operating condition at generator's terminal. 
% 	parameters of excitation system

% Clear all variables in Matlab worksapce

clear variables;

% load per unit parameters of generator and excitation system
 
set1

% load parameters of pss

Ks = 120;
Tw = 1.;
T1 = 0.024;
T2 = 0.002;
T3 = 0.024;
T4 = 0.24;
pss_limit = 0.1;


% Enter option to simulate or to determine  
% transfer functions 

opt_sim = menu('Simulation or Transfer Function?',...
                'Simulation','Transfer functions');
% set up loop for repeating multiple cases

repeat_run =  'Y'; % set initially to yes for 1 or more cases 
while repeat_run == 'Y' 

% Input the following per unit parameters via the keyboard
% Type in after K>>

%  re = 0.027; for real part of ac thevenin's source impedance
%  xe = 0.1; for imag part of ac thevenin's source impedance
%  Vi = 1.0 + 0*j   for phasor voltage at infinite bus
%  Si = 0.8 + 0.6*j for delivered complex power(lagging Q>0) 

disp('Enter pu of re, xe, Vt and St via keyboard'); 
disp('Example: re = 0.027; xe = 0.1; Vi = 1 +j*0; Si = 0.8 +j*0.6')
disp('Type ''return'' following K>> prompt to continue');
keyboard
% ************* END OF INPUT BLOCK ***************

% Calculate base quantities

we = 2*pi*Frated;
wb = we;
wbm=wb*(2/Poles);
Sbase = Prated/Pfrated;
% Use peak values of phase quantites for voltage and current
Vbase = Vrated*sqrt(2/3);
Ibase = sqrt(2)*(Sbase/(sqrt(3)*Vrated));
Zbase = Vbase/Ibase;


% Determine steady state phasor and q-d variables
% Phasor reference axis is along the q axis of a synchronous qd frame,
% aligned along Vi, the infinite bus voltage.
% Transfer function expressions use rotor 
% reference frame with q-axis aligned to internal E_q.
% Stator resistance rs, though ignored for TF, is included 
%  in steady-state calculation to obtain correct values 
%  for simulation,  especially the value of  Dz.

  Ie = conj(Si/Vi);
  Eqe = Vi + ((rs+re) + (xq+xe)*j)*Ie;
  Vte = Vi + (re + xe*j)*Ie
  deltat = angle(Vte);  
  delta = angle(Eqe);

  Eqo = abs(Eqe);
  I = (conj(Eqe)/Eqo)*Ie; % I = Ie*(cos(delta) - sin(delta)*j);
  Iqo = real(I);
  Ido = -imag(I);
  Vio = abs(Vi);
  Vto = (conj(Eqe)/Eqo)*Vte; % Vto = Vt*(cos(delta) - sin(delta)*j);
  Vqo = real(Vto);
  Vdo = -imag(Vto);
  Sto = Vto*conj(I)
  Eqpo = Vqo + xpd*Ido + rs*Iqo;
  Edpo = Vdo - xpq*Iqo + rs*Ido
  Efo = Eqo + (xd-xq)*Ido;
  delio = delta
  Pmecho = real(Sto);
% initialize excitation variables
 VR = KE*Efo;
 Vs = Efo*KF/TF;
 Vref =abs(Vto)
 Dz = (re+rs)*(re+rs) + (xe + xq)*(xe + xpd);  

% ********** END OF STEADY-STATE CALCULATIONS ***********
% ********** BEGIN SIMULATION RUNS ***********

if (opt_sim == 1) % enter simulation mode 

% set PSS_sw for operation without pss
pss_sw = -5 % threshold of sw being set at zero

% set up run time and DTmech signal for load cycling
tstop = 30;
time_Dtmech=[0 7.5 7.5 15 15 22.5 22.5 30];
DT = 0.1 % size of pu torque perturbation about operating point
tmech_Dtmech=[0 0 DT DT -DT -DT 0 0];

% Transfer back to keyboard for simulation
disp('Entering simulation mode - m4.m has set up')
disp('  PSS_sw, tstop and Dtmech in s4.m') 
disp('  for you to perform simulation without pss.');
disp(' ');
disp('After your simulation run, type return.')
disp('m4.m will store results of first run for later plotting')
disp('and also set up condition for the next run with pss.')
keyboard
% store run results before making new run 
yvt = y(:,1); % store value of |Vt|
ypgen = y(:,2); % store value of Pgen
yqgen = y(:,3); % store value of Qgen
ydel = y(:,4); % store value of delta
ytime = y(:,5); % store time array for this run

% set PSS_sw for operation with pss
pss_sw = 5 % threshold of sw being set at zero

disp('Conditions set for a repeat run with pss.')
disp('Type return for plots in figure window')
keyboard

subplot(4,1,1)
plot(ytime,yvt,':',y(:,5),y(:,1),'-')
axis([0,inf,0.6,1.2]) % resize yaxis
xlabel('Time in sec')
ylabel('|Vt|')
subplot(4,1,2)
plot(ytime,ydel,':',y(:,5),y(:,4),'-')
xlabel('Time in sec')
ylabel('delta')
subplot(4,1,3)
plot(ytime,ypgen,':',y(:,5),y(:,2),'-')
xlabel('Time in sec')
ylabel('Pgen')
subplot(4,1,4)
plot(ytime,yqgen,':',y(:,5),y(:,3),'-')
xlabel('Time in sec')
ylabel('Qgen')
end % if opt_sim
	
% ********** END SIMULATION RUNS ***********
% ********** BEGINNING OF TRANSFER FUNCTION CALCULATIONS *********

if (opt_sim == 2)

  Vq_ratio = Vqo/Vto;
  Vd_ratio = Vdo/Vto;
  co = cos(delta);
  si = sin(delta);

%  compute nonlinear gains in transfer functions

  K1 = (Eqo*Vio/Dz)*(re*si + (xe+xpd)*co) + ...
(Iqo*Vio/Dz)*((xq-xpd)*(xe+xq)*si - re*(xe-xpd)*co);
  K2 = re*Eqo/Dz + Iqo*( 1 + (xq-xpd)*(xe+xq)/Dz );
  K3 = 1/(1 + (xd-xpd)*(xe+xq)/Dz);
  K4 = (Vio*(xd-xpd)/Dz)*((xe+xq)*si - re*co);
  K5 = (Vio*Vq_ratio*xpd/Dz)*( re*co - (xe+xq)*si ) ...
+ (Vio*Vd_ratio*xq/Dz)*( re*si + (xe+xpd)*co );
  K6 = Vq_ratio*( 1 - xpd*(xe+xq)/Dz ) + Vd_ratio*xq*re/Dz;


% ***** Block dealing with Exc(s)   *******

% construct numerator s polynomial of Exc(s)
 
Exc_num = KA*[TF 1];

% construct denominator s polynomial of Exc(s)

Exc_den = [TA*TE*TF (TA*TE + TA*TF + TE*TF) (TA + TE + TF + KA*KF) 1];

% compute and display zeros and poles of Exc(s)
disp('Poles and zeros of Exc(s)');
[z,p,k] = tf2zp(Exc_num,Exc_den)

% Enter option to generate plots of excitation system Exc(s) 

opt_Exc = menu('Plots of Exciter block transfer function?',...
                'Plot Frequency Response of Exc(s)','No plots');
	
if (opt_Exc == 1), 
% generate Bode plot of Exc(s)
freq = logspace(-1, 3, 500)';
w = 2*pi*freq;
[m,p]=bode(Exc_num,Exc_den,w);
clf;
disp('Displaying Bode plot of Exc(s)');
subplot(211); semilogx(freq,20*log10(m)); grid;
ylabel('Gain dB')
xlabel('Freq (Hz)')
title('Gain vs. frequency of Exc(s)')
subplot(212); semilogx(freq,p); grid;
ylabel('Phase (deg)');
xlabel('Freq (Hz)');
title('Phase vs. frequency of Exc(s)')

% compute gain and phase margins
[Exc_Gm,Exc_Pm,freq_cg,freq_cp] = margin(m,p,freq);

disp('Type ''return'' for GEP(s)');     
keyboard
end

% Generate the transfer function GEP(s) 

format short e

G_num = K3*Exc_num;
G_den = conv([K3*Tpdo 1],Exc_den); 
GEP_num = K2*G_num

% Pad zeros to equalize vector length to compute GEP_den

lp = length(G_den); lq = length(G_num);

if lp == lq,
  elseif lp > lq
  G_num = [zeros(1,lp-lq) G_num]
  else  G_den =[zeros(1,lq-lp) G_den]
end

GEP_den = G_den + K6*G_num

% compute zeros and poles

[zz,pp,kk] = tf2zp(GEP_num,GEP_den)

% Option to generate plots of GEP(s) with slip as input

opt_GEP = menu('Plot GEP(s)?','Plot Frequency Response of GEP(s)','No plots');
	
if (opt_GEP == 1), 
		    
% generate Bode plot of GEP(s) with slip as input
freq = logspace(-1, 3, 500)';
w = 2*pi*freq;
[m_GEP,p_GEP]=bode(GEP_num,GEP_den,w);
clf;
disp('Displaying Bode plot of GEP(s)');
subplot(211); semilogx(freq,20*log10(m_GEP)); grid;
ylabel('Gain dB')
xlabel('Freq (Hz)')
title('Gain vs. frequency of GEP(s)')
subplot(212); semilogx(freq,p_GEP); grid;
ylabel('Phase (deg)');
xlabel('Freq (Hz)');
title('Phase vs. frequency of GEP(s)')

% compute gain and phase margins
[GEP_Gm,GEP_Pm,freq_cg,freq_cp] = margin(m_GEP,p_GEP,freq); 
     
disp('Keyboard entry of the value of DPSS');
disp('Example: >>K DPSS = 6');
disp('Type ''return'' for PSS(s)');     
DPSS=[];
keyboard
end
while isempty(DPSS),
disp('Enter value of DPSS, Example: K>> DPSS  = 6');
disp('and type ''return'' for PSS(s)');     
keyboard
end % if isempty

% Use PSS(s) GEP(s) = -DPSS or PSS(s) = -DPSS*GEP_den/GEP_num 
% Plot inverse of GEP(s) to get ideal PSS(s) with speed input
if  (opt_GEP == 2)|(opt_GEP == 3),
[m_PSS,p_PSS]=bode(-DPSS*GEP_den,GEP_num,w);
clf;
disp('Displaying Bode plot of PSS(s)');
subplot(211); semilogx(freq,20*log10(m_PSS)); grid;
ylabel('Gain dB')
xlabel('Freq (Hz)')
title('Gain vs. frequency of PSS(s)')

subplot(212); semilogx(freq,p_PSS); grid;
ylabel('Phase (deg)');
xlabel('Freq (Hz)');
title('Phase vs. frequency of PSS(s)')
disp('Type ''return'' for PSS(s) with K4 and K5 contributions');
keyboard   
end


% Include the contributions of Ddelta via K4 and K5 in
% determining PSS(s)

% contibutions via K5

numK5 = [0 K5*wb];
denK5 = [1 0];
[a5,b5,c5,d5] = tf2ss(numK5,denK5);

% contribution via K4

numK4 = K4*wb*Exc_den;
denK4 = conv([1 0],[Exc_num]);

% determine parallel combination

denK45 = conv(denK4,denK5);

numK451 = conv(numK4,denK5);
numK452 = conv(denK4,numK5);

% Pad zeros to equalize vector length for addition

lp = length(numK451); lq = length(numK452);

    if lp == lq,
       elseif lp > lq
       numK452 = [zeros(1,lp-lq) numK452];
       else  numK451 =[zeros(1,lq-lp) numK451];
    end

% add the two numerator terms

numK45 = numK451 + numK452;

% now add numK45/denK45 to DPSS/GEP(s)

den_PSS = conv(GEP_num,denK45);

num_PSS1 = conv((-DPSS*GEP_den),denK45);
num_PSS2 = conv(GEP_num,numK45);

% Pad zeros to equalize vector length for addition

lp = length(num_PSS1); lq = length(num_PSS2);

    if lp == lq,
       elseif lp > lq
       num_PSS2 = [zeros(1,lp-lq) num_PSS2];
       else  num_PSS1 =[zeros(1,lq-lp) num_PSS1];
    end

num_PSS = num_PSS1 + num_PSS2;


% Generate Bode plots of PSS(s) for slip input
% with K4 and K5 contributions
		
freq = logspace(-1, 3, 500)';
w = 2*pi*freq;
[m_PSS,p_PSS]=bode(num_PSS,den_PSS,w);
clf;
disp('Displaying Bode plot of PSS(s) with K4 and K5');
subplot(211); semilogx(freq,20*log10(m_PSS)); grid;
ylabel('Gain dB')
xlabel('Freq (Hz)')
title('Gain vs. frequency of PSS(s) with K4 and K5')
subplot(212); semilogx(freq,p_PSS); grid;
ylabel('Phase (deg)');
xlabel('Freq (Hz)');
title('Phase vs. frequency of PSS(s) with K4 and K5')
disp('Type ''return'' for next computation');     
keyboard

end % if of opt_sim

% prompt for repeat with new system condition 
repeat_run =  input('Repeat with new system condition? Y/N: ','s');
if isempty(repeat_run) % if empty return a No to terminate
repeat_run = 'N';
end
 
end % while repeat_run
