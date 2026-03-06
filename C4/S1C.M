function [ret,x0,str,ts,xts]=s1c(t,x,u,flag);
%s1c	is the M-file description of the SIMULINK system named s1c.
%	The block-diagram can be displayed by typing: s1c.
%
%	SYS=s1c(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes s1c to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling s1c with a FLAG of zero:
%	[SIZES]=s1c([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[4,43,792,592])
     open_system(sys)
end;
set_param(sys,'algorithm',     'Adams/Gear')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     'tstop')
set_param(sys,'Min step size', '1e-4')
set_param(sys,'Max step size', '1e-3')
set_param(sys,'Relative error','1e-7')
set_param(sys,'Return vars',   '')

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
		'Vgain','200.000000',...
		'Hgain','0.200000',...
		'Vmax','400.000000',...
		'Hmax','0.400000',...
		'Window',[0,474,812,600])
open_system([sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'position',[565,62,585,88])

add_block('built-in/To Workspace',[sys,'/','To Workspace'])
set_param([sys,'/','To Workspace'],...
		'orientation',2,...
		'mat-name','y',...
		'buffer','80000',...
		'position',[310,67,360,83])

add_block('built-in/Fcn',[sys,'/','Fcn4'])
set_param([sys,'/','Fcn4'],...
		'Expr','(u[1]-u[2])/xl1',...
		'position',[550,206,640,234])

add_block('built-in/Mux',[sys,'/','Mux'])
set_param([sys,'/','Mux'],...
		'inputs','3',...
		'position',[175,188,195,272])

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
		'position',[545,410,640,440])

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

add_block('built-in/Mux',[sys,'/','Mux1'])
set_param([sys,'/','Mux1'],...
		'inputs','3',...
		'position',[175,372,195,448])

add_block('built-in/Note',[sys,'/',['psi2''']])
set_param([sys,'/',['psi2''']],...
		'position',[440,386,445,391])

add_block('built-in/Note',[sys,'/','psim'])
set_param([sys,'/','psim'],...
		'position',[720,280,725,285])

add_block('built-in/Outport',[sys,'/','Out_psim'])
set_param([sys,'/','Out_psim'],...
		'Port','2',...
		'position',[805,295,825,315])

add_block('built-in/Mux',[sys,'/','Mux3'])
set_param([sys,'/','Mux3'],...
		'inputs','3',...
		'position',[485,273,500,337])

add_block('built-in/Fcn',[sys,'/','Fcn3'])
set_param([sys,'/','Fcn3'],...
		'Expr','xM*(u[1]/xl1+u[2]/xpl2-u[3]/xm)',...
		'position',[520,286,695,324])

add_block('built-in/Note',[sys,'/','Dpsi'])
set_param([sys,'/','Dpsi'],...
		'orientation',2,...
		'position',[530,337,535,342])

add_block('built-in/Memory',[sys,'/','Memory'])
set_param([sys,'/','Memory'],...
		'orientation',2,...
		'position',[560,343,585,367])

add_block('built-in/Look Up Table',[sys,'/',['Look-Up',13,'Table']])
set_param([sys,'/',['Look-Up',13,'Table']],...
		'orientation',2,...
		'Input_Values','psisat',...
		'Output_Values','Dpsi',...
		'position',[630,338,690,372])


%     Subsystem  'Load Module'.

new_system([sys,'/','Load Module'])
set_param([sys,'/','Load Module'],'Location',[64,124,294,386])

add_block('built-in/Outport',[sys,'/','Load Module/out_1'])
set_param([sys,'/','Load Module/out_1'],...
		'orientation',2,...
		'position',[15,55,35,75])

add_block('built-in/Inport',[sys,'/','Load Module/in_1'])
set_param([sys,'/','Load Module/in_1'],...
		'orientation',2,...
		'position',[180,55,200,75])

add_block('built-in/Gain',[sys,'/','Load Module/HGR'])
set_param([sys,'/','Load Module/HGR'],...
		'orientation',2,...
		'Gain','-RH',...
		'position',[90,44,130,86])
add_line([sys,'/','Load Module'],[85,65;40,65])
add_line([sys,'/','Load Module'],[175,65;135,65])


%     Finished composite block 'Load Module'.

set_param([sys,'/','Load Module'],...
		'position',[785,420,820,470])

add_block('built-in/Sine Wave',[sys,'/','v1'])
set_param([sys,'/','v1'],...
		'amplitude','Vpk',...
		'frequency','wb',...
		'phase','0*pi/2',...
		'position',[80,215,115,245])

add_block('built-in/Note',[sys,'/','v2p'])
set_param([sys,'/','v2p'],...
		'position',[125,400,130,405])

add_block('built-in/Integrator',[sys,'/',['psi2''_']])
set_param([sys,'/',['psi2''_']],...
		'Initial','Psip2o',...
		'position',[400,397,430,423])

add_block('built-in/Fcn',[sys,'/','Fcn2'])
set_param([sys,'/','Fcn2'],...
		'Expr','wb*(u[2] -(rp2/xpl2)*(u[1]-u[3]))',...
		'position',[205,394,385,426])

add_block('built-in/Note',[sys,'/',['i2''']])
set_param([sys,'/',['i2''']],...
		'position',[655,402,660,407])

add_block('built-in/Note',[sys,'/',['Double click the masked block m1 or run m1.m in MATLAB command window to initialize this simulation.',13,'Type return after the K>> prompt in the MATLAB command window to plot simulated results. ']])
set_param([sys,'/',['Double click the masked block m1 or run m1.m in MATLAB command window to initialize this simulation.',13,'Type return after the K>> prompt in the MATLAB command window to plot simulated results. ']],...
		'position',[435,488,440,493])

add_block('built-in/Note',[sys,'/',[' Double click masked block FFT to run fftplot.m and provide the input requested in the MATLAB command ',13,'window to obtain the time and frequency plots.']])
set_param([sys,'/',[' Double click masked block FFT to run fftplot.m and provide the input requested in the MATLAB command ',13,'window to obtain the time and frequency plots.']],...
		'position',[440,520,445,525])


%     Subsystem  'm1'.

new_system([sys,'/','m1'])
set_param([sys,'/','m1'],'Location',[5,5767267,170,5767382])

add_block('built-in/Note',[sys,'/',['m1/This masked block uses m1.m',13,'to initialize s1c.m.',13,'and plots the simulated results  ']])
set_param([sys,'/',['m1/This masked block uses m1.m',13,'to initialize s1c.m.',13,'and plots the simulated results  ']],...
		'position',[125,31,130,36])
set_param([sys,'/','m1'],...
		'Mask Display','Initialize\nand plot',...
		'Mask Type','Masked block of m1.m',...
		'Mask Dialogue','eval(''m1'')',...
		'Mask Help','Uses m1.m to initialize and plot')


%     Finished composite block 'm1'.

set_param([sys,'/','m1'],...
		'Drop Shadow',4,...
		'position',[82,38,151,72])


%     Subsystem  'FFT'.

new_system([sys,'/','FFT'])
set_param([sys,'/','FFT'],'Location',[125,5767262,465,5767348])

add_block('built-in/Note',[sys,'/',['FFT/FFT computation using the time and variable arrays(column)',13,'in the Matlab workspace.  It uses fftplot.m in the user''s ',13,'Matlab directory.  fftplot.m  will interpolate for values',13,'at uniformly spaced time interval.  ']])
set_param([sys,'/',['FFT/FFT computation using the time and variable arrays(column)',13,'in the Matlab workspace.  It uses fftplot.m in the user''s ',13,'Matlab directory.  fftplot.m  will interpolate for values',13,'at uniformly spaced time interval.  ']],...
		'position',[225,31,230,36])
set_param([sys,'/','FFT'],...
		'Mask Display','Plots FFT',...
		'Mask Type','Masked block of fftplot.m',...
		'Mask Dialogue','eval(''fftplot'')')


%     Finished composite block 'FFT'.

set_param([sys,'/','FFT'],...
		'Drop Shadow',4,...
		'position',[184,39,260,73])
add_line(sys,[120,230;170,230])
add_line(sys,[200,230;205,230])
add_line(sys,[380,230;385,230])
add_line(sys,[390,410;395,410])
add_line(sys,[425,230;460,230;460,285;480,285])
add_line(sys,[505,305;515,305])
add_line(sys,[530,220;545,220])
add_line(sys,[425,230;460,230;460,205;500,205])
add_line(sys,[700,305;750,305;750,260;480,260;480,230;500,230])
add_line(sys,[700,305;750,305;750,470;150,470;150,435;170,435])
add_line(sys,[700,305;750,305;750,170;155,170;155,200;170,200])
add_line(sys,[700,305;800,305])
add_line(sys,[645,220;715,220])
add_line(sys,[425,230;460,230;460,160;790,160])
add_line(sys,[200,410;200,410])
add_line(sys,[825,445;840,445;840,480;145,480;145,160;405,160;405,125])
add_line(sys,[840,445;840,480;145,480;145,410;170,410])
add_line(sys,[435,410;460,410;460,360;155,360;155,385;170,385])
add_line(sys,[425,230;460,230;460,285;155,285;155,260;170,260])
add_line(sys,[435,410;460,410;460,305;480,305])
add_line(sys,[520,425;540,425])
add_line(sys,[645,425;695,425])
add_line(sys,[435,410;490,410])
add_line(sys,[700,305;750,305;750,470;465,470;465,435;490,435])
add_line(sys,[120,230;135,230;135,150;305,150;305,125])
add_line(sys,[125,135;205,125])
add_line(sys,[700,305;750,305;750,150;505,150;505,125])
add_line(sys,[645,220;685,220;685,140;605,140;605,125])
add_line(sys,[645,425;670,425;670,400;765,400;765,140;705,140;705,125])
add_line(sys,[455,95;455,75;560,75])
add_line(sys,[455,95;455,75;365,75])
add_line(sys,[700,305;715,305;715,355;695,355])
add_line(sys,[555,355;465,355;465,325;480,325])
add_line(sys,[625,355;590,355])
add_line(sys,[645,425;670,425;670,445;780,445])

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
