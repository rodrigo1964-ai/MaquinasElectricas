% MATLAB M-file m4comp.m is for checking preliminary 
%   designs of the pss in Project 4 on 
%   power system stablizer in Chapter 10. 

% m4comp.m provides the Bode plot of pss transfer function.
% If the system transfer function, GEP(s), from running m4.m 
%  is still in Matlab workspace, m4comp.m can also provide
%  a root-locus plot of the pss open-loop transfer function.  
 
% input parameters of pss
 Ks = 120;
 Tw = 1.;
 T1 = 0.024;
 T2 = 0.002;
 T3 = 0.024;
 T4 = 0.24;

numW = [1 0];
denW = [Tw 1];
num1 = [T1 1];
den1 = [T2 1];
num2 = [T3 1];
den2 = [T4 1];

num3 = conv(num1,num2);
den3 = conv(den1,den2);
num_unit = conv(num3,numW); % unity gain
num = Ks*num_unit;
den = conv(den3,denW);


[z,p,k] = tf2zp(num,den)


     
% Plot frequency response

freq = logspace(-1, 3, 500)';
     w = 2*pi*freq;
     [m_Comp,p_Comp]=bode(num,den,w);

     clf;
     subplot(211); semilogx(freq,20*log10(m_Comp)); grid;
     ylabel('Gain dB')
     xlabel('Freq (Hz)')
     title('Gain of PSS(s) vs. frequency')

     subplot(212); semilogx(freq,p_Comp); grid;
     ylabel('Phase deg');
     xlabel('Freq (Hz)');
     title('Phase of PSS(s) vs.frequency')

disp('Type ''return'' to continue');
keyboard   
disp('If GEP(s) is still in Matlab workspace from running m4.m')
disp('Option to check root locus and margin of PSS(s)*GEP(s)')

opt_root = menu('Plot root locus? ','Yes','No');

if (opt_root == 1), 

open_num = conv(num_unit,GEP_num);
open_den = conv(den,GEP_den);
      
% plot root locus
k = [10:10:300];% specify range of gain 
[r]=rlocus(open_num,open_den,k);
clf;
v=50;
h=50;
plot(r,'-')
title('Root locus of PSS*GEP loop')
xlabel('real axis')
ylabel('imag axis')
hold on
plot(real(r(1,:)), imag(r(1,:)),'x')
plot([-h h/10],[0 0],'w:')
plot([0 0],[-v v],'w:')
axis([-h h/10 -v/10 v]);
axis square ; % set plot to be square 
hold off
% transfer control to keyboard for printing of plot

disp('Type ''return'' to exit');
keyboard   
end % if opt_root
