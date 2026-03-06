function [ret,x0,str,ts,xts]=s5(t,x,u,flag);
%s5	is the M-file description of the SIMULINK system named s5.
%	s5 has a the following characteristics:
%		9 continuous states
%		0 discrete states
%		0 outputs
%		0 inputs
%		does not have direct feedthrough
%		1 sample times
%
%	The block-diagram can be displayed by typing: s5.
%
%	SYS=s5(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes s5 to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling s5 with a FLAG of zero:
%	[SIZES]=s5([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[12,63,803,536])
     open_system(sys)
end;
set_param(sys,'algorithm',     'Adams/Gear')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     'tstop')
set_param(sys,'Min step size', '1e-6')
set_param(sys,'Max step size', '1e-2')
set_param(sys,'Relative error','1e-6')
set_param(sys,'Return vars',   '')
set_param(sys,'AssignWideVectorLines','on');

add_block('built-in/Gain',[sys,'/','vbg'])
set_param([sys,'/','vbg'],...
		'Gain','400*Zb',...
		'position',[510,190,530,210])

add_block('built-in/Transfer Fcn',[sys,'/',['Flux ',13,'controller']])
set_param([sys,'/',['Flux ',13,'controller']],...
		'Numerator','[16 4]',...
		'Denominator','[1 0]',...
		'position',[160,365,215,405])

add_block('built-in/Sum',[sys,'/','Sum4'])
set_param([sys,'/','Sum4'],...
		'inputs','+-',...
		'position',[130,368,145,397])

add_block('built-in/Fcn',[sys,'/','Vs-Tem'])
set_param([sys,'/','Vs-Tem'],...
		'Expr','VsTem(1)*u[1]*u[1] + VsTem(3)',...
		'position',[60,365,100,385])


%     Subsystem  'Tmech'.

new_system([sys,'/','Tmech'])
set_param([sys,'/','Tmech'],'Location',[5,40,315,196])

add_block('built-in/Outport',[sys,'/','Tmech/out_1'])
set_param([sys,'/','Tmech/out_1'],...
		'position',[285,60,305,80])

add_block('built-in/Look Up Table',[sys,'/','Tmech/Look-Up Table'])
set_param([sys,'/','Tmech/Look-Up Table'],...
		'Input_Values','t',...
		'Output_Values','y',...
		'position',[210,58,250,82])

add_block('built-in/Fcn',[sys,'/','Tmech/Fcn1'])
set_param([sys,'/','Tmech/Fcn1'],...
		'Expr','rem(u[1],period)',...
		'position',[110,60,150,80])

add_block('built-in/Clock',[sys,'/','Tmech/Clock'])
set_param([sys,'/','Tmech/Clock'],...
		'position',[45,60,65,80])
add_line([sys,'/','Tmech'],[255,70;280,70])
add_line([sys,'/','Tmech'],[70,70;105,70])
add_line([sys,'/','Tmech'],[155,70;205,70])
set_param([sys,'/','Tmech'],...
		'Mask Display','plot([t,t+period,t+2*period],[y,y,y])',...
		'Mask Type','Repeating table',...
		'Mask Dialogue','Repeating table.\nEnter values of time and output for first cycle.|Time values:|Output values:')
set_param([sys,'/','Tmech'],...
		'Mask Translate','period = max(@1); t = @1; y = @2;',...
		'Mask Help','Repeats cycle given in table. Time values should be monotonically increasing.',...
		'Mask Entries','tmech_time\/tmech_value\/')


%     Finished composite block 'Tmech'.

set_param([sys,'/','Tmech'],...
		'position',[625,260,650,280])


%     Subsystem  'pm_motor'.

new_system([sys,'/','pm_motor'])
set_param([sys,'/','pm_motor'],'Location',[182,400,716,773])

add_block('built-in/Inport',[sys,'/','pm_motor/vq'])
set_param([sys,'/','pm_motor/vq'],...
		'position',[60,65,80,85])

add_block('built-in/Product',[sys,'/','pm_motor/prod1'])
set_param([sys,'/','pm_motor/prod1'],...
		'orientation',2,...
		'Font Number',3,...
		'position',[165,148,185,172])

add_block('built-in/Product',[sys,'/','pm_motor/prod2'])
set_param([sys,'/','pm_motor/prod2'],...
		'orientation',2,...
		'Font Number',3,...
		'position',[165,193,185,222])

add_block('built-in/Outport',[sys,'/','pm_motor/id_motor'])
set_param([sys,'/','pm_motor/id_motor'],...
		'Port','2',...
		'position',[240,310,260,330])


%     Subsystem  'pm_motor/Rotor'.

new_system([sys,'/','pm_motor/Rotor'])
set_param([sys,'/','pm_motor/Rotor'],'Location',[361,139,920,407])

add_block('built-in/Outport',[sys,'/','pm_motor/Rotor/Tem'])
set_param([sys,'/','pm_motor/Rotor/Tem'],...
		'position',[275,188,300,212])

add_block('built-in/Inport',[sys,'/','pm_motor/Rotor/id'])
set_param([sys,'/','pm_motor/Rotor/id'],...
		'Port','4',...
		'position',[85,200,105,220])

add_block('built-in/Inport',[sys,'/','pm_motor/Rotor/iq'])
set_param([sys,'/','pm_motor/Rotor/iq'],...
		'position',[85,85,105,105])

add_block('built-in/Inport',[sys,'/','pm_motor/Rotor/Tmech'])
set_param([sys,'/','pm_motor/Rotor/Tmech'],...
		'Port','5',...
		'position',[85,45,105,65])

add_block('built-in/Integrator',[sys,'/','pm_motor/Rotor/wr//wb'])
set_param([sys,'/','pm_motor/Rotor/wr//wb'],...
		'Initial','wrbywbo',...
		'position',[410,111,440,149])

add_block('built-in/Note',[sys,'/','pm_motor/Rotor/Tem_'])
set_param([sys,'/','pm_motor/Rotor/Tem_'],...
		'position',[225,130,230,135])

add_block('built-in/Product',[sys,'/','pm_motor/Rotor/Prod'])
set_param([sys,'/','pm_motor/Rotor/Prod'],...
		'position',[145,114,160,136])

add_block('built-in/Inport',[sys,'/','pm_motor/Rotor/psiq'])
set_param([sys,'/','pm_motor/Rotor/psiq'],...
		'Port','3',...
		'position',[85,160,105,180])

add_block('built-in/Product',[sys,'/','pm_motor/Rotor/Prod2'])
set_param([sys,'/','pm_motor/Rotor/Prod2'],...
		'position',[145,165,160,185])

add_block('built-in/Sum',[sys,'/','pm_motor/Rotor/Sum12'])
set_param([sys,'/','pm_motor/Rotor/Sum12'],...
		'inputs','+-',...
		'position',[185,101,205,199])

add_block('built-in/Inport',[sys,'/','pm_motor/Rotor/psid '])
set_param([sys,'/','pm_motor/Rotor/psid '],...
		'Port','2',...
		'position',[85,120,105,140])

add_block('built-in/Gain',[sys,'/','pm_motor/Rotor/D'])
set_param([sys,'/','pm_motor/Rotor/D'],...
		'orientation',2,...
		'Gain','Domega',...
		'position',[320,58,395,92])

add_block('built-in/Sum',[sys,'/','pm_motor/Rotor/Tacc'])
set_param([sys,'/','pm_motor/Rotor/Tacc'],...
		'inputs','-++',...
		'position',[275,100,295,160])

add_block('built-in/Gain',[sys,'/','pm_motor/Rotor/1//2H'])
set_param([sys,'/','pm_motor/Rotor/1//2H'],...
		'Gain','1/(2*H)',...
		'position',[315,110,385,150])

add_block('built-in/Outport',[sys,'/','pm_motor/Rotor/wr//wb '])
set_param([sys,'/','pm_motor/Rotor/wr//wb '],...
		'Port','2',...
		'position',[510,120,530,140])
add_line([sys,'/','pm_motor/Rotor'],[315,75;255,75;255,110;270,110])
add_line([sys,'/','pm_motor/Rotor'],[210,150;270,150])
add_line([sys,'/','pm_motor/Rotor'],[165,175;180,175])
add_line([sys,'/','pm_motor/Rotor'],[390,130;405,130])
add_line([sys,'/','pm_motor/Rotor'],[300,130;310,130])
add_line([sys,'/','pm_motor/Rotor'],[165,125;180,125])
add_line([sys,'/','pm_motor/Rotor'],[110,95;120,95;120,120;140,120])
add_line([sys,'/','pm_motor/Rotor'],[110,130;140,130])
add_line([sys,'/','pm_motor/Rotor'],[110,170;140,170])
add_line([sys,'/','pm_motor/Rotor'],[110,210;120,210;120,180;140,180])
add_line([sys,'/','pm_motor/Rotor'],[210,150;245,150;245,200;270,200])
add_line([sys,'/','pm_motor/Rotor'],[445,130;460,130;460,75;400,75])
add_line([sys,'/','pm_motor/Rotor'],[110,55;240,55;240,130;270,130])
add_line([sys,'/','pm_motor/Rotor'],[445,130;505,130])


%     Finished composite block 'pm_motor/Rotor'.

set_param([sys,'/','pm_motor/Rotor'],...
		'Font Number',3,...
		'position',[345,230,395,330])

add_block('built-in/Inport',[sys,'/','pm_motor/Tmech'])
set_param([sys,'/','pm_motor/Tmech'],...
		'Port','4',...
		'position',[295,310,315,330])


%     Subsystem  'pm_motor/q_cct'.

new_system([sys,'/','pm_motor/q_cct'])
set_param([sys,'/','pm_motor/q_cct'],'Location',[159,307,956,658])

add_block('built-in/Integrator',[sys,'/','pm_motor/q_cct/psiq_'])
set_param([sys,'/','pm_motor/q_cct/psiq_'],...
		'Initial','Psiqo',...
		'position',[390,127,420,153])

add_block('built-in/Fcn',[sys,'/','pm_motor/q_cct/Fcn'])
set_param([sys,'/','pm_motor/q_cct/Fcn'],...
		'Expr','wb*(u[2]-u[3]+(rs/xls)*(u[1]-u[4]))',...
		'position',[180,125,375,155])

add_block('built-in/Inport',[sys,'/','pm_motor/q_cct/In_wrpsid'])
set_param([sys,'/','pm_motor/q_cct/In_wrpsid'],...
		'Port','2',...
		'position',[50,160,70,180])

add_block('built-in/Inport',[sys,'/','pm_motor/q_cct/In_vq'])
set_param([sys,'/','pm_motor/q_cct/In_vq'],...
		'position',[50,105,70,125])

add_block('built-in/Mux',[sys,'/','pm_motor/q_cct/Mux'])
set_param([sys,'/','pm_motor/q_cct/Mux'],...
		'position',[135,86,160,189])

add_block('built-in/Mux',[sys,'/','pm_motor/q_cct/Mux4'])
set_param([sys,'/','pm_motor/q_cct/Mux4'],...
		'inputs','2',...
		'position',[495,179,520,246])

add_block('built-in/Fcn',[sys,'/','pm_motor/q_cct/Fcn4'])
set_param([sys,'/','pm_motor/q_cct/Fcn4'],...
		'Expr','(u[1]-u[2])/xls',...
		'position',[540,202,630,228])

add_block('built-in/Outport',[sys,'/','pm_motor/q_cct/Out_iq'])
set_param([sys,'/','pm_motor/q_cct/Out_iq'],...
		'Port','2',...
		'position',[665,205,685,225])

add_block('built-in/Fcn',[sys,'/','pm_motor/q_cct/Fcn5'])
set_param([sys,'/','pm_motor/q_cct/Fcn5'],...
		'Expr','xMQ*u[1]/xls',...
		'position',[510,127,600,153])

add_block('built-in/Outport',[sys,'/','pm_motor/q_cct/Out_psiq'])
set_param([sys,'/','pm_motor/q_cct/Out_psiq'],...
		'position',[460,90,480,110])

add_block('built-in/Note',[sys,'/','pm_motor/q_cct/psimq'])
set_param([sys,'/','pm_motor/q_cct/psimq'],...
		'position',[645,115,650,120])

add_block('built-in/Outport',[sys,'/','pm_motor/q_cct/Out_psimq'])
set_param([sys,'/','pm_motor/q_cct/Out_psimq'],...
		'Port','3',...
		'position',[725,130,745,150])
add_line([sys,'/','pm_motor/q_cct'],[75,170;95,170;95,150;130,150])
add_line([sys,'/','pm_motor/q_cct'],[75,115;95,115;95,125;130,125])
add_line([sys,'/','pm_motor/q_cct'],[165,140;175,140])
add_line([sys,'/','pm_motor/q_cct'],[380,140;385,140])
add_line([sys,'/','pm_motor/q_cct'],[425,140;435,140;435,205;115,205;115,175;130,175])
add_line([sys,'/','pm_motor/q_cct'],[525,215;535,215])
add_line([sys,'/','pm_motor/q_cct'],[425,140;470,140;470,195;490,195])
add_line([sys,'/','pm_motor/q_cct'],[635,215;660,215])
add_line([sys,'/','pm_motor/q_cct'],[425,140;435,140;435,100;455,100])
add_line([sys,'/','pm_motor/q_cct'],[425,140;505,140])
add_line([sys,'/','pm_motor/q_cct'],[605,140;700,140;700,275;470,275;470,230;490,230])
add_line([sys,'/','pm_motor/q_cct'],[605,140;700,140;700,80;115,80;115,100;130,100])
add_line([sys,'/','pm_motor/q_cct'],[605,140;720,140])


%     Finished composite block 'pm_motor/q_cct'.

set_param([sys,'/','pm_motor/q_cct'],...
		'position',[155,57,195,133])

add_block('built-in/Note',[sys,'/','pm_motor/psid'])
set_param([sys,'/','pm_motor/psid'],...
		'position',[205,240,210,245])

add_block('built-in/Inport',[sys,'/','pm_motor/vd'])
set_param([sys,'/','pm_motor/vd'],...
		'Port','2',...
		'position',[55,250,75,270])

add_block('built-in/Inport',[sys,'/','pm_motor/Ipm'])
set_param([sys,'/','pm_motor/Ipm'],...
		'Port','3',...
		'position',[55,300,75,320])


%     Subsystem  'pm_motor/d_cct'.

new_system([sys,'/','pm_motor/d_cct'])
set_param([sys,'/','pm_motor/d_cct'],'Location',[71,250,938,576])

add_block('built-in/Outport',[sys,'/','pm_motor/d_cct/Out_psid'])
set_param([sys,'/','pm_motor/d_cct/Out_psid'],...
		'position',[585,45,605,65])

add_block('built-in/Fcn',[sys,'/','pm_motor/d_cct/Fcn3'])
set_param([sys,'/','pm_motor/d_cct/Fcn3'],...
		'Expr','xMD*(u[1]/xls+u[2])',...
		'position',[565,113,735,147])

add_block('built-in/Mux',[sys,'/','pm_motor/d_cct/Mux3'])
set_param([sys,'/','pm_motor/d_cct/Mux3'],...
		'inputs','2',...
		'position',[520,91,545,169])

add_block('built-in/Integrator',[sys,'/','pm_motor/d_cct/psid_'])
set_param([sys,'/','pm_motor/d_cct/psid_'],...
		'Initial','Psido',...
		'position',[390,127,420,153])

add_block('built-in/Fcn',[sys,'/','pm_motor/d_cct/Fcn'])
set_param([sys,'/','pm_motor/d_cct/Fcn'],...
		'Expr','wb*(u[2]+u[3]+(rs/xls)*(u[1]-u[4]))',...
		'position',[180,125,375,155])

add_block('built-in/Inport',[sys,'/','pm_motor/d_cct/In_wrpsiq'])
set_param([sys,'/','pm_motor/d_cct/In_wrpsiq'],...
		'Port','2',...
		'position',[50,160,70,180])

add_block('built-in/Inport',[sys,'/','pm_motor/d_cct/In_vd'])
set_param([sys,'/','pm_motor/d_cct/In_vd'],...
		'position',[50,105,70,125])

add_block('built-in/Mux',[sys,'/','pm_motor/d_cct/Mux'])
set_param([sys,'/','pm_motor/d_cct/Mux'],...
		'position',[135,86,160,189])

add_block('built-in/Inport',[sys,'/','pm_motor/d_cct/In_Ipm'])
set_param([sys,'/','pm_motor/d_cct/In_Ipm'],...
		'Port','3',...
		'position',[50,225,70,245])

add_block('built-in/Mux',[sys,'/','pm_motor/d_cct/Mux4'])
set_param([sys,'/','pm_motor/d_cct/Mux4'],...
		'inputs','2',...
		'position',[520,194,540,261])

add_block('built-in/Fcn',[sys,'/','pm_motor/d_cct/Fcn4'])
set_param([sys,'/','pm_motor/d_cct/Fcn4'],...
		'Expr','(u[1]-u[2])/xls',...
		'position',[570,217,660,243])

add_block('built-in/Outport',[sys,'/','pm_motor/d_cct/Out_id'])
set_param([sys,'/','pm_motor/d_cct/Out_id'],...
		'Port','2',...
		'position',[795,220,815,240])

add_block('built-in/Outport',[sys,'/','pm_motor/d_cct/Out_psimd'])
set_param([sys,'/','pm_motor/d_cct/Out_psimd'],...
		'Port','3',...
		'position',[795,120,815,140])
add_line([sys,'/','pm_motor/d_cct'],[75,170;95,170;95,150;130,150])
add_line([sys,'/','pm_motor/d_cct'],[75,115;95,115;95,125;130,125])
add_line([sys,'/','pm_motor/d_cct'],[165,140;175,140])
add_line([sys,'/','pm_motor/d_cct'],[380,140;385,140])
add_line([sys,'/','pm_motor/d_cct'],[425,140;435,140;435,205;115,205;115,175;130,175])
add_line([sys,'/','pm_motor/d_cct'],[425,140;435,140;435,110;515,110])
add_line([sys,'/','pm_motor/d_cct'],[550,130;560,130])
add_line([sys,'/','pm_motor/d_cct'],[545,230;565,230])
add_line([sys,'/','pm_motor/d_cct'],[425,140;470,140;470,210;515,210])
add_line([sys,'/','pm_motor/d_cct'],[740,130;755,130;755,275;495,275;495,245;515,245])
add_line([sys,'/','pm_motor/d_cct'],[740,130;755,130;755,80;115,80;115,100;130,100])
add_line([sys,'/','pm_motor/d_cct'],[740,130;790,130])
add_line([sys,'/','pm_motor/d_cct'],[665,230;790,230])
add_line([sys,'/','pm_motor/d_cct'],[425,140;435,140;435,55;580,55])
add_line([sys,'/','pm_motor/d_cct'],[75,235;450,235;450,150;515,150])


%     Finished composite block 'pm_motor/d_cct'.

set_param([sys,'/','pm_motor/d_cct'],...
		'position',[150,248,190,322])

add_block('built-in/Note',[sys,'/','pm_motor/id'])
set_param([sys,'/','pm_motor/id'],...
		'position',[205,265,210,270])

add_block('built-in/Outport',[sys,'/','pm_motor/iq_motor'])
set_param([sys,'/','pm_motor/iq_motor'],...
		'position',[340,85,360,105])

add_block('built-in/Note',[sys,'/','pm_motor/iq'])
set_param([sys,'/','pm_motor/iq'],...
		'position',[210,75,215,80])

add_block('built-in/Note',[sys,'/','pm_motor/psiq'])
set_param([sys,'/','pm_motor/psiq'],...
		'position',[215,50,220,55])

add_block('built-in/Outport',[sys,'/','pm_motor/Tem'])
set_param([sys,'/','pm_motor/Tem'],...
		'Port','3',...
		'position',[460,245,480,265])

add_block('built-in/Outport',[sys,'/','pm_motor/wr//wb'])
set_param([sys,'/','pm_motor/wr//wb'],...
		'Port','4',...
		'position',[460,295,480,315])

add_block('built-in/Scope',[sys,'/','pm_motor/Scope'])
set_param([sys,'/','pm_motor/Scope'],...
		'Vgain','100.000000',...
		'Hgain','1.000000',...
		'Vmax','100.000000',...
		'Hmax','2.000000',...
		'Window',[184,667,647,821],...
		'position',[440,92,460,118])
add_line([sys,'/','pm_motor'],[320,320;340,320])
add_line([sys,'/','pm_motor'],[195,260;340,260])
add_line([sys,'/','pm_motor'],[195,285;220,285;220,300;340,300])
add_line([sys,'/','pm_motor'],[200,95;290,95;290,240;340,240])
add_line([sys,'/','pm_motor'],[200,70;255,70;255,280;340,280])
add_line([sys,'/','pm_motor'],[200,95;335,95])
add_line([sys,'/','pm_motor'],[195,285;220,285;220,320;235,320])
add_line([sys,'/','pm_motor'],[160,160;120,160;120,115;150,115])
add_line([sys,'/','pm_motor'],[85,75;150,75])
add_line([sys,'/','pm_motor'],[195,260;235,260;235,165;190,165])
add_line([sys,'/','pm_motor'],[200,70;255,70;255,215;190,215])
add_line([sys,'/','pm_motor'],[80,310;145,310])
add_line([sys,'/','pm_motor'],[80,260;145,260])
add_line([sys,'/','pm_motor'],[160,210;120,210;120,285;145,285])
add_line([sys,'/','pm_motor'],[400,305;415,305;415,155;190,155])
add_line([sys,'/','pm_motor'],[400,305;415,305;415,200;190,200])
add_line([sys,'/','pm_motor'],[400,305;455,305])
add_line([sys,'/','pm_motor'],[400,255;455,255])


%     Finished composite block 'pm_motor'.

set_param([sys,'/','pm_motor'],...
		'position',[670,156,710,284])

add_block('built-in/Note',[sys,'/','v0'])
set_param([sys,'/','v0'],...
		'position',[618,214,623,219])

add_block('built-in/Constant',[sys,'/','Ipm'])
set_param([sys,'/','Ipm'],...
		'Value','Ipm',...
		'position',[630,225,655,245])

add_block('built-in/Note',[sys,'/','vd'])
set_param([sys,'/','vd'],...
		'position',[618,184,623,189])


%     Subsystem  'abc2qd0'.

new_system([sys,'/','abc2qd0'])
set_param([sys,'/','abc2qd0'],'Location',[454,254,1125,632])

add_block('built-in/Outport',[sys,'/','abc2qd0/vq'])
set_param([sys,'/','abc2qd0/vq'],...
		'position',[595,70,615,90])

add_block('built-in/Outport',[sys,'/','abc2qd0/vd'])
set_param([sys,'/','abc2qd0/vd'],...
		'Port','2',...
		'position',[590,145,610,165])

add_block('built-in/Outport',[sys,'/','abc2qd0/vd0'])
set_param([sys,'/','abc2qd0/vd0'],...
		'Port','3',...
		'position',[590,225,610,245])

add_block('built-in/Fcn',[sys,'/','abc2qd0/abc2q'])
set_param([sys,'/','abc2qd0/abc2q'],...
		'Expr','(2*u[1]- u[2] - u[3])/3',...
		'position',[150,129,290,151])

add_block('built-in/Fcn',[sys,'/','abc2qd0/abc20'])
set_param([sys,'/','abc2qd0/abc20'],...
		'Expr','(u[1] + u[2]  + u[3])/3',...
		'position',[150,224,290,246])

add_block('built-in/Fcn',[sys,'/','abc2qd0/abc2d'])
set_param([sys,'/','abc2qd0/abc2d'],...
		'Expr','(u[3] -u[2])/sqrt(3)',...
		'position',[150,174,290,196])

add_block('built-in/Inport',[sys,'/','abc2qd0/vc'])
set_param([sys,'/','abc2qd0/vc'],...
		'Port','3',...
		'position',[40,210,60,230])

add_block('built-in/Inport',[sys,'/','abc2qd0/vb'])
set_param([sys,'/','abc2qd0/vb'],...
		'Port','2',...
		'position',[40,175,60,195])

add_block('built-in/Inport',[sys,'/','abc2qd0/va'])
set_param([sys,'/','abc2qd0/va'],...
		'position',[40,140,60,160])

add_block('built-in/Mux',[sys,'/','abc2qd0/Mux'])
set_param([sys,'/','abc2qd0/Mux'],...
		'inputs','3',...
		'position',[90,129,115,241])

add_block('built-in/Note',[sys,'/','abc2qd0/vds'])
set_param([sys,'/','abc2qd0/vds'],...
		'position',[325,150,330,155])

add_block('built-in/Inport',[sys,'/','abc2qd0/cos_thetar'])
set_param([sys,'/','abc2qd0/cos_thetar'],...
		'Port','4',...
		'position',[40,60,60,80])

add_block('built-in/Mux',[sys,'/','abc2qd0/Mux1'])
set_param([sys,'/','abc2qd0/Mux1'],...
		'position',[375,56,400,189])

add_block('built-in/Inport',[sys,'/','abc2qd0/sin_thetar'])
set_param([sys,'/','abc2qd0/sin_thetar'],...
		'Port','5',...
		'position',[40,95,60,115])

add_block('built-in/Note',[sys,'/','abc2qd0/abc2qd0'])
set_param([sys,'/','abc2qd0/abc2qd0'],...
		'position',[205,275,210,280])

add_block('built-in/Note',[sys,'/','abc2qd0/qds2qdr'])
set_param([sys,'/','abc2qd0/qds2qdr'],...
		'position',[470,275,475,280])

add_block('built-in/Fcn',[sys,'/','abc2qd0/qds2dr'])
set_param([sys,'/','abc2qd0/qds2dr'],...
		'Expr','u[2]*u[3] + u[1]*u[4] ',...
		'position',[425,143,560,167])

add_block('built-in/Fcn',[sys,'/','abc2qd0/qds2qr'])
set_param([sys,'/','abc2qd0/qds2qr'],...
		'Expr','u[1]*u[3] - u[2]*u[4]',...
		'position',[425,68,560,92])

add_block('built-in/Note',[sys,'/','abc2qd0/vqs'])
set_param([sys,'/','abc2qd0/vqs'],...
		'position',[325,118,330,123])
add_line([sys,'/','abc2qd0'],[120,185;125,185;125,140;145,140])
add_line([sys,'/','abc2qd0'],[120,185;145,185])
add_line([sys,'/','abc2qd0'],[405,125;405,80;420,80])
add_line([sys,'/','abc2qd0'],[405,125;405,155;420,155])
add_line([sys,'/','abc2qd0'],[65,150;85,150])
add_line([sys,'/','abc2qd0'],[65,185;85,185])
add_line([sys,'/','abc2qd0'],[65,220;85,220])
add_line([sys,'/','abc2qd0'],[565,80;590,80])
add_line([sys,'/','abc2qd0'],[565,155;585,155])
add_line([sys,'/','abc2qd0'],[120,185;125,185;125,235;145,235])
add_line([sys,'/','abc2qd0'],[65,70;370,70])
add_line([sys,'/','abc2qd0'],[65,105;370,105])
add_line([sys,'/','abc2qd0'],[295,140;370,140])
add_line([sys,'/','abc2qd0'],[295,185;325,185;325,175;370,175])
add_line([sys,'/','abc2qd0'],[295,235;585,235])


%     Finished composite block 'abc2qd0'.

set_param([sys,'/','abc2qd0'],...
		'Font Number',3,...
		'position',[575,156,610,254])


%     Subsystem  'qdr2abc1'.

new_system([sys,'/','qdr2abc1'])
set_param([sys,'/','qdr2abc1'],'Location',[56,346,800,637])

add_block('built-in/Mux',[sys,'/','qdr2abc1/Mux'])
set_param([sys,'/','qdr2abc1/Mux'],...
		'position',[125,34,155,196])

add_block('built-in/Inport',[sys,'/','qdr2abc1/id'])
set_param([sys,'/','qdr2abc1/id'],...
		'Port','2',...
		'position',[60,165,80,185])

add_block('built-in/Inport',[sys,'/','qdr2abc1/iq'])
set_param([sys,'/','qdr2abc1/iq'],...
		'position',[60,125,80,145])

add_block('built-in/Inport',[sys,'/','qdr2abc1/sin(thetar)'])
set_param([sys,'/','qdr2abc1/sin(thetar)'],...
		'Port','4',...
		'position',[60,85,80,105])

add_block('built-in/Inport',[sys,'/','qdr2abc1/cos(thetar)'])
set_param([sys,'/','qdr2abc1/cos(thetar)'],...
		'Port','3',...
		'position',[60,45,80,65])

add_block('built-in/Fcn',[sys,'/','qdr2abc1/qdr2qs'])
set_param([sys,'/','qdr2abc1/qdr2qs'],...
		'Expr','u[1]*u[3] + u[2]*u[4]',...
		'position',[190,64,310,86])

add_block('built-in/Fcn',[sys,'/','qdr2abc1/qdr2ds'])
set_param([sys,'/','qdr2abc1/qdr2ds'],...
		'Expr','u[1]*u[4] - u[2]*u[3]',...
		'position',[190,140,310,160])

add_block('built-in/Note',[sys,'/','qdr2abc1/qds2abc'])
set_param([sys,'/','qdr2abc1/qds2abc'],...
		'position',[530,20,535,25])

add_block('built-in/Mux',[sys,'/','qdr2abc1/Mux1'])
set_param([sys,'/','qdr2abc1/Mux1'],...
		'inputs','2',...
		'position',[350,38,380,187])

add_block('built-in/Fcn',[sys,'/','qdr2abc1/qds2a'])
set_param([sys,'/','qdr2abc1/qds2a'],...
		'Expr','u[1] ',...
		'position',[440,49,610,71])

add_block('built-in/Outport',[sys,'/','qdr2abc1/ia'])
set_param([sys,'/','qdr2abc1/ia'],...
		'position',[640,49,665,71])

add_block('built-in/Outport',[sys,'/','qdr2abc1/ib'])
set_param([sys,'/','qdr2abc1/ib'],...
		'Port','2',...
		'position',[645,104,670,126])

add_block('built-in/Fcn',[sys,'/','qdr2abc1/qds2b'])
set_param([sys,'/','qdr2abc1/qds2b'],...
		'Expr','-u[1]/2 -sqrt(3)*u[2]/2',...
		'position',[435,104,600,126])

add_block('built-in/Outport',[sys,'/','qdr2abc1/ic'])
set_param([sys,'/','qdr2abc1/ic'],...
		'Port','3',...
		'position',[645,158,670,182])

add_block('built-in/Fcn',[sys,'/','qdr2abc1/qds2c'])
set_param([sys,'/','qdr2abc1/qds2c'],...
		'Expr','-u[1]/2 +sqrt(3)*u[2]/2 ',...
		'position',[435,159,605,181])

add_block('built-in/Note',[sys,'/','qdr2abc1/qdr2qds'])
set_param([sys,'/','qdr2abc1/qdr2qds'],...
		'position',[250,20,255,25])
add_line([sys,'/','qdr2abc1'],[85,55;120,55])
add_line([sys,'/','qdr2abc1'],[85,95;120,95])
add_line([sys,'/','qdr2abc1'],[85,135;120,135])
add_line([sys,'/','qdr2abc1'],[85,175;120,175])
add_line([sys,'/','qdr2abc1'],[160,115;165,115;165,75;185,75])
add_line([sys,'/','qdr2abc1'],[160,115;165,115;165,150;185,150])
add_line([sys,'/','qdr2abc1'],[315,75;345,75])
add_line([sys,'/','qdr2abc1'],[315,150;345,150])
add_line([sys,'/','qdr2abc1'],[385,115;430,115])
add_line([sys,'/','qdr2abc1'],[385,115;400,115;400,60;435,60])
add_line([sys,'/','qdr2abc1'],[615,60;635,60])
add_line([sys,'/','qdr2abc1'],[605,115;640,115])
add_line([sys,'/','qdr2abc1'],[385,115;400,115;400,170;430,170])
add_line([sys,'/','qdr2abc1'],[610,170;640,170])


%     Finished composite block 'qdr2abc1'.

set_param([sys,'/','qdr2abc1'],...
		'Font Number',3,...
		'position',[390,167,425,238])

add_block('built-in/Gain',[sys,'/','vag'])
set_param([sys,'/','vag'],...
		'Gain','400*Zb',...
		'position',[515,155,535,175])

add_block('built-in/Sum',[sys,'/','Sa'])
set_param([sys,'/','Sa'],...
		'inputs','-+',...
		'position',[475,155,495,175])

add_block('built-in/Sum',[sys,'/','Sa2'])
set_param([sys,'/','Sa2'],...
		'inputs','-+',...
		'position',[470,235,490,255])

add_block('built-in/Gain',[sys,'/','vcg'])
set_param([sys,'/','vcg'],...
		'Gain','400*Zb',...
		'position',[510,235,530,255])

add_block('built-in/Sum',[sys,'/','Sa1'])
set_param([sys,'/','Sa1'],...
		'inputs','-+',...
		'position',[470,190,490,210])

add_block('built-in/Note',[sys,'/','vq'])
set_param([sys,'/','vq'],...
		'position',[618,159,623,164])

add_block('built-in/Scope',[sys,'/','Scope2'])
set_param([sys,'/','Scope2'],...
		'Vgain','2.000000',...
		'Hgain','2.000000',...
		'Vmax','2.000000',...
		'Hmax','4.000000',...
		'Window',[677,690,1140,844],...
		'position',[815,27,835,53])


%     Subsystem  'Feedback'.

new_system([sys,'/','Feedback'])
set_param([sys,'/','Feedback'],'Location',[97,258,961,527])

add_block('built-in/Outport',[sys,'/','Feedback/out_id'])
set_param([sys,'/','Feedback/out_id'],...
		'Port','2',...
		'position',[705,70,725,90])

add_block('built-in/Outport',[sys,'/','Feedback/out_iq'])
set_param([sys,'/','Feedback/out_iq'],...
		'position',[705,35,725,55])

add_block('built-in/Fcn',[sys,'/','Feedback/psiqgap'])
set_param([sys,'/','Feedback/psiqgap'],...
		'Expr','u[1]*xq',...
		'position',[305,94,375,116])

add_block('built-in/Inport',[sys,'/','Feedback/cos_thetar'])
set_param([sys,'/','Feedback/cos_thetar'],...
		'position',[75,75,95,95])

add_block('built-in/Inport',[sys,'/','Feedback/sin_thetar'])
set_param([sys,'/','Feedback/sin_thetar'],...
		'Port','2',...
		'position',[75,115,95,135])

add_block('built-in/Note',[sys,'/','Feedback/iq'])
set_param([sys,'/','Feedback/iq'],...
		'position',[215,95,220,100])

add_block('built-in/Inport',[sys,'/','Feedback/ic'])
set_param([sys,'/','Feedback/ic'],...
		'Port','5',...
		'position',[75,225,95,245])

add_block('built-in/Inport',[sys,'/','Feedback/ia'])
set_param([sys,'/','Feedback/ia'],...
		'Port','3',...
		'position',[75,155,95,175])

add_block('built-in/Inport',[sys,'/','Feedback/ib'])
set_param([sys,'/','Feedback/ib'],...
		'Port','4',...
		'position',[75,190,95,210])


%     Subsystem  'Feedback/abc2qd'.

new_system([sys,'/','Feedback/abc2qd'])
set_param([sys,'/','Feedback/abc2qd'],'Location',[50,271,596,583])

add_block('built-in/Note',[sys,'/','Feedback/abc2qd/abc2qd0'])
set_param([sys,'/','Feedback/abc2qd/abc2qd0'],...
		'position',[150,265,155,270])

add_block('built-in/Note',[sys,'/','Feedback/abc2qd/qds2qdr'])
set_param([sys,'/','Feedback/abc2qd/qds2qdr'],...
		'position',[370,240,375,245])

add_block('built-in/Mux',[sys,'/','Feedback/abc2qd/Mux1'])
set_param([sys,'/','Feedback/abc2qd/Mux1'],...
		'position',[250,66,280,239])

add_block('built-in/Mux',[sys,'/','Feedback/abc2qd/Mux'])
set_param([sys,'/','Feedback/abc2qd/Mux'],...
		'inputs','3',...
		'position',[50,148,75,252])

add_block('built-in/Fcn',[sys,'/','Feedback/abc2qd/abc2q'])
set_param([sys,'/','Feedback/abc2qd/abc2q'],...
		'Expr','(2*u[1]- u[2] - u[3])/3',...
		'position',[100,163,225,187])

add_block('built-in/Fcn',[sys,'/','Feedback/abc2qd/abc2d'])
set_param([sys,'/','Feedback/abc2qd/abc2d'],...
		'Expr','(u[3] -u[2])/sqrt(3)',...
		'position',[100,209,225,231])

add_block('built-in/Note',[sys,'/','Feedback/abc2qd/iqs'])
set_param([sys,'/','Feedback/abc2qd/iqs'],...
		'position',[235,153,240,158])

add_block('built-in/Note',[sys,'/','Feedback/abc2qd/ids'])
set_param([sys,'/','Feedback/abc2qd/ids'],...
		'position',[235,190,240,195])

add_block('built-in/Note',[sys,'/','Feedback/abc2qd/id'])
set_param([sys,'/','Feedback/abc2qd/id'],...
		'position',[455,160,460,165])

add_block('built-in/Note',[sys,'/','Feedback/abc2qd/iq'])
set_param([sys,'/','Feedback/abc2qd/iq'],...
		'position',[458,111,463,116])

add_block('built-in/Fcn',[sys,'/','Feedback/abc2qd/qds2qr'])
set_param([sys,'/','Feedback/abc2qd/qds2qr'],...
		'Expr','u[1]*u[3] - u[2]*u[4]',...
		'position',[310,118,445,142])

add_block('built-in/Fcn',[sys,'/','Feedback/abc2qd/qds2dr'])
set_param([sys,'/','Feedback/abc2qd/qds2dr'],...
		'Expr','u[2]*u[3] + u[1]*u[4] ',...
		'position',[310,168,445,192])

add_block('built-in/Inport',[sys,'/','Feedback/abc2qd/in_1'])
set_param([sys,'/','Feedback/abc2qd/in_1'],...
		'position',[15,75,35,95])

add_block('built-in/Inport',[sys,'/','Feedback/abc2qd/in_2'])
set_param([sys,'/','Feedback/abc2qd/in_2'],...
		'Port','2',...
		'position',[15,120,35,140])

add_block('built-in/Inport',[sys,'/','Feedback/abc2qd/in_3'])
set_param([sys,'/','Feedback/abc2qd/in_3'],...
		'Port','3',...
		'position',[15,155,35,175])

add_block('built-in/Inport',[sys,'/','Feedback/abc2qd/in_4'])
set_param([sys,'/','Feedback/abc2qd/in_4'],...
		'Port','4',...
		'position',[15,190,35,210])

add_block('built-in/Inport',[sys,'/','Feedback/abc2qd/in_5'])
set_param([sys,'/','Feedback/abc2qd/in_5'],...
		'Port','5',...
		'position',[15,225,35,245])

add_block('built-in/Outport',[sys,'/','Feedback/abc2qd/out_iq'])
set_param([sys,'/','Feedback/abc2qd/out_iq'],...
		'position',[500,120,520,140])

add_block('built-in/Outport',[sys,'/','Feedback/abc2qd/out_id'])
set_param([sys,'/','Feedback/abc2qd/out_id'],...
		'Port','2',...
		'position',[500,170,520,190])
add_line([sys,'/','Feedback/abc2qd'],[230,220;245,220])
add_line([sys,'/','Feedback/abc2qd'],[230,175;245,175])
add_line([sys,'/','Feedback/abc2qd'],[285,155;290,155;290,180;305,180])
add_line([sys,'/','Feedback/abc2qd'],[285,155;290,155;290,130;305,130])
add_line([sys,'/','Feedback/abc2qd'],[80,200;85,200;95,220])
add_line([sys,'/','Feedback/abc2qd'],[80,200;85,200;95,175])
add_line([sys,'/','Feedback/abc2qd'],[40,85;245,85])
add_line([sys,'/','Feedback/abc2qd'],[450,130;495,130])
add_line([sys,'/','Feedback/abc2qd'],[40,130;245,130])
add_line([sys,'/','Feedback/abc2qd'],[40,165;45,165])
add_line([sys,'/','Feedback/abc2qd'],[450,180;495,180])
add_line([sys,'/','Feedback/abc2qd'],[40,200;45,200])
add_line([sys,'/','Feedback/abc2qd'],[40,235;45,235])


%     Finished composite block 'Feedback/abc2qd'.

set_param([sys,'/','Feedback/abc2qd'],...
		'position',[155,77,210,253])

add_block('built-in/Note',[sys,'/','Feedback/id'])
set_param([sys,'/','Feedback/id'],...
		'position',[215,185,220,190])

add_block('built-in/Mux',[sys,'/','Feedback/Mux3'])
set_param([sys,'/','Feedback/Mux3'],...
		'position',[445,83,470,232])

add_block('built-in/Fcn',[sys,'/','Feedback/psidgap'])
set_param([sys,'/','Feedback/psidgap'],...
		'Expr','Ipm*xmd + u[1]*xd',...
		'position',[300,138,415,162])

add_block('built-in/Fcn',[sys,'/','Feedback/psigap'])
set_param([sys,'/','Feedback/psigap'],...
		'Expr','sqrt(u[1]*u[1] + u[2]*u[2])',...
		'position',[500,122,660,148])

add_block('built-in/Outport',[sys,'/','Feedback/out_psigap'])
set_param([sys,'/','Feedback/out_psigap'],...
		'Port','3',...
		'position',[705,125,725,145])

add_block('built-in/Fcn',[sys,'/','Feedback/Tem'])
set_param([sys,'/','Feedback/Tem'],...
		'Expr','u[2]*u[3] - u[1]*u[4]',...
		'position',[500,172,670,198])

add_block('built-in/Outport',[sys,'/','Feedback/out_Tem'])
set_param([sys,'/','Feedback/out_Tem'],...
		'Port','4',...
		'position',[705,175,725,195])
add_line([sys,'/','Feedback'],[100,165;150,165])
add_line([sys,'/','Feedback'],[100,200;150,200])
add_line([sys,'/','Feedback'],[100,235;150,235])
add_line([sys,'/','Feedback'],[100,85;135,85;135,95;150,95])
add_line([sys,'/','Feedback'],[100,125;120,125;120,130;150,130])
add_line([sys,'/','Feedback'],[380,105;440,105])
add_line([sys,'/','Feedback'],[420,150;425,150;425,140;440,140])
add_line([sys,'/','Feedback'],[475,160;475,185;495,185])
add_line([sys,'/','Feedback'],[475,160;475,135;495,135])
add_line([sys,'/','Feedback'],[215,120;235,120;235,175;440,175])
add_line([sys,'/','Feedback'],[215,210;440,210])
add_line([sys,'/','Feedback'],[675,185;700,185])
add_line([sys,'/','Feedback'],[665,135;700,135])
add_line([sys,'/','Feedback'],[215,120;235,120;235,45;700,45])
add_line([sys,'/','Feedback'],[215,210;265,210;265,80;700,80])
add_line([sys,'/','Feedback'],[215,120;235,120;235,105;300,105])
add_line([sys,'/','Feedback'],[215,210;265,210;265,150;295,150])


%     Finished composite block 'Feedback'.

set_param([sys,'/','Feedback'],...
		'orientation',2,...
		'Font Number',3,...
		'position',[400,376,460,444])

add_block('built-in/Transfer Fcn',[sys,'/',['Torque',13,'controller']])
set_param([sys,'/',['Torque',13,'controller']],...
		'Numerator','[7 50]',...
		'Denominator','[1 0]',...
		'position',[95,153,150,187])

add_block('built-in/Sum',[sys,'/','Sum2'])
set_param([sys,'/','Sum2'],...
		'inputs','+-',...
		'position',[195,163,210,192])

add_block('built-in/Fcn',[sys,'/','Id-Iq'])
set_param([sys,'/','Id-Iq'],...
		'Expr','IdeIqe(1)*u[1]*u[1]+ IdeIqe(2)',...
		'position',[175,229,205,251])

add_block('built-in/Transfer Fcn',[sys,'/',['Current',13,'Controller1']])
set_param([sys,'/',['Current',13,'Controller1']],...
		'Numerator','[5 1]',...
		'Denominator','[1 0]',...
		'position',[235,162,275,198])

add_block('built-in/Sum',[sys,'/','Sum3'])
set_param([sys,'/','Sum3'],...
		'inputs','++-',...
		'position',[225,247,240,283])

add_block('built-in/Transfer Fcn',[sys,'/',['Current',13,'Controller2']])
set_param([sys,'/',['Current',13,'Controller2']],...
		'Numerator','[5 1]',...
		'Denominator','[1 0]',...
		'position',[255,248,295,282])

add_block('built-in/Saturation',[sys,'/','Satq'])
set_param([sys,'/','Satq'],...
		'Lower Limit','-1.2',...
		'Upper Limit','1.2',...
		'position',[295,168,315,192])

add_block('built-in/Note',[sys,'/','iq*'])
set_param([sys,'/','iq*'],...
		'position',[330,160,335,165])

add_block('built-in/Saturation',[sys,'/','Satd'])
set_param([sys,'/','Satd'],...
		'Lower Limit','-1.2',...
		'Upper Limit','1.2',...
		'position',[315,254,335,276])

add_block('built-in/Note',[sys,'/','id*'])
set_param([sys,'/','id*'],...
		'position',[340,236,345,241])


%     Subsystem  ['Torque ',13,'Command'].

new_system([sys,'/',['Torque ',13,'Command']])
set_param([sys,'/',['Torque ',13,'Command']],'Location',[5,40,315,196])

add_block('built-in/Outport',[sys,'/',['Torque ',13,'Command/out_1']])
set_param([sys,'/',['Torque ',13,'Command/out_1']],...
		'position',[285,60,305,80])

add_block('built-in/Look Up Table',[sys,'/',['Torque ',13,'Command/Look-Up Table']])
set_param([sys,'/',['Torque ',13,'Command/Look-Up Table']],...
		'Input_Values','t',...
		'Output_Values','y',...
		'position',[210,58,250,82])

add_block('built-in/Fcn',[sys,'/',['Torque ',13,'Command/Fcn1']])
set_param([sys,'/',['Torque ',13,'Command/Fcn1']],...
		'Expr','rem(u[1],period)',...
		'position',[110,60,150,80])

add_block('built-in/Clock',[sys,'/',['Torque ',13,'Command/Clock']])
set_param([sys,'/',['Torque ',13,'Command/Clock']],...
		'position',[45,60,65,80])
add_line([sys,'/',['Torque ',13,'Command']],[255,70;280,70])
add_line([sys,'/',['Torque ',13,'Command']],[70,70;105,70])
add_line([sys,'/',['Torque ',13,'Command']],[155,70;205,70])
set_param([sys,'/',['Torque ',13,'Command']],...
		'Mask Display','plot([t,t+period,t+2*period],[y,y,y])',...
		'Mask Type','Repeating table')
set_param([sys,'/',['Torque ',13,'Command']],...
		'Mask Dialogue','Repeating table.\nEnter values of time and output for first cycle.|Time values:|Output values:',...
		'Mask Translate','period = max(@1); t = @1; y = @2;')
set_param([sys,'/',['Torque ',13,'Command']],...
		'Mask Help','Repeats cycle given in table. Time values should be monotonically increasing.',...
		'Mask Entries','tref_time\/tref_value\/')


%     Finished composite block ['Torque ',13,'Command'].

set_param([sys,'/',['Torque ',13,'Command']],...
		'orientation',2,...
		'position',[145,111,185,129])

add_block('built-in/Sum',[sys,'/','Sum1'])
set_param([sys,'/','Sum1'],...
		'inputs','+-',...
		'position',[60,153,75,182])

add_block('built-in/Note',[sys,'/','Tref'])
set_param([sys,'/','Tref'],...
		'position',[45,100,50,105])

add_block('built-in/Rate Limiter',[sys,'/','Rate Limiter'])
set_param([sys,'/','Rate Limiter'],...
		'orientation',2,...
		'Rising Slew Limit','1000',...
		'Falling Slew Limit','-1000',...
		'position',[75,110,100,130])

add_block('built-in/Note',[sys,'/','Tem*'])
set_param([sys,'/','Tem*'],...
		'position',[165,150,170,155])

add_block('built-in/Note',[sys,'/','Vs*'])
set_param([sys,'/','Vs*'],...
		'position',[110,350,115,355])


%     Subsystem  'qdr2abc'.

new_system([sys,'/','qdr2abc'])
set_param([sys,'/','qdr2abc'],'Location',[56,346,800,637])

add_block('built-in/Mux',[sys,'/','qdr2abc/Mux'])
set_param([sys,'/','qdr2abc/Mux'],...
		'position',[125,34,155,196])

add_block('built-in/Inport',[sys,'/','qdr2abc/id'])
set_param([sys,'/','qdr2abc/id'],...
		'Port','2',...
		'position',[60,165,80,185])

add_block('built-in/Inport',[sys,'/','qdr2abc/iq'])
set_param([sys,'/','qdr2abc/iq'],...
		'position',[60,125,80,145])

add_block('built-in/Inport',[sys,'/','qdr2abc/sin_thetar'])
set_param([sys,'/','qdr2abc/sin_thetar'],...
		'Port','4',...
		'position',[60,85,80,105])

add_block('built-in/Inport',[sys,'/','qdr2abc/cos_thetar'])
set_param([sys,'/','qdr2abc/cos_thetar'],...
		'Port','3',...
		'position',[60,45,80,65])

add_block('built-in/Fcn',[sys,'/','qdr2abc/qdr2qs'])
set_param([sys,'/','qdr2abc/qdr2qs'],...
		'Expr','u[1]*u[3] + u[2]*u[4]',...
		'position',[190,64,310,86])

add_block('built-in/Fcn',[sys,'/','qdr2abc/qdr2ds'])
set_param([sys,'/','qdr2abc/qdr2ds'],...
		'Expr','u[1]*u[4] - u[2]*u[3]',...
		'position',[190,140,310,160])

add_block('built-in/Note',[sys,'/','qdr2abc/qdr2qds'])
set_param([sys,'/','qdr2abc/qdr2qds'],...
		'position',[255,15,260,20])

add_block('built-in/Note',[sys,'/','qdr2abc/qds2abc'])
set_param([sys,'/','qdr2abc/qds2abc'],...
		'position',[530,20,535,25])

add_block('built-in/Note',[sys,'/','qdr2abc/iqs'])
set_param([sys,'/','qdr2abc/iqs'],...
		'position',[330,55,335,60])

add_block('built-in/Note',[sys,'/','qdr2abc/ids'])
set_param([sys,'/','qdr2abc/ids'],...
		'position',[330,125,335,130])

add_block('built-in/Mux',[sys,'/','qdr2abc/Mux1'])
set_param([sys,'/','qdr2abc/Mux1'],...
		'inputs','2',...
		'position',[355,38,385,187])

add_block('built-in/Fcn',[sys,'/','qdr2abc/qds2a'])
set_param([sys,'/','qdr2abc/qds2a'],...
		'Expr','u[1] ',...
		'position',[435,44,605,66])

add_block('built-in/Outport',[sys,'/','qdr2abc/ia'])
set_param([sys,'/','qdr2abc/ia'],...
		'position',[645,44,670,66])

add_block('built-in/Fcn',[sys,'/','qdr2abc/qds2b'])
set_param([sys,'/','qdr2abc/qds2b'],...
		'Expr','-u[1]/2 -sqrt(3)*u[2]/2 ',...
		'position',[435,104,600,126])

add_block('built-in/Outport',[sys,'/','qdr2abc/ib'])
set_param([sys,'/','qdr2abc/ib'],...
		'Port','2',...
		'position',[645,104,670,126])

add_block('built-in/Fcn',[sys,'/','qdr2abc/qds2c'])
set_param([sys,'/','qdr2abc/qds2c'],...
		'Expr','-u[1]/2 +sqrt(3)*u[2]/2 ',...
		'position',[435,159,605,181])

add_block('built-in/Outport',[sys,'/','qdr2abc/ic'])
set_param([sys,'/','qdr2abc/ic'],...
		'Port','3',...
		'position',[650,158,675,182])
add_line([sys,'/','qdr2abc'],[85,55;120,55])
add_line([sys,'/','qdr2abc'],[85,95;120,95])
add_line([sys,'/','qdr2abc'],[85,135;120,135])
add_line([sys,'/','qdr2abc'],[85,175;120,175])
add_line([sys,'/','qdr2abc'],[160,115;165,115;165,75;185,75])
add_line([sys,'/','qdr2abc'],[160,115;165,115;165,150;185,150])
add_line([sys,'/','qdr2abc'],[315,75;350,75])
add_line([sys,'/','qdr2abc'],[315,150;350,150])
add_line([sys,'/','qdr2abc'],[390,115;430,115])
add_line([sys,'/','qdr2abc'],[390,115;420,115;430,55])
add_line([sys,'/','qdr2abc'],[610,55;640,55])
add_line([sys,'/','qdr2abc'],[605,115;640,115])
add_line([sys,'/','qdr2abc'],[390,115;420,115;430,170])
add_line([sys,'/','qdr2abc'],[610,170;645,170])


%     Finished composite block 'qdr2abc'.

set_param([sys,'/','qdr2abc'],...
		'Font Number',3,...
		'position',[875,165,915,245])

add_block('built-in/Note',[sys,'/','iq'])
set_param([sys,'/','iq'],...
		'position',[748,154,753,159])

add_block('built-in/Note',[sys,'/','id'])
set_param([sys,'/','id'],...
		'position',[748,184,753,189])

add_block('built-in/Note',[sys,'/','sin (wrt)'])
set_param([sys,'/','sin (wrt)'],...
		'position',[828,254,833,259])

add_block('built-in/Note',[sys,'/','cos (wrt)'])
set_param([sys,'/','cos (wrt)'],...
		'position',[828,234,833,239])

add_block('built-in/Note',[sys,'/','wr//wb'])
set_param([sys,'/','wr//wb'],...
		'position',[743,244,748,249])


%     Subsystem  'osc'.

new_system([sys,'/','osc'])
set_param([sys,'/','osc'],'Location',[280,55,870,299])

add_block('built-in/Gain',[sys,'/','osc/Gain'])
set_param([sys,'/','osc/Gain'],...
		'Gain','-wb',...
		'position',[135,63,180,97])

add_block('built-in/Product',[sys,'/','osc/Product'])
set_param([sys,'/','osc/Product'],...
		'position',[370,43,390,92])

add_block('built-in/Integrator',[sys,'/','osc/cos'])
set_param([sys,'/','osc/cos'],...
		'Initial','1',...
		'position',[215,63,245,97])

add_block('built-in/Inport',[sys,'/','osc/wr//wb'])
set_param([sys,'/','osc/wr//wb'],...
		'position',[30,45,50,65])

add_block('built-in/Integrator',[sys,'/','osc/sin'])
set_param([sys,'/','osc/sin'],...
		'orientation',2,...
		'position',[265,123,295,157])

add_block('built-in/Gain',[sys,'/','osc/Gain1'])
set_param([sys,'/','osc/Gain1'],...
		'orientation',2,...
		'Gain','wb',...
		'position',[340,120,385,160])

add_block('built-in/Product',[sys,'/','osc/Product1'])
set_param([sys,'/','osc/Product1'],...
		'orientation',2,...
		'position',[140,128,160,172])

add_block('built-in/Outport',[sys,'/','osc/cos_thetar'])
set_param([sys,'/','osc/cos_thetar'],...
		'position',[470,105,490,125])

add_block('built-in/Outport',[sys,'/','osc/sin_thetar'])
set_param([sys,'/','osc/sin_thetar'],...
		'Port','2',...
		'position',[470,160,490,180])
add_line([sys,'/','osc'],[260,140;165,140])
add_line([sys,'/','osc'],[250,80;270,80;270,115;465,115])
add_line([sys,'/','osc'],[395,70;415,70;415,140;390,140])
add_line([sys,'/','osc'],[55,55;365,55])
add_line([sys,'/','osc'],[250,80;365,80])
add_line([sys,'/','osc'],[185,80;210,80])
add_line([sys,'/','osc'],[135,150;115,150;115,80;130,80])
add_line([sys,'/','osc'],[335,140;300,140])
add_line([sys,'/','osc'],[55,55;90,55;90,190;200,190;200,160;165,160])
add_line([sys,'/','osc'],[260,140;230,140;230,170;465,170])


%     Finished composite block 'osc'.

set_param([sys,'/','osc'],...
		'position',[775,245,800,285])

add_block('built-in/Mux',[sys,'/','Mux'])
set_param([sys,'/','Mux'],...
		'orientation',3,...
		'inputs','9',...
		'position',[163,65,877,90])

add_block('built-in/Clock',[sys,'/','Clock'])
set_param([sys,'/','Clock'],...
		'orientation',3,...
		'position',[235,125,255,145])

add_block('built-in/Note',[sys,'/','Tem'])
set_param([sys,'/','Tem'],...
		'position',[743,219,748,224])


%     Subsystem  'm5'.

new_system([sys,'/','m5'])
set_param([sys,'/','m5'],'Location',[85,4128819,240,4128906])

add_block('built-in/Note',[sys,'/',['m5/Masked block m5.m to initialize',13,'s5.m in Chapter 10 and to plot results']])
set_param([sys,'/',['m5/Masked block m5.m to initialize',13,'s5.m in Chapter 10 and to plot results']],...
		'position',[120,50,125,55])
set_param([sys,'/','m5'],...
		'Mask Display','Initialize\nand plot',...
		'Mask Type','Masked block of m5.m',...
		'Mask Dialogue','eval(''m5'')',...
		'Mask Help','Uses m5.m to initialize and plot')


%     Finished composite block 'm5'.

set_param([sys,'/','m5'],...
		'Drop Shadow',4,...
		'position',[72,41,145,75])

add_block('built-in/Scope',[sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'Vgain','1.000000',...
		'Hgain','3.000000',...
		'Vmax','2.000000',...
		'Hmax','6.000000',...
		'Window',[20,497,832,625])
open_system([sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'position',[625,23,645,47])

add_block('built-in/To Workspace',[sys,'/','To Workspace'])
set_param([sys,'/','To Workspace'],...
		'orientation',2,...
		'mat-name','y',...
		'buffer','40000',...
		'position',[410,27,460,43])
add_line(sys,[245,120;245,115;200,115;200,95])
add_line(sys,[520,60;520,35;465,35])
add_line(sys,[430,180;435,180;435,170;470,170])
add_line(sys,[495,200;505,200])
add_line(sys,[500,165;510,165])
add_line(sys,[495,245;505,245])
add_line(sys,[140,120;125,120;125,105;280,95])
add_line(sys,[80,170;90,170])
add_line(sys,[615,205;665,205])
add_line(sys,[615,175;665,175])
add_line(sys,[715,175;870,175])
add_line(sys,[660,235;665,235])
add_line(sys,[655,270;665,265])
add_line(sys,[920,230;920,320;445,320;445,240;465,240])
add_line(sys,[920,205;945,205;945,325;450,325;450,195;465,195])
add_line(sys,[920,180;955,180;955,330;455,330;455,160;470,160])
add_line(sys,[430,205;465,205])
add_line(sys,[430,230;435,230;435,250;465,250])
add_line(sys,[805,275;805,340;555,340;555,245;570,245])
add_line(sys,[920,180;955,180;955,410;465,410])
add_line(sys,[920,205;945,205;945,425;465,425])
add_line(sys,[920,230;920,440;465,440])
add_line(sys,[245,265;250,265])
add_line(sys,[150,385;155,385])
add_line(sys,[105,375;125,375])
add_line(sys,[220,385;215,385;215,325;160,325;160,265;220,265])
add_line(sys,[210,240;220,255])
add_line(sys,[805,275;805,395;465,395])
add_line(sys,[805,275;855,275;855,235;870,235])
add_line(sys,[805,255;845,255;845,215;870,215])
add_line(sys,[805,255;820,255;820,380;465,380])
add_line(sys,[805,275;805,340;375,340;385,225])
add_line(sys,[805,255;820,255;820,365;360,365;360,210;385,210])
add_line(sys,[805,255;820,255;820,365;550,365;550,225;570,225])
add_line(sys,[540,165;570,165])
add_line(sys,[535,200;550,200;550,185;570,185])
add_line(sys,[535,245;545,245;545,205;570,205])
add_line(sys,[395,420;105,420;105,390;125,390])
add_line(sys,[155,170;190,170])
add_line(sys,[215,180;230,180])
add_line(sys,[215,180;215,215;160,215;170,240])
add_line(sys,[395,435;45,435;55,175])
add_line(sys,[395,405;230,405;230,310;180,310;180,275;220,275])
add_line(sys,[395,390;280,390;280,350;155,350;155,185;190,185])
add_line(sys,[520,60;520,35;620,35])
add_line(sys,[920,180;940,180;940,130;840,130;840,95])
add_line(sys,[540,165;550,165;550,125;600,125;600,95])
add_line(sys,[395,420;365,420;365,135;520,135;520,95])
add_line(sys,[280,180;290,180])
add_line(sys,[320,180;385,180])
add_line(sys,[320,180;320,105;360,95])
add_line(sys,[300,265;310,265])
add_line(sys,[340,265;355,265;355,195;385,195])
add_line(sys,[340,265;355,265;355,120;440,120;440,95])
add_line(sys,[140,120;105,120])
add_line(sys,[70,120;35,120;35,375;55,375])
add_line(sys,[70,120;35,120;35,160;55,160])
add_line(sys,[715,205;785,205;785,195;870,195])
add_line(sys,[715,265;770,265])
add_line(sys,[715,235;730,235;730,130;680,130;680,95])
add_line(sys,[715,265;760,265;760,95])

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
