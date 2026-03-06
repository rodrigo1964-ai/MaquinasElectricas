% M-file for Project 2 on induction motor starting in Chapter 6
% It calculates and the torque-speed and current-speed curves
% and plots them (see Fig. 6.27 of Project 2) on starting methods 
% in Chapter 6

clear % clear workspace

% load 20 hp three-phase induction motor parameters 

p20hp

% Per-phase Thevenin's equivalent
vas = Vrated/sqrt(3); % Vrated line-to_line voltage
vth = abs((j*xm/(rs + j*(xls + xm)))*vas);
zth = (j*xm*(rs + j*xls)/(rs + j*(xls + xm )));
rth = real(zth);
xth = imag(zth);

% Compute rotor resistances
% rotor resistance for max torque at s=1
rpr1 = 0.8*sqrt(rth^2 + (xth + xplr)^2);
rprm = 0.4*sqrt(rth^2 + (xth + xplr)^2);


%set up vector of rotor resistances
rprv = [rpr rprm rpr1];

s = (1:-0.025:0.025);
N=length(s); 

for n=1:N
sn = s(n);
wr(n)=2*we*(1-sn)/P;
for nrpr = 1:3
rprn = rprv(nrpr);
zin=(rs +j*xls) + j*xm*(rprn/sn + j*xplr)/(rprn/sn + j*(xm + xplr));
ias = vas/zin; 
Sin =3*vas*conj(ias); 
pin = real(Sin);
pfin(nrpr,n)=cos(-angle(ias));
iin(nrpr,n)=abs(ias);
te(nrpr,n)=(3*P/(2*we))*(vth^2*rprn/sn)/((rth + rprn/sn)^2 + (xth + xplr)^2);
pe(nrpr,n)=te(nrpr,n)*wr(n);
eff(nrpr,n)=100*pe(nrpr,n)/pin;
end
end

% add in synchronous speed values
size(te);
z=[0 0 0];
inl=vas/(rs +j*(xls+xm));
inlm = abs(inl);
inla = cos(-angle(inl));
iin=[iin [inlm inlm inlm]'];
pfin=[pfin [inla inla inla]'];
eff=[eff z'];
te=[te z'];
pe=[pe z'];
s=[s 0];
wr=[wr 2*we/P];

N=size(wr);
M=size(te);
subplot(2,1,1)
plot(wr,te(1,:),'-',wr,te(2,:),'--',wr,te(3,:),':')
xlabel('Rotor speed in rad/sec')
ylabel('Torque in Nm')
subplot(2,1,2)
plot(wr,iin(1,:),'-',wr,iin(2,:),'--',wr,iin(3,:),':')
xlabel('Rotor speed in rad/sec')
ylabel('Stator current in Amps')
