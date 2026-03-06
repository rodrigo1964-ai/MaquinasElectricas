function [ret,x0,str,ts,xts]=s3a(t,x,u,flag);
%s3a	is the M-file description of the SIMULINK system named s3a.
%	The block-diagram can be displayed by typing: s3a.
%
%	SYS=s3a(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes s3a to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling s3a with a FLAG of zero:
%	[SIZES]=s3a([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[43,64,765,444])
     open_system(sys)
end;
set_param(sys,'algorithm',     'Adams/Gear')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     '10')
set_param(sys,'Min step size', '0.0001')
set_param(sys,'Max step size', '0.01')
set_param(sys,'Relative error','1e-6')
set_param(sys,'Return vars',   '')


%     Subsystem  'm3a'.

new_system([sys,'/','m3a'])
set_param([sys,'/','m3a'],'Location',[20,197,328,323])

add_block('built-in/Note',[sys,'/',['m3a/Uses m3a.m to initialize and plot',13,'results of S3.m']])
set_param([sys,'/',['m3a/Uses m3a.m to initialize and plot',13,'results of S3.m']],...
		'position',[150,45,155,50])
set_param([sys,'/','m3a'],...
		'Mask Display','Initialize\nand plot',...
		'Mask Type','Masked block of m3a.m',...
		'Mask Dialogue','eval(''m3a'')',...
		'Mask Help','Uses m3a.m to initialize and plot')


%     Finished composite block 'm3a'.

set_param([sys,'/','m3a'],...
		'Drop Shadow',4,...
		'position',[95,20,168,50])

add_block('built-in/Note',[sys,'/','Ea'])
set_param([sys,'/','Ea'],...
		'position',[195,46,200,51])

add_block('built-in/Gain',[sys,'/','Rext'])
set_param([sys,'/','Rext'],...
		'orientation',2,...
		'Gain','Rext',...
		'position',[190,245,250,275])

add_block('built-in/Fcn',[sys,'/','Tload'])
set_param([sys,'/','Tload'],...
		'orientation',2,...
		'Expr','0.01 + 3.189e-4*u[1]^2',...
		'position',[450,178,605,202])

add_block('built-in/Note',[sys,'/','wm'])
set_param([sys,'/','wm'],...
		'position',[605,115,610,120])

add_block('built-in/Integrator',[sys,'/','Integrator2'])
set_param([sys,'/','Integrator2'],...
		'Initial','wmrated',...
		'position',[565,122,595,158])

add_block('built-in/Gain',[sys,'/','1//J'])
set_param([sys,'/','1//J'],...
		'Gain','1/J',...
		'position',[495,119,540,161])

add_block('built-in/Sum',[sys,'/','Sum2'])
set_param([sys,'/','Sum2'],...
		'inputs','+-',...
		'position',[450,114,465,161])

add_block('built-in/Switch',[sys,'/','C1'])
set_param([sys,'/','C1'],...
		'orientation',2,...
		'Threshold','0.5',...
		'position',[105,208,125,272])

add_block('built-in/Gain',[sys,'/','Ra'])
set_param([sys,'/','Ra'],...
		'orientation',2,...
		'Gain','Ra',...
		'position',[220,173,255,207])

add_block('built-in/Note',[sys,'/','Tem'])
set_param([sys,'/','Tem'],...
		'position',[410,105,415,110])

add_block('built-in/Integrator',[sys,'/','Integrator'])
set_param([sys,'/','Integrator'],...
		'Initial','Iarated',...
		'position',[245,112,275,148])

add_block('built-in/Sum',[sys,'/','Sum'])
set_param([sys,'/','Sum'],...
		'inputs','-+--',...
		'position',[120,90,135,170])

add_block('built-in/Gain',[sys,'/','1//Laq'])
set_param([sys,'/','1//Laq'],...
		'Gain','1/Laq',...
		'position',[170,109,215,151])

add_block('built-in/Note',[sys,'/','Ia'])
set_param([sys,'/','Ia'],...
		'position',[305,110,310,115])


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
		'position',[375,106,390,139])

add_block('built-in/Scope',[sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'orientation',2,...
		'Vgain','300.000000',...
		'Hgain','10.000000',...
		'Vmax','600.000000',...
		'Hmax','20.000000',...
		'Window',[48,465,782,629])
open_system([sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'position',[500,324,520,346])

add_block('built-in/To Workspace',[sys,'/','To Workspace'])
set_param([sys,'/','To Workspace'],...
		'mat-name','y',...
		'position',[580,324,630,346])

add_block('built-in/Clock',[sys,'/','Clock'])
set_param([sys,'/','Clock'],...
		'orientation',1,...
		'position',[416,250,434,265])

add_block('built-in/Constant',[sys,'/','Va_motoring'])
set_param([sys,'/','Va_motoring'],...
		'orientation',2,...
		'Value','Vrated',...
		'position',[170,303,250,317])

add_block('built-in/Step Fcn',[sys,'/',['Timing',13,'motoring2braking']])
set_param([sys,'/',['Timing',13,'motoring2braking']],...
		'orientation',2,...
		'Before','1',...
		'After','0',...
		'position',[305,319,340,341])

add_block('built-in/Mux',[sys,'/','Mux'])
set_param([sys,'/','Mux'],...
		'orientation',1,...
		'inputs','5',...
		'position',[397,280,673,300])


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
		'position',[240,50,260,90])

add_block('built-in/Constant',[sys,'/','kaphi'])
set_param([sys,'/','kaphi'],...
		'orientation',2,...
		'Value','0.6699',...
		'position',[365,69,415,91])

add_block('built-in/Switch',[sys,'/','C2'])
set_param([sys,'/','C2'],...
		'orientation',2,...
		'Threshold','0.5',...
		'position',[105,296,125,364])

add_block('built-in/Constant',[sys,'/','Va_braking'])
set_param([sys,'/','Va_braking'],...
		'orientation',2,...
		'Value','Vbrake',...
		'position',[170,343,250,357])
add_line(sys,[140,130;165,130])
add_line(sys,[470,140;490,140])
add_line(sys,[545,140;560,140])
add_line(sys,[280,130;370,130])
add_line(sys,[360,80;265,80])
add_line(sys,[235,70;80,70;80,100;115,100])
add_line(sys,[220,130;240,130])
add_line(sys,[280,130;310,130;310,190;260,190])
add_line(sys,[535,305;535,335;575,335])
add_line(sys,[535,305;525,335])
add_line(sys,[425,270;425,275])
add_line(sys,[185,260;130,260])
add_line(sys,[310,189;310,260;255,260])
add_line(sys,[360,80;345,80;345,115;370,115])
add_line(sys,[215,190;95,190;95,160;115,160])
add_line(sys,[100,240;85,240;85,140;115,140])
add_line(sys,[165,310;130,310])
add_line(sys,[165,350;130,350])
add_line(sys,[100,330;75,330;75,120;115,120])
add_line(sys,[300,330;130,330])
add_line(sys,[600,140;625,140;625,60;265,60])
add_line(sys,[235,70;225,70;225,35;645,35;645,275])
add_line(sys,[600,140;625,140;625,245;590,245;590,275])
add_line(sys,[395,125;410,125;410,230;535,230;535,275])
add_line(sys,[280,130;310,130;310,240;480,240;480,275])
add_line(sys,[300,330;285,330;285,240;130,240])
add_line(sys,[395,125;445,125])
add_line(sys,[445,190;425,190;425,150;445,150])
add_line(sys,[600,140;625,140;625,190;610,190])

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
