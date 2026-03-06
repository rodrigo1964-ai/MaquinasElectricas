% M-file for Exercise 2 
% plots the result of the simulation

gcf;
subplot(3,1,1)
plot(y(:,1),y(:,2))
title('source current')
ylabel('iS in A')
subplot(3,1,2)
plot(y(:,1),y(:,3))
title('capacitor voltage')
ylabel('vC in V')
subplot(3,1,3)
plot(y(:,1),y(:,4))
title('inductor current')
xlabel('time in sec.')
ylabel('iL in A')
