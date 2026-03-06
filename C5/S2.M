function [ret,x0,str,ts,xts]=s2(t,x,u,flag);
%s2	is the M-file description of the SIMULINK system named s2.
%	The block-diagram can be displayed by typing: s2.
%
%	SYS=s2(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes s2 to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling s2 with a FLAG of zero:
%	[SIZES]=s2([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[-4,60,787,398])
     open_system(sys)
end;
set_param(sys,'algorithm',     'Linear')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     'tstop')
set_param(sys,'Min step size', '0.005')
set_param(sys,'Max step size', '0.005')
set_param(sys,'Relative error','1e-6')
set_param(sys,'Return vars',   '')

add_block('built-in/Note',[sys,'/','ib'])
set_param([sys,'/','ib'],...
		'position',[435,175,440,180])

add_block('built-in/Sum',[sys,'/','Sum5'])
set_param([sys,'/','Sum5'],...
		'position',[415,267,430,298])

add_block('built-in/Sum',[sys,'/','Sum4'])
set_param([sys,'/','Sum4'],...
		'position',[410,178,425,207])

add_block('built-in/Sine Wave',[sys,'/','ibn'])
set_param([sys,'/','ibn'],...
		'amplitude','10/n',...
		'frequency','(2*pi)*n',...
		'phase','-n*pi/6',...
		'position',[310,150,340,170])

add_block('built-in/Switch',[sys,'/','Sw2'])
set_param([sys,'/','Sw2'],...
		'Threshold','0.5',...
		'position',[365,244,385,276])

add_block('built-in/Sine Wave',[sys,'/','icn'])
set_param([sys,'/','icn'],...
		'amplitude','10/n',...
		'frequency','(2*pi)*n',...
		'phase','n*7*pi/6',...
		'position',[310,240,340,260])

add_block('built-in/Switch',[sys,'/','Sw1'])
set_param([sys,'/','Sw1'],...
		'Threshold','0.5',...
		'position',[365,154,385,186])

add_block('built-in/Note',[sys,'/','ic'])
set_param([sys,'/','ic'],...
		'position',[440,265,445,270])

add_block('built-in/Sum',[sys,'/','Sum'])
set_param([sys,'/','Sum'],...
		'inputs','+++',...
		'position',[485,133,505,237])

add_block('built-in/Sum',[sys,'/','Sum2'])
set_param([sys,'/','Sum2'],...
		'inputs','+-',...
		'position',[610,138,630,202])

add_block('built-in/Sum',[sys,'/','Sum1'])
set_param([sys,'/','Sum1'],...
		'inputs','+-',...
		'position',[530,241,550,299])

add_block('built-in/Gain',[sys,'/','Gain'])
set_param([sys,'/','Gain'],...
		'Gain','0.5',...
		'position',[530,167,570,203])

add_block('built-in/Gain',[sys,'/','Gain1'])
set_param([sys,'/','Gain1'],...
		'Gain','sqrt(3)/2',...
		'position',[575,248,645,292])

add_block('built-in/Gain',[sys,'/','Gain3'])
set_param([sys,'/','Gain3'],...
		'Gain','-1',...
		'position',[670,253,705,287])

add_block('built-in/Note',[sys,'/','x1'])
set_param([sys,'/','x1'],...
		'position',[718,151,723,156])

add_block('built-in/Note',[sys,'/','x2'])
set_param([sys,'/','x2'],...
		'position',[720,220,725,225])

add_block('built-in/Note',[sys,'/','y1'])
set_param([sys,'/','y1'],...
		'position',[715,175,720,180])

add_block('built-in/Note',[sys,'/','y2'])
set_param([sys,'/','y2'],...
		'position',[715,250,720,255])

add_block('built-in/To Workspace',[sys,'/','To Workspace'])
set_param([sys,'/','To Workspace'],...
		'mat-name','y',...
		'position',[755,96,790,114])

add_block('built-in/Mux',[sys,'/','Mux'])
set_param([sys,'/','Mux'],...
		'inputs','3',...
		'position',[705,74,730,136])

add_block('built-in/Clock',[sys,'/','Clock'])
set_param([sys,'/','Clock'],...
		'orientation',2,...
		'position',[260,60,280,80])

add_block('built-in/Fcn',[sys,'/','Fcn3'])
set_param([sys,'/','Fcn3'],...
		'orientation',2,...
		'Expr','10*exp(-alpha*u[1])',...
		'position',[95,28,225,52])

add_block('built-in/Gain',[sys,'/','omega*t'])
set_param([sys,'/','omega*t'],...
		'orientation',2,...
		'Gain','2*pi',...
		'position',[90,69,135,101])

add_block('built-in/Mux',[sys,'/','Mux1'])
set_param([sys,'/','Mux1'],...
		'orientation',1,...
		'inputs','2',...
		'position',[57,145,88,180])

add_block('built-in/Sum',[sys,'/','Sum3'])
set_param([sys,'/','Sum3'],...
		'position',[415,104,430,131])

add_block('built-in/Switch',[sys,'/','Sw'])
set_param([sys,'/','Sw'],...
		'Threshold','0.5',...
		'position',[365,79,385,111])

add_block('built-in/Sine Wave',[sys,'/','ian'])
set_param([sys,'/','ian'],...
		'amplitude','10/n',...
		'frequency','(2*pi)*n',...
		'phase','n*pi/2',...
		'position',[310,75,340,95])

add_block('built-in/Note',[sys,'/','ia'])
set_param([sys,'/','ia'],...
		'position',[440,100,445,105])

add_block('built-in/Gain',[sys,'/','Gain2'])
set_param([sys,'/','Gain2'],...
		'Gain','1.5',...
		'position',[525,101,565,139])

add_block('built-in/Fcn',[sys,'/','iam'])
set_param([sys,'/','iam'],...
		'Expr','u[1]*cos(m*u[2])',...
		'position',[155,109,285,141])

add_block('built-in/Fcn',[sys,'/','ibm'])
set_param([sys,'/','ibm'],...
		'Expr','u[1]*cos(m*(u[2]-2*pi/3))',...
		'position',[145,184,295,216])

add_block('built-in/Fcn',[sys,'/','icm'])
set_param([sys,'/','icm'],...
		'Expr','u[1]*cos(m*(u[2] +2*pi/3))',...
		'position',[140,274,300,306])

add_block('built-in/Constant',[sys,'/','nSw'])
set_param([sys,'/','nSw'],...
		'Value','n',...
		'position',[315,35,335,55])


%     Subsystem  'i2'.

new_system([sys,'/','i2'])
set_param([sys,'/','i2'],'Location',[8,52,282,245])

add_block('built-in/Inport',[sys,'/','i2/y'])
set_param([sys,'/','i2/y'],...
		'Port','2',...
		'position',[10,100,30,120])

add_block('built-in/Inport',[sys,'/','i2/x'])
set_param([sys,'/','i2/x'],...
		'position',[10,30,30,50])

add_block('built-in/Mux',[sys,'/','i2/Mux'])
set_param([sys,'/','i2/Mux'],...
		'inputs','2',...
		'position',[100,61,130,94])

add_block('built-in/S-Function',[sys,'/',['i2/S-function',13,'M-file which plots',13,'lines',13,'']])
set_param([sys,'/',['i2/S-function',13,'M-file which plots',13,'lines',13,'']],...
		'function name','sfunxy',...
		'parameters','ax, st',...
		'position',[185,70,235,90])
add_line([sys,'/','i2'],[35,110;70,110;70,85;95,85])
add_line([sys,'/','i2'],[35,40;70,40;70,70;95,70])
add_line([sys,'/','i2'],[135,80;180,80])
set_param([sys,'/','i2'],...
		'Mask Display','plot(0,0,100,100,[12,91,91,12,12],[90,90,45,45,90],[51,57,65,75,80,79,75,67,60,54,51,48,42,34,28,27,31,42,51],[71,68,66,66,72,79,83,84,81,77,71,60,54,54,58,65,71,74,71])',...
		'Mask Type','XY scope.')
set_param([sys,'/','i2'],...
		'Mask Dialogue','XY scope using MATLAB graph window.\nFirst input is used as time base.\nEnter plotting ranges.|x-min:|x-max:|y-min:|y-max:',...
		'Mask Translate','ax = [@1, @2, @3, @4];st=-1;')
set_param([sys,'/','i2'],...
		'Mask Help','This block can be used to explore limit cycles. Look at the m-file sfunxy.m to see how it works.',...
		'Mask Entries','-20\/20\/-20\/20\/')


%     Finished composite block 'i2'.

set_param([sys,'/','i2'],...
		'position',[760,233,795,282])


%     Subsystem  'i1'.

new_system([sys,'/','i1'])
set_param([sys,'/','i1'],'Location',[8,52,282,245])

add_block('built-in/Inport',[sys,'/','i1/y'])
set_param([sys,'/','i1/y'],...
		'Port','2',...
		'position',[10,100,30,120])

add_block('built-in/Inport',[sys,'/','i1/x'])
set_param([sys,'/','i1/x'],...
		'position',[10,30,30,50])

add_block('built-in/Mux',[sys,'/','i1/Mux'])
set_param([sys,'/','i1/Mux'],...
		'inputs','2',...
		'position',[100,61,130,94])

add_block('built-in/S-Function',[sys,'/',['i1/S-function',13,'M-file which plots',13,'lines',13,'']])
set_param([sys,'/',['i1/S-function',13,'M-file which plots',13,'lines',13,'']],...
		'function name','sfunxy',...
		'parameters','ax, st',...
		'position',[185,70,235,90])
add_line([sys,'/','i1'],[35,110;70,110;70,85;95,85])
add_line([sys,'/','i1'],[35,40;70,40;70,70;95,70])
add_line([sys,'/','i1'],[135,80;180,80])
set_param([sys,'/','i1'],...
		'Mask Display','plot(0,0,100,100,[12,91,91,12,12],[90,90,45,45,90],[51,57,65,75,80,79,75,67,60,54,51,48,42,34,28,27,31,42,51],[71,68,66,66,72,79,83,84,81,77,71,60,54,54,58,65,71,74,71])',...
		'Mask Type','XY scope.')
set_param([sys,'/','i1'],...
		'Mask Dialogue','XY scope using MATLAB graph window.\nFirst input is used as time base.\nEnter plotting ranges.|x-min:|x-max:|y-min:|y-max:',...
		'Mask Translate','ax = [@1, @2, @3, @4];st=-1;')
set_param([sys,'/','i1'],...
		'Mask Help','This block can be used to explore limit cycles. Look at the m-file sfunxy.m to see how it works.',...
		'Mask Entries','-20\/20\/-20\/20\/')


%     Finished composite block 'i1'.

set_param([sys,'/','i1'],...
		'position',[760,158,795,207])

add_block('built-in/Note',[sys,'/',['Run simulation once to open up the two XY graphs, move ',13,'them to an open location before reruning  the simulation']])
set_param([sys,'/',['Run simulation once to open up the two XY graphs, move ',13,'them to an open location before reruning  the simulation']],...
		'position',[670,25,675,30])


%     Subsystem  'm2'.

new_system([sys,'/','m2'])
set_param([sys,'/','m2'],'Location',[275,5963853,450,5963937])

add_block('built-in/Note',[sys,'/',['m2/Masked block m2.m',13,'to initialize s2.m and plot results']])
set_param([sys,'/',['m2/Masked block m2.m',13,'to initialize s2.m and plot results']],...
		'position',[125,35,130,40])
set_param([sys,'/','m2'],...
		'Mask Display','Initialize\nand plot',...
		'Mask Type','Masked block of m2.m',...
		'Mask Dialogue','eval(''m2'')',...
		'Mask Help','Uses m2.m to initialize and plot results')


%     Finished composite block 'm2'.

set_param([sys,'/','m2'],...
		'Drop Shadow',4,...
		'position',[407,31,467,65])
add_line(sys,[555,270;570,270])
add_line(sys,[510,185;525,185])
add_line(sys,[635,170;755,170])
add_line(sys,[650,270;650,195;755,195])
add_line(sys,[575,185;605,185])
add_line(sys,[570,120;580,120;580,155;605,155])
add_line(sys,[635,170;660,170;660,245;755,245])
add_line(sys,[650,270;665,270])
add_line(sys,[710,270;755,270])
add_line(sys,[635,170;640,170;640,85;700,85])
add_line(sys,[650,270;650,105;700,105])
add_line(sys,[710,270;710,155;685,155;685,125;700,125])
add_line(sys,[735,105;750,105])
add_line(sys,[435,120;520,120])
add_line(sys,[435,120;450,120;450,150;480,150])
add_line(sys,[430,195;455,195;455,185;480,185])
add_line(sys,[435,285;525,285])
add_line(sys,[435,285;455,285;455,220;480,220])
add_line(sys,[430,195;470,195;470,255;525,255])
add_line(sys,[345,85;360,85])
add_line(sys,[390,95;395,95;395,110;410,110])
add_line(sys,[345,160;360,160])
add_line(sys,[390,170;395,170;405,185])
add_line(sys,[345,250;360,250])
add_line(sys,[390,260;390,275;410,275])
add_line(sys,[340,45;350,45;360,260])
add_line(sys,[340,45;350,45;360,170])
add_line(sys,[340,45;350,45;360,95])
add_line(sys,[255,70;210,70;210,85;140,85])
add_line(sys,[290,125;410,125])
add_line(sys,[300,200;405,200])
add_line(sys,[305,290;410,290])
add_line(sys,[90,40;65,40;65,140])
add_line(sys,[255,70;245,70;245,40;230,40])
add_line(sys,[85,85;80,85;80,140])
add_line(sys,[75,185;75,200;125,200;125,125;150,125])
add_line(sys,[75,185;75,200;140,200])
add_line(sys,[75,185;75,290;135,290])

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
