function [ret,x0,str,ts,xts]=s4(t,x,u,flag);
%s4	is the M-file description of the SIMULINK system named s4.
%	s4 has a the following characteristics:
%		2 continuous states
%		0 discrete states
%		0 outputs
%		0 inputs
%		does not have direct feedthrough
%		1 sample times
%
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
     set_param(sys,'Location',[30,55,708,444])
     open_system(sys)
end;
set_param(sys,'algorithm',     'Adams/Gear')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     '2.5')
set_param(sys,'Min step size', '0.0005')
set_param(sys,'Max step size', '0.005')
set_param(sys,'Relative error','1e-6')
set_param(sys,'Return vars',   '')

add_block('built-in/Constant',[sys,'/','dc_supply'])
set_param([sys,'/','dc_supply'],...
		'Value','120',...
		'position',[45,300,85,330])

add_block('built-in/Sine Wave',[sys,'/','ac_supply'])
set_param([sys,'/','ac_supply'],...
		'amplitude','120*sqrt(2)',...
		'frequency','377',...
		'position',[45,209,80,241])

add_block('built-in/Switch',[sys,'/','Switch'])
set_param([sys,'/','Switch'],...
		'Threshold','0.5',...
		'position',[120,258,140,292])

add_block('built-in/Constant',[sys,'/','Sw'])
set_param([sys,'/','Sw'],...
		'Value','Sw4AC',...
		'position',[40,264,90,286])

add_block('built-in/Note',[sys,'/','Ia'])
set_param([sys,'/','Ia'],...
		'position',[415,260,420,265])

add_block('built-in/Clock',[sys,'/','Clock'])
set_param([sys,'/','Clock'],...
		'orientation',1,...
		'position',[100,85,120,105])

add_block('built-in/Mux',[sys,'/','Mux'])
set_param([sys,'/','Mux'],...
		'orientation',3,...
		'inputs','6',...
		'position',[166,80,569,95])

add_block('built-in/Note',[sys,'/','kaphi'])
set_param([sys,'/','kaphi'],...
		'position',[205,195,210,200])

add_block('built-in/Note',[sys,'/','Ea'])
set_param([sys,'/','Ea'],...
		'position',[170,141,175,146])


%     Subsystem  'Ea_'.

new_system([sys,'/','Ea_'])
set_param([sys,'/','Ea_'],'Location',[33,479,253,634])

add_block('built-in/Product',[sys,'/','Ea_/Product'])
set_param([sys,'/','Ea_/Product'],...
		'position',[65,55,90,75])

add_block('built-in/Sum',[sys,'/','Ea_/Sum'])
set_param([sys,'/','Ea_/Sum'],...
		'inputs','+',...
		'position',[125,55,145,75])

add_block('built-in/Outport',[sys,'/','Ea_/out_1'])
set_param([sys,'/','Ea_/out_1'],...
		'position',[185,55,205,75])

add_block('built-in/Inport',[sys,'/','Ea_/in_2'])
set_param([sys,'/','Ea_/in_2'],...
		'Port','2',...
		'position',[15,90,35,110])

add_block('built-in/Inport',[sys,'/','Ea_/in_1'])
set_param([sys,'/','Ea_/in_1'],...
		'position',[15,25,35,45])
add_line([sys,'/','Ea_'],[40,100;60,70])
add_line([sys,'/','Ea_'],[40,35;60,60])
add_line([sys,'/','Ea_'],[95,65;120,65])
add_line([sys,'/','Ea_'],[150,65;180,65])
set_param([sys,'/','Ea_'],...
		'Mask Display','.\n',...
		'Mask Type','Dot Product',...
		'Mask Dialogue','Inner (dot) product.\ny=sum(u1.*u2)')
set_param([sys,'/','Ea_'],...
		'Mask Help','Computes the inner (dot) product of the inputs: sum(u1.*u2).  The inputs are vectors of the same length. Output is a scalar.')


%     Finished composite block 'Ea_'.

set_param([sys,'/','Ea_'],...
		'orientation',2,...
		'position',[195,140,215,175])

add_block('built-in/Gain',[sys,'/','1//wmo'])
set_param([sys,'/','1//wmo'],...
		'orientation',2,...
		'Gain','1/wmo',...
		'position',[240,180,290,220])

add_block('built-in/Look Up Table',[sys,'/','Mag_curve'])
set_param([sys,'/','Mag_curve'],...
		'orientation',2,...
		'Input_Values','SEIP4',...
		'Output_Values','SEVP4',...
		'position',[305,175,370,225])

add_block('built-in/Gain',[sys,'/','Ra+Rse'])
set_param([sys,'/','Ra+Rse'],...
		'orientation',2,...
		'Gain','Ra+Rse',...
		'position',[265,327,355,363])

add_block('built-in/Gain',[sys,'/','1//(Laq+Lse)'])
set_param([sys,'/','1//(Laq+Lse)'],...
		'Gain','1/(Laq+Lse)',...
		'position',[225,250,325,300])

add_block('built-in/Sum',[sys,'/','Sum'])
set_param([sys,'/','Sum'],...
		'inputs','-+-',...
		'position',[185,239,205,311])

add_block('built-in/Integrator',[sys,'/','Integrator'])
set_param([sys,'/','Integrator'],...
		'position',[345,259,380,291])

add_block('built-in/Integrator',[sys,'/','Integrator2'])
set_param([sys,'/','Integrator2'],...
		'Initial','wm0',...
		'position',[595,174,625,206])

add_block('built-in/Gain',[sys,'/','1//J'])
set_param([sys,'/','1//J'],...
		'Gain','1/J',...
		'position',[530,169,575,211])

add_block('built-in/Sum',[sys,'/','Sum2'])
set_param([sys,'/','Sum2'],...
		'position',[490,162,505,213])

add_block('built-in/Note',[sys,'/','Tem'])
set_param([sys,'/','Tem'],...
		'position',[460,155,465,160])


%     Subsystem  'Product'.

new_system([sys,'/','Product'])
set_param([sys,'/','Product'],'Location',[33,479,253,634])

add_block('built-in/Product',[sys,'/','Product/Product'])
set_param([sys,'/','Product/Product'],...
		'position',[65,55,90,75])

add_block('built-in/Sum',[sys,'/','Product/Sum'])
set_param([sys,'/','Product/Sum'],...
		'inputs','+',...
		'position',[125,55,145,75])

add_block('built-in/Outport',[sys,'/','Product/out_1'])
set_param([sys,'/','Product/out_1'],...
		'position',[185,55,205,75])

add_block('built-in/Inport',[sys,'/','Product/in_2'])
set_param([sys,'/','Product/in_2'],...
		'Port','2',...
		'position',[15,90,35,110])

add_block('built-in/Inport',[sys,'/','Product/in_1'])
set_param([sys,'/','Product/in_1'],...
		'position',[15,25,35,45])
add_line([sys,'/','Product'],[40,100;60,70])
add_line([sys,'/','Product'],[40,35;60,60])
add_line([sys,'/','Product'],[95,65;120,65])
add_line([sys,'/','Product'],[150,65;180,65])
set_param([sys,'/','Product'],...
		'Mask Display','.\n',...
		'Mask Type','Dot Product',...
		'Mask Dialogue','Inner (dot) product.\ny=sum(u1.*u2)')
set_param([sys,'/','Product'],...
		'Mask Help','Computes the inner (dot) product of the inputs: sum(u1.*u2).  The inputs are vectors of the same length. Output is a scalar.')


%     Finished composite block 'Product'.

set_param([sys,'/','Product'],...
		'position',[430,154,445,196])

add_block('built-in/Note',[sys,'/','wm'])
set_param([sys,'/','wm'],...
		'position',[645,185,650,190])

add_block('built-in/To Workspace',[sys,'/','To Workspace'])
set_param([sys,'/','To Workspace'],...
		'mat-name','y',...
		'buffer','12000',...
		'position',[430,36,500,54])

add_block('built-in/Scope',[sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'orientation',2,...
		'Vgain','150.000000',...
		'Hgain','2.000000',...
		'Vmax','300.000000',...
		'Hmax','4.000000',...
		'Window',[42,440,723,654])
open_system([sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'position',[245,35,265,55])

add_block('built-in/Step Fcn',[sys,'/','Tmech'])
set_param([sys,'/','Tmech'],...
		'orientation',2,...
		'Time','0.5',...
		'Before','-1',...
		'After','-0.5',...
		'position',[490,233,540,257])


%     Subsystem  'm4'.

new_system([sys,'/','m4'])
set_param([sys,'/','m4'],'Location',[450,4260301,601,4260399])

add_block('built-in/Note',[sys,'/',['m4/Masked block of m4.m to initialize',13,'s4.m in Chapter 8 and to plot results']])
set_param([sys,'/',['m4/Masked block of m4.m to initialize',13,'s4.m in Chapter 8 and to plot results']],...
		'position',[75,60,80,65])
set_param([sys,'/','m4'],...
		'Mask Display','Initialize\nand plot',...
		'Mask Type','Masked block of m4.m',...
		'Mask Dialogue','eval(''m4'')',...
		'Mask Help','Uses m4.m to initialize and plot')


%     Finished composite block 'm4'.

set_param([sys,'/','m4'],...
		'Drop Shadow',4,...
		'position',[464,292,545,334])
add_line(sys,[210,275;220,275])
add_line(sys,[510,190;525,190])
add_line(sys,[580,190;590,190])
add_line(sys,[630,190;635,190;635,150;220,150])
add_line(sys,[190,160;160,160;160,250;180,250])
add_line(sys,[330,275;340,275])
add_line(sys,[385,275;400,275;400,345;360,345])
add_line(sys,[370,75;370,45;425,45])
add_line(sys,[370,75;370,45;270,45])
add_line(sys,[110,110;205,100])
add_line(sys,[300,200;295,200])
add_line(sys,[235,200;235,165;425,165])
add_line(sys,[235,200;235,165;220,165])
add_line(sys,[385,275;400,275;400,185;425,185])
add_line(sys,[260,345;170,345;180,300])
add_line(sys,[450,175;485,175])
add_line(sys,[630,190;635,190;635,150;530,150;530,100])
add_line(sys,[450,175;465,175;465,100])
add_line(sys,[385,275;400,275;400,100])
add_line(sys,[190,160;190,130;335,130;335,100])
add_line(sys,[385,275;400,275;400,200;375,200])
add_line(sys,[145,275;180,275])
add_line(sys,[85,225;95,225;95,265;115,265])
add_line(sys,[95,275;115,275])
add_line(sys,[90,315;105,315;115,285])
add_line(sys,[485,245;465,245;465,200;485,200])
add_line(sys,[145,275;145,120;270,120;270,100])

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
