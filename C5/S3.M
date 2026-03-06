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
     set_param(sys,'Location',[0,40,771,383])
     open_system(sys)
end;
set_param(sys,'algorithm',     'RK-45')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     '3')
set_param(sys,'Min step size', '1e-3')
set_param(sys,'Max step size', '1e-2')
set_param(sys,'Relative error','1e-6')
set_param(sys,'Return vars',   '')

add_block('built-in/Fcn',[sys,'/','Fcn2'])
set_param([sys,'/','Fcn2'],...
		'Expr','10*exp(-alpha*u[1])*cos(m*(u[2]+2*pi/3))',...
		'position',[130,223,370,247])

add_block('built-in/Fcn',[sys,'/','Fcn1'])
set_param([sys,'/','Fcn1'],...
		'Expr','10*exp(-alpha*u[1])*cos(m*(u[2]-2*pi/3))',...
		'position',[130,187,365,213])

add_block('built-in/Fcn',[sys,'/','Fcn'])
set_param([sys,'/','Fcn'],...
		'Expr','10*exp(-alpha*u[1])*cos(m*u[2])',...
		'position',[130,153,365,177])

add_block('built-in/Note',[sys,'/','i0s'])
set_param([sys,'/','i0s'],...
		'position',[500,213,505,218])

add_block('built-in/Note',[sys,'/','ids'])
set_param([sys,'/','ids'],...
		'position',[500,175,505,180])

add_block('built-in/Note',[sys,'/','iqs'])
set_param([sys,'/','iqs'],...
		'position',[500,145,505,150])


%     Subsystem  'abc2qd0s'.

new_system([sys,'/','abc2qd0s'])
set_param([sys,'/','abc2qd0s'],'Location',[483,441,1051,758])

add_block('built-in/Mux',[sys,'/','abc2qd0s/Mux'])
set_param([sys,'/','abc2qd0s/Mux'],...
		'hide name',0,...
		'inputs','3',...
		'position',[100,90,130,230])

add_block('built-in/Inport',[sys,'/','abc2qd0s/in_a'])
set_param([sys,'/','abc2qd0s/in_a'],...
		'position',[40,105,60,125])

add_block('built-in/Inport',[sys,'/','abc2qd0s/in_c'])
set_param([sys,'/','abc2qd0s/in_c'],...
		'Port','3',...
		'position',[40,195,60,215])

add_block('built-in/Inport',[sys,'/','abc2qd0s/in_b'])
set_param([sys,'/','abc2qd0s/in_b'],...
		'Port','2',...
		'position',[40,150,60,170])

add_block('built-in/Fcn',[sys,'/','abc2qd0s/abc2qd_row3'])
set_param([sys,'/','abc2qd0s/abc2qd_row3'],...
		'Expr','(u[1] + u[2] + u[3])/3',...
		'position',[175,195,400,225])

add_block('built-in/Outport',[sys,'/','abc2qd0s/out_ds'])
set_param([sys,'/','abc2qd0s/out_ds'],...
		'Port','2',...
		'position',[495,150,515,170])

add_block('built-in/Fcn',[sys,'/','abc2qd0s/abc2qds_row2'])
set_param([sys,'/','abc2qd0s/abc2qds_row2'],...
		'Expr','(-u[2] + u[3])/sqrt(3)',...
		'position',[175,146,400,174])

add_block('built-in/Outport',[sys,'/','abc2qd0s/out_0s'])
set_param([sys,'/','abc2qd0s/out_0s'],...
		'Port','3',...
		'position',[495,200,515,220])

add_block('built-in/Outport',[sys,'/','abc2qd0s/out_qs'])
set_param([sys,'/','abc2qd0s/out_qs'],...
		'position',[495,100,515,120])

add_block('built-in/Fcn',[sys,'/','abc2qd0s/abc2qds_row1'])
set_param([sys,'/','abc2qd0s/abc2qds_row1'],...
		'Expr','(2*u[1] - u[2]- u[3])/3',...
		'position',[175,96,400,124])
add_line([sys,'/','abc2qd0s'],[135,160;144,160;144,110;170,110])
add_line([sys,'/','abc2qd0s'],[65,115;95,115])
add_line([sys,'/','abc2qd0s'],[65,160;95,160])
add_line([sys,'/','abc2qd0s'],[65,205;95,205])
add_line([sys,'/','abc2qd0s'],[405,110;490,110])
add_line([sys,'/','abc2qd0s'],[405,160;490,160])
add_line([sys,'/','abc2qd0s'],[405,210;490,210])
add_line([sys,'/','abc2qd0s'],[135,160;170,160])
add_line([sys,'/','abc2qd0s'],[135,160;145,160;145,210;170,210])


%     Finished composite block 'abc2qd0s'.

set_param([sys,'/','abc2qd0s'],...
		'position',[415,147,470,253])

add_block('built-in/Gain',[sys,'/','nframe'])
set_param([sys,'/','nframe'],...
		'Gain','nframe',...
		'position',[325,258,400,292])

add_block('built-in/Scope',[sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'orientation',2,...
		'Vgain','25.000000',...
		'Hgain','2.000000',...
		'Vmax','50.000000',...
		'Hmax','4.000000',...
		'Window',[-3,323,781,492])
open_system([sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'position',[450,25,470,45])


%     Subsystem  'qds2qd'.

new_system([sys,'/','qds2qd'])
set_param([sys,'/','qds2qd'],'Location',[189,191,737,401])

add_block('built-in/Inport',[sys,'/','qds2qd/theta '])
set_param([sys,'/','qds2qd/theta '],...
		'Port','3',...
		'position',[20,139,40,161])

add_block('built-in/Mux',[sys,'/','qds2qd/Mux'])
set_param([sys,'/','qds2qd/Mux'],...
		'hide name',0,...
		'inputs','3',...
		'position',[65,47,95,173])

add_block('built-in/Inport',[sys,'/','qds2qd/in_qs'])
set_param([sys,'/','qds2qd/in_qs'],...
		'position',[20,60,40,80])

add_block('built-in/Inport',[sys,'/','qds2qd/in_ds'])
set_param([sys,'/','qds2qd/in_ds'],...
		'Port','2',...
		'position',[20,100,40,120])

add_block('built-in/Fcn',[sys,'/','qds2qd/qds2qd_row1'])
set_param([sys,'/','qds2qd/qds2qd_row1'],...
		'Expr','u[1]*cos(u[3]) - u[2]*sin(u[3])',...
		'position',[155,64,390,96])

add_block('built-in/Outport',[sys,'/','qds2qd/out_q'])
set_param([sys,'/','qds2qd/out_q'],...
		'position',[455,70,475,90])

add_block('built-in/Fcn',[sys,'/','qds2qd/qds2qd_row2'])
set_param([sys,'/','qds2qd/qds2qd_row2'],...
		'Expr','u[1]*sin(u[3]) + u[2]*cos(u[3])',...
		'position',[155,118,385,152])

add_block('built-in/Outport',[sys,'/','qds2qd/out_d'])
set_param([sys,'/','qds2qd/out_d'],...
		'Port','2',...
		'position',[455,125,475,145])
add_line([sys,'/','qds2qd'],[390,135;450,135])
add_line([sys,'/','qds2qd'],[395,80;450,80])
add_line([sys,'/','qds2qd'],[100,110;120,110;120,135;150,135])
add_line([sys,'/','qds2qd'],[45,70;60,70])
add_line([sys,'/','qds2qd'],[45,110;60,110])
add_line([sys,'/','qds2qd'],[45,150;60,150])
add_line([sys,'/','qds2qd'],[100,110;120,110;120,80;150,80])


%     Finished composite block 'qds2qd'.

set_param([sys,'/','qds2qd'],...
		'position',[585,150,635,250])

add_block('built-in/Note',[sys,'/','ib'])
set_param([sys,'/','ib'],...
		'position',[390,170,395,175])

add_block('built-in/Note',[sys,'/','ia'])
set_param([sys,'/','ia'],...
		'position',[390,135,395,140])

add_block('built-in/Note',[sys,'/','ic'])
set_param([sys,'/','ic'],...
		'position',[390,215,395,220])

add_block('built-in/Mux',[sys,'/','Mux'])
set_param([sys,'/','Mux'],...
		'orientation',3,...
		'inputs','7',...
		'position',[381,60,659,80])

add_block('built-in/To Workspace',[sys,'/','To Workspace'])
set_param([sys,'/','To Workspace'],...
		'mat-name','y',...
		'buffer','10000',...
		'position',[565,26,600,44])

add_block('built-in/Constant',[sys,'/','theta(0)'])
set_param([sys,'/','theta(0)'],...
		'Value','theta0',...
		'position',[415,290,470,310])

add_block('built-in/Sum',[sys,'/','Sum'])
set_param([sys,'/','Sum'],...
		'position',[495,263,515,312])

add_block('built-in/Note',[sys,'/','theta'])
set_param([sys,'/','theta'],...
		'position',[535,270,540,275])

add_block('built-in/Note',[sys,'/','id'])
set_param([sys,'/','id'],...
		'position',[645,200,650,205])

add_block('built-in/Note',[sys,'/','iq'])
set_param([sys,'/','iq'],...
		'position',[645,150,650,155])

add_block('built-in/Gain',[sys,'/','Gain'])
set_param([sys,'/','Gain'],...
		'orientation',2,...
		'Gain','2*pi',...
		'position',[140,91,180,119])

add_block('built-in/Mux',[sys,'/','Mux1'])
set_param([sys,'/','Mux1'],...
		'orientation',1,...
		'inputs','2',...
		'position',[76,130,109,150])

add_block('built-in/Clock',[sys,'/','Clock'])
set_param([sys,'/','Clock'],...
		'orientation',1,...
		'position',[200,45,220,65])


%     Subsystem  'm3'.

new_system([sys,'/','m3'])
set_param([sys,'/','m3'],'Location',[10,55,1133,881])

add_block('built-in/Note',[sys,'/','m3/Masked block of m3.m'])
set_param([sys,'/','m3/Masked block of m3.m'],...
		'position',[80,35,85,40])
set_param([sys,'/','m3'],...
		'Mask Display','Initialize\nand plot',...
		'Mask Type','Masked block of m3.m',...
		'Mask Dialogue','eval(''m3'')',...
		'Mask Help','Uses m3.m to initialize and plot')


%     Finished composite block 'm3'.

set_param([sys,'/','m3'],...
		'Drop Shadow',4,...
		'position',[285,38,344,74])
add_line(sys,[520,55;520,35;560,35])
add_line(sys,[370,165;410,165])
add_line(sys,[370,200;410,200])
add_line(sys,[375,235;410,235])
add_line(sys,[210,70;210,105;400,105;400,85])
add_line(sys,[370,165;375,165;375,120;440,120;440,85])
add_line(sys,[475,165;480,165;480,85])
add_line(sys,[475,200;520,200;520,85])
add_line(sys,[475,200;580,200])
add_line(sys,[475,235;560,235;560,85])
add_line(sys,[640,175;665,175;665,125;600,125;600,85])
add_line(sys,[640,225;680,225;680,105;640,105;640,85])
add_line(sys,[405,275;490,275])
add_line(sys,[520,290;570,290;580,235])
add_line(sys,[475,300;490,300])
add_line(sys,[520,55;520,35;475,35])
add_line(sys,[475,165;580,165])
add_line(sys,[210,70;210,105;185,105])
add_line(sys,[135,105;100,105;100,125])
add_line(sys,[210,70;85,70;85,125])
add_line(sys,[95,155;95,165;125,165])
add_line(sys,[95,155;95,200;125,200])
add_line(sys,[95,155;95,235;125,235])
add_line(sys,[135,105;115,105;115,275;320,275])

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
