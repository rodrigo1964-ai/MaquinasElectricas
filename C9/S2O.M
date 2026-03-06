function [ret,x0,str,ts,xts]=s2o(t,x,u,flag);
%s2o	is the M-file description of the SIMULINK system named s2o.
%	The block-diagram can be displayed by typing: s2o.
%
%	SYS=s2o(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes s2o to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling s2o with a FLAG of zero:
%	[SIZES]=s2o([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[166,80,961,496])
     open_system(sys)
end;
set_param(sys,'algorithm',     'Adams/Gear')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     'tstop')
set_param(sys,'Min step size', '1e-4')
set_param(sys,'Max step size', '1e-2')
set_param(sys,'Relative error','1e-5')
set_param(sys,'Return vars',   '')


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
		'position',[410,269,450,291])

add_block('built-in/Sum',[sys,'/','Sum'])
set_param([sys,'/','Sum'],...
		'inputs','+++',...
		'position',[715,226,735,264])

add_block('built-in/Mux',[sys,'/','Mux1'])
set_param([sys,'/','Mux1'],...
		'inputs','2',...
		'position',[420,151,440,184])

add_block('built-in/Note',[sys,'/','wr//wb'])
set_param([sys,'/','wr//wb'],...
		'position',[445,220,450,225])

add_block('built-in/Fcn',[sys,'/','Fcn'])
set_param([sys,'/','Fcn'],...
		'Expr','sqrt(u[1]*u[1]+u[2]*u[2])',...
		'position',[465,159,495,181])

add_block('built-in/Product',[sys,'/','Product1'])
set_param([sys,'/','Product1'],...
		'orientation',2,...
		'position',[340,243,360,267])

add_block('built-in/Product',[sys,'/','Product'])
set_param([sys,'/','Product'],...
		'orientation',2,...
		'position',[335,199,355,221])

add_block('built-in/Fcn',[sys,'/','Fcn1'])
set_param([sys,'/','Fcn1'],...
		'Expr','sqrt(u[1]*u[1]+u[2]*u[2])',...
		'position',[640,125,680,145])

add_block('built-in/Mux',[sys,'/','Mux2'])
set_param([sys,'/','Mux2'],...
		'inputs','2',...
		'position',[595,115,615,155])


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
		'position',[320,120,355,175])

add_block('built-in/Note',[sys,'/','ias'])
set_param([sys,'/','ias'],...
		'position',[685,190,690,195])

add_block('built-in/Note',[sys,'/','i0s'])
set_param([sys,'/','i0s'],...
		'position',[505,340,510,345])


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

add_block('built-in/Scope',[sys,'/','Zero_seq/Scope1'])
set_param([sys,'/','Zero_seq/Scope1'],...
		'Vgain','2.000000',...
		'Hgain','0.200000',...
		'Vmax','2.000000',...
		'Hmax','0.384615',...
		'Window',[208,515,1101,682],...
		'position',[375,106,405,134])
add_line([sys,'/','Zero_seq'],[195,140;115,140;115,90;135,90])
add_line([sys,'/','Zero_seq'],[300,80;310,80;310,140;250,140])
add_line([sys,'/','Zero_seq'],[170,80;195,80])
add_line([sys,'/','Zero_seq'],[245,80;260,80])
add_line([sys,'/','Zero_seq'],[80,70;135,70])
add_line([sys,'/','Zero_seq'],[300,80;360,80])


%     Finished composite block 'Zero_seq'.

set_param([sys,'/','Zero_seq'],...
		'position',[445,335,480,385])


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
		'position',[330,295,365,350])

add_block('built-in/Note',[sys,'/','Tem'])
set_param([sys,'/','Tem'],...
		'position',[449,192,454,197])

add_block('built-in/Note',[sys,'/','vcg'])
set_param([sys,'/','vcg'],...
		'position',[147,235,152,240])

add_block('built-in/Note',[sys,'/','vbg'])
set_param([sys,'/','vbg'],...
		'position',[147,210,152,215])


%     Subsystem  'Rotor'.

new_system([sys,'/','Rotor'])
set_param([sys,'/','Rotor'],'Location',[330,112,965,358])

add_block('built-in/Sum',[sys,'/','Rotor/Sum1'])
set_param([sys,'/','Rotor/Sum1'],...
		'inputs','+-',...
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

add_block('built-in/Inport',[sys,'/','Rotor/Tload'])
set_param([sys,'/','Rotor/Tload'],...
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
add_line([sys,'/','Rotor'],[90,210;325,210;325,150;350,150])
add_line([sys,'/','Rotor'],[90,170;95,170;95,150;115,150])
add_line([sys,'/','Rotor'],[380,130;385,130])
add_line([sys,'/','Rotor'],[460,130;475,130])
add_line([sys,'/','Rotor'],[320,110;350,110])
add_line([sys,'/','Rotor'],[320,110;325,110;325,70;535,70])


%     Finished composite block 'Rotor'.

set_param([sys,'/','Rotor'],...
		'orientation',2,...
		'position',[465,194,505,266])

add_block('built-in/Note',[sys,'/','v0s'])
set_param([sys,'/','v0s'],...
		'position',[250,220,255,225])

add_block('built-in/Note',[sys,'/','vqs'])
set_param([sys,'/','vqs'],...
		'position',[250,180,255,185])

add_block('built-in/Note',[sys,'/','vds'])
set_param([sys,'/','vds'],...
		'position',[250,200,255,205])


%     Subsystem  'abc2qds'.

new_system([sys,'/','abc2qds'])
set_param([sys,'/','abc2qds'],'Location',[127,439,811,823])

add_block('built-in/Note',[sys,'/','abc2qds/abc to qd0 stationary '])
set_param([sys,'/','abc2qds/abc to qd0 stationary '],...
		'position',[255,45,260,50])

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

add_block('built-in/Scope',[sys,'/','abc2qds/Scope1'])
set_param([sys,'/','abc2qds/Scope1'],...
		'Vgain','300.000000',...
		'Hgain','0.300000',...
		'Vmax','300.000000',...
		'Hmax','0.566038',...
		'Window',[439,261,1332,428],...
		'position',[495,296,525,324])

add_block('built-in/Mux',[sys,'/','abc2qds/Mux'])
set_param([sys,'/','abc2qds/Mux'],...
		'inputs','3',...
		'position',[90,81,130,259])

add_block('built-in/Sum',[sys,'/','abc2qds/Sum2'])
set_param([sys,'/','abc2qds/Sum2'],...
		'inputs','+-',...
		'position',[485,85,500,120])

add_block('built-in/Outport',[sys,'/','abc2qds/vqs'])
set_param([sys,'/','abc2qds/vqs'],...
		'position',[530,95,550,115])

add_block('built-in/Gain',[sys,'/','abc2qds/Gain'])
set_param([sys,'/','abc2qds/Gain'],...
		'Gain','-sqrt(3)',...
		'position',[375,129,440,171])

add_block('built-in/Outport',[sys,'/','abc2qds/vbs-vcs'])
set_param([sys,'/','abc2qds/vbs-vcs'],...
		'Port','5',...
		'position',[525,140,545,160])

add_block('built-in/Fcn',[sys,'/','abc2qds/Fcn'])
set_param([sys,'/','abc2qds/Fcn'],...
		'Expr','(2/3)*(u[1] - (u[2]+u[3])/2)',...
		'position',[170,81,330,109])

add_block('built-in/Fcn',[sys,'/','abc2qds/Fcn1'])
set_param([sys,'/','abc2qds/Fcn1'],...
		'Expr','(u[3]-u[2])/sqrt(3)',...
		'position',[170,157,330,183])

add_block('built-in/Fcn',[sys,'/','abc2qds/Fcn2'])
set_param([sys,'/','abc2qds/Fcn2'],...
		'Expr','(u[1]+u[2]+u[3])/3',...
		'position',[170,220,325,250])

add_block('built-in/Outport',[sys,'/','abc2qds/vas'])
set_param([sys,'/','abc2qds/vas'],...
		'Port','4',...
		'position',[530,30,550,50])

add_block('built-in/Sum',[sys,'/','abc2qds/Sum1'])
set_param([sys,'/','abc2qds/Sum1'],...
		'position',[490,20,505,60])

add_block('built-in/Sum',[sys,'/','abc2qds/Sum'])
set_param([sys,'/','abc2qds/Sum'],...
		'inputs','+-',...
		'position',[425,223,440,267])

add_block('built-in/Outport',[sys,'/','abc2qds/vds'])
set_param([sys,'/','abc2qds/vds'],...
		'Port','2',...
		'position',[525,180,545,200])

add_block('built-in/Outport',[sys,'/','abc2qds/v0s'])
set_param([sys,'/','abc2qds/v0s'],...
		'Port','3',...
		'position',[520,235,540,255])

add_block('built-in/Integrator',[sys,'/','abc2qds/Integrator'])
set_param([sys,'/','abc2qds/Integrator'],...
		'position',[285,272,310,308])

add_block('built-in/Inport',[sys,'/','abc2qds/ias+ibs+ics'])
set_param([sys,'/','abc2qds/ias+ibs+ics'],...
		'Port','4',...
		'position',[40,280,60,300])

add_block('built-in/Note',[sys,'/','abc2qds/vsg'])
set_param([sys,'/','abc2qds/vsg'],...
		'position',[330,270,335,275])

add_block('built-in/Gain',[sys,'/','abc2qds/Rsg'])
set_param([sys,'/','abc2qds/Rsg'],...
		'Gain','50*Zb*wb',...
		'position',[140,270,230,310])
add_line([sys,'/','abc2qds'],[65,290;135,290])
add_line([sys,'/','abc2qds'],[65,110;85,110])
add_line([sys,'/','abc2qds'],[65,170;85,170])
add_line([sys,'/','abc2qds'],[65,230;85,230])
add_line([sys,'/','abc2qds'],[135,170;165,170])
add_line([sys,'/','abc2qds'],[135,170;145,170;145,95;165,95])
add_line([sys,'/','abc2qds'],[335,170;345,170;345,190;520,190])
add_line([sys,'/','abc2qds'],[135,170;145,170;145,235;165,235])
add_line([sys,'/','abc2qds'],[445,245;515,245])
add_line([sys,'/','abc2qds'],[330,235;420,235])
add_line([sys,'/','abc2qds'],[510,40;525,40])
add_line([sys,'/','abc2qds'],[445,150;520,150])
add_line([sys,'/','abc2qds'],[335,170;345,170;345,150;370,150])
add_line([sys,'/','abc2qds'],[445,245;460,245;460,50;485,50])
add_line([sys,'/','abc2qds'],[335,95;370,95;370,30;485,30])
add_line([sys,'/','abc2qds'],[335,95;480,95])
add_line([sys,'/','abc2qds'],[505,105;525,105])
add_line([sys,'/','abc2qds'],[315,290;360,290;360,255;420,255])
add_line([sys,'/','abc2qds'],[315,290;360,290;360,110;480,110])
add_line([sys,'/','abc2qds'],[235,290;280,290])


%     Finished composite block 'abc2qds'.

set_param([sys,'/','abc2qds'],...
		'position',[185,187,225,293])

add_block('built-in/Note',[sys,'/','vag'])
set_param([sys,'/','vag'],...
		'position',[147,185,152,190])


%     Subsystem  ['Variable ',13,'Freq. source'].

new_system([sys,'/',['Variable ',13,'Freq. source']])
set_param([sys,'/',['Variable ',13,'Freq. source']],'Location',[61,189,853,500])

add_block('built-in/Scope',[sys,'/',['Variable ',13,'Freq. source/Scope1']])
set_param([sys,'/',['Variable ',13,'Freq. source/Scope1']],...
		'Vgain','1.000000',...
		'Hgain','0.300000',...
		'Vmax','1.000000',...
		'Hmax','0.566038',...
		'Window',[165,735,1058,902],...
		'position',[675,32,695,58])

add_block('built-in/Gain',[sys,'/',['Variable ',13,'Freq. source/Vb//wb']])
set_param([sys,'/',['Variable ',13,'Freq. source/Vb//wb']],...
		'Gain','.43315*pi/4',...
		'position',[100,35,205,75])

add_block('built-in/Note',[sys,'/',['Variable ',13,'Freq. source/Vpk']])
set_param([sys,'/',['Variable ',13,'Freq. source/Vpk']],...
		'position',[250,35,255,40])


%     Subsystem  ['Variable ',13,'Freq. source/Sign'].

new_system([sys,'/',['Variable ',13,'Freq. source/Sign']])
set_param([sys,'/',['Variable ',13,'Freq. source/Sign']],'Location',[159,417,467,586])

add_block('built-in/Outport',[sys,'/',['Variable ',13,'Freq. source/Sign/out_1']])
set_param([sys,'/',['Variable ',13,'Freq. source/Sign/out_1']],...
		'position',[265,70,285,90])

add_block('built-in/Inport',[sys,'/',['Variable ',13,'Freq. source/Sign/in_1']])
set_param([sys,'/',['Variable ',13,'Freq. source/Sign/in_1']],...
		'position',[35,30,55,50])

add_block('built-in/Relational Operator',[sys,'/',['Variable ',13,'Freq. source/Sign/Relational',13,'Operator']])
set_param([sys,'/',['Variable ',13,'Freq. source/Sign/Relational',13,'Operator']],...
		'Operator','>',...
		'position',[140,32,170,63])

add_block('built-in/Sum',[sys,'/',['Variable ',13,'Freq. source/Sign/Sum']])
set_param([sys,'/',['Variable ',13,'Freq. source/Sign/Sum']],...
		'inputs','+-',...
		'position',[215,64,235,91])

add_block('built-in/Relational Operator',[sys,'/',['Variable ',13,'Freq. source/Sign/Relational',13,'Operator1']])
set_param([sys,'/',['Variable ',13,'Freq. source/Sign/Relational',13,'Operator1']],...
		'Operator','<',...
		'position',[140,92,170,123])

add_block('built-in/Constant',[sys,'/',['Variable ',13,'Freq. source/Sign/Constant']])
set_param([sys,'/',['Variable ',13,'Freq. source/Sign/Constant']],...
		'Value','0',...
		'position',[65,105,85,125])
add_line([sys,'/',['Variable ',13,'Freq. source/Sign']],[60,40;135,40])
add_line([sys,'/',['Variable ',13,'Freq. source/Sign']],[95,40;95,100;135,100])
add_line([sys,'/',['Variable ',13,'Freq. source/Sign']],[90,115;135,115])
add_line([sys,'/',['Variable ',13,'Freq. source/Sign']],[110,115;110,55;135,55])
add_line([sys,'/',['Variable ',13,'Freq. source/Sign']],[175,110;185,110;185,85;210,85])
add_line([sys,'/',['Variable ',13,'Freq. source/Sign']],[175,50;185,50;185,70;210,70])
add_line([sys,'/',['Variable ',13,'Freq. source/Sign']],[240,80;260,80])
set_param([sys,'/',['Variable ',13,'Freq. source/Sign']],...
		'Mask Display','plot(-50,-50,50,50,[-50,50],[0,0],[0,0],[-50,50],[-40,0],[-30,-30],[0,40],[30,30])',...
		'Mask Type','Sign',...
		'Mask Dialogue','y = sign(x)')
set_param([sys,'/',['Variable ',13,'Freq. source/Sign']],...
		'Mask Help','Sign Function:\n\t\t\ty = 1 if x > 0\n\t\t\ty = 0 if x = 0\n\t\t\ty = -1 if x < 0')


%     Finished composite block ['Variable ',13,'Freq. source/Sign'].

set_param([sys,'/',['Variable ',13,'Freq. source/Sign']],...
		'position',[570,102,600,128])


%     Subsystem  ['Variable ',13,'Freq. source/Sign1'].

new_system([sys,'/',['Variable ',13,'Freq. source/Sign1']])
set_param([sys,'/',['Variable ',13,'Freq. source/Sign1']],'Location',[159,417,467,586])

add_block('built-in/Outport',[sys,'/',['Variable ',13,'Freq. source/Sign1/out_1']])
set_param([sys,'/',['Variable ',13,'Freq. source/Sign1/out_1']],...
		'position',[265,70,285,90])

add_block('built-in/Inport',[sys,'/',['Variable ',13,'Freq. source/Sign1/in_1']])
set_param([sys,'/',['Variable ',13,'Freq. source/Sign1/in_1']],...
		'position',[35,30,55,50])

add_block('built-in/Relational Operator',[sys,'/',['Variable ',13,'Freq. source/Sign1/Relational',13,'Operator']])
set_param([sys,'/',['Variable ',13,'Freq. source/Sign1/Relational',13,'Operator']],...
		'Operator','>',...
		'position',[140,32,170,63])

add_block('built-in/Sum',[sys,'/',['Variable ',13,'Freq. source/Sign1/Sum']])
set_param([sys,'/',['Variable ',13,'Freq. source/Sign1/Sum']],...
		'inputs','+-',...
		'position',[215,64,235,91])

add_block('built-in/Relational Operator',[sys,'/',['Variable ',13,'Freq. source/Sign1/Relational',13,'Operator1']])
set_param([sys,'/',['Variable ',13,'Freq. source/Sign1/Relational',13,'Operator1']],...
		'Operator','<',...
		'position',[140,92,170,123])

add_block('built-in/Constant',[sys,'/',['Variable ',13,'Freq. source/Sign1/Constant']])
set_param([sys,'/',['Variable ',13,'Freq. source/Sign1/Constant']],...
		'Value','0',...
		'position',[65,105,85,125])
add_line([sys,'/',['Variable ',13,'Freq. source/Sign1']],[60,40;135,40])
add_line([sys,'/',['Variable ',13,'Freq. source/Sign1']],[95,40;95,100;135,100])
add_line([sys,'/',['Variable ',13,'Freq. source/Sign1']],[90,115;135,115])
add_line([sys,'/',['Variable ',13,'Freq. source/Sign1']],[110,115;110,55;135,55])
add_line([sys,'/',['Variable ',13,'Freq. source/Sign1']],[175,110;185,110;185,85;210,85])
add_line([sys,'/',['Variable ',13,'Freq. source/Sign1']],[175,50;185,50;185,70;210,70])
add_line([sys,'/',['Variable ',13,'Freq. source/Sign1']],[240,80;260,80])
set_param([sys,'/',['Variable ',13,'Freq. source/Sign1']],...
		'Mask Display','plot(-50,-50,50,50,[-50,50],[0,0],[0,0],[-50,50],[-40,0],[-30,-30],[0,40],[30,30])',...
		'Mask Type','Sign',...
		'Mask Dialogue','y = sign(x)')
set_param([sys,'/',['Variable ',13,'Freq. source/Sign1']],...
		'Mask Help','Sign Function:\n\t\t\ty = 1 if x > 0\n\t\t\ty = 0 if x = 0\n\t\t\ty = -1 if x < 0')


%     Finished composite block ['Variable ',13,'Freq. source/Sign1'].

set_param([sys,'/',['Variable ',13,'Freq. source/Sign1']],...
		'position',[565,162,595,188])


%     Subsystem  ['Variable ',13,'Freq. source/Sign2'].

new_system([sys,'/',['Variable ',13,'Freq. source/Sign2']])
set_param([sys,'/',['Variable ',13,'Freq. source/Sign2']],'Location',[159,417,467,586])

add_block('built-in/Outport',[sys,'/',['Variable ',13,'Freq. source/Sign2/out_1']])
set_param([sys,'/',['Variable ',13,'Freq. source/Sign2/out_1']],...
		'position',[265,70,285,90])

add_block('built-in/Inport',[sys,'/',['Variable ',13,'Freq. source/Sign2/in_1']])
set_param([sys,'/',['Variable ',13,'Freq. source/Sign2/in_1']],...
		'position',[35,30,55,50])

add_block('built-in/Relational Operator',[sys,'/',['Variable ',13,'Freq. source/Sign2/Relational',13,'Operator']])
set_param([sys,'/',['Variable ',13,'Freq. source/Sign2/Relational',13,'Operator']],...
		'Operator','>',...
		'position',[140,32,170,63])

add_block('built-in/Sum',[sys,'/',['Variable ',13,'Freq. source/Sign2/Sum']])
set_param([sys,'/',['Variable ',13,'Freq. source/Sign2/Sum']],...
		'inputs','+-',...
		'position',[215,64,235,91])

add_block('built-in/Relational Operator',[sys,'/',['Variable ',13,'Freq. source/Sign2/Relational',13,'Operator1']])
set_param([sys,'/',['Variable ',13,'Freq. source/Sign2/Relational',13,'Operator1']],...
		'Operator','<',...
		'position',[140,92,170,123])

add_block('built-in/Constant',[sys,'/',['Variable ',13,'Freq. source/Sign2/Constant']])
set_param([sys,'/',['Variable ',13,'Freq. source/Sign2/Constant']],...
		'Value','0',...
		'position',[65,105,85,125])
add_line([sys,'/',['Variable ',13,'Freq. source/Sign2']],[60,40;135,40])
add_line([sys,'/',['Variable ',13,'Freq. source/Sign2']],[95,40;95,100;135,100])
add_line([sys,'/',['Variable ',13,'Freq. source/Sign2']],[90,115;135,115])
add_line([sys,'/',['Variable ',13,'Freq. source/Sign2']],[110,115;110,55;135,55])
add_line([sys,'/',['Variable ',13,'Freq. source/Sign2']],[175,110;185,110;185,85;210,85])
add_line([sys,'/',['Variable ',13,'Freq. source/Sign2']],[175,50;185,50;185,70;210,70])
add_line([sys,'/',['Variable ',13,'Freq. source/Sign2']],[240,80;260,80])
set_param([sys,'/',['Variable ',13,'Freq. source/Sign2']],...
		'Mask Display','plot(-50,-50,50,50,[-50,50],[0,0],[0,0],[-50,50],[-40,0],[-30,-30],[0,40],[30,30])',...
		'Mask Type','Sign',...
		'Mask Dialogue','y = sign(x)')
set_param([sys,'/',['Variable ',13,'Freq. source/Sign2']],...
		'Mask Help','Sign Function:\n\t\t\ty = 1 if x > 0\n\t\t\ty = 0 if x = 0\n\t\t\ty = -1 if x < 0')


%     Finished composite block ['Variable ',13,'Freq. source/Sign2'].

set_param([sys,'/',['Variable ',13,'Freq. source/Sign2']],...
		'position',[565,222,595,248])

add_block('built-in/Outport',[sys,'/',['Variable ',13,'Freq. source/vag']])
set_param([sys,'/',['Variable ',13,'Freq. source/vag']],...
		'position',[720,100,740,120])

add_block('built-in/Outport',[sys,'/',['Variable ',13,'Freq. source/vbg']])
set_param([sys,'/',['Variable ',13,'Freq. source/vbg']],...
		'Port','2',...
		'position',[715,160,735,180])

add_block('built-in/Outport',[sys,'/',['Variable ',13,'Freq. source/vcg']])
set_param([sys,'/',['Variable ',13,'Freq. source/vcg']],...
		'Port','3',...
		'position',[720,220,740,240])

add_block('built-in/Fcn',[sys,'/',['Variable ',13,'Freq. source/Fcn1']])
set_param([sys,'/',['Variable ',13,'Freq. source/Fcn1']],...
		'Expr','(-u[1]-sqrt(3)*u[2])/2',...
		'position',[410,156,530,194])

add_block('built-in/Fcn',[sys,'/',['Variable ',13,'Freq. source/Fcn2']])
set_param([sys,'/',['Variable ',13,'Freq. source/Fcn2']],...
		'Expr','(-u[1]+sqrt(3)*u[2])/2',...
		'position',[410,218,535,252])

add_block('built-in/Product',[sys,'/',['Variable ',13,'Freq. source/Product1']])
set_param([sys,'/',['Variable ',13,'Freq. source/Product1']],...
		'position',[655,158,685,182])

add_block('built-in/Product',[sys,'/',['Variable ',13,'Freq. source/Product']])
set_param([sys,'/',['Variable ',13,'Freq. source/Product']],...
		'position',[650,98,680,122])

add_block('built-in/Product',[sys,'/',['Variable ',13,'Freq. source/Product2']])
set_param([sys,'/',['Variable ',13,'Freq. source/Product2']],...
		'position',[655,218,685,242])

add_block('built-in/Fcn',[sys,'/',['Variable ',13,'Freq. source/Fcn']])
set_param([sys,'/',['Variable ',13,'Freq. source/Fcn']],...
		'Expr','u[1]',...
		'position',[415,98,535,132])

add_block('built-in/Mux',[sys,'/',['Variable ',13,'Freq. source/Mux']])
set_param([sys,'/',['Variable ',13,'Freq. source/Mux']],...
		'inputs','2',...
		'position',[340,104,370,246])

add_block('built-in/Note',[sys,'/',['Variable ',13,'Freq. source/cos_wet']])
set_param([sys,'/',['Variable ',13,'Freq. source/cos_wet']],...
		'position',[310,104,315,109])

add_block('built-in/Constant',[sys,'/',['Variable ',13,'Freq. source/we']])
set_param([sys,'/',['Variable ',13,'Freq. source/we']],...
		'Value','377',...
		'position',[25,113,50,147])

add_block('built-in/Note',[sys,'/',['Variable ',13,'Freq. source/sin_wet']])
set_param([sys,'/',['Variable ',13,'Freq. source/sin_wet']],...
		'position',[300,181,305,186])

add_block('built-in/Gain',[sys,'/',['Variable ',13,'Freq. source/-1']])
set_param([sys,'/',['Variable ',13,'Freq. source/-1']],...
		'Gain','-1',...
		'position',[185,233,225,267])

add_block('built-in/Integrator',[sys,'/',['Variable ',13,'Freq. source/cos']])
set_param([sys,'/',['Variable ',13,'Freq. source/cos']],...
		'Initial','1',...
		'position',[235,120,270,160])


%     Subsystem  ['Variable ',13,'Freq. source/Inner',13,'Product1'].

new_system([sys,'/',['Variable ',13,'Freq. source/Inner',13,'Product1']])
set_param([sys,'/',['Variable ',13,'Freq. source/Inner',13,'Product1']],'Location',[33,479,253,634])

add_block('built-in/Product',[sys,'/',['Variable ',13,'Freq. source/Inner',13,'Product1/Product']])
set_param([sys,'/',['Variable ',13,'Freq. source/Inner',13,'Product1/Product']],...
		'position',[65,55,90,75])

add_block('built-in/Sum',[sys,'/',['Variable ',13,'Freq. source/Inner',13,'Product1/Sum']])
set_param([sys,'/',['Variable ',13,'Freq. source/Inner',13,'Product1/Sum']],...
		'inputs','+',...
		'position',[125,55,145,75])

add_block('built-in/Outport',[sys,'/',['Variable ',13,'Freq. source/Inner',13,'Product1/out_1']])
set_param([sys,'/',['Variable ',13,'Freq. source/Inner',13,'Product1/out_1']],...
		'position',[185,55,205,75])

add_block('built-in/Inport',[sys,'/',['Variable ',13,'Freq. source/Inner',13,'Product1/in_2']])
set_param([sys,'/',['Variable ',13,'Freq. source/Inner',13,'Product1/in_2']],...
		'Port','2',...
		'position',[15,90,35,110])

add_block('built-in/Inport',[sys,'/',['Variable ',13,'Freq. source/Inner',13,'Product1/in_1']])
set_param([sys,'/',['Variable ',13,'Freq. source/Inner',13,'Product1/in_1']],...
		'position',[15,25,35,45])
add_line([sys,'/',['Variable ',13,'Freq. source/Inner',13,'Product1']],[40,100;60,70])
add_line([sys,'/',['Variable ',13,'Freq. source/Inner',13,'Product1']],[40,35;60,60])
add_line([sys,'/',['Variable ',13,'Freq. source/Inner',13,'Product1']],[95,65;120,65])
add_line([sys,'/',['Variable ',13,'Freq. source/Inner',13,'Product1']],[150,65;180,65])
set_param([sys,'/',['Variable ',13,'Freq. source/Inner',13,'Product1']],...
		'Mask Display','.\n',...
		'Mask Type','Dot Product',...
		'Mask Dialogue','Inner (dot) product.\ny=sum(u1.*u2)')
set_param([sys,'/',['Variable ',13,'Freq. source/Inner',13,'Product1']],...
		'Mask Help','Computes the inner (dot) product of the inputs: sum(u1.*u2).  The inputs are vectors of the same length. Output is a scalar.')


%     Finished composite block ['Variable ',13,'Freq. source/Inner',13,'Product1'].

set_param([sys,'/',['Variable ',13,'Freq. source/Inner',13,'Product1']],...
		'position',[170,120,195,155])


%     Subsystem  ['Variable ',13,'Freq. source/Inner',13,'Product'].

new_system([sys,'/',['Variable ',13,'Freq. source/Inner',13,'Product']])
set_param([sys,'/',['Variable ',13,'Freq. source/Inner',13,'Product']],'Location',[33,479,253,634])

add_block('built-in/Product',[sys,'/',['Variable ',13,'Freq. source/Inner',13,'Product/Product']])
set_param([sys,'/',['Variable ',13,'Freq. source/Inner',13,'Product/Product']],...
		'position',[65,55,90,75])

add_block('built-in/Sum',[sys,'/',['Variable ',13,'Freq. source/Inner',13,'Product/Sum']])
set_param([sys,'/',['Variable ',13,'Freq. source/Inner',13,'Product/Sum']],...
		'inputs','+',...
		'position',[125,55,145,75])

add_block('built-in/Outport',[sys,'/',['Variable ',13,'Freq. source/Inner',13,'Product/out_1']])
set_param([sys,'/',['Variable ',13,'Freq. source/Inner',13,'Product/out_1']],...
		'position',[185,55,205,75])

add_block('built-in/Inport',[sys,'/',['Variable ',13,'Freq. source/Inner',13,'Product/in_2']])
set_param([sys,'/',['Variable ',13,'Freq. source/Inner',13,'Product/in_2']],...
		'Port','2',...
		'position',[15,90,35,110])

add_block('built-in/Inport',[sys,'/',['Variable ',13,'Freq. source/Inner',13,'Product/in_1']])
set_param([sys,'/',['Variable ',13,'Freq. source/Inner',13,'Product/in_1']],...
		'position',[15,25,35,45])
add_line([sys,'/',['Variable ',13,'Freq. source/Inner',13,'Product']],[40,100;60,70])
add_line([sys,'/',['Variable ',13,'Freq. source/Inner',13,'Product']],[40,35;60,60])
add_line([sys,'/',['Variable ',13,'Freq. source/Inner',13,'Product']],[95,65;120,65])
add_line([sys,'/',['Variable ',13,'Freq. source/Inner',13,'Product']],[150,65;180,65])
set_param([sys,'/',['Variable ',13,'Freq. source/Inner',13,'Product']],...
		'Mask Display','.\n',...
		'Mask Type','Dot Product',...
		'Mask Dialogue','Inner (dot) product.\ny=sum(u1.*u2)')
set_param([sys,'/',['Variable ',13,'Freq. source/Inner',13,'Product']],...
		'Mask Help','Computes the inner (dot) product of the inputs: sum(u1.*u2).  The inputs are vectors of the same length. Output is a scalar.')


%     Finished composite block ['Variable ',13,'Freq. source/Inner',13,'Product'].

set_param([sys,'/',['Variable ',13,'Freq. source/Inner',13,'Product']],...
		'position',[135,231,160,264])

add_block('built-in/Integrator',[sys,'/',['Variable ',13,'Freq. source/sin']])
set_param([sys,'/',['Variable ',13,'Freq. source/sin']],...
		'position',[245,231,280,269])
add_line([sys,'/',['Variable ',13,'Freq. source']],[55,130;165,130])
add_line([sys,'/',['Variable ',13,'Freq. source']],[55,130;120,130;130,240])
add_line([sys,'/',['Variable ',13,'Freq. source']],[230,250;240,250])
add_line([sys,'/',['Variable ',13,'Freq. source']],[165,250;180,250])
add_line([sys,'/',['Variable ',13,'Freq. source']],[285,250;295,250;295,210;155,210;165,145])
add_line([sys,'/',['Variable ',13,'Freq. source']],[200,140;230,140])
add_line([sys,'/',['Variable ',13,'Freq. source']],[275,140;285,140;285,100;110,100;110,255;130,255])
add_line([sys,'/',['Variable ',13,'Freq. source']],[375,175;385,175;385,115;410,115])
add_line([sys,'/',['Variable ',13,'Freq. source']],[375,175;405,175])
add_line([sys,'/',['Variable ',13,'Freq. source']],[375,175;385,175;385,235;405,235])
add_line([sys,'/',['Variable ',13,'Freq. source']],[55,130;65,130;65,55;95,55])
add_line([sys,'/',['Variable ',13,'Freq. source']],[535,175;560,175])
add_line([sys,'/',['Variable ',13,'Freq. source']],[540,235;560,235])
add_line([sys,'/',['Variable ',13,'Freq. source']],[275,140;335,140])
add_line([sys,'/',['Variable ',13,'Freq. source']],[285,250;295,250;295,210;335,210])
add_line([sys,'/',['Variable ',13,'Freq. source']],[690,230;715,230])
add_line([sys,'/',['Variable ',13,'Freq. source']],[690,170;710,170])
add_line([sys,'/',['Variable ',13,'Freq. source']],[685,110;715,110])
add_line([sys,'/',['Variable ',13,'Freq. source']],[210,55;625,55;625,225;650,225])
add_line([sys,'/',['Variable ',13,'Freq. source']],[625,105;645,105])
add_line([sys,'/',['Variable ',13,'Freq. source']],[625,165;650,165])
add_line([sys,'/',['Variable ',13,'Freq. source']],[600,235;650,235])
add_line([sys,'/',['Variable ',13,'Freq. source']],[600,175;650,175])
add_line([sys,'/',['Variable ',13,'Freq. source']],[605,115;645,115])
add_line([sys,'/',['Variable ',13,'Freq. source']],[540,115;565,115])


%     Finished composite block ['Variable ',13,'Freq. source'].

set_param([sys,'/',['Variable ',13,'Freq. source']],...
		'position',[75,193,120,267])


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
		'position',[635,207,675,263])

add_block('built-in/Scope',[sys,'/','Scope1'])
set_param([sys,'/','Scope1'],...
		'Vgain','20.000000',...
		'Hgain','0.200000',...
		'Vmax','20.000000',...
		'Hmax','0.377358',...
		'Window',[148,833,1041,1000],...
		'position',[615,23,630,47])

add_block('built-in/To Workspace',[sys,'/','To Workspace'])
set_param([sys,'/','To Workspace'],...
		'orientation',2,...
		'mat-name','y',...
		'buffer','10000',...
		'position',[305,27,345,43])

add_block('built-in/Scope',[sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'Vgain','300.000000',...
		'Hgain','2.000000',...
		'Vmax','300.000000',...
		'Hmax','3.773585',...
		'Window',[165,605,982,759])
open_system([sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'position',[505,24,520,46])

add_block('built-in/Mux',[sys,'/','Mux'])
set_param([sys,'/','Mux'],...
		'orientation',3,...
		'inputs','7',...
		'position',[150,65,680,80])

add_block('built-in/Clock',[sys,'/','Clock'])
set_param([sys,'/','Clock'],...
		'position',[140,90,160,110])

add_block('built-in/Note',[sys,'/','psir'])
set_param([sys,'/','psir'],...
		'position',[505,92,510,97])

add_block('built-in/Note',[sys,'/','psis'])
set_param([sys,'/','psis'],...
		'position',[595,90,600,95])


%     Subsystem  'm1o'.

new_system([sys,'/','m1o'])
set_param([sys,'/','m1o'],'Location',[90,5243146,238,5243224])

add_block('built-in/Note',[sys,'/',['m1o/Masked block of m1o.m',13,'to initilialize s2o.m',13,'and to plot the results.']])
set_param([sys,'/',['m1o/Masked block of m1o.m',13,'to initilialize s2o.m',13,'and to plot the results.']],...
		'position',[65,47,70,52])
set_param([sys,'/','m1o'],...
		'Mask Display','Initialize\nand plot',...
		'Mask Type','Masked block of m1o.m',...
		'Mask Dialogue','eval(''m1o'')',...
		'Mask Help','Uses m1o.m to initialize and plot')


%     Finished composite block 'm1o'.

set_param([sys,'/','m1o'],...
		'Drop Shadow',4,...
		'position',[59,129,124,164])

add_block('built-in/Note',[sys,'/',['Induction Machine Simulation  ',13,'in Stationary Reference Frame']])
set_param([sys,'/',['Induction Machine Simulation  ',13,'in Stationary Reference Frame']],...
		'position',[125,25,130,30])
add_line(sys,[370,315;575,315;575,235;630,235])
add_line(sys,[335,255;300,255;300,160;315,160])
add_line(sys,[360,125;560,125;560,230;510,230])
add_line(sys,[230,220;290,220;290,310;325,310])
add_line(sys,[230,200;290,200;290,135;315,135])
add_line(sys,[360,140;575,140;575,215;630,215])
add_line(sys,[600,215;510,215])
add_line(sys,[330,210;310,210;310,335;325,335])
add_line(sys,[370,300;545,300;545,200;510,200])
add_line(sys,[460,250;395,250;395,215;360,215])
add_line(sys,[460,250;365,250])
add_line(sys,[455,280;525,280;525,260;510,260])
add_line(sys,[415,60;415,35;350,35])
add_line(sys,[415,60;415,35;500,35])
add_line(sys,[165,100;190,100;190,85])
add_line(sys,[360,170;380,170;380,205;360,205])
add_line(sys,[125,205;180,205])
add_line(sys,[125,230;180,230])
add_line(sys,[125,255;180,255])
add_line(sys,[125,205;165,205;165,170;265,170;265,85])
add_line(sys,[485,360;610,360;610,255;630,255])
add_line(sys,[680,215;695,215;695,235;710,235])
add_line(sys,[680,235;690,235;690,245;710,245])
add_line(sys,[680,255;710,255])
add_line(sys,[230,240;270,240;270,360;440,360])
add_line(sys,[740,245;745,245;745,400;165,400;165,280;180,280])
add_line(sys,[370,315;535,315;535,245;510,245])
add_line(sys,[370,345;405,345;405,260;365,260])
add_line(sys,[620,135;635,135])
add_line(sys,[360,125;590,125])
add_line(sys,[370,300;545,300;545,145;590,145])
add_line(sys,[445,170;460,170])
add_line(sys,[360,170;380,170;380,160;415,160])
add_line(sys,[370,345;405,345;415,175])
add_line(sys,[460,250;395,250;395,110;340,110;340,85])
add_line(sys,[460,215;450,215;450,105;415,105;415,85])
add_line(sys,[500,170;510,170;510,115;490,115;490,85])
add_line(sys,[685,135;710,135;710,110;565,110;565,85])
add_line(sys,[680,215;735,215;735,95;640,85])

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
