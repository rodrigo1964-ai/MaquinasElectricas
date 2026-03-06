function [ret,x0,str,ts,xts]=s4(t,x,u,flag);
%s4	is the M-file description of the SIMULINK system named s4.
%	s4 has a the following characteristics:
%		10 continuous states
%		0 discrete states
%		7 outputs
%		0 inputs
%		does not have direct feedthrough
%		1 sample times
%
%	The block-diagram can be displayed by typing: s4.
%
%	SYS=s4(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes s4 to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling s4 with a FLAG of zero:
%	[SIZES]=s4([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[44,55,681,484])
     open_system(sys)
end;
set_param(sys,'algorithm',     'Adams/Gear')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     'tstop')
set_param(sys,'Min step size', '0.0001')
set_param(sys,'Max step size', '0.1')
set_param(sys,'Relative error','1e-6')
set_param(sys,'Return vars',   '')
set_param(sys,'AssignWideVectorLines','on');

add_block('built-in/Outport',[sys,'/','Pgen'])
set_param([sys,'/','Pgen'],...
		'Port','3',...
		'position',[500,150,520,170])

add_block('built-in/Outport',[sys,'/','delta'])
set_param([sys,'/','delta'],...
		'Port','5',...
		'position',[500,200,520,220])

add_block('built-in/Outport',[sys,'/','puslip'])
set_param([sys,'/','puslip'],...
		'Port','6',...
		'position',[555,225,575,245])

add_block('built-in/Outport',[sys,'/','Tem'])
set_param([sys,'/','Tem'],...
		'Port','7',...
		'position',[500,250,520,270])

add_block('built-in/Outport',[sys,'/','Qgen'])
set_param([sys,'/','Qgen'],...
		'Port','4',...
		'position',[555,175,575,195])


%     Subsystem  'tmodel'.

new_system([sys,'/','tmodel'])
set_param([sys,'/','tmodel'],'Location',[300,169,1083,682])

add_block('built-in/Note',[sys,'/','tmodel/Fixed excitation transient model in generator notation'])
set_param([sys,'/','tmodel/Fixed excitation transient model in generator notation'],...
		'position',[550,25,555,30])

add_block('built-in/Scope',[sys,'/','tmodel/Scope'])
set_param([sys,'/','tmodel/Scope'],...
		'orientation',2,...
		'Vgain','2.000000',...
		'Hgain','10.000000',...
		'Vmax','4.000000',...
		'Hmax','20.000000',...
		'Window',[153,726,582,896],...
		'position',[580,401,600,429])

add_block('built-in/Note',[sys,'/','tmodel/|Vt|'])
set_param([sys,'/','tmodel/|Vt|'],...
		'position',[540,85,545,90])

add_block('built-in/Note',[sys,'/','tmodel/id'])
set_param([sys,'/','tmodel/id'],...
		'position',[355,260,360,265])

add_block('built-in/Note',[sys,'/','tmodel/iq'])
set_param([sys,'/','tmodel/iq'],...
		'position',[355,230,360,235])

add_block('built-in/Outport',[sys,'/','tmodel/out_Tem'])
set_param([sys,'/','tmodel/out_Tem'],...
		'Port','7',...
		'position',[735,285,755,305])

add_block('built-in/Outport',[sys,'/','tmodel/out_puslip'])
set_param([sys,'/','tmodel/out_puslip'],...
		'Port','6',...
		'position',[665,245,685,265])

add_block('built-in/Note',[sys,'/','tmodel/delta'])
set_param([sys,'/','tmodel/delta'],...
		'position',[605,195,610,200])

add_block('built-in/Outport',[sys,'/','tmodel/out_delta'])
set_param([sys,'/','tmodel/out_delta'],...
		'Port','5',...
		'position',[735,205,755,225])

add_block('built-in/Inport',[sys,'/','tmodel/in_Tmech'])
set_param([sys,'/','tmodel/in_Tmech'],...
		'Port','4',...
		'position',[485,295,505,315])


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
		'position',[450,96,525,134])

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
add_line([sys,'/','tmodel/Rotor'],[565,60;575,60;575,115;530,115])
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
		'position',[530,196,575,314])

add_block('built-in/Outport',[sys,'/','tmodel/out_Qgen'])
set_param([sys,'/','tmodel/out_Qgen'],...
		'Port','4',...
		'position',[665,170,685,190])

add_block('built-in/Outport',[sys,'/','tmodel/out_Pgen'])
set_param([sys,'/','tmodel/out_Pgen'],...
		'Port','3',...
		'position',[735,145,755,165])

add_block('built-in/Outport',[sys,'/','tmodel/out_|I|'])
set_param([sys,'/','tmodel/out_|I|'],...
		'Port','2',...
		'position',[665,120,685,140])

add_block('built-in/Outport',[sys,'/','tmodel/out_|Vt|'])
set_param([sys,'/','tmodel/out_|Vt|'],...
		'position',[735,95,755,115])


%     Subsystem  'tmodel/VIPQ'.

new_system([sys,'/','tmodel/VIPQ'])
set_param([sys,'/','tmodel/VIPQ'],'Location',[264,557,952,990])

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
		'position',[480,96,520,189])

add_block('built-in/Inport',[sys,'/','tmodel/in_vdie'])
set_param([sys,'/','tmodel/in_vdie'],...
		'Port','3',...
		'position',[55,252,75,278])

add_block('built-in/Inport',[sys,'/','tmodel/in_vqie'])
set_param([sys,'/','tmodel/in_vqie'],...
		'Port','2',...
		'position',[55,200,75,220])


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
		'position',[300,178,340,292])

add_block('built-in/Gain',[sys,'/','tmodel/Gain3'])
set_param([sys,'/','tmodel/Gain3'],...
		'orientation',2,...
		'Gain','xq-xpq',...
		'position',[190,441,255,479])

add_block('built-in/Gain',[sys,'/','tmodel/1//Tpqo'])
set_param([sys,'/','tmodel/1//Tpqo'],...
		'Gain','1/Tpqo',...
		'position',[165,376,225,414])

add_block('built-in/Integrator',[sys,'/','tmodel/Edp'])
set_param([sys,'/','tmodel/Edp'],...
		'Initial','Edpo',...
		'position',[240,379,270,411])

add_block('built-in/Sum',[sys,'/','tmodel/sum1'])
set_param([sys,'/','tmodel/sum1'],...
		'inputs','+-',...
		'position',[115,368,135,417])

add_block('built-in/Gain',[sys,'/','tmodel/1//Tpdo'])
set_param([sys,'/','tmodel/1//Tpdo'],...
		'Gain','1/Tpdo',...
		'position',[165,131,225,169])

add_block('built-in/Integrator',[sys,'/','tmodel/Eqp'])
set_param([sys,'/','tmodel/Eqp'],...
		'Initial','Eqpo',...
		'position',[235,134,265,166])

add_block('built-in/Note',[sys,'/','tmodel/Ef'])
set_param([sys,'/','tmodel/Ef'],...
		'position',[105,130,110,135])

add_block('built-in/Inport',[sys,'/','tmodel/in_Ef'])
set_param([sys,'/','tmodel/in_Ef'],...
		'position',[55,140,75,160])

add_block('built-in/Note',[sys,'/','tmodel/vdir'])
set_param([sys,'/','tmodel/vdir'],...
		'position',[215,260,220,265])

add_block('built-in/Note',[sys,'/','tmodel/vqir'])
set_param([sys,'/','tmodel/vqir'],...
		'position',[215,235,220,240])


%     Subsystem  'tmodel/qde2qdr'.

new_system([sys,'/','tmodel/qde2qdr'])
set_param([sys,'/','tmodel/qde2qdr'],'Location',[266,603,791,790])

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
		'position',[165,235,205,295])

add_block('built-in/Note',[sys,'/','tmodel/Eqp_'])
set_param([sys,'/','tmodel/Eqp_'],...
		'position',[290,130,295,135])

add_block('built-in/Sum',[sys,'/','tmodel/sum'])
set_param([sys,'/','tmodel/sum'],...
		'inputs','-+-',...
		'position',[125,123,145,177])

add_block('built-in/Gain',[sys,'/','tmodel/Gain2'])
set_param([sys,'/','tmodel/Gain2'],...
		'orientation',2,...
		'Gain','xd-xpd',...
		'position',[190,56,255,94])
add_line([sys,'/','tmodel'],[270,150;275,150;275,190;295,190])
add_line([sys,'/','tmodel'],[580,215;595,215;595,340;145,340;145,285;160,285])
add_line([sys,'/','tmodel'],[270,150;390,150;390,205;525,205])
add_line([sys,'/','tmodel'],[270,150;275,150;275,115;100,115;100,130;120,130])
add_line([sys,'/','tmodel'],[230,150;230,150])
add_line([sys,'/','tmodel'],[150,150;160,150])
add_line([sys,'/','tmodel'],[185,75;90,75;90,170;120,170])
add_line([sys,'/','tmodel'],[525,130;660,130])
add_line([sys,'/','tmodel'],[525,155;730,155])
add_line([sys,'/','tmodel'],[525,180;660,180])
add_line([sys,'/','tmodel'],[580,215;730,215])
add_line([sys,'/','tmodel'],[580,255;660,255])
add_line([sys,'/','tmodel'],[80,210;115,210;115,245;160,245])
add_line([sys,'/','tmodel'],[80,265;160,265])
add_line([sys,'/','tmodel'],[345,190;355,190;355,105;475,105])
add_line([sys,'/','tmodel'],[345,220;375,220;375,155;475,155])
add_line([sys,'/','tmodel'],[345,250;405,250;405,130;475,130])
add_line([sys,'/','tmodel'],[345,280;440,280;440,180;475,180])
add_line([sys,'/','tmodel'],[345,280;440,280;440,75;260,75])
add_line([sys,'/','tmodel'],[80,150;120,150])
add_line([sys,'/','tmodel'],[580,295;730,295])
add_line([sys,'/','tmodel'],[230,395;235,395])
add_line([sys,'/','tmodel'],[140,395;160,395])
add_line([sys,'/','tmodel'],[275,395;280,395;280,430;95,430;95,405;110,405])
add_line([sys,'/','tmodel'],[345,250;405,250;405,460;260,460])
add_line([sys,'/','tmodel'],[185,460;85,460;85,380;110,380])
add_line([sys,'/','tmodel'],[275,395;280,395;280,220;295,220])
add_line([sys,'/','tmodel'],[210,250;295,250])
add_line([sys,'/','tmodel'],[210,280;295,280])
add_line([sys,'/','tmodel'],[510,305;525,305])
add_line([sys,'/','tmodel'],[345,280;525,280])
add_line([sys,'/','tmodel'],[345,250;405,250;405,255;525,255])
add_line([sys,'/','tmodel'],[275,395;465,395;465,230;525,230])
add_line([sys,'/','tmodel'],[525,105;730,105])


%     Finished composite block 'tmodel'.

set_param([sys,'/','tmodel'],...
		'position',[230,98,310,272])

add_block('built-in/Outport',[sys,'/','|Vt|'])
set_param([sys,'/','|Vt|'],...
		'position',[500,100,520,120])

add_block('built-in/Outport',[sys,'/','|Igen|'])
set_param([sys,'/','|Igen|'],...
		'Port','2',...
		'position',[555,125,575,145])

add_block('built-in/Note',[sys,'/',['Ef''']])
set_param([sys,'/',['Ef''']],...
		'position',[200,97,205,102])

add_block('built-in/Scope',[sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'orientation',2,...
		'Vgain','2.000000',...
		'Hgain','30.000000',...
		'Vmax','4.000000',...
		'Hmax','60.000000',...
		'Window',[39,467,741,587])
open_system([sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'position',[285,21,305,49])

add_block('built-in/Constant',[sys,'/','vqe'])
set_param([sys,'/','vqe'],...
		'Value','Vio',...
		'position',[185,155,215,175])

add_block('built-in/Constant',[sys,'/','vde'])
set_param([sys,'/','vde'],...
		'Value','0',...
		'position',[195,200,215,220])

add_block('built-in/Note',[sys,'/','Vsupp'])
set_param([sys,'/','Vsupp'],...
		'position',[95,100,100,105])

add_block('built-in/Note',[sys,'/','Vt'])
set_param([sys,'/','Vt'],...
		'position',[105,125,110,130])

add_block('built-in/Constant',[sys,'/','Tmecho'])
set_param([sys,'/','Tmecho'],...
		'Value','Pmecho',...
		'position',[90,234,150,256])

add_block('built-in/Constant',[sys,'/','PSS_sw'])
set_param([sys,'/','PSS_sw'],...
		'orientation',2,...
		'Value','pss_sw',...
		'position',[185,385,260,405])

add_block('built-in/Switch',[sys,'/','Switch'])
set_param([sys,'/','Switch'],...
		'orientation',2,...
		'position',[115,329,145,361])

add_block('built-in/Saturation',[sys,'/',['signal',13,'limits']])
set_param([sys,'/',['signal',13,'limits']],...
		'orientation',2,...
		'Lower Limit','-pss_limit',...
		'Upper Limit','pss_limit',...
		'position',[200,316,235,354])

add_block('built-in/Transfer Fcn',[sys,'/','wash-out'])
set_param([sys,'/','wash-out'],...
		'orientation',2,...
		'Numerator','[Ks 0]',...
		'Denominator','[Tw 1]',...
		'position',[260,315,340,355])

add_block('built-in/Transfer Fcn',[sys,'/','comp2'])
set_param([sys,'/','comp2'],...
		'orientation',2,...
		'Numerator','[T3 1]',...
		'Denominator','[T4 1]',...
		'position',[375,315,420,355])

add_block('built-in/Transfer Fcn',[sys,'/','comp1'])
set_param([sys,'/','comp1'],...
		'orientation',2,...
		'Numerator','[T1 1]',...
		'Denominator','[T2 1]',...
		'position',[460,316,510,354])

add_block('built-in/Mux',[sys,'/','Mux'])
set_param([sys,'/','Mux'],...
		'orientation',3,...
		'inputs','5',...
		'position',[337,45,483,70])

add_block('built-in/To Workspace',[sys,'/','To Workspace'])
set_param([sys,'/','To Workspace'],...
		'mat-name','y',...
		'buffer','10000',...
		'position',[540,27,590,43])

add_block('built-in/Clock',[sys,'/','Clock'])
set_param([sys,'/','Clock'],...
		'orientation',2,...
		'position',[555,80,575,100])

add_block('built-in/Sum',[sys,'/','Sum'])
set_param([sys,'/','Sum'],...
		'position',[190,239,210,266])


%     Subsystem  'exciter'.

new_system([sys,'/','exciter'])
set_param([sys,'/','exciter'],'Location',[149,293,965,637])

add_block('built-in/Integrator',[sys,'/','exciter/VR'])
set_param([sys,'/','exciter/VR'],...
		'Initial','VR',...
		'position',[325,89,355,121])

add_block('built-in/Sum',[sys,'/','exciter/Sum1'])
set_param([sys,'/','exciter/Sum1'],...
		'inputs','-+',...
		'position',[460,68,475,117])

add_block('built-in/Saturation',[sys,'/','exciter/VRmax//VRmin'])
set_param([sys,'/','exciter/VRmax//VRmin'],...
		'Lower Limit','VRmin',...
		'Upper Limit','VRmax',...
		'position',[385,82,435,128])

add_block('built-in/Gain',[sys,'/','exciter/Gain2'])
set_param([sys,'/','exciter/Gain2'],...
		'Gain','1/TE',...
		'position',[500,77,565,113])

add_block('built-in/Gain',[sys,'/','exciter/Gain3'])
set_param([sys,'/','exciter/Gain3'],...
		'orientation',2,...
		'Gain','KE/TE',...
		'position',[575,157,685,193])

add_block('built-in/Fcn',[sys,'/','exciter/Se'])
set_param([sys,'/','exciter/Se'],...
		'orientation',2,...
		'Expr','AEx*exp(BEx*u[1])',...
		'position',[480,21,660,49])

add_block('built-in/Outport',[sys,'/','exciter/out_Ef'])
set_param([sys,'/','exciter/out_Ef'],...
		'position',[745,95,765,115])

add_block('built-in/Gain',[sys,'/','exciter/Gain'])
set_param([sys,'/','exciter/Gain'],...
		'Gain','KA/TA',...
		'position',[170,74,265,116])

add_block('built-in/Gain',[sys,'/','exciter/Gain1'])
set_param([sys,'/','exciter/Gain1'],...
		'orientation',2,...
		'Gain','1/TA',...
		'position',[265,158,350,192])

add_block('built-in/Gain',[sys,'/','exciter/Gain5'])
set_param([sys,'/','exciter/Gain5'],...
		'Gain','1/TF',...
		'position',[230,274,295,316])

add_block('built-in/Gain',[sys,'/','exciter/Gain4'])
set_param([sys,'/','exciter/Gain4'],...
		'orientation',2,...
		'Gain','KF/TF',...
		'position',[405,216,520,254])

add_block('built-in/Integrator',[sys,'/','exciter/Ef'])
set_param([sys,'/','exciter/Ef'],...
		'Initial','Efo',...
		'position',[645,90,675,120])

add_block('built-in/Integrator',[sys,'/','exciter/Vs'])
set_param([sys,'/','exciter/Vs'],...
		'Initial','Vs',...
		'position',[345,277,380,313])

add_block('built-in/Note',[sys,'/','exciter/Vstab'])
set_param([sys,'/','exciter/Vstab'],...
		'position',[150,225,155,230])

add_block('built-in/Sum',[sys,'/','exciter/Sum2'])
set_param([sys,'/','exciter/Sum2'],...
		'inputs','+-',...
		'position',[290,84,305,126])

add_block('built-in/Sum',[sys,'/','exciter/Sum3'])
set_param([sys,'/','exciter/Sum3'],...
		'inputs','+-',...
		'position',[600,84,615,126])

add_block('built-in/Sum',[sys,'/','exciter/Sum4'])
set_param([sys,'/','exciter/Sum4'],...
		'orientation',2,...
		'inputs','+-',...
		'position',[305,226,320,264])

add_block('built-in/Sum',[sys,'/','exciter/Sum'])
set_param([sys,'/','exciter/Sum'],...
		'inputs','+---',...
		'position',[135,58,150,127])

add_block('built-in/Inport',[sys,'/','exciter/Vref'])
set_param([sys,'/','exciter/Vref'],...
		'position',[55,45,75,65])

add_block('built-in/Inport',[sys,'/','exciter/Vsupp'])
set_param([sys,'/','exciter/Vsupp'],...
		'Port','2',...
		'position',[55,85,75,105])

add_block('built-in/Inport',[sys,'/','exciter/Vt'])
set_param([sys,'/','exciter/Vt'],...
		'Port','3',...
		'position',[55,130,75,150])

add_block('built-in/Scope',[sys,'/','exciter/Scope'])
set_param([sys,'/','exciter/Scope'],...
		'orientation',2,...
		'Vgain','1.200000',...
		'Hgain','10.000000',...
		'Vmax','2.400000',...
		'Hmax','20.000000',...
		'Window',[177,801,606,971],...
		'position',[315,36,335,64])
add_line([sys,'/','exciter'],[440,105;455,105])
add_line([sys,'/','exciter'],[80,55;100,55;100,70;130,70])
add_line([sys,'/','exciter'],[475,35;440,35;440,80;455,80])
add_line([sys,'/','exciter'],[310,105;320,105])
add_line([sys,'/','exciter'],[155,95;165,95])
add_line([sys,'/','exciter'],[360,105;380,105])
add_line([sys,'/','exciter'],[360,105;365,105;355,175])
add_line([sys,'/','exciter'],[620,105;640,105])
add_line([sys,'/','exciter'],[680,105;710,105;710,175;690,175])
add_line([sys,'/','exciter'],[480,95;495,95])
add_line([sys,'/','exciter'],[570,95;595,95])
add_line([sys,'/','exciter'],[570,175;565,175;565,115;595,115])
add_line([sys,'/','exciter'],[680,105;710,105;710,35;665,35])
add_line([sys,'/','exciter'],[680,105;740,105])
add_line([sys,'/','exciter'],[270,95;285,95])
add_line([sys,'/','exciter'],[260,175;250,175;250,115;285,115])
add_line([sys,'/','exciter'],[400,235;325,235])
add_line([sys,'/','exciter'],[300,295;340,295])
add_line([sys,'/','exciter'],[385,295;405,295;405,255;325,255])
add_line([sys,'/','exciter'],[680,105;710,105;710,235;525,235])
add_line([sys,'/','exciter'],[300,245;205,245;205,295;225,295])
add_line([sys,'/','exciter'],[300,245;110,245;110,115;130,115])
add_line([sys,'/','exciter'],[80,140;100,140;100,100;130,100])
add_line([sys,'/','exciter'],[80,95;100,95;100,85;130,85])


%     Finished composite block 'exciter'.

set_param([sys,'/','exciter'],...
		'position',[135,84,175,156])

add_block('built-in/Constant',[sys,'/','Vref*'])
set_param([sys,'/','Vref*'],...
		'Value','Vref',...
		'position',[45,86,75,104])

add_block('built-in/Note',[sys,'/','Vref'])
set_param([sys,'/','Vref'],...
		'position',[100,75,105,80])


%     Subsystem  'DTmech'.

new_system([sys,'/','DTmech'])
set_param([sys,'/','DTmech'],'Location',[5,40,315,196])

add_block('built-in/Outport',[sys,'/','DTmech/out_1'])
set_param([sys,'/','DTmech/out_1'],...
		'position',[285,60,305,80])

add_block('built-in/Look Up Table',[sys,'/','DTmech/Look-Up Table'])
set_param([sys,'/','DTmech/Look-Up Table'],...
		'Input_Values','t',...
		'Output_Values','y',...
		'position',[210,58,250,82])

add_block('built-in/Fcn',[sys,'/','DTmech/Fcn1'])
set_param([sys,'/','DTmech/Fcn1'],...
		'Expr','rem(u[1],period)',...
		'position',[110,60,150,80])

add_block('built-in/Clock',[sys,'/','DTmech/Clock'])
set_param([sys,'/','DTmech/Clock'],...
		'position',[45,60,65,80])
add_line([sys,'/','DTmech'],[255,70;280,70])
add_line([sys,'/','DTmech'],[70,70;105,70])
add_line([sys,'/','DTmech'],[155,70;205,70])
set_param([sys,'/','DTmech'],...
		'Mask Display','plot([t,t+period,t+2*period],[y,y,y])',...
		'Mask Type','Repeating table',...
		'Mask Dialogue','Repeating table.\nEnter values of time and output for first cycle.|Time values:|Output values:')
set_param([sys,'/','DTmech'],...
		'Mask Translate','period = max(@1); t = @1; y = @2;',...
		'Mask Help','Repeats cycle given in table. Time values should be monotonically increasing.',...
		'Mask Entries','time_Dtmech\/tmech_Dtmech\/')


%     Finished composite block 'DTmech'.

set_param([sys,'/','DTmech'],...
		'position',[90,280,145,300])


%     Subsystem  'm4'.

new_system([sys,'/','m4'])
set_param([sys,'/','m4'],'Location',[140,4325536,228,4325622])

add_block('built-in/Note',[sys,'/',['m4/Masked block of m4.m to initialize',13,'s4.m in chapter 10 and to plot results']])
set_param([sys,'/',['m4/Masked block of m4.m to initialize',13,'s4.m in chapter 10 and to plot results']],...
		'position',[55,50,60,55])
set_param([sys,'/','m4'],...
		'Mask Display','Initialize\nand plot',...
		'Mask Type','Masked block of m4.m',...
		'Mask Dialogue','eval(''m4'')',...
		'Mask Help','Uses m4.m to initialize and plot')


%     Finished composite block 'm4'.

set_param([sys,'/','m4'],...
		'Drop Shadow',4,...
		'position',[149,20,220,53])
add_line(sys,[220,165;225,165])
add_line(sys,[220,210;225,210])
add_line(sys,[410,40;410,35;310,35])
add_line(sys,[315,260;495,260])
add_line(sys,[315,235;550,235])
add_line(sys,[315,210;495,210])
add_line(sys,[315,185;550,185])
add_line(sys,[315,160;495,160])
add_line(sys,[315,135;550,135])
add_line(sys,[315,110;495,110])
add_line(sys,[410,40;410,35;535,35])
add_line(sys,[315,110;350,110;350,75])
add_line(sys,[180,120;225,120])
add_line(sys,[315,110;325,110;325,75;35,75;35,145;130,145])
add_line(sys,[370,335;345,335])
add_line(sys,[455,335;425,335])
add_line(sys,[315,235;535,235;535,335;515,335])
add_line(sys,[255,335;240,335])
add_line(sys,[195,335;150,335])
add_line(sys,[110,345;80,345;80,120;130,120])
add_line(sys,[180,395;160,395;150,345])
add_line(sys,[80,95;130,95])
add_line(sys,[155,245;185,245])
add_line(sys,[215,255;225,255])
add_line(sys,[315,160;380,160;380,75])
add_line(sys,[315,185;410,185;410,75])
add_line(sys,[315,210;440,210;440,75])
add_line(sys,[550,90;470,90;470,75])
add_line(sys,[150,290;160,290;160,260;185,260])

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
