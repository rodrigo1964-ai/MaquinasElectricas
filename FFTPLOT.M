% This m-file is for obtaining the fft plot of any variable
% that is stored in MATLAB's workspace as a column array.
% It requires the column array of the variable as well as the 
% the column array of the time corresponding to the variable
% values. The time step need not be uniform. 
% Here fft computation is a post-processing procedure, the   
% integration step size may be variable. 

% The fft computation is faster when
% the number of data points, npts_fft, is even.
% 
% To minimize leakage, the time window, T_window, of the data points 
% should be integer multiples of the fundamental frequency, T_1.   
% The frequency resolution of the discrete Fourier transform 
% is inversely proportional to the size of the time window.  
% freq_resolution = 1/T_window Hz, for distinct peak in fft plot 
% freq_resolution should be a small fraction of fundamental frequency 

disp('Script file computes Fourier transform of variable')
disp('based on its value in the cycle before the time you provide.') 
disp('It plots the variable vs time and its transform vs frequency.')
disp('It will prompt you next for information regarding variable') 
disp('')
Frated = input('Enter fundamental frequency in Hz > ');
T_1 = 1/Frated; % period of fundamental 

% Select sampling frequency based on highest harmonic of interest
samples_per_cycle = 128; % number of samples per cycle
sample_time = T_1/(samples_per_cycle -1); %  sampling time 
sample_freq = 1/sample_time % sampling frequency
fprintf('Highest frequency should be less than %.4g.',sample_freq/2)   

% Pad with odd number of cycles to get even npts_fft and 
% the desired frequency resolution  
ncycle = 21;% total number of cycles used in fft calculation
npts_fft = ncycle*samples_per_cycle; % number of fft points
record_length = ncycle*T_1 % total record length in seconds

freq_resolution = 1/record_length% frequency resolution of fft
				 % output 
xx = input('Enter name of stored time array e.g. y(:,1) > ');
yy = input('Enter name of stored variable array e.g. y(:,5) > ');
ystring = input('Enter string label for stored variable e.g. i_1 > ','s');
tt = input('Enter time when sample cycle ends, e.g. tstop > ');
tmargin = sample_time; % margin to avoid exceeding range
time = (tt-T_1-tmargin:sample_time:tt-tmargin);% column vector of 
				%uniformly spaced sample 
%ysample = interp1(xx,yy,time,'spline'); % interpolate 
ysample = interp1(xx,yy,time); % linear interpolation 
% test to fix differences in the behavior of interp1 
% with MATLAB 5 ysample is a row vector 
% but with MATLAB4 ysample, a column vector
[ms,ns] = size(ysample);
if  ms <= ns    
   ysample = ysample';% transpose if row vector or MATLAB5
end % test if
ytrunc = ysample(1:samples_per_cycle-1);
y_fft = ysample;
for n=2:ncycle
y_fft = [y_fft; ytrunc];
end
F = fft(y_fft); % compute fft
N = length(y_fft); % determine actual length of array 
Fdc = F(1)/N;% extract zero frequency point of fft output 
		% and rescale dc component
Fp = [Fdc; F(2:(N/2+1))*(2/N)];% extract positive frequency points  
 			% and append rescale magnitude of ac with 
			% that of dc 
freq = (sample_freq/N)*(0:N/2);%frequency values for plotting
nharm = input('Enter highest harmonic number to display on the x axis , e.g. 8 > ');
h1=figure;
subplot(2,1,1)
plot(xx,yy); % plot fft output
title(['Time trace of  ',ystring ])
xlabel('time in sec')
ylabel(ystring)
subplot(2,1,2)
plot(freq',abs(Fp)); % plot fft output
axis([0 nharm*Frated -inf inf]);% zoom in with axis scaling
xlabel('frequency in Hz')
ylabel('Fourier transform/N')
title(['Discrete transform of  ', ystring])
disp('Save fft plot before typing return') 
keyboard
close(h1)
