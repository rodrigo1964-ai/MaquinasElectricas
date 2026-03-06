function [ret,x0,str,ts,xts]=s4eig(t,x,u,flag);
%s4eig	is the M-file description of the SIMULINK system named s4eig.
%	The block-diagram can be displayed by typing: s4eig.
%
%	SYS=s4eig(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes s4eig to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling s4eig with a FLAG of zero:
%	[SIZES]=s4eig([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[213,66,922,484])
     open_system(sys)
end;
set_param(sys,'algorithm',     'RK-45')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     '999999')
set_param(sys,'Min step size', '0.0001')
set_param(sys,'Max step size', '10')
set_param(sys,'Relative error','1e-3')
set_param(sys,'Return vars',   '')

add_block('built-in/Outport',[sys,'/','out_4'])
set_param([sys,'/','out_4'],...
		'orientation',1,...
		'Port','4',...
		'position',[430,240,450,260])

add_block('built-in/Inport',[sys,'/','vdse'])
set_param([sys,'/','vdse'],...
		'Port','2',...
		'position',[95,260,115,280])

add_block('built-in/Inport',[sys,'/','vqse'])
set_param([sys,'/','vqse'],...
		'position',[95,80,115,100])

add_block('built-in/Note',[sys,'/','psiqre'])
set_param([sys,'/','psiqre'],...
		'position',[265,112,270,117])

add_block('built-in/Note',[sys,'/','psidse'])
set_param([sys,'/','psidse'],...
		'position',[285,247,290,252])

add_block('built-in/Note',[sys,'/','idse_'])
set_param([sys,'/','idse_'],...
		'position',[280,262,285,267])

add_block('built-in/Inport',[sys,'/','Tmech'])
set_param([sys,'/','Tmech'],...
		'Port','3',...
		'position',[95,315,115,335])


%     Subsystem  'Qaxis'.

new_system([sys,'/','Qaxis'])
set_param([sys,'/','Qaxis'],'Location',[360,432,1192,846])

add_block('built-in/Outport',[sys,'/',['Qaxis/out_psiqr''']])
set_param([sys,'/',['Qaxis/out_psiqr''']],...
		'Port','4',...
		'position',[790,265,810,285])

add_block('built-in/Note',[sys,'/',['Qaxis/psiqr''']])
set_param([sys,'/',['Qaxis/psiqr''']],...
		'position',[445,281,450,286])

add_block('built-in/Mux',[sys,'/','Qaxis/Mux2'])
set_param([sys,'/','Qaxis/Mux2'],...
		'inputs','2',...
		'position',[505,291,525,344])

add_block('built-in/Mux',[sys,'/','Qaxis/Mux3'])
set_param([sys,'/','Qaxis/Mux3'],...
		'inputs','2',...
		'position',[500,198,520,262])

add_block('built-in/Fcn',[sys,'/','Qaxis/Fcn3'])
set_param([sys,'/','Qaxis/Fcn3'],...
		'Expr','xM*(u[1]/xls+u[2]/xplr)',...
		'position',[540,212,690,248])

add_block('built-in/Note',[sys,'/',['Qaxis/iqr''']])
set_param([sys,'/',['Qaxis/iqr''']],...
		'position',[655,297,660,302])

add_block('built-in/Fcn',[sys,'/','Qaxis/Fcn5'])
set_param([sys,'/','Qaxis/Fcn5'],...
		'Expr','(u[1]-u[2])/xplr',...
		'position',[545,305,640,335])

add_block('built-in/Outport',[sys,'/',['Qaxis/out_iqr''']])
set_param([sys,'/',['Qaxis/out_iqr''']],...
		'Port','3',...
		'position',[790,310,810,330])

add_block('built-in/Note',[sys,'/','Qaxis/psiqm'])
set_param([sys,'/','Qaxis/psiqm'],...
		'position',[720,205,725,210])

add_block('built-in/Note',[sys,'/','Qaxis/psiqs'])
set_param([sys,'/','Qaxis/psiqs'],...
		'position',[435,130,440,135])

add_block('built-in/Integrator',[sys,'/','Qaxis/psiqs_'])
set_param([sys,'/','Qaxis/psiqs_'],...
		'Initial','Psiqso',...
		'position',[395,140,420,170])

add_block('built-in/Note',[sys,'/','Qaxis/iqs'])
set_param([sys,'/','Qaxis/iqs'],...
		'position',[655,125,660,130])

add_block('built-in/Mux',[sys,'/','Qaxis/Mux4'])
set_param([sys,'/','Qaxis/Mux4'],...
		'inputs','2',...
		'position',[505,119,525,166])

add_block('built-in/Fcn',[sys,'/','Qaxis/Fcn4'])
set_param([sys,'/','Qaxis/Fcn4'],...
		'Expr','(u[1]-u[2])/xls',...
		'position',[550,131,640,159])

add_block('built-in/Outport',[sys,'/','Qaxis/out_iqs'])
set_param([sys,'/','Qaxis/out_iqs'],...
		'Port','2',...
		'position',[790,135,810,155])

add_block('built-in/Outport',[sys,'/','Qaxis/out_psiqs'])
set_param([sys,'/','Qaxis/out_psiqs'],...
		'position',[790,70,810,90])

add_block('built-in/Fcn',[sys,'/','Qaxis/Fcn'])
set_param([sys,'/','Qaxis/Fcn'],...
		'Expr','wb*(u[2]-(we/wb)*u[4]+(rs/xls)*(u[1]-u[3]))',...
		'position',[140,141,380,169])

add_block('built-in/Mux',[sys,'/','Qaxis/Mux1'])
set_param([sys,'/','Qaxis/Mux1'],...
		'inputs','3',...
		'position',[120,267,140,343])

add_block('built-in/Inport',[sys,'/','Qaxis/in_vqs'])
set_param([sys,'/','Qaxis/in_vqs'],...
		'position',[45,135,65,155])

add_block('built-in/Inport',[sys,'/','Qaxis/in_psids'])
set_param([sys,'/','Qaxis/in_psids'],...
		'Port','3',...
		'position',[45,175,65,195])

add_block('built-in/Mux',[sys,'/','Qaxis/Mux'])
set_param([sys,'/','Qaxis/Mux'],...
		'position',[105,113,125,197])

add_block('built-in/Inport',[sys,'/',['Qaxis/(wr-we)*psidr''//wb']])
set_param([sys,'/',['Qaxis/(wr-we)*psidr''//wb']],...
		'Port','2',...
		'position',[55,295,75,315])

add_block('built-in/Integrator',[sys,'/',['Qaxis/psiqr''_']])
set_param([sys,'/',['Qaxis/psiqr''_']],...
		'Initial','Psipqro',...
		'position',[400,291,425,319])

add_block('built-in/Fcn',[sys,'/','Qaxis/Fcn2'])
set_param([sys,'/','Qaxis/Fcn2'],...
		'Expr','wb*(u[2] +(rpr/xplr)*(u[3]-u[1]))',...
		'position',[175,289,355,321])
add_line([sys,'/','Qaxis'],[695,230;750,230;750,370;465,370;465,330;500,330])
add_line([sys,'/','Qaxis'],[430,305;500,305])
add_line([sys,'/','Qaxis'],[530,320;540,320])
add_line([sys,'/','Qaxis'],[430,305;470,305;470,245;495,245])
add_line([sys,'/','Qaxis'],[425,155;435,155;435,215;85,215;85,165;100,165])
add_line([sys,'/','Qaxis'],[430,305;470,305;470,245;90,245;90,280;115,280])
add_line([sys,'/','Qaxis'],[145,305;170,305])
add_line([sys,'/','Qaxis'],[695,230;750,230;750,95;80,95;80,125;100,125])
add_line([sys,'/','Qaxis'],[695,230;750,230;750,370;90,370;90,330;115,330])
add_line([sys,'/','Qaxis'],[695,230;750,230;750,185;480,185;480,155;500,155])
add_line([sys,'/','Qaxis'],[425,155;460,155;460,130;500,130])
add_line([sys,'/','Qaxis'],[530,145;545,145])
add_line([sys,'/','Qaxis'],[525,230;535,230])
add_line([sys,'/','Qaxis'],[425,155;460,155;460,215;495,215])
add_line([sys,'/','Qaxis'],[360,305;395,305])
add_line([sys,'/','Qaxis'],[385,155;390,155])
add_line([sys,'/','Qaxis'],[130,155;135,155])
add_line([sys,'/','Qaxis'],[645,145;785,145])
add_line([sys,'/','Qaxis'],[425,155;460,155;460,80;785,80])
add_line([sys,'/','Qaxis'],[70,145;100,145])
add_line([sys,'/','Qaxis'],[80,305;115,305])
add_line([sys,'/','Qaxis'],[645,320;785,320])
add_line([sys,'/','Qaxis'],[430,305;470,305;470,275;785,275])
add_line([sys,'/','Qaxis'],[70,185;100,185])


%     Finished composite block 'Qaxis'.

set_param([sys,'/','Qaxis'],...
		'position',[215,80,250,135])


%     Subsystem  'Daxis'.

new_system([sys,'/','Daxis'])
set_param([sys,'/','Daxis'],'Location',[213,440,1045,854])

add_block('built-in/Outport',[sys,'/',['Daxis/out_psidr''']])
set_param([sys,'/',['Daxis/out_psidr''']],...
		'Port','4',...
		'position',[785,260,805,280])

add_block('built-in/Note',[sys,'/',['Daxis/psidr''']])
set_param([sys,'/',['Daxis/psidr''']],...
		'position',[440,276,445,281])

add_block('built-in/Mux',[sys,'/','Daxis/Mux2'])
set_param([sys,'/','Daxis/Mux2'],...
		'inputs','2',...
		'position',[500,286,520,339])

add_block('built-in/Mux',[sys,'/','Daxis/Mux3'])
set_param([sys,'/','Daxis/Mux3'],...
		'inputs','2',...
		'position',[495,193,515,257])

add_block('built-in/Fcn',[sys,'/','Daxis/Fcn3'])
set_param([sys,'/','Daxis/Fcn3'],...
		'Expr','xM*(u[1]/xls+u[2]/xplr)',...
		'position',[535,207,685,243])

add_block('built-in/Note',[sys,'/',['Daxis/idr''']])
set_param([sys,'/',['Daxis/idr''']],...
		'position',[650,292,655,297])

add_block('built-in/Fcn',[sys,'/','Daxis/Fcn5'])
set_param([sys,'/','Daxis/Fcn5'],...
		'Expr','(u[1]-u[2])/xplr',...
		'position',[540,300,635,330])

add_block('built-in/Outport',[sys,'/',['Daxis/out_idr''']])
set_param([sys,'/',['Daxis/out_idr''']],...
		'Port','3',...
		'position',[785,305,805,325])

add_block('built-in/Note',[sys,'/','Daxis/psiqm'])
set_param([sys,'/','Daxis/psiqm'],...
		'position',[715,200,720,205])

add_block('built-in/Note',[sys,'/','Daxis/psids'])
set_param([sys,'/','Daxis/psids'],...
		'position',[430,125,435,130])

add_block('built-in/Integrator',[sys,'/','Daxis/psids_'])
set_param([sys,'/','Daxis/psids_'],...
		'Initial','Psidso',...
		'position',[390,136,415,164])

add_block('built-in/Note',[sys,'/','Daxis/ids'])
set_param([sys,'/','Daxis/ids'],...
		'position',[650,120,655,125])

add_block('built-in/Mux',[sys,'/','Daxis/Mux4'])
set_param([sys,'/','Daxis/Mux4'],...
		'inputs','2',...
		'position',[500,114,520,161])

add_block('built-in/Fcn',[sys,'/','Daxis/Fcn4'])
set_param([sys,'/','Daxis/Fcn4'],...
		'Expr','(u[1]-u[2])/xls',...
		'position',[545,126,635,154])

add_block('built-in/Outport',[sys,'/','Daxis/out_ids'])
set_param([sys,'/','Daxis/out_ids'],...
		'Port','2',...
		'position',[785,130,805,150])

add_block('built-in/Outport',[sys,'/','Daxis/out_psids'])
set_param([sys,'/','Daxis/out_psids'],...
		'position',[785,65,805,85])

add_block('built-in/Fcn',[sys,'/','Daxis/Fcn'])
set_param([sys,'/','Daxis/Fcn'],...
		'Expr','wb*(u[2]+(we/wb)*u[4]+(rs/xls)*(u[1]-u[3]))',...
		'position',[130,135,370,165])

add_block('built-in/Mux',[sys,'/','Daxis/Mux'])
set_param([sys,'/','Daxis/Mux'],...
		'position',[95,108,115,192])

add_block('built-in/Inport',[sys,'/','Daxis/in_vds'])
set_param([sys,'/','Daxis/in_vds'],...
		'position',[40,130,60,150])

add_block('built-in/Inport',[sys,'/','Daxis/in_psiqs'])
set_param([sys,'/','Daxis/in_psiqs'],...
		'Port','3',...
		'position',[35,170,55,190])

add_block('built-in/Inport',[sys,'/',['Daxis/in_(wr//wb)*psiqr''']])
set_param([sys,'/',['Daxis/in_(wr//wb)*psiqr''']],...
		'Port','2',...
		'position',[40,290,60,310])

add_block('built-in/Mux',[sys,'/','Daxis/Mux1'])
set_param([sys,'/','Daxis/Mux1'],...
		'inputs','3',...
		'position',[100,262,120,338])

add_block('built-in/Fcn',[sys,'/','Daxis/Fcn2'])
set_param([sys,'/','Daxis/Fcn2'],...
		'Expr','wb*(-u[2] +(rpr/xplr)*(u[3]-u[1]))',...
		'position',[165,284,345,316])

add_block('built-in/Integrator',[sys,'/',['Daxis/psidr''_']])
set_param([sys,'/',['Daxis/psidr''_']],...
		'Initial','Psipdro',...
		'position',[390,285,420,315])
add_line([sys,'/','Daxis'],[690,225;745,225;745,365;460,365;460,325;495,325])
add_line([sys,'/','Daxis'],[425,300;495,300])
add_line([sys,'/','Daxis'],[525,315;535,315])
add_line([sys,'/','Daxis'],[425,300;465,300;465,240;490,240])
add_line([sys,'/','Daxis'],[420,150;455,150;455,210;80,210;90,160])
add_line([sys,'/','Daxis'],[425,300;465,300;465,240;75,240;75,275;95,275])
add_line([sys,'/','Daxis'],[125,300;160,300])
add_line([sys,'/','Daxis'],[690,225;745,225;745,90;75,90;75,120;90,120])
add_line([sys,'/','Daxis'],[690,225;745,225;745,365;75,365;75,325;95,325])
add_line([sys,'/','Daxis'],[690,225;745,225;745,180;475,180;475,150;495,150])
add_line([sys,'/','Daxis'],[420,150;455,150;455,125;495,125])
add_line([sys,'/','Daxis'],[525,140;540,140])
add_line([sys,'/','Daxis'],[520,225;530,225])
add_line([sys,'/','Daxis'],[420,150;455,150;455,210;490,210])
add_line([sys,'/','Daxis'],[350,300;385,300])
add_line([sys,'/','Daxis'],[375,150;385,150])
add_line([sys,'/','Daxis'],[120,150;125,150])
add_line([sys,'/','Daxis'],[640,140;780,140])
add_line([sys,'/','Daxis'],[420,150;455,150;455,75;780,75])
add_line([sys,'/','Daxis'],[65,140;90,140])
add_line([sys,'/','Daxis'],[65,300;95,300])
add_line([sys,'/','Daxis'],[640,315;780,315])
add_line([sys,'/','Daxis'],[425,300;465,300;465,270;780,270])
add_line([sys,'/','Daxis'],[60,180;90,180])


%     Finished composite block 'Daxis'.

set_param([sys,'/','Daxis'],...
		'position',[220,260,255,315])

add_block('built-in/Note',[sys,'/','psiqse'])
set_param([sys,'/','psiqse'],...
		'position',[290,62,295,67])

add_block('built-in/Note',[sys,'/','iqse_'])
set_param([sys,'/','iqse_'],...
		'position',[285,82,290,87])

add_block('built-in/Note',[sys,'/','psidre'])
set_param([sys,'/','psidre'],...
		'position',[284,292,289,297])

add_block('built-in/Product',[sys,'/','Product'])
set_param([sys,'/','Product'],...
		'orientation',2,...
		'position',[220,154,240,176])

add_block('built-in/Product',[sys,'/','Product1'])
set_param([sys,'/','Product1'],...
		'orientation',2,...
		'position',[220,203,240,227])


%     Subsystem  'Rotor'.

new_system([sys,'/','Rotor'])
set_param([sys,'/','Rotor'],'Location',[219,388,854,634])

add_block('built-in/Note',[sys,'/','Rotor/Tdamp'])
set_param([sys,'/','Rotor/Tdamp'],...
		'position',[415,180,420,185])

add_block('built-in/Outport',[sys,'/','Rotor/out_wr//wb'])
set_param([sys,'/','Rotor/out_wr//wb'],...
		'Port','2',...
		'position',[550,123,570,147])

add_block('built-in/Integrator',[sys,'/','Rotor/1//s'])
set_param([sys,'/','Rotor/1//s'],...
		'Initial','wrbywbo',...
		'position',[480,118,515,152])

add_block('built-in/Gain',[sys,'/','Rotor/1//2H'])
set_param([sys,'/','Rotor/1//2H'],...
		'Gain','1/(2*H)',...
		'position',[395,109,460,161])

add_block('built-in/Sum',[sys,'/','Rotor/Taccl'])
set_param([sys,'/','Rotor/Taccl'],...
		'inputs','++-',...
		'position',[355,95,375,175])

add_block('built-in/Gain',[sys,'/',['Rotor/Damping',13,'coefficient']])
set_param([sys,'/',['Rotor/Damping',13,'coefficient']],...
		'orientation',2,...
		'Gain','Domega',...
		'position',[440,180,515,220])

add_block('built-in/Inport',[sys,'/','Rotor/in_iqse'])
set_param([sys,'/','Rotor/in_iqse'],...
		'Port','2',...
		'position',[60,80,80,100])

add_block('built-in/Inport',[sys,'/','Rotor/in_psidse'])
set_param([sys,'/','Rotor/in_psidse'],...
		'position',[60,40,80,60])

add_block('built-in/Inport',[sys,'/','Rotor/in_idse'])
set_param([sys,'/','Rotor/in_idse'],...
		'Port','4',...
		'position',[60,160,80,180])

add_block('built-in/Mux',[sys,'/','Rotor/Mux'])
set_param([sys,'/','Rotor/Mux'],...
		'position',[110,31,130,189])

add_block('built-in/Fcn',[sys,'/','Rotor/Tem'])
set_param([sys,'/','Rotor/Tem'],...
		'Expr','Tfactor*(u[1]*u[2] - u[3]*u[4])',...
		'position',[150,94,310,126])

add_block('built-in/Inport',[sys,'/','Rotor/in_Tmech'])
set_param([sys,'/','Rotor/in_Tmech'],...
		'Port','5',...
		'position',[60,200,80,220])

add_block('built-in/Outport',[sys,'/','Rotor/out_Tem'])
set_param([sys,'/','Rotor/out_Tem'],...
		'position',[540,50,560,70])

add_block('built-in/Inport',[sys,'/','Rotor/in_psiqse'])
set_param([sys,'/','Rotor/in_psiqse'],...
		'Port','3',...
		'position',[60,120,80,140])
add_line([sys,'/','Rotor'],[435,200;330,200;330,160;350,160])
add_line([sys,'/','Rotor'],[520,135;530,135;520,200])
add_line([sys,'/','Rotor'],[315,110;325,110;325,60;535,60])
add_line([sys,'/','Rotor'],[315,110;350,110])
add_line([sys,'/','Rotor'],[465,135;475,135])
add_line([sys,'/','Rotor'],[380,135;390,135])
add_line([sys,'/','Rotor'],[85,210;310,210;310,135;350,135])
add_line([sys,'/','Rotor'],[520,135;545,135])
add_line([sys,'/','Rotor'],[135,110;145,110])
add_line([sys,'/','Rotor'],[85,50;105,50])
add_line([sys,'/','Rotor'],[85,90;105,90])
add_line([sys,'/','Rotor'],[85,130;105,130])
add_line([sys,'/','Rotor'],[85,170;105,170])


%     Finished composite block 'Rotor'.

set_param([sys,'/','Rotor'],...
		'orientation',2,...
		'position',[450,144,490,216])

add_block('built-in/Outport',[sys,'/','out_3'])
set_param([sys,'/','out_3'],...
		'orientation',2,...
		'Port','3',...
		'position',[380,155,400,175])

add_block('built-in/Note',[sys,'/','Tem'])
set_param([sys,'/','Tem'],...
		'position',[424,149,429,154])

add_block('built-in/Sum',[sys,'/','Sum'])
set_param([sys,'/','Sum'],...
		'orientation',2,...
		'inputs','+-',...
		'position',[345,190,360,225])

add_block('built-in/Note',[sys,'/','wr//wb'])
set_param([sys,'/','wr//wb'],...
		'position',[420,182,425,187])

add_block('built-in/Constant',[sys,'/','we//wb'])
set_param([sys,'/','we//wb'],...
		'orientation',2,...
		'position',[390,205,410,225])

add_block('built-in/Outport',[sys,'/','out_1'])
set_param([sys,'/','out_1'],...
		'position',[610,90,630,110])

add_block('built-in/Outport',[sys,'/','out_2'])
set_param([sys,'/','out_2'],...
		'Port','2',...
		'position',[605,267,625,293])
add_line(sys,[260,265;260,242;175,242;175,130;210,130])
add_line(sys,[340,210;245,210])
add_line(sys,[340,210;285,210;285,170;245,170])
add_line(sys,[385,215;365,215])
add_line(sys,[445,200;365,200])
add_line(sys,[260,280;575,280;575,195;495,195])
add_line(sys,[215,215;190,215;190,110;210,110])
add_line(sys,[255,85;555,85;555,180;495,180])
add_line(sys,[255,100;575,100;575,165;495,165])
add_line(sys,[215,165;200,165;200,290;215,290])
add_line(sys,[260,265;530,265;530,150;495,150])
add_line(sys,[255,130;305,130;305,160;245,160])
add_line(sys,[120,90;210,90])
add_line(sys,[255,100;605,100])
add_line(sys,[445,165;405,165])
add_line(sys,[445,200;440,200;440,235])
add_line(sys,[120,325;510,325;510,210;495,210])
add_line(sys,[120,270;215,270])
add_line(sys,[260,280;600,280])
add_line(sys,[255,85;265,85;265,55;160,55;160,310;215,310])
add_line(sys,[260,310;315,310;315,220;245,220])

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
