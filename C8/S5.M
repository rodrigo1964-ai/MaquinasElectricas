function [ret,x0,str,ts,xts]=s5(t,x,u,flag);
%s5	is the M-file description of the SIMULINK system named s5.
%	The block-diagram can be displayed by typing: s5.
%
%	SYS=s5(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes s5 to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling s5 with a FLAG of zero:
%	[SIZES]=s5([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[22,55,705,513])
     open_system(sys)
end;
set_param(sys,'algorithm',     'Adams/Gear')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     '35')
set_param(sys,'Min step size', '0.001')
set_param(sys,'Max step size', '0.05')
set_param(sys,'Relative error','1e-6')
set_param(sys,'Return vars',   '')

add_block('built-in/Mux',[sys,'/','Mux'])
set_param([sys,'/','Mux'],...
		'orientation',3,...
		'inputs','5',...
		'position',[194,80,636,100])

add_block('built-in/Constant',[sys,'/','Va_braking'])
set_param([sys,'/','Va_braking'],...
		'Value','Vbrake',...
		'position',[40,291,110,309])

add_block('built-in/Constant',[sys,'/','Va_motoring'])
set_param([sys,'/','Va_motoring'],...
		'Value','Vmotor',...
		'position',[40,256,115,274])

add_block('built-in/Switch',[sys,'/','Va'])
set_param([sys,'/','Va'],...
		'Threshold','0.5',...
		'position',[160,257,175,293])

add_block('built-in/Switch',[sys,'/','Rinsertion'])
set_param([sys,'/','Rinsertion'],...
		'Threshold','0.5',...
		'position',[170,333,185,367])

add_block('built-in/Step Fcn',[sys,'/','Switchover'])
set_param([sys,'/','Switchover'],...
		'Time','8',...
		'Before','1',...
		'After','0',...
		'position',[80,333,110,367])

add_block('built-in/Gain',[sys,'/','Rbrake'])
set_param([sys,'/','Rbrake'],...
		'orientation',2,...
		'Gain','Rbrake',...
		'position',[220,380,290,420])

add_block('built-in/Sum',[sys,'/','Sum'])
set_param([sys,'/','Sum'],...
		'inputs','-+--',...
		'position',[225,249,245,321])

add_block('built-in/Gain',[sys,'/','1//(Laq+Lse)'])
set_param([sys,'/','1//(Laq+Lse)'],...
		'Gain','1/(Laq+Lse)',...
		'position',[260,256,355,314])

add_block('built-in/Integrator',[sys,'/','Integrator'])
set_param([sys,'/','Integrator'],...
		'position',[370,269,405,301])

add_block('built-in/Note',[sys,'/','Ia'])
set_param([sys,'/','Ia'],...
		'position',[430,265,435,270])


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
		'position',[165,150,185,185])

add_block('built-in/Gain',[sys,'/','Ra+Rse'])
set_param([sys,'/','Ra+Rse'],...
		'orientation',2,...
		'Gain','Ra+Rse',...
		'position',[280,337,370,373])

add_block('built-in/Constant',[sys,'/','Tmech'])
set_param([sys,'/','Tmech'],...
		'orientation',2,...
		'Value','-Trated',...
		'position',[535,241,615,269])

add_block('built-in/Integrator',[sys,'/','Integrator2'])
set_param([sys,'/','Integrator2'],...
		'position',[610,184,640,216])

add_block('built-in/Gain',[sys,'/','1//J'])
set_param([sys,'/','1//J'],...
		'Gain','1/J',...
		'position',[545,179,590,221])

add_block('built-in/Sum',[sys,'/','Sum2'])
set_param([sys,'/','Sum2'],...
		'position',[505,172,520,223])

add_block('built-in/Note',[sys,'/','Tem'])
set_param([sys,'/','Tem'],...
		'position',[475,165,480,170])


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
		'position',[445,164,460,206])

add_block('built-in/To Workspace',[sys,'/','To Workspace'])
set_param([sys,'/','To Workspace'],...
		'mat-name','y',...
		'buffer','20000',...
		'position',[445,36,515,54])

add_block('built-in/Note',[sys,'/','kaphi'])
set_param([sys,'/','kaphi'],...
		'position',[190,205,195,210])

add_block('built-in/Note',[sys,'/','Ea'])
set_param([sys,'/','Ea'],...
		'position',[150,131,155,136])

add_block('built-in/Note',[sys,'/','wm'])
set_param([sys,'/','wm'],...
		'position',[660,195,665,200])

add_block('built-in/Look Up Table',[sys,'/','Mag_curve'])
set_param([sys,'/','Mag_curve'],...
		'orientation',2,...
		'Input_Values','SEIP5',...
		'Output_Values','SEVP5',...
		'position',[305,185,370,235])

add_block('built-in/Gain',[sys,'/','1//wmo'])
set_param([sys,'/','1//wmo'],...
		'orientation',2,...
		'Gain','1/wmo',...
		'position',[230,190,280,230])

add_block('built-in/Scope',[sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'orientation',2,...
		'Vgain','150.000000',...
		'Hgain','35.000000',...
		'Vmax','300.000000',...
		'Hmax','70.000000',...
		'Window',[31,445,730,636])
open_system([sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'position',[340,35,360,55])

add_block('built-in/Clock',[sys,'/','Clock'])
set_param([sys,'/','Clock'],...
		'orientation',1,...
		'position',[100,80,120,100])


%     Subsystem  'm5'.

new_system([sys,'/','m5'])
set_param([sys,'/','m5'],'Location',[420,453,705,574])

add_block('built-in/Note',[sys,'/',['m5/Uses m5.m to initialize s5.m',13,'and plot results ']])
set_param([sys,'/',['m5/Uses m5.m to initialize s5.m',13,'and plot results ']],...
		'position',[145,45,150,50])
set_param([sys,'/','m5'],...
		'Mask Display','Initialize\nand plot',...
		'Mask Type','Masked block of m5.m',...
		'Mask Dialogue','eval(''m5'')',...
		'Mask Help','Uses m5.m to initialize and plot')


%     Finished composite block 'm5'.

set_param([sys,'/','m5'],...
		'Drop Shadow',4,...
		'position',[510,314,589,355])
add_line(sys,[250,285;255,285])
add_line(sys,[525,200;540,200])
add_line(sys,[595,200;605,200])
add_line(sys,[160,170;135,170;135,255;220,255])
add_line(sys,[360,285;365,285])
add_line(sys,[410,285;415,285;415,355;375,355])
add_line(sys,[415,75;415,45;440,45])
add_line(sys,[415,75;415,45;365,45])
add_line(sys,[110,105;110,115;235,105])
add_line(sys,[300,210;285,210])
add_line(sys,[225,210;215,210;215,175;440,175])
add_line(sys,[530,255;490,255;500,210])
add_line(sys,[225,210;215,210;215,175;190,175])
add_line(sys,[160,170;135,170;135,125;325,125;325,105])
add_line(sys,[410,285;415,285;415,105])
add_line(sys,[410,285;415,285;415,210;375,210])
add_line(sys,[410,285;415,285;415,195;440,195])
add_line(sys,[465,185;500,185])
add_line(sys,[410,285;415,285;415,400;295,400])
add_line(sys,[115,350;165,350])
add_line(sys,[215,400;155,400;165,360])
add_line(sys,[645,200;650,200;650,160;190,160])
add_line(sys,[275,355;205,355;205,315;220,315])
add_line(sys,[190,350;200,350;200,295;220,295])
add_line(sys,[180,275;220,275])
add_line(sys,[120,265;155,265])
add_line(sys,[115,300;130,300;130,285;155,285])
add_line(sys,[155,350;120,350;120,275;155,275])
add_line(sys,[645,200;650,200;650,145;595,145;595,105])
add_line(sys,[465,185;465,140;505,140;505,105])

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
