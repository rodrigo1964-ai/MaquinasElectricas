% This function file to be used in conjunction with m5.m 
%   of Project 5 on permanent magnet drive in Chapter 10.

function f = m5torqi(sing,Tem,Em,Ia,xd,xq) 

%To obtain underexcited motoring and generating conditions
%Set Iq = abs(Ia)*cos(gamma); Id = Ia*sin(gamma)

f = Tem - Em*abs(Ia)*sqrt(1-sing*sing) - Ia*abs(Ia)*(xd - xq)*sing*sqrt(1-sing*sing);
