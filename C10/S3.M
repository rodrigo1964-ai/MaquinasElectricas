function [ret,x0,str,ts,xts]=s3(t,x,u,flag);
%s3	is the M-file description of the SIMULINK system named s3.
%	The block-diagram can be displayed by typing: s3.
%
%	SYS=s3(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes s3 to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling s3 with a FLAG of zero:
%	[SIZES]=s3([],[],[],0),  returns a vector, SIZES, which
%	contains the sizes of the state vector and other parameters.
%		SIZES(1) number of states
%		SIZES(2) number of discrete states
%		SIZES(3) number of outputs
%		SIZES(4) number of inputs
%		SIZES(5) number of roots (currently unsupported)
%		SIZES(6) direct feedthrough flag
%		SIZES(7) number of sample times
%
%	For the definition of other parameters in SIZES, see SFUNC.
%	See also, TRIM, LINMOD, LINSIM, EULER, RK23, RK45, ADAMS, GEAR.

% Note: This M-file is only used for saving graphical information;
%       after the model is loaded into memory an internal model
%       representation is used.

% the system will take on the name of this mfile:
sys = mfilename;
new_system(sys)
simver(1.3)
if (0 == (nargin + nargout))
     set_param(sys,'Location',[12,55,803,388])
     open_system(sys)
end;
set_param(sys,'algorithm',     'RK-45')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     '0.7')
set_param(sys,'Min step size', '1e-4')
set_param(sys,'Max step size', '1e-2')
set_param(sys,'Relative error','1e-5')
set_param(sys,'Return vars',   '')
set_param(sys,'AssignWideVectorLines','on');


%     Subsystem  'Plot//Scope'.

new_system([sys,'/','Plot//Scope'])
set_param([sys,'/','Plot//Scope'],'Location',[4,145,735,510])

add_block('built-in/Scope',[sys,'/','Plot//Scope/Scope'])
set_param([sys,'/','Plot//Scope/Scope'],...
		'Vgain','3.000000',...
		'Hgain','0.700000',...
		'Vmax','6.000000',...
		'Hmax','1.400000',...
		'Window',[0,347,812,498],...
		'position',[650,230,680,260])

add_block('built-in/To Workspace',[sys,'/','Plot//Scope/Out'])
set_param([sys,'/','Plot//Scope/Out'],...
		'mat-name','yout',...
		'buffer','20000',...
		'position',[640,157,690,173])

add_block('built-in/Inport',[sys,'/','Plot//Scope/in_Gen-Exc'])
set_param([sys,'/','Plot//Scope/in_Gen-Exc'],...
		'Port','7',...
		'position',[450,255,470,275])

add_block('built-in/Inport',[sys,'/','Plot//Scope/in_LPA-LPB'])
set_param([sys,'/','Plot//Scope/in_LPA-LPB'],...
		'Port','6',...
		'position',[450,215,470,235])

add_block('built-in/Inport',[sys,'/','Plot//Scope/in_Tem'])
set_param([sys,'/','Plot//Scope/in_Tem'],...
		'Port','5',...
		'position',[450,175,470,195])

add_block('built-in/Mux',[sys,'/','Plot//Scope/Mux'])
set_param([sys,'/','Plot//Scope/Mux'],...
		'inputs','6',...
		'position',[555,44,585,286])

add_block('built-in/Mux',[sys,'/','Plot//Scope/Mux1'])
set_param([sys,'/','Plot//Scope/Mux1'],...
		'inputs','5',...
		'position',[145,74,175,196])

add_block('built-in/Inport',[sys,'/','Plot//Scope/in_iqe'])
set_param([sys,'/','Plot//Scope/in_iqe'],...
		'position',[70,100,90,120])

add_block('built-in/Clock',[sys,'/','Plot//Scope/Clock'])
set_param([sys,'/','Plot//Scope/Clock'],...
		'position',[70,55,90,75])

add_block('built-in/Inport',[sys,'/','Plot//Scope/in_vdCs'])
set_param([sys,'/','Plot//Scope/in_vdCs'],...
		'Port','4',...
		'position',[70,245,90,265])

add_block('built-in/Inport',[sys,'/','Plot//Scope/in_ide'])
set_param([sys,'/','Plot//Scope/in_ide'],...
		'Port','2',...
		'position',[70,150,90,170])

add_block('built-in/Inport',[sys,'/','Plot//Scope/in_vqCs'])
set_param([sys,'/','Plot//Scope/in_vqCs'],...
		'Port','3',...
		'position',[70,195,90,215])

add_block('built-in/Fcn',[sys,'/','Plot//Scope/Fcn'])
set_param([sys,'/','Plot//Scope/Fcn'],...
		'Expr','u[2]*cos(wb*u[1]) + u[3]*sin(wb*u[1])',...
		'position',[205,135,430,165])

add_block('built-in/Fcn',[sys,'/','Plot//Scope/Fcn1'])
set_param([sys,'/','Plot//Scope/Fcn1'],...
		'Expr','u[4]*cos(wb*u[1]) + u[5]*sin(wb*u[1])',...
		'position',[205,90,430,120])
add_line([sys,'/','Plot//Scope'],[590,165;635,165])
add_line([sys,'/','Plot//Scope'],[475,185;550,185])
add_line([sys,'/','Plot//Scope'],[180,135;185,135;185,150;200,150])
add_line([sys,'/','Plot//Scope'],[180,135;185,135;185,105;200,105])
add_line([sys,'/','Plot//Scope'],[95,110;140,110])
add_line([sys,'/','Plot//Scope'],[95,160;105,160;105,135;140,135])
add_line([sys,'/','Plot//Scope'],[95,205;115,205;115,160;140,160])
add_line([sys,'/','Plot//Scope'],[95,255;125,255;125,185;140,185])
add_line([sys,'/','Plot//Scope'],[475,225;550,225])
add_line([sys,'/','Plot//Scope'],[475,265;550,265])
add_line([sys,'/','Plot//Scope'],[95,65;550,65])
add_line([sys,'/','Plot//Scope'],[95,65;125,65;125,85;140,85])
add_line([sys,'/','Plot//Scope'],[590,165;615,165;615,245;645,245])
add_line([sys,'/','Plot//Scope'],[435,150;485,150;485,145;550,145])
add_line([sys,'/','Plot//Scope'],[435,105;550,105])


%     Finished composite block 'Plot//Scope'.

set_param([sys,'/','Plot//Scope'],...
		'orientation',3,...
		'position',[427,35,543,80])


%     Subsystem  'gen'.

new_system([sys,'/','gen'])
set_param([sys,'/','gen'],'Location',[-66,136,707,591])

add_block('built-in/Inport',[sys,'/','gen/in_vdse'])
set_param([sys,'/','gen/in_vdse'],...
		'Port','2',...
		'position',[80,255,100,275])

add_block('built-in/Inport',[sys,'/','gen/in_vqse'])
set_param([sys,'/','gen/in_vqse'],...
		'position',[30,230,50,250])

add_block('built-in/Note',[sys,'/','gen/vdr'])
set_param([sys,'/','gen/vdr'],...
		'position',[190,265,195,270])

add_block('built-in/Note',[sys,'/','gen/vqr'])
set_param([sys,'/','gen/vqr'],...
		'position',[188,223,193,228])


%     Subsystem  'gen/qde2qdr'.

new_system([sys,'/','gen/qde2qdr'])
set_param([sys,'/','gen/qde2qdr'],'Location',[103,460,628,647])

add_block('built-in/Mux',[sys,'/','gen/qde2qdr/Mux'])
set_param([sys,'/','gen/qde2qdr/Mux'],...
		'hide name',0,...
		'inputs','3',...
		'position',[75,50,105,130])

add_block('built-in/Fcn',[sys,'/','gen/qde2qdr/fcn'])
set_param([sys,'/','gen/qde2qdr/fcn'],...
		'Expr','u[1]*cos(u[3]) - u[2]*sin(u[3])',...
		'position',[150,52,390,78])

add_block('built-in/Fcn',[sys,'/','gen/qde2qdr/fcn1'])
set_param([sys,'/','gen/qde2qdr/fcn1'],...
		'Expr','u[1]*sin(u[3]) + u[2]*cos(u[3])',...
		'position',[150,97,390,123])

add_block('built-in/Inport',[sys,'/','gen/qde2qdr/vde'])
set_param([sys,'/','gen/qde2qdr/vde'],...
		'Port','2',...
		'position',[15,80,35,100])

add_block('built-in/Inport',[sys,'/','gen/qde2qdr/delta '])
set_param([sys,'/','gen/qde2qdr/delta '],...
		'Port','3',...
		'position',[15,124,35,146])

add_block('built-in/Inport',[sys,'/','gen/qde2qdr/vqe'])
set_param([sys,'/','gen/qde2qdr/vqe'],...
		'position',[15,35,35,55])

add_block('built-in/Outport',[sys,'/','gen/qde2qdr/vdr'])
set_param([sys,'/','gen/qde2qdr/vdr'],...
		'Port','2',...
		'position',[445,100,465,120])

add_block('built-in/Outport',[sys,'/','gen/qde2qdr/vqr'])
set_param([sys,'/','gen/qde2qdr/vqr'],...
		'position',[445,55,465,75])
add_line([sys,'/','gen/qde2qdr'],[395,110;440,110])
add_line([sys,'/','gen/qde2qdr'],[40,45;50,45;50,65;70,65])
add_line([sys,'/','gen/qde2qdr'],[395,65;440,65])
add_line([sys,'/','gen/qde2qdr'],[110,90;125,90;125,65;145,65])
add_line([sys,'/','gen/qde2qdr'],[110,90;125,90;125,110;145,110])
add_line([sys,'/','gen/qde2qdr'],[40,135;50,135;50,115;70,115])
add_line([sys,'/','gen/qde2qdr'],[40,90;70,90])


%     Finished composite block 'gen/qde2qdr'.

set_param([sys,'/','gen/qde2qdr'],...
		'position',[135,229,175,301])


%     Subsystem  'gen/q_cct'.

new_system([sys,'/','gen/q_cct'])
set_param([sys,'/','gen/q_cct'],'Location',[154,128,1103,645])

add_block('built-in/Outport',[sys,'/','gen/q_cct/Out_psiq'])
set_param([sys,'/','gen/q_cct/Out_psiq'],...
		'position',[585,45,605,65])

add_block('built-in/Outport',[sys,'/','gen/q_cct/Out_-iq'])
set_param([sys,'/','gen/q_cct/Out_-iq'],...
		'Port','2',...
		'position',[830,230,850,250])

add_block('built-in/Outport',[sys,'/','gen/q_cct/Out_psimq'])
set_param([sys,'/','gen/q_cct/Out_psimq'],...
		'Port','3',...
		'position',[835,120,855,140])

add_block('built-in/Mux',[sys,'/','gen/q_cct/Mux4'])
set_param([sys,'/','gen/q_cct/Mux4'],...
		'inputs','2',...
		'position',[520,204,540,271])

add_block('built-in/Fcn',[sys,'/','gen/q_cct/Fcn4'])
set_param([sys,'/','gen/q_cct/Fcn4'],...
		'Expr','-(u[1]-u[2])/xls',...
		'position',[565,227,655,253])

add_block('built-in/Fcn',[sys,'/','gen/q_cct/Fcn3'])
set_param([sys,'/','gen/q_cct/Fcn3'],...
		'Expr','xMQ*(u[1]/xls+u[2]/xplkq2+u[3]/xplkq)',...
		'position',[565,114,775,146])

add_block('built-in/Mux',[sys,'/','gen/q_cct/Mux3'])
set_param([sys,'/','gen/q_cct/Mux3'],...
		'inputs','3',...
		'position',[520,87,545,173])

add_block('built-in/Integrator',[sys,'/','gen/q_cct/psipkq_'])
set_param([sys,'/','gen/q_cct/psipkq_'],...
		'Initial','Psikqo',...
		'position',[390,357,420,383])

add_block('built-in/Fcn',[sys,'/','gen/q_cct/Fcn2'])
set_param([sys,'/','gen/q_cct/Fcn2'],...
		'Expr','wb*rpkq*(u[1]-u[2])/xplkq',...
		'position',[180,356,365,384])

add_block('built-in/Integrator',[sys,'/','gen/q_cct/psipkq2_'])
set_param([sys,'/','gen/q_cct/psipkq2_'],...
		'Initial','Psikq2o',...
		'position',[390,247,420,273])

add_block('built-in/Fcn',[sys,'/','gen/q_cct/Fcn1'])
set_param([sys,'/','gen/q_cct/Fcn1'],...
		'Expr','wb*rpkq2*(u[1]-u[2])/xplkq2',...
		'position',[175,245,375,275])

add_block('built-in/Integrator',[sys,'/','gen/q_cct/psiq_'])
set_param([sys,'/','gen/q_cct/psiq_'],...
		'Initial','Psiqo',...
		'position',[390,127,420,153])

add_block('built-in/Mux',[sys,'/','gen/q_cct/Mux2'])
set_param([sys,'/','gen/q_cct/Mux2'],...
		'inputs','2',...
		'position',[130,330,155,405])

add_block('built-in/Mux',[sys,'/','gen/q_cct/Mux1'])
set_param([sys,'/','gen/q_cct/Mux1'],...
		'inputs','2',...
		'position',[135,220,160,300])

add_block('built-in/Fcn',[sys,'/','gen/q_cct/Fcn'])
set_param([sys,'/','gen/q_cct/Fcn'],...
		'Expr','wb*(u[2]-u[3]+(rs/xls)*(u[1]-u[4]))',...
		'position',[180,125,375,155])

add_block('built-in/Inport',[sys,'/','gen/q_cct/In_wrpsid'])
set_param([sys,'/','gen/q_cct/In_wrpsid'],...
		'Port','2',...
		'position',[50,160,70,180])

add_block('built-in/Inport',[sys,'/','gen/q_cct/In_vqr'])
set_param([sys,'/','gen/q_cct/In_vqr'],...
		'position',[50,105,70,125])

add_block('built-in/Mux',[sys,'/','gen/q_cct/Mux'])
set_param([sys,'/','gen/q_cct/Mux'],...
		'position',[135,86,160,189])

add_block('built-in/Scope',[sys,'/','gen/q_cct/qaxis_Scope'])
set_param([sys,'/','gen/q_cct/qaxis_Scope'],...
		'Vgain','3.000000',...
		'Hgain','0.050000',...
		'Vmax','6.000000',...
		'Hmax','2.000000',...
		'Window',[451,130,627,387],...
		'position',[835,402,855,428])
add_line([sys,'/','gen/q_cct'],[75,170;95,170;95,150;130,150])
add_line([sys,'/','gen/q_cct'],[75,115;95,115;95,125;130,125])
add_line([sys,'/','gen/q_cct'],[165,140;175,140])
add_line([sys,'/','gen/q_cct'],[380,140;385,140])
add_line([sys,'/','gen/q_cct'],[425,140;435,140;435,205;115,205;115,175;130,175])
add_line([sys,'/','gen/q_cct'],[165,260;170,260])
add_line([sys,'/','gen/q_cct'],[380,260;385,260])
add_line([sys,'/','gen/q_cct'],[160,370;175,370])
add_line([sys,'/','gen/q_cct'],[370,370;385,370])
add_line([sys,'/','gen/q_cct'],[425,370;460,370;460,430;110,430;110,385;125,385])
add_line([sys,'/','gen/q_cct'],[425,140;435,140;435,100;515,100])
add_line([sys,'/','gen/q_cct'],[425,260;450,260;450,130;515,130])
add_line([sys,'/','gen/q_cct'],[425,370;460,370;460,160;515,160])
add_line([sys,'/','gen/q_cct'],[550,130;560,130])
add_line([sys,'/','gen/q_cct'],[545,240;560,240])
add_line([sys,'/','gen/q_cct'],[425,140;470,140;470,220;515,220])
add_line([sys,'/','gen/q_cct'],[780,130;790,130;790,305;495,305;495,255;515,255])
add_line([sys,'/','gen/q_cct'],[780,130;790,130;790,445;90,445;90,350;125,350])
add_line([sys,'/','gen/q_cct'],[780,130;790,130;790,445;90,445;90,240;130,240])
add_line([sys,'/','gen/q_cct'],[780,130;790,130;790,80;115,80;115,100;130,100])
add_line([sys,'/','gen/q_cct'],[780,130;830,130])
add_line([sys,'/','gen/q_cct'],[660,240;825,240])
add_line([sys,'/','gen/q_cct'],[425,140;435,140;435,55;580,55])
add_line([sys,'/','gen/q_cct'],[425,260;435,260;435,320;115,320;115,280;130,280])


%     Finished composite block 'gen/q_cct'.

set_param([sys,'/','gen/q_cct'],...
		'position',[260,193,300,267])

add_block('built-in/Note',[sys,'/','gen/wr//wb'])
set_param([sys,'/','gen/wr//wb'],...
		'position',[585,155,590,160])

add_block('built-in/Outport',[sys,'/','gen/out_|It|'])
set_param([sys,'/','gen/out_|It|'],...
		'Port','2',...
		'position',[640,55,660,75])

add_block('built-in/Outport',[sys,'/','gen/out_Pgen'])
set_param([sys,'/','gen/out_Pgen'],...
		'Port','3',...
		'position',[580,80,600,100])

add_block('built-in/Outport',[sys,'/','gen/out_Qgen'])
set_param([sys,'/','gen/out_Qgen'],...
		'Port','4',...
		'position',[640,105,660,125])

add_block('built-in/Outport',[sys,'/','gen/out_|Vt|'])
set_param([sys,'/','gen/out_|Vt|'],...
		'position',[580,30,600,50])


%     Subsystem  'gen/PQgen'.

new_system([sys,'/','gen/PQgen'])
set_param([sys,'/','gen/PQgen'],'Location',[217,186,928,574])

add_block('built-in/Mux',[sys,'/','gen/PQgen/Mux'])
set_param([sys,'/','gen/PQgen/Mux'],...
		'position',[180,75,210,260])

add_block('built-in/Inport',[sys,'/','gen/PQgen/vdr'])
set_param([sys,'/','gen/PQgen/vdr'],...
		'Port','3',...
		'position',[115,180,135,200])

add_block('built-in/Fcn',[sys,'/','gen/PQgen/Fcn'])
set_param([sys,'/','gen/PQgen/Fcn'],...
		'Expr','sqrt(u[1]*u[1] + u[3]*u[3])',...
		'position',[285,75,450,105])

add_block('built-in/Fcn',[sys,'/','gen/PQgen/P'])
set_param([sys,'/','gen/PQgen/P'],...
		'Expr','u[1]*u[2] + u[3]*u[4]',...
		'position',[285,180,450,210])

add_block('built-in/Fcn',[sys,'/','gen/PQgen/Q'])
set_param([sys,'/','gen/PQgen/Q'],...
		'Expr','u[1]*u[4]-u[2]*u[3]',...
		'position',[285,230,450,260])

add_block('built-in/Outport',[sys,'/','gen/PQgen/Pgen'])
set_param([sys,'/','gen/PQgen/Pgen'],...
		'Port','3',...
		'position',[510,185,530,205])

add_block('built-in/Outport',[sys,'/','gen/PQgen/Out_|Vt|'])
set_param([sys,'/','gen/PQgen/Out_|Vt|'],...
		'position',[510,80,530,100])

add_block('built-in/Fcn',[sys,'/','gen/PQgen/Fcn1'])
set_param([sys,'/','gen/PQgen/Fcn1'],...
		'Expr','sqrt(u[2]*u[2] + u[4]*u[4])',...
		'position',[285,125,450,155])

add_block('built-in/Outport',[sys,'/','gen/PQgen/Qgen'])
set_param([sys,'/','gen/PQgen/Qgen'],...
		'Port','4',...
		'position',[510,235,530,255])

add_block('built-in/Outport',[sys,'/','gen/PQgen/Out_|It|'])
set_param([sys,'/','gen/PQgen/Out_|It|'],...
		'Port','2',...
		'position',[510,130,530,150])

add_block('built-in/Inport',[sys,'/','gen/PQgen/-iqr'])
set_param([sys,'/','gen/PQgen/-iqr'],...
		'Port','2',...
		'position',[115,135,135,155])

add_block('built-in/Inport',[sys,'/','gen/PQgen/vqr'])
set_param([sys,'/','gen/PQgen/vqr'],...
		'position',[115,90,135,110])

add_block('built-in/Inport',[sys,'/','gen/PQgen/-idr'])
set_param([sys,'/','gen/PQgen/-idr'],...
		'Port','4',...
		'position',[115,225,135,245])
add_line([sys,'/','gen/PQgen'],[140,100;175,100])
add_line([sys,'/','gen/PQgen'],[140,145;175,145])
add_line([sys,'/','gen/PQgen'],[140,190;175,190])
add_line([sys,'/','gen/PQgen'],[140,235;175,235])
add_line([sys,'/','gen/PQgen'],[215,170;240,170;240,195;280,195])
add_line([sys,'/','gen/PQgen'],[455,195;505,195])
add_line([sys,'/','gen/PQgen'],[455,245;505,245])
add_line([sys,'/','gen/PQgen'],[215,170;240,170;240,245;280,245])
add_line([sys,'/','gen/PQgen'],[215,170;240,170;240,90;280,90])
add_line([sys,'/','gen/PQgen'],[215,170;240,170;240,140;280,140])
add_line([sys,'/','gen/PQgen'],[455,140;505,140])
add_line([sys,'/','gen/PQgen'],[455,90;505,90])


%     Finished composite block 'gen/PQgen'.

set_param([sys,'/','gen/PQgen'],...
		'position',[490,31,525,124])

add_block('built-in/Product',[sys,'/','gen/prod1'])
set_param([sys,'/','gen/prod1'],...
		'orientation',2,...
		'Font Number',3,...
		'position',[270,118,285,147])

add_block('built-in/Note',[sys,'/','gen/psid'])
set_param([sys,'/','gen/psid'],...
		'position',[325,282,330,287])

add_block('built-in/Inport',[sys,'/','gen/in_Ef'])
set_param([sys,'/','gen/in_Ef'],...
		'Port','3',...
		'position',[190,350,210,370])


%     Subsystem  'gen/d_cct'.

new_system([sys,'/','gen/d_cct'])
set_param([sys,'/','gen/d_cct'],'Location',[252,284,1201,801])

add_block('built-in/Outport',[sys,'/','gen/d_cct/Out_psid'])
set_param([sys,'/','gen/d_cct/Out_psid'],...
		'position',[585,45,605,65])

add_block('built-in/Inport',[sys,'/','gen/d_cct/In_Ef'])
set_param([sys,'/','gen/d_cct/In_Ef'],...
		'Port','3',...
		'position',[50,250,70,270])

add_block('built-in/Outport',[sys,'/','gen/d_cct/Out_ipf'])
set_param([sys,'/','gen/d_cct/Out_ipf'],...
		'Port','4',...
		'position',[835,335,855,355])

add_block('built-in/Outport',[sys,'/','gen/d_cct/Out_-id'])
set_param([sys,'/','gen/d_cct/Out_-id'],...
		'Port','2',...
		'position',[830,230,850,250])

add_block('built-in/Outport',[sys,'/','gen/d_cct/Out_psimd'])
set_param([sys,'/','gen/d_cct/Out_psimd'],...
		'Port','3',...
		'position',[835,120,855,140])

add_block('built-in/Fcn',[sys,'/','gen/d_cct/Fcn5'])
set_param([sys,'/','gen/d_cct/Fcn5'],...
		'Expr','(u[1]-u[2])/xplf',...
		'position',[565,332,655,358])

add_block('built-in/Mux',[sys,'/','gen/d_cct/Mux5'])
set_param([sys,'/','gen/d_cct/Mux5'],...
		'inputs','2',...
		'position',[520,309,540,376])

add_block('built-in/Mux',[sys,'/','gen/d_cct/Mux4'])
set_param([sys,'/','gen/d_cct/Mux4'],...
		'inputs','2',...
		'position',[520,204,540,271])

add_block('built-in/Fcn',[sys,'/','gen/d_cct/Fcn4'])
set_param([sys,'/','gen/d_cct/Fcn4'],...
		'Expr','-(u[1]-u[2])/xls',...
		'position',[565,227,655,253])

add_block('built-in/Fcn',[sys,'/','gen/d_cct/Fcn3'])
set_param([sys,'/','gen/d_cct/Fcn3'],...
		'Expr','xMD*(u[1]/xls+u[2]/xplf+u[3]/xplkd)',...
		'position',[565,114,775,146])

add_block('built-in/Mux',[sys,'/','gen/d_cct/Mux3'])
set_param([sys,'/','gen/d_cct/Mux3'],...
		'inputs','3',...
		'position',[520,87,545,173])

add_block('built-in/Integrator',[sys,'/','gen/d_cct/psipkd_'])
set_param([sys,'/','gen/d_cct/psipkd_'],...
		'Initial','Psikdo',...
		'position',[390,357,420,383])

add_block('built-in/Fcn',[sys,'/','gen/d_cct/Fcn2'])
set_param([sys,'/','gen/d_cct/Fcn2'],...
		'Expr','wb*rpkd*(u[1]-u[2])/xplkd',...
		'position',[180,356,365,384])

add_block('built-in/Integrator',[sys,'/','gen/d_cct/psipf_'])
set_param([sys,'/','gen/d_cct/psipf_'],...
		'Initial','Psifo',...
		'position',[390,247,420,273])

add_block('built-in/Fcn',[sys,'/','gen/d_cct/Fcn1'])
set_param([sys,'/','gen/d_cct/Fcn1'],...
		'Expr','wb*rpf*(u[2]/xmd+(u[1]-u[3])/xplf)',...
		'position',[175,245,375,275])

add_block('built-in/Integrator',[sys,'/','gen/d_cct/psid_'])
set_param([sys,'/','gen/d_cct/psid_'],...
		'Initial','Psido',...
		'position',[390,127,420,153])

add_block('built-in/Mux',[sys,'/','gen/d_cct/Mux2'])
set_param([sys,'/','gen/d_cct/Mux2'],...
		'inputs','2',...
		'position',[130,330,155,405])

add_block('built-in/Mux',[sys,'/','gen/d_cct/Mux1'])
set_param([sys,'/','gen/d_cct/Mux1'],...
		'inputs','3',...
		'position',[135,217,160,303])

add_block('built-in/Fcn',[sys,'/','gen/d_cct/Fcn'])
set_param([sys,'/','gen/d_cct/Fcn'],...
		'Expr','wb*(u[2]+u[3]+(rs/xls)*(u[1]-u[4]))',...
		'position',[180,125,375,155])

add_block('built-in/Inport',[sys,'/','gen/d_cct/In_wrpsiq'])
set_param([sys,'/','gen/d_cct/In_wrpsiq'],...
		'Port','2',...
		'position',[50,160,70,180])

add_block('built-in/Inport',[sys,'/','gen/d_cct/In_vdr'])
set_param([sys,'/','gen/d_cct/In_vdr'],...
		'position',[50,105,70,125])

add_block('built-in/Mux',[sys,'/','gen/d_cct/Mux'])
set_param([sys,'/','gen/d_cct/Mux'],...
		'position',[135,86,160,189])

add_block('built-in/Scope',[sys,'/','gen/d_cct/daxis_Scope'])
set_param([sys,'/','gen/d_cct/daxis_Scope'],...
		'Vgain','3.000000',...
		'Hgain','0.050000',...
		'Vmax','6.000000',...
		'Hmax','2.000000',...
		'Window',[451,130,627,387],...
		'position',[835,402,855,428])
add_line([sys,'/','gen/d_cct'],[75,170;95,170;95,150;130,150])
add_line([sys,'/','gen/d_cct'],[75,115;95,115;95,125;130,125])
add_line([sys,'/','gen/d_cct'],[165,140;175,140])
add_line([sys,'/','gen/d_cct'],[380,140;385,140])
add_line([sys,'/','gen/d_cct'],[425,140;435,140;435,205;115,205;115,175;130,175])
add_line([sys,'/','gen/d_cct'],[165,260;170,260])
add_line([sys,'/','gen/d_cct'],[380,260;385,260])
add_line([sys,'/','gen/d_cct'],[425,260;450,260;450,320;115,320;115,290;130,290])
add_line([sys,'/','gen/d_cct'],[75,260;130,260])
add_line([sys,'/','gen/d_cct'],[160,370;175,370])
add_line([sys,'/','gen/d_cct'],[370,370;385,370])
add_line([sys,'/','gen/d_cct'],[425,370;460,370;460,430;110,430;110,385;125,385])
add_line([sys,'/','gen/d_cct'],[425,140;435,140;435,100;515,100])
add_line([sys,'/','gen/d_cct'],[425,260;450,260;450,130;515,130])
add_line([sys,'/','gen/d_cct'],[425,370;460,370;460,160;515,160])
add_line([sys,'/','gen/d_cct'],[550,130;560,130])
add_line([sys,'/','gen/d_cct'],[545,240;560,240])
add_line([sys,'/','gen/d_cct'],[425,140;470,140;470,220;515,220])
add_line([sys,'/','gen/d_cct'],[545,345;560,345])
add_line([sys,'/','gen/d_cct'],[425,260;485,260;485,325;515,325])
add_line([sys,'/','gen/d_cct'],[780,130;790,130;790,445;495,445;495,360;515,360])
add_line([sys,'/','gen/d_cct'],[780,130;790,130;790,305;495,305;495,255;515,255])
add_line([sys,'/','gen/d_cct'],[780,130;790,130;790,445;90,445;90,350;125,350])
add_line([sys,'/','gen/d_cct'],[780,130;790,130;790,445;90,445;90,230;130,230])
add_line([sys,'/','gen/d_cct'],[780,130;790,130;790,80;115,80;115,100;130,100])
add_line([sys,'/','gen/d_cct'],[780,130;830,130])
add_line([sys,'/','gen/d_cct'],[660,240;825,240])
add_line([sys,'/','gen/d_cct'],[660,345;830,345])
add_line([sys,'/','gen/d_cct'],[425,140;435,140;435,55;580,55])


%     Finished composite block 'gen/d_cct'.

set_param([sys,'/','gen/d_cct'],...
		'position',[260,298,300,372])

add_block('built-in/Product',[sys,'/','gen/prod2'])
set_param([sys,'/','gen/prod2'],...
		'orientation',2,...
		'Font Number',3,...
		'position',[305,148,320,177])

add_block('built-in/Outport',[sys,'/','gen/out_ide'])
set_param([sys,'/','gen/out_ide'],...
		'Port','9',...
		'position',[625,400,645,420])

add_block('built-in/Outport',[sys,'/','gen/out_iqe'])
set_param([sys,'/','gen/out_iqe'],...
		'Port','8',...
		'position',[525,375,545,395])


%     Subsystem  'gen/qdr2qde'.

new_system([sys,'/','gen/qdr2qde'])
set_param([sys,'/','gen/qdr2qde'],'Location',[268,603,791,790])

add_block('built-in/Inport',[sys,'/','gen/qdr2qde/-idr'])
set_param([sys,'/','gen/qdr2qde/-idr'],...
		'Port','2',...
		'position',[15,80,35,100])

add_block('built-in/Inport',[sys,'/','gen/qdr2qde/delta'])
set_param([sys,'/','gen/qdr2qde/delta'],...
		'Port','3',...
		'position',[15,120,35,140])

add_block('built-in/Inport',[sys,'/','gen/qdr2qde/-iqr'])
set_param([sys,'/','gen/qdr2qde/-iqr'],...
		'position',[15,40,35,60])

add_block('built-in/Mux',[sys,'/','gen/qdr2qde/Mux'])
set_param([sys,'/','gen/qdr2qde/Mux'],...
		'hide name',0,...
		'inputs','3',...
		'position',[75,27,100,153])

add_block('built-in/Fcn',[sys,'/','gen/qdr2qde/fcn'])
set_param([sys,'/','gen/qdr2qde/fcn'],...
		'Expr','u[1]*cos(u[3]) + u[2]*sin(u[3])',...
		'position',[155,36,360,64])

add_block('built-in/Outport',[sys,'/','gen/qdr2qde/-iqe'])
set_param([sys,'/','gen/qdr2qde/-iqe'],...
		'position',[420,40,440,60])

add_block('built-in/Outport',[sys,'/','gen/qdr2qde/-ide'])
set_param([sys,'/','gen/qdr2qde/-ide'],...
		'Port','2',...
		'position',[420,120,440,140])

add_block('built-in/Fcn',[sys,'/','gen/qdr2qde/fcn1'])
set_param([sys,'/','gen/qdr2qde/fcn1'],...
		'Expr','-u[1]*sin(u[3]) + u[2]*cos(u[3])',...
		'position',[150,116,360,144])
add_line([sys,'/','gen/qdr2qde'],[365,130;415,130])
add_line([sys,'/','gen/qdr2qde'],[40,50;70,50])
add_line([sys,'/','gen/qdr2qde'],[365,50;415,50])
add_line([sys,'/','gen/qdr2qde'],[105,90;125,90;125,50;150,50])
add_line([sys,'/','gen/qdr2qde'],[105,90;125,90;125,130;145,130])
add_line([sys,'/','gen/qdr2qde'],[40,90;70,90])
add_line([sys,'/','gen/qdr2qde'],[40,130;70,130])


%     Finished composite block 'gen/qdr2qde'.

set_param([sys,'/','gen/qdr2qde'],...
		'position',[450,369,490,421])

add_block('built-in/Note',[sys,'/','gen/psiq'])
set_param([sys,'/','gen/psiq'],...
		'position',[325,187,330,192])

add_block('built-in/Inport',[sys,'/','gen/in_Tmech'])
set_param([sys,'/','gen/in_Tmech'],...
		'Port','4',...
		'position',[450,295,470,315])

add_block('built-in/Note',[sys,'/','gen/-iqr'])
set_param([sys,'/','gen/-iqr'],...
		'position',[320,207,325,212])

add_block('built-in/Note',[sys,'/','gen/-idr'])
set_param([sys,'/','gen/-idr'],...
		'position',[320,307,325,312])


%     Subsystem  'gen/Rotor'.

new_system([sys,'/','gen/Rotor'])
set_param([sys,'/','gen/Rotor'],'Location',[59,317,1033,761])

add_block('built-in/Note',[sys,'/','gen/Rotor/Tem_'])
set_param([sys,'/','gen/Rotor/Tem_'],...
		'position',[185,260,190,265])

add_block('built-in/State-Space',[sys,'/',['gen/Rotor/Matrix',13,'Gain2']])
set_param([sys,'/',['gen/Rotor/Matrix',13,'Gain2']],...
		'A','[]',...
		'B','[]',...
		'C','[]',...
		'D','K',...
		'Mask Display','K',...
		'Mask Type','Matrix Gain',...
		'Mask Dialogue','Matrix Gain.|Gain matrix:')
set_param([sys,'/',['gen/Rotor/Matrix',13,'Gain2']],...
		'Mask Translate','K = @1;',...
		'Mask Help','Multiplies input vector by entered matrix to produce output vector (y=Au).',...
		'Mask Entries','tmechv\/',...
		'position',[115,76,140,104])

add_block('built-in/Sum',[sys,'/','gen/Rotor/Tacc'])
set_param([sys,'/','gen/Rotor/Tacc'],...
		'inputs','-++',...
		'position',[210,232,225,288])

add_block('built-in/Sum',[sys,'/','gen/Rotor/Sum12'])
set_param([sys,'/','gen/Rotor/Sum12'],...
		'inputs','-+',...
		'position',[130,231,150,329])

add_block('built-in/Product',[sys,'/','gen/Rotor/Prod2'])
set_param([sys,'/','gen/Rotor/Prod2'],...
		'position',[100,295,115,315])

add_block('built-in/Product',[sys,'/','gen/Rotor/Prod'])
set_param([sys,'/','gen/Rotor/Prod'],...
		'position',[100,244,115,266])

add_block('built-in/Inport',[sys,'/','gen/Rotor/Tmech'])
set_param([sys,'/','gen/Rotor/Tmech'],...
		'Port','5',...
		'position',[50,160,70,180])

add_block('built-in/Outport',[sys,'/','gen/Rotor/Tem'])
set_param([sys,'/','gen/Rotor/Tem'],...
		'Port','3',...
		'position',[235,323,260,347])

add_block('built-in/Inport',[sys,'/','gen/Rotor/-iqr'])
set_param([sys,'/','gen/Rotor/-iqr'],...
		'Port','3',...
		'position',[50,200,70,220])

add_block('built-in/Inport',[sys,'/','gen/Rotor/psiq'])
set_param([sys,'/','gen/Rotor/psiq'],...
		'position',[50,290,70,310])

add_block('built-in/Inport',[sys,'/','gen/Rotor/-idr'])
set_param([sys,'/','gen/Rotor/-idr'],...
		'Port','4',...
		'position',[50,340,70,360])

add_block('built-in/Inport',[sys,'/','gen/Rotor/psid '])
set_param([sys,'/','gen/Rotor/psid '],...
		'Port','2',...
		'position',[50,250,70,270])

add_block('built-in/Gain',[sys,'/','gen/Rotor/1//2H_mode0'])
set_param([sys,'/','gen/Rotor/1//2H_mode0'],...
		'Gain','1/(2*H_m(1,1))',...
		'position',[245,238,365,282])

add_block('built-in/Gain',[sys,'/','gen/Rotor/Damping'])
set_param([sys,'/','gen/Rotor/Damping'],...
		'orientation',2,...
		'Gain','Domega',...
		'position',[230,187,310,213])

add_block('built-in/Integrator',[sys,'/','gen/Rotor/slip'])
set_param([sys,'/','gen/Rotor/slip'],...
		'position',[390,245,420,275])

add_block('built-in/State-Space',[sys,'/',['gen/Rotor/Matrix',13,'Gain3']])
set_param([sys,'/',['gen/Rotor/Matrix',13,'Gain3']],...
		'A','[]',...
		'B','[]',...
		'C','[]',...
		'D','K',...
		'Mask Display','K',...
		'Mask Type','Matrix Gain',...
		'Mask Dialogue','Matrix Gain.|Gain matrix:')
set_param([sys,'/',['gen/Rotor/Matrix',13,'Gain3']],...
		'Mask Translate','K = @1;',...
		'Mask Help','Multiplies input vector by entered matrix to produce output vector (y=Au).',...
		'Mask Entries','temmask\/')
set_param([sys,'/',['gen/Rotor/Matrix',13,'Gain3']],...
		'position',[175,106,200,134])

add_block('built-in/Sum',[sys,'/','gen/Rotor/Sum2'])
set_param([sys,'/','gen/Rotor/Sum2'],...
		'position',[230,76,250,134])

add_block('built-in/Integrator',[sys,'/',['gen/Rotor/modal',13,'angles']])
set_param([sys,'/',['gen/Rotor/modal',13,'angles']],...
		'Initial','thetam2to6o',...
		'position',[480,87,510,123])

add_block('built-in/State-Space',[sys,'/',['gen/Rotor/Modal',13,'speed']])
set_param([sys,'/',['gen/Rotor/Modal',13,'speed']],...
		'A','[]',...
		'B','[]',...
		'C','[]',...
		'D','K',...
		'Mask Display','K',...
		'Mask Type','Matrix Gain',...
		'Mask Dialogue','Matrix Gain.|Gain matrix:')
set_param([sys,'/',['gen/Rotor/Modal',13,'speed']],...
		'Mask Translate','K = @1;',...
		'Mask Help','Multiplies input vector by entered matrix to produce output vector (y=Au).',...
		'Mask Entries','omegam2to6\/')
set_param([sys,'/',['gen/Rotor/Modal',13,'speed']],...
		'position',[510,31,535,59])

add_block('built-in/Gain',[sys,'/','gen/Rotor/Gain5'])
set_param([sys,'/','gen/Rotor/Gain5'],...
		'orientation',2,...
		'Gain','wmi_xi_2',...
		'position',[325,25,425,65])

add_block('built-in/Gain',[sys,'/','gen/Rotor/Gain6'])
set_param([sys,'/','gen/Rotor/Gain6'],...
		'orientation',2,...
		'Gain','wmi_wmi',...
		'position',[345,140,445,180])

add_block('built-in/Sum',[sys,'/','gen/Rotor/Sum'])
set_param([sys,'/','gen/Rotor/Sum'],...
		'inputs','-+-',...
		'position',[345,78,360,132])

add_block('built-in/State-Space',[sys,'/',['gen/Rotor/Matrix',13,'Gain']])
set_param([sys,'/',['gen/Rotor/Matrix',13,'Gain']],...
		'A','[]',...
		'B','[]',...
		'C','[]',...
		'D','K',...
		'Mask Display','K',...
		'Mask Type','Matrix Gain',...
		'Mask Dialogue','Matrix Gain.|Gain matrix:')
set_param([sys,'/',['gen/Rotor/Matrix',13,'Gain']],...
		'Mask Translate','K = @1;',...
		'Mask Help','Multiplies input vector by entered matrix to produce output vector (y=Au).',...
		'Mask Entries','tdisk2m\/',...
		'position',[265,90,295,120])

add_block('built-in/Integrator',[sys,'/','gen/Rotor/modal_speed'])
set_param([sys,'/','gen/Rotor/modal_speed'],...
		'Initial','[0; 0 ; 0 ;0 ;0 ]',...
		'position',[395,84,425,126])

add_block('built-in/Outport',[sys,'/','gen/Rotor/wr//wb '])
set_param([sys,'/','gen/Rotor/wr//wb '],...
		'Port','2',...
		'position',[765,85,785,105])

add_block('built-in/Outport',[sys,'/','gen/Rotor/(wr-we)//wb'])
set_param([sys,'/','gen/Rotor/(wr-we)//wb'],...
		'Port','4',...
		'position',[760,45,780,65])

add_block('built-in/Sum',[sys,'/','gen/Rotor/Sum14'])
set_param([sys,'/','gen/Rotor/Sum14'],...
		'position',[710,76,725,109])

add_block('built-in/Constant',[sys,'/','gen/Rotor/we//wb'])
set_param([sys,'/','gen/Rotor/we//wb'],...
		'position',[645,88,675,112])

add_block('built-in/Sum',[sys,'/','gen/Rotor/Sum1'])
set_param([sys,'/','gen/Rotor/Sum1'],...
		'position',[665,37,680,68])

add_block('built-in/Mux',[sys,'/',['gen/Rotor/Modal',13,'angle']])
set_param([sys,'/',['gen/Rotor/Modal',13,'angle']],...
		'inputs','2',...
		'position',[595,191,620,224])

add_block('built-in/Gain',[sys,'/','gen/Rotor/gain4'])
set_param([sys,'/','gen/Rotor/gain4'],...
		'Gain','wb',...
		'position',[470,184,505,216])

add_block('built-in/Integrator',[sys,'/','gen/Rotor/delta_mode0'])
set_param([sys,'/','gen/Rotor/delta_mode0'],...
		'Initial','delio',...
		'position',[525,183,555,217])

add_block('built-in/Sum',[sys,'/','gen/Rotor/Sum4'])
set_param([sys,'/','gen/Rotor/Sum4'],...
		'inputs','+-',...
		'position',[785,155,800,190])

add_block('built-in/Sum',[sys,'/','gen/Rotor/Sum3'])
set_param([sys,'/','gen/Rotor/Sum3'],...
		'inputs','+-',...
		'position',[780,260,795,295])

add_block('built-in/Outport',[sys,'/','gen/Rotor/delta_gen'])
set_param([sys,'/','gen/Rotor/delta_gen'],...
		'position',[815,215,835,235])

add_block('built-in/Gain',[sys,'/','gen/Rotor/Gain'])
set_param([sys,'/','gen/Rotor/Gain'],...
		'Gain','k(2)',...
		'position',[815,157,850,193])

add_block('built-in/Gain',[sys,'/','gen/Rotor/Gain1'])
set_param([sys,'/','gen/Rotor/Gain1'],...
		'Gain','k(5)',...
		'position',[810,263,850,297])

add_block('built-in/Outport',[sys,'/',['gen/Rotor/LPA-LPB',13,'Shaft_torque']])
set_param([sys,'/',['gen/Rotor/LPA-LPB',13,'Shaft_torque']],...
		'Port','5',...
		'position',[880,165,900,185])

add_block('built-in/State-Space',[sys,'/','gen/Rotor/Qbar'])
set_param([sys,'/','gen/Rotor/Qbar'],...
		'A','[]',...
		'B','[]',...
		'C','[]',...
		'D','K',...
		'Mask Display','K',...
		'Mask Type','Matrix Gain',...
		'Mask Dialogue','Matrix Gain.|Gain matrix:',...
		'Mask Translate','K = @1;')
set_param([sys,'/','gen/Rotor/Qbar'],...
		'Mask Help','Multiplies input vector by entered matrix to produce output vector (y=Au).',...
		'Mask Entries','Qbar\/',...
		'position',[645,196,670,224])

add_block('built-in/Demux',[sys,'/',['gen/Rotor/Mass',13,'angle']])
set_param([sys,'/',['gen/Rotor/Mass',13,'angle']],...
		'outputs','6',...
		'position',[685,175,730,245])

add_block('built-in/Outport',[sys,'/',['gen/Rotor/Gen-Exc',13,'Shaft_torque']])
set_param([sys,'/',['gen/Rotor/Gen-Exc',13,'Shaft_torque']],...
		'Port','6',...
		'position',[875,270,895,290])

add_block('built-in/Note',[sys,'/',['gen/Rotor/Tem negative',13,' for generating  ']])
set_param([sys,'/',['gen/Rotor/Tem negative',13,' for generating  ']],...
		'position',[320,325,325,330])
add_line([sys,'/','gen/Rotor'],[225,200;190,200;190,240;205,240])
add_line([sys,'/','gen/Rotor'],[155,280;205,280])
add_line([sys,'/','gen/Rotor'],[510,200;520,200])
add_line([sys,'/','gen/Rotor'],[120,305;125,305])
add_line([sys,'/','gen/Rotor'],[370,260;385,260])
add_line([sys,'/','gen/Rotor'],[680,100;705,100])
add_line([sys,'/','gen/Rotor'],[230,260;240,260])
add_line([sys,'/','gen/Rotor'],[120,255;125,255])
add_line([sys,'/','gen/Rotor'],[75,210;80,210;80,250;95,250])
add_line([sys,'/','gen/Rotor'],[75,260;95,260])
add_line([sys,'/','gen/Rotor'],[75,300;95,300])
add_line([sys,'/','gen/Rotor'],[75,350;80,350;80,310;95,310])
add_line([sys,'/','gen/Rotor'],[730,95;760,95])
add_line([sys,'/','gen/Rotor'],[155,280;165,280;165,335;230,335])
add_line([sys,'/','gen/Rotor'],[425,260;445,260;445,200;315,200])
add_line([sys,'/','gen/Rotor'],[75,170;175,170;175,260;205,260])
add_line([sys,'/','gen/Rotor'],[430,105;455,105;455,45;430,45])
add_line([sys,'/','gen/Rotor'],[320,45;310,45;310,85;340,85])
add_line([sys,'/','gen/Rotor'],[300,105;340,105])
add_line([sys,'/','gen/Rotor'],[255,105;260,105])
add_line([sys,'/','gen/Rotor'],[155,280;165,280;165,210;140,210;140,120;170,120])
add_line([sys,'/','gen/Rotor'],[205,120;225,120])
add_line([sys,'/','gen/Rotor'],[145,90;225,90])
add_line([sys,'/','gen/Rotor'],[75,170;85,170;85,90;110,90])
add_line([sys,'/','gen/Rotor'],[365,105;390,105])
add_line([sys,'/','gen/Rotor'],[455,105;475,105])
add_line([sys,'/','gen/Rotor'],[515,105;530,105;530,160;450,160])
add_line([sys,'/','gen/Rotor'],[340,160;320,160;320,125;340,125])
add_line([sys,'/','gen/Rotor'],[685,55;690,55;690,85;705,85])
add_line([sys,'/','gen/Rotor'],[430,105;455,105;455,45;505,45])
add_line([sys,'/','gen/Rotor'],[685,55;755,55])
add_line([sys,'/','gen/Rotor'],[425,260;445,260;445,200;465,200])
add_line([sys,'/','gen/Rotor'],[540,45;660,45])
add_line([sys,'/','gen/Rotor'],[445,260;630,260;630,60;660,60])
add_line([sys,'/','gen/Rotor'],[515,105;565,105;565,215;590,215])
add_line([sys,'/','gen/Rotor'],[560,200;590,200])
add_line([sys,'/','gen/Rotor'],[625,210;640,210])
add_line([sys,'/','gen/Rotor'],[675,210;680,210])
add_line([sys,'/','gen/Rotor'],[735,225;810,225])
add_line([sys,'/','gen/Rotor'],[735,205;760,205;760,165;780,165])
add_line([sys,'/','gen/Rotor'],[735,215;765,215;765,180;780,180])
add_line([sys,'/','gen/Rotor'],[735,225;765,225;775,270])
add_line([sys,'/','gen/Rotor'],[735,235;755,235;755,285;775,285])
add_line([sys,'/','gen/Rotor'],[805,175;810,175])
add_line([sys,'/','gen/Rotor'],[800,280;805,280])
add_line([sys,'/','gen/Rotor'],[855,175;875,175])
add_line([sys,'/','gen/Rotor'],[855,280;870,280])


%     Finished composite block 'gen/Rotor'.

set_param([sys,'/','gen/Rotor'],...
		'Font Number',3,...
		'position',[495,183,540,322])

add_block('built-in/Outport',[sys,'/','gen/out_delta_gen'])
set_param([sys,'/','gen/out_delta_gen'],...
		'Port','5',...
		'position',[630,180,650,200])

add_block('built-in/Outport',[sys,'/','gen/out_(wr-we)//wb'])
set_param([sys,'/','gen/out_(wr-we)//wb'],...
		'Port','7',...
		'position',[695,255,715,275])

add_block('built-in/Outport',[sys,'/','gen/out_LPA-LPB'])
set_param([sys,'/','gen/out_LPA-LPB'],...
		'Port','10',...
		'position',[625,280,645,300])

add_block('built-in/Outport',[sys,'/','gen/out_Tem'])
set_param([sys,'/','gen/out_Tem'],...
		'Port','6',...
		'position',[625,230,645,250])

add_block('built-in/Outport',[sys,'/','gen/out_Gen-Exc'])
set_param([sys,'/','gen/out_Gen-Exc'],...
		'Port','11',...
		'position',[695,305,715,325])
add_line([sys,'/','gen'],[305,205;365,205;365,155;325,155])
add_line([sys,'/','gen'],[305,305;355,305;355,125;290,125])
add_line([sys,'/','gen'],[545,215;560,215;560,140;290,140])
add_line([sys,'/','gen'],[545,215;560,215;560,170;325,170])
add_line([sys,'/','gen'],[305,325;380,325;380,280;490,280])
add_line([sys,'/','gen'],[305,305;430,305;430,230;490,230])
add_line([sys,'/','gen'],[300,165;230,165;230,335;255,335])
add_line([sys,'/','gen'],[545,190;625,190])
add_line([sys,'/','gen'],[545,240;620,240])
add_line([sys,'/','gen'],[215,360;255,360])
add_line([sys,'/','gen'],[545,265;690,265])
add_line([sys,'/','gen'],[475,305;490,305])
add_line([sys,'/','gen'],[180,285;220,285;220,310;255,310])
add_line([sys,'/','gen'],[305,230;405,230;405,65;485,65])
add_line([sys,'/','gen'],[305,325;380,325;380,115;485,115])
add_line([sys,'/','gen'],[180,250;205,250;205,40;485,40])
add_line([sys,'/','gen'],[180,285;220,285;220,90;485,90])
add_line([sys,'/','gen'],[55,240;130,240])
add_line([sys,'/','gen'],[105,265;130,265])
add_line([sys,'/','gen'],[545,190;590,190;590,445;405,445;405,410;445,410])
add_line([sys,'/','gen'],[545,190;590,190;590,445;115,445;115,290;130,290])
add_line([sys,'/','gen'],[305,230;405,230;405,380;445,380])
add_line([sys,'/','gen'],[305,325;380,325;380,395;445,395])
add_line([sys,'/','gen'],[305,205;490,205])
add_line([sys,'/','gen'],[305,230;405,230;405,255;490,255])
add_line([sys,'/','gen'],[495,385;520,385])
add_line([sys,'/','gen'],[495,410;620,410])
add_line([sys,'/','gen'],[530,40;575,40])
add_line([sys,'/','gen'],[530,90;575,90])
add_line([sys,'/','gen'],[530,115;635,115])
add_line([sys,'/','gen'],[530,65;635,65])
add_line([sys,'/','gen'],[180,250;205,250;205,215;255,215])
add_line([sys,'/','gen'],[265,135;240,135;240,250;255,250])
add_line([sys,'/','gen'],[545,290;620,290])
add_line([sys,'/','gen'],[545,315;690,315])


%     Finished composite block 'gen'.

set_param([sys,'/','gen'],...
		'position',[145,46,215,234])

add_block('built-in/Constant',[sys,'/','Tmech'])
set_param([sys,'/','Tmech'],...
		'Value','Tmech',...
		'position',[45,200,100,220])


%     Subsystem  'Vq4'.

new_system([sys,'/','Vq4'])
set_param([sys,'/','Vq4'],'Location',[5,40,315,196])

add_block('built-in/Outport',[sys,'/','Vq4/out_1'])
set_param([sys,'/','Vq4/out_1'],...
		'position',[285,60,305,80])

add_block('built-in/Look Up Table',[sys,'/','Vq4/Look-Up Table'])
set_param([sys,'/','Vq4/Look-Up Table'],...
		'Input_Values','t',...
		'Output_Values','y',...
		'position',[210,58,250,82])

add_block('built-in/Fcn',[sys,'/','Vq4/Fcn1'])
set_param([sys,'/','Vq4/Fcn1'],...
		'Expr','rem(u[1],period)',...
		'position',[110,60,150,80])

add_block('built-in/Clock',[sys,'/','Vq4/Clock'])
set_param([sys,'/','Vq4/Clock'],...
		'position',[45,60,65,80])
add_line([sys,'/','Vq4'],[255,70;280,70])
add_line([sys,'/','Vq4'],[70,70;105,70])
add_line([sys,'/','Vq4'],[155,70;205,70])
set_param([sys,'/','Vq4'],...
		'Mask Display','plot([t,t+period,t+2*period],[y,y,y])',...
		'Mask Type','Repeating table',...
		'Mask Dialogue','Repeating table.\nEnter values of time and output for first cycle.|Time values:|Output values:')
set_param([sys,'/','Vq4'],...
		'Mask Translate','period = max(@1); t = @1; y = @2;',...
		'Mask Help','Repeats cycle given in table. Time values should be monotonically increasing.')
set_param([sys,'/','Vq4'],...
		'Mask Entries','[0 0.2 0.2 0.275 0.275 0.7 ]\/[1. 1. 0.5 0.5 1. 1.]*Vq4\/')


%     Finished composite block 'Vq4'.

set_param([sys,'/','Vq4'],...
		'position',[615,145,650,185])

add_block('built-in/Constant',[sys,'/','Vd4'])
set_param([sys,'/','Vd4'],...
		'Value','Vd4',...
		'position',[640,259,675,281])

add_block('built-in/Sum',[sys,'/','Sum4'])
set_param([sys,'/','Sum4'],...
		'position',[715,180,730,215])

add_block('built-in/Sum',[sys,'/','Sum5'])
set_param([sys,'/','Sum5'],...
		'position',[710,242,725,273])


%     Subsystem  'Cap'.

new_system([sys,'/','Cap'])
set_param([sys,'/','Cap'],'Location',[145,152,806,492])

add_block('built-in/Mux',[sys,'/','Cap/Mux'])
set_param([sys,'/','Cap/Mux'],...
		'position',[110,60,130,260])

add_block('built-in/Integrator',[sys,'/','Cap/vq'])
set_param([sys,'/','Cap/vq'],...
		'Initial','VqCs',...
		'position',[500,92,525,118])

add_block('built-in/Fcn',[sys,'/','Cap/Fcn'])
set_param([sys,'/','Cap/Fcn'],...
		'Expr','-wb*xc(1)*u[2] - wb*u[4] ',...
		'position',[190,88,470,122])

add_block('built-in/Outport',[sys,'/','Cap/out_vqa2b'])
set_param([sys,'/','Cap/out_vqa2b'],...
		'position',[595,95,615,115])

add_block('built-in/Integrator',[sys,'/','Cap/vd'])
set_param([sys,'/','Cap/vd'],...
		'Initial','VdCs',...
		'position',[500,192,525,218])

add_block('built-in/Outport',[sys,'/','Cap/out_vda2b'])
set_param([sys,'/','Cap/out_vda2b'],...
		'Port','2',...
		'position',[595,195,615,215])

add_block('built-in/Inport',[sys,'/','Cap/in_iqa2b'])
set_param([sys,'/','Cap/in_iqa2b'],...
		'position',[15,125,35,145])

add_block('built-in/Inport',[sys,'/','Cap/in_ida2b'])
set_param([sys,'/','Cap/in_ida2b'],...
		'Port','2',...
		'position',[50,175,70,195])

add_block('built-in/Fcn',[sys,'/','Cap/Fcn1'])
set_param([sys,'/','Cap/Fcn1'],...
		'Expr','-wb*xc(1)*u[3] + wb*u[1] ',...
		'position',[190,188,470,222])
add_line([sys,'/','Cap'],[135,160;160,160;160,205;185,205])
add_line([sys,'/','Cap'],[475,205;495,205])
add_line([sys,'/','Cap'],[530,105;565,105;565,40;90,40;90,85;105,85])
add_line([sys,'/','Cap'],[475,105;495,105])
add_line([sys,'/','Cap'],[135,160;160,160;160,105;185,105])
add_line([sys,'/','Cap'],[530,105;590,105])
add_line([sys,'/','Cap'],[40,135;105,135])
add_line([sys,'/','Cap'],[75,185;105,185])
add_line([sys,'/','Cap'],[530,205;590,205])
add_line([sys,'/','Cap'],[530,205;560,205;560,285;90,285;90,235;105,235])


%     Finished composite block 'Cap'.

set_param([sys,'/','Cap'],...
		'position',[560,183,600,272])

add_block('built-in/Constant',[sys,'/','Ef'])
set_param([sys,'/','Ef'],...
		'Value','Efo',...
		'position',[50,154,90,176])


%     Subsystem  'ShuntCap'.

new_system([sys,'/','ShuntCap'])
set_param([sys,'/','ShuntCap'],'Location',[145,152,806,492])

add_block('built-in/Mux',[sys,'/','ShuntCap/Mux'])
set_param([sys,'/','ShuntCap/Mux'],...
		'position',[110,60,130,260])

add_block('built-in/Integrator',[sys,'/','ShuntCap/vq'])
set_param([sys,'/','ShuntCap/vq'],...
		'Initial','Vq1',...
		'position',[500,92,525,118])

add_block('built-in/Fcn',[sys,'/','ShuntCap/Fcn'])
set_param([sys,'/','ShuntCap/Fcn'],...
		'Expr','-wb*xc(2)*u[2] - wb*u[4] ',...
		'position',[190,88,470,122])

add_block('built-in/Outport',[sys,'/','ShuntCap/out_vqa2b'])
set_param([sys,'/','ShuntCap/out_vqa2b'],...
		'position',[595,95,615,115])

add_block('built-in/Integrator',[sys,'/','ShuntCap/vd'])
set_param([sys,'/','ShuntCap/vd'],...
		'Initial','Vd1',...
		'position',[500,192,525,218])

add_block('built-in/Outport',[sys,'/','ShuntCap/out_vda2b'])
set_param([sys,'/','ShuntCap/out_vda2b'],...
		'Port','2',...
		'position',[595,195,615,215])

add_block('built-in/Inport',[sys,'/','ShuntCap/in_iqa2b'])
set_param([sys,'/','ShuntCap/in_iqa2b'],...
		'position',[15,125,35,145])

add_block('built-in/Inport',[sys,'/','ShuntCap/in_ida2b'])
set_param([sys,'/','ShuntCap/in_ida2b'],...
		'Port','2',...
		'position',[50,175,70,195])

add_block('built-in/Fcn',[sys,'/','ShuntCap/Fcn1'])
set_param([sys,'/','ShuntCap/Fcn1'],...
		'Expr','-wb*xc(2)*u[3] + wb*u[1] ',...
		'position',[190,188,470,222])
add_line([sys,'/','ShuntCap'],[135,160;160,160;160,205;185,205])
add_line([sys,'/','ShuntCap'],[475,205;495,205])
add_line([sys,'/','ShuntCap'],[530,105;565,105;565,40;90,40;90,85;105,85])
add_line([sys,'/','ShuntCap'],[475,105;495,105])
add_line([sys,'/','ShuntCap'],[135,160;160,160;160,105;185,105])
add_line([sys,'/','ShuntCap'],[530,105;590,105])
add_line([sys,'/','ShuntCap'],[40,135;105,135])
add_line([sys,'/','ShuntCap'],[75,185;105,185])
add_line([sys,'/','ShuntCap'],[530,205;590,205])
add_line([sys,'/','ShuntCap'],[530,205;560,205;560,285;90,285;90,235;105,235])


%     Finished composite block 'ShuntCap'.

set_param([sys,'/','ShuntCap'],...
		'position',[355,175,390,250])


%     Subsystem  'seriesRL'.

new_system([sys,'/','seriesRL'])
set_param([sys,'/','seriesRL'],'Location',[191,509,852,849])

add_block('built-in/Mux',[sys,'/','seriesRL/Mux'])
set_param([sys,'/','seriesRL/Mux'],...
		'inputs','6',...
		'position',[110,58,130,257])

add_block('built-in/Inport',[sys,'/','seriesRL/in_vqa'])
set_param([sys,'/','seriesRL/in_vqa'],...
		'position',[15,95,35,115])

add_block('built-in/Inport',[sys,'/','seriesRL/in_vqb'])
set_param([sys,'/','seriesRL/in_vqb'],...
		'Port','3',...
		'position',[15,165,35,185])

add_block('built-in/Inport',[sys,'/','seriesRL/in_vda'])
set_param([sys,'/','seriesRL/in_vda'],...
		'Port','2',...
		'position',[50,130,70,150])

add_block('built-in/Inport',[sys,'/','seriesRL/in_vdb'])
set_param([sys,'/','seriesRL/in_vdb'],...
		'Port','4',...
		'position',[45,200,65,220])

add_block('built-in/Integrator',[sys,'/','seriesRL/iq'])
set_param([sys,'/','seriesRL/iq'],...
		'Initial','Iq',...
		'position',[500,92,525,118])

add_block('built-in/Fcn',[sys,'/','seriesRL/Fcn'])
set_param([sys,'/','seriesRL/Fcn'],...
		'Expr','(wb/xl(1))*(u[2]-u[4] - r(1)*u[1] -xl(1)*u[6])',...
		'position',[190,88,470,122])

add_block('built-in/Outport',[sys,'/','seriesRL/out_iqa2b'])
set_param([sys,'/','seriesRL/out_iqa2b'],...
		'position',[595,95,615,115])

add_block('built-in/Integrator',[sys,'/','seriesRL/id'])
set_param([sys,'/','seriesRL/id'],...
		'Initial','Id',...
		'position',[500,192,525,218])

add_block('built-in/Outport',[sys,'/','seriesRL/out_ida2b'])
set_param([sys,'/','seriesRL/out_ida2b'],...
		'Port','2',...
		'position',[595,195,615,215])

add_block('built-in/Fcn',[sys,'/','seriesRL/Fcn1'])
set_param([sys,'/','seriesRL/Fcn1'],...
		'Expr','(wb/xl(1))*(u[3]-u[5] - r(1)*u[6] + xl(1)*u[1])',...
		'position',[190,188,470,222])
add_line([sys,'/','seriesRL'],[530,205;560,205;560,275;90,275;90,245;105,245])
add_line([sys,'/','seriesRL'],[135,160;160,160;160,205;185,205])
add_line([sys,'/','seriesRL'],[475,205;495,205])
add_line([sys,'/','seriesRL'],[530,105;565,105;565,40;90,40;90,70;105,70])
add_line([sys,'/','seriesRL'],[475,105;495,105])
add_line([sys,'/','seriesRL'],[135,160;160,160;160,105;185,105])
add_line([sys,'/','seriesRL'],[530,105;590,105])
add_line([sys,'/','seriesRL'],[40,105;105,105])
add_line([sys,'/','seriesRL'],[75,140;105,140])
add_line([sys,'/','seriesRL'],[40,175;105,175])
add_line([sys,'/','seriesRL'],[70,210;105,210])
add_line([sys,'/','seriesRL'],[530,205;590,205])


%     Finished composite block 'seriesRL'.

set_param([sys,'/','seriesRL'],...
		'position',[480,181,520,269])

add_block('built-in/Sum',[sys,'/','Sum3'])
set_param([sys,'/','Sum3'],...
		'inputs','+-',...
		'position',[315,211,330,244])

add_block('built-in/Sum',[sys,'/','Sum2'])
set_param([sys,'/','Sum2'],...
		'inputs','-+',...
		'position',[285,176,300,209])


%     Subsystem  'm3'.

new_system([sys,'/','m3'])
set_param([sys,'/','m3'],'Location',[600,5177521,792,5177620])

add_block('built-in/Note',[sys,'/',['m3/Masked block of m3.m to initalize',13,'s3.m  in Chapter 10 and plot results ']])
set_param([sys,'/',['m3/Masked block of m3.m to initalize',13,'s3.m  in Chapter 10 and plot results ']],...
		'position',[130,60,135,65])
set_param([sys,'/','m3'],...
		'Mask Display','Initialize\nand plot',...
		'Mask Type','Masked block of m3.m',...
		'Mask Dialogue','eval(''m3'')',...
		'Mask Help','Uses m3.m to initialize and plot')


%     Finished composite block 'm3'.

set_param([sys,'/','m3'],...
		'Drop Shadow',4,...
		'position',[671,62,744,99])
add_line(sys,[525,205;555,205])
add_line(sys,[525,250;555,250])
add_line(sys,[335,230;350,230])
add_line(sys,[305,195;350,195])
add_line(sys,[395,195;475,195])
add_line(sys,[395,230;435,230;435,215;475,215])
add_line(sys,[525,205;540,205;540,170;265,170;265,185;280,185])
add_line(sys,[525,250;540,250;540,290;295,290;295,235;310,235])
add_line(sys,[395,195;400,195;400,35;125,35;125,75;140,75])
add_line(sys,[395,230;405,230;405,280;125,280;125,120;140,120])
add_line(sys,[95,165;140,165])
add_line(sys,[105,210;140,210])
add_line(sys,[735,200;770,200;770,295;450,295;450,235;475,235])
add_line(sys,[730,260;755,260;755,310;465,310;475,255])
add_line(sys,[220,170;255,170;255,200;280,200])
add_line(sys,[220,185;250,185;250,220;310,220])
add_line(sys,[605,205;710,205])
add_line(sys,[680,270;680,265;705,265])
add_line(sys,[605,250;705,250])
add_line(sys,[655,165;690,165;690,190;710,190])
add_line(sys,[220,170;255,170;255,95;440,85])
add_line(sys,[220,185;250,185;250,105;455,105;455,85])
add_line(sys,[605,205;660,205;660,135;470,135;470,85])
add_line(sys,[605,250;665,250;665,130;485,130;485,85])
add_line(sys,[220,140;500,140;500,85])
add_line(sys,[220,200;230,200;230,115;515,115;515,85])
add_line(sys,[220,215;240,215;240,125;530,125;530,85])

drawnow

% Return any arguments.
if (nargin | nargout)
	% Must use feval here to access system in memory
	if (nargin > 3)
		if (flag == 0)
			eval(['[ret,x0,str,ts,xts]=',sys,'(t,x,u,flag);'])
		else
			eval(['ret =', sys,'(t,x,u,flag);'])
		end
	else
		[ret,x0,str,ts,xts] = feval(sys);
	end
else
	drawnow % Flash up the model and execute load callback
end
