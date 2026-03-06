% M-file to plot the results from a simulation run 
% comparing the errors from the rms open-circuit curve 
% and from the instantaneous psi versus i curve  when
% driven by a sinusoidal voltage input whose peak value 
% is between 0 and Vrmsmax   

subplot(2,2,1)
plot(I,V,'-')
grid
ylabel('V rms in V')
xlabel('I rms in A')
axis square
title('Open circuit curve in rms')
subplot(2,2,2)
plot(i,psi,'-')
ylabel('psi in V')
xlabel('i in A')
axis square
title('Instantaneous flux versus current')
subplot(2,2,3)
plot(yin(:,1),yout(:,2),'-');
ylabel('Current error in rms amps')
xlabel('time in sec')
axis square
axis([-inf inf -0.1 0.1]);
title('Error from rms value curve')
subplot(2,2,4)
plot(yin(:,1),yout(:,1),'-');
ylabel('Current error in rms amps')
xlabel('time in sec')
axis square
axis([-inf inf -0.1 0.1]);
title('Error from instantaneous value curve')
