function [ret,x0,str,ts,xts]=s2c(t,x,u,flag);
%s2c	is the M-file description of the SIMULINK system named s2c.
%	The block-diagram can be displayed by typing: s2c.
%
%	SYS=s2c(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes s2c to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling s2c with a FLAG of zero:
%	[SIZES]=s2c([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[124,85,943,458])
     open_system(sys)
end;
set_param(sys,'algorithm',     'Adams/Gear')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     'tstop')
set_param(sys,'Min step size', '1e-4')
set_param(sys,'Max step size', '1e-2')
set_param(sys,'Relative error','1e-5')
set_param(sys,'Return vars',   '')

add_block('built-in/Scope',[sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'Vgain','300.000000',...
		'Hgain','2.000000',...
		'Vmax','300.000000',...
		'Hmax','3.921569',...
		'Window',[134,576,957,712])
open_system([sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'position',[455,39,470,61])

add_block('built-in/To Workspace',[sys,'/','To Workspace'])
set_param([sys,'/','To Workspace'],...
		'orientation',2,...
		'mat-name','y',...
		'buffer','40000',...
		'position',[305,42,355,58])

add_block('built-in/Clock',[sys,'/','Clock'])
set_param([sys,'/','Clock'],...
		'orientation',1,...
		'position',[112,65,128,80])

add_block('built-in/Mux',[sys,'/','Mux'])
set_param([sys,'/','Mux'],...
		'orientation',3,...
		'inputs','7',...
		'position',[143,75,667,90])

add_block('built-in/Sum',[sys,'/','Sum1'])
set_param([sys,'/','Sum1'],...
		'inputs','+-',...
		'position',[105,148,120,177])

add_block('built-in/Gain',[sys,'/','Gain'])
set_param([sys,'/','Gain'],...
		'Gain','wb',...
		'position',[220,242,250,278])

add_block('built-in/Sum',[sys,'/','Sum2'])
set_param([sys,'/','Sum2'],...
		'position',[165,240,180,275])

add_block('built-in/Note',[sys,'/','ics'])
set_param([sys,'/','ics'],...
		'position',[685,180,690,185])

add_block('built-in/Note',[sys,'/','ias'])
set_param([sys,'/','ias'],...
		'position',[685,140,690,145])

add_block('built-in/Note',[sys,'/','ibs'])
set_param([sys,'/','ibs'],...
		'position',[685,160,690,165])

add_block('built-in/Sum',[sys,'/','Sum'])
set_param([sys,'/','Sum'],...
		'inputs','+++',...
		'position',[715,149,730,211])


%     Subsystem  'qds2abc'.

new_system([sys,'/','qds2abc'])
set_param([sys,'/','qds2abc'],'Location',[487,91,1006,301])

add_block('built-in/Inport',[sys,'/','qds2abc/iqs'])
set_param([sys,'/','qds2abc/iqs'],...
		'position',[45,35,65,55])

add_block('built-in/Inport',[sys,'/','qds2abc/ids'])
set_param([sys,'/','qds2abc/ids'],...
		'Port','2',...
		'position',[45,95,65,115])

add_block('built-in/Inport',[sys,'/','qds2abc/i0s'])
set_param([sys,'/','qds2abc/i0s'],...
		'Port','3',...
		'position',[45,155,65,175])

add_block('built-in/Mux',[sys,'/','qds2abc/Mux'])
set_param([sys,'/','qds2abc/Mux'],...
		'inputs','3',...
		'position',[110,34,135,176])

add_block('built-in/Fcn',[sys,'/','qds2abc/Fcn1'])
set_param([sys,'/','qds2abc/Fcn1'],...
		'Expr','-(u[1]+sqrt(3)*u[2])/2 +u[3]',...
		'position',[185,92,370,118])

add_block('built-in/Outport',[sys,'/','qds2abc/ibs'])
set_param([sys,'/','qds2abc/ibs'],...
		'Port','2',...
		'position',[440,95,460,115])

add_block('built-in/Outport',[sys,'/','qds2abc/ias'])
set_param([sys,'/','qds2abc/ias'],...
		'position',[440,40,460,60])

add_block('built-in/Fcn',[sys,'/','qds2abc/Fcn2'])
set_param([sys,'/','qds2abc/Fcn2'],...
		'Expr','-(u[1]-sqrt(3)*u[2])/2 + u[3]',...
		'position',[185,147,375,173])

add_block('built-in/Fcn',[sys,'/','qds2abc/Fcn'])
set_param([sys,'/','qds2abc/Fcn'],...
		'Expr','u[1] + u[3]',...
		'position',[185,36,375,64])

add_block('built-in/Outport',[sys,'/','qds2abc/ics'])
set_param([sys,'/','qds2abc/ics'],...
		'Port','3',...
		'position',[440,150,460,170])
add_line([sys,'/','qds2abc'],[70,105;105,105])
add_line([sys,'/','qds2abc'],[70,45;80,45;80,60;105,60])
add_line([sys,'/','qds2abc'],[70,165;80,165;80,150;105,150])
add_line([sys,'/','qds2abc'],[140,105;180,105])
add_line([sys,'/','qds2abc'],[375,105;435,105])
add_line([sys,'/','qds2abc'],[380,50;435,50])
add_line([sys,'/','qds2abc'],[140,105;155,105;155,50;180,50])
add_line([sys,'/','qds2abc'],[140,105;155,105;155,160;180,160])
add_line([sys,'/','qds2abc'],[380,160;435,160])


%     Finished composite block 'qds2abc'.

set_param([sys,'/','qds2abc'],...
		'position',[635,149,665,211])

add_block('built-in/Note',[sys,'/','ids'])
set_param([sys,'/','ids'],...
		'position',[610,160,615,165])

add_block('built-in/Note',[sys,'/','iqs'])
set_param([sys,'/','iqs'],...
		'position',[610,135,615,140])

add_block('built-in/Note',[sys,'/','i0s'])
set_param([sys,'/','i0s'],...
		'position',[610,180,615,185])

add_block('built-in/Note',[sys,'/','Tem'])
set_param([sys,'/','Tem'],...
		'position',[575,202,580,207])

add_block('built-in/Note',[sys,'/','psids'])
set_param([sys,'/','psids'],...
		'position',[605,260,610,265])

add_block('built-in/Note',[sys,'/','psiqs'])
set_param([sys,'/','psiqs'],...
		'position',[604,241,609,246])

add_block('built-in/Note',[sys,'/','vds'])
set_param([sys,'/','vds'],...
		'position',[470,185,475,190])

add_block('built-in/Note',[sys,'/','vqs'])
set_param([sys,'/','vqs'],...
		'position',[470,150,475,155])

add_block('built-in/Fcn',[sys,'/','Fcn1'])
set_param([sys,'/','Fcn1'],...
		'Expr','sqrt(u[1]*u[1]+u[2]*u[2])',...
		'position',[670,260,710,280])

add_block('built-in/Mux',[sys,'/','Mux2'])
set_param([sys,'/','Mux2'],...
		'inputs','2',...
		'position',[630,250,650,290])

add_block('built-in/Note',[sys,'/','v0s'])
set_param([sys,'/','v0s'],...
		'position',[475,218,480,223])


%     Subsystem  'abc2qds'.

new_system([sys,'/','abc2qds'])
set_param([sys,'/','abc2qds'],'Location',[299,170,863,507])

add_block('built-in/Note',[sys,'/','abc2qds/abc to qd0 stationary '])
set_param([sys,'/','abc2qds/abc to qd0 stationary '],...
		'position',[255,45,260,50])

add_block('built-in/Mux',[sys,'/','abc2qds/Mux'])
set_param([sys,'/','abc2qds/Mux'],...
		'inputs','3',...
		'position',[105,81,145,259])

add_block('built-in/Inport',[sys,'/','abc2qds/vag'])
set_param([sys,'/','abc2qds/vag'],...
		'position',[40,100,60,120])

add_block('built-in/Inport',[sys,'/','abc2qds/vbg'])
set_param([sys,'/','abc2qds/vbg'],...
		'Port','2',...
		'position',[40,160,60,180])

add_block('built-in/Inport',[sys,'/','abc2qds/vcg'])
set_param([sys,'/','abc2qds/vcg'],...
		'Port','3',...
		'position',[40,220,60,240])

add_block('built-in/Inport',[sys,'/','abc2qds/ias+ibs+ics'])
set_param([sys,'/','abc2qds/ias+ibs+ics'],...
		'Port','4',...
		'position',[40,285,60,305])

add_block('built-in/Outport',[sys,'/','abc2qds/v0s'])
set_param([sys,'/','abc2qds/v0s'],...
		'Port','3',...
		'position',[515,240,535,260])

add_block('built-in/Outport',[sys,'/','abc2qds/vds'])
set_param([sys,'/','abc2qds/vds'],...
		'Port','2',...
		'position',[515,160,535,180])

add_block('built-in/Gain',[sys,'/','abc2qds/1//Csg'])
set_param([sys,'/','abc2qds/1//Csg'],...
		'Gain','50*Zb*wb',...
		'position',[105,274,195,316])

add_block('built-in/Note',[sys,'/','abc2qds/vsg'])
set_param([sys,'/','abc2qds/vsg'],...
		'position',[335,275,340,280])

add_block('built-in/Integrator',[sys,'/','abc2qds/Integrator'])
set_param([sys,'/','abc2qds/Integrator'],...
		'position',[230,280,260,310])

add_block('built-in/Fcn',[sys,'/','abc2qds/Fcn'])
set_param([sys,'/','abc2qds/Fcn'],...
		'Expr','(2/3)*(u[1] - (u[2]+u[3])/2)',...
		'position',[210,82,370,108])

add_block('built-in/Sum',[sys,'/','abc2qds/Sum'])
set_param([sys,'/','abc2qds/Sum'],...
		'inputs','+-',...
		'position',[470,223,485,272])

add_block('built-in/Fcn',[sys,'/','abc2qds/Fcn1'])
set_param([sys,'/','abc2qds/Fcn1'],...
		'Expr','(u[3]-u[2])/sqrt(3)',...
		'position',[210,157,370,183])

add_block('built-in/Fcn',[sys,'/','abc2qds/Fcn2'])
set_param([sys,'/','abc2qds/Fcn2'],...
		'Expr','(u[1]+u[2]+u[3])/3',...
		'position',[210,224,370,246])

add_block('built-in/Sum',[sys,'/','abc2qds/Sum1'])
set_param([sys,'/','abc2qds/Sum1'],...
		'inputs','+-',...
		'position',[460,83,475,132])

add_block('built-in/Outport',[sys,'/','abc2qds/vqs'])
set_param([sys,'/','abc2qds/vqs'],...
		'position',[520,100,540,120])
add_line([sys,'/','abc2qds'],[65,295;100,295])
add_line([sys,'/','abc2qds'],[65,110;100,110])
add_line([sys,'/','abc2qds'],[65,170;100,170])
add_line([sys,'/','abc2qds'],[65,230;100,230])
add_line([sys,'/','abc2qds'],[150,170;205,170])
add_line([sys,'/','abc2qds'],[150,170;170,170;170,95;205,95])
add_line([sys,'/','abc2qds'],[375,170;510,170])
add_line([sys,'/','abc2qds'],[150,170;170,170;170,235;205,235])
add_line([sys,'/','abc2qds'],[490,250;510,250])
add_line([sys,'/','abc2qds'],[375,235;465,235])
add_line([sys,'/','abc2qds'],[200,295;225,295])
add_line([sys,'/','abc2qds'],[265,295;405,295;405,260;465,260])
add_line([sys,'/','abc2qds'],[375,95;455,95])
add_line([sys,'/','abc2qds'],[480,110;515,110])
add_line([sys,'/','abc2qds'],[265,295;405,295;405,120;455,120])


%     Finished composite block 'abc2qds'.

set_param([sys,'/','abc2qds'],...
		'position',[405,151,450,254])

add_block('built-in/Note',[sys,'/','vcg'])
set_param([sys,'/','vcg'],...
		'position',[367,195,372,200])

add_block('built-in/Note',[sys,'/','wr//wb'])
set_param([sys,'/','wr//wb'],...
		'position',[565,220,570,225])

add_block('built-in/Scope',[sys,'/','Scope2'])
set_param([sys,'/','Scope2'],...
		'Vgain','1.000000',...
		'Hgain','1.000000',...
		'Vmax','1.000000',...
		'Hmax','1.960784',...
		'Window',[134,851,597,1005],...
		'position',[520,39,535,61])

add_block('built-in/Saturation',[sys,'/','slip_limit'])
set_param([sys,'/','slip_limit'],...
		'Lower Limit','-0.7*smaxt',...
		'Upper Limit','0.7*smaxt',...
		'position',[215,153,245,177])

add_block('built-in/Transfer Fcn',[sys,'/',['speed',13,'controller']])
set_param([sys,'/',['speed',13,'controller']],...
		'Numerator','[10 0.5]',...
		'Denominator','[1 0]',...
		'position',[140,145,190,185])


%     Subsystem  'Tmech'.

new_system([sys,'/','Tmech'])
set_param([sys,'/','Tmech'],'Location',[5,40,315,196])

add_block('built-in/Outport',[sys,'/','Tmech/out_1'])
set_param([sys,'/','Tmech/out_1'],...
		'position',[285,60,305,80])

add_block('built-in/Look Up Table',[sys,'/','Tmech/Look-Up Table'])
set_param([sys,'/','Tmech/Look-Up Table'],...
		'Input_Values','t',...
		'Output_Values','y',...
		'position',[210,58,250,82])

add_block('built-in/Fcn',[sys,'/','Tmech/Fcn1'])
set_param([sys,'/','Tmech/Fcn1'],...
		'Expr','rem(u[1],period)',...
		'position',[110,60,150,80])

add_block('built-in/Clock',[sys,'/','Tmech/Clock'])
set_param([sys,'/','Tmech/Clock'],...
		'position',[45,60,65,80])
add_line([sys,'/','Tmech'],[255,70;280,70])
add_line([sys,'/','Tmech'],[70,70;105,70])
add_line([sys,'/','Tmech'],[155,70;205,70])
set_param([sys,'/','Tmech'],...
		'Mask Display','plot([t,t+period,t+2*period],[y,y,y])',...
		'Mask Type','Repeating table',...
		'Mask Dialogue','Repeating table.\nEnter values of time and output for first cycle.|Time values:|Output values:')
set_param([sys,'/','Tmech'],...
		'Mask Translate','period = max(@1); t = @1; y = @2;',...
		'Mask Help','Repeats cycle given in table. Time values should be monotonically increasing.',...
		'Mask Entries','time_tmech\/tmech_tmech\/')


%     Finished composite block 'Tmech'.

set_param([sys,'/','Tmech'],...
		'position',[410,274,450,296])


%     Subsystem  ['Speed Ref',13,'in per unit'].

new_system([sys,'/',['Speed Ref',13,'in per unit']])
set_param([sys,'/',['Speed Ref',13,'in per unit']],'Location',[5,40,315,196])

add_block('built-in/Outport',[sys,'/',['Speed Ref',13,'in per unit/out_1']])
set_param([sys,'/',['Speed Ref',13,'in per unit/out_1']],...
		'position',[285,60,305,80])

add_block('built-in/Look Up Table',[sys,'/',['Speed Ref',13,'in per unit/Look-Up Table']])
set_param([sys,'/',['Speed Ref',13,'in per unit/Look-Up Table']],...
		'Input_Values','t',...
		'Output_Values','y',...
		'position',[210,58,250,82])

add_block('built-in/Fcn',[sys,'/',['Speed Ref',13,'in per unit/Fcn1']])
set_param([sys,'/',['Speed Ref',13,'in per unit/Fcn1']],...
		'Expr','rem(u[1],period)',...
		'position',[110,60,150,80])

add_block('built-in/Clock',[sys,'/',['Speed Ref',13,'in per unit/Clock']])
set_param([sys,'/',['Speed Ref',13,'in per unit/Clock']],...
		'position',[45,60,65,80])
add_line([sys,'/',['Speed Ref',13,'in per unit']],[255,70;280,70])
add_line([sys,'/',['Speed Ref',13,'in per unit']],[70,70;105,70])
add_line([sys,'/',['Speed Ref',13,'in per unit']],[155,70;205,70])
set_param([sys,'/',['Speed Ref',13,'in per unit']],...
		'Mask Display','plot([t,t+period,t+2*period],[y,y,y])',...
		'Mask Type','Repeating table')
set_param([sys,'/',['Speed Ref',13,'in per unit']],...
		'Mask Dialogue','Repeating table.\nEnter values of time and output for first cycle.|Time values:|Output values:',...
		'Mask Translate','period = max(@1); t = @1; y = @2;')
set_param([sys,'/',['Speed Ref',13,'in per unit']],...
		'Mask Help','Repeats cycle given in table. Time values should be monotonically increasing.',...
		'Mask Entries','time_wref\/speed_wref\/')


%     Finished composite block ['Speed Ref',13,'in per unit'].

set_param([sys,'/',['Speed Ref',13,'in per unit']],...
		'position',[35,115,75,135])


%     Subsystem  'Sqvar_we'.

new_system([sys,'/','Sqvar_we'])
set_param([sys,'/','Sqvar_we'],'Location',[146,282,943,605])


%     Subsystem  'Sqvar_we/Sign'.

new_system([sys,'/','Sqvar_we/Sign'])
set_param([sys,'/','Sqvar_we/Sign'],'Location',[159,417,467,586])

add_block('built-in/Outport',[sys,'/','Sqvar_we/Sign/out_1'])
set_param([sys,'/','Sqvar_we/Sign/out_1'],...
		'position',[265,70,285,90])

add_block('built-in/Inport',[sys,'/','Sqvar_we/Sign/in_1'])
set_param([sys,'/','Sqvar_we/Sign/in_1'],...
		'position',[35,30,55,50])

add_block('built-in/Relational Operator',[sys,'/',['Sqvar_we/Sign/Relational',13,'Operator']])
set_param([sys,'/',['Sqvar_we/Sign/Relational',13,'Operator']],...
		'Operator','>',...
		'position',[140,32,170,63])

add_block('built-in/Sum',[sys,'/','Sqvar_we/Sign/Sum'])
set_param([sys,'/','Sqvar_we/Sign/Sum'],...
		'inputs','+-',...
		'position',[215,64,235,91])

add_block('built-in/Relational Operator',[sys,'/',['Sqvar_we/Sign/Relational',13,'Operator1']])
set_param([sys,'/',['Sqvar_we/Sign/Relational',13,'Operator1']],...
		'Operator','<',...
		'position',[140,92,170,123])

add_block('built-in/Constant',[sys,'/','Sqvar_we/Sign/Constant'])
set_param([sys,'/','Sqvar_we/Sign/Constant'],...
		'Value','0',...
		'position',[65,105,85,125])
add_line([sys,'/','Sqvar_we/Sign'],[60,40;135,40])
add_line([sys,'/','Sqvar_we/Sign'],[95,40;95,100;135,100])
add_line([sys,'/','Sqvar_we/Sign'],[90,115;135,115])
add_line([sys,'/','Sqvar_we/Sign'],[110,115;110,55;135,55])
add_line([sys,'/','Sqvar_we/Sign'],[175,110;185,110;185,85;210,85])
add_line([sys,'/','Sqvar_we/Sign'],[175,50;185,50;185,70;210,70])
add_line([sys,'/','Sqvar_we/Sign'],[240,80;260,80])
set_param([sys,'/','Sqvar_we/Sign'],...
		'Mask Display','plot(-50,-50,50,50,[-50,50],[0,0],[0,0],[-50,50],[-40,0],[-30,-30],[0,40],[30,30])',...
		'Mask Type','Sign',...
		'Mask Dialogue','y = sign(x)')
set_param([sys,'/','Sqvar_we/Sign'],...
		'Mask Help','Sign Function:\n\t\t\ty = 1 if x > 0\n\t\t\ty = 0 if x = 0\n\t\t\ty = -1 if x < 0')


%     Finished composite block 'Sqvar_we/Sign'.

set_param([sys,'/','Sqvar_we/Sign'],...
		'position',[565,127,595,153])


%     Subsystem  'Sqvar_we/Sign1'.

new_system([sys,'/','Sqvar_we/Sign1'])
set_param([sys,'/','Sqvar_we/Sign1'],'Location',[159,417,467,586])

add_block('built-in/Outport',[sys,'/','Sqvar_we/Sign1/out_1'])
set_param([sys,'/','Sqvar_we/Sign1/out_1'],...
		'position',[265,70,285,90])

add_block('built-in/Inport',[sys,'/','Sqvar_we/Sign1/in_1'])
set_param([sys,'/','Sqvar_we/Sign1/in_1'],...
		'position',[35,30,55,50])

add_block('built-in/Relational Operator',[sys,'/',['Sqvar_we/Sign1/Relational',13,'Operator']])
set_param([sys,'/',['Sqvar_we/Sign1/Relational',13,'Operator']],...
		'Operator','>',...
		'position',[140,32,170,63])

add_block('built-in/Sum',[sys,'/','Sqvar_we/Sign1/Sum'])
set_param([sys,'/','Sqvar_we/Sign1/Sum'],...
		'inputs','+-',...
		'position',[215,64,235,91])

add_block('built-in/Relational Operator',[sys,'/',['Sqvar_we/Sign1/Relational',13,'Operator1']])
set_param([sys,'/',['Sqvar_we/Sign1/Relational',13,'Operator1']],...
		'Operator','<',...
		'position',[140,92,170,123])

add_block('built-in/Constant',[sys,'/','Sqvar_we/Sign1/Constant'])
set_param([sys,'/','Sqvar_we/Sign1/Constant'],...
		'Value','0',...
		'position',[65,105,85,125])
add_line([sys,'/','Sqvar_we/Sign1'],[60,40;135,40])
add_line([sys,'/','Sqvar_we/Sign1'],[95,40;95,100;135,100])
add_line([sys,'/','Sqvar_we/Sign1'],[90,115;135,115])
add_line([sys,'/','Sqvar_we/Sign1'],[110,115;110,55;135,55])
add_line([sys,'/','Sqvar_we/Sign1'],[175,110;185,110;185,85;210,85])
add_line([sys,'/','Sqvar_we/Sign1'],[175,50;185,50;185,70;210,70])
add_line([sys,'/','Sqvar_we/Sign1'],[240,80;260,80])
set_param([sys,'/','Sqvar_we/Sign1'],...
		'Mask Display','plot(-50,-50,50,50,[-50,50],[0,0],[0,0],[-50,50],[-40,0],[-30,-30],[0,40],[30,30])',...
		'Mask Type','Sign',...
		'Mask Dialogue','y = sign(x)')
set_param([sys,'/','Sqvar_we/Sign1'],...
		'Mask Help','Sign Function:\n\t\t\ty = 1 if x > 0\n\t\t\ty = 0 if x = 0\n\t\t\ty = -1 if x < 0')


%     Finished composite block 'Sqvar_we/Sign1'.

set_param([sys,'/','Sqvar_we/Sign1'],...
		'position',[560,187,590,213])


%     Subsystem  'Sqvar_we/Sign2'.

new_system([sys,'/','Sqvar_we/Sign2'])
set_param([sys,'/','Sqvar_we/Sign2'],'Location',[159,417,467,586])

add_block('built-in/Outport',[sys,'/','Sqvar_we/Sign2/out_1'])
set_param([sys,'/','Sqvar_we/Sign2/out_1'],...
		'position',[265,70,285,90])

add_block('built-in/Inport',[sys,'/','Sqvar_we/Sign2/in_1'])
set_param([sys,'/','Sqvar_we/Sign2/in_1'],...
		'position',[35,30,55,50])

add_block('built-in/Relational Operator',[sys,'/',['Sqvar_we/Sign2/Relational',13,'Operator']])
set_param([sys,'/',['Sqvar_we/Sign2/Relational',13,'Operator']],...
		'Operator','>',...
		'position',[140,32,170,63])

add_block('built-in/Sum',[sys,'/','Sqvar_we/Sign2/Sum'])
set_param([sys,'/','Sqvar_we/Sign2/Sum'],...
		'inputs','+-',...
		'position',[215,64,235,91])

add_block('built-in/Relational Operator',[sys,'/',['Sqvar_we/Sign2/Relational',13,'Operator1']])
set_param([sys,'/',['Sqvar_we/Sign2/Relational',13,'Operator1']],...
		'Operator','<',...
		'position',[140,92,170,123])

add_block('built-in/Constant',[sys,'/','Sqvar_we/Sign2/Constant'])
set_param([sys,'/','Sqvar_we/Sign2/Constant'],...
		'Value','0',...
		'position',[65,105,85,125])
add_line([sys,'/','Sqvar_we/Sign2'],[60,40;135,40])
add_line([sys,'/','Sqvar_we/Sign2'],[95,40;95,100;135,100])
add_line([sys,'/','Sqvar_we/Sign2'],[90,115;135,115])
add_line([sys,'/','Sqvar_we/Sign2'],[110,115;110,55;135,55])
add_line([sys,'/','Sqvar_we/Sign2'],[175,110;185,110;185,85;210,85])
add_line([sys,'/','Sqvar_we/Sign2'],[175,50;185,50;185,70;210,70])
add_line([sys,'/','Sqvar_we/Sign2'],[240,80;260,80])
set_param([sys,'/','Sqvar_we/Sign2'],...
		'Mask Display','plot(-50,-50,50,50,[-50,50],[0,0],[0,0],[-50,50],[-40,0],[-30,-30],[0,40],[30,30])',...
		'Mask Type','Sign',...
		'Mask Dialogue','y = sign(x)')
set_param([sys,'/','Sqvar_we/Sign2'],...
		'Mask Help','Sign Function:\n\t\t\ty = 1 if x > 0\n\t\t\ty = 0 if x = 0\n\t\t\ty = -1 if x < 0')


%     Finished composite block 'Sqvar_we/Sign2'.

set_param([sys,'/','Sqvar_we/Sign2'],...
		'position',[560,247,590,273])

add_block('built-in/Outport',[sys,'/','Sqvar_we/vag'])
set_param([sys,'/','Sqvar_we/vag'],...
		'position',[715,125,735,145])

add_block('built-in/Outport',[sys,'/','Sqvar_we/vbg'])
set_param([sys,'/','Sqvar_we/vbg'],...
		'Port','2',...
		'position',[710,185,730,205])

add_block('built-in/Outport',[sys,'/','Sqvar_we/vcg'])
set_param([sys,'/','Sqvar_we/vcg'],...
		'Port','3',...
		'position',[715,245,735,265])

add_block('built-in/Fcn',[sys,'/','Sqvar_we/Fcn1'])
set_param([sys,'/','Sqvar_we/Fcn1'],...
		'Expr','(-u[1]-sqrt(3)*u[2])/2',...
		'position',[405,181,525,219])

add_block('built-in/Fcn',[sys,'/','Sqvar_we/Fcn2'])
set_param([sys,'/','Sqvar_we/Fcn2'],...
		'Expr','(-u[1]+sqrt(3)*u[2])/2',...
		'position',[405,243,530,277])

add_block('built-in/Product',[sys,'/','Sqvar_we/Product1'])
set_param([sys,'/','Sqvar_we/Product1'],...
		'position',[650,183,680,207])

add_block('built-in/Product',[sys,'/','Sqvar_we/Product'])
set_param([sys,'/','Sqvar_we/Product'],...
		'position',[645,123,675,147])

add_block('built-in/Product',[sys,'/','Sqvar_we/Product2'])
set_param([sys,'/','Sqvar_we/Product2'],...
		'position',[650,243,680,267])

add_block('built-in/Fcn',[sys,'/','Sqvar_we/Fcn'])
set_param([sys,'/','Sqvar_we/Fcn'],...
		'Expr','u[1]',...
		'position',[410,123,530,157])

add_block('built-in/Mux',[sys,'/','Sqvar_we/Mux'])
set_param([sys,'/','Sqvar_we/Mux'],...
		'inputs','2',...
		'position',[335,129,365,271])

add_block('built-in/Note',[sys,'/','Sqvar_we/cos_wet'])
set_param([sys,'/','Sqvar_we/cos_wet'],...
		'position',[305,129,310,134])

add_block('built-in/Note',[sys,'/','Sqvar_we/sin_wet'])
set_param([sys,'/','Sqvar_we/sin_wet'],...
		'position',[295,206,300,211])

add_block('built-in/Gain',[sys,'/','Sqvar_we/-1'])
set_param([sys,'/','Sqvar_we/-1'],...
		'Gain','-1',...
		'position',[180,258,220,292])

add_block('built-in/Integrator',[sys,'/','Sqvar_we/cos'])
set_param([sys,'/','Sqvar_we/cos'],...
		'Initial','1',...
		'position',[230,145,265,185])


%     Subsystem  ['Sqvar_we/Inner',13,'Product1'].

new_system([sys,'/',['Sqvar_we/Inner',13,'Product1']])
set_param([sys,'/',['Sqvar_we/Inner',13,'Product1']],'Location',[33,479,253,634])

add_block('built-in/Product',[sys,'/',['Sqvar_we/Inner',13,'Product1/Product']])
set_param([sys,'/',['Sqvar_we/Inner',13,'Product1/Product']],...
		'position',[65,55,90,75])

add_block('built-in/Sum',[sys,'/',['Sqvar_we/Inner',13,'Product1/Sum']])
set_param([sys,'/',['Sqvar_we/Inner',13,'Product1/Sum']],...
		'inputs','+',...
		'position',[125,55,145,75])

add_block('built-in/Outport',[sys,'/',['Sqvar_we/Inner',13,'Product1/out_1']])
set_param([sys,'/',['Sqvar_we/Inner',13,'Product1/out_1']],...
		'position',[185,55,205,75])

add_block('built-in/Inport',[sys,'/',['Sqvar_we/Inner',13,'Product1/in_2']])
set_param([sys,'/',['Sqvar_we/Inner',13,'Product1/in_2']],...
		'Port','2',...
		'position',[15,90,35,110])

add_block('built-in/Inport',[sys,'/',['Sqvar_we/Inner',13,'Product1/in_1']])
set_param([sys,'/',['Sqvar_we/Inner',13,'Product1/in_1']],...
		'position',[15,25,35,45])
add_line([sys,'/',['Sqvar_we/Inner',13,'Product1']],[40,100;60,70])
add_line([sys,'/',['Sqvar_we/Inner',13,'Product1']],[40,35;60,60])
add_line([sys,'/',['Sqvar_we/Inner',13,'Product1']],[95,65;120,65])
add_line([sys,'/',['Sqvar_we/Inner',13,'Product1']],[150,65;180,65])
set_param([sys,'/',['Sqvar_we/Inner',13,'Product1']],...
		'Mask Display','.\n',...
		'Mask Type','Dot Product',...
		'Mask Dialogue','Inner (dot) product.\ny=sum(u1.*u2)')
set_param([sys,'/',['Sqvar_we/Inner',13,'Product1']],...
		'Mask Help','Computes the inner (dot) product of the inputs: sum(u1.*u2).  The inputs are vectors of the same length. Output is a scalar.')


%     Finished composite block ['Sqvar_we/Inner',13,'Product1'].

set_param([sys,'/',['Sqvar_we/Inner',13,'Product1']],...
		'position',[165,145,190,180])


%     Subsystem  ['Sqvar_we/Inner',13,'Product'].

new_system([sys,'/',['Sqvar_we/Inner',13,'Product']])
set_param([sys,'/',['Sqvar_we/Inner',13,'Product']],'Location',[33,479,253,634])

add_block('built-in/Product',[sys,'/',['Sqvar_we/Inner',13,'Product/Product']])
set_param([sys,'/',['Sqvar_we/Inner',13,'Product/Product']],...
		'position',[65,55,90,75])

add_block('built-in/Sum',[sys,'/',['Sqvar_we/Inner',13,'Product/Sum']])
set_param([sys,'/',['Sqvar_we/Inner',13,'Product/Sum']],...
		'inputs','+',...
		'position',[125,55,145,75])

add_block('built-in/Outport',[sys,'/',['Sqvar_we/Inner',13,'Product/out_1']])
set_param([sys,'/',['Sqvar_we/Inner',13,'Product/out_1']],...
		'position',[185,55,205,75])

add_block('built-in/Inport',[sys,'/',['Sqvar_we/Inner',13,'Product/in_2']])
set_param([sys,'/',['Sqvar_we/Inner',13,'Product/in_2']],...
		'Port','2',...
		'position',[15,90,35,110])

add_block('built-in/Inport',[sys,'/',['Sqvar_we/Inner',13,'Product/in_1']])
set_param([sys,'/',['Sqvar_we/Inner',13,'Product/in_1']],...
		'position',[15,25,35,45])
add_line([sys,'/',['Sqvar_we/Inner',13,'Product']],[40,100;60,70])
add_line([sys,'/',['Sqvar_we/Inner',13,'Product']],[40,35;60,60])
add_line([sys,'/',['Sqvar_we/Inner',13,'Product']],[95,65;120,65])
add_line([sys,'/',['Sqvar_we/Inner',13,'Product']],[150,65;180,65])
set_param([sys,'/',['Sqvar_we/Inner',13,'Product']],...
		'Mask Display','.\n',...
		'Mask Type','Dot Product',...
		'Mask Dialogue','Inner (dot) product.\ny=sum(u1.*u2)')
set_param([sys,'/',['Sqvar_we/Inner',13,'Product']],...
		'Mask Help','Computes the inner (dot) product of the inputs: sum(u1.*u2).  The inputs are vectors of the same length. Output is a scalar.')


%     Finished composite block ['Sqvar_we/Inner',13,'Product'].

set_param([sys,'/',['Sqvar_we/Inner',13,'Product']],...
		'position',[130,256,155,289])

add_block('built-in/Integrator',[sys,'/','Sqvar_we/sin'])
set_param([sys,'/','Sqvar_we/sin'],...
		'position',[240,256,275,294])

add_block('built-in/Scope',[sys,'/','Sqvar_we/Scope1'])
set_param([sys,'/','Sqvar_we/Scope1'],...
		'Vgain','1.000000',...
		'Hgain','0.300000',...
		'Vmax','1.000000',...
		'Hmax','0.566038',...
		'Window',[165,735,1058,902],...
		'position',[650,66,675,94])

add_block('built-in/Note',[sys,'/','Sqvar_we/Vpksine'])
set_param([sys,'/','Sqvar_we/Vpksine'],...
		'position',[245,60,250,65])

add_block('built-in/Gain',[sys,'/','Sqvar_we/pksine2pksquare'])
set_param([sys,'/','Sqvar_we/pksine2pksquare'],...
		'Gain','pi/4',...
		'position',[290,66,360,104])

add_block('built-in/Inport',[sys,'/','Sqvar_we/we'])
set_param([sys,'/','Sqvar_we/we'],...
		'Port','2',...
		'position',[40,145,60,165])

add_block('built-in/Inport',[sys,'/',['Sqvar_we/pu speed',13,'reference']])
set_param([sys,'/',['Sqvar_we/pu speed',13,'reference']],...
		'position',[35,75,55,95])

add_block('built-in/Look Up Table',[sys,'/','Sqvar_we/Volts//hertz'])
set_param([sys,'/','Sqvar_we/Volts//hertz'],...
		'Input_Values','we_vf',...
		'Output_Values','vrms_vf',...
		'position',[145,63,220,107])

add_block('built-in/Gain',[sys,'/','Sqvar_we/wb'])
set_param([sys,'/','Sqvar_we/wb'],...
		'Gain','wb',...
		'position',[90,71,125,99])
add_line([sys,'/','Sqvar_we'],[225,275;235,275])
add_line([sys,'/','Sqvar_we'],[160,275;175,275])
add_line([sys,'/','Sqvar_we'],[280,275;290,275;290,235;150,235;160,170])
add_line([sys,'/','Sqvar_we'],[195,165;225,165])
add_line([sys,'/','Sqvar_we'],[270,165;280,165;280,125;105,125;105,280;125,280])
add_line([sys,'/','Sqvar_we'],[370,200;380,200;380,140;405,140])
add_line([sys,'/','Sqvar_we'],[370,200;400,200])
add_line([sys,'/','Sqvar_we'],[370,200;380,200;380,260;400,260])
add_line([sys,'/','Sqvar_we'],[530,200;555,200])
add_line([sys,'/','Sqvar_we'],[535,260;555,260])
add_line([sys,'/','Sqvar_we'],[270,165;330,165])
add_line([sys,'/','Sqvar_we'],[280,275;290,275;290,235;330,235])
add_line([sys,'/','Sqvar_we'],[685,255;710,255])
add_line([sys,'/','Sqvar_we'],[685,195;705,195])
add_line([sys,'/','Sqvar_we'],[680,135;710,135])
add_line([sys,'/','Sqvar_we'],[595,260;645,260])
add_line([sys,'/','Sqvar_we'],[595,200;645,200])
add_line([sys,'/','Sqvar_we'],[600,140;640,140])
add_line([sys,'/','Sqvar_we'],[535,140;560,140])
add_line([sys,'/','Sqvar_we'],[225,85;285,85])
add_line([sys,'/','Sqvar_we'],[365,85;610,85;610,130;640,130])
add_line([sys,'/','Sqvar_we'],[365,85;610,85;610,190;645,190])
add_line([sys,'/','Sqvar_we'],[365,85;610,85;610,250;645,250])
add_line([sys,'/','Sqvar_we'],[65,155;160,155])
add_line([sys,'/','Sqvar_we'],[65,155;85,155;85,265;125,265])
add_line([sys,'/','Sqvar_we'],[130,85;140,85])
add_line([sys,'/','Sqvar_we'],[60,85;85,85])


%     Finished composite block 'Sqvar_we'.

set_param([sys,'/','Sqvar_we'],...
		'position',[300,153,345,227])

add_block('built-in/Note',[sys,'/','we'])
set_param([sys,'/','we'],...
		'position',[260,240,265,245])

add_block('built-in/Note',[sys,'/','vbg'])
set_param([sys,'/','vbg'],...
		'position',[367,165,372,170])

add_block('built-in/Note',[sys,'/','vag'])
set_param([sys,'/','vag'],...
		'position',[367,140,372,145])


%     Subsystem  ['induction machine',13,'in stationary qd0'].

new_system([sys,'/',['induction machine',13,'in stationary qd0']])
set_param([sys,'/',['induction machine',13,'in stationary qd0']],'Location',[50,241,804,663])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/Induction Machine Simulation',13,'  in Stationary Reference Frame']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Induction Machine Simulation',13,'  in Stationary Reference Frame']],...
		'position',[570,45,575,50])


%     Subsystem  ['induction machine',13,'in stationary qd0/Qaxis'].

new_system([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],'Location',[213,440,1045,854])

add_block('built-in/Fcn',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Fcn']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Fcn']],...
		'Expr','wb*(u[2]+(rs/xls)*(u[1]-u[3]))',...
		'position',[145,135,310,165])

add_block('built-in/Mux',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Mux']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Mux']],...
		'inputs','3',...
		'position',[100,108,120,192])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/in_vqs']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/in_vqs']],...
		'position',[50,140,70,160])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/out_psiqs']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/out_psiqs']],...
		'position',[735,65,755,85])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/out_iqs']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/out_iqs']],...
		'Port','2',...
		'position',[735,130,755,150])

add_block('built-in/Fcn',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Fcn4']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Fcn4']],...
		'Expr','(u[1]-u[2])/xls',...
		'position',[495,126,585,154])

add_block('built-in/Mux',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Mux4']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Mux4']],...
		'inputs','2',...
		'position',[450,114,470,161])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/iqs']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/iqs']],...
		'position',[600,120,605,125])

add_block('built-in/Integrator',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/psiqs_']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/psiqs_']],...
		'Initial','Psiqso',...
		'position',[335,137,365,163])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/psiqs']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/psiqs']],...
		'position',[380,125,385,130])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/psiqm']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/psiqm']],...
		'position',[665,200,670,205])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/out_iqr''']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/out_iqr''']],...
		'Port','3',...
		'position',[735,305,755,325])

add_block('built-in/Fcn',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Fcn5']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Fcn5']],...
		'Expr','(u[1]-u[2])/xplr',...
		'position',[490,300,585,330])

add_block('built-in/Integrator',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/psiqr''_']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/psiqr''_']],...
		'Initial','Psipqro',...
		'position',[345,287,375,313])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/iqr''']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/iqr''']],...
		'position',[600,292,605,297])

add_block('built-in/Mux',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Mux1']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Mux1']],...
		'inputs','3',...
		'position',[105,262,125,338])

add_block('built-in/Fcn',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Fcn2']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Fcn2']],...
		'Expr','wb*(u[2] +(rpr/xplr)*(u[3]-u[1]))',...
		'position',[145,284,325,316])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/in_(wr//wb)*psidr''']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/in_(wr//wb)*psidr''']],...
		'Port','2',...
		'position',[45,290,65,310])

add_block('built-in/Fcn',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Fcn3']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Fcn3']],...
		'Expr','xM*(u[1]/xls+u[2]/xplr)',...
		'position',[485,207,635,243])

add_block('built-in/Mux',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Mux3']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Mux3']],...
		'inputs','2',...
		'position',[445,193,465,257])

add_block('built-in/Mux',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Mux2']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Mux2']],...
		'inputs','2',...
		'position',[450,286,470,339])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/psiqr''']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/psiqr''']],...
		'position',[390,276,395,281])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/out_psiqr''']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/out_psiqr''']],...
		'Port','4',...
		'position',[735,260,755,280])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[640,225;695,225;695,365;410,365;410,325;445,325])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[380,300;445,300])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[475,315;485,315])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[380,300;415,300;415,240;440,240])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[370,150;405,150;405,210;80,210;80,180;95,180])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[380,300;415,300;415,240;85,240;85,275;100,275])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[130,300;140,300])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[640,225;695,225;695,90;80,90;80,120;95,120])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[640,225;695,225;695,365;75,365;75,325;100,325])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[640,225;695,225;695,180;425,180;425,150;445,150])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[370,150;405,150;405,125;445,125])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[475,140;490,140])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[470,225;480,225])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[370,150;405,150;405,210;440,210])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[330,300;340,300])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[315,150;330,150])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[125,150;140,150])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[590,140;730,140])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[370,150;405,150;405,75;730,75])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[75,150;95,150])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[70,300;100,300])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[590,315;730,315])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[380,300;415,300;415,270;730,270])


%     Finished composite block ['induction machine',13,'in stationary qd0/Qaxis'].

set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],...
		'position',[240,75,275,130])

add_block('built-in/Product',[sys,'/',['induction machine',13,'in stationary qd0/Product']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Product']],...
		'orientation',2,...
		'position',[275,144,295,166])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/iqs']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/iqs']],...
		'position',[285,75,290,80])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/psiqr']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/psiqr']],...
		'position',[290,105,295,110])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/psidr']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/psidr']],...
		'position',[299,280,304,285])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/ids']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/ids']],...
		'position',[290,250,295,255])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/in_vqs']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/in_vqs']],...
		'position',[115,80,135,100])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/vqs']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/vqs']],...
		'position',[190,65,195,70])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/in_vds']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/in_vds']],...
		'Port','2',...
		'position',[115,255,135,275])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/vds']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/vds']],...
		'position',[185,245,190,250])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/out_iqs']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/out_iqs']],...
		'position',[565,85,585,105])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/out_ids']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/out_ids']],...
		'Port','2',...
		'position',[565,260,585,280])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/in_Tmech']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/in_Tmech']],...
		'orientation',2,...
		'Port','4',...
		'position',[450,195,470,215])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/wr//wb']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/wr//wb']],...
		'position',[355,170,360,175])


%     Subsystem  ['induction machine',13,'in stationary qd0/Rotor'].

new_system([sys,'/',['induction machine',13,'in stationary qd0/Rotor']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Rotor']],'Location',[149,82,784,328])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/Rotor/out_Tem']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Rotor/out_Tem']],...
		'position',[540,60,560,80])

add_block('built-in/Sum',[sys,'/',['induction machine',13,'in stationary qd0/Rotor/Taccl']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Rotor/Taccl']],...
		'inputs','++-',...
		'position',[355,95,370,175])

add_block('built-in/Gain',[sys,'/',['induction machine',13,'in stationary qd0/Rotor/1//2H']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Rotor/1//2H']],...
		'Gain','1/(2*H)',...
		'position',[395,109,460,161])

add_block('built-in/Integrator',[sys,'/',['induction machine',13,'in stationary qd0/Rotor/1//s']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Rotor/1//s']],...
		'Initial','wrbywbo',...
		'position',[480,120,510,150])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/Rotor/out_wr//wb']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Rotor/out_wr//wb']],...
		'Port','2',...
		'position',[550,123,570,147])

add_block('built-in/Gain',[sys,'/',['induction machine',13,'in stationary qd0/Rotor/Damping',13,'coefficient']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Rotor/Damping',13,'coefficient']],...
		'orientation',2,...
		'Gain','Domega',...
		'position',[440,177,510,213])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/Rotor/Tdamp']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Rotor/Tdamp']],...
		'position',[405,175,410,180])

add_block('built-in/Fcn',[sys,'/',['induction machine',13,'in stationary qd0/Rotor/Tem_']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Rotor/Tem_']],...
		'Expr','Tfactor*(u[1]*u[2]-u[3]*u[4])',...
		'position',[150,96,310,124])

add_block('built-in/Mux',[sys,'/',['induction machine',13,'in stationary qd0/Rotor/Mux']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Rotor/Mux']],...
		'position',[105,26,130,194])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/Rotor/in_psids']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Rotor/in_psids']],...
		'position',[55,40,75,60])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/Rotor/in_iqs']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Rotor/in_iqs']],...
		'Port','2',...
		'position',[55,80,75,100])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/Rotor/in_psiqs']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Rotor/in_psiqs']],...
		'Port','3',...
		'position',[55,120,75,140])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/Rotor/in_ids']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Rotor/in_ids']],...
		'Port','4',...
		'position',[55,160,75,180])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/Rotor/in_Tmech']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Rotor/in_Tmech']],...
		'Port','5',...
		'position',[55,200,75,220])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Rotor']],[515,135;545,135])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Rotor']],[80,210;310,210;310,135;350,135])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Rotor']],[375,135;390,135])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Rotor']],[465,135;475,135])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Rotor']],[315,110;350,110])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Rotor']],[315,110;325,110;325,70;535,70])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Rotor']],[515,135;530,135;530,195;515,195])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Rotor']],[435,195;330,195;330,160;350,160])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Rotor']],[135,110;145,110])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Rotor']],[80,50;100,50])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Rotor']],[80,90;100,90])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Rotor']],[80,130;100,130])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Rotor']],[80,170;100,170])


%     Finished composite block ['induction machine',13,'in stationary qd0/Rotor'].

set_param([sys,'/',['induction machine',13,'in stationary qd0/Rotor']],...
		'orientation',2,...
		'position',[385,139,425,211])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/Tem']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Tem']],...
		'position',[364,142,369,147])

add_block('built-in/Product',[sys,'/',['induction machine',13,'in stationary qd0/Product1']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Product1']],...
		'orientation',2,...
		'position',[275,188,295,212])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/out_wr//wb']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/out_wr//wb']],...
		'Port','5',...
		'position',[395,225,415,245])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/out_Tem']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/out_Tem']],...
		'Port','4',...
		'position',[405,100,425,120])


%     Subsystem  ['induction machine',13,'in stationary qd0/Zero_seq'].

new_system([sys,'/',['induction machine',13,'in stationary qd0/Zero_seq']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Zero_seq']],'Location',[160,675,612,861])

add_block('built-in/Gain',[sys,'/',['induction machine',13,'in stationary qd0/Zero_seq/rs']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Zero_seq/rs']],...
		'orientation',2,...
		'Gain','rs',...
		'position',[200,122,245,158])

add_block('built-in/Sum',[sys,'/',['induction machine',13,'in stationary qd0/Zero_seq/Sum']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Zero_seq/Sum']],...
		'inputs','+-',...
		'position',[140,59,155,101])

add_block('built-in/Gain',[sys,'/',['induction machine',13,'in stationary qd0/Zero_seq/wb//xls']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Zero_seq/wb//xls']],...
		'Gain','wb/xls',...
		'position',[180,62,240,98])

add_block('built-in/Integrator',[sys,'/',['induction machine',13,'in stationary qd0/Zero_seq/Integrator']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Zero_seq/Integrator']],...
		'position',[265,65,295,95])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/Zero_seq/out_i0s']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Zero_seq/out_i0s']],...
		'position',[365,70,385,90])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/Zero_seq/in_v0s']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Zero_seq/in_v0s']],...
		'position',[55,60,75,80])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Zero_seq']],[195,140;115,140;115,90;135,90])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Zero_seq']],[300,80;310,80;310,140;250,140])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Zero_seq']],[160,80;175,80])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Zero_seq']],[245,80;260,80])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Zero_seq']],[80,70;135,70])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Zero_seq']],[300,80;360,80])


%     Finished composite block ['induction machine',13,'in stationary qd0/Zero_seq'].

set_param([sys,'/',['induction machine',13,'in stationary qd0/Zero_seq']],...
		'position',[395,305,430,355])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/out_i0s']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/out_i0s']],...
		'Port','3',...
		'position',[565,320,585,340])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/in_v0s']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/in_v0s']],...
		'Port','3',...
		'position',[115,320,135,340])


%     Subsystem  ['induction machine',13,'in stationary qd0/Daxis'].

new_system([sys,'/',['induction machine',13,'in stationary qd0/Daxis']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],'Location',[213,440,1045,854])

add_block('built-in/Fcn',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/Fcn']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/Fcn']],...
		'Expr','wb*(u[2]+(rs/xls)*(u[1]-u[3]))',...
		'position',[145,135,310,165])

add_block('built-in/Mux',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/Mux']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/Mux']],...
		'inputs','3',...
		'position',[100,108,120,192])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/in_vds']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/in_vds']],...
		'position',[50,140,70,160])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/out_psids']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/out_psids']],...
		'position',[735,65,755,85])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/out_ids']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/out_ids']],...
		'Port','2',...
		'position',[735,130,755,150])

add_block('built-in/Fcn',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/Fcn4']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/Fcn4']],...
		'Expr','(u[1]-u[2])/xls',...
		'position',[495,126,585,154])

add_block('built-in/Mux',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/Mux4']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/Mux4']],...
		'inputs','2',...
		'position',[450,114,470,161])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/ids']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/ids']],...
		'position',[600,120,605,125])

add_block('built-in/Integrator',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/psids_']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/psids_']],...
		'Initial','Psidso',...
		'position',[335,137,365,163])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/psids']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/psids']],...
		'position',[380,125,385,130])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/psiqm']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/psiqm']],...
		'position',[665,200,670,205])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/out_idr''']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/out_idr''']],...
		'Port','3',...
		'position',[735,305,755,325])

add_block('built-in/Fcn',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/Fcn5']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/Fcn5']],...
		'Expr','(u[1]-u[2])/xplr',...
		'position',[490,300,585,330])

add_block('built-in/Integrator',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/psidr''_']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/psidr''_']],...
		'Initial','Psipdro',...
		'position',[345,287,375,313])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/idr''']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/idr''']],...
		'position',[600,292,605,297])

add_block('built-in/Mux',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/Mux1']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/Mux1']],...
		'inputs','3',...
		'position',[105,262,125,338])

add_block('built-in/Fcn',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/Fcn2']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/Fcn2']],...
		'Expr','wb*(-u[2] +(rpr/xplr)*(u[3]-u[1]))',...
		'position',[145,284,325,316])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/in_(wr//wb)*psiqr''']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/in_(wr//wb)*psiqr''']],...
		'Port','2',...
		'position',[45,290,65,310])

add_block('built-in/Fcn',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/Fcn3']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/Fcn3']],...
		'Expr','xM*(u[1]/xls+u[2]/xplr)',...
		'position',[485,207,635,243])

add_block('built-in/Mux',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/Mux3']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/Mux3']],...
		'inputs','2',...
		'position',[445,193,465,257])

add_block('built-in/Mux',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/Mux2']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/Mux2']],...
		'inputs','2',...
		'position',[450,286,470,339])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/psidr''']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/psidr''']],...
		'position',[390,276,395,281])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/out_psidr''']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/out_psidr''']],...
		'Port','4',...
		'position',[735,260,755,280])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[640,225;695,225;695,365;410,365;410,325;445,325])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[380,300;445,300])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[475,315;485,315])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[380,300;415,300;415,240;440,240])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[370,150;405,150;405,210;80,210;80,180;95,180])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[380,300;415,300;415,240;85,240;85,275;100,275])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[130,300;140,300])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[640,225;695,225;695,90;80,90;80,120;95,120])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[640,225;695,225;695,365;75,365;75,325;100,325])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[640,225;695,225;695,180;425,180;425,150;445,150])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[370,150;405,150;405,125;445,125])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[475,140;490,140])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[470,225;480,225])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[370,150;405,150;405,210;440,210])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[330,300;340,300])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[315,150;330,150])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[125,150;140,150])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[590,140;730,140])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[370,150;405,150;405,75;730,75])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[75,150;95,150])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[70,300;100,300])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[590,315;730,315])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[380,300;415,300;415,270;730,270])


%     Finished composite block ['induction machine',13,'in stationary qd0/Daxis'].

set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],...
		'position',[245,250,280,305])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/i0s']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/i0s']],...
		'position',[455,310,460,315])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/v0s']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/v0s']],...
		'position',[185,305,190,310])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/out_psiqs']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/out_psiqs']],...
		'Port','6',...
		'position',[345,40,365,60])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/out_psids']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/out_psids']],...
		'Port','7',...
		'position',[345,225,365,245])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/psids']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/psids']],...
		'position',[295,230,300,235])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/psiqs']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/psiqs']],...
		'position',[290,55,295,60])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[285,300;325,300;325,205;300,205])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[280,125;320,125;320,150;300,150])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[380,195;300,195])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[380,195;335,195;335,160;300,160])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[285,255;490,255;490,145;430,145])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[270,155;225,155;225,290;240,290])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[280,95;515,95;515,160;430,160])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[280,80;495,80;495,175;430,175])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[270,200;215,200;215,115;235,115])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[285,270;515,270;515,190;430,190])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[380,160;380,110;400,110])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[380,195;390,235])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[445,205;430,205])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[140,90;235,90])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[140,330;390,330])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[140,265;240,265])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[435,330;560,330])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[280,95;560,95])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[285,270;560,270])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[280,80;310,80;310,50;340,50])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[285,255;315,255;315,235;340,235])


%     Finished composite block ['induction machine',13,'in stationary qd0'].

set_param([sys,'/',['induction machine',13,'in stationary qd0']],...
		'position',[500,153,550,287])


%     Subsystem  'm1c'.

new_system([sys,'/','m1c'])
set_param([sys,'/','m1c'],'Location',[220,5570689,280,5570749])

add_block('built-in/Note',[sys,'/',['m1c/Masked block of m1c.m',13,'to initilialize s2c.m',13,'and to plot the results.']])
set_param([sys,'/',['m1c/Masked block of m1c.m',13,'to initilialize s2c.m',13,'and to plot the results.']],...
		'position',[10,17,15,22])
set_param([sys,'/','m1c'],...
		'Mask Display','Initialize\nand plot',...
		'Mask Type','Masked block of m1c.m',...
		'Mask Dialogue','eval(''m1c'')',...
		'Mask Help','Uses m1c.m to initialize and plot')


%     Finished composite block 'm1c'.

set_param([sys,'/','m1c'],...
		'Drop Shadow',4,...
		'position',[33,23,99,57])
add_line(sys,[455,170;495,170])
add_line(sys,[405,70;405,50;450,50])
add_line(sys,[120,85;120,105;180,95])
add_line(sys,[670,160;710,160])
add_line(sys,[670,180;710,180])
add_line(sys,[670,200;710,200])
add_line(sys,[735,180;740,180;740,325;385,325;385,240;400,240])
add_line(sys,[455,205;495,205])
add_line(sys,[555,160;630,160])
add_line(sys,[555,180;630,180])
add_line(sys,[555,200;630,200])
add_line(sys,[125,165;135,165])
add_line(sys,[80,125;90,125;100,155])
add_line(sys,[555,240;585,240;585,315;90,315;100,170])
add_line(sys,[185,260;215,260])
add_line(sys,[555,240;585,240;585,315;145,315;145,265;160,265])
add_line(sys,[195,165;210,165])
add_line(sys,[405,70;405,50;360,50])
add_line(sys,[555,260;625,260])
add_line(sys,[555,280;625,280])
add_line(sys,[655,270;665,270])
add_line(sys,[80,125;255,125;255,95])
add_line(sys,[715,270;745,270;745,105;630,95])
add_line(sys,[455,285;465,285;465,275;495,275])
add_line(sys,[555,220;560,220;560,135;405,135;405,95])
add_line(sys,[555,240;585,240;585,125;480,125;480,95])
add_line(sys,[670,160;675,160;675,115;555,115;555,95])
add_line(sys,[250,165;260,165;260,230;145,230;145,250;160,250])
add_line(sys,[455,240;495,240])
add_line(sys,[350,165;400,165])
add_line(sys,[350,190;400,190])
add_line(sys,[350,215;400,215])
add_line(sys,[350,165;385,165;385,125;330,125;330,95])
add_line(sys,[255,260;280,260;280,210;295,210])
add_line(sys,[80,125;280,125;280,175;295,175])

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
