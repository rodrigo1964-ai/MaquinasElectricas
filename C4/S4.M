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
     set_param(sys,'Location',[148,97,927,648])
     open_system(sys)
end;
set_param(sys,'algorithm',     'Adams/Gear')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     'tstop')
set_param(sys,'Min step size', '2e-4')
set_param(sys,'Max step size', '1e-2')
set_param(sys,'Relative error','2e-6')
set_param(sys,'Return vars',   '')

add_block('built-in/Note',[sys,'/','vCA'])
set_param([sys,'/','vCA'],...
		'position',[250,395,255,400])

add_block('built-in/Sine Wave',[sys,'/','vBO'])
set_param([sys,'/','vBO'],...
		'amplitude','169.7/sqrt(3)',...
		'frequency','120*pi',...
		'phase','-2*pi/3',...
		'position',[95,259,125,291])

add_block('built-in/Sine Wave',[sys,'/','vCO'])
set_param([sys,'/','vCO'],...
		'amplitude','169.7/sqrt(3)',...
		'frequency','120*pi',...
		'phase','-4*pi/3',...
		'position',[100,388,130,422])

add_block('built-in/Note',[sys,'/',['i''a']])
set_param([sys,'/',['i''a']],...
		'position',[370,195,375,200])

add_block('built-in/Mux',[sys,'/','Mux'])
set_param([sys,'/','Mux'],...
		'orientation',3,...
		'inputs','8',...
		'position',[166,60,564,75])


%     Subsystem  'ABan_unit'.

new_system([sys,'/','ABan_unit'])
set_param([sys,'/','ABan_unit'],'Location',[271,216,1084,635])

add_block('built-in/Fcn',[sys,'/','ABan_unit/Fcn2'])
set_param([sys,'/','ABan_unit/Fcn2'],...
		'Expr','wb*(u[2] -(rp2/xpl2)*(u[1]-u[3]))',...
		'position',[120,314,300,346])

add_block('built-in/Mux',[sys,'/','ABan_unit/Mux1'])
set_param([sys,'/','ABan_unit/Mux1'],...
		'inputs','3',...
		'position',[80,292,100,368])

add_block('built-in/Note',[sys,'/',['ABan_unit/i2''']])
set_param([sys,'/',['ABan_unit/i2''']],...
		'position',[575,322,580,327])

add_block('built-in/Integrator',[sys,'/',['ABan_unit/psi2''_']])
set_param([sys,'/',['ABan_unit/psi2''_']],...
		'Initial','Psip2o',...
		'position',[320,317,350,343])

add_block('built-in/Look Up Table',[sys,'/',['ABan_unit/Look-Up',13,'Table']])
set_param([sys,'/',['ABan_unit/Look-Up',13,'Table']],...
		'orientation',2,...
		'Input_Values','psisat',...
		'Output_Values','Dpsi',...
		'position',[550,258,610,292])

add_block('built-in/Memory',[sys,'/','ABan_unit/Memory'])
set_param([sys,'/','ABan_unit/Memory'],...
		'orientation',2,...
		'position',[480,263,505,287])

add_block('built-in/Note',[sys,'/','ABan_unit/Dpsi'])
set_param([sys,'/','ABan_unit/Dpsi'],...
		'orientation',2,...
		'position',[450,257,455,262])

add_block('built-in/Fcn',[sys,'/','ABan_unit/Fcn3'])
set_param([sys,'/','ABan_unit/Fcn3'],...
		'Expr','xM*(u[1]/xl1+u[2]/xpl2-u[3]/xm)',...
		'position',[440,206,615,244])

add_block('built-in/Mux',[sys,'/','ABan_unit/Mux3'])
set_param([sys,'/','ABan_unit/Mux3'],...
		'inputs','3',...
		'position',[405,193,420,257])

add_block('built-in/Note',[sys,'/','ABan_unit/psim'])
set_param([sys,'/','ABan_unit/psim'],...
		'position',[640,200,645,205])

add_block('built-in/Note',[sys,'/',['ABan_unit/psi2''']])
set_param([sys,'/',['ABan_unit/psi2''']],...
		'position',[360,306,365,311])

add_block('built-in/Note',[sys,'/','ABan_unit/psi1'])
set_param([sys,'/','ABan_unit/psi1'],...
		'position',[355,125,360,130])

add_block('built-in/Integrator',[sys,'/','ABan_unit/psi1_'])
set_param([sys,'/','ABan_unit/psi1_'],...
		'Initial','Psi1o',...
		'position',[310,137,340,163])

add_block('built-in/Note',[sys,'/','ABan_unit/i1'])
set_param([sys,'/','ABan_unit/i1'],...
		'position',[575,120,580,125])

add_block('built-in/Fcn',[sys,'/','ABan_unit/Fcn5'])
set_param([sys,'/','ABan_unit/Fcn5'],...
		'Expr','(u[1]-u[2])/xpl2',...
		'position',[465,330,560,360])

add_block('built-in/Mux',[sys,'/','ABan_unit/Mux4'])
set_param([sys,'/','ABan_unit/Mux4'],...
		'inputs','2',...
		'position',[425,114,445,161])

add_block('built-in/Mux',[sys,'/','ABan_unit/Mux2'])
set_param([sys,'/','ABan_unit/Mux2'],...
		'inputs','2',...
		'position',[415,316,435,369])

add_block('built-in/Fcn',[sys,'/','ABan_unit/Fcn4'])
set_param([sys,'/','ABan_unit/Fcn4'],...
		'Expr','(u[1]-u[2])/xl1',...
		'position',[470,126,560,154])

add_block('built-in/Outport',[sys,'/','ABan_unit/out_i1'])
set_param([sys,'/','ABan_unit/out_i1'],...
		'Port','3',...
		'position',[710,130,730,150])

add_block('built-in/Outport',[sys,'/','ABan_unit/out_psim'])
set_param([sys,'/','ABan_unit/out_psim'],...
		'Port','2',...
		'position',[710,215,730,235])

add_block('built-in/Inport',[sys,'/','ABan_unit/in_2'])
set_param([sys,'/','ABan_unit/in_2'],...
		'Port','2',...
		'position',[30,320,50,340])

add_block('built-in/Outport',[sys,'/',['ABan_unit/out_i2''']])
set_param([sys,'/',['ABan_unit/out_i2''']],...
		'Port','4',...
		'position',[710,335,730,355])

add_block('built-in/Outport',[sys,'/','ABan_unit/out_psi1'])
set_param([sys,'/','ABan_unit/out_psi1'],...
		'position',[710,65,730,85])

add_block('built-in/Inport',[sys,'/','ABan_unit/in_1'])
set_param([sys,'/','ABan_unit/in_1'],...
		'position',[25,140,45,160])

add_block('built-in/Mux',[sys,'/','ABan_unit/Mux'])
set_param([sys,'/','ABan_unit/Mux'],...
		'inputs','3',...
		'position',[75,108,95,192])

add_block('built-in/Fcn',[sys,'/','ABan_unit/Fcn'])
set_param([sys,'/','ABan_unit/Fcn'],...
		'Expr','wb*(u[2]-(r1/xl1)*(u[3]-u[1]))',...
		'position',[120,135,285,165])
add_line([sys,'/','ABan_unit'],[545,275;510,275])
add_line([sys,'/','ABan_unit'],[475,275;385,275;385,245;400,245])
add_line([sys,'/','ABan_unit'],[620,225;670,225;670,275;615,275])
add_line([sys,'/','ABan_unit'],[620,225;670,225;670,390;385,390;385,355;410,355])
add_line([sys,'/','ABan_unit'],[355,330;410,330])
add_line([sys,'/','ABan_unit'],[440,345;460,345])
add_line([sys,'/','ABan_unit'],[355,330;380,330;380,225;400,225])
add_line([sys,'/','ABan_unit'],[345,150;380,150;380,205;55,205;55,180;70,180])
add_line([sys,'/','ABan_unit'],[355,330;380,330;380,285;60,285;60,305;75,305])
add_line([sys,'/','ABan_unit'],[105,330;115,330])
add_line([sys,'/','ABan_unit'],[620,225;670,225;670,90;55,90;55,120;70,120])
add_line([sys,'/','ABan_unit'],[620,225;670,225;670,390;50,390;50,355;75,355])
add_line([sys,'/','ABan_unit'],[620,225;670,225;670,180;400,180;400,150;420,150])
add_line([sys,'/','ABan_unit'],[345,150;380,150;380,125;420,125])
add_line([sys,'/','ABan_unit'],[450,140;465,140])
add_line([sys,'/','ABan_unit'],[425,225;435,225])
add_line([sys,'/','ABan_unit'],[345,150;380,150;380,205;400,205])
add_line([sys,'/','ABan_unit'],[305,330;315,330])
add_line([sys,'/','ABan_unit'],[290,150;305,150])
add_line([sys,'/','ABan_unit'],[100,150;115,150])
add_line([sys,'/','ABan_unit'],[565,140;705,140])
add_line([sys,'/','ABan_unit'],[345,150;380,150;380,75;705,75])
add_line([sys,'/','ABan_unit'],[50,150;70,150])
add_line([sys,'/','ABan_unit'],[620,225;705,225])
add_line([sys,'/','ABan_unit'],[55,330;75,330])
add_line([sys,'/','ABan_unit'],[565,345;705,345])


%     Finished composite block 'ABan_unit'.

set_param([sys,'/','ABan_unit'],...
		'position',[310,130,340,180])


%     Subsystem  'BCbn_unit'.

new_system([sys,'/','BCbn_unit'])
set_param([sys,'/','BCbn_unit'],'Location',[271,216,1084,635])

add_block('built-in/Fcn',[sys,'/','BCbn_unit/Fcn2'])
set_param([sys,'/','BCbn_unit/Fcn2'],...
		'Expr','wb*(u[2] -(rp2/xpl2)*(u[1]-u[3]))',...
		'position',[120,314,300,346])

add_block('built-in/Mux',[sys,'/','BCbn_unit/Mux1'])
set_param([sys,'/','BCbn_unit/Mux1'],...
		'inputs','3',...
		'position',[80,292,100,368])

add_block('built-in/Note',[sys,'/',['BCbn_unit/i2''']])
set_param([sys,'/',['BCbn_unit/i2''']],...
		'position',[575,322,580,327])

add_block('built-in/Integrator',[sys,'/',['BCbn_unit/psi2''_']])
set_param([sys,'/',['BCbn_unit/psi2''_']],...
		'Initial','Psip2o',...
		'position',[320,317,350,343])

add_block('built-in/Look Up Table',[sys,'/',['BCbn_unit/Look-Up',13,'Table']])
set_param([sys,'/',['BCbn_unit/Look-Up',13,'Table']],...
		'orientation',2,...
		'Input_Values','psisat',...
		'Output_Values','Dpsi',...
		'position',[550,258,610,292])

add_block('built-in/Memory',[sys,'/','BCbn_unit/Memory'])
set_param([sys,'/','BCbn_unit/Memory'],...
		'orientation',2,...
		'position',[480,263,505,287])

add_block('built-in/Note',[sys,'/','BCbn_unit/Dpsi'])
set_param([sys,'/','BCbn_unit/Dpsi'],...
		'orientation',2,...
		'position',[450,257,455,262])

add_block('built-in/Fcn',[sys,'/','BCbn_unit/Fcn3'])
set_param([sys,'/','BCbn_unit/Fcn3'],...
		'Expr','xM*(u[1]/xl1+u[2]/xpl2-u[3]/xm)',...
		'position',[440,206,615,244])

add_block('built-in/Mux',[sys,'/','BCbn_unit/Mux3'])
set_param([sys,'/','BCbn_unit/Mux3'],...
		'inputs','3',...
		'position',[405,193,420,257])

add_block('built-in/Note',[sys,'/','BCbn_unit/psim'])
set_param([sys,'/','BCbn_unit/psim'],...
		'position',[640,200,645,205])

add_block('built-in/Note',[sys,'/',['BCbn_unit/psi2''']])
set_param([sys,'/',['BCbn_unit/psi2''']],...
		'position',[360,306,365,311])

add_block('built-in/Note',[sys,'/','BCbn_unit/psi1'])
set_param([sys,'/','BCbn_unit/psi1'],...
		'position',[355,125,360,130])

add_block('built-in/Integrator',[sys,'/','BCbn_unit/psi1_'])
set_param([sys,'/','BCbn_unit/psi1_'],...
		'Initial','Psi1o',...
		'position',[310,137,340,163])

add_block('built-in/Note',[sys,'/','BCbn_unit/i1'])
set_param([sys,'/','BCbn_unit/i1'],...
		'position',[575,120,580,125])

add_block('built-in/Fcn',[sys,'/','BCbn_unit/Fcn5'])
set_param([sys,'/','BCbn_unit/Fcn5'],...
		'Expr','(u[1]-u[2])/xpl2',...
		'position',[465,330,560,360])

add_block('built-in/Mux',[sys,'/','BCbn_unit/Mux4'])
set_param([sys,'/','BCbn_unit/Mux4'],...
		'inputs','2',...
		'position',[425,114,445,161])

add_block('built-in/Mux',[sys,'/','BCbn_unit/Mux2'])
set_param([sys,'/','BCbn_unit/Mux2'],...
		'inputs','2',...
		'position',[415,316,435,369])

add_block('built-in/Fcn',[sys,'/','BCbn_unit/Fcn4'])
set_param([sys,'/','BCbn_unit/Fcn4'],...
		'Expr','(u[1]-u[2])/xl1',...
		'position',[470,126,560,154])

add_block('built-in/Outport',[sys,'/','BCbn_unit/out_i1'])
set_param([sys,'/','BCbn_unit/out_i1'],...
		'Port','3',...
		'position',[710,130,730,150])

add_block('built-in/Outport',[sys,'/','BCbn_unit/out_psim'])
set_param([sys,'/','BCbn_unit/out_psim'],...
		'Port','2',...
		'position',[710,215,730,235])

add_block('built-in/Inport',[sys,'/','BCbn_unit/in_2'])
set_param([sys,'/','BCbn_unit/in_2'],...
		'Port','2',...
		'position',[30,320,50,340])

add_block('built-in/Outport',[sys,'/',['BCbn_unit/out_i2''']])
set_param([sys,'/',['BCbn_unit/out_i2''']],...
		'Port','4',...
		'position',[710,335,730,355])

add_block('built-in/Outport',[sys,'/','BCbn_unit/out_psi1'])
set_param([sys,'/','BCbn_unit/out_psi1'],...
		'position',[710,65,730,85])

add_block('built-in/Inport',[sys,'/','BCbn_unit/in_1'])
set_param([sys,'/','BCbn_unit/in_1'],...
		'position',[25,140,45,160])

add_block('built-in/Mux',[sys,'/','BCbn_unit/Mux'])
set_param([sys,'/','BCbn_unit/Mux'],...
		'inputs','3',...
		'position',[75,108,95,192])

add_block('built-in/Fcn',[sys,'/','BCbn_unit/Fcn'])
set_param([sys,'/','BCbn_unit/Fcn'],...
		'Expr','wb*(u[2]-(r1/xl1)*(u[3]-u[1]))',...
		'position',[120,135,285,165])
add_line([sys,'/','BCbn_unit'],[545,275;510,275])
add_line([sys,'/','BCbn_unit'],[475,275;385,275;385,245;400,245])
add_line([sys,'/','BCbn_unit'],[620,225;670,225;670,275;615,275])
add_line([sys,'/','BCbn_unit'],[620,225;670,225;670,390;385,390;385,355;410,355])
add_line([sys,'/','BCbn_unit'],[355,330;410,330])
add_line([sys,'/','BCbn_unit'],[440,345;460,345])
add_line([sys,'/','BCbn_unit'],[355,330;380,330;380,225;400,225])
add_line([sys,'/','BCbn_unit'],[345,150;380,150;380,205;55,205;55,180;70,180])
add_line([sys,'/','BCbn_unit'],[355,330;380,330;380,285;60,285;60,305;75,305])
add_line([sys,'/','BCbn_unit'],[105,330;115,330])
add_line([sys,'/','BCbn_unit'],[620,225;670,225;670,90;55,90;55,120;70,120])
add_line([sys,'/','BCbn_unit'],[620,225;670,225;670,390;50,390;50,355;75,355])
add_line([sys,'/','BCbn_unit'],[620,225;670,225;670,180;400,180;400,150;420,150])
add_line([sys,'/','BCbn_unit'],[345,150;380,150;380,125;420,125])
add_line([sys,'/','BCbn_unit'],[450,140;465,140])
add_line([sys,'/','BCbn_unit'],[425,225;435,225])
add_line([sys,'/','BCbn_unit'],[345,150;380,150;380,205;400,205])
add_line([sys,'/','BCbn_unit'],[305,330;315,330])
add_line([sys,'/','BCbn_unit'],[290,150;305,150])
add_line([sys,'/','BCbn_unit'],[100,150;115,150])
add_line([sys,'/','BCbn_unit'],[565,140;705,140])
add_line([sys,'/','BCbn_unit'],[345,150;380,150;380,75;705,75])
add_line([sys,'/','BCbn_unit'],[50,150;70,150])
add_line([sys,'/','BCbn_unit'],[620,225;705,225])
add_line([sys,'/','BCbn_unit'],[55,330;75,330])
add_line([sys,'/','BCbn_unit'],[565,345;705,345])


%     Finished composite block 'BCbn_unit'.

set_param([sys,'/','BCbn_unit'],...
		'position',[305,270,335,320])

add_block('built-in/To Workspace',[sys,'/','To Workspace'])
set_param([sys,'/','To Workspace'],...
		'mat-name','y',...
		'buffer','300',...
		'position',[470,26,505,44])

add_block('built-in/Scope',[sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'orientation',2,...
		'Vgain','500.000000',...
		'Hgain','0.100000',...
		'Vmax','1000.000000',...
		'Hmax','0.312500',...
		'Window',[164,707,949,847])
open_system([sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'position',[245,25,265,45])

add_block('built-in/Sine Wave',[sys,'/','vAO'])
set_param([sys,'/','vAO'],...
		'amplitude','169.7/sqrt(3)',...
		'frequency','120*pi',...
		'position',[100,119,130,151])

add_block('built-in/Clock',[sys,'/','Clock'])
set_param([sys,'/','Clock'],...
		'position',[145,80,165,100])

add_block('built-in/Note',[sys,'/','iAB'])
set_param([sys,'/','iAB'],...
		'position',[360,140,365,145])

add_block('built-in/Note',[sys,'/','iCA'])
set_param([sys,'/','iCA'],...
		'position',[360,410,365,415])

add_block('built-in/Note',[sys,'/',['v''bn']])
set_param([sys,'/',['v''bn']],...
		'position',[265,335,270,340])

add_block('built-in/Note',[sys,'/','vBC'])
set_param([sys,'/','vBC'],...
		'position',[265,266,270,271])


%     Subsystem  'Ref_Load an_'.

new_system([sys,'/','Ref_Load an_'])
set_param([sys,'/','Ref_Load an_'],'Location',[64,100,294,386])

add_block('built-in/Outport',[sys,'/','Ref_Load an_/out_1'])
set_param([sys,'/','Ref_Load an_/out_1'],...
		'orientation',2,...
		'position',[15,55,35,75])

add_block('built-in/Inport',[sys,'/','Ref_Load an_/in_1'])
set_param([sys,'/','Ref_Load an_/in_1'],...
		'orientation',2,...
		'position',[180,55,200,75])

add_block('built-in/Gain',[sys,'/','Ref_Load an_/HGR'])
set_param([sys,'/','Ref_Load an_/HGR'],...
		'orientation',2,...
		'Gain','-24',...
		'position',[100,51,140,79])
add_line([sys,'/','Ref_Load an_'],[95,65;40,65])
add_line([sys,'/','Ref_Load an_'],[175,65;145,65])


%     Finished composite block 'Ref_Load an_'.

set_param([sys,'/','Ref_Load an_'],...
		'orientation',2,...
		'position',[310,200,335,240])


%     Subsystem  'Ref_Load bn'.

new_system([sys,'/','Ref_Load bn'])
set_param([sys,'/','Ref_Load bn'],'Location',[64,196,294,386])

add_block('built-in/Outport',[sys,'/','Ref_Load bn/out_1'])
set_param([sys,'/','Ref_Load bn/out_1'],...
		'orientation',2,...
		'position',[15,55,35,75])

add_block('built-in/Inport',[sys,'/','Ref_Load bn/in_1'])
set_param([sys,'/','Ref_Load bn/in_1'],...
		'orientation',2,...
		'position',[180,55,200,75])

add_block('built-in/Gain',[sys,'/','Ref_Load bn/HGR'])
set_param([sys,'/','Ref_Load bn/HGR'],...
		'orientation',2,...
		'Gain','-24',...
		'position',[100,55,120,75])
add_line([sys,'/','Ref_Load bn'],[95,65;40,65])
add_line([sys,'/','Ref_Load bn'],[175,65;125,65])


%     Finished composite block 'Ref_Load bn'.

set_param([sys,'/','Ref_Load bn'],...
		'orientation',2,...
		'position',[305,335,330,375])


%     Subsystem  'Ref_Load cn'.

new_system([sys,'/','Ref_Load cn'])
set_param([sys,'/','Ref_Load cn'],'Location',[64,196,294,386])

add_block('built-in/Outport',[sys,'/','Ref_Load cn/out_1'])
set_param([sys,'/','Ref_Load cn/out_1'],...
		'orientation',2,...
		'position',[15,55,35,75])

add_block('built-in/Inport',[sys,'/','Ref_Load cn/in_1'])
set_param([sys,'/','Ref_Load cn/in_1'],...
		'orientation',2,...
		'position',[180,55,200,75])

add_block('built-in/Gain',[sys,'/','Ref_Load cn/HGR'])
set_param([sys,'/','Ref_Load cn/HGR'],...
		'orientation',2,...
		'Gain','-24',...
		'position',[100,55,120,75])
add_line([sys,'/','Ref_Load cn'],[95,65;40,65])
add_line([sys,'/','Ref_Load cn'],[175,65;125,65])


%     Finished composite block 'Ref_Load cn'.

set_param([sys,'/','Ref_Load cn'],...
		'orientation',2,...
		'position',[305,470,330,510])


%     Subsystem  'CAcn_unit'.

new_system([sys,'/','CAcn_unit'])
set_param([sys,'/','CAcn_unit'],'Location',[271,216,1084,635])

add_block('built-in/Fcn',[sys,'/','CAcn_unit/Fcn2'])
set_param([sys,'/','CAcn_unit/Fcn2'],...
		'Expr','wb*(u[2] -(rp2/xpl2)*(u[1]-u[3]))',...
		'position',[120,314,300,346])

add_block('built-in/Mux',[sys,'/','CAcn_unit/Mux1'])
set_param([sys,'/','CAcn_unit/Mux1'],...
		'inputs','3',...
		'position',[80,292,100,368])

add_block('built-in/Note',[sys,'/',['CAcn_unit/i2''']])
set_param([sys,'/',['CAcn_unit/i2''']],...
		'position',[575,322,580,327])

add_block('built-in/Integrator',[sys,'/',['CAcn_unit/psi2''_']])
set_param([sys,'/',['CAcn_unit/psi2''_']],...
		'Initial','Psip2o',...
		'position',[320,317,350,343])

add_block('built-in/Look Up Table',[sys,'/',['CAcn_unit/Look-Up',13,'Table']])
set_param([sys,'/',['CAcn_unit/Look-Up',13,'Table']],...
		'orientation',2,...
		'Input_Values','psisat',...
		'Output_Values','Dpsi',...
		'position',[550,258,610,292])

add_block('built-in/Memory',[sys,'/','CAcn_unit/Memory'])
set_param([sys,'/','CAcn_unit/Memory'],...
		'orientation',2,...
		'position',[480,263,505,287])

add_block('built-in/Note',[sys,'/','CAcn_unit/Dpsi'])
set_param([sys,'/','CAcn_unit/Dpsi'],...
		'orientation',2,...
		'position',[450,257,455,262])

add_block('built-in/Fcn',[sys,'/','CAcn_unit/Fcn3'])
set_param([sys,'/','CAcn_unit/Fcn3'],...
		'Expr','xM*(u[1]/xl1+u[2]/xpl2-u[3]/xm)',...
		'position',[440,206,615,244])

add_block('built-in/Mux',[sys,'/','CAcn_unit/Mux3'])
set_param([sys,'/','CAcn_unit/Mux3'],...
		'inputs','3',...
		'position',[405,193,420,257])

add_block('built-in/Note',[sys,'/','CAcn_unit/psim'])
set_param([sys,'/','CAcn_unit/psim'],...
		'position',[640,200,645,205])

add_block('built-in/Note',[sys,'/',['CAcn_unit/psi2''']])
set_param([sys,'/',['CAcn_unit/psi2''']],...
		'position',[360,306,365,311])

add_block('built-in/Note',[sys,'/','CAcn_unit/psi1'])
set_param([sys,'/','CAcn_unit/psi1'],...
		'position',[355,125,360,130])

add_block('built-in/Integrator',[sys,'/','CAcn_unit/psi1_'])
set_param([sys,'/','CAcn_unit/psi1_'],...
		'Initial','Psi1o',...
		'position',[310,137,340,163])

add_block('built-in/Note',[sys,'/','CAcn_unit/i1'])
set_param([sys,'/','CAcn_unit/i1'],...
		'position',[575,120,580,125])

add_block('built-in/Fcn',[sys,'/','CAcn_unit/Fcn5'])
set_param([sys,'/','CAcn_unit/Fcn5'],...
		'Expr','(u[1]-u[2])/xpl2',...
		'position',[465,330,560,360])

add_block('built-in/Mux',[sys,'/','CAcn_unit/Mux4'])
set_param([sys,'/','CAcn_unit/Mux4'],...
		'inputs','2',...
		'position',[425,114,445,161])

add_block('built-in/Mux',[sys,'/','CAcn_unit/Mux2'])
set_param([sys,'/','CAcn_unit/Mux2'],...
		'inputs','2',...
		'position',[415,316,435,369])

add_block('built-in/Fcn',[sys,'/','CAcn_unit/Fcn4'])
set_param([sys,'/','CAcn_unit/Fcn4'],...
		'Expr','(u[1]-u[2])/xl1',...
		'position',[470,126,560,154])

add_block('built-in/Outport',[sys,'/','CAcn_unit/out_i1'])
set_param([sys,'/','CAcn_unit/out_i1'],...
		'Port','3',...
		'position',[710,130,730,150])

add_block('built-in/Outport',[sys,'/','CAcn_unit/out_psim'])
set_param([sys,'/','CAcn_unit/out_psim'],...
		'Port','2',...
		'position',[710,215,730,235])

add_block('built-in/Inport',[sys,'/','CAcn_unit/in_2'])
set_param([sys,'/','CAcn_unit/in_2'],...
		'Port','2',...
		'position',[30,320,50,340])

add_block('built-in/Outport',[sys,'/',['CAcn_unit/out_i2''']])
set_param([sys,'/',['CAcn_unit/out_i2''']],...
		'Port','4',...
		'position',[710,335,730,355])

add_block('built-in/Outport',[sys,'/','CAcn_unit/out_psi1'])
set_param([sys,'/','CAcn_unit/out_psi1'],...
		'position',[710,65,730,85])

add_block('built-in/Inport',[sys,'/','CAcn_unit/in_1'])
set_param([sys,'/','CAcn_unit/in_1'],...
		'position',[25,140,45,160])

add_block('built-in/Mux',[sys,'/','CAcn_unit/Mux'])
set_param([sys,'/','CAcn_unit/Mux'],...
		'inputs','3',...
		'position',[75,108,95,192])

add_block('built-in/Fcn',[sys,'/','CAcn_unit/Fcn'])
set_param([sys,'/','CAcn_unit/Fcn'],...
		'Expr','wb*(u[2]-(r1/xl1)*(u[3]-u[1]))',...
		'position',[120,135,285,165])
add_line([sys,'/','CAcn_unit'],[545,275;510,275])
add_line([sys,'/','CAcn_unit'],[475,275;385,275;385,245;400,245])
add_line([sys,'/','CAcn_unit'],[620,225;670,225;670,275;615,275])
add_line([sys,'/','CAcn_unit'],[620,225;670,225;670,390;385,390;385,355;410,355])
add_line([sys,'/','CAcn_unit'],[355,330;410,330])
add_line([sys,'/','CAcn_unit'],[440,345;460,345])
add_line([sys,'/','CAcn_unit'],[355,330;380,330;380,225;400,225])
add_line([sys,'/','CAcn_unit'],[345,150;380,150;380,205;55,205;55,180;70,180])
add_line([sys,'/','CAcn_unit'],[355,330;380,330;380,285;60,285;60,305;75,305])
add_line([sys,'/','CAcn_unit'],[105,330;115,330])
add_line([sys,'/','CAcn_unit'],[620,225;670,225;670,90;55,90;55,120;70,120])
add_line([sys,'/','CAcn_unit'],[620,225;670,225;670,390;50,390;50,355;75,355])
add_line([sys,'/','CAcn_unit'],[620,225;670,225;670,180;400,180;400,150;420,150])
add_line([sys,'/','CAcn_unit'],[345,150;380,150;380,125;420,125])
add_line([sys,'/','CAcn_unit'],[450,140;465,140])
add_line([sys,'/','CAcn_unit'],[425,225;435,225])
add_line([sys,'/','CAcn_unit'],[345,150;380,150;380,205;400,205])
add_line([sys,'/','CAcn_unit'],[305,330;315,330])
add_line([sys,'/','CAcn_unit'],[290,150;305,150])
add_line([sys,'/','CAcn_unit'],[100,150;115,150])
add_line([sys,'/','CAcn_unit'],[565,140;705,140])
add_line([sys,'/','CAcn_unit'],[345,150;380,150;380,75;705,75])
add_line([sys,'/','CAcn_unit'],[50,150;70,150])
add_line([sys,'/','CAcn_unit'],[620,225;705,225])
add_line([sys,'/','CAcn_unit'],[55,330;75,330])
add_line([sys,'/','CAcn_unit'],[565,345;705,345])


%     Finished composite block 'CAcn_unit'.

set_param([sys,'/','CAcn_unit'],...
		'position',[300,400,330,450])

add_block('built-in/Note',[sys,'/',['v''cn']])
set_param([sys,'/',['v''cn']],...
		'position',[255,460,260,465])

add_block('built-in/Note',[sys,'/',['i''c']])
set_param([sys,'/',['i''c']],...
		'position',[365,465,370,470])

add_block('built-in/Note',[sys,'/',['i''b']])
set_param([sys,'/',['i''b']],...
		'position',[370,330,375,335])

add_block('built-in/Note',[sys,'/',['v''an']])
set_param([sys,'/',['v''an']],...
		'position',[260,200,265,205])

add_block('built-in/Note',[sys,'/','iBC'])
set_param([sys,'/','iBC'],...
		'position',[355,275,360,280])

add_block('built-in/Gain',[sys,'/','(Np//Ns)'])
set_param([sys,'/','(Np//Ns)'],...
		'Gain','NpbyNs',...
		'position',[450,154,475,186])

add_block('built-in/Note',[sys,'/','vnG'])
set_param([sys,'/','vnG'],...
		'position',[575,285,580,290])

add_block('built-in/Gain',[sys,'/','(Ns//Np)'])
set_param([sys,'/','(Ns//Np)'],...
		'Gain','1/NpbyNs',...
		'position',[255,96,280,124])

add_block('built-in/Note',[sys,'/','vab'])
set_param([sys,'/','vab'],...
		'position',[300,90,305,95])

add_block('built-in/Sum',[sys,'/','S'])
set_param([sys,'/','S'],...
		'inputs','+-',...
		'position',[175,127,190,163])

add_block('built-in/Note',[sys,'/','vAB'])
set_param([sys,'/','vAB'],...
		'position',[205,125,210,130])

add_block('built-in/Sum',[sys,'/','S5'])
set_param([sys,'/','S5'],...
		'orientation',3,...
		'inputs','-+',...
		'position',[217,180,248,195])

add_block('built-in/Sum',[sys,'/','S1'])
set_param([sys,'/','S1'],...
		'inputs','+-',...
		'position',[180,266,195,304])

add_block('built-in/Sum',[sys,'/','S2'])
set_param([sys,'/','S2'],...
		'inputs','+-',...
		'position',[180,396,195,434])

add_block('built-in/Gain',[sys,'/','1//3'])
set_param([sys,'/','1//3'],...
		'orientation',3,...
		'Gain','1/3',...
		'position',[508,165,542,200])

add_block('built-in/Sum',[sys,'/','s4'])
set_param([sys,'/','s4'],...
		'inputs','+-',...
		'position',[415,120,430,155])

add_block('built-in/Note',[sys,'/','iA'])
set_param([sys,'/','iA'],...
		'position',[445,120,450,125])

add_block('built-in/Note',[sys,'/','ia'])
set_param([sys,'/','ia'],...
		'position',[480,150,485,155])

add_block('built-in/Sum',[sys,'/','Sum'])
set_param([sys,'/','Sum'],...
		'inputs','+++',...
		'position',[420,214,435,256])

add_block('built-in/Note',[sys,'/','iAB+iBC+iCA'])
set_param([sys,'/','iAB+iBC+iCA'],...
		'position',[475,215,480,220])

add_block('built-in/Gain',[sys,'/','(Np//Ns)//3'])
set_param([sys,'/','(Np//Ns)//3'],...
		'orientation',3,...
		'Gain','NpbyNs/3',...
		'position',[543,220,577,250])

add_block('built-in/Sum',[sys,'/','Sum3'])
set_param([sys,'/','Sum3'],...
		'inputs','+++',...
		'position',[430,285,445,335])

add_block('built-in/Note',[sys,'/',['ia''+ib''+ic''']])
set_param([sys,'/',['ia''+ib''+ic''']],...
		'position',[480,285,485,290])

add_block('built-in/Gain',[sys,'/','R_n(Np//Ns)'])
set_param([sys,'/','R_n(Np//Ns)'],...
		'Gain','Rn*NpbyNs',...
		'position',[520,291,555,329])

add_block('built-in/Scope',[sys,'/','Scope1'])
set_param([sys,'/','Scope1'],...
		'Vgain','60.000000',...
		'Hgain','0.200000',...
		'Vmax','120.000000',...
		'Hmax','0.200000',...
		'Window',[611,772,1210,896],...
		'position',[455,382,475,408])


%     Subsystem  'm4'.

new_system([sys,'/','m4'])
set_param([sys,'/','m4'],'Location',[480,6357505,795,6357599])

add_block('built-in/Note',[sys,'/',['m4/Masked block of m4.m to initilaize s4.m',13,'and plot results of simulation']])
set_param([sys,'/',['m4/Masked block of m4.m to initilaize s4.m',13,'and plot results of simulation']],...
		'position',[165,42,170,47])
set_param([sys,'/','m4'],...
		'Mask Display','Initialize\nand plot',...
		'Mask Type','Masked block of m4.m',...
		'Mask Dialogue','eval(''m4'')',...
		'Mask Help','Uses m4.m to initialize and plot')


%     Finished composite block 'm4'.

set_param([sys,'/','m4'],...
		'Drop Shadow',4,...
		'position',[519,374,587,417])
add_line(sys,[365,55;365,35;270,35])
add_line(sys,[365,55;365,35;465,35])
add_line(sys,[170,90;190,80])
add_line(sys,[195,145;305,145])
add_line(sys,[135,135;170,135])
add_line(sys,[130,275;175,275])
add_line(sys,[135,405;175,405])
add_line(sys,[200,285;300,285])
add_line(sys,[200,415;295,415])
add_line(sys,[450,310;515,310])
add_line(sys,[305,220;285,220;285,170;305,170])
add_line(sys,[340,310;360,310;360,355;335,355])
add_line(sys,[300,355;285,355;285,310;300,310])
add_line(sys,[335,440;355,440;355,490;335,490])
add_line(sys,[300,490;275,490;275,440;295,440])
add_line(sys,[345,170;385,170;385,295;425,295])
add_line(sys,[340,310;425,310])
add_line(sys,[335,440;405,440;405,325;425,325])
add_line(sys,[130,275;155,275;155,155;170,155])
add_line(sys,[135,405;160,405;160,295;175,295])
add_line(sys,[135,135;145,135;145,425;175,425])
add_line(sys,[345,170;360,170;360,220;340,220])
add_line(sys,[480,170;500,170;500,110;390,110;390,80])
add_line(sys,[235,175;235,110;250,110])
add_line(sys,[305,220;240,220;240,200])
add_line(sys,[300,355;225,355;225,200])
add_line(sys,[345,170;445,170])
add_line(sys,[435,140;460,140;460,115;340,115;340,80])
add_line(sys,[195,145;225,145;225,95;240,95;240,80])
add_line(sys,[285,110;290,110;290,80])
add_line(sys,[345,160;380,160;380,130;410,130])
add_line(sys,[335,430;395,430;395,145;410,145])
add_line(sys,[345,160;380,160;380,220;415,220])
add_line(sys,[340,300;375,300;375,235;415,235])
add_line(sys,[335,430;395,430;395,250;415,250])
add_line(sys,[560,310;595,310;595,90;540,80])
add_line(sys,[440,235;525,235;525,205])
add_line(sys,[525,160;525,105;440,105;440,80])
add_line(sys,[560,215;560,100;490,100;490,80])
add_line(sys,[450,310;450,265;560,255])

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
