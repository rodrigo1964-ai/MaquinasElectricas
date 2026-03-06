function [ret,x0,str,ts,xts]=s2eig(t,x,u,flag);
%s2eig	is the M-file description of the SIMULINK system named s2eig.
%	The block-diagram can be displayed by typing: s2eig.
%
%	SYS=s2eig(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes s2eig to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling s2eig with a FLAG of zero:
%	[SIZES]=s2eig([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[100,100,879,698])
     open_system(sys)
end;
set_param(sys,'algorithm',     'RK-45')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     'tstop')
set_param(sys,'Min step size', '0.00001')
set_param(sys,'Max step size', '0.04')
set_param(sys,'Relative error','1e-6')
set_param(sys,'Return vars',   '')

add_block('built-in/Gain',[sys,'/','Sys//Gen2VA_'])
set_param([sys,'/','Sys//Gen2VA_'],...
		'orientation',2,...
		'Gain','Sbratio(2)',...
		'position',[360,513,450,547])

add_block('built-in/Note',[sys,'/','ide2'])
set_param([sys,'/','ide2'],...
		'position',[315,512,320,517])

add_block('built-in/Outport',[sys,'/','Out_Qgen2'])
set_param([sys,'/','Out_Qgen2'],...
		'Port','6',...
		'position',[265,400,285,420])

add_block('built-in/Outport',[sys,'/','Out_|vt2|'])
set_param([sys,'/','Out_|vt2|'],...
		'Port','4',...
		'position',[265,355,285,375])

add_block('built-in/Outport',[sys,'/','Out_Pgen2'])
set_param([sys,'/','Out_Pgen2'],...
		'Port','5',...
		'position',[330,385,350,405])

add_block('built-in/Outport',[sys,'/','Out_Qgen1'])
set_param([sys,'/','Out_Qgen1'],...
		'Port','3',...
		'position',[310,70,330,90])

add_block('built-in/Outport',[sys,'/','Out_Pgen1'])
set_param([sys,'/','Out_Pgen1'],...
		'Port','2',...
		'position',[410,55,430,75])

add_block('built-in/Outport',[sys,'/','Out_|vt1|'])
set_param([sys,'/','Out_|vt1|'],...
		'position',[310,25,330,45])

add_block('built-in/Note',[sys,'/','iqe1'])
set_param([sys,'/','iqe1'],...
		'position',[315,186,320,191])

add_block('built-in/Note',[sys,'/','ide1'])
set_param([sys,'/','ide1'],...
		'position',[525,147,530,152])

add_block('built-in/Gain',[sys,'/','Sys//Gen1VA'])
set_param([sys,'/','Sys//Gen1VA'],...
		'orientation',2,...
		'Gain','Sbratio(1)',...
		'position',[445,189,535,221])

add_block('built-in/Gain',[sys,'/','Sys//Gen1VA_'])
set_param([sys,'/','Sys//Gen1VA_'],...
		'orientation',2,...
		'Gain','Sbratio(1)',...
		'position',[575,153,660,187])

add_block('built-in/Note',[sys,'/','iqe2'])
set_param([sys,'/','iqe2'],...
		'position',[170,220,175,225])

add_block('built-in/Gain',[sys,'/','Sys//Gen2VA'])
set_param([sys,'/','Sys//Gen2VA'],...
		'orientation',2,...
		'Gain','Sbratio(2)',...
		'position',[190,223,275,257])

add_block('built-in/Inport',[sys,'/','In_tmech2'])
set_param([sys,'/','In_tmech2'],...
		'Port','4',...
		'position',[85,460,105,480])

add_block('built-in/Inport',[sys,'/','In_vref2'])
set_param([sys,'/','In_vref2'],...
		'Port','3',...
		'position',[85,370,105,390])


%     Subsystem  'tmodel1'.

new_system([sys,'/','tmodel1'])
set_param([sys,'/','tmodel1'],'Location',[272,180,1082,845])

add_block('built-in/Note',[sys,'/','tmodel1/Eqp_'])
set_param([sys,'/','tmodel1/Eqp_'],...
		'position',[320,150,325,155])

add_block('built-in/Integrator',[sys,'/','tmodel1/Eqp'])
set_param([sys,'/','tmodel1/Eqp'],...
		'Initial','Eqpo(1)',...
		'position',[255,154,285,186])

add_block('built-in/Sum',[sys,'/','tmodel1/sum'])
set_param([sys,'/','tmodel1/sum'],...
		'inputs','-+-',...
		'position',[130,143,145,197])

add_block('built-in/Gain',[sys,'/','tmodel1/1//Tpdo'])
set_param([sys,'/','tmodel1/1//Tpdo'],...
		'Gain','1/Tpdo(1)',...
		'position',[160,149,240,191])

add_block('built-in/Outport',[sys,'/','tmodel1/out_Pgen'])
set_param([sys,'/','tmodel1/out_Pgen'],...
		'Port','3',...
		'position',[675,175,695,195])

add_block('built-in/Outport',[sys,'/','tmodel1/out_|I|'])
set_param([sys,'/','tmodel1/out_|I|'],...
		'Port','2',...
		'position',[730,150,750,170])

add_block('built-in/Outport',[sys,'/','tmodel1/out_|Vt|'])
set_param([sys,'/','tmodel1/out_|Vt|'],...
		'position',[675,125,695,145])

add_block('built-in/Outport',[sys,'/','tmodel1/out_Qgen'])
set_param([sys,'/','tmodel1/out_Qgen'],...
		'Port','4',...
		'position',[730,200,750,220])

add_block('built-in/Scope',[sys,'/','tmodel1/Scope'])
set_param([sys,'/','tmodel1/Scope'],...
		'Vgain','0.500000',...
		'Hgain','4.000000',...
		'Vmax','1.000000',...
		'Hmax','8.000000',...
		'Window',[25,411,356,725],...
		'position',[45,430,75,460])

add_block('built-in/Sum',[sys,'/','tmodel1/Sum'])
set_param([sys,'/','tmodel1/Sum'],...
		'inputs','-+',...
		'position',[145,440,160,475])

add_block('built-in/Gain',[sys,'/','tmodel1/Gain1'])
set_param([sys,'/','tmodel1/Gain1'],...
		'Gain','1/Tpqo(1)',...
		'position',[180,441,265,479])

add_block('built-in/Integrator',[sys,'/','tmodel1/Edp'])
set_param([sys,'/','tmodel1/Edp'],...
		'Initial','Edpo(1)',...
		'position',[290,443,320,477])

add_block('built-in/Outport',[sys,'/','tmodel1/out_Edpe'])
set_param([sys,'/','tmodel1/out_Edpe'],...
		'Port','9',...
		'position',[670,465,690,485])

add_block('built-in/Inport',[sys,'/','tmodel1/in_iqe'])
set_param([sys,'/','tmodel1/in_iqe'],...
		'Port','2',...
		'position',[50,270,70,290])

add_block('built-in/Note',[sys,'/','tmodel1/|Vt|'])
set_param([sys,'/','tmodel1/|Vt|'],...
		'position',[585,110,590,115])


%     Subsystem  'tmodel1/VIPQ'.

new_system([sys,'/','tmodel1/VIPQ'])
set_param([sys,'/','tmodel1/VIPQ'],'Location',[206,374,894,807])

add_block('built-in/Mux',[sys,'/','tmodel1/VIPQ/Mux'])
set_param([sys,'/','tmodel1/VIPQ/Mux'],...
		'position',[135,143,165,307])

add_block('built-in/Inport',[sys,'/','tmodel1/VIPQ/vqt'])
set_param([sys,'/','tmodel1/VIPQ/vqt'],...
		'position',[45,155,65,175])

add_block('built-in/Inport',[sys,'/','tmodel1/VIPQ/vdt'])
set_param([sys,'/','tmodel1/VIPQ/vdt'],...
		'Port','2',...
		'position',[45,195,65,215])

add_block('built-in/Inport',[sys,'/','tmodel1/VIPQ/iq'])
set_param([sys,'/','tmodel1/VIPQ/iq'],...
		'Port','3',...
		'position',[45,235,65,255])

add_block('built-in/Inport',[sys,'/','tmodel1/VIPQ/id'])
set_param([sys,'/','tmodel1/VIPQ/id'],...
		'Port','4',...
		'position',[45,275,65,295])

add_block('built-in/Fcn',[sys,'/','tmodel1/VIPQ/Fcn'])
set_param([sys,'/','tmodel1/VIPQ/Fcn'],...
		'Expr','u[1]*u[3] + u[2]*u[4]',...
		'position',[230,232,385,258])

add_block('built-in/Fcn',[sys,'/','tmodel1/VIPQ/Fcn1'])
set_param([sys,'/','tmodel1/VIPQ/Fcn1'],...
		'Expr','u[1]*u[4] - u[2]*u[3]',...
		'position',[230,282,385,308])

add_block('built-in/Fcn',[sys,'/','tmodel1/VIPQ/Fcn2'])
set_param([sys,'/','tmodel1/VIPQ/Fcn2'],...
		'Expr','sqrt(u[3]*u[3] + u[4]*u[4])',...
		'position',[230,185,390,215])

add_block('built-in/Outport',[sys,'/','tmodel1/VIPQ/out_P'])
set_param([sys,'/','tmodel1/VIPQ/out_P'],...
		'Port','3',...
		'position',[450,235,470,255])

add_block('built-in/Outport',[sys,'/','tmodel1/VIPQ/out_Q'])
set_param([sys,'/','tmodel1/VIPQ/out_Q'],...
		'Port','4',...
		'position',[450,285,470,305])

add_block('built-in/Fcn',[sys,'/','tmodel1/VIPQ/Fcn3'])
set_param([sys,'/','tmodel1/VIPQ/Fcn3'],...
		'Expr','sqrt(u[1]*u[1] + u[2]*u[2])',...
		'position',[230,136,390,164])

add_block('built-in/Outport',[sys,'/','tmodel1/VIPQ/out_|I|'])
set_param([sys,'/','tmodel1/VIPQ/out_|I|'],...
		'Port','2',...
		'position',[450,190,470,210])

add_block('built-in/Outport',[sys,'/','tmodel1/VIPQ/out_|Vt|'])
set_param([sys,'/','tmodel1/VIPQ/out_|Vt|'],...
		'position',[450,140,470,160])
add_line([sys,'/','tmodel1/VIPQ'],[70,165;130,165])
add_line([sys,'/','tmodel1/VIPQ'],[70,285;130,285])
add_line([sys,'/','tmodel1/VIPQ'],[390,245;445,245])
add_line([sys,'/','tmodel1/VIPQ'],[390,295;445,295])
add_line([sys,'/','tmodel1/VIPQ'],[170,225;190,225;190,245;225,245])
add_line([sys,'/','tmodel1/VIPQ'],[170,225;190,225;190,295;225,295])
add_line([sys,'/','tmodel1/VIPQ'],[395,150;445,150])
add_line([sys,'/','tmodel1/VIPQ'],[395,200;445,200])
add_line([sys,'/','tmodel1/VIPQ'],[170,225;190,225;190,150;225,150])
add_line([sys,'/','tmodel1/VIPQ'],[170,225;190,225;190,200;225,200])
add_line([sys,'/','tmodel1/VIPQ'],[70,205;130,205])
add_line([sys,'/','tmodel1/VIPQ'],[70,245;130,245])


%     Finished composite block 'tmodel1/VIPQ'.

set_param([sys,'/','tmodel1/VIPQ'],...
		'position',[525,121,570,224])

add_block('built-in/Note',[sys,'/','tmodel1/Ef'])
set_param([sys,'/','tmodel1/Ef'],...
		'position',[135,50,140,55])

add_block('built-in/Note',[sys,'/','tmodel1/delta'])
set_param([sys,'/','tmodel1/delta'],...
		'position',[595,250,600,255])

add_block('built-in/Outport',[sys,'/','tmodel1/out_puslip'])
set_param([sys,'/','tmodel1/out_puslip'],...
		'Port','6',...
		'position',[730,305,750,325])

add_block('built-in/Inport',[sys,'/','tmodel1/in_Tmech'])
set_param([sys,'/','tmodel1/in_Tmech'],...
		'Port','4',...
		'position',[470,355,490,375])

add_block('built-in/Gain',[sys,'/','tmodel1/Gain'])
set_param([sys,'/','tmodel1/Gain'],...
		'orientation',2,...
		'Gain','xq(1)-xpd(1)',...
		'position',[160,364,260,406])


%     Subsystem  'tmodel1/Rotor'.

new_system([sys,'/','tmodel1/Rotor'])
set_param([sys,'/','tmodel1/Rotor'],'Location',[146,198,971,414])

add_block('built-in/Inport',[sys,'/','tmodel1/Rotor/T_mech'])
set_param([sys,'/','tmodel1/Rotor/T_mech'],...
		'Port','5',...
		'position',[280,26,305,54])

add_block('built-in/Outport',[sys,'/','tmodel1/Rotor/out_delta'])
set_param([sys,'/','tmodel1/Rotor/out_delta'],...
		'position',[770,50,790,70])

add_block('built-in/Integrator',[sys,'/','tmodel1/Rotor/slip'])
set_param([sys,'/','tmodel1/Rotor/slip'],...
		'position',[540,42,575,78])

add_block('built-in/Sum',[sys,'/','tmodel1/Rotor/Tacc'])
set_param([sys,'/','tmodel1/Rotor/Tacc'],...
		'inputs','++-',...
		'position',[410,28,430,92])

add_block('built-in/Outport',[sys,'/','tmodel1/Rotor/out_puslip'])
set_param([sys,'/','tmodel1/Rotor/out_puslip'],...
		'Port','2',...
		'position',[765,104,785,126])

add_block('built-in/Sum',[sys,'/','tmodel1/Rotor/wr'])
set_param([sys,'/','tmodel1/Rotor/wr'],...
		'position',[630,130,645,170])

add_block('built-in/Constant',[sys,'/','tmodel1/Rotor/we//wb'])
set_param([sys,'/','tmodel1/Rotor/we//wb'],...
		'position',[535,145,585,175])

add_block('built-in/Gain',[sys,'/','tmodel1/Rotor/gain4'])
set_param([sys,'/','tmodel1/Rotor/gain4'],...
		'Gain','wb',...
		'position',[635,38,685,82])

add_block('built-in/Outport',[sys,'/','tmodel1/Rotor/Tem'])
set_param([sys,'/','tmodel1/Rotor/Tem'],...
		'Port','3',...
		'position',[390,137,415,163])

add_block('built-in/Mux',[sys,'/','tmodel1/Rotor/Mux'])
set_param([sys,'/','tmodel1/Rotor/Mux'],...
		'position',[195,71,215,149])

add_block('built-in/Inport',[sys,'/','tmodel1/Rotor/iq'])
set_param([sys,'/','tmodel1/Rotor/iq'],...
		'Port','3',...
		'position',[105,119,125,141])

add_block('built-in/Fcn',[sys,'/','tmodel1/Rotor/Fcn'])
set_param([sys,'/','tmodel1/Rotor/Fcn'],...
		'Expr','-(u[1]*u[3] + u[2]*u[4])',...
		'position',[230,95,360,125])

add_block('built-in/Inport',[sys,'/','tmodel1/Rotor/Eqp'])
set_param([sys,'/','tmodel1/Rotor/Eqp'],...
		'position',[105,29,125,51])

add_block('built-in/Inport',[sys,'/','tmodel1/Rotor/id'])
set_param([sys,'/','tmodel1/Rotor/id'],...
		'Port','4',...
		'position',[105,164,125,186])

add_block('built-in/Integrator',[sys,'/','tmodel1/Rotor/delta'])
set_param([sys,'/','tmodel1/Rotor/delta'],...
		'Initial','delio(1)',...
		'position',[700,42,735,78])

add_block('built-in/Gain',[sys,'/','tmodel1/Rotor/gain2'])
set_param([sys,'/','tmodel1/Rotor/gain2'],...
		'Gain','1/(2*H(1))',...
		'position',[450,38,525,82])

add_block('built-in/Gain',[sys,'/','tmodel1/Rotor/Damp'])
set_param([sys,'/','tmodel1/Rotor/Damp'],...
		'orientation',2,...
		'Gain','Domega(2)',...
		'position',[430,96,530,134])

add_block('built-in/Inport',[sys,'/','tmodel1/Rotor/Edp'])
set_param([sys,'/','tmodel1/Rotor/Edp'],...
		'Port','2',...
		'position',[105,79,125,101])
add_line([sys,'/','tmodel1/Rotor'],[580,60;605,60;605,140;625,140])
add_line([sys,'/','tmodel1/Rotor'],[425,115;385,115;385,80;405,80])
add_line([sys,'/','tmodel1/Rotor'],[310,40;405,40])
add_line([sys,'/','tmodel1/Rotor'],[740,60;765,60])
add_line([sys,'/','tmodel1/Rotor'],[590,160;625,160])
add_line([sys,'/','tmodel1/Rotor'],[530,60;535,60])
add_line([sys,'/','tmodel1/Rotor'],[690,60;695,60])
add_line([sys,'/','tmodel1/Rotor'],[580,60;605,60;605,115;760,115])
add_line([sys,'/','tmodel1/Rotor'],[130,90;155,90;155,100;190,100])
add_line([sys,'/','tmodel1/Rotor'],[130,40;155,40;155,80;190,80])
add_line([sys,'/','tmodel1/Rotor'],[220,110;225,110])
add_line([sys,'/','tmodel1/Rotor'],[365,110;370,110;370,60;405,60])
add_line([sys,'/','tmodel1/Rotor'],[365,110;370,110;370,150;385,150])
add_line([sys,'/','tmodel1/Rotor'],[130,130;155,130;155,120;190,120])
add_line([sys,'/','tmodel1/Rotor'],[130,175;155,175;155,140;190,140])
add_line([sys,'/','tmodel1/Rotor'],[580,60;630,60])
add_line([sys,'/','tmodel1/Rotor'],[580,60;605,60;605,115;535,115])
add_line([sys,'/','tmodel1/Rotor'],[435,60;445,60])


%     Finished composite block 'tmodel1/Rotor'.

set_param([sys,'/','tmodel1/Rotor'],...
		'Font Number',3,...
		'position',[525,252,575,378])

add_block('built-in/Outport',[sys,'/','tmodel1/out_delta'])
set_param([sys,'/','tmodel1/out_delta'],...
		'Port','5',...
		'position',[670,265,690,285])

add_block('built-in/Outport',[sys,'/','tmodel1/out_Tem'])
set_param([sys,'/','tmodel1/out_Tem'],...
		'Port','7',...
		'position',[675,345,695,365])

add_block('built-in/Inport',[sys,'/','tmodel1/in_ide'])
set_param([sys,'/','tmodel1/in_ide'],...
		'Port','3',...
		'position',[50,312,70,338])

add_block('built-in/Note',[sys,'/','tmodel1/iq_'])
set_param([sys,'/','tmodel1/iq_'],...
		'position',[285,355,290,360])


%     Subsystem  'tmodel1/stator_wdg'.

new_system([sys,'/','tmodel1/stator_wdg'])
set_param([sys,'/','tmodel1/stator_wdg'],'Location',[171,185,701,456])

add_block('built-in/Fcn',[sys,'/','tmodel1/stator_wdg/Fcn2'])
set_param([sys,'/','tmodel1/stator_wdg/Fcn2'],...
		'Expr','u[1] -rs(1)*u[3]- xpd(1)*u[4] ',...
		'position',[220,76,390,104])

add_block('built-in/Outport',[sys,'/','tmodel1/stator_wdg/out_vqt'])
set_param([sys,'/','tmodel1/stator_wdg/out_vqt'],...
		'position',[420,80,440,100])

add_block('built-in/Mux',[sys,'/','tmodel1/stator_wdg/Mux1'])
set_param([sys,'/','tmodel1/stator_wdg/Mux1'],...
		'position',[150,45,175,220])

add_block('built-in/Inport',[sys,'/','tmodel1/stator_wdg/Eqp'])
set_param([sys,'/','tmodel1/stator_wdg/Eqp'],...
		'position',[40,55,60,75])

add_block('built-in/Inport',[sys,'/','tmodel1/stator_wdg/Edp'])
set_param([sys,'/','tmodel1/stator_wdg/Edp'],...
		'Port','2',...
		'position',[40,98,60,122])

add_block('built-in/Inport',[sys,'/','tmodel1/stator_wdg/iq'])
set_param([sys,'/','tmodel1/stator_wdg/iq'],...
		'Port','3',...
		'position',[40,143,60,167])

add_block('built-in/Inport',[sys,'/','tmodel1/stator_wdg/id'])
set_param([sys,'/','tmodel1/stator_wdg/id'],...
		'Port','4',...
		'position',[40,190,60,210])

add_block('built-in/Fcn',[sys,'/','tmodel1/stator_wdg/Fcn3'])
set_param([sys,'/','tmodel1/stator_wdg/Fcn3'],...
		'Expr','u[2] + xpd(1)*u[3] - rs(1)*u[4]',...
		'position',[215,166,385,194])

add_block('built-in/Outport',[sys,'/','tmodel1/stator_wdg/out_vdt'])
set_param([sys,'/','tmodel1/stator_wdg/out_vdt'],...
		'Port','2',...
		'position',[420,170,440,190])
add_line([sys,'/','tmodel1/stator_wdg'],[65,65;145,65])
add_line([sys,'/','tmodel1/stator_wdg'],[180,135;190,135;190,90;215,90])
add_line([sys,'/','tmodel1/stator_wdg'],[180,135;190,135;190,180;210,180])
add_line([sys,'/','tmodel1/stator_wdg'],[395,90;415,90])
add_line([sys,'/','tmodel1/stator_wdg'],[390,180;415,180])
add_line([sys,'/','tmodel1/stator_wdg'],[65,155;145,155])
add_line([sys,'/','tmodel1/stator_wdg'],[65,200;145,200])
add_line([sys,'/','tmodel1/stator_wdg'],[65,110;145,110])


%     Finished composite block 'tmodel1/stator_wdg'.

set_param([sys,'/','tmodel1/stator_wdg'],...
		'position',[405,162,445,238])

add_block('built-in/Note',[sys,'/','tmodel1/id_'])
set_param([sys,'/','tmodel1/id_'],...
		'position',[280,210,285,215])

add_block('built-in/Gain',[sys,'/','tmodel1/Gain2'])
set_param([sys,'/','tmodel1/Gain2'],...
		'orientation',2,...
		'Gain','xd(1)-xpd(1)',...
		'position',[155,206,255,254])


%     Subsystem  'tmodel1/qdr2qde'.

new_system([sys,'/','tmodel1/qdr2qde'])
set_param([sys,'/','tmodel1/qdr2qde'],'Location',[268,603,791,790])

add_block('built-in/Inport',[sys,'/','tmodel1/qdr2qde/Edp'])
set_param([sys,'/','tmodel1/qdr2qde/Edp'],...
		'Port','2',...
		'position',[15,80,35,100])

add_block('built-in/Inport',[sys,'/','tmodel1/qdr2qde/delta'])
set_param([sys,'/','tmodel1/qdr2qde/delta'],...
		'Port','3',...
		'position',[15,120,35,140])

add_block('built-in/Inport',[sys,'/','tmodel1/qdr2qde/Eqp'])
set_param([sys,'/','tmodel1/qdr2qde/Eqp'],...
		'position',[15,40,35,60])

add_block('built-in/Mux',[sys,'/','tmodel1/qdr2qde/Mux'])
set_param([sys,'/','tmodel1/qdr2qde/Mux'],...
		'hide name',0,...
		'inputs','3',...
		'position',[75,27,100,153])

add_block('built-in/Fcn',[sys,'/','tmodel1/qdr2qde/fcn'])
set_param([sys,'/','tmodel1/qdr2qde/fcn'],...
		'Expr','u[1]*cos(u[3]) + u[2]*sin(u[3])',...
		'position',[155,36,360,64])

add_block('built-in/Outport',[sys,'/','tmodel1/qdr2qde/Eqpe'])
set_param([sys,'/','tmodel1/qdr2qde/Eqpe'],...
		'position',[420,40,440,60])

add_block('built-in/Outport',[sys,'/','tmodel1/qdr2qde/Edpe'])
set_param([sys,'/','tmodel1/qdr2qde/Edpe'],...
		'Port','2',...
		'position',[420,120,440,140])

add_block('built-in/Fcn',[sys,'/','tmodel1/qdr2qde/fcn1'])
set_param([sys,'/','tmodel1/qdr2qde/fcn1'],...
		'Expr','-u[1]*sin(u[3]) + u[2]*cos(u[3])',...
		'position',[150,116,360,144])
add_line([sys,'/','tmodel1/qdr2qde'],[365,130;415,130])
add_line([sys,'/','tmodel1/qdr2qde'],[40,50;70,50])
add_line([sys,'/','tmodel1/qdr2qde'],[365,50;415,50])
add_line([sys,'/','tmodel1/qdr2qde'],[105,90;125,90;125,50;150,50])
add_line([sys,'/','tmodel1/qdr2qde'],[105,90;125,90;125,130;145,130])
add_line([sys,'/','tmodel1/qdr2qde'],[40,90;70,90])
add_line([sys,'/','tmodel1/qdr2qde'],[40,130;70,130])


%     Finished composite block 'tmodel1/qdr2qde'.

set_param([sys,'/','tmodel1/qdr2qde'],...
		'position',[525,432,565,488])

add_block('built-in/Outport',[sys,'/','tmodel1/out_Eqpe'])
set_param([sys,'/','tmodel1/out_Eqpe'],...
		'Port','8',...
		'position',[725,435,745,455])


%     Subsystem  'tmodel1/qde2qdr'.

new_system([sys,'/','tmodel1/qde2qdr'])
set_param([sys,'/','tmodel1/qde2qdr'],'Location',[103,460,628,647])

add_block('built-in/Mux',[sys,'/','tmodel1/qde2qdr/Mux'])
set_param([sys,'/','tmodel1/qde2qdr/Mux'],...
		'hide name',0,...
		'inputs','3',...
		'position',[75,50,105,130])

add_block('built-in/Fcn',[sys,'/','tmodel1/qde2qdr/fcn'])
set_param([sys,'/','tmodel1/qde2qdr/fcn'],...
		'Expr','u[1]*cos(u[3]) - u[2]*sin(u[3])',...
		'position',[150,52,390,78])

add_block('built-in/Fcn',[sys,'/','tmodel1/qde2qdr/fcn1'])
set_param([sys,'/','tmodel1/qde2qdr/fcn1'],...
		'Expr','u[1]*sin(u[3]) + u[2]*cos(u[3])',...
		'position',[150,97,390,123])

add_block('built-in/Inport',[sys,'/','tmodel1/qde2qdr/ide'])
set_param([sys,'/','tmodel1/qde2qdr/ide'],...
		'Port','2',...
		'position',[15,80,35,100])

add_block('built-in/Inport',[sys,'/','tmodel1/qde2qdr/delta '])
set_param([sys,'/','tmodel1/qde2qdr/delta '],...
		'Port','3',...
		'position',[15,124,35,146])

add_block('built-in/Inport',[sys,'/','tmodel1/qde2qdr/iqe'])
set_param([sys,'/','tmodel1/qde2qdr/iqe'],...
		'position',[15,35,35,55])

add_block('built-in/Outport',[sys,'/','tmodel1/qde2qdr/vdr'])
set_param([sys,'/','tmodel1/qde2qdr/vdr'],...
		'Port','2',...
		'position',[445,100,465,120])

add_block('built-in/Outport',[sys,'/','tmodel1/qde2qdr/iqr'])
set_param([sys,'/','tmodel1/qde2qdr/iqr'],...
		'position',[445,55,465,75])
add_line([sys,'/','tmodel1/qde2qdr'],[395,110;440,110])
add_line([sys,'/','tmodel1/qde2qdr'],[40,45;50,45;50,65;70,65])
add_line([sys,'/','tmodel1/qde2qdr'],[395,65;440,65])
add_line([sys,'/','tmodel1/qde2qdr'],[110,90;125,90;125,65;145,65])
add_line([sys,'/','tmodel1/qde2qdr'],[110,90;125,90;125,110;145,110])
add_line([sys,'/','tmodel1/qde2qdr'],[40,135;50,135;50,115;70,115])
add_line([sys,'/','tmodel1/qde2qdr'],[40,90;70,90])


%     Finished composite block 'tmodel1/qde2qdr'.

set_param([sys,'/','tmodel1/qde2qdr'],...
		'position',[135,299,175,351])

add_block('built-in/Note',[sys,'/','tmodel1/iq'])
set_param([sys,'/','tmodel1/iq'],...
		'position',[195,295,200,300])

add_block('built-in/Note',[sys,'/','tmodel1/id'])
set_param([sys,'/','tmodel1/id'],...
		'position',[190,320,195,325])

add_block('built-in/Switch',[sys,'/','tmodel1/Sw'])
set_param([sys,'/','tmodel1/Sw'],...
		'orientation',2,...
		'Threshold','0.5',...
		'position',[190,37,205,113])

add_block('built-in/Constant',[sys,'/','tmodel1/Exc_sw'])
set_param([sys,'/','tmodel1/Exc_sw'],...
		'orientation',2,...
		'Value','Exc_sw(2)',...
		'position',[270,66,340,84])

add_block('built-in/Inport',[sys,'/','tmodel1/in_Vref'])
set_param([sys,'/','tmodel1/in_Vref'],...
		'position',[435,65,455,85])


%     Subsystem  'tmodel1/exciter'.

new_system([sys,'/','tmodel1/exciter'])
set_param([sys,'/','tmodel1/exciter'],'Location',[149,293,965,637])

add_block('built-in/Integrator',[sys,'/','tmodel1/exciter/VR'])
set_param([sys,'/','tmodel1/exciter/VR'],...
		'Initial','VR(2)',...
		'position',[325,89,355,121])

add_block('built-in/Sum',[sys,'/','tmodel1/exciter/Sum1'])
set_param([sys,'/','tmodel1/exciter/Sum1'],...
		'inputs','-+',...
		'position',[460,68,475,117])

add_block('built-in/Saturation',[sys,'/','tmodel1/exciter/VRmax//VRmin'])
set_param([sys,'/','tmodel1/exciter/VRmax//VRmin'],...
		'Lower Limit','VRmin(2)',...
		'Upper Limit','VRmax(2)',...
		'position',[385,82,435,128])

add_block('built-in/Gain',[sys,'/','tmodel1/exciter/Gain2'])
set_param([sys,'/','tmodel1/exciter/Gain2'],...
		'Gain','1/TE(2)',...
		'position',[500,77,565,113])

add_block('built-in/Gain',[sys,'/','tmodel1/exciter/Gain3'])
set_param([sys,'/','tmodel1/exciter/Gain3'],...
		'orientation',2,...
		'Gain','KE(2)/TE(2)',...
		'position',[575,157,685,193])

add_block('built-in/Fcn',[sys,'/','tmodel1/exciter/Se'])
set_param([sys,'/','tmodel1/exciter/Se'],...
		'orientation',2,...
		'Expr','AEx(2)*exp(BEx(2)*u[1])',...
		'position',[480,21,660,49])

add_block('built-in/Outport',[sys,'/','tmodel1/exciter/out_Ef'])
set_param([sys,'/','tmodel1/exciter/out_Ef'],...
		'position',[745,95,765,115])

add_block('built-in/Inport',[sys,'/','tmodel1/exciter/Vref'])
set_param([sys,'/','tmodel1/exciter/Vref'],...
		'position',[55,55,75,75])

add_block('built-in/Inport',[sys,'/','tmodel1/exciter/Vt'])
set_param([sys,'/','tmodel1/exciter/Vt'],...
		'Port','2',...
		'position',[55,105,75,125])

add_block('built-in/Sum',[sys,'/','tmodel1/exciter/Sum'])
set_param([sys,'/','tmodel1/exciter/Sum'],...
		'inputs','+--',...
		'position',[135,62,150,128])

add_block('built-in/Gain',[sys,'/','tmodel1/exciter/Gain'])
set_param([sys,'/','tmodel1/exciter/Gain'],...
		'Gain','KA(2)/TA(2)',...
		'position',[170,74,265,116])

add_block('built-in/Gain',[sys,'/','tmodel1/exciter/Gain1'])
set_param([sys,'/','tmodel1/exciter/Gain1'],...
		'orientation',2,...
		'Gain','1/TA(2)',...
		'position',[265,158,350,192])

add_block('built-in/Gain',[sys,'/','tmodel1/exciter/Gain4'])
set_param([sys,'/','tmodel1/exciter/Gain4'],...
		'orientation',2,...
		'Gain','KF(2)/TF(2)',...
		'position',[405,216,520,254])

add_block('built-in/Integrator',[sys,'/','tmodel1/exciter/Ef'])
set_param([sys,'/','tmodel1/exciter/Ef'],...
		'Initial','Ef(2)',...
		'position',[645,90,675,120])

add_block('built-in/Integrator',[sys,'/','tmodel1/exciter/Vs'])
set_param([sys,'/','tmodel1/exciter/Vs'],...
		'Initial','Vs(2)',...
		'position',[345,277,380,313])

add_block('built-in/Note',[sys,'/','tmodel1/exciter/Vstab'])
set_param([sys,'/','tmodel1/exciter/Vstab'],...
		'position',[150,225,155,230])

add_block('built-in/Sum',[sys,'/','tmodel1/exciter/Sum2'])
set_param([sys,'/','tmodel1/exciter/Sum2'],...
		'inputs','+-',...
		'position',[290,84,305,126])

add_block('built-in/Sum',[sys,'/','tmodel1/exciter/Sum3'])
set_param([sys,'/','tmodel1/exciter/Sum3'],...
		'inputs','+-',...
		'position',[600,84,615,126])

add_block('built-in/Sum',[sys,'/','tmodel1/exciter/Sum4'])
set_param([sys,'/','tmodel1/exciter/Sum4'],...
		'orientation',2,...
		'inputs','+-',...
		'position',[305,226,320,264])

add_block('built-in/Gain',[sys,'/','tmodel1/exciter/Gain5'])
set_param([sys,'/','tmodel1/exciter/Gain5'],...
		'Gain','1/TF(2)',...
		'position',[240,274,305,316])
add_line([sys,'/','tmodel1/exciter'],[80,115;95,115;95,95;130,95])
add_line([sys,'/','tmodel1/exciter'],[440,105;455,105])
add_line([sys,'/','tmodel1/exciter'],[80,65;100,65;100,75;130,75])
add_line([sys,'/','tmodel1/exciter'],[475,35;440,35;440,80;455,80])
add_line([sys,'/','tmodel1/exciter'],[310,105;320,105])
add_line([sys,'/','tmodel1/exciter'],[155,95;165,95])
add_line([sys,'/','tmodel1/exciter'],[360,105;380,105])
add_line([sys,'/','tmodel1/exciter'],[360,105;365,105;355,175])
add_line([sys,'/','tmodel1/exciter'],[620,105;640,105])
add_line([sys,'/','tmodel1/exciter'],[680,105;710,105;710,175;690,175])
add_line([sys,'/','tmodel1/exciter'],[480,95;495,95])
add_line([sys,'/','tmodel1/exciter'],[570,95;595,95])
add_line([sys,'/','tmodel1/exciter'],[570,175;565,175;565,115;595,115])
add_line([sys,'/','tmodel1/exciter'],[680,105;710,105;710,35;665,35])
add_line([sys,'/','tmodel1/exciter'],[680,105;740,105])
add_line([sys,'/','tmodel1/exciter'],[270,95;285,95])
add_line([sys,'/','tmodel1/exciter'],[260,175;250,175;250,115;285,115])
add_line([sys,'/','tmodel1/exciter'],[400,235;325,235])
add_line([sys,'/','tmodel1/exciter'],[310,295;340,295])
add_line([sys,'/','tmodel1/exciter'],[385,295;405,295;405,255;325,255])
add_line([sys,'/','tmodel1/exciter'],[680,105;710,105;710,235;525,235])
add_line([sys,'/','tmodel1/exciter'],[300,245;110,245;110,115;130,115])
add_line([sys,'/','tmodel1/exciter'],[300,245;205,245;205,295;235,295])


%     Finished composite block 'tmodel1/exciter'.

set_param([sys,'/','tmodel1/exciter'],...
		'position',[625,64,665,111])
add_line([sys,'/','tmodel1'],[290,170;400,170])
add_line([sys,'/','tmodel1'],[580,275;635,275;635,510;100,510;100,340;130,340])
add_line([sys,'/','tmodel1'],[575,135;605,135;605,100;620,100])
add_line([sys,'/','tmodel1'],[290,170;370,170;370,265;520,265])
add_line([sys,'/','tmodel1'],[290,170;300,170;300,135;110,135;110,150;125,150])
add_line([sys,'/','tmodel1'],[245,170;250,170])
add_line([sys,'/','tmodel1'],[150,170;155,170])
add_line([sys,'/','tmodel1'],[150,230;105,230;105,190;125,190])
add_line([sys,'/','tmodel1'],[670,90;730,90;730,50;210,50])
add_line([sys,'/','tmodel1'],[265,75;210,75])
add_line([sys,'/','tmodel1'],[185,75;100,75;100,170;125,170])
add_line([sys,'/','tmodel1'],[460,75;620,75])
add_line([sys,'/','tmodel1'],[575,160;725,160])
add_line([sys,'/','tmodel1'],[575,185;670,185])
add_line([sys,'/','tmodel1'],[575,210;725,210])
add_line([sys,'/','tmodel1'],[580,275;665,275])
add_line([sys,'/','tmodel1'],[580,315;725,315])
add_line([sys,'/','tmodel1'],[75,280;95,280;95,310;130,310])
add_line([sys,'/','tmodel1'],[580,355;670,355])
add_line([sys,'/','tmodel1'],[450,180;460,180;460,135;520,135])
add_line([sys,'/','tmodel1'],[575,135;670,135])
add_line([sys,'/','tmodel1'],[570,445;720,445])
add_line([sys,'/','tmodel1'],[570,475;665,475])
add_line([sys,'/','tmodel1'],[580,275;635,275;635,510;490,510;490,480;520,480])
add_line([sys,'/','tmodel1'],[290,170;370,170;370,440;520,440])
add_line([sys,'/','tmodel1'],[180,340;280,340;280,230;260,230])
add_line([sys,'/','tmodel1'],[495,365;520,365])
add_line([sys,'/','tmodel1'],[155,385;115,385;115,465;140,465])
add_line([sys,'/','tmodel1'],[325,460;335,460;335,420;125,420;125,450;140,450])
add_line([sys,'/','tmodel1'],[325,460;335,460;335,290;520,290])
add_line([sys,'/','tmodel1'],[325,460;335,460;335,190;400,190])
add_line([sys,'/','tmodel1'],[165,460;175,460])
add_line([sys,'/','tmodel1'],[270,460;285,460])
add_line([sys,'/','tmodel1'],[180,315;310,315;310,385;265,385])
add_line([sys,'/','tmodel1'],[180,315;520,315])
add_line([sys,'/','tmodel1'],[180,340;520,340])
add_line([sys,'/','tmodel1'],[180,315;310,315;310,210;400,210])
add_line([sys,'/','tmodel1'],[180,340;280,340;280,230;400,230])
add_line([sys,'/','tmodel1'],[75,325;130,325])
add_line([sys,'/','tmodel1'],[325,460;520,460])
add_line([sys,'/','tmodel1'],[180,340;500,340;500,210;520,210])
add_line([sys,'/','tmodel1'],[450,220;470,220;470,160;520,160])
add_line([sys,'/','tmodel1'],[180,315;485,315;485,185;520,185])
add_line([sys,'/','tmodel1'],[460,75;505,75;505,100;210,100])


%     Finished composite block 'tmodel1'.

set_param([sys,'/','tmodel1'],...
		'position',[155,363,210,487])


%     Subsystem  'tmodel'.

new_system([sys,'/','tmodel'])
set_param([sys,'/','tmodel'],'Location',[250,148,1029,698])

add_block('built-in/Note',[sys,'/','tmodel/Eqp_'])
set_param([sys,'/','tmodel/Eqp_'],...
		'position',[320,150,325,155])

add_block('built-in/Integrator',[sys,'/','tmodel/Eqp'])
set_param([sys,'/','tmodel/Eqp'],...
		'Initial','Eqpo(1)',...
		'position',[255,154,285,186])

add_block('built-in/Sum',[sys,'/','tmodel/sum'])
set_param([sys,'/','tmodel/sum'],...
		'inputs','-+-',...
		'position',[130,143,145,197])

add_block('built-in/Gain',[sys,'/','tmodel/1//Tpdo'])
set_param([sys,'/','tmodel/1//Tpdo'],...
		'Gain','1/Tpdo(1)',...
		'position',[160,149,240,191])

add_block('built-in/Outport',[sys,'/','tmodel/out_Pgen'])
set_param([sys,'/','tmodel/out_Pgen'],...
		'Port','3',...
		'position',[675,175,695,195])

add_block('built-in/Outport',[sys,'/','tmodel/out_|I|'])
set_param([sys,'/','tmodel/out_|I|'],...
		'Port','2',...
		'position',[730,150,750,170])

add_block('built-in/Outport',[sys,'/','tmodel/out_|Vt|'])
set_param([sys,'/','tmodel/out_|Vt|'],...
		'position',[675,125,695,145])

add_block('built-in/Outport',[sys,'/','tmodel/out_Qgen'])
set_param([sys,'/','tmodel/out_Qgen'],...
		'Port','4',...
		'position',[730,200,750,220])

add_block('built-in/Sum',[sys,'/','tmodel/Sum'])
set_param([sys,'/','tmodel/Sum'],...
		'inputs','-+',...
		'position',[145,440,160,475])

add_block('built-in/Gain',[sys,'/','tmodel/Gain1'])
set_param([sys,'/','tmodel/Gain1'],...
		'Gain','1/Tpqo(1)',...
		'position',[180,441,265,479])

add_block('built-in/Integrator',[sys,'/','tmodel/Edp'])
set_param([sys,'/','tmodel/Edp'],...
		'Initial','Edpo(1)',...
		'position',[290,443,320,477])

add_block('built-in/Outport',[sys,'/','tmodel/out_Edpe'])
set_param([sys,'/','tmodel/out_Edpe'],...
		'Port','9',...
		'position',[670,465,690,485])

add_block('built-in/Inport',[sys,'/','tmodel/in_iqe'])
set_param([sys,'/','tmodel/in_iqe'],...
		'Port','2',...
		'position',[50,270,70,290])

add_block('built-in/Note',[sys,'/','tmodel/|Vt|'])
set_param([sys,'/','tmodel/|Vt|'],...
		'position',[585,110,590,115])


%     Subsystem  'tmodel/VIPQ'.

new_system([sys,'/','tmodel/VIPQ'])
set_param([sys,'/','tmodel/VIPQ'],'Location',[206,374,894,807])

add_block('built-in/Mux',[sys,'/','tmodel/VIPQ/Mux'])
set_param([sys,'/','tmodel/VIPQ/Mux'],...
		'position',[135,143,165,307])

add_block('built-in/Inport',[sys,'/','tmodel/VIPQ/vqt'])
set_param([sys,'/','tmodel/VIPQ/vqt'],...
		'position',[45,155,65,175])

add_block('built-in/Inport',[sys,'/','tmodel/VIPQ/vdt'])
set_param([sys,'/','tmodel/VIPQ/vdt'],...
		'Port','2',...
		'position',[45,195,65,215])

add_block('built-in/Inport',[sys,'/','tmodel/VIPQ/iq'])
set_param([sys,'/','tmodel/VIPQ/iq'],...
		'Port','3',...
		'position',[45,235,65,255])

add_block('built-in/Inport',[sys,'/','tmodel/VIPQ/id'])
set_param([sys,'/','tmodel/VIPQ/id'],...
		'Port','4',...
		'position',[45,275,65,295])

add_block('built-in/Fcn',[sys,'/','tmodel/VIPQ/Fcn'])
set_param([sys,'/','tmodel/VIPQ/Fcn'],...
		'Expr','u[1]*u[3] + u[2]*u[4]',...
		'position',[230,232,385,258])

add_block('built-in/Fcn',[sys,'/','tmodel/VIPQ/Fcn1'])
set_param([sys,'/','tmodel/VIPQ/Fcn1'],...
		'Expr','u[1]*u[4] - u[2]*u[3]',...
		'position',[230,282,385,308])

add_block('built-in/Fcn',[sys,'/','tmodel/VIPQ/Fcn2'])
set_param([sys,'/','tmodel/VIPQ/Fcn2'],...
		'Expr','sqrt(u[3]*u[3] + u[4]*u[4])',...
		'position',[230,185,390,215])

add_block('built-in/Outport',[sys,'/','tmodel/VIPQ/out_P'])
set_param([sys,'/','tmodel/VIPQ/out_P'],...
		'Port','3',...
		'position',[450,235,470,255])

add_block('built-in/Outport',[sys,'/','tmodel/VIPQ/out_Q'])
set_param([sys,'/','tmodel/VIPQ/out_Q'],...
		'Port','4',...
		'position',[450,285,470,305])

add_block('built-in/Fcn',[sys,'/','tmodel/VIPQ/Fcn3'])
set_param([sys,'/','tmodel/VIPQ/Fcn3'],...
		'Expr','sqrt(u[1]*u[1] + u[2]*u[2])',...
		'position',[230,136,390,164])

add_block('built-in/Outport',[sys,'/','tmodel/VIPQ/out_|I|'])
set_param([sys,'/','tmodel/VIPQ/out_|I|'],...
		'Port','2',...
		'position',[450,190,470,210])

add_block('built-in/Outport',[sys,'/','tmodel/VIPQ/out_|Vt|'])
set_param([sys,'/','tmodel/VIPQ/out_|Vt|'],...
		'position',[450,140,470,160])
add_line([sys,'/','tmodel/VIPQ'],[70,165;130,165])
add_line([sys,'/','tmodel/VIPQ'],[70,285;130,285])
add_line([sys,'/','tmodel/VIPQ'],[390,245;445,245])
add_line([sys,'/','tmodel/VIPQ'],[390,295;445,295])
add_line([sys,'/','tmodel/VIPQ'],[170,225;190,225;190,245;225,245])
add_line([sys,'/','tmodel/VIPQ'],[170,225;190,225;190,295;225,295])
add_line([sys,'/','tmodel/VIPQ'],[395,150;445,150])
add_line([sys,'/','tmodel/VIPQ'],[395,200;445,200])
add_line([sys,'/','tmodel/VIPQ'],[170,225;190,225;190,150;225,150])
add_line([sys,'/','tmodel/VIPQ'],[170,225;190,225;190,200;225,200])
add_line([sys,'/','tmodel/VIPQ'],[70,205;130,205])
add_line([sys,'/','tmodel/VIPQ'],[70,245;130,245])


%     Finished composite block 'tmodel/VIPQ'.

set_param([sys,'/','tmodel/VIPQ'],...
		'position',[525,121,570,224])

add_block('built-in/Switch',[sys,'/','tmodel/Sw'])
set_param([sys,'/','tmodel/Sw'],...
		'orientation',2,...
		'Threshold','0.5',...
		'position',[190,42,205,118])


%     Subsystem  'tmodel/exciter'.

new_system([sys,'/','tmodel/exciter'])
set_param([sys,'/','tmodel/exciter'],'Location',[149,293,965,637])

add_block('built-in/Integrator',[sys,'/','tmodel/exciter/VR'])
set_param([sys,'/','tmodel/exciter/VR'],...
		'Initial','VR(1)',...
		'position',[325,89,355,121])

add_block('built-in/Sum',[sys,'/','tmodel/exciter/Sum1'])
set_param([sys,'/','tmodel/exciter/Sum1'],...
		'inputs','-+',...
		'position',[460,68,475,117])

add_block('built-in/Saturation',[sys,'/','tmodel/exciter/VRmax//VRmin'])
set_param([sys,'/','tmodel/exciter/VRmax//VRmin'],...
		'Lower Limit','VRmin(1)',...
		'Upper Limit','VRmax(1)',...
		'position',[385,82,435,128])

add_block('built-in/Gain',[sys,'/','tmodel/exciter/Gain2'])
set_param([sys,'/','tmodel/exciter/Gain2'],...
		'Gain','1/TE(1)',...
		'position',[500,77,565,113])

add_block('built-in/Gain',[sys,'/','tmodel/exciter/Gain3'])
set_param([sys,'/','tmodel/exciter/Gain3'],...
		'orientation',2,...
		'Gain','KE(1)/TE(1)',...
		'position',[575,157,685,193])

add_block('built-in/Fcn',[sys,'/','tmodel/exciter/Se'])
set_param([sys,'/','tmodel/exciter/Se'],...
		'orientation',2,...
		'Expr','AEx(1)*exp(BEx(1)*u[1])',...
		'position',[480,21,660,49])

add_block('built-in/Outport',[sys,'/','tmodel/exciter/out_Ef'])
set_param([sys,'/','tmodel/exciter/out_Ef'],...
		'position',[745,95,765,115])

add_block('built-in/Inport',[sys,'/','tmodel/exciter/Vref'])
set_param([sys,'/','tmodel/exciter/Vref'],...
		'position',[55,55,75,75])

add_block('built-in/Inport',[sys,'/','tmodel/exciter/Vt'])
set_param([sys,'/','tmodel/exciter/Vt'],...
		'Port','2',...
		'position',[55,105,75,125])

add_block('built-in/Sum',[sys,'/','tmodel/exciter/Sum'])
set_param([sys,'/','tmodel/exciter/Sum'],...
		'inputs','+--',...
		'position',[135,62,150,128])

add_block('built-in/Gain',[sys,'/','tmodel/exciter/Gain'])
set_param([sys,'/','tmodel/exciter/Gain'],...
		'Gain','KA(1)/TA(1)',...
		'position',[170,74,265,116])

add_block('built-in/Gain',[sys,'/','tmodel/exciter/Gain1'])
set_param([sys,'/','tmodel/exciter/Gain1'],...
		'orientation',2,...
		'Gain','1/TA(1)',...
		'position',[265,158,350,192])

add_block('built-in/Gain',[sys,'/','tmodel/exciter/Gain5'])
set_param([sys,'/','tmodel/exciter/Gain5'],...
		'Gain','1/TF(1)',...
		'position',[230,274,295,316])

add_block('built-in/Gain',[sys,'/','tmodel/exciter/Gain4'])
set_param([sys,'/','tmodel/exciter/Gain4'],...
		'orientation',2,...
		'Gain','KF(1)/TF(1)',...
		'position',[405,216,520,254])

add_block('built-in/Integrator',[sys,'/','tmodel/exciter/Ef'])
set_param([sys,'/','tmodel/exciter/Ef'],...
		'Initial','Ef(1)',...
		'position',[645,90,675,120])

add_block('built-in/Integrator',[sys,'/','tmodel/exciter/Vs'])
set_param([sys,'/','tmodel/exciter/Vs'],...
		'Initial','Vs(1)',...
		'position',[345,277,380,313])

add_block('built-in/Note',[sys,'/','tmodel/exciter/Vstab'])
set_param([sys,'/','tmodel/exciter/Vstab'],...
		'position',[150,225,155,230])

add_block('built-in/Sum',[sys,'/','tmodel/exciter/Sum2'])
set_param([sys,'/','tmodel/exciter/Sum2'],...
		'inputs','+-',...
		'position',[290,84,305,126])

add_block('built-in/Sum',[sys,'/','tmodel/exciter/Sum3'])
set_param([sys,'/','tmodel/exciter/Sum3'],...
		'inputs','+-',...
		'position',[600,84,615,126])

add_block('built-in/Sum',[sys,'/','tmodel/exciter/Sum4'])
set_param([sys,'/','tmodel/exciter/Sum4'],...
		'orientation',2,...
		'inputs','+-',...
		'position',[305,226,320,264])
add_line([sys,'/','tmodel/exciter'],[80,115;95,115;95,95;130,95])
add_line([sys,'/','tmodel/exciter'],[440,105;455,105])
add_line([sys,'/','tmodel/exciter'],[80,65;100,65;100,75;130,75])
add_line([sys,'/','tmodel/exciter'],[475,35;440,35;440,80;455,80])
add_line([sys,'/','tmodel/exciter'],[310,105;320,105])
add_line([sys,'/','tmodel/exciter'],[155,95;165,95])
add_line([sys,'/','tmodel/exciter'],[360,105;380,105])
add_line([sys,'/','tmodel/exciter'],[360,105;365,105;355,175])
add_line([sys,'/','tmodel/exciter'],[620,105;640,105])
add_line([sys,'/','tmodel/exciter'],[680,105;710,105;710,175;690,175])
add_line([sys,'/','tmodel/exciter'],[480,95;495,95])
add_line([sys,'/','tmodel/exciter'],[570,95;595,95])
add_line([sys,'/','tmodel/exciter'],[570,175;565,175;565,115;595,115])
add_line([sys,'/','tmodel/exciter'],[680,105;710,105;710,35;665,35])
add_line([sys,'/','tmodel/exciter'],[680,105;740,105])
add_line([sys,'/','tmodel/exciter'],[270,95;285,95])
add_line([sys,'/','tmodel/exciter'],[260,175;250,175;250,115;285,115])
add_line([sys,'/','tmodel/exciter'],[400,235;325,235])
add_line([sys,'/','tmodel/exciter'],[300,295;340,295])
add_line([sys,'/','tmodel/exciter'],[385,295;405,295;405,255;325,255])
add_line([sys,'/','tmodel/exciter'],[680,105;710,105;710,235;525,235])
add_line([sys,'/','tmodel/exciter'],[300,245;110,245;110,115;130,115])
add_line([sys,'/','tmodel/exciter'],[300,245;205,245;205,295;225,295])


%     Finished composite block 'tmodel/exciter'.

set_param([sys,'/','tmodel/exciter'],...
		'position',[625,64,665,111])

add_block('built-in/Outport',[sys,'/','tmodel/out_puslip'])
set_param([sys,'/','tmodel/out_puslip'],...
		'Port','6',...
		'position',[730,305,750,325])

add_block('built-in/Inport',[sys,'/','tmodel/in_Tmech'])
set_param([sys,'/','tmodel/in_Tmech'],...
		'Port','4',...
		'position',[470,355,490,375])

add_block('built-in/Gain',[sys,'/','tmodel/Gain'])
set_param([sys,'/','tmodel/Gain'],...
		'orientation',2,...
		'Gain','xq(1)-xpd(1)',...
		'position',[160,364,260,406])


%     Subsystem  'tmodel/Rotor'.

new_system([sys,'/','tmodel/Rotor'])
set_param([sys,'/','tmodel/Rotor'],'Location',[146,198,971,414])

add_block('built-in/Outport',[sys,'/','tmodel/Rotor/out_delta'])
set_param([sys,'/','tmodel/Rotor/out_delta'],...
		'position',[770,50,790,70])

add_block('built-in/Gain',[sys,'/','tmodel/Rotor/Damp'])
set_param([sys,'/','tmodel/Rotor/Damp'],...
		'orientation',2,...
		'Gain','Domega(1)',...
		'position',[455,96,545,134])

add_block('built-in/Outport',[sys,'/','tmodel/Rotor/out_puslip'])
set_param([sys,'/','tmodel/Rotor/out_puslip'],...
		'Port','2',...
		'position',[765,104,785,126])

add_block('built-in/Sum',[sys,'/','tmodel/Rotor/wr'])
set_param([sys,'/','tmodel/Rotor/wr'],...
		'position',[630,130,645,170])

add_block('built-in/Constant',[sys,'/','tmodel/Rotor/we//wb'])
set_param([sys,'/','tmodel/Rotor/we//wb'],...
		'position',[535,145,585,175])

add_block('built-in/Gain',[sys,'/','tmodel/Rotor/gain4'])
set_param([sys,'/','tmodel/Rotor/gain4'],...
		'Gain','wb',...
		'position',[635,38,685,82])

add_block('built-in/Outport',[sys,'/','tmodel/Rotor/Tem'])
set_param([sys,'/','tmodel/Rotor/Tem'],...
		'Port','3',...
		'position',[390,137,415,163])

add_block('built-in/Mux',[sys,'/','tmodel/Rotor/Mux'])
set_param([sys,'/','tmodel/Rotor/Mux'],...
		'position',[195,71,215,149])

add_block('built-in/Inport',[sys,'/','tmodel/Rotor/iq'])
set_param([sys,'/','tmodel/Rotor/iq'],...
		'Port','3',...
		'position',[105,119,125,141])

add_block('built-in/Fcn',[sys,'/','tmodel/Rotor/Fcn'])
set_param([sys,'/','tmodel/Rotor/Fcn'],...
		'Expr','-(u[1]*u[3] + u[2]*u[4])',...
		'position',[230,95,360,125])

add_block('built-in/Inport',[sys,'/','tmodel/Rotor/Eqp'])
set_param([sys,'/','tmodel/Rotor/Eqp'],...
		'position',[105,29,125,51])

add_block('built-in/Inport',[sys,'/','tmodel/Rotor/id'])
set_param([sys,'/','tmodel/Rotor/id'],...
		'Port','4',...
		'position',[105,164,125,186])

add_block('built-in/Integrator',[sys,'/','tmodel/Rotor/delta'])
set_param([sys,'/','tmodel/Rotor/delta'],...
		'Initial','delio(1)',...
		'position',[700,42,735,78])

add_block('built-in/Sum',[sys,'/','tmodel/Rotor/Tacc'])
set_param([sys,'/','tmodel/Rotor/Tacc'],...
		'inputs','++-',...
		'position',[410,25,430,95])

add_block('built-in/Inport',[sys,'/','tmodel/Rotor/T_mech'])
set_param([sys,'/','tmodel/Rotor/T_mech'],...
		'Port','5',...
		'position',[310,21,335,49])

add_block('built-in/Integrator',[sys,'/','tmodel/Rotor/slip'])
set_param([sys,'/','tmodel/Rotor/slip'],...
		'position',[555,42,590,78])

add_block('built-in/Gain',[sys,'/','tmodel/Rotor/gain2'])
set_param([sys,'/','tmodel/Rotor/gain2'],...
		'Gain','1/(2*H(1))',...
		'position',[460,38,535,82])

add_block('built-in/Inport',[sys,'/','tmodel/Rotor/Edp'])
set_param([sys,'/','tmodel/Rotor/Edp'],...
		'Port','2',...
		'position',[105,79,125,101])
add_line([sys,'/','tmodel/Rotor'],[595,60;605,60;605,140;625,140])
add_line([sys,'/','tmodel/Rotor'],[450,115;385,115;385,85;405,85])
add_line([sys,'/','tmodel/Rotor'],[340,35;405,35])
add_line([sys,'/','tmodel/Rotor'],[740,60;765,60])
add_line([sys,'/','tmodel/Rotor'],[590,160;625,160])
add_line([sys,'/','tmodel/Rotor'],[540,60;550,60])
add_line([sys,'/','tmodel/Rotor'],[690,60;695,60])
add_line([sys,'/','tmodel/Rotor'],[595,60;605,60;605,115;760,115])
add_line([sys,'/','tmodel/Rotor'],[130,90;155,90;155,100;190,100])
add_line([sys,'/','tmodel/Rotor'],[130,40;155,40;155,80;190,80])
add_line([sys,'/','tmodel/Rotor'],[220,110;225,110])
add_line([sys,'/','tmodel/Rotor'],[365,110;370,110;370,60;405,60])
add_line([sys,'/','tmodel/Rotor'],[365,110;370,110;370,150;385,150])
add_line([sys,'/','tmodel/Rotor'],[130,130;155,130;155,120;190,120])
add_line([sys,'/','tmodel/Rotor'],[130,175;155,175;155,140;190,140])
add_line([sys,'/','tmodel/Rotor'],[595,60;630,60])
add_line([sys,'/','tmodel/Rotor'],[595,60;605,60;605,115;550,115])
add_line([sys,'/','tmodel/Rotor'],[435,60;455,60])


%     Finished composite block 'tmodel/Rotor'.

set_param([sys,'/','tmodel/Rotor'],...
		'Font Number',3,...
		'position',[525,252,575,378])

add_block('built-in/Outport',[sys,'/','tmodel/out_delta'])
set_param([sys,'/','tmodel/out_delta'],...
		'Port','5',...
		'position',[670,265,690,285])

add_block('built-in/Outport',[sys,'/','tmodel/out_Tem'])
set_param([sys,'/','tmodel/out_Tem'],...
		'Port','7',...
		'position',[675,345,695,365])

add_block('built-in/Inport',[sys,'/','tmodel/in_ide'])
set_param([sys,'/','tmodel/in_ide'],...
		'Port','3',...
		'position',[50,312,70,338])


%     Subsystem  'tmodel/stator_wdg'.

new_system([sys,'/','tmodel/stator_wdg'])
set_param([sys,'/','tmodel/stator_wdg'],'Location',[171,185,701,456])

add_block('built-in/Fcn',[sys,'/','tmodel/stator_wdg/Fcn2'])
set_param([sys,'/','tmodel/stator_wdg/Fcn2'],...
		'Expr','u[1] -rs(1)*u[3]- xpd(1)*u[4] ',...
		'position',[220,76,390,104])

add_block('built-in/Outport',[sys,'/','tmodel/stator_wdg/out_vqt'])
set_param([sys,'/','tmodel/stator_wdg/out_vqt'],...
		'position',[420,80,440,100])

add_block('built-in/Mux',[sys,'/','tmodel/stator_wdg/Mux1'])
set_param([sys,'/','tmodel/stator_wdg/Mux1'],...
		'position',[150,45,175,220])

add_block('built-in/Inport',[sys,'/','tmodel/stator_wdg/Eqp'])
set_param([sys,'/','tmodel/stator_wdg/Eqp'],...
		'position',[40,55,60,75])

add_block('built-in/Inport',[sys,'/','tmodel/stator_wdg/Edp'])
set_param([sys,'/','tmodel/stator_wdg/Edp'],...
		'Port','2',...
		'position',[40,98,60,122])

add_block('built-in/Inport',[sys,'/','tmodel/stator_wdg/iq'])
set_param([sys,'/','tmodel/stator_wdg/iq'],...
		'Port','3',...
		'position',[40,143,60,167])

add_block('built-in/Inport',[sys,'/','tmodel/stator_wdg/id'])
set_param([sys,'/','tmodel/stator_wdg/id'],...
		'Port','4',...
		'position',[40,190,60,210])

add_block('built-in/Fcn',[sys,'/','tmodel/stator_wdg/Fcn3'])
set_param([sys,'/','tmodel/stator_wdg/Fcn3'],...
		'Expr','u[2] + xpd(1)*u[3] - rs(1)*u[4]',...
		'position',[215,166,385,194])

add_block('built-in/Outport',[sys,'/','tmodel/stator_wdg/out_vdt'])
set_param([sys,'/','tmodel/stator_wdg/out_vdt'],...
		'Port','2',...
		'position',[420,170,440,190])
add_line([sys,'/','tmodel/stator_wdg'],[65,65;145,65])
add_line([sys,'/','tmodel/stator_wdg'],[180,135;190,135;190,90;215,90])
add_line([sys,'/','tmodel/stator_wdg'],[180,135;190,135;190,180;210,180])
add_line([sys,'/','tmodel/stator_wdg'],[395,90;415,90])
add_line([sys,'/','tmodel/stator_wdg'],[390,180;415,180])
add_line([sys,'/','tmodel/stator_wdg'],[65,155;145,155])
add_line([sys,'/','tmodel/stator_wdg'],[65,200;145,200])
add_line([sys,'/','tmodel/stator_wdg'],[65,110;145,110])


%     Finished composite block 'tmodel/stator_wdg'.

set_param([sys,'/','tmodel/stator_wdg'],...
		'position',[405,162,445,238])

add_block('built-in/Note',[sys,'/','tmodel/id_'])
set_param([sys,'/','tmodel/id_'],...
		'position',[280,210,285,215])

add_block('built-in/Gain',[sys,'/','tmodel/Gain2'])
set_param([sys,'/','tmodel/Gain2'],...
		'orientation',2,...
		'Gain','xd(1)-xpd(1)',...
		'position',[155,206,255,254])


%     Subsystem  'tmodel/qdr2qde'.

new_system([sys,'/','tmodel/qdr2qde'])
set_param([sys,'/','tmodel/qdr2qde'],'Location',[268,603,791,790])

add_block('built-in/Inport',[sys,'/','tmodel/qdr2qde/Edp'])
set_param([sys,'/','tmodel/qdr2qde/Edp'],...
		'Port','2',...
		'position',[15,80,35,100])

add_block('built-in/Inport',[sys,'/','tmodel/qdr2qde/delta'])
set_param([sys,'/','tmodel/qdr2qde/delta'],...
		'Port','3',...
		'position',[15,120,35,140])

add_block('built-in/Inport',[sys,'/','tmodel/qdr2qde/Eqp'])
set_param([sys,'/','tmodel/qdr2qde/Eqp'],...
		'position',[15,40,35,60])

add_block('built-in/Mux',[sys,'/','tmodel/qdr2qde/Mux'])
set_param([sys,'/','tmodel/qdr2qde/Mux'],...
		'hide name',0,...
		'inputs','3',...
		'position',[75,27,100,153])

add_block('built-in/Fcn',[sys,'/','tmodel/qdr2qde/fcn'])
set_param([sys,'/','tmodel/qdr2qde/fcn'],...
		'Expr','u[1]*cos(u[3]) + u[2]*sin(u[3])',...
		'position',[155,36,360,64])

add_block('built-in/Outport',[sys,'/','tmodel/qdr2qde/Eqpe'])
set_param([sys,'/','tmodel/qdr2qde/Eqpe'],...
		'position',[420,40,440,60])

add_block('built-in/Outport',[sys,'/','tmodel/qdr2qde/Edpe'])
set_param([sys,'/','tmodel/qdr2qde/Edpe'],...
		'Port','2',...
		'position',[420,120,440,140])

add_block('built-in/Fcn',[sys,'/','tmodel/qdr2qde/fcn1'])
set_param([sys,'/','tmodel/qdr2qde/fcn1'],...
		'Expr','-u[1]*sin(u[3]) + u[2]*cos(u[3])',...
		'position',[150,116,360,144])
add_line([sys,'/','tmodel/qdr2qde'],[365,130;415,130])
add_line([sys,'/','tmodel/qdr2qde'],[40,50;70,50])
add_line([sys,'/','tmodel/qdr2qde'],[365,50;415,50])
add_line([sys,'/','tmodel/qdr2qde'],[105,90;125,90;125,50;150,50])
add_line([sys,'/','tmodel/qdr2qde'],[105,90;125,90;125,130;145,130])
add_line([sys,'/','tmodel/qdr2qde'],[40,90;70,90])
add_line([sys,'/','tmodel/qdr2qde'],[40,130;70,130])


%     Finished composite block 'tmodel/qdr2qde'.

set_param([sys,'/','tmodel/qdr2qde'],...
		'position',[525,432,565,488])

add_block('built-in/Outport',[sys,'/','tmodel/out_Eqpe'])
set_param([sys,'/','tmodel/out_Eqpe'],...
		'Port','8',...
		'position',[725,435,745,455])


%     Subsystem  'tmodel/qde2qdr'.

new_system([sys,'/','tmodel/qde2qdr'])
set_param([sys,'/','tmodel/qde2qdr'],'Location',[103,460,628,647])

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

add_block('built-in/Inport',[sys,'/','tmodel/qde2qdr/ide'])
set_param([sys,'/','tmodel/qde2qdr/ide'],...
		'Port','2',...
		'position',[15,80,35,100])

add_block('built-in/Inport',[sys,'/','tmodel/qde2qdr/delta '])
set_param([sys,'/','tmodel/qde2qdr/delta '],...
		'Port','3',...
		'position',[15,124,35,146])

add_block('built-in/Inport',[sys,'/','tmodel/qde2qdr/iqe'])
set_param([sys,'/','tmodel/qde2qdr/iqe'],...
		'position',[15,35,35,55])

add_block('built-in/Outport',[sys,'/','tmodel/qde2qdr/vdr'])
set_param([sys,'/','tmodel/qde2qdr/vdr'],...
		'Port','2',...
		'position',[445,100,465,120])

add_block('built-in/Outport',[sys,'/','tmodel/qde2qdr/iqr'])
set_param([sys,'/','tmodel/qde2qdr/iqr'],...
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
		'position',[135,299,175,351])

add_block('built-in/Note',[sys,'/','tmodel/iq'])
set_param([sys,'/','tmodel/iq'],...
		'position',[195,295,200,300])

add_block('built-in/Note',[sys,'/','tmodel/id'])
set_param([sys,'/','tmodel/id'],...
		'position',[190,320,195,325])

add_block('built-in/Note',[sys,'/','tmodel/delta'])
set_param([sys,'/','tmodel/delta'],...
		'position',[595,255,600,260])

add_block('built-in/Inport',[sys,'/','tmodel/in_Vref'])
set_param([sys,'/','tmodel/in_Vref'],...
		'position',[450,65,470,85])

add_block('built-in/Note',[sys,'/','tmodel/Ef'])
set_param([sys,'/','tmodel/Ef'],...
		'position',[135,55,140,60])

add_block('built-in/Constant',[sys,'/','tmodel/Exc_sw'])
set_param([sys,'/','tmodel/Exc_sw'],...
		'orientation',2,...
		'Value','Exc_sw(1)',...
		'position',[260,70,335,90])

add_block('built-in/Note',[sys,'/','tmodel/iq_'])
set_param([sys,'/','tmodel/iq_'],...
		'position',[285,360,290,365])
add_line([sys,'/','tmodel'],[290,170;400,170])
add_line([sys,'/','tmodel'],[580,275;635,275;635,510;100,510;100,340;130,340])
add_line([sys,'/','tmodel'],[575,135;605,135;605,100;620,100])
add_line([sys,'/','tmodel'],[290,170;370,170;370,265;520,265])
add_line([sys,'/','tmodel'],[290,170;300,170;300,135;110,135;110,150;125,150])
add_line([sys,'/','tmodel'],[245,170;250,170])
add_line([sys,'/','tmodel'],[150,170;155,170])
add_line([sys,'/','tmodel'],[150,230;105,230;105,190;125,190])
add_line([sys,'/','tmodel'],[670,90;730,90;730,55;210,55])
add_line([sys,'/','tmodel'],[255,80;210,80])
add_line([sys,'/','tmodel'],[185,80;100,80;100,170;125,170])
add_line([sys,'/','tmodel'],[475,75;620,75])
add_line([sys,'/','tmodel'],[575,160;725,160])
add_line([sys,'/','tmodel'],[575,185;670,185])
add_line([sys,'/','tmodel'],[575,210;725,210])
add_line([sys,'/','tmodel'],[580,275;665,275])
add_line([sys,'/','tmodel'],[580,315;725,315])
add_line([sys,'/','tmodel'],[75,280;95,280;95,310;130,310])
add_line([sys,'/','tmodel'],[580,355;670,355])
add_line([sys,'/','tmodel'],[450,180;460,180;460,135;520,135])
add_line([sys,'/','tmodel'],[575,135;670,135])
add_line([sys,'/','tmodel'],[570,445;720,445])
add_line([sys,'/','tmodel'],[570,475;665,475])
add_line([sys,'/','tmodel'],[580,275;635,275;635,510;490,510;490,480;520,480])
add_line([sys,'/','tmodel'],[290,170;370,170;370,440;520,440])
add_line([sys,'/','tmodel'],[180,340;280,340;280,230;260,230])
add_line([sys,'/','tmodel'],[495,365;520,365])
add_line([sys,'/','tmodel'],[155,385;115,385;115,465;140,465])
add_line([sys,'/','tmodel'],[325,460;335,460;335,420;125,420;125,450;140,450])
add_line([sys,'/','tmodel'],[325,460;335,460;335,290;520,290])
add_line([sys,'/','tmodel'],[325,460;335,460;335,190;400,190])
add_line([sys,'/','tmodel'],[165,460;175,460])
add_line([sys,'/','tmodel'],[270,460;285,460])
add_line([sys,'/','tmodel'],[180,315;310,315;310,385;265,385])
add_line([sys,'/','tmodel'],[180,315;520,315])
add_line([sys,'/','tmodel'],[180,340;520,340])
add_line([sys,'/','tmodel'],[180,315;310,315;310,210;400,210])
add_line([sys,'/','tmodel'],[180,340;280,340;280,230;400,230])
add_line([sys,'/','tmodel'],[75,325;130,325])
add_line([sys,'/','tmodel'],[325,460;520,460])
add_line([sys,'/','tmodel'],[180,340;500,340;500,210;520,210])
add_line([sys,'/','tmodel'],[450,220;470,220;470,160;520,160])
add_line([sys,'/','tmodel'],[180,315;485,315;485,185;520,185])
add_line([sys,'/','tmodel'],[475,75;495,75;495,105;210,105])


%     Finished composite block 'tmodel'.

set_param([sys,'/','tmodel'],...
		'position',[160,33,215,157])

add_block('built-in/Note',[sys,'/','vde2'])
set_param([sys,'/','vde2'],...
		'position',[480,400,485,405])

add_block('built-in/Note',[sys,'/','vde1'])
set_param([sys,'/','vde1'],...
		'position',[455,365,460,370])

add_block('built-in/Note',[sys,'/','vqe2'])
set_param([sys,'/','vqe2'],...
		'position',[490,280,495,285])

add_block('built-in/Note',[sys,'/','vqe1'])
set_param([sys,'/','vqe1'],...
		'position',[460,250,465,255])

add_block('built-in/Inport',[sys,'/','In_iqe4'])
set_param([sys,'/','In_iqe4'],...
		'Port','7',...
		'position',[540,350,560,370])

add_block('built-in/Inport',[sys,'/','In_vde3'])
set_param([sys,'/','In_vde3'],...
		'Port','6',...
		'position',[490,440,510,460])

add_block('built-in/Inport',[sys,'/','In_vref1'])
set_param([sys,'/','In_vref1'],...
		'position',[80,40,100,60])

add_block('built-in/Inport',[sys,'/','In_Tmech1'])
set_param([sys,'/','In_Tmech1'],...
		'Port','2',...
		'position',[80,130,100,150])

add_block('built-in/Inport',[sys,'/','In_ide4'])
set_param([sys,'/','In_ide4'],...
		'Port','8',...
		'position',[535,470,555,490])

add_block('built-in/Inport',[sys,'/','In_vqe3'])
set_param([sys,'/','In_vqe3'],...
		'Port','5',...
		'position',[500,320,520,340])


%     Subsystem  'network'.

new_system([sys,'/','network'])
set_param([sys,'/','network'],'Location',[423,208,1167,701])

add_block('built-in/Mux',[sys,'/','network/Mux'])
set_param([sys,'/','network/Mux'],...
		'position',[265,62,295,213])

add_block('built-in/Sum',[sys,'/','network/Sum'])
set_param([sys,'/','network/Sum'],...
		'position',[450,126,470,179])

add_block('built-in/State-Space',[sys,'/','network/IZ*d'])
set_param([sys,'/','network/IZ*d'],...
		'A','[]',...
		'B','[]',...
		'C','[]',...
		'D','K',...
		'Mask Display','K',...
		'Mask Type','Matrix Gain',...
		'Mask Dialogue','Matrix Gain.|Gain matrix:',...
		'Mask Translate','K = @1;')
set_param([sys,'/','network/IZ*d'],...
		'Mask Help','Multiplies input vector by entered matrix to produce output vector (y=Au).',...
		'Mask Entries','IZ\/',...
		'position',[350,184,410,216])

add_block('built-in/State-Space',[sys,'/','network/RZ*q'])
set_param([sys,'/','network/RZ*q'],...
		'A','[]',...
		'B','[]',...
		'C','[]',...
		'D','K',...
		'Mask Display','K',...
		'Mask Type','Matrix Gain',...
		'Mask Dialogue','Matrix Gain.|Gain matrix:',...
		'Mask Translate','K = @1;')
set_param([sys,'/','network/RZ*q'],...
		'Mask Help','Multiplies input vector by entered matrix to produce output vector (y=Au).',...
		'Mask Entries','RZ\/',...
		'position',[350,123,410,157])

add_block('built-in/Demux',[sys,'/','network/q'])
set_param([sys,'/','network/q'],...
		'position',[495,75,535,235])

add_block('built-in/Outport',[sys,'/','network/out_iq2e'])
set_param([sys,'/','network/out_iq2e'],...
		'Port','2',...
		'position',[585,125,605,145])

add_block('built-in/Outport',[sys,'/','network/out_vq4e'])
set_param([sys,'/','network/out_vq4e'],...
		'Port','4',...
		'position',[585,205,605,225])

add_block('built-in/Demux',[sys,'/','network/d'])
set_param([sys,'/','network/d'],...
		'position',[495,253,535,407])

add_block('built-in/State-Space',[sys,'/','network/IZ*q'])
set_param([sys,'/','network/IZ*q'],...
		'A','[]',...
		'B','[]',...
		'C','[]',...
		'D','K',...
		'Mask Display','K',...
		'Mask Type','Matrix Gain',...
		'Mask Dialogue','Matrix Gain.|Gain matrix:',...
		'Mask Translate','K = @1;')
set_param([sys,'/','network/IZ*q'],...
		'Mask Help','Multiplies input vector by entered matrix to produce output vector (y=Au).',...
		'Mask Entries','IZ\/',...
		'position',[350,259,410,291])

add_block('built-in/Sum',[sys,'/','network/Sum1'])
set_param([sys,'/','network/Sum1'],...
		'inputs','-+',...
		'position',[445,301,465,354])

add_block('built-in/State-Space',[sys,'/','network/RZ*d'])
set_param([sys,'/','network/RZ*d'],...
		'A','[]',...
		'B','[]',...
		'C','[]',...
		'D','K',...
		'Mask Display','K',...
		'Mask Type','Matrix Gain',...
		'Mask Dialogue','Matrix Gain.|Gain matrix:',...
		'Mask Translate','K = @1;')
set_param([sys,'/','network/RZ*d'],...
		'Mask Help','Multiplies input vector by entered matrix to produce output vector (y=Au).',...
		'Mask Entries','RZ\/',...
		'position',[350,324,410,356])

add_block('built-in/Mux',[sys,'/','network/Mux1'])
set_param([sys,'/','network/Mux1'],...
		'position',[265,264,295,411])

add_block('built-in/Outport',[sys,'/','network/out_id2e'])
set_param([sys,'/','network/out_id2e'],...
		'Port','6',...
		'position',[585,300,605,320])

add_block('built-in/Outport',[sys,'/','network/out_vd4e'])
set_param([sys,'/','network/out_vd4e'],...
		'Port','8',...
		'position',[585,380,605,400])

add_block('built-in/Inport',[sys,'/','network/in_Eq1e'])
set_param([sys,'/','network/in_Eq1e'],...
		'position',[135,75,155,95])

add_block('built-in/Inport',[sys,'/','network/in_Eq2e'])
set_param([sys,'/','network/in_Eq2e'],...
		'Port','2',...
		'position',[175,110,195,130])

add_block('built-in/Inport',[sys,'/','network/in_vq3e'])
set_param([sys,'/','network/in_vq3e'],...
		'Port','3',...
		'position',[135,145,155,165])

add_block('built-in/Outport',[sys,'/','network/out_iq1e'])
set_param([sys,'/','network/out_iq1e'],...
		'position',[630,85,650,105])

add_block('built-in/Outport',[sys,'/','network/out_iq3e'])
set_param([sys,'/','network/out_iq3e'],...
		'Port','3',...
		'position',[630,165,650,185])

add_block('built-in/Outport',[sys,'/','network/out_id1e'])
set_param([sys,'/','network/out_id1e'],...
		'Port','5',...
		'position',[630,260,650,280])

add_block('built-in/Outport',[sys,'/','network/out_id3e'])
set_param([sys,'/','network/out_id3e'],...
		'Port','7',...
		'position',[625,340,645,360])

add_block('built-in/Inport',[sys,'/','network/in_iq4e'])
set_param([sys,'/','network/in_iq4e'],...
		'Port','4',...
		'position',[170,180,190,200])

add_block('built-in/Inport',[sys,'/','network/in_Ed1e'])
set_param([sys,'/','network/in_Ed1e'],...
		'Port','5',...
		'position',[130,275,150,295])

add_block('built-in/Inport',[sys,'/','network/in_Ed2e'])
set_param([sys,'/','network/in_Ed2e'],...
		'Port','6',...
		'position',[170,310,190,330])

add_block('built-in/Inport',[sys,'/','network/in_vd3e'])
set_param([sys,'/','network/in_vd3e'],...
		'Port','7',...
		'position',[130,345,150,365])

add_block('built-in/Inport',[sys,'/','network/in_id4e'])
set_param([sys,'/','network/in_id4e'],...
		'Port','8',...
		'position',[170,380,190,400])
add_line([sys,'/','network'],[470,330;490,330])
add_line([sys,'/','network'],[475,155;490,155])
add_line([sys,'/','network'],[415,340;440,340])
add_line([sys,'/','network'],[415,275;430,275;440,315])
add_line([sys,'/','network'],[415,200;425,200;425,165;445,165])
add_line([sys,'/','network'],[415,140;445,140])
add_line([sys,'/','network'],[300,140;310,140;310,275;345,275])
add_line([sys,'/','network'],[300,340;345,340])
add_line([sys,'/','network'],[300,340;330,340;330,200;345,200])
add_line([sys,'/','network'],[300,140;345,140])
add_line([sys,'/','network'],[540,95;625,95])
add_line([sys,'/','network'],[540,175;625,175])
add_line([sys,'/','network'],[540,215;580,215])
add_line([sys,'/','network'],[200,120;260,120])
add_line([sys,'/','network'],[540,135;580,135])
add_line([sys,'/','network'],[540,270;625,270])
add_line([sys,'/','network'],[540,350;620,350])
add_line([sys,'/','network'],[540,390;580,390])
add_line([sys,'/','network'],[540,310;580,310])
add_line([sys,'/','network'],[160,85;260,85])
add_line([sys,'/','network'],[160,155;260,155])
add_line([sys,'/','network'],[195,190;260,190])
add_line([sys,'/','network'],[155,285;260,285])
add_line([sys,'/','network'],[195,320;260,320])
add_line([sys,'/','network'],[155,355;260,355])
add_line([sys,'/','network'],[195,390;260,390])


%     Finished composite block 'network'.

set_param([sys,'/','network'],...
		'position',[600,245,685,505])
add_line(sys,[220,140;415,140;415,270;595,270])
add_line(sys,[215,470;415,470;415,300;595,300])
add_line(sys,[220,155;390,155;390,390;595,390])
add_line(sys,[215,485;435,485;435,420;595,420])
add_line(sys,[105,50;155,50])
add_line(sys,[105,140;155,140])
add_line(sys,[110,380;150,380])
add_line(sys,[110,470;150,470])
add_line(sys,[525,330;595,330])
add_line(sys,[515,450;595,450])
add_line(sys,[565,360;595,360])
add_line(sys,[560,480;595,480])
add_line(sys,[220,35;305,35])
add_line(sys,[220,65;405,65])
add_line(sys,[220,80;305,80])
add_line(sys,[215,365;260,365])
add_line(sys,[215,395;325,395])
add_line(sys,[215,410;260,410])
add_line(sys,[690,300;710,300;710,240;280,240])
add_line(sys,[185,240;125,240;125,410;150,410])
add_line(sys,[690,420;710,420;710,530;455,530])
add_line(sys,[355,530;125,530;125,440;150,440])
add_line(sys,[690,390;720,390;720,170;665,170])
add_line(sys,[570,170;135,170;135,110;155,110])
add_line(sys,[690,270;700,270;700,205;540,205])
add_line(sys,[440,205;125,205;125,80;155,80])

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
