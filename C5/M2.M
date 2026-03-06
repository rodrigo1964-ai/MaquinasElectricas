% M-file for Project 2 on space vectors in Chapter 5.

% m2.m prompts the user for the values of m, n and attenuation
%    factor used in the SIMULINK file s2.m  
% It also plots the results of the simulation. 

clear all % clear workspace

repeat_run = 'Y'; % set up repeat run flag
while repeat_run == 'Y'

disp('iam = 10*cos(m*(2*pi*t))')
disp('ibm = 10*cos(m*(2*pi*t - 2*pi/3)')
disp('icm = 10*cos(m*(2*pi*t - 4*pi/3))')
m = input('Enter value of m  > ')
disp('Enter attenuation factor for m component') 
disp('For constant amplitude, enter zero for alpha')
disp('For spiral effect, use an alpha of 0.2')
alpha = input('Enter attenuation factor, alpha > ') 
disp('')
disp('Next enter the harmonic number n after the prompt ')
disp('Enter any negative number for n if ')
disp('     you do not want that component')
disp('')
disp('ian = (10/n)*cos(2*n*pi*t)')
disp('ibn = (10/n)*cos(2*n*pi*t - 2*n*pi/3)')
disp('icn = (10/n)*cos(2*n*pi*t - 4*n*pi/3)')
n = input('Enter value of harmonic order n  > ')
tstop = 0.95 % set the simulation time to 0.95 of
              % the basic period when m=1 and n<0. 
disp('Perform simulation and type return for figure plot')
keyboard
hnew=figure('Position',[250,25,600,300]); % open new window
subplot(1,2,1)
plot(y(:,1),y(:,2),'-')
axis([-20 20 -20 20])
axis square
title('Positive sequence i_1 locus') 
subplot(1,2,2)
plot(y(:,1),y(:,3),'-')
axis([-20 20 -20 20])
axis square
title('Negative sequence i_2 locus') 
disp('Save figures and type return to continue') 
keyboard
close(hnew) % close newly open figure window

% prompt for repeat with new system condition
repeat_run =  input('Repeat with new system condition? Y/N: ','s');
if isempty(repeat_run) % if empty return a No to terminate
repeat_run = 'N';
end

end % while repeat_run
close % close first graph window 
close % close second graph window
