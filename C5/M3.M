% MATLAB script file for Project 3 on the transformation of 
%   sinusoidal and complex quantities in 
%   in the qd0 reference frames in Chapter 5.

% m3.m prompts the user for the harmonic order m of the phase
%    currents, nframe and theta(0) of the reference frame 
%    to set up the SIMULINK file s3.m.
% It also plots the results of the simulation.
 
clear all % clear workspace

repeat_run = 'Y'; % set up repeat run flag
while repeat_run == 'Y'

m = input('Enter the value of m for abc currents  > ')
alpha = input('Enter attenuation factor alpha, try 1,  > ')
disp('nframe is the speed factor of qd0 frame')   
disp('  with respect to the sychronous speed of')
disp('  the fundamental abc currents') 
nframe = input('Enter the value of nframe of the qd0 frame  > ')
disp('theta0 is the initial value theta(0)')  
theta0 = input('Enter value of theta0 > ')
disp('Run simulation s3.m, type return for plots')
keyboard

clf;
subplot(3,1,1)
plot(y(:,1),y(:,2),'-')
ylabel('ias in A')
axis([-inf inf -20 20])
subplot(3,1,2)
plot(y(:,1),y(:,3),'-')
axis([-inf inf -20 20])
ylabel('iqs in A')
subplot(3,1,3)
plot(y(:,1),y(:,4),'-')
axis([-inf inf -20 20])
ylabel('ids in A')

%h2=figure('Position',[400,50,650,650]);

h2=figure;
subplot(3,1,1)
plot(y(:,1),y(:,5),'-')
axis([-inf inf -20 20])
ylabel('i0s in A')
subplot(3,1,2)
plot(y(:,1),y(:,6),'-')
axis([-inf inf -20 20])
ylabel('iqe in A')
subplot(3,1,3)
plot(y(:,1),y(:,7),'-')
axis([-inf inf -20 20])
ylabel('ide in A')
xlabel('Time in sec')

disp('Save plots in Figs 1 and 2 before typing return to exit')
keyboard
close (h2)

% prompt for repeat with new system condition
repeat_run =  input('Repeat with new system condition? Y/N: ','s');
if isempty(repeat_run) % if empty return a No to terminate
repeat_run = 'N';
end

end % while repeat_run

