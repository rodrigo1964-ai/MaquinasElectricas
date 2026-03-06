function [ret,x0,str,ts,xts]=s4(t,x,u,flag);
%s4	is the M-file description of the SIMULINK system named s4.
%	The block-diagram can be displayed by typing: s4.
%
%	SYS=s4(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes s4 to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling s4 with a FLAG of zero:
%	[SIZES]=s4([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[3,53,777,447])
     open_system(sys)
end;
set_param(sys,'algorithm',     'RK-45')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     'tstop')
set_param(sys,'Min step size', '1e-7')
set_param(sys,'Max step size', '5e-3')
set_param(sys,'Relative error','1e-5')
set_param(sys,'Return vars',   '')

add_block('built-in/To Workspace',[sys,'/','To Workspace'])
set_param([sys,'/','To Workspace'],...
		'mat-name','y',...
		'buffer','100000',...
		'position',[540,16,585,34])

add_block('built-in/Scope',[sys,'/','Scope1'])
set_param([sys,'/','Scope1'],...
		'Vgain','600.000000',...
		'Hgain','0.003000',...
		'Vmax','1200.000000',...
		'Hmax','0.006000',...
		'Window',[52,402,383,716],...
		'position',[260,15,275,35])

add_block('built-in/Note',[sys,'/',['Double click on masked block of m4 in this screen or run m4.m in MATLAB command window',13,'to initialize simulation.  After simulation type return after the K>> prompt in MATLAB command ',13,'window to obtain a plot of the simulated results.']])
set_param([sys,'/',['Double click on masked block of m4 in this screen or run m4.m in MATLAB command window',13,'to initialize simulation.  After simulation type return after the K>> prompt in MATLAB command ',13,'window to obtain a plot of the simulated results.']],...
		'position',[395,345,400,350])

add_block('built-in/Gain',[sys,'/','R'])
set_param([sys,'/','R'],...
		'orientation',2,...
		'Gain','R',...
		'position',[515,194,545,226])

add_block('built-in/Note',[sys,'/','vS'])
set_param([sys,'/','vS'],...
		'position',[380,235,385,240])


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
		'position',[345,243,360,267])

add_block('built-in/Constant',[sys,'/','Vdc'])
set_param([sys,'/','Vdc'],...
		'Value','Vdc',...
		'position',[240,287,290,303])

add_block('built-in/Fcn',[sys,'/','Load power'])
set_param([sys,'/','Load power'],...
		'orientation',2,...
		'Expr','u[1]*u[1]*R',...
		'position',[535,139,625,161])

add_block('built-in/Gain',[sys,'/','1//L'])
set_param([sys,'/','1//L'],...
		'Gain','1/L',...
		'position',[490,236,530,274])

add_block('built-in/Integrator',[sys,'/','iL'])
set_param([sys,'/','iL'],...
		'Initial','iLo',...
		'position',[560,238,590,272])

add_block('built-in/Note',[sys,'/','i'])
set_param([sys,'/','i'],...
		'position',[605,235,610,240])

add_block('built-in/Sum',[sys,'/','Sum'])
set_param([sys,'/','Sum'],...
		'inputs','-+-',...
		'position',[440,237,455,273])

add_block('built-in/Mux',[sys,'/','Mux'])
set_param([sys,'/','Mux'],...
		'orientation',3,...
		'inputs','5',...
		'position',[248,55,632,70])

add_block('built-in/Clock',[sys,'/','Clock'])
set_param([sys,'/','Clock'],...
		'position',[205,86,225,104])

add_block('built-in/Mux',[sys,'/','Mux1'])
set_param([sys,'/','Mux1'],...
		'inputs','2',...
		'position',[135,231,165,264])


%     Subsystem  'Sign'.

new_system([sys,'/','Sign'])
set_param([sys,'/','Sign'],'Location',[159,417,467,586])

add_block('built-in/Outport',[sys,'/','Sign/out_1'])
set_param([sys,'/','Sign/out_1'],...
		'position',[265,70,285,90])

add_block('built-in/Inport',[sys,'/','Sign/in_1'])
set_param([sys,'/','Sign/in_1'],...
		'position',[35,30,55,50])

add_block('built-in/Relational Operator',[sys,'/',['Sign/Relational',13,'Operator']])
set_param([sys,'/',['Sign/Relational',13,'Operator']],...
		'Operator','>',...
		'position',[140,32,170,63])

add_block('built-in/Sum',[sys,'/','Sign/Sum'])
set_param([sys,'/','Sign/Sum'],...
		'inputs','+-',...
		'position',[215,64,235,91])

add_block('built-in/Relational Operator',[sys,'/',['Sign/Relational',13,'Operator1']])
set_param([sys,'/',['Sign/Relational',13,'Operator1']],...
		'Operator','<',...
		'position',[140,92,170,123])

add_block('built-in/Constant',[sys,'/','Sign/Constant'])
set_param([sys,'/','Sign/Constant'],...
		'Value','0',...
		'position',[65,105,85,125])
add_line([sys,'/','Sign'],[60,40;135,40])
add_line([sys,'/','Sign'],[95,40;95,100;135,100])
add_line([sys,'/','Sign'],[90,115;135,115])
add_line([sys,'/','Sign'],[110,115;110,55;135,55])
add_line([sys,'/','Sign'],[175,110;185,110;185,85;210,85])
add_line([sys,'/','Sign'],[175,50;185,50;185,70;210,70])
add_line([sys,'/','Sign'],[240,80;260,80])
set_param([sys,'/','Sign'],...
		'Mask Display','plot(-50,-50,50,50,[-50,50],[0,0],[0,0],[-50,50],[-40,0],[-30,-30],[0,40],[30,30])',...
		'Mask Type','Sign',...
		'Mask Dialogue','y = sign(x)')
set_param([sys,'/','Sign'],...
		'Mask Help','Sign Function:\n\t\t\ty = 1 if x > 0\n\t\t\ty = 0 if x = 0\n\t\t\ty = -1 if x < 0')


%     Finished composite block 'Sign'.

set_param([sys,'/','Sign'],...
		'position',[285,236,315,264])

add_block('built-in/Fcn',[sys,'/','Fcn1'])
set_param([sys,'/','Fcn1'],...
		'Expr','sin(u[1]*u[2])',...
		'position',[185,238,270,262])


%     Subsystem  'Pref'.

new_system([sys,'/','Pref'])
set_param([sys,'/','Pref'],'Location',[5,40,315,196])

add_block('built-in/Outport',[sys,'/','Pref/out_1'])
set_param([sys,'/','Pref/out_1'],...
		'position',[285,60,305,80])

add_block('built-in/Look Up Table',[sys,'/','Pref/Look-Up Table'])
set_param([sys,'/','Pref/Look-Up Table'],...
		'Input_Values','t',...
		'Output_Values','y',...
		'position',[210,58,250,82])

add_block('built-in/Fcn',[sys,'/','Pref/Fcn1'])
set_param([sys,'/','Pref/Fcn1'],...
		'Expr','rem(u[1],period)',...
		'position',[110,60,150,80])

add_block('built-in/Clock',[sys,'/','Pref/Clock'])
set_param([sys,'/','Pref/Clock'],...
		'position',[45,60,65,80])
add_line([sys,'/','Pref'],[255,70;280,70])
add_line([sys,'/','Pref'],[70,70;105,70])
add_line([sys,'/','Pref'],[155,70;205,70])
set_param([sys,'/','Pref'],...
		'Mask Display','plot([t,t+period,t+2*period],[y,y,y])',...
		'Mask Type','Repeating table',...
		'Mask Dialogue','Repeating table.\nEnter values of time and output for first cycle.|Time values:|Output values:')
set_param([sys,'/','Pref'],...
		'Mask Translate','period = max(@1); t = @1; y = @2;',...
		'Mask Help','Repeats cycle given in table. Time values should be monotonically increasing.',...
		'Mask Entries','Pref_time\/Pref_value\/')


%     Finished composite block 'Pref'.

set_param([sys,'/','Pref'],...
		'orientation',2,...
		'position',[350,163,385,187])

add_block('built-in/Transfer Fcn',[sys,'/','Transfer Fcn'])
set_param([sys,'/','Transfer Fcn'],...
		'orientation',2,...
		'Denominator','[tf 1]',...
		'position',[430,132,505,168])

add_block('built-in/Transfer Fcn',[sys,'/','controller'])
set_param([sys,'/','controller'],...
		'orientation',2,...
		'Numerator','4e4*[1 10*tf]',...
		'Denominator','[1 0]',...
		'position',[190,142,290,178])

add_block('built-in/Sum',[sys,'/','Sum1'])
set_param([sys,'/','Sum1'],...
		'orientation',2,...
		'inputs','-+',...
		'position',[305,143,320,172])

add_block('built-in/Saturation',[sys,'/','wo limit'])
set_param([sys,'/','wo limit'],...
		'orientation',2,...
		'Lower Limit','0',...
		'Upper Limit','wo',...
		'position',[140,146,170,174])

add_block('built-in/Scope',[sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'orientation',2,...
		'Vgain','500.000000',...
		'Hgain','0.002500',...
		'Vmax','1000.000000',...
		'Hmax','0.005000',...
		'Window',[13,438,800,600])
open_system([sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'position',[335,15,350,35])

add_block('built-in/Integrator',[sys,'/','vC'])
set_param([sys,'/','vC'],...
		'orientation',2,...
		'Initial','vCo',...
		'position',[530,289,560,321])

add_block('built-in/Gain',[sys,'/','Gain'])
set_param([sys,'/','Gain'],...
		'orientation',2,...
		'Gain','1/C',...
		'position',[595,287,635,323])


%     Subsystem  'm4'.

new_system([sys,'/','m4'])
set_param([sys,'/','m4'],'Location',[165,6357193,225,6357256])

add_block('built-in/Note',[sys,'/',['m4/Masked block of m4.m to initialize ',13,'and plot results']])
set_param([sys,'/',['m4/Masked block of m4.m to initialize ',13,'and plot results']],...
		'position',[10,15,15,20])
set_param([sys,'/','m4'],...
		'Mask Display','Initialize\nand plot',...
		'Mask Type','Masked block of m4.m',...
		'Mask Dialogue','eval(''m4'')',...
		'Mask Help','Uses m4.m to initialize and plot')


%     Finished composite block 'm4'.

set_param([sys,'/','m4'],...
		'Drop Shadow',4,...
		'position',[114,29,185,71])
add_line(sys,[535,255;555,255])
add_line(sys,[440,50;440,25;535,25])
add_line(sys,[230,95;290,95;290,75])
add_line(sys,[440,50;440,25;355,25])
add_line(sys,[460,255;485,255])
add_line(sys,[595,255;660,255;660,210;550,210])
add_line(sys,[510,210;420,210;420,245;435,245])
add_line(sys,[595,255;660,255;660,305;640,305])
add_line(sys,[590,305;565,305])
add_line(sys,[525,305;415,305;415,265;435,265])
add_line(sys,[595,255;660,255;660,150;630,150])
add_line(sys,[530,150;510,150])
add_line(sys,[345,175;335,175;325,165])
add_line(sys,[300,160;295,160])
add_line(sys,[275,250;280,250])
add_line(sys,[365,255;435,255])
add_line(sys,[295,295;320,295;320,260;340,260])
add_line(sys,[320,250;340,250])
add_line(sys,[365,255;395,255;395,85;365,75])
add_line(sys,[525,305;495,305;495,335;685,335;685,100;590,100;590,75])
add_line(sys,[170,250;180,250])
add_line(sys,[230,95;240,95;240,110;110,110;110,255;130,255])
add_line(sys,[135,160;120,160;130,240])
add_line(sys,[425,150;325,150])
add_line(sys,[425,150;415,150;415,105;440,105;440,75])
add_line(sys,[595,255;660,255;660,115;515,115;515,75])
add_line(sys,[185,160;175,160])

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
