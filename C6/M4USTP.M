% M-file for the second part of Project 4 on linearized analysis
%  in Chapter 6 to obtain the unit step response of the motor 
%  transfer function, numG/denG. 
% It can only be used after the transfer function has been
% determined by m4.m, that is numG/denG must be already 
% defined in the MATLAB workspace. 

% M4USTEP.M computes the step response using the step function
% and plots the unit step response of the transfer function
% numG/denG.
% Requires MATLAB Control System Toolbox function step

%
t =[0:0.0005:0.25]; % set up the regularly spaced time points
% Obtain the step response of the transfer function 
[y,x,ti]=step(numG,denG,t); 	% step is a Control System Toolbox
				% function
plot(ti,y);
title('step response of numG/denG')
