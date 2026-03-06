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
     set_param(sys,'Location',[34,70,783,544])
     open_system(sys)
end;
set_param(sys,'algorithm',     'Adams/Gear')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     '2')
set_param(sys,'Min step size', '5e-5')
set_param(sys,'Max step size', '1e-3')
set_param(sys,'Relative error','1e-6')
set_param(sys,'Return vars',   '')
set_param(sys,'AssignWideVectorLines','on');

add_block('built-in/Gain',[sys,'/','Field _cct_resis'])
set_param([sys,'/','Field _cct_resis'],...
		'orientation',2,...
		'Gain','Rf+ Rrh',...
		'position',[145,35,220,75])

add_block('built-in/Gain',[sys,'/',['Field',13,'Polarity']])
set_param([sys,'/',['Field',13,'Polarity']],...
		'orientation',3,...
		'position',[37,135,73,165])

add_block('built-in/Sum',[sys,'/','Sum'])
set_param([sys,'/','Sum'],...
		'inputs','-+',...
		'position',[125,96,145,134])

add_block('built-in/Gain',[sys,'/','1//Lf'])
set_param([sys,'/','1//Lf'],...
		'Gain','1/Lf',...
		'position',[165,98,200,132])

add_block('built-in/Integrator',[sys,'/','If'])
set_param([sys,'/','If'],...
		'position',[220,99,250,131])

add_block('built-in/Note',[sys,'/','if'])
set_param([sys,'/','if'],...
		'position',[280,95,285,100])

add_block('built-in/Gain',[sys,'/','1//wmo'])
set_param([sys,'/','1//wmo'],...
		'Gain','1/wmo',...
		'position',[445,104,495,146])

add_block('built-in/Note',[sys,'/',['Eao//wmo',13,'(or ka phi)']])
set_param([sys,'/',['Eao//wmo',13,'(or ka phi)']],...
		'position',[515,81,520,86])

add_block('built-in/Note',[sys,'/','wm'])
set_param([sys,'/','wm'],...
		'position',[85,280,90,285])

add_block('built-in/Constant',[sys,'/','wm_'])
set_param([sys,'/','wm_'],...
		'Value','wmrated',...
		'position',[20,291,75,309])


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
		'position',[115,275,135,310])

add_block('built-in/Note',[sys,'/','Ea'])
set_param([sys,'/','Ea'],...
		'position',[155,270,160,275])

add_block('built-in/Integrator',[sys,'/','Ia_'])
set_param([sys,'/','Ia_'],...
		'position',[330,301,365,339])

add_block('built-in/Gain',[sys,'/','1//Laq'])
set_param([sys,'/','1//Laq'],...
		'Gain','1/Laq ',...
		'position',[250,297,295,343])

add_block('built-in/Sum',[sys,'/','Sum1'])
set_param([sys,'/','Sum1'],...
		'inputs','+---',...
		'position',[205,290,220,345])

add_block('built-in/Relay',[sys,'/','brush drop'])
set_param([sys,'/','brush drop'],...
		'orientation',2,...
		'On_output_value','2',...
		'Off_output_value','-2',...
		'position',[215,365,260,395])

add_block('built-in/Gain',[sys,'/','IaRa drop'])
set_param([sys,'/','IaRa drop'],...
		'orientation',2,...
		'Gain','Ra',...
		'position',[290,396,340,434])

add_block('built-in/Look Up Table',[sys,'/','Armature Reaction'])
set_param([sys,'/','Armature Reaction'],...
		'orientation',2,...
		'Input_Values','Ia',...
		'Output_Values','Iar',...
		'position',[270,217,365,263])

add_block('built-in/Note',[sys,'/','Ia'])
set_param([sys,'/','Ia'],...
		'position',[405,285,410,290])

add_block('built-in/Sum',[sys,'/','Sum2'])
set_param([sys,'/','Sum2'],...
		'inputs','+-',...
		'position',[300,106,320,144])

add_block('built-in/Look Up Table',[sys,'/','Mag_curve'])
set_param([sys,'/','Mag_curve'],...
		'Input_Values','SHIP1',...
		'Output_Values','SHVP1',...
		'position',[350,100,425,150])

add_block('built-in/Note',[sys,'/','ifeq'])
set_param([sys,'/','ifeq'],...
		'position',[330,95,335,100])

add_block('built-in/Gain',[sys,'/','Ext_load'])
set_param([sys,'/','Ext_load'],...
		'Gain','Rload',...
		'position',[435,336,510,374])


%     Subsystem  '-Tem'.

new_system([sys,'/','-Tem'])
set_param([sys,'/','-Tem'],'Location',[33,479,253,634])

add_block('built-in/Product',[sys,'/','-Tem/Product'])
set_param([sys,'/','-Tem/Product'],...
		'position',[65,55,90,75])

add_block('built-in/Sum',[sys,'/','-Tem/Sum'])
set_param([sys,'/','-Tem/Sum'],...
		'inputs','+',...
		'position',[125,55,145,75])

add_block('built-in/Outport',[sys,'/','-Tem/out_1'])
set_param([sys,'/','-Tem/out_1'],...
		'position',[185,55,205,75])

add_block('built-in/Inport',[sys,'/','-Tem/in_2'])
set_param([sys,'/','-Tem/in_2'],...
		'Port','2',...
		'position',[15,90,35,110])

add_block('built-in/Inport',[sys,'/','-Tem/in_1'])
set_param([sys,'/','-Tem/in_1'],...
		'position',[15,25,35,45])
add_line([sys,'/','-Tem'],[40,100;60,70])
add_line([sys,'/','-Tem'],[40,35;60,60])
add_line([sys,'/','-Tem'],[95,65;120,65])
add_line([sys,'/','-Tem'],[150,65;180,65])
set_param([sys,'/','-Tem'],...
		'Mask Display','.\n',...
		'Mask Type','Dot Product',...
		'Mask Dialogue','Inner (dot) product.\ny=sum(u1.*u2)')
set_param([sys,'/','-Tem'],...
		'Mask Help','Computes the inner (dot) product of the inputs: sum(u1.*u2).  The inputs are vectors of the same length. Output is a scalar.')


%     Finished composite block '-Tem'.

set_param([sys,'/','-Tem'],...
		'position',[540,270,570,310])

add_block('built-in/Clock',[sys,'/','Clock'])
set_param([sys,'/','Clock'],...
		'position',[570,100,590,120])

add_block('built-in/Mux',[sys,'/','Mux'])
set_param([sys,'/','Mux'],...
		'inputs','6',...
		'position',[610,93,640,352])

add_block('built-in/Note',[sys,'/','Va'])
set_param([sys,'/','Va'],...
		'position',[590,340,595,345])

add_block('built-in/To Workspace',[sys,'/','To Workspace'])
set_param([sys,'/','To Workspace'],...
		'mat-name','y',...
		'buffer','5000',...
		'position',[665,152,715,168])

add_block('built-in/Scope',[sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'Vgain','150.000000',...
		'Hgain','2.000000',...
		'Vmax','300.000000',...
		'Hmax','4.000000',...
		'Window',[46,434,808,625])
open_system([sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'position',[680,210,705,240])


%     Subsystem  'm1'.

new_system([sys,'/','m1'])
set_param([sys,'/','m1'],'Location',[570,4719130,685,4719215])

add_block('built-in/Note',[sys,'/',['m1/Masked block of m1.m in Chapter 8',13,'to initialize s1.m and plot results']])
set_param([sys,'/',['m1/Masked block of m1.m in Chapter 8',13,'to initialize s1.m and plot results']],...
		'position',[75,45,80,50])
set_param([sys,'/','m1'],...
		'Mask Display','Initialize\nand plot',...
		'Mask Type','Masked block of m1.m',...
		'Mask Dialogue','eval(''m1'')',...
		'Mask Help','Uses m1.m to initialize and plot')


%     Finished composite block 'm1'.

set_param([sys,'/','m1'],...
		'Drop Shadow',4,...
		'position',[622,35,705,72])
add_line(sys,[150,115;160,115])
add_line(sys,[205,115;215,115])
add_line(sys,[430,125;440,125])
add_line(sys,[225,320;245,320])
add_line(sys,[300,320;325,320])
add_line(sys,[500,125;525,125;525,175;100,175;110,285])
add_line(sys,[595,110;605,110])
add_line(sys,[575,290;605,290])
add_line(sys,[645,225;675,225])
add_line(sys,[80,300;110,300])
add_line(sys,[140,55;85,55;85,105;120,105])
add_line(sys,[55,130;55,125;120,125])
add_line(sys,[370,320;390,320;390,415;345,415])
add_line(sys,[370,320;520,320;520,300;535,300])
add_line(sys,[500,125;525,125;535,280])
add_line(sys,[140,295;145,295;145,215;55,215;55,170])
add_line(sys,[370,320;390,320;390,240;370,240])
add_line(sys,[140,295;145,295;145,200;605,200])
add_line(sys,[370,320;390,320;390,245;605,245])
add_line(sys,[255,115;295,115])
add_line(sys,[325,125;345,125])
add_line(sys,[265,240;255,240;255,135;295,135])
add_line(sys,[255,115;265,115;265,55;225,55])
add_line(sys,[255,115;265,115;265,55;560,55;560,155;605,155])
add_line(sys,[370,320;390,320;390,380;265,380])
add_line(sys,[140,295;200,295])
add_line(sys,[210,380;180,380;180,340;200,340])
add_line(sys,[285,415;170,415;170,325;200,325])
add_line(sys,[370,320;390,320;390,355;430,355])
add_line(sys,[515,355;545,355;545,335;605,335])
add_line(sys,[515,355;545,355;545,455;160,455;160,310;200,310])
add_line(sys,[645,225;650,225;660,160])

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
