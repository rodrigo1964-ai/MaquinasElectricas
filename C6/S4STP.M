function [ret,x0,str,ts,xts]=s4stp(t,x,u,flag);
%s4stp	is the M-file description of the SIMULINK system named s4stp.
%	The block-diagram can be displayed by typing: s4stp.
%
%	SYS=s4stp(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes s4stp to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling s4stp with a FLAG of zero:
%	[SIZES]=s4stp([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[76,59,630,240])
     open_system(sys)
end;
set_param(sys,'algorithm',     'Adams/Gear')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     '1.2')
set_param(sys,'Min step size', '0.0001')
set_param(sys,'Max step size', '0.0005')
set_param(sys,'Relative error','1e-6')
set_param(sys,'Return vars',   '')


%     Subsystem  's4eig'.

new_system([sys,'/','s4eig'])
set_param([sys,'/','s4eig'],'Location',[437,96,1056,514])

add_block('built-in/Note',[sys,'/','s4eig/psidse'])
set_param([sys,'/','s4eig/psidse'],...
		'position',[190,260,195,265])

add_block('built-in/Note',[sys,'/','s4eig/psiqre'])
set_param([sys,'/','s4eig/psiqre'],...
		'position',[185,120,190,125])

add_block('built-in/Note',[sys,'/','s4eig/psidre'])
set_param([sys,'/','s4eig/psidre'],...
		'position',[194,310,199,315])

add_block('built-in/Note',[sys,'/','s4eig/idse'])
set_param([sys,'/','s4eig/idse'],...
		'position',[190,275,195,280])

add_block('built-in/Note',[sys,'/','s4eig/Tem'])
set_param([sys,'/','s4eig/Tem'],...
		'position',[344,162,349,167])


%     Subsystem  's4eig/Rotor'.

new_system([sys,'/','s4eig/Rotor'])
set_param([sys,'/','s4eig/Rotor'],'Location',[219,388,854,634])

add_block('built-in/Note',[sys,'/','s4eig/Rotor/Tdamp'])
set_param([sys,'/','s4eig/Rotor/Tdamp'],...
		'position',[415,180,420,185])

add_block('built-in/Outport',[sys,'/','s4eig/Rotor/out_wr//wb'])
set_param([sys,'/','s4eig/Rotor/out_wr//wb'],...
		'Port','2',...
		'position',[550,123,570,147])

add_block('built-in/Integrator',[sys,'/','s4eig/Rotor/1//s'])
set_param([sys,'/','s4eig/Rotor/1//s'],...
		'Initial','wrbywbo',...
		'position',[480,118,515,152])

add_block('built-in/Gain',[sys,'/','s4eig/Rotor/1//2H'])
set_param([sys,'/','s4eig/Rotor/1//2H'],...
		'Gain','1/(2*H)',...
		'position',[395,109,460,161])

add_block('built-in/Sum',[sys,'/','s4eig/Rotor/Taccl'])
set_param([sys,'/','s4eig/Rotor/Taccl'],...
		'inputs','++-',...
		'position',[355,95,375,175])

add_block('built-in/Gain',[sys,'/',['s4eig/Rotor/Damping',13,'coefficient']])
set_param([sys,'/',['s4eig/Rotor/Damping',13,'coefficient']],...
		'orientation',2,...
		'Gain','Domega',...
		'position',[440,180,515,220])

add_block('built-in/Inport',[sys,'/','s4eig/Rotor/in_iqse'])
set_param([sys,'/','s4eig/Rotor/in_iqse'],...
		'Port','2',...
		'position',[60,80,80,100])

add_block('built-in/Inport',[sys,'/','s4eig/Rotor/in_psidse'])
set_param([sys,'/','s4eig/Rotor/in_psidse'],...
		'position',[60,40,80,60])

add_block('built-in/Inport',[sys,'/','s4eig/Rotor/in_idse'])
set_param([sys,'/','s4eig/Rotor/in_idse'],...
		'Port','4',...
		'position',[60,160,80,180])

add_block('built-in/Mux',[sys,'/','s4eig/Rotor/Mux'])
set_param([sys,'/','s4eig/Rotor/Mux'],...
		'position',[110,31,130,189])

add_block('built-in/Fcn',[sys,'/','s4eig/Rotor/Tem'])
set_param([sys,'/','s4eig/Rotor/Tem'],...
		'Expr','Tfactor*(u[1]*u[2] - u[3]*u[4])',...
		'position',[150,94,310,126])

add_block('built-in/Inport',[sys,'/','s4eig/Rotor/in_Tmech'])
set_param([sys,'/','s4eig/Rotor/in_Tmech'],...
		'Port','5',...
		'position',[60,200,80,220])

add_block('built-in/Outport',[sys,'/','s4eig/Rotor/out_Tem'])
set_param([sys,'/','s4eig/Rotor/out_Tem'],...
		'position',[540,50,560,70])

add_block('built-in/Inport',[sys,'/','s4eig/Rotor/in_psiqse'])
set_param([sys,'/','s4eig/Rotor/in_psiqse'],...
		'Port','3',...
		'position',[60,120,80,140])
add_line([sys,'/','s4eig/Rotor'],[435,200;330,200;330,160;350,160])
add_line([sys,'/','s4eig/Rotor'],[520,135;530,135;520,200])
add_line([sys,'/','s4eig/Rotor'],[315,110;325,110;325,60;535,60])
add_line([sys,'/','s4eig/Rotor'],[315,110;350,110])
add_line([sys,'/','s4eig/Rotor'],[465,135;475,135])
add_line([sys,'/','s4eig/Rotor'],[380,135;390,135])
add_line([sys,'/','s4eig/Rotor'],[85,210;310,210;310,135;350,135])
add_line([sys,'/','s4eig/Rotor'],[520,135;545,135])
add_line([sys,'/','s4eig/Rotor'],[135,110;145,110])
add_line([sys,'/','s4eig/Rotor'],[85,50;105,50])
add_line([sys,'/','s4eig/Rotor'],[85,90;105,90])
add_line([sys,'/','s4eig/Rotor'],[85,130;105,130])
add_line([sys,'/','s4eig/Rotor'],[85,170;105,170])


%     Finished composite block 's4eig/Rotor'.

set_param([sys,'/','s4eig/Rotor'],...
		'orientation',2,...
		'position',[365,159,405,231])

add_block('built-in/Note',[sys,'/','s4eig/wr//wb'])
set_param([sys,'/','s4eig/wr//wb'],...
		'position',[335,195,340,200])

add_block('built-in/Note',[sys,'/','s4eig/psiqse'])
set_param([sys,'/','s4eig/psiqse'],...
		'position',[200,75,205,80])


%     Subsystem  's4eig/Qaxis'.

new_system([sys,'/','s4eig/Qaxis'])
set_param([sys,'/','s4eig/Qaxis'],'Location',[368,432,1200,846])

add_block('built-in/Outport',[sys,'/',['s4eig/Qaxis/out_psiqr''']])
set_param([sys,'/',['s4eig/Qaxis/out_psiqr''']],...
		'Port','4',...
		'position',[790,265,810,285])

add_block('built-in/Note',[sys,'/',['s4eig/Qaxis/psiqr''']])
set_param([sys,'/',['s4eig/Qaxis/psiqr''']],...
		'position',[445,281,450,286])

add_block('built-in/Mux',[sys,'/','s4eig/Qaxis/Mux2'])
set_param([sys,'/','s4eig/Qaxis/Mux2'],...
		'inputs','2',...
		'position',[505,291,525,344])

add_block('built-in/Mux',[sys,'/','s4eig/Qaxis/Mux3'])
set_param([sys,'/','s4eig/Qaxis/Mux3'],...
		'inputs','2',...
		'position',[500,198,520,262])

add_block('built-in/Fcn',[sys,'/','s4eig/Qaxis/Fcn3'])
set_param([sys,'/','s4eig/Qaxis/Fcn3'],...
		'Expr','xM*(u[1]/xls+u[2]/xplr)',...
		'position',[540,212,690,248])

add_block('built-in/Fcn',[sys,'/','s4eig/Qaxis/Fcn2'])
set_param([sys,'/','s4eig/Qaxis/Fcn2'],...
		'Expr','wb*(u[2] +(rpr/xplr)*(u[3]-u[1]))',...
		'position',[200,289,380,321])

add_block('built-in/Note',[sys,'/',['s4eig/Qaxis/iqr''']])
set_param([sys,'/',['s4eig/Qaxis/iqr''']],...
		'position',[655,297,660,302])

add_block('built-in/Integrator',[sys,'/',['s4eig/Qaxis/psiqr''_']])
set_param([sys,'/',['s4eig/Qaxis/psiqr''_']],...
		'Initial','Psipqro',...
		'position',[400,290,425,320])

add_block('built-in/Fcn',[sys,'/','s4eig/Qaxis/Fcn5'])
set_param([sys,'/','s4eig/Qaxis/Fcn5'],...
		'Expr','(u[1]-u[2])/xplr',...
		'position',[545,305,640,335])

add_block('built-in/Outport',[sys,'/',['s4eig/Qaxis/out_iqr''']])
set_param([sys,'/',['s4eig/Qaxis/out_iqr''']],...
		'Port','3',...
		'position',[790,310,810,330])

add_block('built-in/Note',[sys,'/','s4eig/Qaxis/psiqm'])
set_param([sys,'/','s4eig/Qaxis/psiqm'],...
		'position',[720,205,725,210])

add_block('built-in/Note',[sys,'/','s4eig/Qaxis/psiqs'])
set_param([sys,'/','s4eig/Qaxis/psiqs'],...
		'position',[435,130,440,135])

add_block('built-in/Integrator',[sys,'/','s4eig/Qaxis/psiqs_'])
set_param([sys,'/','s4eig/Qaxis/psiqs_'],...
		'Initial','Psiqso',...
		'position',[395,140,420,170])

add_block('built-in/Note',[sys,'/','s4eig/Qaxis/iqs'])
set_param([sys,'/','s4eig/Qaxis/iqs'],...
		'position',[655,125,660,130])

add_block('built-in/Mux',[sys,'/','s4eig/Qaxis/Mux4'])
set_param([sys,'/','s4eig/Qaxis/Mux4'],...
		'inputs','2',...
		'position',[505,119,525,166])

add_block('built-in/Fcn',[sys,'/','s4eig/Qaxis/Fcn4'])
set_param([sys,'/','s4eig/Qaxis/Fcn4'],...
		'Expr','(u[1]-u[2])/xls',...
		'position',[550,131,640,159])

add_block('built-in/Outport',[sys,'/','s4eig/Qaxis/out_iqs'])
set_param([sys,'/','s4eig/Qaxis/out_iqs'],...
		'Port','2',...
		'position',[790,135,810,155])

add_block('built-in/Outport',[sys,'/','s4eig/Qaxis/out_psiqs'])
set_param([sys,'/','s4eig/Qaxis/out_psiqs'],...
		'position',[790,70,810,90])

add_block('built-in/Fcn',[sys,'/','s4eig/Qaxis/Fcn'])
set_param([sys,'/','s4eig/Qaxis/Fcn'],...
		'Expr','wb*(u[2]-(we/wb)*u[4]+(rs/xls)*(u[1]-u[3]))',...
		'position',[140,141,380,169])

add_block('built-in/Mux',[sys,'/','s4eig/Qaxis/Mux1'])
set_param([sys,'/','s4eig/Qaxis/Mux1'],...
		'inputs','3',...
		'position',[120,267,140,343])

add_block('built-in/Inport',[sys,'/','s4eig/Qaxis/in_vqs'])
set_param([sys,'/','s4eig/Qaxis/in_vqs'],...
		'position',[45,135,65,155])

add_block('built-in/Inport',[sys,'/','s4eig/Qaxis/in_psids'])
set_param([sys,'/','s4eig/Qaxis/in_psids'],...
		'Port','3',...
		'position',[45,175,65,195])

add_block('built-in/Mux',[sys,'/','s4eig/Qaxis/Mux'])
set_param([sys,'/','s4eig/Qaxis/Mux'],...
		'position',[105,113,125,197])

add_block('built-in/Inport',[sys,'/',['s4eig/Qaxis/(wr-we)*psidr''//wb']])
set_param([sys,'/',['s4eig/Qaxis/(wr-we)*psidr''//wb']],...
		'Port','2',...
		'position',[55,295,75,315])
add_line([sys,'/','s4eig/Qaxis'],[695,230;750,230;750,370;465,370;465,330;500,330])
add_line([sys,'/','s4eig/Qaxis'],[430,305;500,305])
add_line([sys,'/','s4eig/Qaxis'],[530,320;540,320])
add_line([sys,'/','s4eig/Qaxis'],[430,305;470,305;470,245;495,245])
add_line([sys,'/','s4eig/Qaxis'],[425,155;435,155;435,215;85,215;85,165;100,165])
add_line([sys,'/','s4eig/Qaxis'],[430,305;470,305;470,245;90,245;90,280;115,280])
add_line([sys,'/','s4eig/Qaxis'],[145,305;195,305])
add_line([sys,'/','s4eig/Qaxis'],[695,230;750,230;750,95;80,95;80,125;100,125])
add_line([sys,'/','s4eig/Qaxis'],[695,230;750,230;750,370;90,370;90,330;115,330])
add_line([sys,'/','s4eig/Qaxis'],[695,230;750,230;750,185;480,185;480,155;500,155])
add_line([sys,'/','s4eig/Qaxis'],[425,155;460,155;460,130;500,130])
add_line([sys,'/','s4eig/Qaxis'],[530,145;545,145])
add_line([sys,'/','s4eig/Qaxis'],[525,230;535,230])
add_line([sys,'/','s4eig/Qaxis'],[425,155;460,155;460,215;495,215])
add_line([sys,'/','s4eig/Qaxis'],[385,305;395,305])
add_line([sys,'/','s4eig/Qaxis'],[385,155;390,155])
add_line([sys,'/','s4eig/Qaxis'],[130,155;135,155])
add_line([sys,'/','s4eig/Qaxis'],[645,145;785,145])
add_line([sys,'/','s4eig/Qaxis'],[425,155;460,155;460,80;785,80])
add_line([sys,'/','s4eig/Qaxis'],[70,145;100,145])
add_line([sys,'/','s4eig/Qaxis'],[80,305;115,305])
add_line([sys,'/','s4eig/Qaxis'],[645,320;785,320])
add_line([sys,'/','s4eig/Qaxis'],[430,305;470,305;470,275;785,275])
add_line([sys,'/','s4eig/Qaxis'],[70,185;100,185])


%     Finished composite block 's4eig/Qaxis'.

set_param([sys,'/','s4eig/Qaxis'],...
		'position',[130,90,165,145])

add_block('built-in/Note',[sys,'/','s4eig/iqse'])
set_param([sys,'/','s4eig/iqse'],...
		'position',[195,90,200,95])


%     Subsystem  's4eig/Daxis'.

new_system([sys,'/','s4eig/Daxis'])
set_param([sys,'/','s4eig/Daxis'],'Location',[213,440,1045,854])

add_block('built-in/Outport',[sys,'/',['s4eig/Daxis/out_psidr''']])
set_param([sys,'/',['s4eig/Daxis/out_psidr''']],...
		'Port','4',...
		'position',[785,260,805,280])

add_block('built-in/Note',[sys,'/',['s4eig/Daxis/psidr''']])
set_param([sys,'/',['s4eig/Daxis/psidr''']],...
		'position',[440,276,445,281])

add_block('built-in/Mux',[sys,'/','s4eig/Daxis/Mux2'])
set_param([sys,'/','s4eig/Daxis/Mux2'],...
		'inputs','2',...
		'position',[500,286,520,339])

add_block('built-in/Mux',[sys,'/','s4eig/Daxis/Mux3'])
set_param([sys,'/','s4eig/Daxis/Mux3'],...
		'inputs','2',...
		'position',[495,193,515,257])

add_block('built-in/Fcn',[sys,'/','s4eig/Daxis/Fcn3'])
set_param([sys,'/','s4eig/Daxis/Fcn3'],...
		'Expr','xM*(u[1]/xls+u[2]/xplr)',...
		'position',[535,207,685,243])

add_block('built-in/Note',[sys,'/',['s4eig/Daxis/idr''']])
set_param([sys,'/',['s4eig/Daxis/idr''']],...
		'position',[650,292,655,297])

add_block('built-in/Integrator',[sys,'/',['s4eig/Daxis/psidr''_']])
set_param([sys,'/',['s4eig/Daxis/psidr''_']],...
		'Initial','Psipdro',...
		'position',[395,287,425,313])

add_block('built-in/Fcn',[sys,'/','s4eig/Daxis/Fcn5'])
set_param([sys,'/','s4eig/Daxis/Fcn5'],...
		'Expr','(u[1]-u[2])/xplr',...
		'position',[540,300,635,330])

add_block('built-in/Outport',[sys,'/',['s4eig/Daxis/out_idr''']])
set_param([sys,'/',['s4eig/Daxis/out_idr''']],...
		'Port','3',...
		'position',[785,305,805,325])

add_block('built-in/Note',[sys,'/','s4eig/Daxis/psiqm'])
set_param([sys,'/','s4eig/Daxis/psiqm'],...
		'position',[715,200,720,205])

add_block('built-in/Note',[sys,'/','s4eig/Daxis/psids'])
set_param([sys,'/','s4eig/Daxis/psids'],...
		'position',[430,125,435,130])

add_block('built-in/Integrator',[sys,'/','s4eig/Daxis/psids_'])
set_param([sys,'/','s4eig/Daxis/psids_'],...
		'Initial','Psidso',...
		'position',[390,136,415,164])

add_block('built-in/Note',[sys,'/','s4eig/Daxis/ids'])
set_param([sys,'/','s4eig/Daxis/ids'],...
		'position',[650,120,655,125])

add_block('built-in/Mux',[sys,'/','s4eig/Daxis/Mux4'])
set_param([sys,'/','s4eig/Daxis/Mux4'],...
		'inputs','2',...
		'position',[500,114,520,161])

add_block('built-in/Fcn',[sys,'/','s4eig/Daxis/Fcn4'])
set_param([sys,'/','s4eig/Daxis/Fcn4'],...
		'Expr','(u[1]-u[2])/xls',...
		'position',[545,126,635,154])

add_block('built-in/Outport',[sys,'/','s4eig/Daxis/out_ids'])
set_param([sys,'/','s4eig/Daxis/out_ids'],...
		'Port','2',...
		'position',[785,130,805,150])

add_block('built-in/Outport',[sys,'/','s4eig/Daxis/out_psids'])
set_param([sys,'/','s4eig/Daxis/out_psids'],...
		'position',[785,65,805,85])

add_block('built-in/Fcn',[sys,'/','s4eig/Daxis/Fcn'])
set_param([sys,'/','s4eig/Daxis/Fcn'],...
		'Expr','wb*(u[2]+(we/wb)*u[4]+(rs/xls)*(u[1]-u[3]))',...
		'position',[130,135,370,165])

add_block('built-in/Mux',[sys,'/','s4eig/Daxis/Mux'])
set_param([sys,'/','s4eig/Daxis/Mux'],...
		'position',[95,108,115,192])

add_block('built-in/Inport',[sys,'/','s4eig/Daxis/in_vds'])
set_param([sys,'/','s4eig/Daxis/in_vds'],...
		'position',[40,130,60,150])

add_block('built-in/Inport',[sys,'/','s4eig/Daxis/in_psiqs'])
set_param([sys,'/','s4eig/Daxis/in_psiqs'],...
		'Port','3',...
		'position',[35,170,55,190])

add_block('built-in/Inport',[sys,'/',['s4eig/Daxis/in_(wr//wb)*psiqr''']])
set_param([sys,'/',['s4eig/Daxis/in_(wr//wb)*psiqr''']],...
		'Port','2',...
		'position',[40,290,60,310])

add_block('built-in/Mux',[sys,'/','s4eig/Daxis/Mux1'])
set_param([sys,'/','s4eig/Daxis/Mux1'],...
		'inputs','3',...
		'position',[100,262,120,338])

add_block('built-in/Fcn',[sys,'/','s4eig/Daxis/Fcn2'])
set_param([sys,'/','s4eig/Daxis/Fcn2'],...
		'Expr','wb*(-u[2] +(rpr/xplr)*(u[3]-u[1]))',...
		'position',[165,284,345,316])
add_line([sys,'/','s4eig/Daxis'],[690,225;745,225;745,365;460,365;460,325;495,325])
add_line([sys,'/','s4eig/Daxis'],[430,300;495,300])
add_line([sys,'/','s4eig/Daxis'],[525,315;535,315])
add_line([sys,'/','s4eig/Daxis'],[430,300;465,300;465,240;490,240])
add_line([sys,'/','s4eig/Daxis'],[420,150;455,150;455,210;80,210;90,160])
add_line([sys,'/','s4eig/Daxis'],[430,300;465,300;465,240;75,240;75,275;95,275])
add_line([sys,'/','s4eig/Daxis'],[125,300;160,300])
add_line([sys,'/','s4eig/Daxis'],[690,225;745,225;745,90;75,90;75,120;90,120])
add_line([sys,'/','s4eig/Daxis'],[690,225;745,225;745,365;75,365;75,325;95,325])
add_line([sys,'/','s4eig/Daxis'],[690,225;745,225;745,180;475,180;475,150;495,150])
add_line([sys,'/','s4eig/Daxis'],[420,150;455,150;455,125;495,125])
add_line([sys,'/','s4eig/Daxis'],[525,140;540,140])
add_line([sys,'/','s4eig/Daxis'],[520,225;530,225])
add_line([sys,'/','s4eig/Daxis'],[420,150;455,150;455,210;490,210])
add_line([sys,'/','s4eig/Daxis'],[350,300;390,300])
add_line([sys,'/','s4eig/Daxis'],[375,150;385,150])
add_line([sys,'/','s4eig/Daxis'],[120,150;125,150])
add_line([sys,'/','s4eig/Daxis'],[640,140;780,140])
add_line([sys,'/','s4eig/Daxis'],[420,150;455,150;455,75;780,75])
add_line([sys,'/','s4eig/Daxis'],[65,140;90,140])
add_line([sys,'/','s4eig/Daxis'],[65,300;95,300])
add_line([sys,'/','s4eig/Daxis'],[640,315;780,315])
add_line([sys,'/','s4eig/Daxis'],[430,300;465,300;465,270;780,270])
add_line([sys,'/','s4eig/Daxis'],[60,180;90,180])


%     Finished composite block 's4eig/Daxis'.

set_param([sys,'/','s4eig/Daxis'],...
		'position',[135,270,170,325])

add_block('built-in/Product',[sys,'/','s4eig/Prod1'])
set_param([sys,'/','s4eig/Prod1'],...
		'orientation',2,...
		'position',[140,218,160,242])

add_block('built-in/Product',[sys,'/','s4eig/Prod'])
set_param([sys,'/','s4eig/Prod'],...
		'orientation',2,...
		'position',[140,169,160,191])

add_block('built-in/Note',[sys,'/','s4eig/(wr-we)//wb'])
set_param([sys,'/','s4eig/(wr-we)//wb'],...
		'position',[215,200,220,205])

add_block('built-in/Sum',[sys,'/','s4eig/Sum'])
set_param([sys,'/','s4eig/Sum'],...
		'orientation',2,...
		'inputs','+-',...
		'position',[255,205,270,240])

add_block('built-in/Constant',[sys,'/','s4eig/we//wb'])
set_param([sys,'/','s4eig/we//wb'],...
		'orientation',2,...
		'position',[295,220,315,240])

add_block('built-in/Outport',[sys,'/','s4eig/out_wr//wb'])
set_param([sys,'/','s4eig/out_wr//wb'],...
		'orientation',1,...
		'Port','4',...
		'position',[330,255,350,275])

add_block('built-in/Outport',[sys,'/','s4eig/out_Tem'])
set_param([sys,'/','s4eig/out_Tem'],...
		'orientation',2,...
		'Port','3',...
		'position',[265,140,285,160])

add_block('built-in/Inport',[sys,'/','s4eig/in_vqse'])
set_param([sys,'/','s4eig/in_vqse'],...
		'position',[30,90,50,110])

add_block('built-in/Inport',[sys,'/','s4eig/in_vdse'])
set_param([sys,'/','s4eig/in_vdse'],...
		'Port','2',...
		'position',[30,270,50,290])

add_block('built-in/Inport',[sys,'/','s4eig/in_Tmech'])
set_param([sys,'/','s4eig/in_Tmech'],...
		'Port','3',...
		'position',[30,330,50,350])

add_block('built-in/Outport',[sys,'/','s4eig/out_idse'])
set_param([sys,'/','s4eig/out_idse'],...
		'Port','2',...
		'position',[515,280,535,300])

add_block('built-in/Outport',[sys,'/','s4eig/out_iqse'])
set_param([sys,'/','s4eig/out_iqse'],...
		'position',[520,100,540,120])
add_line([sys,'/','s4eig'],[170,95;175,95;175,85;85,85;85,320;130,320])
add_line([sys,'/','s4eig'],[250,225;165,225])
add_line([sys,'/','s4eig'],[250,225;205,225;205,185;165,185])
add_line([sys,'/','s4eig'],[290,230;275,230])
add_line([sys,'/','s4eig'],[360,215;275,215])
add_line([sys,'/','s4eig'],[175,290;495,290;495,210;410,210])
add_line([sys,'/','s4eig'],[135,230;110,230;110,120;125,120])
add_line([sys,'/','s4eig'],[170,95;475,95;475,195;410,195])
add_line([sys,'/','s4eig'],[170,110;495,110;495,180;410,180])
add_line([sys,'/','s4eig'],[135,180;120,180;130,300])
add_line([sys,'/','s4eig'],[175,290;450,290;450,165;410,165])
add_line([sys,'/','s4eig'],[170,140;215,140;215,175;165,175])
add_line([sys,'/','s4eig'],[175,320;205,320;205,235;165,235])
add_line([sys,'/','s4eig'],[55,100;125,100])
add_line([sys,'/','s4eig'],[170,110;515,110])
add_line([sys,'/','s4eig'],[360,180;325,180;325,150;290,150])
add_line([sys,'/','s4eig'],[360,215;340,215;340,250])
add_line([sys,'/','s4eig'],[55,280;130,280])
add_line([sys,'/','s4eig'],[175,290;510,290])
add_line([sys,'/','s4eig'],[175,275;185,275;185,260;100,260;100,140;125,140])
add_line([sys,'/','s4eig'],[55,340;430,340;430,225;410,225])


%     Finished composite block 's4eig'.

set_param([sys,'/','s4eig'],...
		'position',[180,26,260,154])

add_block('built-in/To Workspace',[sys,'/','To Workspace'])
set_param([sys,'/','To Workspace'],...
		'mat-name','y',...
		'buffer','500',...
		'position',[395,122,445,138])

add_block('built-in/Mux',[sys,'/','Mux'])
set_param([sys,'/','Mux'],...
		'inputs','2',...
		'position',[330,111,360,144])

add_block('built-in/Note',[sys,'/','wr//wb'])
set_param([sys,'/','wr//wb'],...
		'position',[280,115,285,120])


%     Subsystem  'Vqse'.

new_system([sys,'/','Vqse'])
set_param([sys,'/','Vqse'],'Location',[5,40,315,196])

add_block('built-in/Outport',[sys,'/','Vqse/out_1'])
set_param([sys,'/','Vqse/out_1'],...
		'position',[285,60,305,80])

add_block('built-in/Look Up Table',[sys,'/','Vqse/Look-Up Table'])
set_param([sys,'/','Vqse/Look-Up Table'],...
		'Input_Values','t',...
		'Output_Values','y',...
		'position',[210,58,250,82])

add_block('built-in/Fcn',[sys,'/','Vqse/Fcn1'])
set_param([sys,'/','Vqse/Fcn1'],...
		'Expr','rem(u[1],period)',...
		'position',[110,60,150,80])

add_block('built-in/Clock',[sys,'/','Vqse/Clock'])
set_param([sys,'/','Vqse/Clock'],...
		'position',[45,60,65,80])
add_line([sys,'/','Vqse'],[255,70;280,70])
add_line([sys,'/','Vqse'],[70,70;105,70])
add_line([sys,'/','Vqse'],[155,70;205,70])
set_param([sys,'/','Vqse'],...
		'Mask Display','plot([t,t+period,t+2*period],[y,y,y])',...
		'Mask Type','Repeating table',...
		'Mask Dialogue','Repeating table.\nEnter values of time and output for first cycle.|Time values:|Output values:')
set_param([sys,'/','Vqse'],...
		'Mask Translate','period = max(@1); t = @1; y = @2;',...
		'Mask Help','Repeats cycle given in table. Time values should be monotonically increasing.',...
		'Mask Entries','[0 1 1 1.2]\/[Vm Vm Vm+1 Vm+1]\/')


%     Finished composite block 'Vqse'.

set_param([sys,'/','Vqse'],...
		'position',[85,33,145,67])

add_block('built-in/Constant',[sys,'/','Tmech'])
set_param([sys,'/','Tmech'],...
		'Value','-Tb',...
		'position',[85,120,145,140])

add_block('built-in/Clock',[sys,'/','Clock'])
set_param([sys,'/','Clock'],...
		'orientation',1,...
		'position',[295,90,315,110])

add_block('built-in/Scope',[sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'Vgain','2.000000',...
		'Hgain','1.200000',...
		'Vmax','4.000000',...
		'Hmax','2.400000',...
		'Window',[82,261,668,480])
open_system([sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'position',[410,84,435,106])


%     Subsystem  'm4stp'.

new_system([sys,'/','m4stp'])
set_param([sys,'/','m4stp'],'Location',[275,5308650,520,5308755])

add_block('built-in/Note',[sys,'/',['m4stp/This masked block uses m4stp.m',13,'to initialize the s4stp.m with',13,'machine parameters and plot the simulated',13,'results.']])
set_param([sys,'/',['m4stp/This masked block uses m4stp.m',13,'to initialize the s4stp.m with',13,'machine parameters and plot the simulated',13,'results.']],...
		'position',[140,41,145,46])
set_param([sys,'/','m4stp'],...
		'Mask Display','Initialize\nand plot',...
		'Mask Type','Masked block of m4stp.m',...
		'Mask Dialogue','eval(''m4stp'')',...
		'Mask Help','Uses m4stp.m to initialize and plot')


%     Finished composite block 'm4stp'.

set_param([sys,'/','m4stp'],...
		'Drop Shadow',4,...
		'position',[327,22,407,59])
add_line(sys,[305,115;305,120;325,120])
add_line(sys,[365,130;390,130])
add_line(sys,[150,50;175,50])
add_line(sys,[265,135;325,135])
add_line(sys,[150,130;175,130])
add_line(sys,[365,130;375,130;375,95;405,95])

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
