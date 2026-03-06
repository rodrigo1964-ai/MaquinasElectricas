% plot file for Project 5 
% Save the output of each case in a Workspace array 
%  by first reassigning it with a different name, e.g. y, y2, y3 
%  and then using the MATLAB save command.
%      e.g. save data2 y2

% reload the stored Workspace arrays using MATLAB
% command load before using this plot file
%      e.g. load data2
%
% It is assumed that the Workspace arrays of the three cases
% are stored as y, y2, and y3, respectively. 

subplot(4,1,1)
plot(y(:,1),y(:,6),'-') % SET3A.M with S5.M
ylabel('Delta in rad')
title('Power angle delta')
hold on
plot(y2(:,1),y2(:,6),'-.') % SET3B.M with S5.M
plot(y3(:,1),y3(:,6),'--') % SET3C.M with S1.M
hold off
subplot(4,1,2)
plot(y(:,1),y(:,8),'-')
ylabel('If in pu')
title('Field current for SET3A')
subplot(4,1,3)
plot(y2(:,1),y2(:,8),'-')
ylabel('If in pu')
title('Field current for SET3B')
subplot(4,1,4)
plot(y3(:,1),y3(:,8),'-')
ylabel('If in pu')
title('Field current for SET3C')
xlabel('time in sec')

