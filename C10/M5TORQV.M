% This function file to be used in conjunction with m5.m 
%   of Project 5 on permanent magnet drive in Chapter 10.

function y = m5torqv(sind,Temo,Em,Va,xd,xq) 
y = Temo + (Em*Va/xd)*sind + Va*Va*(1/xq - 1/xd)*sind*sqrt(1-sind*sind);
