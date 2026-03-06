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
     set_param(sys,'Location',[55,65,612,321])
     open_system(sys)
end;
set_param(sys,'algorithm',     'Linear')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     'tstop')
set_param(sys,'Min step size', '0.001')
set_param(sys,'Max step size', '0.01')
set_param(sys,'Relative error','1e-5')
set_param(sys,'Return vars',   '')


%     Subsystem  'm3'.

new_system([sys,'/','m3'])
set_param([sys,'/','m3'],'Location',[285,6357255,540,6357378])

add_block('built-in/Note',[sys,'/',['m3/Masked block of m3.m to initialize',13,'and plot results']])
set_param([sys,'/',['m3/Masked block of m3.m to initialize',13,'and plot results']],...
		'position',[154,45,159,50])
set_param([sys,'/','m3'],...
		'Mask Display','Initialize\ns3',...
		'Mask Type','Masked block of m3.m',...
		'Mask Dialogue','eval(''m3'')',...
		'Mask Help','Uses m3.m to initialize')


%     Finished composite block 'm3'.

set_param([sys,'/','m3'],...
		'Drop Shadow',4,...
		'position',[367,18,435,56])

add_block('built-in/Scope',[sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'orientation',2,...
		'Vgain','120.000000',...
		'Hgain','0.500000',...
		'Vmax','240.000000',...
		'Hmax','1.000000',...
		'Window',[54,317,625,543])
open_system([sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'position',[140,14,160,36])

add_block('built-in/To Workspace',[sys,'/','To Workspace'])
set_param([sys,'/','To Workspace'],...
		'mat-name','y',...
		'buffer','3000',...
		'position',[250,16,295,34])

add_block('built-in/Note',[sys,'/',['Double click on the masked block m3 in this screen or run m3.m ',13,'in MATLAB command window to initialize this simulation. ',13,'After simulation,  type return in MATLAB window to plot results.',13,'']])
set_param([sys,'/',['Double click on the masked block m3 in this screen or run m3.m ',13,'in MATLAB command window to initialize this simulation. ',13,'After simulation,  type return in MATLAB window to plot results.',13,'']],...
		'position',[265,195,270,200])

add_block('built-in/Clock',[sys,'/','Clock'])
set_param([sys,'/','Clock'],...
		'position',[130,95,150,115])

add_block('built-in/Mux',[sys,'/','Mux'])
set_param([sys,'/','Mux'],...
		'orientation',3,...
		'inputs','3',...
		'position',[128,60,302,75])

add_block('built-in/Sine Wave',[sys,'/','Vac'])
set_param([sys,'/','Vac'],...
		'amplitude','Vac_mag',...
		'frequency','we',...
		'position',[135,144,165,176])

add_block('built-in/Gain',[sys,'/','R'])
set_param([sys,'/','R'],...
		'orientation',2,...
		'Gain','R',...
		'position',[290,98,325,132])

add_block('built-in/Integrator',[sys,'/','Integrator'])
set_param([sys,'/','Integrator'],...
		'Initial','iLo',...
		'position',[350,139,380,171])

add_block('built-in/Sum',[sys,'/','Sum'])
set_param([sys,'/','Sum'],...
		'inputs','-+',...
		'position',[230,135,245,170])

add_block('built-in/Note',[sys,'/','i'])
set_param([sys,'/','i'],...
		'position',[395,135,400,140])

add_block('built-in/Gain',[sys,'/','1//L'])
set_param([sys,'/','1//L'],...
		'Gain','1/L',...
		'position',[265,135,305,175])
add_line(sys,[310,155;345,155])
add_line(sys,[215,55;215,25;245,25])
add_line(sys,[155,105;155,80])
add_line(sys,[215,55;215,25;165,25])
add_line(sys,[250,155;260,155])
add_line(sys,[170,160;225,160])
add_line(sys,[385,155;425,155;425,115;330,115])
add_line(sys,[285,115;205,115;205,145;225,145])
add_line(sys,[170,160;185,160;185,105;215,105;215,80])
add_line(sys,[385,155;425,155;425,90;275,80])

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
