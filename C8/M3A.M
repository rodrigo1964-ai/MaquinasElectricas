% This M-file, m3a.m, is for Project 3 on methods of braking 
% of separately-excited dc motor in Chapter 8
% It is to be used in conjunction with the Simulink file s3a.m
% for the first two parts of the projects, that is 
% plugging and dynamic braking. The m-file m3b.m is for
% the other part of the project on regenerative braking.
% 
% loads the following machine parameters of dc machine
% and plots results from simulation

Prated = 2*746;  
Vrated = 125;
Iarated = 16;
wmrated = 1750*(2*pi)/60; 
Trated = Prated/wmrated;
Ra = 0.14;
Rf = 111;
Rrh = 25; % ext field rheostat resistance
Laq =  0.018; 
Lf = 10;
Rload = 1e6;
D = 0; % damping
J = 0.5; % rotor inertia in kgm2

% Set Rext for each method, one at a time 

Rext = 6.054; % Set Rext for plugging method
Vbrake = -Vrated;
% Transfer to keyboard for simulation
disp('Run plugging case, return to program by typing ''return''');
keyboard 
plot_option = menu('Do you want plots?', 'Yes' ,'No');
if plot_option == 1,
clf;
subplot(4,1,1)
plot(y(:,1),y(:,2))
title('Armature current in plugging method')
ylabel('Ia in A')
subplot(4,1,2)
plot(y(:,1),y(:,4)) 
axis([-inf inf -200 200])
title('Rotor speed in plugging method')
ylabel('wm in rad/sec')
end % if plot_option

Rext = 2.929; % Set Rext for dynamic method
Vbrake = 0;
% Transfer to keyboard for simulation
disp('Run dynamic braking case, return to program by typing ''return''');
keyboard 
if plot_option == 1,
subplot(4,1,3)
plot(y(:,1),y(:,2))
title('Armature current in dynamic braking method')
ylabel('Ia in A')
subplot(4,1,4)
plot(y(:,1),y(:,4)) 
title('Rotor speed in dynamic braking method')
ylabel('wm in rad/sec')
xlabel('time in sec')
end % if plot_option
