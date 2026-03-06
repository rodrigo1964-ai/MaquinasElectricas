% Machine parameter input file SET3B.M

% Machine data for 2x3 equivalent circuit model with one
% nonzero coupling inductance in the d-axis rotor circuits
% per IEEE Std 115A.
% From p.295 of the closure by Canay to his papers 
% Canay, I. M., " Determination of the Model Parameters
% of Machines from the Reactance Operators xd(p), xq(p)
% (Evaluation of Standstill Frequency Response Test),"
% and `` Modelling of Alternating-Current Machines
% Having Multiple Rotor Circuits,"
% IEEE Trans. on energy Conversion, Vol. 8,
% No.2 June 1993, pp. 272- 279, 280-296.
% Copyright 1993 IEEE

Frated = 60;
Poles = 2;
Vrated =26e3; 
Srated=722.222e6;
rs = 0.004; % estimate, not from above reference
xls = 0.19;
xpd = 0.346;
xpq = 0.642;

% d-axis circuit parameters
xmd = 1.70;
xd = xmd + xls;
xpr2c = 0.06650;
xpr1c = 0.0; % zero value
xp1c = 0.12094;
xp2c = 0.06563;
xp3c = -0.00988;
rpkd3 = 0.02334;
rpkd2 = 0.01848;
rpf = 0.00109;

% q-axis circuit parameters (unchanged)
xmq = 1.61;
xq = xmq + xls;
xplkq3 = 0.1225;
xplkq2 = 0.3248;
xplkq1 = 0.6802;
rpkq3 = 0.2237;
rpkq2 = 0.03537;
rpkq1 = 0.005698;

H = 3.77; % estimate, not from above reference
Domega = 0; % mechanical damping coeff
