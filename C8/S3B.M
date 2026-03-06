function [ret,x0,str,ts,xts]=s3b(t,x,u,flag);
%s3b	is the M-file description of the SIMULINK system named s3b.
%	s3b has a the following characteristics:
%		4 continuous states
%		0 discrete states
%		0 outputs
%		0 inputs
%		does not have direct feedthrough
%		1 sample times
%
%	The block-diagram can be displayed by typing: s3b.
%
%	SYS=s3b(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes s3b to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling s3b with a FLAG of zero:
%	[SIZES]=s3b([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[15,55,806,478])
     open_system(sys)
end;
set_param(sys,'algorithm',     'Adams/Gear')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     '140')
set_param(sys,'Min step size', '0.005')
set_param(sys,'Max step size', '0.1')
set_param(sys,'Relative error','1e-6')
set_param(sys,'Return vars',   '')

add_block('built-in/Note',[sys,'/','wm'])
set_param([sys,'/','wm'],...
		'position',[625,185,630,190])


%     Subsystem  'wm* of hoisting  cycle'.

new_system([sys,'/','wm* of hoisting  cycle'])
set_param([sys,'/','wm* of hoisting  cycle'],'Location',[5,40,315,196])

add_block('built-in/Outport',[sys,'/','wm* of hoisting  cycle/out_1'])
set_param([sys,'/','wm* of hoisting  cycle/out_1'],...
		'position',[285,60,305,80])

add_block('built-in/Look Up Table',[sys,'/','wm* of hoisting  cycle/Look-Up Table'])
set_param([sys,'/','wm* of hoisting  cycle/Look-Up Table'],...
		'Input_Values','t',...
		'Output_Values','y',...
		'position',[210,58,250,82])

add_block('built-in/Fcn',[sys,'/','wm* of hoisting  cycle/Fcn1'])
set_param([sys,'/','wm* of hoisting  cycle/Fcn1'],...
		'Expr','rem(u[1],period)',...
		'position',[110,60,150,80])

add_block('built-in/Clock',[sys,'/','wm* of hoisting  cycle/Clock'])
set_param([sys,'/','wm* of hoisting  cycle/Clock'],...
		'position',[45,60,65,80])
add_line([sys,'/','wm* of hoisting  cycle'],[255,70;280,70])
add_line([sys,'/','wm* of hoisting  cycle'],[70,70;105,70])
add_line([sys,'/','wm* of hoisting  cycle'],[155,70;205,70])
set_param([sys,'/','wm* of hoisting  cycle'],...
		'Mask Display','plot([t,t+period,t+2*period],[y,y,y])',...
		'Mask Type','Repeating table')
set_param([sys,'/','wm* of hoisting  cycle'],...
		'Mask Dialogue','Repeating table.\nEnter values of time and output for first cycle.|Time values:|Output values:',...
		'Mask Translate','period = max(@1); t = @1; y = @2;')
set_param([sys,'/','wm* of hoisting  cycle'],...
		'Mask Help','Repeats cycle given in table. Time values should be monotonically increasing.',...
		'Mask Entries','[0 30 40  50  65 75 85 95 100]\/[0 wraise wraise 0 0 wlower wlower 0 0]\/')


%     Finished composite block 'wm* of hoisting  cycle'.

set_param([sys,'/','wm* of hoisting  cycle'],...
		'orientation',2,...
		'position',[540,24,605,56])

add_block('built-in/Note',[sys,'/','Va'])
set_param([sys,'/','Va'],...
		'position',[85,42,90,47])

add_block('built-in/Gain',[sys,'/','Ra'])
set_param([sys,'/','Ra'],...
		'orientation',2,...
		'Gain','Ra',...
		'position',[165,238,200,272])

add_block('built-in/Transfer Fcn',[sys,'/','Current controller'])
set_param([sys,'/','Current controller'],...
		'orientation',2,...
		'Numerator','10*[1 0.0004]',...
		'Denominator','[1 0 ]',...
		'position',[325,37,415,73])

add_block('built-in/Saturation',[sys,'/','Ia_limit'])
set_param([sys,'/','Ia_limit'],...
		'orientation',2,...
		'Lower Limit','-Iarated*1.2',...
		'Upper Limit','Iarated*1.2',...
		'position',[255,36,300,74])

add_block('built-in/Sum',[sys,'/','Sum3'])
set_param([sys,'/','Sum3'],...
		'orientation',2,...
		'inputs','+-',...
		'position',[195,45,210,80])

add_block('built-in/Note',[sys,'/','wm_'])
set_param([sys,'/','wm_'],...
		'position',[490,50,495,55])

add_block('built-in/Note',[sys,'/','wm*'])
set_param([sys,'/','wm*'],...
		'position',[490,20,495,25])

add_block('built-in/Sum',[sys,'/','Sum1'])
set_param([sys,'/','Sum1'],...
		'orientation',2,...
		'inputs','+-',...
		'position',[445,27,465,83])

add_block('built-in/Note',[sys,'/','Ea'])
set_param([sys,'/','Ea'],...
		'position',[135,111,140,116])

add_block('built-in/Transfer Fcn',[sys,'/','Converter'])
set_param([sys,'/','Converter'],...
		'orientation',2,...
		'Numerator','[100]',...
		'Denominator','[0.02 1]',...
		'position',[105,47,155,83])

add_block('built-in/Gain',[sys,'/','1//Laq'])
set_param([sys,'/','1//Laq'],...
		'Gain','1/Laq',...
		'position',[160,174,205,216])

add_block('built-in/Integrator',[sys,'/','Integrator2'])
set_param([sys,'/','Integrator2'],...
		'position',[560,187,590,223])

add_block('built-in/Gain',[sys,'/','1//J'])
set_param([sys,'/','1//J'],...
		'Gain','1/J',...
		'position',[490,184,535,226])

add_block('built-in/Note',[sys,'/','Tem'])
set_param([sys,'/','Tem'],...
		'position',[405,170,410,175])

add_block('built-in/Integrator',[sys,'/','Integrator'])
set_param([sys,'/','Integrator'],...
		'position',[240,177,270,213])

add_block('built-in/Sum',[sys,'/','Sum'])
set_param([sys,'/','Sum'],...
		'inputs','-+-',...
		'position',[115,156,135,234])

add_block('built-in/Note',[sys,'/','Ia'])
set_param([sys,'/','Ia'],...
		'position',[300,175,305,180])


%     Subsystem  '.'.

new_system([sys,'/','.'])
set_param([sys,'/','.'],'Location',[33,479,253,634])

add_block('built-in/Product',[sys,'/','./Product'])
set_param([sys,'/','./Product'],...
		'position',[65,55,90,75])

add_block('built-in/Sum',[sys,'/','./Sum'])
set_param([sys,'/','./Sum'],...
		'inputs','+',...
		'position',[125,55,145,75])

add_block('built-in/Outport',[sys,'/','./out_1'])
set_param([sys,'/','./out_1'],...
		'position',[185,55,205,75])

add_block('built-in/Inport',[sys,'/','./in_2'])
set_param([sys,'/','./in_2'],...
		'Port','2',...
		'position',[15,90,35,110])

add_block('built-in/Inport',[sys,'/','./in_1'])
set_param([sys,'/','./in_1'],...
		'position',[15,25,35,45])
add_line([sys,'/','.'],[40,100;60,70])
add_line([sys,'/','.'],[40,35;60,60])
add_line([sys,'/','.'],[95,65;120,65])
add_line([sys,'/','.'],[150,65;180,65])
set_param([sys,'/','.'],...
		'Mask Display','.\n',...
		'Mask Type','Dot Product',...
		'Mask Dialogue','Inner (dot) product.\ny=sum(u1.*u2)')
set_param([sys,'/','.'],...
		'Mask Help','Computes the inner (dot) product of the inputs: sum(u1.*u2).  The inputs are vectors of the same length. Output is a scalar.')


%     Finished composite block '.'.

set_param([sys,'/','.'],...
		'position',[370,171,385,204])


%     Subsystem  'Product2'.

new_system([sys,'/','Product2'])
set_param([sys,'/','Product2'],'Location',[33,479,253,634])

add_block('built-in/Product',[sys,'/','Product2/Product'])
set_param([sys,'/','Product2/Product'],...
		'position',[65,55,90,75])

add_block('built-in/Sum',[sys,'/','Product2/Sum'])
set_param([sys,'/','Product2/Sum'],...
		'inputs','+',...
		'position',[125,55,145,75])

add_block('built-in/Outport',[sys,'/','Product2/out_1'])
set_param([sys,'/','Product2/out_1'],...
		'position',[185,55,205,75])

add_block('built-in/Inport',[sys,'/','Product2/in_2'])
set_param([sys,'/','Product2/in_2'],...
		'Port','2',...
		'position',[15,90,35,110])

add_block('built-in/Inport',[sys,'/','Product2/in_1'])
set_param([sys,'/','Product2/in_1'],...
		'position',[15,25,35,45])
add_line([sys,'/','Product2'],[40,100;60,70])
add_line([sys,'/','Product2'],[40,35;60,60])
add_line([sys,'/','Product2'],[95,65;120,65])
add_line([sys,'/','Product2'],[150,65;180,65])
set_param([sys,'/','Product2'],...
		'Mask Display','.\n',...
		'Mask Type','Dot Product',...
		'Mask Dialogue','Inner (dot) product.\ny=sum(u1.*u2)')
set_param([sys,'/','Product2'],...
		'Mask Help','Computes the inner (dot) product of the inputs: sum(u1.*u2).  The inputs are vectors of the same length. Output is a scalar.')


%     Finished composite block 'Product2'.

set_param([sys,'/','Product2'],...
		'orientation',2,...
		'position',[235,115,255,155])

add_block('built-in/Constant',[sys,'/','kaphi'])
set_param([sys,'/','kaphi'],...
		'orientation',2,...
		'Value','0.6699',...
		'position',[360,134,410,156])

add_block('built-in/Mux',[sys,'/','Mux'])
set_param([sys,'/','Mux'],...
		'orientation',1,...
		'inputs','5',...
		'position',[238,330,602,350])

add_block('built-in/To Workspace',[sys,'/','To Workspace'])
set_param([sys,'/','To Workspace'],...
		'mat-name','y',...
		'buffer','30000',...
		'position',[465,354,515,376])

add_block('built-in/Scope',[sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'orientation',2,...
		'Vgain','200.000000',...
		'Hgain','150.000000',...
		'Vmax','400.000000',...
		'Hmax','300.000000',...
		'Window',[20,488,824,625])
open_system([sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'position',[355,354,375,376])

add_block('built-in/Clock',[sys,'/','Clock'])
set_param([sys,'/','Clock'],...
		'position',[200,306,220,324])

add_block('built-in/Step Fcn',[sys,'/','Tmech'])
set_param([sys,'/','Tmech'],...
		'orientation',2,...
		'After','-Trated',...
		'position',[465,238,505,262])

add_block('built-in/Sum',[sys,'/','Sum2'])
set_param([sys,'/','Sum2'],...
		'position',[440,179,455,226])


%     Subsystem  'm3b'.

new_system([sys,'/','m3b'])
set_param([sys,'/','m3b'],'Location',[65,6029761,277,6029850])

add_block('built-in/Note',[sys,'/',['m3b/Masked block of m3b.m to initialize',13,'s3b.m and plot results']])
set_param([sys,'/',['m3b/Masked block of m3b.m to initialize',13,'s3b.m and plot results']],...
		'position',[110,45,115,50])
set_param([sys,'/','m3b'],...
		'Mask Display','Initialize\nand plot',...
		'Mask Type','Masked block of m3b.m',...
		'Mask Dialogue','eval(''m3b'')',...
		'Mask Help','Uses m3b.m to initialize and plot')


%     Finished composite block 'm3b'.

set_param([sys,'/','m3b'],...
		'Drop Shadow',4,...
		'position',[82,333,161,374])
add_line(sys,[140,195;155,195])
add_line(sys,[460,205;485,205])
add_line(sys,[540,205;555,205])
add_line(sys,[275,195;365,195])
add_line(sys,[355,145;260,145])
add_line(sys,[230,135;95,135;95,170;110,170])
add_line(sys,[210,195;235,195])
add_line(sys,[275,195;285,195;285,255;205,255])
add_line(sys,[420,355;420,365;460,365])
add_line(sys,[420,355;420,365;380,365])
add_line(sys,[225,315;280,325])
add_line(sys,[355,145;340,145;340,180;365,180])
add_line(sys,[595,205;605,205;605,125;260,125])
add_line(sys,[390,190;435,190])
add_line(sys,[595,205;605,205;605,70;470,70])
add_line(sys,[535,40;470,40])
add_line(sys,[160,255;90,255;90,220;110,220])
add_line(sys,[460,250;420,250;420,215;435,215])
add_line(sys,[320,55;305,55])
add_line(sys,[440,55;420,55])
add_line(sys,[100,65;75,65;75,195;110,195])
add_line(sys,[250,55;215,55])
add_line(sys,[275,195;285,195;285,90;230,90;230,70;215,70])
add_line(sys,[190,65;160,65])
add_line(sys,[100,65;75,65;75,300;350,300;350,325])
add_line(sys,[275,195;285,195;285,290;420,290;420,325])
add_line(sys,[390,190;405,190;405,280;490,280;490,325])
add_line(sys,[595,205;605,205;605,280;560,280;560,325])

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
