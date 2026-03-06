function [ret,x0,str,ts,xts]=s2(t,x,u,flag);
%S2	is the M-file description of the SIMULINK system named S2.
%	The block-diagram can be displayed by typing: S2.
%
%	SYS=S2(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes S2 to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling S2 with a FLAG of zero:
%	[SIZES]=S2([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[63,71,682,398])
     open_system(sys)
end;
set_param(sys,'algorithm',     'Adams/Gear')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     'tstop')
set_param(sys,'Min step size', '0.0001')
set_param(sys,'Max step size', '0.0010')
set_param(sys,'Relative error','1e-5')
set_param(sys,'Return vars',   '')

add_block('built-in/Note',[sys,'/','vC'])
set_param([sys,'/','vC'],...
		'position',[465,130,470,135])

add_block('built-in/Note',[sys,'/','iL'])
set_param([sys,'/','iL'],...
		'position',[315,185,320,190])

add_block('built-in/Note',[sys,'/','iC'])
set_param([sys,'/','iC'],...
		'position',[315,125,320,130])

add_block('built-in/To Workspace',[sys,'/','To Workspace'])
set_param([sys,'/','To Workspace'],...
		'mat-name','y',...
		'buffer','3000',...
		'position',[400,15,425,35])

add_block('built-in/Scope',[sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'orientation',2,...
		'Vgain','20.000000',...
		'Hgain','0.500000',...
		'Vmax','40.000000',...
		'Hmax','1.000000',...
		'Window',[60,398,707,609])
open_system([sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'position',[115,14,130,36])

add_block('built-in/Integrator',[sys,'/','Integrator'])
set_param([sys,'/','Integrator'],...
		'orientation',2,...
		'Initial','iLo',...
		'position',[340,192,375,228])

add_block('built-in/Integrator',[sys,'/','Integrator1'])
set_param([sys,'/','Integrator1'],...
		'Initial','vCo',...
		'position',[415,133,450,167])

add_block('built-in/Gain',[sys,'/','1//C'])
set_param([sys,'/','1//C'],...
		'Gain','1/C',...
		'position',[355,133,395,167])

add_block('built-in/Sum',[sys,'/','Sum1'])
set_param([sys,'/','Sum1'],...
		'inputs','+-',...
		'position',[285,131,300,169])

add_block('built-in/Clock',[sys,'/','time'])
set_param([sys,'/','time'],...
		'position',[95,71,115,89])

add_block('built-in/Gain',[sys,'/','1//L'])
set_param([sys,'/','1//L'],...
		'orientation',2,...
		'Gain','1/L',...
		'position',[410,192,445,228])

add_block('built-in/Mux',[sys,'/','Mux'])
set_param([sys,'/','Mux'],...
		'orientation',3,...
		'position',[150,45,360,65])

add_block('built-in/Gain',[sys,'/','1//Rs'])
set_param([sys,'/','1//Rs'],...
		'Gain','1/Rs',...
		'position',[180,119,220,161])

add_block('built-in/Step Fcn',[sys,'/','vS'])
set_param([sys,'/','vS'],...
		'Time','tdelay',...
		'After','VS_mag',...
		'position',[80,134,115,166])

add_block('built-in/Note',[sys,'/','iS'])
set_param([sys,'/','iS'],...
		'position',[245,120,250,125])

add_block('built-in/Sum',[sys,'/','Sum'])
set_param([sys,'/','Sum'],...
		'inputs','-+',...
		'position',[145,121,160,159])

add_block('built-in/Note',[sys,'/',['Double click on masked block "m2init" to initialize before starting ',13,'simulation. After simulation, double click on masked block "m2plot" ',13,'to plot simulated results on MATLAB window']])
set_param([sys,'/',['Double click on masked block "m2init" to initialize before starting ',13,'simulation. After simulation, double click on masked block "m2plot" ',13,'to plot simulated results on MATLAB window']],...
		'position',[280,260,285,265])


%     Subsystem  'm2plot'.

new_system([sys,'/','m2plot'])
set_param([sys,'/','m2plot'],'Location',[365,5636560,530,5636648])

add_block('built-in/Note',[sys,'/',['m2plot/Display the plots programmed in ',13,'m2plot.m in a new figure window']])
set_param([sys,'/',['m2plot/Display the plots programmed in ',13,'m2plot.m in a new figure window']],...
		'position',[115,50,120,55])
set_param([sys,'/','m2plot'],...
		'Mask Display','Plot\nresults',...
		'Mask Type','Masked block of m2plot.m',...
		'Mask Dialogue','eval(''m2plot'')',...
		'Mask Help','Uses m2plot.m to plot')


%     Finished composite block 'm2plot'.

set_param([sys,'/','m2plot'],...
		'Drop Shadow',4,...
		'position',[77,190,124,234])


%     Subsystem  'm2init'.

new_system([sys,'/','m2init'])
set_param([sys,'/','m2init'],'Location',[120,5636530,321,5636630])

add_block('built-in/Note',[sys,'/',['m2init/Initialize above simulation ',13,'using the values given in ',13,'m2init.']])
set_param([sys,'/',['m2init/Initialize above simulation ',13,'using the values given in ',13,'m2init.']],...
		'position',[120,45,125,50])
set_param([sys,'/','m2init'],...
		'Mask Display','Initialize\ns2',...
		'Mask Type','Masked block of m2init.m',...
		'Mask Dialogue','eval(''m2init'')',...
		'Mask Help','Uses m2init.m to initialize')


%     Finished composite block 'm2init'.

set_param([sys,'/','m2init'],...
		'Drop Shadow',4,...
		'position',[156,192,230,235])

add_block('built-in/Scope',[sys,'/','Scope2'])
set_param([sys,'/','Scope2'],...
		'Vgain','1.000000',...
		'Hgain','1.000000',...
		'Vmax','2.000000',...
		'Hmax','2.000000',...
		'Window',[112,160,443,474],...
		'position',[480,22,495,48])
add_line(sys,[165,140;175,140])
add_line(sys,[305,150;350,150])
add_line(sys,[400,150;410,150])
add_line(sys,[455,150;480,150;480,100;125,100;125,130;140,130])
add_line(sys,[405,210;380,210])
add_line(sys,[255,40;255,25;395,25])
add_line(sys,[120,80;180,70])
add_line(sys,[335,210;260,210;260,160;280,160])
add_line(sys,[255,40;255,25;135,25])
add_line(sys,[225,140;280,140])
add_line(sys,[120,150;140,150])
add_line(sys,[225,140;230,140;230,70])
add_line(sys,[335,210;330,210;330,70])
add_line(sys,[455,150;480,150;480,100;280,100;280,70])
add_line(sys,[455,150;480,150;480,210;450,210])

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
