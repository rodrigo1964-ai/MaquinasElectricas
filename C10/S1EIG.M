function [ret,x0,str,ts,xts]=s1eig(t,x,u,flag);
%s1eig	is the M-file description of the SIMULINK system named s1eig.
%	The block-diagram can be displayed by typing: s1eig.
%
%	SYS=s1eig(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes s1eig to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling s1eig with a FLAG of zero:
%	[SIZES]=s1eig([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[100,100,600,400])
     open_system(sys)
end;
set_param(sys,'algorithm',     'RK-45')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     '999999')
set_param(sys,'Min step size', '0.0001')
set_param(sys,'Max step size', '10')
set_param(sys,'Relative error','1e-3')
set_param(sys,'Return vars',   '')

add_block('built-in/Outport',[sys,'/','out_delta'])
set_param([sys,'/','out_delta'],...
		'Port','5',...
		'position',[335,175,355,195])

add_block('built-in/Outport',[sys,'/','out_Pgen'])
set_param([sys,'/','out_Pgen'],...
		'Port','3',...
		'position',[335,125,355,145])

add_block('built-in/Inport',[sys,'/','in_Tmech'])
set_param([sys,'/','in_Tmech'],...
		'Port','4',...
		'position',[120,220,140,240])

add_block('built-in/Inport',[sys,'/',['in_Ef''']])
set_param([sys,'/',['in_Ef''']],...
		'position',[120,85,140,105])

add_block('built-in/Inport',[sys,'/','in_vqie'])
set_param([sys,'/','in_vqie'],...
		'Port','2',...
		'position',[120,130,140,150])

add_block('built-in/Inport',[sys,'/','in_vdie'])
set_param([sys,'/','in_vdie'],...
		'Port','3',...
		'position',[120,175,140,195])

add_block('built-in/Outport',[sys,'/','out_puslip'])
set_param([sys,'/','out_puslip'],...
		'Port','6',...
		'position',[405,200,425,220])

add_block('built-in/Outport',[sys,'/','out_Qgen'])
set_param([sys,'/','out_Qgen'],...
		'Port','4',...
		'position',[405,150,425,170])

add_block('built-in/Outport',[sys,'/','out_|igen|'])
set_param([sys,'/','out_|igen|'],...
		'Port','2',...
		'position',[400,100,420,120])

add_block('built-in/Outport',[sys,'/','out_|Vt|'])
set_param([sys,'/','out_|Vt|'],...
		'position',[335,75,355,95])


%     Subsystem  'tmodel'.

new_system([sys,'/','tmodel'])
set_param([sys,'/','tmodel'],'Location',[300,169,1114,700])

add_block('built-in/Gain',[sys,'/','tmodel/Gain2'])
set_param([sys,'/','tmodel/Gain2'],...
		'orientation',2,...
		'Gain','xd-xpd',...
		'position',[195,86,260,124])

add_block('built-in/Sum',[sys,'/','tmodel/sum'])
set_param([sys,'/','tmodel/sum'],...
		'inputs','-+-',...
		'position',[130,153,150,207])


%     Subsystem  'tmodel/qde2qdr'.

new_system([sys,'/','tmodel/qde2qdr'])
set_param([sys,'/','tmodel/qde2qdr'],'Location',[277,287,802,474])

add_block('built-in/Mux',[sys,'/','tmodel/qde2qdr/Mux'])
set_param([sys,'/','tmodel/qde2qdr/Mux'],...
		'hide name',0,...
		'inputs','3',...
		'position',[75,50,105,130])

add_block('built-in/Fcn',[sys,'/','tmodel/qde2qdr/fcn'])
set_param([sys,'/','tmodel/qde2qdr/fcn'],...
		'Expr','u[1]*cos(u[3]) - u[2]*sin(u[3])',...
		'position',[150,52,390,78])

add_block('built-in/Fcn',[sys,'/','tmodel/qde2qdr/fcn1'])
set_param([sys,'/','tmodel/qde2qdr/fcn1'],...
		'Expr','u[1]*sin(u[3]) + u[2]*cos(u[3])',...
		'position',[150,97,390,123])

add_block('built-in/Inport',[sys,'/','tmodel/qde2qdr/vde'])
set_param([sys,'/','tmodel/qde2qdr/vde'],...
		'Port','2',...
		'position',[15,80,35,100])

add_block('built-in/Inport',[sys,'/','tmodel/qde2qdr/delta '])
set_param([sys,'/','tmodel/qde2qdr/delta '],...
		'Port','3',...
		'position',[15,124,35,146])

add_block('built-in/Inport',[sys,'/','tmodel/qde2qdr/vqe'])
set_param([sys,'/','tmodel/qde2qdr/vqe'],...
		'position',[15,35,35,55])

add_block('built-in/Outport',[sys,'/','tmodel/qde2qdr/vdr'])
set_param([sys,'/','tmodel/qde2qdr/vdr'],...
		'Port','2',...
		'position',[445,100,465,120])

add_block('built-in/Outport',[sys,'/','tmodel/qde2qdr/vqr'])
set_param([sys,'/','tmodel/qde2qdr/vqr'],...
		'position',[445,55,465,75])
add_line([sys,'/','tmodel/qde2qdr'],[395,110;440,110])
add_line([sys,'/','tmodel/qde2qdr'],[40,45;50,45;50,65;70,65])
add_line([sys,'/','tmodel/qde2qdr'],[395,65;440,65])
add_line([sys,'/','tmodel/qde2qdr'],[110,90;125,90;125,65;145,65])
add_line([sys,'/','tmodel/qde2qdr'],[110,90;125,90;125,110;145,110])
add_line([sys,'/','tmodel/qde2qdr'],[40,135;50,135;50,115;70,115])
add_line([sys,'/','tmodel/qde2qdr'],[40,90;70,90])


%     Finished composite block 'tmodel/qde2qdr'.

set_param([sys,'/','tmodel/qde2qdr'],...
		'position',[170,265,210,325])

add_block('built-in/Note',[sys,'/','tmodel/vdir'])
set_param([sys,'/','tmodel/vdir'],...
		'position',[220,290,225,295])

add_block('built-in/Inport',[sys,'/',['tmodel/in_Ef''']])
set_param([sys,'/',['tmodel/in_Ef''']],...
		'position',[60,170,80,190])

add_block('built-in/Note',[sys,'/',['tmodel/Ef''']])
set_param([sys,'/',['tmodel/Ef''']],...
		'position',[110,160,115,165])

add_block('built-in/Integrator',[sys,'/','tmodel/Eqp'])
set_param([sys,'/','tmodel/Eqp'],...
		'Initial','Eqpo',...
		'position',[240,164,270,196])

add_block('built-in/Gain',[sys,'/','tmodel/1//Tpdo'])
set_param([sys,'/','tmodel/1//Tpdo'],...
		'Gain','1/Tpdo',...
		'position',[170,161,230,199])


%     Subsystem  'tmodel/stator_wdg'.

new_system([sys,'/','tmodel/stator_wdg'])
set_param([sys,'/','tmodel/stator_wdg'],'Location',[171,185,1084,470])

add_block('built-in/Inport',[sys,'/','tmodel/stator_wdg/vdir'])
set_param([sys,'/','tmodel/stator_wdg/vdir'],...
		'Port','4',...
		'position',[25,210,45,230])

add_block('built-in/Inport',[sys,'/','tmodel/stator_wdg/vqir'])
set_param([sys,'/','tmodel/stator_wdg/vqir'],...
		'Port','3',...
		'position',[25,168,45,192])

add_block('built-in/Inport',[sys,'/','tmodel/stator_wdg/Edp'])
set_param([sys,'/','tmodel/stator_wdg/Edp'],...
		'Port','2',...
		'position',[25,130,45,150])

add_block('built-in/Inport',[sys,'/','tmodel/stator_wdg/Eqp'])
set_param([sys,'/','tmodel/stator_wdg/Eqp'],...
		'position',[25,90,45,110])

add_block('built-in/Mux',[sys,'/','tmodel/stator_wdg/Mux'])
set_param([sys,'/','tmodel/stator_wdg/Mux'],...
		'position',[85,84,110,236])

add_block('built-in/Fcn',[sys,'/','tmodel/stator_wdg/Fcn1'])
set_param([sys,'/','tmodel/stator_wdg/Fcn1'],...
		'Expr','-((xq+xe)*(u[3]-u[1]) + (rs+re)*(u[4]-u[2]))/Dz',...
		'position',[135,180,395,210])

add_block('built-in/Fcn',[sys,'/','tmodel/stator_wdg/Fcn'])
set_param([sys,'/','tmodel/stator_wdg/Fcn'],...
		'Expr','-((rs+re)*(u[3]-u[1]) - (xpd+xe)*(u[4]-u[2]))/Dz',...
		'position',[135,110,395,140])

add_block('built-in/Mux',[sys,'/','tmodel/stator_wdg/Mux1'])
set_param([sys,'/','tmodel/stator_wdg/Mux1'],...
		'position',[485,74,505,196])

add_block('built-in/Outport',[sys,'/','tmodel/stator_wdg/out_id'])
set_param([sys,'/','tmodel/stator_wdg/out_id'],...
		'Port','4',...
		'position',[430,185,450,205])

add_block('built-in/Fcn',[sys,'/','tmodel/stator_wdg/Fcn3'])
set_param([sys,'/','tmodel/stator_wdg/Fcn3'],...
		'Expr','u[2] + xq*u[3] - rs*u[4]',...
		'position',[540,156,680,184])

add_block('built-in/Outport',[sys,'/','tmodel/stator_wdg/out_vdt'])
set_param([sys,'/','tmodel/stator_wdg/out_vdt'],...
		'Port','2',...
		'position',[705,160,725,180])

add_block('built-in/Fcn',[sys,'/','tmodel/stator_wdg/Fcn2'])
set_param([sys,'/','tmodel/stator_wdg/Fcn2'],...
		'Expr','u[1] -rs*u[3]- xpd*u[4] ',...
		'position',[540,85,670,115])

add_block('built-in/Outport',[sys,'/','tmodel/stator_wdg/out_vqt'])
set_param([sys,'/','tmodel/stator_wdg/out_vqt'],...
		'position',[700,90,720,110])

add_block('built-in/Outport',[sys,'/','tmodel/stator_wdg/out_iq'])
set_param([sys,'/','tmodel/stator_wdg/out_iq'],...
		'Port','3',...
		'position',[425,115,445,135])
add_line([sys,'/','tmodel/stator_wdg'],[50,100;80,100])
add_line([sys,'/','tmodel/stator_wdg'],[115,160;115,125;130,125])
add_line([sys,'/','tmodel/stator_wdg'],[115,160;115,195;130,195])
add_line([sys,'/','tmodel/stator_wdg'],[400,125;420,125])
add_line([sys,'/','tmodel/stator_wdg'],[400,195;425,195])
add_line([sys,'/','tmodel/stator_wdg'],[510,135;515,135;515,100;535,100])
add_line([sys,'/','tmodel/stator_wdg'],[510,135;515,135;515,170;535,170])
add_line([sys,'/','tmodel/stator_wdg'],[675,100;695,100])
add_line([sys,'/','tmodel/stator_wdg'],[685,170;700,170])
add_line([sys,'/','tmodel/stator_wdg'],[50,180;80,180])
add_line([sys,'/','tmodel/stator_wdg'],[50,220;80,220])
add_line([sys,'/','tmodel/stator_wdg'],[50,140;80,140])
add_line([sys,'/','tmodel/stator_wdg'],[400,195;410,195;410,180;480,180])
add_line([sys,'/','tmodel/stator_wdg'],[400,125;410,125;410,150;480,150])
add_line([sys,'/','tmodel/stator_wdg'],[50,100;55,100;55,50;465,50;465,90;480,90])
add_line([sys,'/','tmodel/stator_wdg'],[50,140;65,140;65,75;455,75;455,120;480,120])


%     Finished composite block 'tmodel/stator_wdg'.

set_param([sys,'/','tmodel/stator_wdg'],...
		'position',[305,208,345,322])

add_block('built-in/Inport',[sys,'/','tmodel/in_vqie'])
set_param([sys,'/','tmodel/in_vqie'],...
		'Port','2',...
		'position',[60,230,80,250])

add_block('built-in/Inport',[sys,'/','tmodel/in_vdie'])
set_param([sys,'/','tmodel/in_vdie'],...
		'Port','3',...
		'position',[60,282,80,308])


%     Subsystem  'tmodel/VIPQ'.

new_system([sys,'/','tmodel/VIPQ'])
set_param([sys,'/','tmodel/VIPQ'],'Location',[351,304,1039,737])

add_block('built-in/Inport',[sys,'/','tmodel/VIPQ/vdt'])
set_param([sys,'/','tmodel/VIPQ/vdt'],...
		'Port','3',...
		'position',[45,245,65,265])

add_block('built-in/Inport',[sys,'/','tmodel/VIPQ/iq'])
set_param([sys,'/','tmodel/VIPQ/iq'],...
		'Port','2',...
		'position',[45,205,65,225])

add_block('built-in/Mux',[sys,'/','tmodel/VIPQ/Mux'])
set_param([sys,'/','tmodel/VIPQ/Mux'],...
		'position',[135,172,160,298])

add_block('built-in/Inport',[sys,'/','tmodel/VIPQ/id'])
set_param([sys,'/','tmodel/VIPQ/id'],...
		'Port','4',...
		'position',[45,290,65,310])

add_block('built-in/Inport',[sys,'/','tmodel/VIPQ/vqt'])
set_param([sys,'/','tmodel/VIPQ/vqt'],...
		'position',[45,160,65,180])

add_block('built-in/Fcn',[sys,'/','tmodel/VIPQ/Fcn'])
set_param([sys,'/','tmodel/VIPQ/Fcn'],...
		'Expr','u[1]*u[2] + u[3]*u[4]',...
		'position',[230,247,385,273])

add_block('built-in/Fcn',[sys,'/','tmodel/VIPQ/Fcn1'])
set_param([sys,'/','tmodel/VIPQ/Fcn1'],...
		'Expr','u[1]*u[4] - u[2]*u[3]',...
		'position',[230,297,385,323])

add_block('built-in/Fcn',[sys,'/','tmodel/VIPQ/Fcn2'])
set_param([sys,'/','tmodel/VIPQ/Fcn2'],...
		'Expr','sqrt(u[2]*u[2] + u[4]*u[4])',...
		'position',[230,200,390,230])

add_block('built-in/Outport',[sys,'/','tmodel/VIPQ/out_P'])
set_param([sys,'/','tmodel/VIPQ/out_P'],...
		'Port','3',...
		'position',[450,250,470,270])

add_block('built-in/Outport',[sys,'/','tmodel/VIPQ/out_Q'])
set_param([sys,'/','tmodel/VIPQ/out_Q'],...
		'Port','4',...
		'position',[450,300,470,320])

add_block('built-in/Fcn',[sys,'/','tmodel/VIPQ/Fcn3'])
set_param([sys,'/','tmodel/VIPQ/Fcn3'],...
		'Expr','sqrt(u[1]*u[1] + u[3]*u[3])',...
		'position',[230,151,390,179])

add_block('built-in/Outport',[sys,'/','tmodel/VIPQ/out_|I|'])
set_param([sys,'/','tmodel/VIPQ/out_|I|'],...
		'Port','2',...
		'position',[450,205,470,225])

add_block('built-in/Outport',[sys,'/','tmodel/VIPQ/out_|Vt|'])
set_param([sys,'/','tmodel/VIPQ/out_|Vt|'],...
		'position',[450,155,470,175])
add_line([sys,'/','tmodel/VIPQ'],[70,170;95,170;95,190;130,190])
add_line([sys,'/','tmodel/VIPQ'],[70,215;95,215;95,220;130,220])
add_line([sys,'/','tmodel/VIPQ'],[70,255;95,255;95,250;130,250])
add_line([sys,'/','tmodel/VIPQ'],[70,300;95,300;95,280;130,280])
add_line([sys,'/','tmodel/VIPQ'],[390,260;445,260])
add_line([sys,'/','tmodel/VIPQ'],[390,310;445,310])
add_line([sys,'/','tmodel/VIPQ'],[165,235;190,235;190,260;225,260])
add_line([sys,'/','tmodel/VIPQ'],[165,235;190,235;190,310;225,310])
add_line([sys,'/','tmodel/VIPQ'],[395,165;445,165])
add_line([sys,'/','tmodel/VIPQ'],[395,215;445,215])
add_line([sys,'/','tmodel/VIPQ'],[165,235;190,235;190,165;225,165])
add_line([sys,'/','tmodel/VIPQ'],[165,235;190,235;190,215;225,215])


%     Finished composite block 'tmodel/VIPQ'.

set_param([sys,'/','tmodel/VIPQ'],...
		'position',[485,126,525,219])

add_block('built-in/Outport',[sys,'/','tmodel/out_|Vt|'])
set_param([sys,'/','tmodel/out_|Vt|'],...
		'position',[740,125,760,145])

add_block('built-in/Outport',[sys,'/','tmodel/out_|I|'])
set_param([sys,'/','tmodel/out_|I|'],...
		'Port','2',...
		'position',[670,150,690,170])

add_block('built-in/Outport',[sys,'/','tmodel/out_Pgen'])
set_param([sys,'/','tmodel/out_Pgen'],...
		'Port','3',...
		'position',[740,175,760,195])

add_block('built-in/Outport',[sys,'/','tmodel/out_Qgen'])
set_param([sys,'/','tmodel/out_Qgen'],...
		'Port','4',...
		'position',[670,200,690,220])


%     Subsystem  'tmodel/Rotor'.

new_system([sys,'/','tmodel/Rotor'])
set_param([sys,'/','tmodel/Rotor'],'Location',[217,296,1042,512])

add_block('built-in/Outport',[sys,'/','tmodel/Rotor/Tem'])
set_param([sys,'/','tmodel/Rotor/Tem'],...
		'Port','3',...
		'position',[420,137,445,163])

add_block('built-in/Mux',[sys,'/','tmodel/Rotor/Mux'])
set_param([sys,'/','tmodel/Rotor/Mux'],...
		'position',[80,15,105,175])

add_block('built-in/Inport',[sys,'/','tmodel/Rotor/Eqp'])
set_param([sys,'/','tmodel/Rotor/Eqp'],...
		'position',[30,25,50,45])

add_block('built-in/Inport',[sys,'/','tmodel/Rotor/Edp'])
set_param([sys,'/','tmodel/Rotor/Edp'],...
		'Port','2',...
		'position',[30,64,50,86])

add_block('built-in/Inport',[sys,'/','tmodel/Rotor/iq'])
set_param([sys,'/','tmodel/Rotor/iq'],...
		'Port','3',...
		'position',[30,105,50,125])

add_block('built-in/Inport',[sys,'/','tmodel/Rotor/id'])
set_param([sys,'/','tmodel/Rotor/id'],...
		'Port','4',...
		'position',[30,144,50,166])

add_block('built-in/Fcn',[sys,'/','tmodel/Rotor/Fcn'])
set_param([sys,'/','tmodel/Rotor/Fcn'],...
		'Expr','-(u[1]*u[3]+u[2]*u[4]+u[3]*u[4]*(xq-xpd))',...
		'position',[125,80,350,110])

add_block('built-in/Inport',[sys,'/','tmodel/Rotor/T_mech'])
set_param([sys,'/','tmodel/Rotor/T_mech'],...
		'Port','5',...
		'position',[275,27,300,53])

add_block('built-in/Sum',[sys,'/','tmodel/Rotor/Tacc'])
set_param([sys,'/','tmodel/Rotor/Tacc'],...
		'inputs','++-',...
		'position',[395,28,415,92])

add_block('built-in/Gain',[sys,'/','tmodel/Rotor/gain2'])
set_param([sys,'/','tmodel/Rotor/gain2'],...
		'Gain','1/(2*H)',...
		'position',[430,39,495,81])

add_block('built-in/Integrator',[sys,'/','tmodel/Rotor/slip'])
set_param([sys,'/','tmodel/Rotor/slip'],...
		'position',[520,42,560,78])

add_block('built-in/Gain',[sys,'/','tmodel/Rotor/Damp'])
set_param([sys,'/','tmodel/Rotor/Damp'],...
		'orientation',2,...
		'Gain','Domega',...
		'position',[450,96,510,134])

add_block('built-in/Constant',[sys,'/','tmodel/Rotor/gain3'])
set_param([sys,'/','tmodel/Rotor/gain3'],...
		'Value','we/wb',...
		'position',[515,145,565,175])

add_block('built-in/Sum',[sys,'/','tmodel/Rotor/wr//wb'])
set_param([sys,'/','tmodel/Rotor/wr//wb'],...
		'position',[600,130,615,170])

add_block('built-in/Gain',[sys,'/','tmodel/Rotor/gain4'])
set_param([sys,'/','tmodel/Rotor/gain4'],...
		'Gain','wb',...
		'position',[605,38,655,82])

add_block('built-in/Integrator',[sys,'/','tmodel/Rotor/delta'])
set_param([sys,'/','tmodel/Rotor/delta'],...
		'Initial','delio',...
		'position',[675,42,710,78])

add_block('built-in/Outport',[sys,'/','tmodel/Rotor/out_delta'])
set_param([sys,'/','tmodel/Rotor/out_delta'],...
		'position',[735,50,755,70])

add_block('built-in/Outport',[sys,'/','tmodel/Rotor/out_puslip'])
set_param([sys,'/','tmodel/Rotor/out_puslip'],...
		'Port','2',...
		'position',[720,104,740,126])
add_line([sys,'/','tmodel/Rotor'],[565,60;575,60;575,140;595,140])
add_line([sys,'/','tmodel/Rotor'],[445,115;380,115;390,80])
add_line([sys,'/','tmodel/Rotor'],[305,40;390,40])
add_line([sys,'/','tmodel/Rotor'],[715,60;730,60])
add_line([sys,'/','tmodel/Rotor'],[420,60;425,60])
add_line([sys,'/','tmodel/Rotor'],[570,160;595,160])
add_line([sys,'/','tmodel/Rotor'],[500,60;515,60])
add_line([sys,'/','tmodel/Rotor'],[660,60;670,60])
add_line([sys,'/','tmodel/Rotor'],[565,60;600,60])
add_line([sys,'/','tmodel/Rotor'],[565,60;575,60;575,115;515,115])
add_line([sys,'/','tmodel/Rotor'],[565,60;575,60;575,115;715,115])
add_line([sys,'/','tmodel/Rotor'],[110,95;120,95])
add_line([sys,'/','tmodel/Rotor'],[355,95;365,95;365,60;390,60])
add_line([sys,'/','tmodel/Rotor'],[355,95;365,95;365,150;415,150])
add_line([sys,'/','tmodel/Rotor'],[55,35;75,35])
add_line([sys,'/','tmodel/Rotor'],[55,115;75,115])
add_line([sys,'/','tmodel/Rotor'],[55,155;75,155])
add_line([sys,'/','tmodel/Rotor'],[55,75;75,75])


%     Finished composite block 'tmodel/Rotor'.

set_param([sys,'/','tmodel/Rotor'],...
		'Font Number',3,...
		'position',[535,226,580,344])

add_block('built-in/Inport',[sys,'/','tmodel/in_Tmech'])
set_param([sys,'/','tmodel/in_Tmech'],...
		'Port','4',...
		'position',[490,325,510,345])

add_block('built-in/Outport',[sys,'/','tmodel/out_delta'])
set_param([sys,'/','tmodel/out_delta'],...
		'Port','5',...
		'position',[740,235,760,255])

add_block('built-in/Note',[sys,'/','tmodel/delta'])
set_param([sys,'/','tmodel/delta'],...
		'position',[610,225,615,230])

add_block('built-in/Outport',[sys,'/','tmodel/out_puslip'])
set_param([sys,'/','tmodel/out_puslip'],...
		'Port','6',...
		'position',[670,275,690,295])

add_block('built-in/Outport',[sys,'/','tmodel/out_Tem'])
set_param([sys,'/','tmodel/out_Tem'],...
		'Port','7',...
		'position',[740,315,760,335])

add_block('built-in/Note',[sys,'/','tmodel/iq'])
set_param([sys,'/','tmodel/iq'],...
		'position',[360,260,365,265])

add_block('built-in/Note',[sys,'/','tmodel/id'])
set_param([sys,'/','tmodel/id'],...
		'position',[360,290,365,295])

add_block('built-in/Note',[sys,'/','tmodel/|Vt|'])
set_param([sys,'/','tmodel/|Vt|'],...
		'position',[545,115,550,120])

add_block('built-in/Note',[sys,'/','tmodel/Fixed excitation transient model in generator notation'])
set_param([sys,'/','tmodel/Fixed excitation transient model in generator notation'],...
		'position',[590,440,595,445])

add_block('built-in/Note',[sys,'/','tmodel/Eqp_'])
set_param([sys,'/','tmodel/Eqp_'],...
		'position',[310,160,315,165])

add_block('built-in/Note',[sys,'/','tmodel/vqir'])
set_param([sys,'/','tmodel/vqir'],...
		'position',[225,255,230,260])

add_block('built-in/Gain',[sys,'/','tmodel/Gain3'])
set_param([sys,'/','tmodel/Gain3'],...
		'orientation',2,...
		'Gain','xq-xpq',...
		'position',[195,456,260,494])

add_block('built-in/Gain',[sys,'/','tmodel/1//Tpqo'])
set_param([sys,'/','tmodel/1//Tpqo'],...
		'Gain','1/Tpqo',...
		'position',[170,391,230,429])

add_block('built-in/Integrator',[sys,'/','tmodel/Edp'])
set_param([sys,'/','tmodel/Edp'],...
		'Initial','Edpo',...
		'position',[245,394,275,426])

add_block('built-in/Sum',[sys,'/','tmodel/sum1'])
set_param([sys,'/','tmodel/sum1'],...
		'inputs','+-',...
		'position',[120,383,140,432])
add_line([sys,'/','tmodel'],[275,180;280,180;280,220;300,220])
add_line([sys,'/','tmodel'],[585,245;600,245;600,370;150,370;150,315;165,315])
add_line([sys,'/','tmodel'],[275,180;395,180;395,235;530,235])
add_line([sys,'/','tmodel'],[275,180;280,180;280,145;105,145;105,160;125,160])
add_line([sys,'/','tmodel'],[235,180;235,180])
add_line([sys,'/','tmodel'],[155,180;165,180])
add_line([sys,'/','tmodel'],[190,105;95,105;95,200;125,200])
add_line([sys,'/','tmodel'],[530,160;665,160])
add_line([sys,'/','tmodel'],[530,185;735,185])
add_line([sys,'/','tmodel'],[530,210;665,210])
add_line([sys,'/','tmodel'],[585,245;735,245])
add_line([sys,'/','tmodel'],[585,285;665,285])
add_line([sys,'/','tmodel'],[85,240;120,240;120,275;165,275])
add_line([sys,'/','tmodel'],[85,295;165,295])
add_line([sys,'/','tmodel'],[350,220;360,220;360,135;480,135])
add_line([sys,'/','tmodel'],[350,250;380,250;380,185;480,185])
add_line([sys,'/','tmodel'],[350,280;410,280;410,160;480,160])
add_line([sys,'/','tmodel'],[350,310;445,310;445,210;480,210])
add_line([sys,'/','tmodel'],[350,310;445,310;445,105;265,105])
add_line([sys,'/','tmodel'],[85,180;125,180])
add_line([sys,'/','tmodel'],[585,325;735,325])
add_line([sys,'/','tmodel'],[235,410;240,410])
add_line([sys,'/','tmodel'],[145,410;165,410])
add_line([sys,'/','tmodel'],[280,410;285,410;285,445;100,445;100,420;115,420])
add_line([sys,'/','tmodel'],[350,280;410,280;410,475;265,475])
add_line([sys,'/','tmodel'],[190,475;90,475;90,395;115,395])
add_line([sys,'/','tmodel'],[280,410;285,410;285,250;300,250])
add_line([sys,'/','tmodel'],[215,280;300,280])
add_line([sys,'/','tmodel'],[215,310;300,310])
add_line([sys,'/','tmodel'],[515,335;530,335])
add_line([sys,'/','tmodel'],[350,310;530,310])
add_line([sys,'/','tmodel'],[350,280;410,280;410,285;530,285])
add_line([sys,'/','tmodel'],[280,410;470,410;470,260;530,260])
add_line([sys,'/','tmodel'],[530,135;735,135])


%     Finished composite block 'tmodel'.

set_param([sys,'/','tmodel'],...
		'position',[190,73,270,247])

add_block('built-in/Outport',[sys,'/','out_Tem'])
set_param([sys,'/','out_Tem'],...
		'Port','7',...
		'position',[340,225,360,245])


%     Subsystem  'm1'.

new_system([sys,'/','m1'])
set_param([sys,'/','m1'],'Location',[8,386,272,573])

add_block('built-in/Note',[sys,'/',['m1/This masked block makes use of',13,'the Matlab file m1.m to initialize s1.m']])
set_param([sys,'/',['m1/This masked block makes use of',13,'the Matlab file m1.m to initialize s1.m']],...
		'position',[135,65,140,70])
set_param([sys,'/','m1'],...
		'Mask Display','Initialize\nand plot',...
		'Mask Type','Initialize s1 or s1eig ',...
		'Mask Dialogue','eval(''m1'')',...
		'Mask Help','Uses m1.m to initialize s1 or s1eig')


%     Finished composite block 'm1'.

set_param([sys,'/','m1'],...
		'Drop Shadow',4,...
		'position',[384,42,454,74])
add_line(sys,[275,85;330,85])
add_line(sys,[275,110;395,110])
add_line(sys,[275,135;330,135])
add_line(sys,[275,160;400,160])
add_line(sys,[275,185;330,185])
add_line(sys,[275,210;400,210])
add_line(sys,[145,95;185,95])
add_line(sys,[145,140;185,140])
add_line(sys,[145,185;185,185])
add_line(sys,[145,230;185,230])
add_line(sys,[275,235;335,235])

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
