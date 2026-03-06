function [ret,x0,str,ts,xts]=s6(t,x,u,flag);
%s6	is the M-file description of the SIMULINK system named s6.
%	The block-diagram can be displayed by typing: s6.
%
%	SYS=s6(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes s6 to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling s6 with a FLAG of zero:
%	[SIZES]=s6([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[8,46,765,560])
     open_system(sys)
end;
set_param(sys,'algorithm',     'Adams/Gear')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     'tstop')
set_param(sys,'Min step size', '2e-5')
set_param(sys,'Max step size', '1e-2')
set_param(sys,'Relative error','1e-6')
set_param(sys,'Return vars',   '')

add_block('built-in/Mux',[sys,'/','Mux'])
set_param([sys,'/','Mux'],...
		'orientation',3,...
		'inputs','11',...
		'position',[72,65,698,85])

add_block('built-in/Product',[sys,'/','Product1'])
set_param([sys,'/','Product1'],...
		'orientation',2,...
		'position',[340,303,360,327])

add_block('built-in/Product',[sys,'/','Product'])
set_param([sys,'/','Product'],...
		'orientation',2,...
		'position',[340,260,360,280])


%     Subsystem  'Daxis'.

new_system([sys,'/','Daxis'])
set_param([sys,'/','Daxis'],'Location',[173,176,1004,691])

add_block('built-in/Mux',[sys,'/','Daxis/Mux'])
set_param([sys,'/','Daxis/Mux'],...
		'inputs','3',...
		'position',[100,108,120,192])

add_block('built-in/Inport',[sys,'/',['Daxis/in_v''ds']])
set_param([sys,'/',['Daxis/in_v''ds']],...
		'position',[50,140,70,160])

add_block('built-in/Outport',[sys,'/',['Daxis/out_psi''ds']])
set_param([sys,'/',['Daxis/out_psi''ds']],...
		'position',[735,65,755,85])

add_block('built-in/Outport',[sys,'/',['Daxis/out_i''ds']])
set_param([sys,'/',['Daxis/out_i''ds']],...
		'Port','2',...
		'position',[735,130,755,150])

add_block('built-in/Fcn',[sys,'/','Daxis/Fcn4'])
set_param([sys,'/','Daxis/Fcn4'],...
		'Expr','(u[1]-u[2])/xplds',...
		'position',[495,126,590,154])

add_block('built-in/Mux',[sys,'/','Daxis/Mux4'])
set_param([sys,'/','Daxis/Mux4'],...
		'inputs','2',...
		'position',[450,114,470,161])

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
		'Expr','xMd*(u[1]/xplds+u[2]/xplr)',...
		'position',[485,207,635,243])

add_block('built-in/Mux',[sys,'/','Daxis/Mux3'])
set_param([sys,'/','Daxis/Mux3'],...
		'inputs','2',...
		'position',[445,193,465,257])

add_block('built-in/Mux',[sys,'/','Daxis/Mux2'])
set_param([sys,'/','Daxis/Mux2'],...
		'inputs','2',...
		'position',[450,286,470,339])

add_block('built-in/Outport',[sys,'/',['Daxis/out_psidr''']])
set_param([sys,'/',['Daxis/out_psidr''']],...
		'Port','4',...
		'position',[735,260,755,280])

add_block('built-in/Note',[sys,'/','Daxis/ipds'])
set_param([sys,'/','Daxis/ipds'],...
		'position',[610,120,615,125])

add_block('built-in/Fcn',[sys,'/','Daxis/Fcn'])
set_param([sys,'/','Daxis/Fcn'],...
		'Expr','wb*(u[2]+(rpds/xplds)*(u[1]-u[3]))',...
		'position',[135,135,320,165])

add_block('built-in/Integrator',[sys,'/',['Daxis/psi''ds_']])
set_param([sys,'/',['Daxis/psi''ds_']],...
		'Initial','Psipdso',...
		'position',[340,137,370,163])

add_block('built-in/Note',[sys,'/',['Daxis/psi''ds']])
set_param([sys,'/',['Daxis/psi''ds']],...
		'position',[385,130,390,135])

add_block('built-in/Integrator',[sys,'/',['Daxis/psidr''_']])
set_param([sys,'/',['Daxis/psidr''_']],...
		'Initial','Psipdro',...
		'position',[355,287,385,313])

add_block('built-in/Note',[sys,'/',['Daxis/psidr''']])
set_param([sys,'/',['Daxis/psidr''']],...
		'position',[405,276,410,281])

add_block('built-in/Gain',[sys,'/','Daxis/Gain'])
set_param([sys,'/','Daxis/Gain'],...
		'Gain','xmq/(wb*(xplr+xmq))',...
		'position',[400,372,570,428])

add_block('built-in/Outport',[sys,'/',['Daxis/out_dpsidr''//dt']])
set_param([sys,'/',['Daxis/out_dpsidr''//dt']],...
		'Port','5',...
		'position',[735,390,755,410])
add_line([sys,'/','Daxis'],[640,225;695,225;695,365;410,365;410,325;445,325])
add_line([sys,'/','Daxis'],[390,300;445,300])
add_line([sys,'/','Daxis'],[475,315;485,315])
add_line([sys,'/','Daxis'],[390,300;415,300;415,240;440,240])
add_line([sys,'/','Daxis'],[375,150;405,150;405,210;80,210;80,180;95,180])
add_line([sys,'/','Daxis'],[390,300;415,300;415,240;85,240;85,275;100,275])
add_line([sys,'/','Daxis'],[130,300;140,300])
add_line([sys,'/','Daxis'],[640,225;695,225;695,90;80,90;80,120;95,120])
add_line([sys,'/','Daxis'],[640,225;695,225;695,365;75,365;75,325;100,325])
add_line([sys,'/','Daxis'],[640,225;695,225;695,180;425,180;425,150;445,150])
add_line([sys,'/','Daxis'],[375,150;405,150;405,125;445,125])
add_line([sys,'/','Daxis'],[475,140;490,140])
add_line([sys,'/','Daxis'],[470,225;480,225])
add_line([sys,'/','Daxis'],[375,150;405,150;405,210;440,210])
add_line([sys,'/','Daxis'],[330,300;350,300])
add_line([sys,'/','Daxis'],[325,150;335,150])
add_line([sys,'/','Daxis'],[125,150;130,150])
add_line([sys,'/','Daxis'],[595,140;730,140])
add_line([sys,'/','Daxis'],[375,150;405,150;405,75;730,75])
add_line([sys,'/','Daxis'],[75,150;95,150])
add_line([sys,'/','Daxis'],[70,300;100,300])
add_line([sys,'/','Daxis'],[590,315;730,315])
add_line([sys,'/','Daxis'],[390,300;415,300;415,270;730,270])
add_line([sys,'/','Daxis'],[575,400;730,400])
add_line([sys,'/','Daxis'],[330,300;335,300;335,400;395,400])


%     Finished composite block 'Daxis'.

set_param([sys,'/','Daxis'],...
		'position',[330,350,365,420])


%     Subsystem  'Qaxis'.

new_system([sys,'/','Qaxis'])
set_param([sys,'/','Qaxis'],'Location',[213,440,1045,854])

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
		'Expr','(u[1]-u[2])/xlqs',...
		'position',[495,126,585,154])

add_block('built-in/Mux',[sys,'/','Qaxis/Mux4'])
set_param([sys,'/','Qaxis/Mux4'],...
		'inputs','2',...
		'position',[450,114,470,161])

add_block('built-in/Note',[sys,'/','Qaxis/iqs'])
set_param([sys,'/','Qaxis/iqs'],...
		'position',[600,120,605,125])

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
		'Expr','xMq*(u[1]/xlqs+u[2]/xplr)',...
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

add_block('built-in/Integrator',[sys,'/','Qaxis/psiqs_'])
set_param([sys,'/','Qaxis/psiqs_'],...
		'Initial','Psiqso',...
		'position',[340,137,370,163])

add_block('built-in/Fcn',[sys,'/','Qaxis/Fcn'])
set_param([sys,'/','Qaxis/Fcn'],...
		'Expr','wb*(u[2]+(rqs/xlqs)*(u[1]-u[3]))',...
		'position',[135,135,320,165])
add_line([sys,'/','Qaxis'],[640,225;695,225;695,365;410,365;410,325;445,325])
add_line([sys,'/','Qaxis'],[380,300;445,300])
add_line([sys,'/','Qaxis'],[475,315;485,315])
add_line([sys,'/','Qaxis'],[380,300;415,300;415,240;440,240])
add_line([sys,'/','Qaxis'],[375,150;405,150;405,210;80,210;80,180;95,180])
add_line([sys,'/','Qaxis'],[380,300;415,300;415,240;85,240;85,275;100,275])
add_line([sys,'/','Qaxis'],[130,300;140,300])
add_line([sys,'/','Qaxis'],[640,225;695,225;695,90;80,90;80,120;95,120])
add_line([sys,'/','Qaxis'],[640,225;695,225;695,365;75,365;75,325;100,325])
add_line([sys,'/','Qaxis'],[640,225;695,225;695,180;425,180;425,150;445,150])
add_line([sys,'/','Qaxis'],[375,150;405,150;405,125;445,125])
add_line([sys,'/','Qaxis'],[475,140;490,140])
add_line([sys,'/','Qaxis'],[470,225;480,225])
add_line([sys,'/','Qaxis'],[375,150;405,150;405,210;440,210])
add_line([sys,'/','Qaxis'],[330,300;340,300])
add_line([sys,'/','Qaxis'],[325,150;335,150])
add_line([sys,'/','Qaxis'],[125,150;130,150])
add_line([sys,'/','Qaxis'],[590,140;730,140])
add_line([sys,'/','Qaxis'],[375,150;405,150;405,75;730,75])
add_line([sys,'/','Qaxis'],[75,150;95,150])
add_line([sys,'/','Qaxis'],[70,300;100,300])
add_line([sys,'/','Qaxis'],[590,315;730,315])
add_line([sys,'/','Qaxis'],[380,300;415,300;415,270;730,270])


%     Finished composite block 'Qaxis'.

set_param([sys,'/','Qaxis'],...
		'position',[335,178,370,247])


%     Subsystem  'ExtConn'.

new_system([sys,'/','ExtConn'])
set_param([sys,'/','ExtConn'],'Location',[81,184,933,743])

add_block('built-in/Logical Operator',[sys,'/',['ExtConn/Logical',13,'Operator3']])
set_param([sys,'/',['ExtConn/Logical',13,'Operator3']],...
		'Operator','AND',...
		'position',[580,320,610,360])

add_block('built-in/Switch',[sys,'/','ExtConn/Switch'])
set_param([sys,'/','ExtConn/Switch'],...
		'Threshold','0.5',...
		'position',[570,128,590,182])

add_block('built-in/Note',[sys,'/','ExtConn/Vcap'])
set_param([sys,'/','ExtConn/Vcap'],...
		'position',[520,110,525,115])

add_block('built-in/Outport',[sys,'/','ExtConn/out_Vcap'])
set_param([sys,'/','ExtConn/out_Vcap'],...
		'Port','3',...
		'position',[785,190,805,210])

add_block('built-in/Scope',[sys,'/','ExtConn/Scope1'])
set_param([sys,'/','ExtConn/Scope1'],...
		'Vgain','300.000000',...
		'Hgain','2.000000',...
		'Vmax','600.000000',...
		'Hmax','4.000000',...
		'Window',[244,752,972,1007],...
		'position',[735,380,765,410])

add_block('built-in/Outport',[sys,'/',['ExtConn/out_v''ds']])
set_param([sys,'/',['ExtConn/out_v''ds']],...
		'Port','2',...
		'position',[790,115,810,135])

add_block('built-in/Note',[sys,'/',['ExtConn/v''ds']])
set_param([sys,'/',['ExtConn/v''ds']],...
		'position',[765,105,770,110])

add_block('built-in/Outport',[sys,'/','ExtConn/out_vqs'])
set_param([sys,'/','ExtConn/out_vqs'],...
		'position',[765,40,785,60])

add_block('built-in/Switch',[sys,'/','ExtConn/Switch3'])
set_param([sys,'/','ExtConn/Switch3'],...
		'Threshold','0.5',...
		'position',[725,98,745,152])

add_block('built-in/Sum',[sys,'/','ExtConn/Sum2'])
set_param([sys,'/','ExtConn/Sum2'],...
		'inputs','+-',...
		'position',[640,126,660,164])

add_block('built-in/Inport',[sys,'/',['ExtConn/in_dpsidr''//dt']])
set_param([sys,'/',['ExtConn/in_dpsidr''//dt']],...
		'Port','4',...
		'position',[115,445,135,465])

add_block('built-in/Logical Operator',[sys,'/',['ExtConn/Logical',13,'Operator1']])
set_param([sys,'/',['ExtConn/Logical',13,'Operator1']],...
		'orientation',2,...
		'Operator','AND',...
		'position',[355,274,395,301])


%     Subsystem  'ExtConn/Latch1'.

new_system([sys,'/','ExtConn/Latch1'])
set_param([sys,'/','ExtConn/Latch1'],'Location',[102,336,551,502])

add_block('built-in/Fcn',[sys,'/','ExtConn/Latch1/Fcn'])
set_param([sys,'/','ExtConn/Latch1/Fcn'],...
		'orientation',2,...
		'Expr','u[1]>.2',...
		'position',[170,123,205,147])

add_block('built-in/Demux',[sys,'/','ExtConn/Latch1/Demux'])
set_param([sys,'/','ExtConn/Latch1/Demux'],...
		'outputs','2',...
		'position',[275,55,315,90])

add_block('built-in/Combinatorial Logic',[sys,'/','ExtConn/Latch1/Logic'])
set_param([sys,'/','ExtConn/Latch1/Logic'],...
		'Truth Table','[0 1;1 0;0 1;0 1;1 0;1 0;0 0;0 0]',...
		'position',[195,55,250,95])

add_block('built-in/Transport Delay',[sys,'/','ExtConn/Latch1/Transport Delay'])
set_param([sys,'/','ExtConn/Latch1/Transport Delay'],...
		'orientation',2,...
		'Initial Input','ini',...
		'position',[250,120,295,150])

add_block('built-in/Outport',[sys,'/','ExtConn/Latch1/out_2'])
set_param([sys,'/','ExtConn/Latch1/out_2'],...
		'Port','2',...
		'position',[395,70,415,90])

add_block('built-in/Outport',[sys,'/','ExtConn/Latch1/out_1'])
set_param([sys,'/','ExtConn/Latch1/out_1'],...
		'position',[355,55,375,75])

add_block('built-in/Mux',[sys,'/','ExtConn/Latch1/Mux'])
set_param([sys,'/','ExtConn/Latch1/Mux'],...
		'inputs','3',...
		'position',[135,59,165,91])

add_block('built-in/Inport',[sys,'/','ExtConn/Latch1/in_1'])
set_param([sys,'/','ExtConn/Latch1/in_1'],...
		'position',[20,50,40,70])

add_block('built-in/Inport',[sys,'/','ExtConn/Latch1/in_2'])
set_param([sys,'/','ExtConn/Latch1/in_2'],...
		'Port','2',...
		'position',[50,65,70,85])
add_line([sys,'/','ExtConn/Latch1'],[320,65;350,65])
add_line([sys,'/','ExtConn/Latch1'],[335,65;335,135;300,135])
add_line([sys,'/','ExtConn/Latch1'],[165,135;110,135;110,85;130,85])
add_line([sys,'/','ExtConn/Latch1'],[245,135;210,135])
add_line([sys,'/','ExtConn/Latch1'],[75,75;130,75])
add_line([sys,'/','ExtConn/Latch1'],[45,60;105,60;105,65;130,65])
add_line([sys,'/','ExtConn/Latch1'],[170,75;190,75])
add_line([sys,'/','ExtConn/Latch1'],[255,75;270,75])
add_line([sys,'/','ExtConn/Latch1'],[320,80;390,80])
set_param([sys,'/','ExtConn/Latch1'],...
		'Mask Display','S  1\n\nR  0',...
		'Mask Type','Latch',...
		'Mask Dialogue','Latch|Initial State for Output "1":',...
		'Mask Translate','ini=(@1~=0);')
set_param([sys,'/','ExtConn/Latch1'],...
		'Mask Help','Latches the S input.  When S (set) is one, the uncomplemented output (1) becomes one.  The output remains one until the R (reset) input becomes one, forcing the output to zero.  If both R and S are one, the latch will be in an undefined state.')
set_param([sys,'/','ExtConn/Latch1'],...
		'Mask Entries','0\/')


%     Finished composite block 'ExtConn/Latch1'.

set_param([sys,'/','ExtConn/Latch1'],...
		'position',[395,339,425,386])

add_block('built-in/Logical Operator',[sys,'/',['ExtConn/Logical',13,'Operator']])
set_param([sys,'/',['ExtConn/Logical',13,'Operator']],...
		'Operator','AND',...
		'position',[330,330,365,370])

add_block('built-in/Constant',[sys,'/',['ExtConn/cutoff',13,'speed']])
set_param([sys,'/',['ExtConn/cutoff',13,'speed']],...
		'Value','wrswbywb',...
		'position',[105,382,170,408])


%     Subsystem  'ExtConn/Latch'.

new_system([sys,'/','ExtConn/Latch'])
set_param([sys,'/','ExtConn/Latch'],'Location',[102,336,551,502])

add_block('built-in/Fcn',[sys,'/','ExtConn/Latch/Fcn'])
set_param([sys,'/','ExtConn/Latch/Fcn'],...
		'orientation',2,...
		'Expr','u[1]>.2',...
		'position',[170,123,205,147])

add_block('built-in/Demux',[sys,'/','ExtConn/Latch/Demux'])
set_param([sys,'/','ExtConn/Latch/Demux'],...
		'outputs','2',...
		'position',[275,55,315,90])

add_block('built-in/Combinatorial Logic',[sys,'/','ExtConn/Latch/Logic'])
set_param([sys,'/','ExtConn/Latch/Logic'],...
		'Truth Table','[0 1;1 0;0 1;0 1;1 0;1 0;0 0;0 0]',...
		'position',[195,55,250,95])

add_block('built-in/Transport Delay',[sys,'/','ExtConn/Latch/Transport Delay'])
set_param([sys,'/','ExtConn/Latch/Transport Delay'],...
		'orientation',2,...
		'Initial Input','ini',...
		'position',[250,120,295,150])

add_block('built-in/Outport',[sys,'/','ExtConn/Latch/out_2'])
set_param([sys,'/','ExtConn/Latch/out_2'],...
		'Port','2',...
		'position',[395,70,415,90])

add_block('built-in/Outport',[sys,'/','ExtConn/Latch/out_1'])
set_param([sys,'/','ExtConn/Latch/out_1'],...
		'position',[355,55,375,75])

add_block('built-in/Mux',[sys,'/','ExtConn/Latch/Mux'])
set_param([sys,'/','ExtConn/Latch/Mux'],...
		'inputs','3',...
		'position',[135,59,165,91])

add_block('built-in/Inport',[sys,'/','ExtConn/Latch/in_1'])
set_param([sys,'/','ExtConn/Latch/in_1'],...
		'position',[20,50,40,70])

add_block('built-in/Inport',[sys,'/','ExtConn/Latch/in_2'])
set_param([sys,'/','ExtConn/Latch/in_2'],...
		'Port','2',...
		'position',[50,65,70,85])
add_line([sys,'/','ExtConn/Latch'],[320,65;350,65])
add_line([sys,'/','ExtConn/Latch'],[335,65;335,135;300,135])
add_line([sys,'/','ExtConn/Latch'],[165,135;110,135;110,85;130,85])
add_line([sys,'/','ExtConn/Latch'],[245,135;210,135])
add_line([sys,'/','ExtConn/Latch'],[75,75;130,75])
add_line([sys,'/','ExtConn/Latch'],[45,60;105,60;105,65;130,65])
add_line([sys,'/','ExtConn/Latch'],[170,75;190,75])
add_line([sys,'/','ExtConn/Latch'],[255,75;270,75])
add_line([sys,'/','ExtConn/Latch'],[320,80;390,80])
set_param([sys,'/','ExtConn/Latch'],...
		'Mask Display','S  1\n\nR  0',...
		'Mask Type','Latch',...
		'Mask Dialogue','Latch|Initial State for Output "1":',...
		'Mask Translate','ini=(@1~=0);')
set_param([sys,'/','ExtConn/Latch'],...
		'Mask Help','Latches the S input.  When S (set) is one, the uncomplemented output (1) becomes one.  The output remains one until the R (reset) input becomes one, forcing the output to zero.  If both R and S are one, the latch will be in an undefined state.')
set_param([sys,'/','ExtConn/Latch'],...
		'Mask Entries','0\/')


%     Finished composite block 'ExtConn/Latch'.

set_param([sys,'/','ExtConn/Latch'],...
		'position',[270,348,300,392])

add_block('built-in/Inport',[sys,'/','ExtConn/in_wr//wb'])
set_param([sys,'/','ExtConn/in_wr//wb'],...
		'Port','2',...
		'position',[115,345,135,365])

add_block('built-in/Relational Operator',[sys,'/','ExtConn/Rel Op'])
set_param([sys,'/','ExtConn/Rel Op'],...
		'position',[215,348,245,372])

add_block('built-in/Relational Operator',[sys,'/','ExtConn/Rel Op1'])
set_param([sys,'/','ExtConn/Rel Op1'],...
		'Operator','<',...
		'position',[245,273,275,297])

add_block('built-in/Fcn',[sys,'/',['ExtConn/abs(i''ds)']])
set_param([sys,'/',['ExtConn/abs(i''ds)']],...
		'Expr','abs(u[1])',...
		'position',[160,265,200,295])

add_block('built-in/Constant',[sys,'/','ExtConn/eps'])
set_param([sys,'/','ExtConn/eps'],...
		'Value','5e-2',...
		'position',[160,320,195,340])

add_block('built-in/Switch',[sys,'/','ExtConn/Switch1'])
set_param([sys,'/','ExtConn/Switch1'],...
		'Threshold','0.5',...
		'position',[375,76,400,134])

add_block('built-in/Switch',[sys,'/','ExtConn/Switch2'])
set_param([sys,'/','ExtConn/Switch2'],...
		'Threshold','0.5',...
		'position',[370,166,395,224])

add_block('built-in/Integrator',[sys,'/','ExtConn/Vcap_'])
set_param([sys,'/','ExtConn/Vcap_'],...
		'position',[420,180,450,210])

add_block('built-in/Sum',[sys,'/','ExtConn/Sum'])
set_param([sys,'/','ExtConn/Sum'],...
		'position',[485,115,505,150])

add_block('built-in/Gain',[sys,'/','ExtConn/Gain2'])
set_param([sys,'/','ExtConn/Gain2'],...
		'Gain','Nq2Nd',...
		'position',[525,73,595,107])

add_block('built-in/Inport',[sys,'/',['ExtConn/in_i''ds']])
set_param([sys,'/',['ExtConn/in_i''ds']],...
		'Port','3',...
		'position',[40,165,60,185])

add_block('built-in/Inport',[sys,'/','ExtConn/in_vas'])
set_param([sys,'/','ExtConn/in_vas'],...
		'position',[40,40,60,60])

add_block('built-in/Gain',[sys,'/','ExtConn/Rcstart'])
set_param([sys,'/','ExtConn/Rcstart'],...
		'Gain','Rcstart',...
		'position',[255,106,330,144])

add_block('built-in/Gain',[sys,'/','ExtConn/Rcrun'])
set_param([sys,'/','ExtConn/Rcrun'],...
		'Gain','Rcrun',...
		'position',[200,64,255,106])

add_block('built-in/Gain',[sys,'/','ExtConn/1//Cstart'])
set_param([sys,'/','ExtConn/1//Cstart'],...
		'Gain','1/Cstart',...
		'position',[255,198,325,232])

add_block('built-in/Gain',[sys,'/','ExtConn/1//Crun'])
set_param([sys,'/','ExtConn/1//Crun'],...
		'Gain','1/Crun',...
		'position',[200,157,270,193])

add_block('built-in/Constant',[sys,'/','ExtConn/Caprun'])
set_param([sys,'/','ExtConn/Caprun'],...
		'orientation',2,...
		'Value','Caprun',...
		'position',[450,269,505,291])

add_block('built-in/Constant',[sys,'/','ExtConn/Capstart'])
set_param([sys,'/','ExtConn/Capstart'],...
		'orientation',2,...
		'Value','Capstart',...
		'position',[575,270,630,290])

add_block('built-in/Logical Operator',[sys,'/',['ExtConn/Logical',13,'Operator2']])
set_param([sys,'/',['ExtConn/Logical',13,'Operator2']],...
		'orientation',3,...
		'Operator','OR',...
		'position',[527,230,558,250])

add_block('built-in/Switch',[sys,'/','ExtConn/Switch4'])
set_param([sys,'/','ExtConn/Switch4'],...
		'Threshold','0.5',...
		'position',[120,168,140,222])
add_line([sys,'/','ExtConn'],[65,50;760,50])
add_line([sys,'/','ExtConn'],[455,195;460,195;460,140;480,140])
add_line([sys,'/','ExtConn'],[65,50;475,50;475,90;520,90])
add_line([sys,'/','ExtConn'],[600,90;610,90;610,135;635,135])
add_line([sys,'/','ExtConn'],[140,355;210,355])
add_line([sys,'/','ExtConn'],[175,395;190,395;190,365;210,365])
add_line([sys,'/','ExtConn'],[250,360;265,360])
add_line([sys,'/','ExtConn'],[205,280;240,280])
add_line([sys,'/','ExtConn'],[200,330;210,330;210,290;240,290])
add_line([sys,'/','ExtConn'],[280,285;300,285;300,340;325,340])
add_line([sys,'/','ExtConn'],[305,360;325,360])
add_line([sys,'/','ExtConn'],[370,350;390,350])
add_line([sys,'/','ExtConn'],[405,105;465,105;465,125;480,125])
add_line([sys,'/','ExtConn'],[400,195;415,195])
add_line([sys,'/','ExtConn'],[65,175;80,175;80,280;155,280])
add_line([sys,'/','ExtConn'],[430,350;435,350;435,295;400,295])
add_line([sys,'/','ExtConn'],[445,280;400,280])
add_line([sys,'/','ExtConn'],[350,290;340,290;340,195;365,195])
add_line([sys,'/','ExtConn'],[350,290;340,290;340,105;370,105])
add_line([sys,'/','ExtConn'],[335,125;370,125])
add_line([sys,'/','ExtConn'],[260,85;370,85])
add_line([sys,'/','ExtConn'],[330,215;365,215])
add_line([sys,'/','ExtConn'],[275,175;365,175])
add_line([sys,'/','ExtConn'],[545,225;545,155;565,155])
add_line([sys,'/','ExtConn'],[750,125;785,125])
add_line([sys,'/','ExtConn'],[615,340;695,340;695,125;720,125])
add_line([sys,'/','ExtConn'],[570,280;550,280;550,255])
add_line([sys,'/','ExtConn'],[445,280;435,280;435,265;535,255])
add_line([sys,'/','ExtConn'],[665,145;720,145])
add_line([sys,'/','ExtConn'],[140,455;675,455;675,105;720,105])
add_line([sys,'/','ExtConn'],[570,280;550,280;550,330;575,330])
add_line([sys,'/','ExtConn'],[430,350;575,350])
add_line([sys,'/','ExtConn'],[510,135;530,135;530,200;780,200])
add_line([sys,'/','ExtConn'],[65,175;115,175])
add_line([sys,'/','ExtConn'],[545,225;545,215;500,215;500,245;95,245;95,195;115,195])
add_line([sys,'/','ExtConn'],[145,195;165,195;165,215;250,215])
add_line([sys,'/','ExtConn'],[145,195;165,195;165,175;195,175])
add_line([sys,'/','ExtConn'],[145,195;165,195;165,125;250,125])
add_line([sys,'/','ExtConn'],[145,195;165,195;165,85;195,85])
add_line([sys,'/','ExtConn'],[595,155;635,155])
add_line([sys,'/','ExtConn'],[510,135;565,135])


%     Finished composite block 'ExtConn'.

set_param([sys,'/','ExtConn'],...
		'position',[135,276,185,394])

add_block('built-in/Clock',[sys,'/','Clock'])
set_param([sys,'/','Clock'],...
		'position',[75,110,95,130])

add_block('built-in/Note',[sys,'/','psidr'])
set_param([sys,'/','psidr'],...
		'position',[419,395,424,400])

add_block('built-in/Note',[sys,'/','psiqr'])
set_param([sys,'/','psiqr'],...
		'position',[400,225,405,230])

add_block('built-in/Note',[sys,'/','vqs'])
set_param([sys,'/','vqs'],...
		'position',[235,175,240,180])

add_block('built-in/Note',[sys,'/',['v''ds']])
set_param([sys,'/',['v''ds']],...
		'position',[240,310,245,315])

add_block('built-in/Note',[sys,'/','psiqs'])
set_param([sys,'/','psiqs'],...
		'position',[405,170,410,175])

add_block('built-in/Note',[sys,'/','iqs'])
set_param([sys,'/','iqs'],...
		'position',[400,190,405,195])

add_block('built-in/Note',[sys,'/',['i''ds']])
set_param([sys,'/',['i''ds']],...
		'position',[390,355,395,360])

add_block('built-in/Note',[sys,'/',['psi''ds']])
set_param([sys,'/',['psi''ds']],...
		'position',[385,340,390,345])


%     Subsystem  'Rotor'.

new_system([sys,'/','Rotor'])
set_param([sys,'/','Rotor'],'Location',[149,82,804,355])

add_block('built-in/Outport',[sys,'/','Rotor/out_Tem'])
set_param([sys,'/','Rotor/out_Tem'],...
		'position',[540,60,560,80])

add_block('built-in/Sum',[sys,'/','Rotor/Taccl'])
set_param([sys,'/','Rotor/Taccl'],...
		'inputs','++-',...
		'position',[355,95,370,175])

add_block('built-in/Gain',[sys,'/','Rotor/1//2H'])
set_param([sys,'/','Rotor/1//2H'],...
		'Gain','1/(2*H)',...
		'position',[395,109,460,161])

add_block('built-in/Integrator',[sys,'/','Rotor/1//s'])
set_param([sys,'/','Rotor/1//s'],...
		'Initial','wrbywbo',...
		'position',[480,120,510,150])

add_block('built-in/Outport',[sys,'/','Rotor/out_wr//wb'])
set_param([sys,'/','Rotor/out_wr//wb'],...
		'Port','2',...
		'position',[550,123,570,147])

add_block('built-in/Gain',[sys,'/',['Rotor/Damping',13,'coefficient']])
set_param([sys,'/',['Rotor/Damping',13,'coefficient']],...
		'orientation',2,...
		'Gain','Domega',...
		'position',[440,177,510,213])

add_block('built-in/Note',[sys,'/','Rotor/Tdamp'])
set_param([sys,'/','Rotor/Tdamp'],...
		'position',[405,175,410,180])

add_block('built-in/Fcn',[sys,'/','Rotor/Tem_'])
set_param([sys,'/','Rotor/Tem_'],...
		'Expr','Tfactor*(u[3]*u[2]-u[1]*u[4])',...
		'position',[150,96,310,124])

add_block('built-in/Mux',[sys,'/','Rotor/Mux'])
set_param([sys,'/','Rotor/Mux'],...
		'position',[105,26,130,194])

add_block('built-in/Inport',[sys,'/','Rotor/in_psiqs'])
set_param([sys,'/','Rotor/in_psiqs'],...
		'position',[55,40,75,60])

add_block('built-in/Inport',[sys,'/','Rotor/in_iqs'])
set_param([sys,'/','Rotor/in_iqs'],...
		'Port','2',...
		'position',[55,80,75,100])

add_block('built-in/Inport',[sys,'/',['Rotor/in_psi''ds']])
set_param([sys,'/',['Rotor/in_psi''ds']],...
		'Port','3',...
		'position',[55,120,75,140])

add_block('built-in/Inport',[sys,'/',['Rotor/in_i''ds']])
set_param([sys,'/',['Rotor/in_i''ds']],...
		'Port','4',...
		'position',[55,160,75,180])

add_block('built-in/Inport',[sys,'/','Rotor/in_Tmech'])
set_param([sys,'/','Rotor/in_Tmech'],...
		'Port','5',...
		'position',[55,200,75,220])
add_line([sys,'/','Rotor'],[515,135;545,135])
add_line([sys,'/','Rotor'],[80,210;310,210;310,135;350,135])
add_line([sys,'/','Rotor'],[375,135;390,135])
add_line([sys,'/','Rotor'],[465,135;475,135])
add_line([sys,'/','Rotor'],[315,110;350,110])
add_line([sys,'/','Rotor'],[315,110;325,110;325,70;535,70])
add_line([sys,'/','Rotor'],[515,135;530,135;530,195;515,195])
add_line([sys,'/','Rotor'],[435,195;330,195;330,160;350,160])
add_line([sys,'/','Rotor'],[135,110;145,110])
add_line([sys,'/','Rotor'],[80,50;100,50])
add_line([sys,'/','Rotor'],[80,90;100,90])
add_line([sys,'/','Rotor'],[80,130;100,130])
add_line([sys,'/','Rotor'],[80,170;100,170])


%     Finished composite block 'Rotor'.

set_param([sys,'/','Rotor'],...
		'position',[575,223,620,387])

add_block('built-in/Note',[sys,'/','wr//wb'])
set_param([sys,'/','wr//wb'],...
		'position',[640,320,645,325])

add_block('built-in/Note',[sys,'/','Tem'])
set_param([sys,'/','Tem'],...
		'position',[629,242,634,247])


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
		'Mask Entries','tmech_time\/tmech_value\/')


%     Finished composite block 'Tmech'.

set_param([sys,'/','Tmech'],...
		'position',[460,379,530,401])

add_block('built-in/To Workspace',[sys,'/','To Workspace'])
set_param([sys,'/','To Workspace'],...
		'mat-name','y',...
		'buffer','80000',...
		'position',[475,26,520,44])

add_block('built-in/Scope',[sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'orientation',2,...
		'Vgain','200.000000',...
		'Hgain','2.000000',...
		'Vmax','400.000000',...
		'Hmax','4.000000',...
		'Window',[4,392,781,579])
open_system([sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'position',[270,24,290,46])

add_block('built-in/Note',[sys,'/',['Single-Phase Induction ',13,'Machine Simulation']])
set_param([sys,'/',['Single-Phase Induction ',13,'Machine Simulation']],...
		'position',[145,20,150,25])

add_block('built-in/Sine Wave',[sys,'/','Sine Wave'])
set_param([sys,'/','Sine Wave'],...
		'amplitude','Vm',...
		'frequency','we',...
		'phase','-pi/2',...
		'position',[60,280,105,300])


%     Subsystem  'm6'.

new_system([sys,'/','m6'])
set_param([sys,'/','m6'],'Location',[10,55,1133,881])

add_block('built-in/Note',[sys,'/',['m6/Masked block of m6.m to initialize s6.m ',13,'and plot results']])
set_param([sys,'/',['m6/Masked block of m6.m to initialize s6.m ',13,'and plot results']],...
		'position',[85,60,90,65])
set_param([sys,'/','m6'],...
		'Mask Display','Initialize\nand plot',...
		'Mask Type','Masked block of m6.m',...
		'Mask Dialogue','eval(''m6'')',...
		'Mask Help','Uses m6.m to initialize and plot')


%     Finished composite block 'm6'.

set_param([sys,'/','m6'],...
		'Drop Shadow',4,...
		'position',[68,177,139,220])
add_line(sys,[335,315;315,315;315,230;330,230])
add_line(sys,[190,335;290,335;290,370;325,370])
add_line(sys,[190,295;190,195;330,195])
add_line(sys,[335,270;305,270;305,405;325,405])
add_line(sys,[625,345;660,345;660,415;425,415;425,275;365,275])
add_line(sys,[625,345;660,345;660,415;425,415;425,310;365,310])
add_line(sys,[385,60;385,35;470,35])
add_line(sys,[385,60;385,35;295,35])
add_line(sys,[375,235;385,235;385,265;365,265])
add_line(sys,[370,400;400,400;400,320;365,320])
add_line(sys,[535,390;550,390;550,365;570,365])
add_line(sys,[375,190;530,190;530,245;570,245])
add_line(sys,[375,205;515,205;515,275;570,275])
add_line(sys,[370,355;440,355;440,305;570,305])
add_line(sys,[370,370;495,370;495,335;570,335])
add_line(sys,[370,370;390,370;390,455;105,455;105,350;130,350])
add_line(sys,[625,345;660,345;660,465;90,465;90,320;130,320])
add_line(sys,[110,290;130,290])
add_line(sys,[100,120;110,120;110,90])
add_line(sys,[190,295;190,130;165,130;165,90])
add_line(sys,[190,335;220,335;220,90])
add_line(sys,[625,345;660,345;660,90])
add_line(sys,[625,265;645,265;645,160;605,160;605,90])
add_line(sys,[535,390;550,390;550,90])
add_line(sys,[370,370;495,370;495,90])
add_line(sys,[370,355;440,355;440,90])
add_line(sys,[375,205;385,205;385,90])
add_line(sys,[375,190;375,135;330,135;330,90])
add_line(sys,[190,375;275,375;275,90])
add_line(sys,[370,415;380,415;380,440;120,440;130,380])

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
