function [ret,x0,str,ts,xts]=s1b(t,x,u,flag);
%s1b	is the M-file description of the SIMULINK system named s1b.
%	The block-diagram can be displayed by typing: s1b.
%
%	SYS=s1b(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes s1b to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling s1b with a FLAG of zero:
%	[SIZES]=s1b([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[132,90,1021,664])
     open_system(sys)
end;
set_param(sys,'algorithm',     'RK-45')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     '999999')
set_param(sys,'Min step size', '0.0001')
set_param(sys,'Max step size', '10')
set_param(sys,'Relative error','1e-3')
set_param(sys,'Return vars',   '')

add_block('built-in/Inport',[sys,'/','In_v1'])
set_param([sys,'/','In_v1'],...
		'position',[100,220,120,240])

add_block('built-in/Clock',[sys,'/','Clock'])
set_param([sys,'/','Clock'],...
		'position',[100,125,120,145])

add_block('built-in/Mux',[sys,'/','Mux5'])
set_param([sys,'/','Mux5'],...
		'orientation',3,...
		'inputs','6',...
		'position',[150,100,760,120])

add_block('built-in/Outport',[sys,'/','Out_psi1'])
set_param([sys,'/','Out_psi1'],...
		'position',[795,150,815,170])

add_block('built-in/Scope',[sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'Vgain','3.000000',...
		'Hgain','0.050000',...
		'Vmax','6.000000',...
		'Hmax','2.000000',...
		'Window',[451,130,627,387],...
		'position',[565,62,585,88])

add_block('built-in/Fcn',[sys,'/','Fcn4'])
set_param([sys,'/','Fcn4'],...
		'Expr','(u[1]-u[2])/xl1',...
		'position',[550,206,640,234])

add_block('built-in/Mux',[sys,'/','Mux'])
set_param([sys,'/','Mux'],...
		'inputs','3',...
		'position',[175,188,195,272])

add_block('built-in/Inport',[sys,'/',['In_v2''']])
set_param([sys,'/',['In_v2''']],...
		'Port','2',...
		'position',[100,400,120,420])

add_block('built-in/Mux',[sys,'/','Mux2'])
set_param([sys,'/','Mux2'],...
		'inputs','2',...
		'position',[495,396,515,449])

add_block('built-in/Outport',[sys,'/',['Out_i2''']])
set_param([sys,'/',['Out_i2''']],...
		'Port','4',...
		'position',[700,415,720,435])

add_block('built-in/Mux',[sys,'/','Mux4'])
set_param([sys,'/','Mux4'],...
		'inputs','2',...
		'position',[505,194,525,241])

add_block('built-in/Fcn',[sys,'/','Fcn5'])
set_param([sys,'/','Fcn5'],...
		'Expr','(u[1]-u[2])/xpl2',...
		'position',[545,409,640,441])

add_block('built-in/Outport',[sys,'/','Out_i1'])
set_param([sys,'/','Out_i1'],...
		'Port','3',...
		'position',[720,210,740,230])

add_block('built-in/Note',[sys,'/','i1'])
set_param([sys,'/','i1'],...
		'position',[655,200,660,205])

add_block('built-in/Fcn',[sys,'/','Fcn'])
set_param([sys,'/','Fcn'],...
		'Expr','wb*(u[2]-(r1/xl1)*(u[3]-u[1]))',...
		'position',[210,215,375,245])

add_block('built-in/Integrator',[sys,'/','psi1_'])
set_param([sys,'/','psi1_'],...
		'Initial','Psi1o',...
		'position',[390,217,420,243])

add_block('built-in/Note',[sys,'/','psi1'])
set_param([sys,'/','psi1'],...
		'position',[435,205,440,210])

add_block('built-in/Gain',[sys,'/','Slope'])
set_param([sys,'/','Slope'],...
		'orientation',2,...
		'Gain','150*3.9502e-5',...
		'position',[575,345,615,375])

add_block('built-in/Dead Zone',[sys,'/','Dead Zone'])
set_param([sys,'/','Dead Zone'],...
		'orientation',2,...
		'Lower_value','-154',...
		'Upper_value','154',...
		'position',[640,345,690,375])

add_block('built-in/Outport',[sys,'/','Out_psim'])
set_param([sys,'/','Out_psim'],...
		'Port','2',...
		'position',[805,295,825,315])

add_block('built-in/Mux',[sys,'/','Mux3'])
set_param([sys,'/','Mux3'],...
		'inputs','3',...
		'position',[485,273,500,337])

add_block('built-in/Memory',[sys,'/','Memory'])
set_param([sys,'/','Memory'],...
		'orientation',2,...
		'position',[530,348,555,372])

add_block('built-in/Note',[sys,'/','Dpsi'])
set_param([sys,'/','Dpsi'],...
		'orientation',2,...
		'position',[495,357,500,362])

add_block('built-in/Mux',[sys,'/','Mux1'])
set_param([sys,'/','Mux1'],...
		'inputs','3',...
		'position',[170,372,190,448])

add_block('built-in/Note',[sys,'/',['psi2''']])
set_param([sys,'/',['psi2''']],...
		'position',[440,376,445,381])

add_block('built-in/Fcn',[sys,'/','Fcn2'])
set_param([sys,'/','Fcn2'],...
		'Expr','wb*(u[2] -(rp2/xpl2)*(u[1]-u[3]))',...
		'position',[210,394,395,426])

add_block('built-in/Integrator',[sys,'/',['psi2''_']])
set_param([sys,'/',['psi2''_']],...
		'Initial','Psip2o',...
		'position',[410,397,440,423])

add_block('built-in/Note',[sys,'/',['i2''']])
set_param([sys,'/',['i2''']],...
		'position',[655,407,660,412])

add_block('built-in/Note',[sys,'/','psim'])
set_param([sys,'/','psim'],...
		'position',[725,280,730,285])

add_block('built-in/Fcn',[sys,'/','Fcn3'])
set_param([sys,'/','Fcn3'],...
		'Expr','xM*(u[1]/xl1+u[2]/xpl2-u[3]/xm)',...
		'position',[520,289,705,321])

add_block('built-in/To Workspace',[sys,'/','To Workspace'])
set_param([sys,'/','To Workspace'],...
		'orientation',2,...
		'mat-name','y',...
		'buffer','80000',...
		'position',[315,67,365,83])
add_line(sys,[125,230;170,230])
add_line(sys,[200,230;205,230])
add_line(sys,[380,230;385,230])
add_line(sys,[400,410;405,410])
add_line(sys,[425,230;460,230;460,285;480,285])
add_line(sys,[505,305;515,305])
add_line(sys,[530,220;545,220])
add_line(sys,[425,230;460,230;460,205;500,205])
add_line(sys,[710,305;750,305;750,260;480,260;480,230;500,230])
add_line(sys,[710,305;750,305;750,470;150,470;150,435;165,435])
add_line(sys,[710,305;750,305;750,170;155,170;155,200;170,200])
add_line(sys,[710,305;800,305])
add_line(sys,[645,220;715,220])
add_line(sys,[425,230;460,230;460,160;790,160])
add_line(sys,[195,410;205,410])
add_line(sys,[125,410;165,410])
add_line(sys,[445,410;460,410;460,360;155,360;165,385])
add_line(sys,[425,230;460,230;460,285;155,285;155,260;170,260])
add_line(sys,[445,410;460,410;460,305;480,305])
add_line(sys,[520,425;540,425])
add_line(sys,[645,425;695,425])
add_line(sys,[445,410;490,410])
add_line(sys,[710,305;750,305;750,470;465,470;465,435;490,435])
add_line(sys,[125,410;145,410;145,160;405,160;405,125])
add_line(sys,[125,230;135,230;135,150;305,150;305,125])
add_line(sys,[125,135;205,125])
add_line(sys,[710,305;750,305;750,150;505,150;505,125])
add_line(sys,[645,220;685,220;685,140;605,140;605,125])
add_line(sys,[645,425;670,425;670,400;765,400;765,140;705,140;705,125])
add_line(sys,[455,95;455,75;560,75])
add_line(sys,[455,95;455,75;370,75])
add_line(sys,[635,360;620,360])
add_line(sys,[570,360;560,360])
add_line(sys,[710,305;715,305;715,360;695,360])
add_line(sys,[525,360;465,360;465,325;480,325])

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
