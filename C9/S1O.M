function [ret,x0,str,ts,xts]=s1o(t,x,u,flag);
%s1o	is the M-file description of the SIMULINK system named s1o.
%	The block-diagram can be displayed by typing: s1o.
%
%	SYS=s1o(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes s1o to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling s1o with a FLAG of zero:
%	[SIZES]=s1o([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[12,77,800,484])
     open_system(sys)
end;
set_param(sys,'algorithm',     'Adams/Gear')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     'tstop')
set_param(sys,'Min step size', '1e-4')
set_param(sys,'Max step size', '1e-2')
set_param(sys,'Relative error','1e-5')
set_param(sys,'Return vars',   '')

add_block('built-in/Sum',[sys,'/','Sum'])
set_param([sys,'/','Sum'],...
		'inputs','+++',...
		'position',[660,216,680,254])

add_block('built-in/Note',[sys,'/','wr//wb'])
set_param([sys,'/','wr//wb'],...
		'position',[400,225,405,230])

add_block('built-in/Note',[sys,'/','Tem'])
set_param([sys,'/','Tem'],...
		'position',[404,197,409,202])

add_block('built-in/Mux',[sys,'/','Mux1'])
set_param([sys,'/','Mux1'],...
		'inputs','2',...
		'position',[395,146,415,179])

add_block('built-in/Fcn',[sys,'/','Fcn1'])
set_param([sys,'/','Fcn1'],...
		'Expr','sqrt(u[1]*u[1]+u[2]*u[2])',...
		'position',[625,125,665,145])

add_block('built-in/Note',[sys,'/','vag'])
set_param([sys,'/','vag'],...
		'position',[107,180,112,185])

add_block('built-in/Note',[sys,'/','vqs'])
set_param([sys,'/','vqs'],...
		'position',[210,185,215,190])

add_block('built-in/Note',[sys,'/','vds'])
set_param([sys,'/','vds'],...
		'position',[210,220,215,225])

add_block('built-in/Note',[sys,'/','v0s'])
set_param([sys,'/','v0s'],...
		'position',[210,255,215,260])


%     Subsystem  'abc2qds'.

new_system([sys,'/','abc2qds'])
set_param([sys,'/','abc2qds'],'Location',[246,146,930,530])

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

add_block('built-in/Fcn',[sys,'/','abc2qds/Fcn1'])
set_param([sys,'/','abc2qds/Fcn1'],...
		'Expr','(u[3]-u[2])/sqrt(3)',...
		'position',[210,150,375,190])

add_block('built-in/Fcn',[sys,'/','abc2qds/Fcn'])
set_param([sys,'/','abc2qds/Fcn'],...
		'Expr','(2/3)*(u[1] - (u[2]+u[3])/2)',...
		'position',[210,86,375,124])

add_block('built-in/Fcn',[sys,'/','abc2qds/Fcn2'])
set_param([sys,'/','abc2qds/Fcn2'],...
		'Expr','(u[1]+u[2]+u[3])/3',...
		'position',[210,215,375,255])

add_block('built-in/Inport',[sys,'/','abc2qds/ias+ibs+ics'])
set_param([sys,'/','abc2qds/ias+ibs+ics'],...
		'Port','4',...
		'position',[40,285,60,305])

add_block('built-in/Outport',[sys,'/','abc2qds/vds'])
set_param([sys,'/','abc2qds/vds'],...
		'Port','2',...
		'position',[515,160,535,180])

add_block('built-in/Sum',[sys,'/','abc2qds/Sum'])
set_param([sys,'/','abc2qds/Sum'],...
		'inputs','+-',...
		'position',[465,223,480,267])

add_block('built-in/Outport',[sys,'/','abc2qds/v0s'])
set_param([sys,'/','abc2qds/v0s'],...
		'Port','3',...
		'position',[515,235,535,255])

add_block('built-in/Sum',[sys,'/','abc2qds/Sum1'])
set_param([sys,'/','abc2qds/Sum1'],...
		'inputs','+-',...
		'position',[465,93,480,137])

add_block('built-in/Outport',[sys,'/','abc2qds/vqs'])
set_param([sys,'/','abc2qds/vqs'],...
		'position',[515,105,535,125])

add_block('built-in/Note',[sys,'/','abc2qds/vsg'])
set_param([sys,'/','abc2qds/vsg'],...
		'position',[410,275,415,280])

add_block('built-in/Integrator',[sys,'/','abc2qds/Integrator'])
set_param([sys,'/','abc2qds/Integrator'],...
		'position',[345,280,375,310])

add_block('built-in/Gain',[sys,'/','abc2qds/1//Csg'])
set_param([sys,'/','abc2qds/1//Csg'],...
		'Gain','50*Zb*wb',...
		'position',[150,274,230,316])
add_line([sys,'/','abc2qds'],[65,295;145,295])
add_line([sys,'/','abc2qds'],[65,110;100,110])
add_line([sys,'/','abc2qds'],[65,170;100,170])
add_line([sys,'/','abc2qds'],[65,230;100,230])
add_line([sys,'/','abc2qds'],[150,170;205,170])
add_line([sys,'/','abc2qds'],[150,170;170,170;170,105;205,105])
add_line([sys,'/','abc2qds'],[380,170;510,170])
add_line([sys,'/','abc2qds'],[150,170;170,170;170,235;205,235])
add_line([sys,'/','abc2qds'],[485,245;510,245])
add_line([sys,'/','abc2qds'],[380,235;460,235])
add_line([sys,'/','abc2qds'],[235,295;340,295])
add_line([sys,'/','abc2qds'],[380,295;425,295;425,255;460,255])
add_line([sys,'/','abc2qds'],[380,105;460,105])
add_line([sys,'/','abc2qds'],[485,115;510,115])
add_line([sys,'/','abc2qds'],[380,295;395,295;395,125;460,125])


%     Finished composite block 'abc2qds'.

set_param([sys,'/','abc2qds'],...
		'position',[145,186,190,289])


%     Subsystem  'Var_we_source'.

new_system([sys,'/','Var_we_source'])
set_param([sys,'/','Var_we_source'],'Location',[209,82,897,440])

add_block('built-in/Note',[sys,'/','Var_we_source/variable frequency oscillator'])
set_param([sys,'/','Var_we_source/variable frequency oscillator'],...
		'position',[200,300,205,305])

add_block('built-in/Constant',[sys,'/','Var_we_source/we'])
set_param([sys,'/','Var_we_source/we'],...
		'Value','we',...
		'position',[65,118,90,152])

add_block('built-in/Note',[sys,'/','Var_we_source/Vpk'])
set_param([sys,'/','Var_we_source/Vpk'],...
		'position',[325,50,330,55])

add_block('built-in/Constant',[sys,'/','Var_we_source/Vb'])
set_param([sys,'/','Var_we_source/Vb'],...
		'Value','Vb',...
		'position',[275,59,305,91])

add_block('built-in/Note',[sys,'/','Var_we_source/2-phase to 3-phase '])
set_param([sys,'/','Var_we_source/2-phase to 3-phase '],...
		'position',[510,300,515,305])

add_block('built-in/Outport',[sys,'/','Var_we_source/vbg'])
set_param([sys,'/','Var_we_source/vbg'],...
		'Port','2',...
		'position',[630,135,650,155])

add_block('built-in/Fcn',[sys,'/','Var_we_source/Fcn1'])
set_param([sys,'/','Var_we_source/Fcn1'],...
		'Expr','u[1]*(-u[2]-sqrt(3)*u[3])/2',...
		'position',[425,128,580,162])

add_block('built-in/Outport',[sys,'/','Var_we_source/vag'])
set_param([sys,'/','Var_we_source/vag'],...
		'position',[630,75,650,95])

add_block('built-in/Fcn',[sys,'/','Var_we_source/Fcn2'])
set_param([sys,'/','Var_we_source/Fcn2'],...
		'Expr','u[1]*(-u[2]+sqrt(3)*u[3])/2',...
		'position',[425,190,580,220])

add_block('built-in/Outport',[sys,'/','Var_we_source/vcg'])
set_param([sys,'/','Var_we_source/vcg'],...
		'Port','3',...
		'position',[630,195,650,215])

add_block('built-in/Fcn',[sys,'/','Var_we_source/Fcn'])
set_param([sys,'/','Var_we_source/Fcn'],...
		'Expr','u[1]*u[2]',...
		'position',[425,68,575,102])

add_block('built-in/Mux',[sys,'/','Var_we_source/Mux'])
set_param([sys,'/','Var_we_source/Mux'],...
		'inputs','3',...
		'position',[355,42,380,248])

add_block('built-in/Note',[sys,'/','Var_we_source/-sin_wet'])
set_param([sys,'/','Var_we_source/-sin_wet'],...
		'position',[300,186,305,191])

add_block('built-in/Note',[sys,'/','Var_we_source/cos_wet'])
set_param([sys,'/','Var_we_source/cos_wet'],...
		'position',[315,114,320,119])

add_block('built-in/Gain',[sys,'/','Var_we_source/-1'])
set_param([sys,'/','Var_we_source/-1'],...
		'Gain','-1',...
		'position',[185,238,225,272])

add_block('built-in/Integrator',[sys,'/','Var_we_source/cos'])
set_param([sys,'/','Var_we_source/cos'],...
		'Initial','1',...
		'position',[235,125,270,165])


%     Subsystem  ['Var_we_source/Inner',13,'Product1'].

new_system([sys,'/',['Var_we_source/Inner',13,'Product1']])
set_param([sys,'/',['Var_we_source/Inner',13,'Product1']],'Location',[33,479,253,634])

add_block('built-in/Product',[sys,'/',['Var_we_source/Inner',13,'Product1/Product']])
set_param([sys,'/',['Var_we_source/Inner',13,'Product1/Product']],...
		'position',[65,55,90,75])

add_block('built-in/Sum',[sys,'/',['Var_we_source/Inner',13,'Product1/Sum']])
set_param([sys,'/',['Var_we_source/Inner',13,'Product1/Sum']],...
		'inputs','+',...
		'position',[125,55,145,75])

add_block('built-in/Outport',[sys,'/',['Var_we_source/Inner',13,'Product1/out_1']])
set_param([sys,'/',['Var_we_source/Inner',13,'Product1/out_1']],...
		'position',[185,55,205,75])

add_block('built-in/Inport',[sys,'/',['Var_we_source/Inner',13,'Product1/in_2']])
set_param([sys,'/',['Var_we_source/Inner',13,'Product1/in_2']],...
		'Port','2',...
		'position',[15,90,35,110])

add_block('built-in/Inport',[sys,'/',['Var_we_source/Inner',13,'Product1/in_1']])
set_param([sys,'/',['Var_we_source/Inner',13,'Product1/in_1']],...
		'position',[15,25,35,45])
add_line([sys,'/',['Var_we_source/Inner',13,'Product1']],[40,100;60,70])
add_line([sys,'/',['Var_we_source/Inner',13,'Product1']],[40,35;60,60])
add_line([sys,'/',['Var_we_source/Inner',13,'Product1']],[95,65;120,65])
add_line([sys,'/',['Var_we_source/Inner',13,'Product1']],[150,65;180,65])
set_param([sys,'/',['Var_we_source/Inner',13,'Product1']],...
		'Mask Display','.\n',...
		'Mask Type','Dot Product',...
		'Mask Dialogue','Inner (dot) product.\ny=sum(u1.*u2)')
set_param([sys,'/',['Var_we_source/Inner',13,'Product1']],...
		'Mask Help','Computes the inner (dot) product of the inputs: sum(u1.*u2).  The inputs are vectors of the same length. Output is a scalar.')


%     Finished composite block ['Var_we_source/Inner',13,'Product1'].

set_param([sys,'/',['Var_we_source/Inner',13,'Product1']],...
		'position',[170,125,195,160])


%     Subsystem  ['Var_we_source/Inner',13,'Product'].

new_system([sys,'/',['Var_we_source/Inner',13,'Product']])
set_param([sys,'/',['Var_we_source/Inner',13,'Product']],'Location',[33,479,253,634])

add_block('built-in/Product',[sys,'/',['Var_we_source/Inner',13,'Product/Product']])
set_param([sys,'/',['Var_we_source/Inner',13,'Product/Product']],...
		'position',[65,55,90,75])

add_block('built-in/Sum',[sys,'/',['Var_we_source/Inner',13,'Product/Sum']])
set_param([sys,'/',['Var_we_source/Inner',13,'Product/Sum']],...
		'inputs','+',...
		'position',[125,55,145,75])

add_block('built-in/Outport',[sys,'/',['Var_we_source/Inner',13,'Product/out_1']])
set_param([sys,'/',['Var_we_source/Inner',13,'Product/out_1']],...
		'position',[185,55,205,75])

add_block('built-in/Inport',[sys,'/',['Var_we_source/Inner',13,'Product/in_2']])
set_param([sys,'/',['Var_we_source/Inner',13,'Product/in_2']],...
		'Port','2',...
		'position',[15,90,35,110])

add_block('built-in/Inport',[sys,'/',['Var_we_source/Inner',13,'Product/in_1']])
set_param([sys,'/',['Var_we_source/Inner',13,'Product/in_1']],...
		'position',[15,25,35,45])
add_line([sys,'/',['Var_we_source/Inner',13,'Product']],[40,100;60,70])
add_line([sys,'/',['Var_we_source/Inner',13,'Product']],[40,35;60,60])
add_line([sys,'/',['Var_we_source/Inner',13,'Product']],[95,65;120,65])
add_line([sys,'/',['Var_we_source/Inner',13,'Product']],[150,65;180,65])
set_param([sys,'/',['Var_we_source/Inner',13,'Product']],...
		'Mask Display','.\n',...
		'Mask Type','Dot Product',...
		'Mask Dialogue','Inner (dot) product.\ny=sum(u1.*u2)')
set_param([sys,'/',['Var_we_source/Inner',13,'Product']],...
		'Mask Help','Computes the inner (dot) product of the inputs: sum(u1.*u2).  The inputs are vectors of the same length. Output is a scalar.')


%     Finished composite block ['Var_we_source/Inner',13,'Product'].

set_param([sys,'/',['Var_we_source/Inner',13,'Product']],...
		'position',[135,236,160,269])

add_block('built-in/Integrator',[sys,'/','Var_we_source/sin'])
set_param([sys,'/','Var_we_source/sin'],...
		'position',[245,236,280,274])
add_line([sys,'/','Var_we_source'],[95,135;165,135])
add_line([sys,'/','Var_we_source'],[95,135;120,135;130,245])
add_line([sys,'/','Var_we_source'],[230,255;240,255])
add_line([sys,'/','Var_we_source'],[165,255;180,255])
add_line([sys,'/','Var_we_source'],[285,255;295,255;295,215;155,215;165,150])
add_line([sys,'/','Var_we_source'],[200,145;230,145])
add_line([sys,'/','Var_we_source'],[275,145;285,145;285,105;110,105;110,260;130,260])
add_line([sys,'/','Var_we_source'],[275,145;350,145])
add_line([sys,'/','Var_we_source'],[285,255;295,255;295,215;350,215])
add_line([sys,'/','Var_we_source'],[580,85;625,85])
add_line([sys,'/','Var_we_source'],[585,145;625,145])
add_line([sys,'/','Var_we_source'],[585,205;625,205])
add_line([sys,'/','Var_we_source'],[385,145;395,145;395,85;420,85])
add_line([sys,'/','Var_we_source'],[385,145;420,145])
add_line([sys,'/','Var_we_source'],[385,145;395,145;395,205;420,205])
add_line([sys,'/','Var_we_source'],[310,75;350,75])


%     Finished composite block 'Var_we_source'.

set_param([sys,'/','Var_we_source'],...
		'position',[35,188,80,262])

add_block('built-in/Note',[sys,'/','vcg'])
set_param([sys,'/','vcg'],...
		'position',[107,235,112,240])

add_block('built-in/Note',[sys,'/','vbg'])
set_param([sys,'/','vbg'],...
		'position',[107,210,112,215])


%     Subsystem  'Rotor'.

new_system([sys,'/','Rotor'])
set_param([sys,'/','Rotor'],'Location',[330,112,965,358])

add_block('built-in/Sum',[sys,'/','Rotor/Sum1'])
set_param([sys,'/','Rotor/Sum1'],...
		'position',[355,90,375,170])

add_block('built-in/Gain',[sys,'/','Rotor/wb//2H'])
set_param([sys,'/','Rotor/wb//2H'],...
		'Gain','1/(2*H)',...
		'position',[390,104,455,156])

add_block('built-in/Integrator',[sys,'/','Rotor/1//s'])
set_param([sys,'/','Rotor/1//s'],...
		'position',[480,113,515,147])

add_block('built-in/Outport',[sys,'/','Rotor/wr//wb'])
set_param([sys,'/','Rotor/wr//wb'],...
		'Port','2',...
		'position',[545,118,565,142])

add_block('built-in/Inport',[sys,'/','Rotor/Tmech'])
set_param([sys,'/','Rotor/Tmech'],...
		'Port','5',...
		'position',[65,200,85,220])

add_block('built-in/Inport',[sys,'/','Rotor/ids'])
set_param([sys,'/','Rotor/ids'],...
		'Port','4',...
		'position',[65,160,85,180])

add_block('built-in/Inport',[sys,'/','Rotor/psiqs'])
set_param([sys,'/','Rotor/psiqs'],...
		'Port','3',...
		'position',[65,120,85,140])

add_block('built-in/Inport',[sys,'/','Rotor/iqs'])
set_param([sys,'/','Rotor/iqs'],...
		'Port','2',...
		'position',[65,80,85,100])

add_block('built-in/Inport',[sys,'/','Rotor/psids'])
set_param([sys,'/','Rotor/psids'],...
		'position',[65,40,85,60])

add_block('built-in/Product',[sys,'/','Rotor/psiqids'])
set_param([sys,'/','Rotor/psiqids'],...
		'position',[120,126,140,159])

add_block('built-in/Product',[sys,'/','Rotor/psidiqs'])
set_param([sys,'/','Rotor/psidiqs'],...
		'position',[120,50,140,85])

add_block('built-in/Sum',[sys,'/','Rotor/Sum'])
set_param([sys,'/','Rotor/Sum'],...
		'inputs','+-',...
		'position',[175,83,195,132])

add_block('built-in/Note',[sys,'/',['Rotor/Rotor''s Equation of Motion']])
set_param([sys,'/',['Rotor/Rotor''s Equation of Motion']],...
		'position',[275,40,280,45])

add_block('built-in/Outport',[sys,'/','Rotor/Tem_out'])
set_param([sys,'/','Rotor/Tem_out'],...
		'position',[540,60,560,80])

add_block('built-in/Gain',[sys,'/','Rotor/3P//4wb'])
set_param([sys,'/','Rotor/3P//4wb'],...
		'Gain','3*P/(4*wb)',...
		'position',[225,81,315,139])
add_line([sys,'/','Rotor'],[200,110;220,110])
add_line([sys,'/','Rotor'],[90,130;95,130;95,135;115,135])
add_line([sys,'/','Rotor'],[90,90;95,90;95,75;115,75])
add_line([sys,'/','Rotor'],[90,50;95,50;95,60;115,60])
add_line([sys,'/','Rotor'],[145,70;160,70;170,95])
add_line([sys,'/','Rotor'],[145,145;160,145;170,120])
add_line([sys,'/','Rotor'],[520,130;540,130])
add_line([sys,'/','Rotor'],[90,210;300,210;300,150;350,150])
add_line([sys,'/','Rotor'],[90,170;95,170;95,150;115,150])
add_line([sys,'/','Rotor'],[380,130;385,130])
add_line([sys,'/','Rotor'],[460,130;475,130])
add_line([sys,'/','Rotor'],[320,110;350,110])
add_line([sys,'/','Rotor'],[320,110;325,110;325,70;535,70])


%     Finished composite block 'Rotor'.

set_param([sys,'/','Rotor'],...
		'orientation',2,...
		'position',[430,189,470,261])


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
		'position',[595,192,620,258])

add_block('built-in/Product',[sys,'/','Product'])
set_param([sys,'/','Product'],...
		'orientation',2,...
		'position',[320,189,340,211])

add_block('built-in/Product',[sys,'/','Product1'])
set_param([sys,'/','Product1'],...
		'orientation',2,...
		'position',[320,238,340,262])


%     Subsystem  'Zero_seq'.

new_system([sys,'/','Zero_seq'])
set_param([sys,'/','Zero_seq'],'Location',[160,675,612,861])

add_block('built-in/Gain',[sys,'/','Zero_seq/rs'])
set_param([sys,'/','Zero_seq/rs'],...
		'orientation',2,...
		'Gain','rs',...
		'position',[200,122,245,158])

add_block('built-in/Sum',[sys,'/','Zero_seq/Sum'])
set_param([sys,'/','Zero_seq/Sum'],...
		'inputs','+-',...
		'position',[140,60,165,100])

add_block('built-in/Gain',[sys,'/','Zero_seq/wb//xls'])
set_param([sys,'/','Zero_seq/wb//xls'],...
		'Gain','wb/xls',...
		'position',[200,64,240,96])

add_block('built-in/Integrator',[sys,'/','Zero_seq/Integrator'])
set_param([sys,'/','Zero_seq/Integrator'],...
		'position',[265,65,295,95])

add_block('built-in/Note',[sys,'/',['Zero_seq/Stator''s zero-sequence circuit']])
set_param([sys,'/',['Zero_seq/Stator''s zero-sequence circuit']],...
		'position',[225,20,230,25])

add_block('built-in/Outport',[sys,'/','Zero_seq/i0s'])
set_param([sys,'/','Zero_seq/i0s'],...
		'position',[365,70,385,90])

add_block('built-in/Inport',[sys,'/','Zero_seq/v0s'])
set_param([sys,'/','Zero_seq/v0s'],...
		'position',[55,60,75,80])
add_line([sys,'/','Zero_seq'],[195,140;115,140;115,90;135,90])
add_line([sys,'/','Zero_seq'],[300,80;310,80;310,140;250,140])
add_line([sys,'/','Zero_seq'],[170,80;195,80])
add_line([sys,'/','Zero_seq'],[245,80;260,80])
add_line([sys,'/','Zero_seq'],[80,70;135,70])
add_line([sys,'/','Zero_seq'],[300,80;360,80])


%     Finished composite block 'Zero_seq'.

set_param([sys,'/','Zero_seq'],...
		'position',[400,338,430,382])

add_block('built-in/Clock',[sys,'/','Clock'])
set_param([sys,'/','Clock'],...
		'position',[75,72,90,88])


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

add_block('built-in/Fcn',[sys,'/','Fcn'])
set_param([sys,'/','Fcn'],...
		'Expr','sqrt(u[1]*u[1]+u[2]*u[2])',...
		'position',[435,155,475,175])

add_block('built-in/Mux',[sys,'/','Mux2'])
set_param([sys,'/','Mux2'],...
		'inputs','2',...
		'position',[585,115,605,155])

add_block('built-in/Scope',[sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'Vgain','200.000000',...
		'Hgain','2.000000',...
		'Vmax','400.000000',...
		'Hmax','4.000000',...
		'Window',[20,500,816,625])
open_system([sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'position',[465,14,480,36])

add_block('built-in/To Workspace',[sys,'/','To Workspace'])
set_param([sys,'/','To Workspace'],...
		'orientation',2,...
		'mat-name','y',...
		'buffer','40000',...
		'position',[240,19,290,31])

add_block('built-in/Mux',[sys,'/','Mux'])
set_param([sys,'/','Mux'],...
		'orientation',3,...
		'inputs','7',...
		'position',[88,50,642,65])


%     Subsystem  'Qaxis'.

new_system([sys,'/','Qaxis'])
set_param([sys,'/','Qaxis'],'Location',[213,440,1045,854])

add_block('built-in/Fcn',[sys,'/','Qaxis/Fcn'])
set_param([sys,'/','Qaxis/Fcn'],...
		'Expr','wb*(u[2]+(rs/xls)*(u[1]-u[3]))',...
		'position',[145,135,310,165])

add_block('built-in/Mux',[sys,'/','Qaxis/Mux'])
set_param([sys,'/','Qaxis/Mux'],...
		'inputs','3',...
		'position',[100,108,120,192])

add_block('built-in/Inport',[sys,'/','Qaxis/in_vqs'])
set_param([sys,'/','Qaxis/in_vqs'],...
		'position',[50,140,70,160])

add_block('built-in/Outport',[sys,'/','Qaxis/out_psiqs'])
set_param([sys,'/','Qaxis/out_psiqs'],...
		'position',[735,65,755,85])

add_block('built-in/Outport',[sys,'/','Qaxis/out_iqs'])
set_param([sys,'/','Qaxis/out_iqs'],...
		'Port','2',...
		'position',[735,130,755,150])

add_block('built-in/Fcn',[sys,'/','Qaxis/Fcn4'])
set_param([sys,'/','Qaxis/Fcn4'],...
		'Expr','(u[1]-u[2])/xls',...
		'position',[495,126,585,154])

add_block('built-in/Mux',[sys,'/','Qaxis/Mux4'])
set_param([sys,'/','Qaxis/Mux4'],...
		'inputs','2',...
		'position',[450,114,470,161])

add_block('built-in/Note',[sys,'/','Qaxis/iqs'])
set_param([sys,'/','Qaxis/iqs'],...
		'position',[600,120,605,125])

add_block('built-in/Integrator',[sys,'/','Qaxis/psiqs_'])
set_param([sys,'/','Qaxis/psiqs_'],...
		'Initial','Psiqso',...
		'position',[335,137,365,163])

add_block('built-in/Note',[sys,'/','Qaxis/psiqs'])
set_param([sys,'/','Qaxis/psiqs'],...
		'position',[380,125,385,130])

add_block('built-in/Note',[sys,'/','Qaxis/psiqm'])
set_param([sys,'/','Qaxis/psiqm'],...
		'position',[665,200,670,205])

add_block('built-in/Outport',[sys,'/',['Qaxis/out_iqr''']])
set_param([sys,'/',['Qaxis/out_iqr''']],...
		'Port','3',...
		'position',[735,305,755,325])

add_block('built-in/Fcn',[sys,'/','Qaxis/Fcn5'])
set_param([sys,'/','Qaxis/Fcn5'],...
		'Expr','(u[1]-u[2])/xplr',...
		'position',[490,300,585,330])

add_block('built-in/Integrator',[sys,'/',['Qaxis/psiqr''_']])
set_param([sys,'/',['Qaxis/psiqr''_']],...
		'Initial','Psipqro',...
		'position',[345,287,375,313])

add_block('built-in/Note',[sys,'/',['Qaxis/iqr''']])
set_param([sys,'/',['Qaxis/iqr''']],...
		'position',[600,292,605,297])

add_block('built-in/Mux',[sys,'/','Qaxis/Mux1'])
set_param([sys,'/','Qaxis/Mux1'],...
		'inputs','3',...
		'position',[105,262,125,338])

add_block('built-in/Fcn',[sys,'/','Qaxis/Fcn2'])
set_param([sys,'/','Qaxis/Fcn2'],...
		'Expr','wb*(u[2] +(rpr/xplr)*(u[3]-u[1]))',...
		'position',[145,284,325,316])

add_block('built-in/Inport',[sys,'/',['Qaxis/in_(wr//wb)*psidr''']])
set_param([sys,'/',['Qaxis/in_(wr//wb)*psidr''']],...
		'Port','2',...
		'position',[45,290,65,310])

add_block('built-in/Fcn',[sys,'/','Qaxis/Fcn3'])
set_param([sys,'/','Qaxis/Fcn3'],...
		'Expr','xM*(u[1]/xls+u[2]/xplr)',...
		'position',[485,207,635,243])

add_block('built-in/Mux',[sys,'/','Qaxis/Mux3'])
set_param([sys,'/','Qaxis/Mux3'],...
		'inputs','2',...
		'position',[445,193,465,257])

add_block('built-in/Mux',[sys,'/','Qaxis/Mux2'])
set_param([sys,'/','Qaxis/Mux2'],...
		'inputs','2',...
		'position',[450,286,470,339])

add_block('built-in/Note',[sys,'/',['Qaxis/psiqr''']])
set_param([sys,'/',['Qaxis/psiqr''']],...
		'position',[390,276,395,281])

add_block('built-in/Outport',[sys,'/',['Qaxis/out_psiqr''']])
set_param([sys,'/',['Qaxis/out_psiqr''']],...
		'Port','4',...
		'position',[735,260,755,280])
add_line([sys,'/','Qaxis'],[640,225;695,225;695,365;410,365;410,325;445,325])
add_line([sys,'/','Qaxis'],[380,300;445,300])
add_line([sys,'/','Qaxis'],[475,315;485,315])
add_line([sys,'/','Qaxis'],[380,300;415,300;415,240;440,240])
add_line([sys,'/','Qaxis'],[370,150;405,150;405,210;80,210;80,180;95,180])
add_line([sys,'/','Qaxis'],[380,300;415,300;415,240;85,240;85,275;100,275])
add_line([sys,'/','Qaxis'],[130,300;140,300])
add_line([sys,'/','Qaxis'],[640,225;695,225;695,90;80,90;80,120;95,120])
add_line([sys,'/','Qaxis'],[640,225;695,225;695,365;75,365;75,325;100,325])
add_line([sys,'/','Qaxis'],[640,225;695,225;695,180;425,180;425,150;445,150])
add_line([sys,'/','Qaxis'],[370,150;405,150;405,125;445,125])
add_line([sys,'/','Qaxis'],[475,140;490,140])
add_line([sys,'/','Qaxis'],[470,225;480,225])
add_line([sys,'/','Qaxis'],[370,150;405,150;405,210;440,210])
add_line([sys,'/','Qaxis'],[330,300;340,300])
add_line([sys,'/','Qaxis'],[315,150;330,150])
add_line([sys,'/','Qaxis'],[125,150;140,150])
add_line([sys,'/','Qaxis'],[590,140;730,140])
add_line([sys,'/','Qaxis'],[370,150;405,150;405,75;730,75])
add_line([sys,'/','Qaxis'],[75,150;95,150])
add_line([sys,'/','Qaxis'],[70,300;100,300])
add_line([sys,'/','Qaxis'],[590,315;730,315])
add_line([sys,'/','Qaxis'],[380,300;415,300;415,270;730,270])


%     Finished composite block 'Qaxis'.

set_param([sys,'/','Qaxis'],...
		'position',[285,120,320,175])


%     Subsystem  'Daxis'.

new_system([sys,'/','Daxis'])
set_param([sys,'/','Daxis'],'Location',[213,440,1045,854])

add_block('built-in/Fcn',[sys,'/','Daxis/Fcn'])
set_param([sys,'/','Daxis/Fcn'],...
		'Expr','wb*(u[2]+(rs/xls)*(u[1]-u[3]))',...
		'position',[145,135,310,165])

add_block('built-in/Mux',[sys,'/','Daxis/Mux'])
set_param([sys,'/','Daxis/Mux'],...
		'inputs','3',...
		'position',[100,108,120,192])

add_block('built-in/Inport',[sys,'/','Daxis/in_vds'])
set_param([sys,'/','Daxis/in_vds'],...
		'position',[50,140,70,160])

add_block('built-in/Outport',[sys,'/','Daxis/out_psids'])
set_param([sys,'/','Daxis/out_psids'],...
		'position',[735,65,755,85])

add_block('built-in/Outport',[sys,'/','Daxis/out_ids'])
set_param([sys,'/','Daxis/out_ids'],...
		'Port','2',...
		'position',[735,130,755,150])

add_block('built-in/Fcn',[sys,'/','Daxis/Fcn4'])
set_param([sys,'/','Daxis/Fcn4'],...
		'Expr','(u[1]-u[2])/xls',...
		'position',[495,126,585,154])

add_block('built-in/Mux',[sys,'/','Daxis/Mux4'])
set_param([sys,'/','Daxis/Mux4'],...
		'inputs','2',...
		'position',[450,114,470,161])

add_block('built-in/Note',[sys,'/','Daxis/ids'])
set_param([sys,'/','Daxis/ids'],...
		'position',[600,120,605,125])

add_block('built-in/Integrator',[sys,'/','Daxis/psids_'])
set_param([sys,'/','Daxis/psids_'],...
		'Initial','Psidso',...
		'position',[335,137,365,163])

add_block('built-in/Note',[sys,'/','Daxis/psids'])
set_param([sys,'/','Daxis/psids'],...
		'position',[380,125,385,130])

add_block('built-in/Note',[sys,'/','Daxis/psiqm'])
set_param([sys,'/','Daxis/psiqm'],...
		'position',[665,200,670,205])

add_block('built-in/Outport',[sys,'/',['Daxis/out_idr''']])
set_param([sys,'/',['Daxis/out_idr''']],...
		'Port','3',...
		'position',[735,305,755,325])

add_block('built-in/Fcn',[sys,'/','Daxis/Fcn5'])
set_param([sys,'/','Daxis/Fcn5'],...
		'Expr','(u[1]-u[2])/xplr',...
		'position',[490,300,585,330])

add_block('built-in/Integrator',[sys,'/',['Daxis/psidr''_']])
set_param([sys,'/',['Daxis/psidr''_']],...
		'Initial','Psipdro',...
		'position',[345,287,375,313])

add_block('built-in/Note',[sys,'/',['Daxis/idr''']])
set_param([sys,'/',['Daxis/idr''']],...
		'position',[600,292,605,297])

add_block('built-in/Mux',[sys,'/','Daxis/Mux1'])
set_param([sys,'/','Daxis/Mux1'],...
		'inputs','3',...
		'position',[105,262,125,338])

add_block('built-in/Fcn',[sys,'/','Daxis/Fcn2'])
set_param([sys,'/','Daxis/Fcn2'],...
		'Expr','wb*(-u[2] +(rpr/xplr)*(u[3]-u[1]))',...
		'position',[145,284,325,316])

add_block('built-in/Inport',[sys,'/',['Daxis/in_(wr//wb)*psiqr''']])
set_param([sys,'/',['Daxis/in_(wr//wb)*psiqr''']],...
		'Port','2',...
		'position',[45,290,65,310])

add_block('built-in/Fcn',[sys,'/','Daxis/Fcn3'])
set_param([sys,'/','Daxis/Fcn3'],...
		'Expr','xM*(u[1]/xls+u[2]/xplr)',...
		'position',[485,207,635,243])

add_block('built-in/Mux',[sys,'/','Daxis/Mux3'])
set_param([sys,'/','Daxis/Mux3'],...
		'inputs','2',...
		'position',[445,193,465,257])

add_block('built-in/Mux',[sys,'/','Daxis/Mux2'])
set_param([sys,'/','Daxis/Mux2'],...
		'inputs','2',...
		'position',[450,286,470,339])

add_block('built-in/Note',[sys,'/',['Daxis/psidr''']])
set_param([sys,'/',['Daxis/psidr''']],...
		'position',[390,276,395,281])

add_block('built-in/Outport',[sys,'/',['Daxis/out_psidr''']])
set_param([sys,'/',['Daxis/out_psidr''']],...
		'Port','4',...
		'position',[735,260,755,280])
add_line([sys,'/','Daxis'],[640,225;695,225;695,365;410,365;410,325;445,325])
add_line([sys,'/','Daxis'],[380,300;445,300])
add_line([sys,'/','Daxis'],[475,315;485,315])
add_line([sys,'/','Daxis'],[380,300;415,300;415,240;440,240])
add_line([sys,'/','Daxis'],[370,150;405,150;405,210;80,210;80,180;95,180])
add_line([sys,'/','Daxis'],[380,300;415,300;415,240;85,240;85,275;100,275])
add_line([sys,'/','Daxis'],[130,300;140,300])
add_line([sys,'/','Daxis'],[640,225;695,225;695,90;80,90;80,120;95,120])
add_line([sys,'/','Daxis'],[640,225;695,225;695,365;75,365;75,325;100,325])
add_line([sys,'/','Daxis'],[640,225;695,225;695,180;425,180;425,150;445,150])
add_line([sys,'/','Daxis'],[370,150;405,150;405,125;445,125])
add_line([sys,'/','Daxis'],[475,140;490,140])
add_line([sys,'/','Daxis'],[470,225;480,225])
add_line([sys,'/','Daxis'],[370,150;405,150;405,210;440,210])
add_line([sys,'/','Daxis'],[330,300;340,300])
add_line([sys,'/','Daxis'],[315,150;330,150])
add_line([sys,'/','Daxis'],[125,150;140,150])
add_line([sys,'/','Daxis'],[590,140;730,140])
add_line([sys,'/','Daxis'],[370,150;405,150;405,75;730,75])
add_line([sys,'/','Daxis'],[75,150;95,150])
add_line([sys,'/','Daxis'],[70,300;100,300])
add_line([sys,'/','Daxis'],[590,315;730,315])
add_line([sys,'/','Daxis'],[380,300;415,300;415,270;730,270])


%     Finished composite block 'Daxis'.

set_param([sys,'/','Daxis'],...
		'position',[290,295,325,350])

add_block('built-in/Note',[sys,'/','i0s'])
set_param([sys,'/','i0s'],...
		'position',[495,340,500,345])

add_block('built-in/Note',[sys,'/','ias'])
set_param([sys,'/','ias'],...
		'position',[655,185,660,190])

add_block('built-in/Note',[sys,'/','psir'])
set_param([sys,'/','psir'],...
		'position',[465,70,470,75])

add_block('built-in/Note',[sys,'/','psis'])
set_param([sys,'/','psis'],...
		'position',[560,80,565,85])


%     Subsystem  'm1o'.

new_system([sys,'/','m1o'])
set_param([sys,'/','m1o'],'Location',[55,5046512,160,5046594])

add_block('built-in/Note',[sys,'/',['m1o/masked block of m1o.m',13,'to initilialize s1o.m',13,'and to plot the results.']])
set_param([sys,'/',['m1o/masked block of m1o.m',13,'to initilialize s1o.m',13,'and to plot the results.']],...
		'position',[65,42,70,47])
set_param([sys,'/','m1o'],...
		'Mask Display','Initialize\nand plot',...
		'Mask Type','Masked block of m1o.m',...
		'Mask Dialogue','eval(''m1o'')',...
		'Mask Help','Uses m1o.m to initialize and plot')


%     Finished composite block 'm1o'.

set_param([sys,'/','m1o'],...
		'Drop Shadow',4,...
		'position',[52,115,123,151])
add_line(sys,[330,315;560,315;560,225;590,225])
add_line(sys,[560,258;560,240;475,240])
add_line(sys,[315,250;260,250;260,160;280,160])
add_line(sys,[325,125;540,125;540,225;475,225])
add_line(sys,[195,240;250,240;250,310;285,310])
add_line(sys,[195,205;250,205;250,135;280,135])
add_line(sys,[325,140;560,140;560,205;590,205])
add_line(sys,[560,205;560,210;475,210])
add_line(sys,[315,200;270,200;270,335;285,335])
add_line(sys,[330,300;515,300;515,195;475,195])
add_line(sys,[425,245;365,245;365,205;345,205])
add_line(sys,[425,245;345,245])
add_line(sys,[455,285;495,285;495,255;475,255])
add_line(sys,[365,45;365,25;295,25])
add_line(sys,[365,45;365,25;460,25])
add_line(sys,[95,80;125,70])
add_line(sys,[325,170;360,170;360,195;345,195])
add_line(sys,[85,200;140,200])
add_line(sys,[85,225;140,225])
add_line(sys,[85,250;140,250])
add_line(sys,[435,360;575,360;575,245;590,245])
add_line(sys,[625,205;640,205;640,225;655,225])
add_line(sys,[625,225;625,235;655,235])
add_line(sys,[625,245;655,245])
add_line(sys,[195,275;230,275;230,360;395,360])
add_line(sys,[685,235;685,395;125,395;125,275;140,275])
add_line(sys,[420,165;430,165])
add_line(sys,[610,135;620,135])
add_line(sys,[325,125;580,125])
add_line(sys,[330,300;515,300;515,145;580,145])
add_line(sys,[85,200;125,200;125,170;205,170;205,70])
add_line(sys,[425,245;365,245;365,105;285,105;285,70])
add_line(sys,[425,210;420,210;420,90;365,90;365,70])
add_line(sys,[480,165;480,90;445,90;445,70])
add_line(sys,[670,135;675,135;675,100;525,100;525,70])
add_line(sys,[625,205;685,205;685,90;605,90;605,70])
add_line(sys,[325,170;360,170;360,155;390,155])
add_line(sys,[330,345;375,345;375,255;345,255])
add_line(sys,[330,345;375,345;375,170;390,170])

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
