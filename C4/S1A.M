function [ret,x0,str,ts,xts]=s1a(t,x,u,flag);
%s1a	is the M-file description of the SIMULINK system named s1a.
%	The block-diagram can be displayed by typing: s1a.
%
%	SYS=s1a(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes s1a to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling s1a with a FLAG of zero:
%	[SIZES]=s1a([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[100,100,1025,570])
     open_system(sys)
end;
set_param(sys,'algorithm',     'Adams/Gear')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     'tstop')
set_param(sys,'Min step size', '1e-4')
set_param(sys,'Max step size', '1e-3')
set_param(sys,'Relative error','1e-8')
set_param(sys,'Return vars',   '')

add_block('built-in/Note',[sys,'/',['i2''']])
set_param([sys,'/',['i2''']],...
		'position',[650,297,655,302])

add_block('built-in/Inport',[sys,'/','In_v1'])
set_param([sys,'/','In_v1'],...
		'position',[90,115,110,135])

add_block('built-in/Inport',[sys,'/',['In_v2''']])
set_param([sys,'/',['In_v2''']],...
		'Port','2',...
		'position',[90,295,110,315])

add_block('built-in/Fcn',[sys,'/','Fcn'])
set_param([sys,'/','Fcn'],...
		'Expr','wb*(u[2]-(r1/xl1)*(u[3]-u[1]))',...
		'position',[195,109,370,141])

add_block('built-in/Integrator',[sys,'/','psi1_'])
set_param([sys,'/','psi1_'],...
		'Initial','Psi1o',...
		'position',[395,111,425,139])

add_block('built-in/Note',[sys,'/','psi1'])
set_param([sys,'/','psi1'],...
		'position',[445,105,450,110])

add_block('built-in/Fcn',[sys,'/','Fcn2'])
set_param([sys,'/','Fcn2'],...
		'Expr','wb*(u[2] -(rp2/xpl2)*(u[1]-u[3]))',...
		'position',[180,289,370,321])

add_block('built-in/Integrator',[sys,'/',['psi2''_']])
set_param([sys,'/',['psi2''_']],...
		'Initial','Psip2o',...
		'position',[395,290,425,320])

add_block('built-in/Note',[sys,'/',['psi2''']])
set_param([sys,'/',['psi2''']],...
		'position',[440,281,445,286])

add_block('built-in/Mux',[sys,'/','Mux'])
set_param([sys,'/','Mux'],...
		'inputs','3',...
		'position',[145,83,165,167])

add_block('built-in/Mux',[sys,'/','Mux1'])
set_param([sys,'/','Mux1'],...
		'inputs','3',...
		'position',[140,267,160,343])

add_block('built-in/Note',[sys,'/','i1'])
set_param([sys,'/','i1'],...
		'position',[650,95,655,100])

add_block('built-in/Outport',[sys,'/','Out_i1'])
set_param([sys,'/','Out_i1'],...
		'Port','3',...
		'position',[715,105,735,125])

add_block('built-in/Fcn',[sys,'/','Fcn5'])
set_param([sys,'/','Fcn5'],...
		'Expr','(u[1]-u[2])/xpl2',...
		'position',[535,305,630,335])

add_block('built-in/Mux',[sys,'/','Mux4'])
set_param([sys,'/','Mux4'],...
		'inputs','2',...
		'position',[500,89,520,136])

add_block('built-in/Fcn',[sys,'/','Fcn3'])
set_param([sys,'/','Fcn3'],...
		'Expr','xM*(u[1]/xl1+u[2]/xpl2)',...
		'position',[540,203,680,237])

add_block('built-in/Mux',[sys,'/','Mux3'])
set_param([sys,'/','Mux3'],...
		'inputs','2',...
		'position',[490,188,510,252])

add_block('built-in/Outport',[sys,'/',['Out_i2''']])
set_param([sys,'/',['Out_i2''']],...
		'Port','4',...
		'position',[695,310,715,330])

add_block('built-in/Mux',[sys,'/','Mux2'])
set_param([sys,'/','Mux2'],...
		'inputs','2',...
		'position',[490,291,510,344])

add_block('built-in/Fcn',[sys,'/','Fcn4'])
set_param([sys,'/','Fcn4'],...
		'Expr','(u[1]-u[2])/xl1',...
		'position',[545,101,635,129])

add_block('built-in/Outport',[sys,'/','Out_psi1'])
set_param([sys,'/','Out_psi1'],...
		'position',[790,45,810,65])

add_block('built-in/Outport',[sys,'/','Out_psim'])
set_param([sys,'/','Out_psim'],...
		'Port','2',...
		'position',[790,210,810,230])

add_block('built-in/Note',[sys,'/','psim'])
set_param([sys,'/','psim'],...
		'position',[705,200,710,205])
add_line(sys,[115,125;140,125])
add_line(sys,[170,125;190,125])
add_line(sys,[375,125;390,125])
add_line(sys,[375,305;390,305])
add_line(sys,[430,125;460,125;460,205;485,205])
add_line(sys,[515,220;535,220])
add_line(sys,[525,115;540,115])
add_line(sys,[430,125;460,125;460,100;495,100])
add_line(sys,[685,220;745,220;745,155;475,155;475,125;495,125])
add_line(sys,[685,220;745,220;745,365;125,365;135,330])
add_line(sys,[685,220;745,220;745,65;125,65;125,95;140,95])
add_line(sys,[685,220;785,220])
add_line(sys,[640,115;710,115])
add_line(sys,[430,125;460,125;460,55;785,55])
add_line(sys,[165,305;175,305])
add_line(sys,[115,305;135,305])
add_line(sys,[430,305;460,305;460,255;125,255;135,280])
add_line(sys,[430,125;460,125;460,180;125,180;125,155;140,155])
add_line(sys,[430,305;460,305;460,235;485,235])
add_line(sys,[515,320;530,320])
add_line(sys,[635,320;690,320])
add_line(sys,[430,305;485,305])
add_line(sys,[685,220;745,220;745,365;460,365;460,330;485,330])

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
