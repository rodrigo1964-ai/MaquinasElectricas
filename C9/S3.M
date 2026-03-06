function [ret,x0,str,ts,xts]=s3(t,x,u,flag);
%s3	is the M-file description of the SIMULINK system named s3.
%	s3 has a the following characteristics:
%		10 continuous states
%		0 discrete states
%		0 outputs
%		0 inputs
%		does not have direct feedthrough
%		1 sample times
%
%	The block-diagram can be displayed by typing: s3.
%
%	SYS=s3(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes s3 to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling s3 with a FLAG of zero:
%	[SIZES]=s3([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[12,78,803,533])
     open_system(sys)
end;
set_param(sys,'algorithm',     'Adams/Gear')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     'tstop')
set_param(sys,'Min step size', '1e-4')
set_param(sys,'Max step size', '1e-2')
set_param(sys,'Relative error','1e-5')
set_param(sys,'Return vars',   '')

add_block('built-in/Note',[sys,'/','sin_rho'])
set_param([sys,'/','sin_rho'],...
		'position',[245,236,250,241])

add_block('built-in/Clock',[sys,'/','Clock'])
set_param([sys,'/','Clock'],...
		'orientation',3,...
		'position',[155,115,175,135])

add_block('built-in/Note',[sys,'/','lambdadr^e*'])
set_param([sys,'/','lambdadr^e*'],...
		'position',[105,230,110,235])

add_block('built-in/Mux',[sys,'/','Mux1'])
set_param([sys,'/','Mux1'],...
		'inputs','2',...
		'position',[675,282,700,313])

add_block('built-in/Note',[sys,'/','psidr'])
set_param([sys,'/','psidr'],...
		'position',[645,290,650,295])

add_block('built-in/Note',[sys,'/','psiqr'])
set_param([sys,'/','psiqr'],...
		'position',[644,266,649,271])

add_block('built-in/Integrator',[sys,'/','thetar'])
set_param([sys,'/','thetar'],...
		'position',[765,248,795,282])

add_block('built-in/Sum',[sys,'/','Sum1'])
set_param([sys,'/','Sum1'],...
		'inputs','+-',...
		'position',[60,168,75,197])

add_block('built-in/Look Up Table',[sys,'/',['Field',13,'Weakening']])
set_param([sys,'/',['Field',13,'Weakening']],...
		'Input_Values','speed',...
		'Output_Values','lambdadre',...
		'position',[95,272,135,308])

add_block('built-in/Gain',[sys,'/','2//P'])
set_param([sys,'/','2//P'],...
		'orientation',2,...
		'Gain','2/P',...
		'position',[300,356,350,394])


%     Subsystem  'abc2qds'.

new_system([sys,'/','abc2qds'])
set_param([sys,'/','abc2qds'],'Location',[73,84,637,421])

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

add_block('built-in/Outport',[sys,'/','abc2qds/v0s'])
set_param([sys,'/','abc2qds/v0s'],...
		'Port','3',...
		'position',[515,240,535,260])

add_block('built-in/Outport',[sys,'/','abc2qds/vds'])
set_param([sys,'/','abc2qds/vds'],...
		'Port','2',...
		'position',[515,160,535,180])

add_block('built-in/Sum',[sys,'/','abc2qds/Sum'])
set_param([sys,'/','abc2qds/Sum'],...
		'inputs','+-',...
		'position',[440,222,460,273])

add_block('built-in/Note',[sys,'/','abc2qds/vsg'])
set_param([sys,'/','abc2qds/vsg'],...
		'position',[345,275,350,280])

add_block('built-in/Gain',[sys,'/','abc2qds/1//Csg'])
set_param([sys,'/','abc2qds/1//Csg'],...
		'Gain','50*Zb*wb',...
		'position',[105,276,205,314])

add_block('built-in/Integrator',[sys,'/','abc2qds/Integrator'])
set_param([sys,'/','abc2qds/Integrator'],...
		'position',[265,280,300,310])

add_block('built-in/Sum',[sys,'/','abc2qds/Sum1'])
set_param([sys,'/','abc2qds/Sum1'],...
		'inputs','+-',...
		'position',[435,92,455,143])

add_block('built-in/Outport',[sys,'/','abc2qds/vqs'])
set_param([sys,'/','abc2qds/vqs'],...
		'position',[515,110,535,130])
add_line([sys,'/','abc2qds'],[65,295;100,295])
add_line([sys,'/','abc2qds'],[65,110;100,110])
add_line([sys,'/','abc2qds'],[65,170;100,170])
add_line([sys,'/','abc2qds'],[65,230;100,230])
add_line([sys,'/','abc2qds'],[150,170;205,170])
add_line([sys,'/','abc2qds'],[150,170;170,170;170,105;205,105])
add_line([sys,'/','abc2qds'],[380,170;510,170])
add_line([sys,'/','abc2qds'],[150,170;170,170;170,235;205,235])
add_line([sys,'/','abc2qds'],[465,250;510,250])
add_line([sys,'/','abc2qds'],[380,235;435,235])
add_line([sys,'/','abc2qds'],[210,295;260,295])
add_line([sys,'/','abc2qds'],[305,295;395,295;395,260;435,260])
add_line([sys,'/','abc2qds'],[380,105;430,105])
add_line([sys,'/','abc2qds'],[460,120;510,120])
add_line([sys,'/','abc2qds'],[305,295;395,295;395,130;430,130])


%     Finished composite block 'abc2qds'.

set_param([sys,'/','abc2qds'],...
		'position',[485,176,530,279])

add_block('built-in/Note',[sys,'/','i0s'])
set_param([sys,'/','i0s'],...
		'position',[655,205,660,210])

add_block('built-in/Note',[sys,'/','wr//wb'])
set_param([sys,'/','wr//wb'],...
		'position',[660,245,665,250])

add_block('built-in/Note',[sys,'/','Tem'])
set_param([sys,'/','Tem'],...
		'position',[655,222,660,227])

add_block('built-in/Note',[sys,'/','ids'])
set_param([sys,'/','ids'],...
		'position',[655,185,660,190])

add_block('built-in/Note',[sys,'/','iqs'])
set_param([sys,'/','iqs'],...
		'position',[655,160,660,165])

add_block('built-in/Note',[sys,'/','vds'])
set_param([sys,'/','vds'],...
		'position',[545,210,550,215])

add_block('built-in/Note',[sys,'/','vqs'])
set_param([sys,'/','vqs'],...
		'position',[545,175,550,180])

add_block('built-in/Note',[sys,'/','v0s'])
set_param([sys,'/','v0s'],...
		'position',[545,243,550,248])


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
		'position',[700,175,740,235])

add_block('built-in/Gain',[sys,'/','wb'])
set_param([sys,'/','wb'],...
		'Gain','wb',...
		'position',[705,252,735,278])

add_block('built-in/Note',[sys,'/','ias'])
set_param([sys,'/','ias'],...
		'position',[780,165,785,170])

add_block('built-in/Note',[sys,'/','ibs'])
set_param([sys,'/','ibs'],...
		'position',[780,185,785,190])

add_block('built-in/Note',[sys,'/','ics'])
set_param([sys,'/','ics'],...
		'position',[780,205,785,210])

add_block('built-in/Note',[sys,'/','ids^e*'])
set_param([sys,'/','ids^e*'],...
		'position',[240,186,245,191])


%     Subsystem  'qde2abc'.

new_system([sys,'/','qde2abc'])
set_param([sys,'/','qde2abc'],'Location',[20,323,713,613])

add_block('built-in/Outport',[sys,'/','qde2abc/ics*'])
set_param([sys,'/','qde2abc/ics*'],...
		'Port','3',...
		'position',[565,185,585,205])

add_block('built-in/Outport',[sys,'/','qde2abc/ibs*'])
set_param([sys,'/','qde2abc/ibs*'],...
		'Port','2',...
		'position',[565,135,585,155])

add_block('built-in/Inport',[sys,'/','qde2abc/ids^e*'])
set_param([sys,'/','qde2abc/ids^e*'],...
		'Port','2',...
		'position',[65,110,85,130])

add_block('built-in/Outport',[sys,'/','qde2abc/ias*'])
set_param([sys,'/','qde2abc/ias*'],...
		'position',[565,90,585,110])

add_block('built-in/Fcn',[sys,'/','qde2abc/iqs^s'])
set_param([sys,'/','qde2abc/iqs^s'],...
		'Expr','u[1]*u[3] + u[2]*u[4]',...
		'position',[175,96,300,124])

add_block('built-in/Fcn',[sys,'/','qde2abc/ics'])
set_param([sys,'/','qde2abc/ics'],...
		'Expr','-(u[1] -sqrt(3)*u[2])/2',...
		'position',[405,182,535,208])

add_block('built-in/Mux',[sys,'/','qde2abc/Mux1'])
set_param([sys,'/','qde2abc/Mux1'],...
		'inputs','2',...
		'position',[330,96,355,189])

add_block('built-in/Fcn',[sys,'/','qde2abc/ibs'])
set_param([sys,'/','qde2abc/ibs'],...
		'Expr','-(u[1] + sqrt(3)*u[2])/2',...
		'position',[405,131,535,159])

add_block('built-in/Fcn',[sys,'/','qde2abc/ids^s'])
set_param([sys,'/','qde2abc/ids^s'],...
		'Expr','-u[1]*u[4] + u[2]*u[3]',...
		'position',[175,161,300,189])

add_block('built-in/Fcn',[sys,'/','qde2abc/ias'])
set_param([sys,'/','qde2abc/ias'],...
		'Expr','u[1]',...
		'position',[410,86,535,114])

add_block('built-in/Mux',[sys,'/','qde2abc/Mux'])
set_param([sys,'/','qde2abc/Mux'],...
		'position',[115,62,140,218])

add_block('built-in/Inport',[sys,'/','qde2abc/iqs^e*'])
set_param([sys,'/','qde2abc/iqs^e*'],...
		'position',[65,70,85,90])

add_block('built-in/Inport',[sys,'/','qde2abc/sin_rho'])
set_param([sys,'/','qde2abc/sin_rho'],...
		'Port','4',...
		'position',[65,190,85,210])

add_block('built-in/Inport',[sys,'/','qde2abc/cos_rho'])
set_param([sys,'/','qde2abc/cos_rho'],...
		'Port','3',...
		'position',[65,150,85,170])
add_line([sys,'/','qde2abc'],[360,145;375,145;375,195;400,195])
add_line([sys,'/','qde2abc'],[360,145;400,145])
add_line([sys,'/','qde2abc'],[360,145;375,145;375,100;405,100])
add_line([sys,'/','qde2abc'],[305,175;310,175;310,165;325,165])
add_line([sys,'/','qde2abc'],[305,110;310,110;310,120;325,120])
add_line([sys,'/','qde2abc'],[145,140;150,140;150,175;170,175])
add_line([sys,'/','qde2abc'],[145,140;150,140;150,110;170,110])
add_line([sys,'/','qde2abc'],[90,80;110,80])
add_line([sys,'/','qde2abc'],[540,100;560,100])
add_line([sys,'/','qde2abc'],[90,120;110,120])
add_line([sys,'/','qde2abc'],[540,145;560,145])
add_line([sys,'/','qde2abc'],[90,160;110,160])
add_line([sys,'/','qde2abc'],[90,200;110,200])
add_line([sys,'/','qde2abc'],[540,195;560,195])


%     Finished composite block 'qde2abc'.

set_param([sys,'/','qde2abc'],...
		'position',[275,171,315,264])


%     Subsystem  'Field_Orient'.

new_system([sys,'/','Field_Orient'])
set_param([sys,'/','Field_Orient'],'Location',[337,454,1015,790])

add_block('built-in/Fcn',[sys,'/','Field_Orient/Fcn'])
set_param([sys,'/','Field_Orient/Fcn'],...
		'Expr','cos(u[1])',...
		'position',[450,193,520,217])

add_block('built-in/Sum',[sys,'/','Field_Orient/rho'])
set_param([sys,'/','Field_Orient/rho'],...
		'position',[400,237,415,273])

add_block('built-in/Integrator',[sys,'/','Field_Orient/theta2'])
set_param([sys,'/','Field_Orient/theta2'],...
		'position',[325,194,360,226])

add_block('built-in/Note',[sys,'/','Field_Orient/w2'])
set_param([sys,'/','Field_Orient/w2'],...
		'position',[295,190,300,195])

add_block('built-in/Fcn',[sys,'/','Field_Orient/we-wr'])
set_param([sys,'/','Field_Orient/we-wr'],...
		'Expr','(rpr*wb/xr)*(u[1]/u[2])',...
		'position',[105,192,275,228])

add_block('built-in/Mux',[sys,'/','Field_Orient/Mux'])
set_param([sys,'/','Field_Orient/Mux'],...
		'inputs','2',...
		'position',[135,55,160,90])

add_block('built-in/Inport',[sys,'/','Field_Orient/Tem*'])
set_param([sys,'/','Field_Orient/Tem*'],...
		'position',[35,55,55,75])

add_block('built-in/Inport',[sys,'/','Field_Orient/thetar'])
set_param([sys,'/','Field_Orient/thetar'],...
		'Port','3',...
		'position',[35,255,55,275])

add_block('built-in/Outport',[sys,'/','Field_Orient/cos_rho'])
set_param([sys,'/','Field_Orient/cos_rho'],...
		'Port','3',...
		'position',[560,195,580,215])

add_block('built-in/Fcn',[sys,'/','Field_Orient/Fcn1'])
set_param([sys,'/','Field_Orient/Fcn1'],...
		'position',[450,253,520,277])

add_block('built-in/Outport',[sys,'/','Field_Orient/sin_rho'])
set_param([sys,'/','Field_Orient/sin_rho'],...
		'Port','4',...
		'position',[560,255,580,275])

add_block('built-in/Outport',[sys,'/','Field_Orient/iqs^e*'])
set_param([sys,'/','Field_Orient/iqs^e*'],...
		'position',[560,65,580,85])

add_block('built-in/Inport',[sys,'/','Field_Orient/lambdadre'])
set_param([sys,'/','Field_Orient/lambdadre'],...
		'Port','2',...
		'position',[35,130,55,150])

add_block('built-in/Derivative',[sys,'/','Field_Orient/Derivative'])
set_param([sys,'/','Field_Orient/Derivative'],...
		'position',[110,130,140,150])

add_block('built-in/Mux',[sys,'/','Field_Orient/Mux2'])
set_param([sys,'/','Field_Orient/Mux2'],...
		'inputs','2',...
		'position',[165,111,185,149])

add_block('built-in/Outport',[sys,'/','Field_Orient/ids^e*'])
set_param([sys,'/','Field_Orient/ids^e*'],...
		'Port','2',...
		'position',[560,120,580,140])

add_block('built-in/Mux',[sys,'/','Field_Orient/Mux1'])
set_param([sys,'/','Field_Orient/Mux1'],...
		'inputs','2',...
		'position',[450,89,480,116])

add_block('built-in/Fcn',[sys,'/','Field_Orient/ids^e'])
set_param([sys,'/','Field_Orient/ids^e'],...
		'Expr','(xr*u[2]+rpr*wb*u[1])/(rpr*xm)',...
		'position',[230,111,405,149])

add_block('built-in/Fcn',[sys,'/','Field_Orient/iqs^e'])
set_param([sys,'/','Field_Orient/iqs^e'],...
		'Expr','(4/(3*P))*u[1]*xr/(xm*u[2])',...
		'position',[220,59,405,91])
add_line([sys,'/','Field_Orient'],[420,255;430,255;430,265;445,265])
add_line([sys,'/','Field_Orient'],[420,255;430,255;430,205;445,205])
add_line([sys,'/','Field_Orient'],[365,210;375,210;375,245;395,245])
add_line([sys,'/','Field_Orient'],[280,210;320,210])
add_line([sys,'/','Field_Orient'],[485,105;505,105;505,170;80,170;80,210;100,210])
add_line([sys,'/','Field_Orient'],[410,75;435,75;445,95])
add_line([sys,'/','Field_Orient'],[165,75;215,75])
add_line([sys,'/','Field_Orient'],[60,65;130,65])
add_line([sys,'/','Field_Orient'],[410,75;555,75])
add_line([sys,'/','Field_Orient'],[60,140;90,140;90,80;130,80])
add_line([sys,'/','Field_Orient'],[525,205;555,205])
add_line([sys,'/','Field_Orient'],[60,265;395,265])
add_line([sys,'/','Field_Orient'],[525,265;555,265])
add_line([sys,'/','Field_Orient'],[60,140;105,140])
add_line([sys,'/','Field_Orient'],[145,140;160,140])
add_line([sys,'/','Field_Orient'],[60,140;90,140;90,120;160,120])
add_line([sys,'/','Field_Orient'],[190,130;225,130])
add_line([sys,'/','Field_Orient'],[410,130;555,130])
add_line([sys,'/','Field_Orient'],[410,130;435,130;445,110])


%     Finished composite block 'Field_Orient'.

set_param([sys,'/','Field_Orient'],...
		'position',[180,168,220,267])

add_block('built-in/Mux',[sys,'/','Mux'])
set_param([sys,'/','Mux'],...
		'orientation',3,...
		'inputs','7',...
		'position',[123,75,717,85])

add_block('built-in/Scope',[sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'Vgain','300.000000',...
		'Hgain','2.000000',...
		'Vmax','600.000000',...
		'Hmax','4.000000',...
		'Window',[20,463,832,625])
open_system([sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'position',[465,32,485,58])

add_block('built-in/To Workspace',[sys,'/','To Workspace'])
set_param([sys,'/','To Workspace'],...
		'orientation',2,...
		'mat-name','y',...
		'buffer','40000',...
		'position',[305,37,355,53])

add_block('built-in/Note',[sys,'/','thetar_'])
set_param([sys,'/','thetar_'],...
		'position',[205,322,210,327])

add_block('built-in/Note',[sys,'/','wrm'])
set_param([sys,'/','wrm'],...
		'position',[160,355,165,360])

add_block('built-in/Fcn',[sys,'/',['Rotor flux ',13,'magnitude']])
set_param([sys,'/',['Rotor flux ',13,'magnitude']],...
		'Expr','sqrt(u[1]*u[1]+u[2]*u[2])',...
		'position',[730,382,825,408])

add_block('built-in/Sum',[sys,'/','Sum'])
set_param([sys,'/','Sum'],...
		'inputs','+++',...
		'position',[805,175,820,235])


%     Subsystem  'Tmech1'.

new_system([sys,'/','Tmech1'])
set_param([sys,'/','Tmech1'],'Location',[5,40,315,196])

add_block('built-in/Outport',[sys,'/','Tmech1/out_1'])
set_param([sys,'/','Tmech1/out_1'],...
		'position',[285,60,305,80])

add_block('built-in/Look Up Table',[sys,'/','Tmech1/Look-Up Table'])
set_param([sys,'/','Tmech1/Look-Up Table'],...
		'Input_Values','t',...
		'Output_Values','y',...
		'position',[210,58,250,82])

add_block('built-in/Fcn',[sys,'/','Tmech1/Fcn1'])
set_param([sys,'/','Tmech1/Fcn1'],...
		'Expr','rem(u[1],period)',...
		'position',[110,60,150,80])

add_block('built-in/Clock',[sys,'/','Tmech1/Clock'])
set_param([sys,'/','Tmech1/Clock'],...
		'position',[45,60,65,80])
add_line([sys,'/','Tmech1'],[255,70;280,70])
add_line([sys,'/','Tmech1'],[70,70;105,70])
add_line([sys,'/','Tmech1'],[155,70;205,70])
set_param([sys,'/','Tmech1'],...
		'Mask Display','plot([t,t+period,t+2*period],[y,y,y])',...
		'Mask Type','Repeating table',...
		'Mask Dialogue','Repeating table.\nEnter values of time and output for first cycle.|Time values:|Output values:')
set_param([sys,'/','Tmech1'],...
		'Mask Translate','period = max(@1); t = @1; y = @2;',...
		'Mask Help','Repeats cycle given in table. Time values should be monotonically increasing.',...
		'Mask Entries','time_tmech\/tmech_tmech\/')


%     Finished composite block 'Tmech1'.

set_param([sys,'/','Tmech1'],...
		'position',[490,299,530,321])


%     Subsystem  ['Speed',13,'Ref1'].

new_system([sys,'/',['Speed',13,'Ref1']])
set_param([sys,'/',['Speed',13,'Ref1']],'Location',[5,40,315,196])

add_block('built-in/Outport',[sys,'/',['Speed',13,'Ref1/out_1']])
set_param([sys,'/',['Speed',13,'Ref1/out_1']],...
		'position',[285,60,305,80])

add_block('built-in/Look Up Table',[sys,'/',['Speed',13,'Ref1/Look-Up Table']])
set_param([sys,'/',['Speed',13,'Ref1/Look-Up Table']],...
		'Input_Values','t',...
		'Output_Values','y',...
		'position',[210,58,250,82])

add_block('built-in/Fcn',[sys,'/',['Speed',13,'Ref1/Fcn1']])
set_param([sys,'/',['Speed',13,'Ref1/Fcn1']],...
		'Expr','rem(u[1],period)',...
		'position',[110,60,150,80])

add_block('built-in/Clock',[sys,'/',['Speed',13,'Ref1/Clock']])
set_param([sys,'/',['Speed',13,'Ref1/Clock']],...
		'position',[45,60,65,80])
add_line([sys,'/',['Speed',13,'Ref1']],[255,70;280,70])
add_line([sys,'/',['Speed',13,'Ref1']],[70,70;105,70])
add_line([sys,'/',['Speed',13,'Ref1']],[155,70;205,70])
set_param([sys,'/',['Speed',13,'Ref1']],...
		'Mask Display','plot([t,t+period,t+2*period],[y,y,y])',...
		'Mask Type','Repeating table')
set_param([sys,'/',['Speed',13,'Ref1']],...
		'Mask Dialogue','Repeating table.\nEnter values of time and output for first cycle.|Time values:|Output values:',...
		'Mask Translate','period = max(@1); t = @1; y = @2;')
set_param([sys,'/',['Speed',13,'Ref1']],...
		'Mask Help','Repeats cycle given in table. Time values should be monotonically increasing.',...
		'Mask Entries','time_wref\/speed_wref\/')


%     Finished composite block ['Speed',13,'Ref1'].

set_param([sys,'/',['Speed',13,'Ref1']],...
		'orientation',2,...
		'position',[80,120,120,140])

add_block('built-in/Note',[sys,'/','wref'])
set_param([sys,'/','wref'],...
		'position',[55,110,60,115])

add_block('built-in/Note',[sys,'/','iqs^e*'])
set_param([sys,'/','iqs^e*'],...
		'position',[240,160,245,165])

add_block('built-in/Note',[sys,'/','cos_rho'])
set_param([sys,'/','cos_rho'],...
		'position',[245,210,250,215])

add_block('built-in/Transfer Fcn',[sys,'/',['Torque',13,'Controller']])
set_param([sys,'/',['Torque',13,'Controller']],...
		'Numerator','[30  7]',...
		'Denominator','[1 0]',...
		'position',[90,166,145,204])

add_block('built-in/Gain',[sys,'/','vag'])
set_param([sys,'/','vag'],...
		'Gain','500*Zb',...
		'position',[410,155,430,175])

add_block('built-in/Sum',[sys,'/','Sa'])
set_param([sys,'/','Sa'],...
		'inputs','-+',...
		'position',[370,155,390,175])

add_block('built-in/Gain',[sys,'/','vbg'])
set_param([sys,'/','vbg'],...
		'Gain','500*Zb',...
		'position',[410,205,430,225])

add_block('built-in/Gain',[sys,'/','vcg'])
set_param([sys,'/','vcg'],...
		'Gain','500*Zb',...
		'position',[410,255,430,275])

add_block('built-in/Sum',[sys,'/','Sa1'])
set_param([sys,'/','Sa1'],...
		'inputs','-+',...
		'position',[370,205,390,225])

add_block('built-in/Sum',[sys,'/','Sa2'])
set_param([sys,'/','Sa2'],...
		'inputs','-+',...
		'position',[370,255,390,275])

add_block('built-in/Note',[sys,'/','Tem*'])
set_param([sys,'/','Tem*'],...
		'position',[160,160,165,165])


%     Subsystem  ['induction machine',13,'in stationary qd0'].

new_system([sys,'/',['induction machine',13,'in stationary qd0']])
set_param([sys,'/',['induction machine',13,'in stationary qd0']],'Location',[50,241,804,663])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/v0s']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/v0s']],...
		'position',[185,305,190,310])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/i0s']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/i0s']],...
		'position',[455,310,460,315])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/out_psidr']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/out_psidr']],...
		'Port','7',...
		'position',[345,290,365,310])


%     Subsystem  ['induction machine',13,'in stationary qd0/Daxis'].

new_system([sys,'/',['induction machine',13,'in stationary qd0/Daxis']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],'Location',[213,440,1045,854])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/out_psidr''']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/out_psidr''']],...
		'Port','4',...
		'position',[735,260,755,280])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/psidr''']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/psidr''']],...
		'position',[390,276,395,281])

add_block('built-in/Mux',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/Mux2']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/Mux2']],...
		'inputs','2',...
		'position',[450,286,470,339])

add_block('built-in/Mux',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/Mux3']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/Mux3']],...
		'inputs','2',...
		'position',[445,193,465,257])

add_block('built-in/Fcn',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/Fcn3']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/Fcn3']],...
		'Expr','xM*(u[1]/xls+u[2]/xplr)',...
		'position',[485,207,635,243])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/in_(wr//wb)*psiqr''']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/in_(wr//wb)*psiqr''']],...
		'Port','2',...
		'position',[45,290,65,310])

add_block('built-in/Fcn',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/Fcn2']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/Fcn2']],...
		'Expr','wb*(-u[2] +(rpr/xplr)*(u[3]-u[1]))',...
		'position',[145,284,325,316])

add_block('built-in/Mux',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/Mux1']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/Mux1']],...
		'inputs','3',...
		'position',[105,262,125,338])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/idr''']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/idr''']],...
		'position',[600,292,605,297])

add_block('built-in/Integrator',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/psidr''_']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/psidr''_']],...
		'Initial','Psipdro',...
		'position',[345,287,375,313])

add_block('built-in/Fcn',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/Fcn5']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/Fcn5']],...
		'Expr','(u[1]-u[2])/xplr',...
		'position',[490,300,585,330])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/out_idr''']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/out_idr''']],...
		'Port','3',...
		'position',[735,305,755,325])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/psiqm']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/psiqm']],...
		'position',[665,200,670,205])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/psids']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/psids']],...
		'position',[380,125,385,130])

add_block('built-in/Integrator',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/psids_']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/psids_']],...
		'Initial','Psidso',...
		'position',[335,137,365,163])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/ids']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/ids']],...
		'position',[600,120,605,125])

add_block('built-in/Mux',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/Mux4']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/Mux4']],...
		'inputs','2',...
		'position',[450,114,470,161])

add_block('built-in/Fcn',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/Fcn4']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/Fcn4']],...
		'Expr','(u[1]-u[2])/xls',...
		'position',[495,126,585,154])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/out_ids']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/out_ids']],...
		'Port','2',...
		'position',[735,130,755,150])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/out_psids']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/out_psids']],...
		'position',[735,65,755,85])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/in_vds']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/in_vds']],...
		'position',[50,140,70,160])

add_block('built-in/Mux',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/Mux']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/Mux']],...
		'inputs','3',...
		'position',[100,108,120,192])

add_block('built-in/Fcn',[sys,'/',['induction machine',13,'in stationary qd0/Daxis/Fcn']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis/Fcn']],...
		'Expr','wb*(u[2]+(rs/xls)*(u[1]-u[3]))',...
		'position',[145,135,310,165])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[380,300;415,300;415,270;730,270])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[590,315;730,315])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[70,300;100,300])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[75,150;95,150])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[370,150;405,150;405,75;730,75])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[590,140;730,140])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[125,150;140,150])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[315,150;330,150])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[330,300;340,300])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[370,150;405,150;405,210;440,210])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[470,225;480,225])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[475,140;490,140])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[370,150;405,150;405,125;445,125])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[640,225;695,225;695,180;425,180;425,150;445,150])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[640,225;695,225;695,365;75,365;75,325;100,325])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[640,225;695,225;695,90;80,90;80,120;95,120])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[130,300;140,300])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[380,300;415,300;415,240;85,240;85,275;100,275])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[370,150;405,150;405,210;80,210;80,180;95,180])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[380,300;415,300;415,240;440,240])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[475,315;485,315])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[380,300;445,300])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],[640,225;695,225;695,365;410,365;410,325;445,325])


%     Finished composite block ['induction machine',13,'in stationary qd0/Daxis'].

set_param([sys,'/',['induction machine',13,'in stationary qd0/Daxis']],...
		'position',[245,250,280,305])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/in_v0s']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/in_v0s']],...
		'Port','3',...
		'position',[115,320,135,340])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/out_i0s']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/out_i0s']],...
		'Port','3',...
		'position',[565,320,585,340])


%     Subsystem  ['induction machine',13,'in stationary qd0/Zero_seq'].

new_system([sys,'/',['induction machine',13,'in stationary qd0/Zero_seq']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Zero_seq']],'Location',[160,675,612,861])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/Zero_seq/in_v0s']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Zero_seq/in_v0s']],...
		'position',[55,60,75,80])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/Zero_seq/out_i0s']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Zero_seq/out_i0s']],...
		'position',[365,70,385,90])

add_block('built-in/Integrator',[sys,'/',['induction machine',13,'in stationary qd0/Zero_seq/Integrator']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Zero_seq/Integrator']],...
		'position',[265,65,295,95])

add_block('built-in/Gain',[sys,'/',['induction machine',13,'in stationary qd0/Zero_seq/wb//xls']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Zero_seq/wb//xls']],...
		'Gain','wb/xls',...
		'position',[180,62,240,98])

add_block('built-in/Sum',[sys,'/',['induction machine',13,'in stationary qd0/Zero_seq/Sum']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Zero_seq/Sum']],...
		'inputs','+-',...
		'position',[140,59,155,101])

add_block('built-in/Gain',[sys,'/',['induction machine',13,'in stationary qd0/Zero_seq/rs']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Zero_seq/rs']],...
		'orientation',2,...
		'Gain','rs',...
		'position',[200,122,245,158])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Zero_seq']],[300,80;360,80])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Zero_seq']],[80,70;135,70])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Zero_seq']],[245,80;260,80])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Zero_seq']],[160,80;175,80])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Zero_seq']],[300,80;310,80;310,140;250,140])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Zero_seq']],[195,140;115,140;115,90;135,90])


%     Finished composite block ['induction machine',13,'in stationary qd0/Zero_seq'].

set_param([sys,'/',['induction machine',13,'in stationary qd0/Zero_seq']],...
		'position',[395,305,430,355])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/out_Tem']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/out_Tem']],...
		'Port','4',...
		'position',[405,100,425,120])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/out_psiqr']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/out_psiqr']],...
		'Port','6',...
		'position',[340,100,360,120])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/out_wr//wb']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/out_wr//wb']],...
		'Port','5',...
		'position',[395,225,415,245])

add_block('built-in/Product',[sys,'/',['induction machine',13,'in stationary qd0/Product1']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Product1']],...
		'orientation',2,...
		'position',[275,188,295,212])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/Tem']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Tem']],...
		'position',[364,142,369,147])


%     Subsystem  ['induction machine',13,'in stationary qd0/Rotor'].

new_system([sys,'/',['induction machine',13,'in stationary qd0/Rotor']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Rotor']],'Location',[149,82,784,328])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/Rotor/in_Tmech']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Rotor/in_Tmech']],...
		'Port','5',...
		'position',[55,200,75,220])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/Rotor/in_ids']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Rotor/in_ids']],...
		'Port','4',...
		'position',[55,160,75,180])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/Rotor/in_psiqs']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Rotor/in_psiqs']],...
		'Port','3',...
		'position',[55,120,75,140])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/Rotor/in_iqs']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Rotor/in_iqs']],...
		'Port','2',...
		'position',[55,80,75,100])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/Rotor/in_psids']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Rotor/in_psids']],...
		'position',[55,40,75,60])

add_block('built-in/Mux',[sys,'/',['induction machine',13,'in stationary qd0/Rotor/Mux']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Rotor/Mux']],...
		'position',[105,26,130,194])

add_block('built-in/Fcn',[sys,'/',['induction machine',13,'in stationary qd0/Rotor/Tem_']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Rotor/Tem_']],...
		'Expr','Tfactor*(u[1]*u[2]-u[3]*u[4])',...
		'position',[150,96,310,124])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/Rotor/Tdamp']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Rotor/Tdamp']],...
		'position',[405,175,410,180])

add_block('built-in/Gain',[sys,'/',['induction machine',13,'in stationary qd0/Rotor/Damping',13,'coefficient']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Rotor/Damping',13,'coefficient']],...
		'orientation',2,...
		'Gain','Domega',...
		'position',[440,177,510,213])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/Rotor/out_wr//wb']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Rotor/out_wr//wb']],...
		'Port','2',...
		'position',[550,123,570,147])

add_block('built-in/Integrator',[sys,'/',['induction machine',13,'in stationary qd0/Rotor/1//s']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Rotor/1//s']],...
		'Initial','wrbywbo',...
		'position',[480,120,510,150])

add_block('built-in/Gain',[sys,'/',['induction machine',13,'in stationary qd0/Rotor/1//2H']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Rotor/1//2H']],...
		'Gain','1/(2*H)',...
		'position',[395,109,460,161])

add_block('built-in/Sum',[sys,'/',['induction machine',13,'in stationary qd0/Rotor/Taccl']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Rotor/Taccl']],...
		'inputs','++-',...
		'position',[355,95,370,175])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/Rotor/out_Tem']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Rotor/out_Tem']],...
		'position',[540,60,560,80])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Rotor']],[80,170;100,170])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Rotor']],[80,130;100,130])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Rotor']],[80,90;100,90])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Rotor']],[80,50;100,50])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Rotor']],[135,110;145,110])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Rotor']],[435,195;330,195;330,160;350,160])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Rotor']],[515,135;530,135;530,195;515,195])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Rotor']],[315,110;325,110;325,70;535,70])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Rotor']],[315,110;350,110])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Rotor']],[465,135;475,135])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Rotor']],[375,135;390,135])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Rotor']],[80,210;310,210;310,135;350,135])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Rotor']],[515,135;545,135])


%     Finished composite block ['induction machine',13,'in stationary qd0/Rotor'].

set_param([sys,'/',['induction machine',13,'in stationary qd0/Rotor']],...
		'orientation',2,...
		'position',[385,139,425,211])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/wr//wb']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/wr//wb']],...
		'position',[355,170,360,175])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/in_Tmech']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/in_Tmech']],...
		'orientation',2,...
		'Port','4',...
		'position',[450,195,470,215])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/out_ids']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/out_ids']],...
		'Port','2',...
		'position',[565,260,585,280])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/out_iqs']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/out_iqs']],...
		'position',[565,85,585,105])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/vds']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/vds']],...
		'position',[185,245,190,250])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/in_vds']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/in_vds']],...
		'Port','2',...
		'position',[115,255,135,275])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/vqs']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/vqs']],...
		'position',[190,65,195,70])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/in_vqs']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/in_vqs']],...
		'position',[115,80,135,100])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/ids']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/ids']],...
		'position',[290,250,295,255])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/psidr']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/psidr']],...
		'position',[299,280,304,285])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/psids']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/psids']],...
		'position',[295,235,300,240])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/psiqr']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/psiqr']],...
		'position',[290,105,295,110])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/iqs']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/iqs']],...
		'position',[285,75,290,80])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/psiqs']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/psiqs']],...
		'position',[290,60,295,65])

add_block('built-in/Product',[sys,'/',['induction machine',13,'in stationary qd0/Product']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Product']],...
		'orientation',2,...
		'position',[275,144,295,166])


%     Subsystem  ['induction machine',13,'in stationary qd0/Qaxis'].

new_system([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],'Location',[213,440,1045,854])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/out_psiqr''']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/out_psiqr''']],...
		'Port','4',...
		'position',[735,260,755,280])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/psiqr''']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/psiqr''']],...
		'position',[390,276,395,281])

add_block('built-in/Mux',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Mux2']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Mux2']],...
		'inputs','2',...
		'position',[450,286,470,339])

add_block('built-in/Mux',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Mux3']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Mux3']],...
		'inputs','2',...
		'position',[445,193,465,257])

add_block('built-in/Fcn',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Fcn3']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Fcn3']],...
		'Expr','xM*(u[1]/xls+u[2]/xplr)',...
		'position',[485,207,635,243])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/in_(wr//wb)*psidr''']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/in_(wr//wb)*psidr''']],...
		'Port','2',...
		'position',[45,290,65,310])

add_block('built-in/Fcn',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Fcn2']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Fcn2']],...
		'Expr','wb*(u[2] +(rpr/xplr)*(u[3]-u[1]))',...
		'position',[145,284,325,316])

add_block('built-in/Mux',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Mux1']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Mux1']],...
		'inputs','3',...
		'position',[105,262,125,338])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/iqr''']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/iqr''']],...
		'position',[600,292,605,297])

add_block('built-in/Integrator',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/psiqr''_']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/psiqr''_']],...
		'Initial','Psipqro',...
		'position',[345,287,375,313])

add_block('built-in/Fcn',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Fcn5']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Fcn5']],...
		'Expr','(u[1]-u[2])/xplr',...
		'position',[490,300,585,330])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/out_iqr''']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/out_iqr''']],...
		'Port','3',...
		'position',[735,305,755,325])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/psiqm']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/psiqm']],...
		'position',[665,200,670,205])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/psiqs']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/psiqs']],...
		'position',[380,125,385,130])

add_block('built-in/Integrator',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/psiqs_']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/psiqs_']],...
		'Initial','Psiqso',...
		'position',[335,137,365,163])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/iqs']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/iqs']],...
		'position',[600,120,605,125])

add_block('built-in/Mux',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Mux4']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Mux4']],...
		'inputs','2',...
		'position',[450,114,470,161])

add_block('built-in/Fcn',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Fcn4']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Fcn4']],...
		'Expr','(u[1]-u[2])/xls',...
		'position',[495,126,585,154])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/out_iqs']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/out_iqs']],...
		'Port','2',...
		'position',[735,130,755,150])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/out_psiqs']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/out_psiqs']],...
		'position',[735,65,755,85])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/in_vqs']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/in_vqs']],...
		'position',[50,140,70,160])

add_block('built-in/Mux',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Mux']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Mux']],...
		'inputs','3',...
		'position',[100,108,120,192])

add_block('built-in/Fcn',[sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Fcn']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis/Fcn']],...
		'Expr','wb*(u[2]+(rs/xls)*(u[1]-u[3]))',...
		'position',[145,135,310,165])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[380,300;415,300;415,270;730,270])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[590,315;730,315])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[70,300;100,300])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[75,150;95,150])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[370,150;405,150;405,75;730,75])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[590,140;730,140])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[125,150;140,150])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[315,150;330,150])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[330,300;340,300])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[370,150;405,150;405,210;440,210])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[470,225;480,225])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[475,140;490,140])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[370,150;405,150;405,125;445,125])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[640,225;695,225;695,180;425,180;425,150;445,150])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[640,225;695,225;695,365;75,365;75,325;100,325])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[640,225;695,225;695,90;80,90;80,120;95,120])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[130,300;140,300])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[380,300;415,300;415,240;85,240;85,275;100,275])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[370,150;405,150;405,210;80,210;80,180;95,180])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[380,300;415,300;415,240;440,240])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[475,315;485,315])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[380,300;445,300])
add_line([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],[640,225;695,225;695,365;410,365;410,325;445,325])


%     Finished composite block ['induction machine',13,'in stationary qd0/Qaxis'].

set_param([sys,'/',['induction machine',13,'in stationary qd0/Qaxis']],...
		'position',[240,75,275,130])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/Induction Machine Simulation',13,'  in Stationary Reference Frame']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Induction Machine Simulation',13,'  in Stationary Reference Frame']],...
		'position',[570,45,575,50])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[285,300;340,300])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[280,125;310,125;310,110;335,110])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[285,270;560,270])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[280,95;560,95])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[435,330;560,330])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[140,265;240,265])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[140,330;390,330])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[140,90;235,90])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[445,205;430,205])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[380,195;390,235])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[380,160;380,110;400,110])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[285,270;515,270;515,190;430,190])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[270,200;215,200;215,115;235,115])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[280,80;495,80;495,175;430,175])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[280,95;515,95;515,160;430,160])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[270,155;225,155;225,290;240,290])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[285,255;490,255;490,145;430,145])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[380,195;335,195;335,160;300,160])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[380,195;300,195])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[280,125;320,125;320,150;300,150])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[285,300;325,300;325,205;300,205])


%     Finished composite block ['induction machine',13,'in stationary qd0'].

set_param([sys,'/',['induction machine',13,'in stationary qd0']],...
		'position',[575,179,625,311])

add_block('built-in/Note',[sys,'/',['Current regulated pwm',13,'field-oriented controlled',13,'induction motor drive']])
set_param([sys,'/',['Current regulated pwm',13,'field-oriented controlled',13,'induction motor drive']],...
		'position',[110,25,115,30])


%     Subsystem  'm3'.

new_system([sys,'/','m3'])
set_param([sys,'/','m3'],'Location',[575,5111904,765,5111991])

add_block('built-in/Note',[sys,'/',['m3/Masked block of m3.m to initialize s3.m',13,'and plot results of the simulation']])
set_param([sys,'/',['m3/Masked block of m3.m to initialize s3.m',13,'and plot results of the simulation']],...
		'position',[105,40,110,45])
set_param([sys,'/','m3'],...
		'Mask Display','Initialize\nand plot',...
		'Mask Type','Masked block of m3.m',...
		'Mask Dialogue','eval(''m3'')',...
		'Mask Help','Uses m3.m to initialize and plot')


%     Finished composite block 'm3'.

set_param([sys,'/','m3'],...
		'Drop Shadow',4,...
		'position',[750,29,818,63])
add_line(sys,[535,195;570,195])
add_line(sys,[420,70;420,45;460,45])
add_line(sys,[165,110;165,90])
add_line(sys,[745,185;800,185])
add_line(sys,[745,205;800,205])
add_line(sys,[745,225;800,225])
add_line(sys,[825,205;830,205;830,360;465,360;465,265;480,265])
add_line(sys,[535,230;570,230])
add_line(sys,[630,185;695,185])
add_line(sys,[630,205;695,205])
add_line(sys,[630,225;695,225])
add_line(sys,[420,70;420,45;360,45])
add_line(sys,[630,265;700,265])
add_line(sys,[740,265;760,265])
add_line(sys,[225,180;270,180])
add_line(sys,[225,205;270,205])
add_line(sys,[225,230;270,230])
add_line(sys,[225,255;270,255])
add_line(sys,[320,190;330,190;330,170;365,170])
add_line(sys,[320,250;325,250;325,270;365,270])
add_line(sys,[745,185;745,150;350,150;350,160;365,160])
add_line(sys,[745,205;750,205;750,135;345,135;345,210;365,210])
add_line(sys,[745,225;765,225;765,120;340,120;340,260;365,260])
add_line(sys,[800,265;800,345;160,345;160,255;175,255])
add_line(sys,[740,265;750,265;750,375;355,375])
add_line(sys,[295,375;70,375;70,290;90,290])
add_line(sys,[295,375;45,375;55,190])
add_line(sys,[395,215;405,215])
add_line(sys,[395,165;405,165])
add_line(sys,[395,265;405,265])
add_line(sys,[295,375;25,375;25,110;335,110;335,90])
add_line(sys,[630,285;635,285;635,290;670,290])
add_line(sys,[630,305;670,305])
add_line(sys,[705,300;715,300;725,395])
add_line(sys,[320,220;365,220])
add_line(sys,[745,185;745,150;505,150;505,90])
add_line(sys,[630,245;640,245;640,105;590,105;590,90])
add_line(sys,[830,395;840,395;840,110;675,110;675,90])
add_line(sys,[140,290;150,290;150,220;175,220])
add_line(sys,[75,130;40,130;40,175;55,175])
add_line(sys,[75,130;40,130;40,100;250,90])
add_line(sys,[535,310;545,310;545,300;570,300])
add_line(sys,[435,165;445,165;445,190;480,190])
add_line(sys,[435,215;480,215])
add_line(sys,[435,265;445,265;445,240;480,240])
add_line(sys,[435,165;445,165;445,125;420,125;420,90])
add_line(sys,[150,185;175,185])
add_line(sys,[80,185;85,185])

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
