% Matlab M-file for Exercise 1 of text.

% It plots the Simulation results of the vco circuit
% in Fig. 2.4 of the text. Labels on the traces can be
% applied using Matlab gtext. 

plot(yout(:,1),yout(:,2),'-', yout(:,1),yout(:,3),'-.')
xlabel('time in sec')
ylabel('y1 and y2')
