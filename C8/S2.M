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
     set_param(sys,'Location',[63,66,783,583])
     open_system(sys)
end;
set_param(sys,'algorithm',     'Adams/Gear')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     '5')
set_param(sys,'Min step size', '0.0005')
set_param(sys,'Max step size', '0.005')
set_param(sys,'Relative error','1e-6')
set_param(sys,'Return vars',   '')

add_block('built-in/Constant',[sys,'/','Tmech'])
set_param([sys,'/','Tmech'],...
		'Value','0',...
		'position',[400,211,430,229])

add_block('built-in/Scope',[sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'Vgain','300.000000',...
		'Hgain','7.000000',...
		'Vmax','600.000000',...
		'Hmax','14.000000',...
		'Window',[29,451,808,625])
open_system([sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'position',[565,59,585,81])

add_block('built-in/To Workspace',[sys,'/','To Workspace'])
set_param([sys,'/','To Workspace'],...
		'mat-name','y',...
		'buffer','2000',...
		'position',[540,21,610,39])

add_block('built-in/Gain',[sys,'/','r2'])
set_param([sys,'/','r2'],...
		'orientation',2,...
		'Gain','0.523',...
		'position',[230,388,290,422])

add_block('built-in/Note',[sys,'/','wm'])
set_param([sys,'/','wm'],...
		'position',[635,165,640,170])

add_block('built-in/Clock',[sys,'/','Clock'])
set_param([sys,'/','Clock'],...
		'position',[240,65,260,85])

add_block('built-in/Mux',[sys,'/','Mux'])
set_param([sys,'/','Mux'],...
		'orientation',3,...
		'position',[279,40,481,60])

add_block('built-in/Gain',[sys,'/','D'])
set_param([sys,'/','D'],...
		'orientation',2,...
		'Gain','D',...
		'position',[505,125,560,155])

add_block('built-in/Constant',[sys,'/','kaphi'])
set_param([sys,'/','kaphi'],...
		'Value','1.3',...
		'position',[235,150,275,170])


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
		'position',[170,103,195,132])

add_block('built-in/Note',[sys,'/','Ea'])
set_param([sys,'/','Ea'],...
		'position',[140,91,145,96])


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
		'position',[355,181,380,219])

add_block('built-in/Integrator',[sys,'/','Integrator'])
set_param([sys,'/','Integrator'],...
		'position',[265,194,300,226])

add_block('built-in/Gain',[sys,'/','1//J'])
set_param([sys,'/','1//J'],...
		'Gain','1/J',...
		'position',[495,164,540,206])

add_block('built-in/Constant',[sys,'/','Vdc- Vbrush'])
set_param([sys,'/','Vdc- Vbrush'],...
		'Value','218',...
		'position',[35,155,70,185])

add_block('built-in/Memory',[sys,'/','Memory2'])
set_param([sys,'/','Memory2'],...
		'orientation',1,...
		'position',[602,415,628,435])

add_block('built-in/Gain',[sys,'/','1//Laq'])
set_param([sys,'/','1//Laq'],...
		'Gain','1/Laq',...
		'position',[180,189,225,231])

add_block('built-in/Logical Operator',[sys,'/','a1'])
set_param([sys,'/','a1'],...
		'orientation',2,...
		'Operator','AND',...
		'position',[465,432,500,463])

add_block('built-in/Note',[sys,'/','Tem'])
set_param([sys,'/','Tem'],...
		'position',[400,165,405,170])

add_block('built-in/Derivative',[sys,'/','Deriv'])
set_param([sys,'/','Deriv'],...
		'position',[510,243,550,277])

add_block('built-in/Relational Operator',[sys,'/','<=Iamin'])
set_param([sys,'/','<=Iamin'],...
		'Operator','<=',...
		'position',[410,254,435,281])

add_block('built-in/Logical Operator',[sys,'/','and'])
set_param([sys,'/','and'],...
		'Operator','AND',...
		'position',[455,240,480,280])


%     Subsystem  'Latch'.

new_system([sys,'/','Latch'])
set_param([sys,'/','Latch'],'Location',[102,336,551,502])

add_block('built-in/Fcn',[sys,'/','Latch/Fcn'])
set_param([sys,'/','Latch/Fcn'],...
		'orientation',2,...
		'Expr','u[1]>.2',...
		'position',[170,123,205,147])

add_block('built-in/Demux',[sys,'/','Latch/Demux'])
set_param([sys,'/','Latch/Demux'],...
		'outputs','2',...
		'position',[275,55,315,90])

add_block('built-in/Combinatorial Logic',[sys,'/','Latch/Logic'])
set_param([sys,'/','Latch/Logic'],...
		'Truth Table','[0 1;1 0;0 1;0 1;1 0;1 0;0 0;0 0]',...
		'position',[195,55,250,95])

add_block('built-in/Transport Delay',[sys,'/','Latch/Transport Delay'])
set_param([sys,'/','Latch/Transport Delay'],...
		'orientation',2,...
		'Initial Input','ini',...
		'position',[250,120,295,150])

add_block('built-in/Outport',[sys,'/','Latch/out_2'])
set_param([sys,'/','Latch/out_2'],...
		'Port','2',...
		'position',[395,70,415,90])

add_block('built-in/Outport',[sys,'/','Latch/out_1'])
set_param([sys,'/','Latch/out_1'],...
		'position',[355,55,375,75])

add_block('built-in/Mux',[sys,'/','Latch/Mux'])
set_param([sys,'/','Latch/Mux'],...
		'inputs','3',...
		'position',[135,59,165,91])

add_block('built-in/Inport',[sys,'/','Latch/in_1'])
set_param([sys,'/','Latch/in_1'],...
		'position',[20,50,40,70])

add_block('built-in/Inport',[sys,'/','Latch/in_2'])
set_param([sys,'/','Latch/in_2'],...
		'Port','2',...
		'position',[50,65,70,85])
add_line([sys,'/','Latch'],[320,65;350,65])
add_line([sys,'/','Latch'],[335,65;335,135;300,135])
add_line([sys,'/','Latch'],[165,135;110,135;110,85;130,85])
add_line([sys,'/','Latch'],[245,135;210,135])
add_line([sys,'/','Latch'],[75,75;130,75])
add_line([sys,'/','Latch'],[45,60;105,60;105,65;130,65])
add_line([sys,'/','Latch'],[170,75;190,75])
add_line([sys,'/','Latch'],[255,75;270,75])
add_line([sys,'/','Latch'],[320,80;390,80])
set_param([sys,'/','Latch'],...
		'Mask Display','S  1\n\nR  0',...
		'Mask Type','Latch',...
		'Mask Dialogue','Latch|Initial State for Output "1":',...
		'Mask Translate','ini=(@1~=0);')
set_param([sys,'/','Latch'],...
		'Mask Help','Latches the S input.  When S (set) is one, the uncomplemented output (1) becomes one.  The output remains one until the R (reset) input becomes one, forcing the output to zero.  If both R and S are one, the latch will be in an undefined state.')
set_param([sys,'/','Latch'],...
		'Mask Entries','0\/')


%     Finished composite block 'Latch'.

set_param([sys,'/','Latch'],...
		'position',[385,325,415,365])

add_block('built-in/Memory',[sys,'/','Memory1'])
set_param([sys,'/','Memory1'],...
		'position',[455,323,480,347])


%     Subsystem  'Latch1'.

new_system([sys,'/','Latch1'])
set_param([sys,'/','Latch1'],'Location',[102,336,551,502])

add_block('built-in/Fcn',[sys,'/','Latch1/Fcn'])
set_param([sys,'/','Latch1/Fcn'],...
		'orientation',2,...
		'Expr','u[1]>.2',...
		'position',[170,123,205,147])

add_block('built-in/Demux',[sys,'/','Latch1/Demux'])
set_param([sys,'/','Latch1/Demux'],...
		'outputs','2',...
		'position',[275,55,315,90])

add_block('built-in/Combinatorial Logic',[sys,'/','Latch1/Logic'])
set_param([sys,'/','Latch1/Logic'],...
		'Truth Table','[0 1;1 0;0 1;0 1;1 0;1 0;0 0;0 0]',...
		'position',[195,55,250,95])

add_block('built-in/Transport Delay',[sys,'/','Latch1/Transport Delay'])
set_param([sys,'/','Latch1/Transport Delay'],...
		'orientation',2,...
		'Initial Input','ini',...
		'position',[250,120,295,150])

add_block('built-in/Outport',[sys,'/','Latch1/out_2'])
set_param([sys,'/','Latch1/out_2'],...
		'Port','2',...
		'position',[395,70,415,90])

add_block('built-in/Outport',[sys,'/','Latch1/out_1'])
set_param([sys,'/','Latch1/out_1'],...
		'position',[355,55,375,75])

add_block('built-in/Mux',[sys,'/','Latch1/Mux'])
set_param([sys,'/','Latch1/Mux'],...
		'inputs','3',...
		'position',[135,59,165,91])

add_block('built-in/Inport',[sys,'/','Latch1/in_1'])
set_param([sys,'/','Latch1/in_1'],...
		'position',[20,50,40,70])

add_block('built-in/Inport',[sys,'/','Latch1/in_2'])
set_param([sys,'/','Latch1/in_2'],...
		'Port','2',...
		'position',[50,65,70,85])
add_line([sys,'/','Latch1'],[320,65;350,65])
add_line([sys,'/','Latch1'],[335,65;335,135;300,135])
add_line([sys,'/','Latch1'],[165,135;110,135;110,85;130,85])
add_line([sys,'/','Latch1'],[245,135;210,135])
add_line([sys,'/','Latch1'],[75,75;130,75])
add_line([sys,'/','Latch1'],[45,60;105,60;105,65;130,65])
add_line([sys,'/','Latch1'],[170,75;190,75])
add_line([sys,'/','Latch1'],[255,75;270,75])
add_line([sys,'/','Latch1'],[320,80;390,80])
set_param([sys,'/','Latch1'],...
		'Mask Display','S  1\n\nR  0',...
		'Mask Type','Latch',...
		'Mask Dialogue','Latch|Initial State for Output "1":',...
		'Mask Translate','ini=(@1~=0);')
set_param([sys,'/','Latch1'],...
		'Mask Help','Latches the S input.  When S (set) is one, the uncomplemented output (1) becomes one.  The output remains one until the R (reset) input becomes one, forcing the output to zero.  If both R and S are one, the latch will be in an undefined state.')
set_param([sys,'/','Latch1'],...
		'Mask Entries','0\/')


%     Finished composite block 'Latch1'.

set_param([sys,'/','Latch1'],...
		'position',[560,313,590,357])

add_block('built-in/Logical Operator',[sys,'/','a'])
set_param([sys,'/','a'],...
		'Operator','AND',...
		'position',[510,305,540,345])


%     Subsystem  'Latch2'.

new_system([sys,'/','Latch2'])
set_param([sys,'/','Latch2'],'Location',[102,336,551,502])

add_block('built-in/Fcn',[sys,'/','Latch2/Fcn'])
set_param([sys,'/','Latch2/Fcn'],...
		'orientation',2,...
		'Expr','u[1]>.2',...
		'position',[170,123,205,147])

add_block('built-in/Demux',[sys,'/','Latch2/Demux'])
set_param([sys,'/','Latch2/Demux'],...
		'outputs','2',...
		'position',[275,55,315,90])

add_block('built-in/Combinatorial Logic',[sys,'/','Latch2/Logic'])
set_param([sys,'/','Latch2/Logic'],...
		'Truth Table','[0 1;1 0;0 1;0 1;1 0;1 0;0 0;0 0]',...
		'position',[195,55,250,95])

add_block('built-in/Transport Delay',[sys,'/','Latch2/Transport Delay'])
set_param([sys,'/','Latch2/Transport Delay'],...
		'orientation',2,...
		'Initial Input','ini',...
		'position',[250,120,295,150])

add_block('built-in/Outport',[sys,'/','Latch2/out_2'])
set_param([sys,'/','Latch2/out_2'],...
		'Port','2',...
		'position',[395,70,415,90])

add_block('built-in/Outport',[sys,'/','Latch2/out_1'])
set_param([sys,'/','Latch2/out_1'],...
		'position',[355,55,375,75])

add_block('built-in/Mux',[sys,'/','Latch2/Mux'])
set_param([sys,'/','Latch2/Mux'],...
		'inputs','3',...
		'position',[135,59,165,91])

add_block('built-in/Inport',[sys,'/','Latch2/in_1'])
set_param([sys,'/','Latch2/in_1'],...
		'position',[20,50,40,70])

add_block('built-in/Inport',[sys,'/','Latch2/in_2'])
set_param([sys,'/','Latch2/in_2'],...
		'Port','2',...
		'position',[50,65,70,85])
add_line([sys,'/','Latch2'],[320,65;350,65])
add_line([sys,'/','Latch2'],[335,65;335,135;300,135])
add_line([sys,'/','Latch2'],[165,135;110,135;110,85;130,85])
add_line([sys,'/','Latch2'],[245,135;210,135])
add_line([sys,'/','Latch2'],[75,75;130,75])
add_line([sys,'/','Latch2'],[45,60;105,60;105,65;130,65])
add_line([sys,'/','Latch2'],[170,75;190,75])
add_line([sys,'/','Latch2'],[255,75;270,75])
add_line([sys,'/','Latch2'],[320,80;390,80])
set_param([sys,'/','Latch2'],...
		'Mask Display','S  1\n\nR  0',...
		'Mask Type','Latch',...
		'Mask Dialogue','Latch|Initial State for Output "1":',...
		'Mask Translate','ini=(@1~=0);')
set_param([sys,'/','Latch2'],...
		'Mask Help','Latches the S input.  When S (set) is one, the uncomplemented output (1) becomes one.  The output remains one until the R (reset) input becomes one, forcing the output to zero.  If both R and S are one, the latch will be in an undefined state.')
set_param([sys,'/','Latch2'],...
		'Mask Entries','0\/')


%     Finished composite block 'Latch2'.

set_param([sys,'/','Latch2'],...
		'orientation',2,...
		'position',[395,439,425,486])

add_block('built-in/Integrator',[sys,'/','Integrator2'])
set_param([sys,'/','Integrator2'],...
		'position',[565,169,595,201])

add_block('built-in/Sum',[sys,'/','Sum2'])
set_param([sys,'/','Sum2'],...
		'inputs','-++',...
		'position',[455,147,470,223])

add_block('built-in/Constant',[sys,'/','Iamin'])
set_param([sys,'/','Iamin'],...
		'Value','60',...
		'position',[350,266,380,284])

add_block('built-in/Relational Operator',[sys,'/','<0'])
set_param([sys,'/','<0'],...
		'Operator','<',...
		'position',[300,242,320,258])

add_block('built-in/Memory',[sys,'/','Memory'])
set_param([sys,'/','Memory'],...
		'position',[255,242,275,258])

add_block('built-in/Sum',[sys,'/','Sum'])
set_param([sys,'/','Sum'],...
		'inputs','-+----',...
		'position',[135,162,155,253])

add_block('built-in/Gain',[sys,'/','r3'])
set_param([sys,'/','r3'],...
		'orientation',2,...
		'Gain','0.313',...
		'position',[250,451,310,489])

add_block('built-in/Switch',[sys,'/','C3'])
set_param([sys,'/','C3'],...
		'orientation',2,...
		'Threshold','0.5',...
		'position',[195,418,220,482])

add_block('built-in/Switch',[sys,'/','C2'])
set_param([sys,'/','C2'],...
		'orientation',2,...
		'Threshold','0.5',...
		'position',[155,354,180,416])

add_block('built-in/Gain',[sys,'/','r1'])
set_param([sys,'/','r1'],...
		'orientation',2,...
		'Gain','0.872',...
		'position',[210,327,270,363])

add_block('built-in/Switch',[sys,'/','C1'])
set_param([sys,'/','C1'],...
		'orientation',2,...
		'Threshold','0.5',...
		'position',[115,295,140,355])

add_block('built-in/Note',[sys,'/','Ia'])
set_param([sys,'/','Ia'],...
		'position',[310,190,315,195])

add_block('built-in/Gain',[sys,'/','Ra'])
set_param([sys,'/','Ra'],...
		'orientation',2,...
		'Gain','Ra',...
		'position',[155,258,190,292])


%     Subsystem  'm2'.

new_system([sys,'/','m2'])
set_param([sys,'/','m2'],'Location',[110,5374099,224,5374175])

add_block('built-in/Note',[sys,'/',['m2/Masked block of m2.m in Chapter 8',13,'to initialize s2.m and plot results']])
set_param([sys,'/',['m2/Masked block of m2.m in Chapter 8',13,'to initialize s2.m and plot results']],...
		'position',[60,45,65,50])
set_param([sys,'/','m2'],...
		'Mask Display','Initialize\nand plot',...
		'Mask Type','Masked block of m2.m',...
		'Mask Dialogue','eval(''m2'')',...
		'Mask Help','Uses m2.m to initialize and plot')


%     Finished composite block 'm2'.

set_param([sys,'/','m2'],...
		'Drop Shadow',4,...
		'position',[82,30,150,68])
add_line(sys,[160,210;175,210])
add_line(sys,[475,185;490,185])
add_line(sys,[545,185;560,185])
add_line(sys,[600,185;620,185;620,110;200,110])
add_line(sys,[305,210;350,210])
add_line(sys,[280,160;305,160;305,125;200,125])
add_line(sys,[280,160;305,160;305,190;350,190])
add_line(sys,[165,120;105,120;105,170;130,170])
add_line(sys,[500,140;422,140;422,160;450,160])
add_line(sys,[620,110;620,140;565,140])
add_line(sys,[230,210;260,210])
add_line(sys,[75,170;95,170;95,185;130,185])
add_line(sys,[305,210;340,210;340,275;195,275])
add_line(sys,[150,275;120,275;130,245])
add_line(sys,[385,200;415,200;415,185;450,185])
add_line(sys,[435,220;435,210;450,210])
add_line(sys,[380,35;380,30;535,30])
add_line(sys,[380,35;380,30;515,30;515,70;560,70])
add_line(sys,[265,75;305,65])
add_line(sys,[165,120;155,120;155,85;355,85;355,65])
add_line(sys,[325,210;325,95;405,95;405,65])
add_line(sys,[340,259;340,260;405,260])
add_line(sys,[340,260;340,470;315,470])
add_line(sys,[190,450;90,450;90,200;130,200])
add_line(sys,[150,385;95,385;95,215;130,215])
add_line(sys,[110,325;100,325;100,230;130,230])
add_line(sys,[385,275;405,275])
add_line(sys,[205,345;145,345])
add_line(sys,[225,405;185,405])
add_line(sys,[245,470;225,470])
add_line(sys,[230,210;240,210;250,250])
add_line(sys,[280,250;280,250;280,245;295,245])
add_line(sys,[325,250;450,250])
add_line(sys,[440,270;450,270])
add_line(sys,[485,260;505,260])
add_line(sys,[555,260;565,260;565,300;365,300;365,335;380,335])
add_line(sys,[545,325;555,325])
add_line(sys,[420,335;430,335;430,310;155,310;145,325])
add_line(sys,[420,335;450,335])
add_line(sys,[485,335;505,335])
add_line(sys,[595,325;615,325;615,410])
add_line(sys,[460,450;430,450])
add_line(sys,[390,450;225,450])
add_line(sys,[340,345;275,345])
add_line(sys,[340,410;340,405;295,405])
add_line(sys,[615,440;505,440])
add_line(sys,[555,260;635,260;635,455;505,455])
add_line(sys,[615,390;615,385;185,385])
add_line(sys,[485,300;485,315;505,315])
add_line(sys,[600,185;620,185;620,110;455,110;455,65])

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
