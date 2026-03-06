function [ret,x0,str,ts,xts]=s1(t,x,u,flag);
%s1	is the M-file description of the SIMULINK system named s1.
%	The block-diagram can be displayed by typing: s1.
%
%	SYS=s1(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes s1 to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling s1 with a FLAG of zero:
%	[SIZES]=s1([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[53,59,721,353])
     open_system(sys)
end;
set_param(sys,'algorithm',     'RK-45')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     '0.05')
set_param(sys,'Min step size', '0.0001')
set_param(sys,'Max step size', '0.01')
set_param(sys,'Relative error','1e-5')
set_param(sys,'Return vars',   '')


%     Subsystem  'm1'.

new_system([sys,'/','m1'])
set_param([sys,'/','m1'],'Location',[10,55,1133,881])

add_block('built-in/Note',[sys,'/',['m1/Uses m1.m to plot the simulated result',13,'stored in yout of  the Matlab workspace',13,'']])
set_param([sys,'/',['m1/Uses m1.m to plot the simulated result',13,'stored in yout of  the Matlab workspace',13,'']],...
		'position',[155,70,160,75])
set_param([sys,'/','m1'],...
		'Mask Display','Plot yout ',...
		'Mask Type','Masked block of m1.m',...
		'Mask Dialogue','eval(''m1'')',...
		'Mask Help','Uses m1.m')


%     Finished composite block 'm1'.

set_param([sys,'/','m1'],...
		'Drop Shadow',4,...
		'position',[100,165,172,197])

add_block('built-in/Note',[sys,'/',['In this simulation, the  system parameters and initial conditions have been ',13,'entered as constants.  After running the simulation, double click on masked ',13,'block "m1" to plot simulated  results on MATLAB figure window.']])
set_param([sys,'/',['In this simulation, the  system parameters and initial conditions have been ',13,'entered as constants.  After running the simulation, double click on masked ',13,'block "m1" to plot simulated  results on MATLAB figure window.']],...
		'position',[365,225,370,230])

add_block('built-in/Note',[sys,'/','y2'])
set_param([sys,'/','y2'],...
		'position',[380,127,385,132])

add_block('built-in/Integrator',[sys,'/','Integrator'])
set_param([sys,'/','Integrator'],...
		'position',[315,139,345,171])

add_block('built-in/Gain',[sys,'/','Gain'])
set_param([sys,'/','Gain'],...
		'Gain','-1',...
		'position',[260,137,290,173])


%     Subsystem  ['Inner',13,'Product'].

new_system([sys,'/',['Inner',13,'Product']])
set_param([sys,'/',['Inner',13,'Product']],'Location',[33,479,253,634])

add_block('built-in/Product',[sys,'/',['Inner',13,'Product/Product']])
set_param([sys,'/',['Inner',13,'Product/Product']],...
		'position',[65,55,90,75])

add_block('built-in/Sum',[sys,'/',['Inner',13,'Product/Sum']])
set_param([sys,'/',['Inner',13,'Product/Sum']],...
		'inputs','+',...
		'position',[125,55,145,75])

add_block('built-in/Outport',[sys,'/',['Inner',13,'Product/out_1']])
set_param([sys,'/',['Inner',13,'Product/out_1']],...
		'position',[185,55,205,75])

add_block('built-in/Inport',[sys,'/',['Inner',13,'Product/in_2']])
set_param([sys,'/',['Inner',13,'Product/in_2']],...
		'Port','2',...
		'position',[15,90,35,110])

add_block('built-in/Inport',[sys,'/',['Inner',13,'Product/in_1']])
set_param([sys,'/',['Inner',13,'Product/in_1']],...
		'position',[15,25,35,45])
add_line([sys,'/',['Inner',13,'Product']],[40,100;60,70])
add_line([sys,'/',['Inner',13,'Product']],[40,35;60,60])
add_line([sys,'/',['Inner',13,'Product']],[95,65;120,65])
add_line([sys,'/',['Inner',13,'Product']],[150,65;180,65])
set_param([sys,'/',['Inner',13,'Product']],...
		'Mask Display','.\n',...
		'Mask Type','Dot Product',...
		'Mask Dialogue','Inner (dot) product.\ny=sum(u1.*u2)')
set_param([sys,'/',['Inner',13,'Product']],...
		'Mask Help','Computes the inner (dot) product of the inputs: sum(u1.*u2).  The inputs are vectors of the same length. Output is a scalar.')


%     Finished composite block ['Inner',13,'Product'].

set_param([sys,'/',['Inner',13,'Product']],...
		'position',[220,137,240,168])

add_block('built-in/To Workspace',[sys,'/','To Workspace'])
set_param([sys,'/','To Workspace'],...
		'mat-name','yout',...
		'buffer','3000',...
		'position',[495,67,535,93])

add_block('built-in/Scope',[sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'Vgain','10.000000',...
		'Hgain','0.050000',...
		'Vmax','20.000000',...
		'Hmax','0.100000',...
		'Window',[50,339,722,453])
open_system([sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'position',[510,137,530,163])

add_block('built-in/Clock',[sys,'/','Clock'])
set_param([sys,'/','Clock'],...
		'position',[385,66,405,84])

add_block('built-in/Mux',[sys,'/','Mux'])
set_param([sys,'/','Mux'],...
		'inputs','3',...
		'position',[425,58,450,172])

add_block('built-in/Note',[sys,'/','y1'])
set_param([sys,'/','y1'],...
		'position',[350,25,355,30])


%     Subsystem  ['Inner',13,'Product1'].

new_system([sys,'/',['Inner',13,'Product1']])
set_param([sys,'/',['Inner',13,'Product1']],'Location',[33,479,253,634])

add_block('built-in/Product',[sys,'/',['Inner',13,'Product1/Product']])
set_param([sys,'/',['Inner',13,'Product1/Product']],...
		'position',[65,55,90,75])

add_block('built-in/Sum',[sys,'/',['Inner',13,'Product1/Sum']])
set_param([sys,'/',['Inner',13,'Product1/Sum']],...
		'inputs','+',...
		'position',[125,55,145,75])

add_block('built-in/Outport',[sys,'/',['Inner',13,'Product1/out_1']])
set_param([sys,'/',['Inner',13,'Product1/out_1']],...
		'position',[185,55,205,75])

add_block('built-in/Inport',[sys,'/',['Inner',13,'Product1/in_2']])
set_param([sys,'/',['Inner',13,'Product1/in_2']],...
		'Port','2',...
		'position',[15,90,35,110])

add_block('built-in/Inport',[sys,'/',['Inner',13,'Product1/in_1']])
set_param([sys,'/',['Inner',13,'Product1/in_1']],...
		'position',[15,25,35,45])
add_line([sys,'/',['Inner',13,'Product1']],[40,100;60,70])
add_line([sys,'/',['Inner',13,'Product1']],[40,35;60,60])
add_line([sys,'/',['Inner',13,'Product1']],[95,65;120,65])
add_line([sys,'/',['Inner',13,'Product1']],[150,65;180,65])
set_param([sys,'/',['Inner',13,'Product1']],...
		'Mask Display','.\n',...
		'Mask Type','Dot Product',...
		'Mask Dialogue','Inner (dot) product.\ny=sum(u1.*u2)')
set_param([sys,'/',['Inner',13,'Product1']],...
		'Mask Help','Computes the inner (dot) product of the inputs: sum(u1.*u2).  The inputs are vectors of the same length. Output is a scalar.')


%     Finished composite block ['Inner',13,'Product1'].

set_param([sys,'/',['Inner',13,'Product1']],...
		'position',[245,31,265,64])

add_block('built-in/Integrator',[sys,'/','Integrator1'])
set_param([sys,'/','Integrator1'],...
		'Initial','5',...
		'position',[300,34,330,66])

add_block('built-in/Constant',[sys,'/','w'])
set_param([sys,'/','w'],...
		'Value','377',...
		'position',[140,75,175,105])
add_line(sys,[180,90;190,90;190,145;215,145])
add_line(sys,[180,90;190,90;190,40;240,40])
add_line(sys,[270,50;295,50])
add_line(sys,[335,50;565,50;565,210;190,210;190,160;215,160])
add_line(sys,[455,115;465,115;465,80;490,80])
add_line(sys,[455,115;465,115;465,150;505,150])
add_line(sys,[245,155;255,155])
add_line(sys,[295,155;310,155])
add_line(sys,[350,155;360,155;360,110;225,110;225,55;240,55])
add_line(sys,[410,75;420,75])
add_line(sys,[335,50;375,50;375,115;420,115])
add_line(sys,[350,155;420,155])

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
