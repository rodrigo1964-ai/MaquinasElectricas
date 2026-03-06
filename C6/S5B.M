function [ret,x0,str,ts,xts]=s5b(t,x,u,flag);
%s5b	is the M-file description of the SIMULINK system named s5b.
%	The block-diagram can be displayed by typing: s5b.
%
%	SYS=s5b(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes s5b to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling s5b with a FLAG of zero:
%	[SIZES]=s5b([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[3,53,794,441])
     open_system(sys)
end;
set_param(sys,'algorithm',     'Adams/Gear')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     '5')
set_param(sys,'Min step size', '1e-6')
set_param(sys,'Max step size', '5e-3')
set_param(sys,'Relative error','5e-6')
set_param(sys,'Return vars',   '')

add_block('built-in/Note',[sys,'/','t'])
set_param([sys,'/','t'],...
		'position',[620,45,625,50])

add_block('built-in/Note',[sys,'/','vag_'])
set_param([sys,'/','vag_'],...
		'position',[620,85,625,90])

add_block('built-in/Clock',[sys,'/','Clock'])
set_param([sys,'/','Clock'],...
		'position',[565,52,590,78])

add_block('built-in/Mux',[sys,'/','Mux'])
set_param([sys,'/','Mux'],...
		'inputs','6',...
		'position',[665,42,695,288])


%     Subsystem  ['induction machine',13,'in stationary qd0'].

new_system([sys,'/',['induction machine',13,'in stationary qd0']])
set_param([sys,'/',['induction machine',13,'in stationary qd0']],'Location',[184,174,938,596])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/Induction Machine Simulation',13,'  in Stationary Reference Frame']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Induction Machine Simulation',13,'  in Stationary Reference Frame']],...
		'position',[570,45,575,50])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/out_ias']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/out_ias']],...
		'position',[610,110,630,130])


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
		'position',[360,290,395,340])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/i0s']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/i0s']],...
		'position',[410,290,415,295])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/out_vsg']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/out_vsg']],...
		'Port','4',...
		'position',[200,320,220,340])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/out_Tem']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/out_Tem']],...
		'orientation',2,...
		'Port','3',...
		'position',[340,105,360,125])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/vag']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/vag']],...
		'position',[77,115,82,120])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/out_wr//wb']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/out_wr//wb']],...
		'orientation',2,...
		'Port','2',...
		'position',[345,215,365,235])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/vcg']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/vcg']],...
		'position',[77,215,82,220])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/in_vcg']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/in_vcg']],...
		'Port','3',...
		'position',[45,225,65,245])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/in_vbg']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/in_vbg']],...
		'Port','2',...
		'position',[45,175,65,195])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/in_vag']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/in_vag']],...
		'position',[45,125,65,145])


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

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/Tem']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Tem']],...
		'position',[364,147,369,152])

add_block('built-in/Product',[sys,'/',['induction machine',13,'in stationary qd0/Product1']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Product1']],...
		'orientation',2,...
		'position',[275,193,295,217])

add_block('built-in/Product',[sys,'/',['induction machine',13,'in stationary qd0/Product']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Product']],...
		'orientation',2,...
		'position',[275,144,295,166])


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
		'position',[385,144,425,216])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/wr//wb']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/wr//wb']],...
		'position',[355,175,360,180])


%     Subsystem  ['induction machine',13,'in stationary qd0/abc2qds'].

new_system([sys,'/',['induction machine',13,'in stationary qd0/abc2qds']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/abc2qds']],'Location',[294,94,893,412])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/abc2qds/ias+ibs+ics']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/abc2qds/ias+ibs+ics']],...
		'Port','4',...
		'position',[80,225,100,245])

add_block('built-in/Mux',[sys,'/',['induction machine',13,'in stationary qd0/abc2qds/Mux']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/abc2qds/Mux']],...
		'inputs','3',...
		'position',[145,80,170,210])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/abc2qds/in_vag']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/abc2qds/in_vag']],...
		'position',[80,90,100,110])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/abc2qds/in_vbg']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/abc2qds/in_vbg']],...
		'Port','2',...
		'position',[80,135,100,155])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/abc2qds/in_vcg']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/abc2qds/in_vcg']],...
		'Port','3',...
		'position',[80,180,100,200])

add_block('built-in/Fcn',[sys,'/',['induction machine',13,'in stationary qd0/abc2qds/Fcn1']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/abc2qds/Fcn1']],...
		'Expr','(u[3]-u[2])/sqrt(3)',...
		'position',[225,132,375,158])

add_block('built-in/Fcn',[sys,'/',['induction machine',13,'in stationary qd0/abc2qds/Fcn']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/abc2qds/Fcn']],...
		'Expr','(2/3)*(u[1] - (u[2]+u[3])/2)',...
		'position',[225,81,380,109])

add_block('built-in/Fcn',[sys,'/',['induction machine',13,'in stationary qd0/abc2qds/Fcn2']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/abc2qds/Fcn2']],...
		'Expr','(u[1]+u[2]+u[3])/3',...
		'position',[225,177,375,203])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/abc2qds/out_vsg']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/abc2qds/out_vsg']],...
		'Port','4',...
		'position',[465,245,485,265])

add_block('built-in/Sum',[sys,'/',['induction machine',13,'in stationary qd0/abc2qds/Sum1']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/abc2qds/Sum1']],...
		'inputs','+-',...
		'position',[425,85,440,120])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/abc2qds/out_vqs']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/abc2qds/out_vqs']],...
		'position',[470,95,490,115])

add_block('built-in/Sum',[sys,'/',['induction machine',13,'in stationary qd0/abc2qds/Sum']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/abc2qds/Sum']],...
		'inputs','+-',...
		'position',[420,182,435,218])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/abc2qds/out_v0s']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/abc2qds/out_v0s']],...
		'Port','3',...
		'position',[465,190,485,210])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/abc2qds/out_vds']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/abc2qds/out_vds']],...
		'Port','2',...
		'position',[475,135,495,155])

add_block('built-in/Gain',[sys,'/',['induction machine',13,'in stationary qd0/abc2qds/1//Csg']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/abc2qds/1//Csg']],...
		'Gain','200*Zb',...
		'position',[190,213,270,257])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/abc2qds/vsg']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/abc2qds/vsg']],...
		'position',[330,215,335,220])
add_line([sys,'/',['induction machine',13,'in stationary qd0/abc2qds']],[105,100;140,100])
add_line([sys,'/',['induction machine',13,'in stationary qd0/abc2qds']],[105,145;140,145])
add_line([sys,'/',['induction machine',13,'in stationary qd0/abc2qds']],[105,190;140,190])
add_line([sys,'/',['induction machine',13,'in stationary qd0/abc2qds']],[175,145;220,145])
add_line([sys,'/',['induction machine',13,'in stationary qd0/abc2qds']],[175,145;190,145;190,95;220,95])
add_line([sys,'/',['induction machine',13,'in stationary qd0/abc2qds']],[380,145;470,145])
add_line([sys,'/',['induction machine',13,'in stationary qd0/abc2qds']],[175,145;190,145;190,190;220,190])
add_line([sys,'/',['induction machine',13,'in stationary qd0/abc2qds']],[440,200;460,200])
add_line([sys,'/',['induction machine',13,'in stationary qd0/abc2qds']],[380,190;415,190])
add_line([sys,'/',['induction machine',13,'in stationary qd0/abc2qds']],[105,235;185,235])
add_line([sys,'/',['induction machine',13,'in stationary qd0/abc2qds']],[385,95;420,95])
add_line([sys,'/',['induction machine',13,'in stationary qd0/abc2qds']],[445,105;465,105])
add_line([sys,'/',['induction machine',13,'in stationary qd0/abc2qds']],[275,235;385,235;385,210;415,210])
add_line([sys,'/',['induction machine',13,'in stationary qd0/abc2qds']],[275,235;365,235;365,255;460,255])
add_line([sys,'/',['induction machine',13,'in stationary qd0/abc2qds']],[275,235;385,235;385,110;420,110])


%     Finished composite block ['induction machine',13,'in stationary qd0/abc2qds'].

set_param([sys,'/',['induction machine',13,'in stationary qd0/abc2qds']],...
		'position',[130,152,175,238])


%     Subsystem  ['induction machine',13,'in stationary qd0/qds2abc'].

new_system([sys,'/',['induction machine',13,'in stationary qd0/qds2abc']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/qds2abc']],'Location',[228,79,747,289])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/qds2abc/in_ids']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/qds2abc/in_ids']],...
		'Port','2',...
		'position',[45,95,65,115])

add_block('built-in/Mux',[sys,'/',['induction machine',13,'in stationary qd0/qds2abc/Mux']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/qds2abc/Mux']],...
		'inputs','3',...
		'position',[110,34,135,176])

add_block('built-in/Fcn',[sys,'/',['induction machine',13,'in stationary qd0/qds2abc/Fcn1']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/qds2abc/Fcn1']],...
		'Expr','-(u[1]+sqrt(3)*u[2])/2 +u[3]',...
		'position',[185,92,370,118])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/qds2abc/out_ibs']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/qds2abc/out_ibs']],...
		'Port','2',...
		'position',[440,95,460,115])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/qds2abc/out_ias']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/qds2abc/out_ias']],...
		'position',[440,40,460,60])

add_block('built-in/Fcn',[sys,'/',['induction machine',13,'in stationary qd0/qds2abc/Fcn2']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/qds2abc/Fcn2']],...
		'Expr','-(u[1]-sqrt(3)*u[2])/2 + u[3]',...
		'position',[185,147,375,173])

add_block('built-in/Fcn',[sys,'/',['induction machine',13,'in stationary qd0/qds2abc/Fcn']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/qds2abc/Fcn']],...
		'Expr','u[1] + u[3]',...
		'position',[185,36,375,64])

add_block('built-in/Outport',[sys,'/',['induction machine',13,'in stationary qd0/qds2abc/out_ics']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/qds2abc/out_ics']],...
		'Port','3',...
		'position',[440,150,460,170])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/qds2abc/in_iqs']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/qds2abc/in_iqs']],...
		'position',[45,50,65,70])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/qds2abc/in_i0s']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/qds2abc/in_i0s']],...
		'Port','3',...
		'position',[45,140,65,160])
add_line([sys,'/',['induction machine',13,'in stationary qd0/qds2abc']],[70,105;105,105])
add_line([sys,'/',['induction machine',13,'in stationary qd0/qds2abc']],[70,60;105,60])
add_line([sys,'/',['induction machine',13,'in stationary qd0/qds2abc']],[70,150;105,150])
add_line([sys,'/',['induction machine',13,'in stationary qd0/qds2abc']],[140,105;180,105])
add_line([sys,'/',['induction machine',13,'in stationary qd0/qds2abc']],[375,105;435,105])
add_line([sys,'/',['induction machine',13,'in stationary qd0/qds2abc']],[380,50;435,50])
add_line([sys,'/',['induction machine',13,'in stationary qd0/qds2abc']],[140,105;155,105;155,50;180,50])
add_line([sys,'/',['induction machine',13,'in stationary qd0/qds2abc']],[140,105;155,105;155,160;180,160])
add_line([sys,'/',['induction machine',13,'in stationary qd0/qds2abc']],[380,160;435,160])


%     Finished composite block ['induction machine',13,'in stationary qd0/qds2abc'].

set_param([sys,'/',['induction machine',13,'in stationary qd0/qds2abc']],...
		'position',[545,155,580,235])

add_block('built-in/Sum',[sys,'/',['induction machine',13,'in stationary qd0/Sum']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/Sum']],...
		'inputs','+++',...
		'position',[625,155,645,235])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/psiqs']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/psiqs']],...
		'position',[290,60,295,65])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/iqs']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/iqs']],...
		'position',[285,75,290,80])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/psiqr']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/psiqr']],...
		'position',[290,105,295,110])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/ibs']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/ibs']],...
		'position',[590,175,595,180])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/ics']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/ics']],...
		'position',[590,200,595,205])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/psids']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/psids']],...
		'position',[295,235,300,240])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/psidr']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/psidr']],...
		'position',[299,280,304,285])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/ias']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/ias']],...
		'position',[600,150,605,155])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/vqs']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/vqs']],...
		'position',[185,145,190,150])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/vds']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/vds']],...
		'position',[185,165,190,170])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/v0s']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/v0s']],...
		'position',[185,185,190,190])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/ids']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/ids']],...
		'position',[290,250,295,255])

add_block('built-in/Note',[sys,'/',['induction machine',13,'in stationary qd0/vbg']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/vbg']],...
		'position',[77,165,82,170])

add_block('built-in/Inport',[sys,'/',['induction machine',13,'in stationary qd0/in_Tmech']])
set_param([sys,'/',['induction machine',13,'in stationary qd0/in_Tmech']],...
		'orientation',2,...
		'Port','4',...
		'position',[450,200,470,220])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[650,195;660,195;660,360;115,360;125,225])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[400,315;530,315;540,220])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[585,220;620,220])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[585,195;620,195])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[585,170;620,170])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[180,205;195,205;195,315;355,315])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[285,300;325,300;325,210;300,210])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[280,125;320,125;320,150;300,150])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[380,200;300,200])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[380,200;335,200;335,160;300,160])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[285,255;490,255;490,150;430,150])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[270,155;225,155;225,290;240,290])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[280,95;515,95;515,170;540,170])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[515,160;515,165;430,165])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[180,165;205,165;205,90;235,90])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[180,185;205,185;205,265;240,265])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[280,80;495,80;495,180;430,180])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[270,205;215,205;215,115;235,115])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[285,270;515,270;515,195;540,195])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[515,213;515,195;430,195])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[70,135;90,135;90,165;125,165])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[380,165;375,165;365,115])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[585,170;590,170;590,120;605,120])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[70,185;125,185])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[380,200;370,225])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[70,235;90,235;90,205;125,205])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[445,210;430,210])
add_line([sys,'/',['induction machine',13,'in stationary qd0']],[180,225;185,225;195,330])


%     Finished composite block ['induction machine',13,'in stationary qd0'].

set_param([sys,'/',['induction machine',13,'in stationary qd0']],...
		'position',[540,128,600,282])

add_block('built-in/Product',[sys,'/','Product1'])
set_param([sys,'/','Product1'],...
		'position',[460,183,490,207])

add_block('built-in/Product',[sys,'/','Product'])
set_param([sys,'/','Product'],...
		'position',[460,133,490,157])

add_block('built-in/Product',[sys,'/','Product2'])
set_param([sys,'/','Product2'],...
		'position',[460,233,490,257])


%     Subsystem  'Sign'.

new_system([sys,'/','Sign'])
set_param([sys,'/','Sign'],'Location',[159,417,467,586])

add_block('built-in/Outport',[sys,'/','Sign/out_1'])
set_param([sys,'/','Sign/out_1'],...
		'position',[265,70,285,90])

add_block('built-in/Inport',[sys,'/','Sign/in_1'])
set_param([sys,'/','Sign/in_1'],...
		'position',[35,30,55,50])

add_block('built-in/Relational Operator',[sys,'/',['Sign/Relational',13,'Operator']])
set_param([sys,'/',['Sign/Relational',13,'Operator']],...
		'Operator','>',...
		'position',[140,32,170,63])

add_block('built-in/Sum',[sys,'/','Sign/Sum'])
set_param([sys,'/','Sign/Sum'],...
		'inputs','+-',...
		'position',[215,64,235,91])

add_block('built-in/Relational Operator',[sys,'/',['Sign/Relational',13,'Operator1']])
set_param([sys,'/',['Sign/Relational',13,'Operator1']],...
		'Operator','<',...
		'position',[140,92,170,123])

add_block('built-in/Constant',[sys,'/','Sign/Constant'])
set_param([sys,'/','Sign/Constant'],...
		'Value','0',...
		'position',[65,105,85,125])
add_line([sys,'/','Sign'],[60,40;135,40])
add_line([sys,'/','Sign'],[95,40;95,100;135,100])
add_line([sys,'/','Sign'],[90,115;135,115])
add_line([sys,'/','Sign'],[110,115;110,55;135,55])
add_line([sys,'/','Sign'],[175,110;185,110;185,85;210,85])
add_line([sys,'/','Sign'],[175,50;185,50;185,70;210,70])
add_line([sys,'/','Sign'],[240,80;260,80])
set_param([sys,'/','Sign'],...
		'Mask Display','plot(-50,-50,50,50,[-50,50],[0,0],[0,0],[-50,50],[-40,0],[-30,-30],[0,40],[30,30])',...
		'Mask Type','Sign',...
		'Mask Dialogue','y = sign(x)')
set_param([sys,'/','Sign'],...
		'Mask Help','Sign Function:\n\t\t\ty = 1 if x > 0\n\t\t\ty = 0 if x = 0\n\t\t\ty = -1 if x < 0')


%     Finished composite block 'Sign'.

set_param([sys,'/','Sign'],...
		'position',[380,127,410,153])


%     Subsystem  'Sign1'.

new_system([sys,'/','Sign1'])
set_param([sys,'/','Sign1'],'Location',[159,417,467,586])

add_block('built-in/Outport',[sys,'/','Sign1/out_1'])
set_param([sys,'/','Sign1/out_1'],...
		'position',[265,70,285,90])

add_block('built-in/Inport',[sys,'/','Sign1/in_1'])
set_param([sys,'/','Sign1/in_1'],...
		'position',[35,30,55,50])

add_block('built-in/Relational Operator',[sys,'/',['Sign1/Relational',13,'Operator']])
set_param([sys,'/',['Sign1/Relational',13,'Operator']],...
		'Operator','>',...
		'position',[140,32,170,63])

add_block('built-in/Sum',[sys,'/','Sign1/Sum'])
set_param([sys,'/','Sign1/Sum'],...
		'inputs','+-',...
		'position',[215,64,235,91])

add_block('built-in/Relational Operator',[sys,'/',['Sign1/Relational',13,'Operator1']])
set_param([sys,'/',['Sign1/Relational',13,'Operator1']],...
		'Operator','<',...
		'position',[140,92,170,123])

add_block('built-in/Constant',[sys,'/','Sign1/Constant'])
set_param([sys,'/','Sign1/Constant'],...
		'Value','0',...
		'position',[65,105,85,125])
add_line([sys,'/','Sign1'],[60,40;135,40])
add_line([sys,'/','Sign1'],[95,40;95,100;135,100])
add_line([sys,'/','Sign1'],[90,115;135,115])
add_line([sys,'/','Sign1'],[110,115;110,55;135,55])
add_line([sys,'/','Sign1'],[175,110;185,110;185,85;210,85])
add_line([sys,'/','Sign1'],[175,50;185,50;185,70;210,70])
add_line([sys,'/','Sign1'],[240,80;260,80])
set_param([sys,'/','Sign1'],...
		'Mask Display','plot(-50,-50,50,50,[-50,50],[0,0],[0,0],[-50,50],[-40,0],[-30,-30],[0,40],[30,30])',...
		'Mask Type','Sign',...
		'Mask Dialogue','y = sign(x)')
set_param([sys,'/','Sign1'],...
		'Mask Help','Sign Function:\n\t\t\ty = 1 if x > 0\n\t\t\ty = 0 if x = 0\n\t\t\ty = -1 if x < 0')


%     Finished composite block 'Sign1'.

set_param([sys,'/','Sign1'],...
		'position',[380,177,410,203])


%     Subsystem  'Sign2'.

new_system([sys,'/','Sign2'])
set_param([sys,'/','Sign2'],'Location',[159,417,467,586])

add_block('built-in/Outport',[sys,'/','Sign2/out_1'])
set_param([sys,'/','Sign2/out_1'],...
		'position',[265,70,285,90])

add_block('built-in/Inport',[sys,'/','Sign2/in_1'])
set_param([sys,'/','Sign2/in_1'],...
		'position',[35,30,55,50])

add_block('built-in/Relational Operator',[sys,'/',['Sign2/Relational',13,'Operator']])
set_param([sys,'/',['Sign2/Relational',13,'Operator']],...
		'Operator','>',...
		'position',[140,32,170,63])

add_block('built-in/Sum',[sys,'/','Sign2/Sum'])
set_param([sys,'/','Sign2/Sum'],...
		'inputs','+-',...
		'position',[215,64,235,91])

add_block('built-in/Relational Operator',[sys,'/',['Sign2/Relational',13,'Operator1']])
set_param([sys,'/',['Sign2/Relational',13,'Operator1']],...
		'Operator','<',...
		'position',[140,92,170,123])

add_block('built-in/Constant',[sys,'/','Sign2/Constant'])
set_param([sys,'/','Sign2/Constant'],...
		'Value','0',...
		'position',[65,105,85,125])
add_line([sys,'/','Sign2'],[60,40;135,40])
add_line([sys,'/','Sign2'],[95,40;95,100;135,100])
add_line([sys,'/','Sign2'],[90,115;135,115])
add_line([sys,'/','Sign2'],[110,115;110,55;135,55])
add_line([sys,'/','Sign2'],[175,110;185,110;185,85;210,85])
add_line([sys,'/','Sign2'],[175,50;185,50;185,70;210,70])
add_line([sys,'/','Sign2'],[240,80;260,80])
set_param([sys,'/','Sign2'],...
		'Mask Display','plot(-50,-50,50,50,[-50,50],[0,0],[0,0],[-50,50],[-40,0],[-30,-30],[0,40],[30,30])',...
		'Mask Type','Sign',...
		'Mask Dialogue','y = sign(x)')
set_param([sys,'/','Sign2'],...
		'Mask Help','Sign Function:\n\t\t\ty = 1 if x > 0\n\t\t\ty = 0 if x = 0\n\t\t\ty = -1 if x < 0')


%     Finished composite block 'Sign2'.

set_param([sys,'/','Sign2'],...
		'position',[380,227,410,253])

add_block('built-in/Integrator',[sys,'/','Integrator'])
set_param([sys,'/','Integrator'],...
		'position',[120,117,155,163])

add_block('built-in/Fcn',[sys,'/','vcg'])
set_param([sys,'/','vcg'],...
		'Expr','Vm*cos(u[1]+2*pi/3)',...
		'position',[200,227,335,253])

add_block('built-in/Fcn',[sys,'/','vbg'])
set_param([sys,'/','vbg'],...
		'Expr','Vm*cos(u[1]-2*pi/3)',...
		'position',[200,177,335,203])

add_block('built-in/Fcn',[sys,'/','vag'])
set_param([sys,'/','vag'],...
		'Expr','Vm*cos(u[1])',...
		'position',[200,128,335,152])

add_block('built-in/Constant',[sys,'/','Tmech'])
set_param([sys,'/','Tmech'],...
		'Value','-Tb',...
		'position',[450,275,490,295])

add_block('built-in/Fcn',[sys,'/','V//Hz & form factor'])
set_param([sys,'/','V//Hz & form factor'],...
		'Expr','u[1]*(Vm/wb)*(pi/4)',...
		'position',[195,276,335,314])

add_block('built-in/Constant',[sys,'/','we'])
set_param([sys,'/','we'],...
		'Value','wb',...
		'position',[55,127,85,153])

add_block('built-in/To Workspace',[sys,'/','To Workspace'])
set_param([sys,'/','To Workspace'],...
		'mat-name','y',...
		'buffer','50000',...
		'position',[725,181,765,199])

add_block('built-in/Scope',[sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'Vgain','20.000000',...
		'Hgain','1.000000',...
		'Vmax','40.000000',...
		'Hmax','2.000000',...
		'Window',[0,417,812,600])
open_system([sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'position',[730,126,760,154])

add_block('built-in/Scope',[sys,'/','Scope1'])
set_param([sys,'/','Scope1'],...
		'Vgain','10.000000',...
		'Hgain','1.000000',...
		'Vmax','10.000000',...
		'Hmax','1.886792',...
		'Window',[138,705,967,833],...
		'position',[725,66,755,94])

add_block('built-in/Note',[sys,'/','ias'])
set_param([sys,'/','ias'],...
		'position',[620,125,625,130])

add_block('built-in/Note',[sys,'/','vsg'])
set_param([sys,'/','vsg'],...
		'position',[625,245,630,250])

add_block('built-in/Note',[sys,'/','Tem'])
set_param([sys,'/','Tem'],...
		'position',[620,200,625,205])

add_block('built-in/Note',[sys,'/','wr//wb'])
set_param([sys,'/','wr//wb'],...
		'position',[625,160,630,165])

add_block('built-in/Note',[sys,'/',['Six-Step Voltage Supply to Induction Machine ',13,'in Stationary Reference Frame']])
set_param([sys,'/',['Six-Step Voltage Supply to Induction Machine ',13,'in Stationary Reference Frame']],...
		'position',[365,65,370,70])


%     Subsystem  'm5'.

new_system([sys,'/','m5'])
set_param([sys,'/','m5'],'Location',[15,8061056,250,8061150])

add_block('built-in/Note',[sys,'/',['m5/Uses m5.m to initIalize simulation ',13,'and plot results']])
set_param([sys,'/',['m5/Uses m5.m to initIalize simulation ',13,'and plot results']],...
		'position',[155,43,160,48])
set_param([sys,'/','m5'],...
		'Mask Display','Initialize\nand plot',...
		'Mask Type','Masked block of m5.m',...
		'Mask Dialogue','eval(''m5'')',...
		'Mask Help','Uses m5.5 to initialize and plot')


%     Finished composite block 'm5'.

set_param([sys,'/','m5'],...
		'Drop Shadow',4,...
		'position',[77,55,142,87])
add_line(sys,[700,165;705,165;705,190;720,190])
add_line(sys,[700,165;705,165;705,140;725,140])
add_line(sys,[595,65;660,65])
add_line(sys,[160,140;170,140;170,240;195,240])
add_line(sys,[170,140;195,140])
add_line(sys,[90,140;115,140])
add_line(sys,[170,140;185,140;195,190])
add_line(sys,[495,145;535,145])
add_line(sys,[495,195;510,195;510,185;535,185])
add_line(sys,[495,245;510,245;510,225;535,225])
add_line(sys,[415,140;455,140])
add_line(sys,[415,190;455,190])
add_line(sys,[415,240;455,240])
add_line(sys,[340,295;430,295;430,150;455,150])
add_line(sys,[430,200;455,200])
add_line(sys,[430,250;455,250])
add_line(sys,[340,140;375,140])
add_line(sys,[340,190;375,190])
add_line(sys,[340,240;375,240])
add_line(sys,[495,145;510,145;510,105;660,105])
add_line(sys,[90,140;95,140;95,295;190,295])
add_line(sys,[495,285;510,285;510,265;535,265])
add_line(sys,[605,145;660,145])
add_line(sys,[605,185;660,185])
add_line(sys,[605,225;660,225])
add_line(sys,[605,265;660,265])

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
