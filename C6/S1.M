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
     set_param(sys,'Location',[0,39,791,455])
     open_system(sys)
end;
set_param(sys,'algorithm',     'Adams/Gear')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     'tstop')
set_param(sys,'Min step size', '2e-4')
set_param(sys,'Max step size', '1e-2')
set_param(sys,'Relative error','1e-7')
set_param(sys,'Return vars',   '')

add_block('built-in/Scope',[sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'Vgain','30.000000',...
		'Hgain','2.000000',...
		'Vmax','60.000000',...
		'Hmax','4.000000',...
		'Window',[0,400,812,600])
open_system([sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'position',[590,32,605,58])


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
		'position',[380,280,415,335])


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
		'position',[375,105,410,160])

add_block('built-in/Note',[sys,'/',['Induction Machine Simulation',13,'  in Stationary Reference Frame']])
set_param([sys,'/',['Induction Machine Simulation',13,'  in Stationary Reference Frame']],...
		'position',[135,350,140,355])

add_block('built-in/Mux',[sys,'/','Mux'])
set_param([sys,'/','Mux'],...
		'inputs','5',...
		'position',[505,31,530,99])

add_block('built-in/Clock',[sys,'/','Clock'])
set_param([sys,'/','Clock'],...
		'orientation',3,...
		'position',[131,50,159,75])

add_block('built-in/To Workspace',[sys,'/','To Workspace'])
set_param([sys,'/','To Workspace'],...
		'mat-name','y',...
		'buffer','80000',...
		'position',[585,76,630,94])

add_block('built-in/Note',[sys,'/','i0s'])
set_param([sys,'/','i0s'],...
		'position',[550,330,555,335])


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
		'position',[140,59,155,101])

add_block('built-in/Gain',[sys,'/','Zero_seq/wb//xls'])
set_param([sys,'/','Zero_seq/wb//xls'],...
		'Gain','wb/xls',...
		'position',[180,62,240,98])

add_block('built-in/Integrator',[sys,'/','Zero_seq/Integrator'])
set_param([sys,'/','Zero_seq/Integrator'],...
		'position',[265,65,295,95])

add_block('built-in/Outport',[sys,'/','Zero_seq/out_i0s'])
set_param([sys,'/','Zero_seq/out_i0s'],...
		'position',[365,70,385,90])

add_block('built-in/Inport',[sys,'/','Zero_seq/in_v0s'])
set_param([sys,'/','Zero_seq/in_v0s'],...
		'position',[55,60,75,80])
add_line([sys,'/','Zero_seq'],[195,140;115,140;115,90;135,90])
add_line([sys,'/','Zero_seq'],[300,80;310,80;310,140;250,140])
add_line([sys,'/','Zero_seq'],[160,80;175,80])
add_line([sys,'/','Zero_seq'],[245,80;260,80])
add_line([sys,'/','Zero_seq'],[80,70;135,70])
add_line([sys,'/','Zero_seq'],[300,80;360,80])


%     Finished composite block 'Zero_seq'.

set_param([sys,'/','Zero_seq'],...
		'position',[495,325,530,375])

add_block('built-in/Note',[sys,'/','vqs'])
set_param([sys,'/','vqs'],...
		'position',[320,175,325,180])

add_block('built-in/Note',[sys,'/','Tem'])
set_param([sys,'/','Tem'],...
		'position',[499,177,504,182])

add_block('built-in/Product',[sys,'/','Product1'])
set_param([sys,'/','Product1'],...
		'orientation',2,...
		'position',[410,223,430,247])

add_block('built-in/Product',[sys,'/','Product'])
set_param([sys,'/','Product'],...
		'orientation',2,...
		'position',[410,174,430,196])


%     Subsystem  'Rotor'.

new_system([sys,'/','Rotor'])
set_param([sys,'/','Rotor'],'Location',[149,82,784,328])

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
		'Expr','Tfactor*(u[1]*u[2]-u[3]*u[4])',...
		'position',[150,96,310,124])

add_block('built-in/Mux',[sys,'/','Rotor/Mux'])
set_param([sys,'/','Rotor/Mux'],...
		'position',[105,26,130,194])

add_block('built-in/Inport',[sys,'/','Rotor/in_psids'])
set_param([sys,'/','Rotor/in_psids'],...
		'position',[55,40,75,60])

add_block('built-in/Inport',[sys,'/','Rotor/in_iqs'])
set_param([sys,'/','Rotor/in_iqs'],...
		'Port','2',...
		'position',[55,80,75,100])

add_block('built-in/Inport',[sys,'/','Rotor/in_psiqs'])
set_param([sys,'/','Rotor/in_psiqs'],...
		'Port','3',...
		'position',[55,120,75,140])

add_block('built-in/Inport',[sys,'/','Rotor/in_ids'])
set_param([sys,'/','Rotor/in_ids'],...
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
		'orientation',2,...
		'position',[520,174,560,246])

add_block('built-in/Fcn',[sys,'/','Fcn2'])
set_param([sys,'/','Fcn2'],...
		'Expr','Vm*cos(u[1]+2*pi/3)',...
		'position',[70,252,205,278])

add_block('built-in/Fcn',[sys,'/','Fcn1'])
set_param([sys,'/','Fcn1'],...
		'Expr','Vm*cos(u[1]-2*pi/3)',...
		'position',[70,202,205,228])

add_block('built-in/Fcn',[sys,'/','Fcn'])
set_param([sys,'/','Fcn'],...
		'Expr','Vm*cos(u[1])',...
		'position',[70,153,205,177])

add_block('built-in/Note',[sys,'/','wr//wb'])
set_param([sys,'/','wr//wb'],...
		'position',[490,205,495,210])

add_block('built-in/Note',[sys,'/','vag'])
set_param([sys,'/','vag'],...
		'position',[217,145,222,150])

add_block('built-in/Note',[sys,'/','vcg'])
set_param([sys,'/','vcg'],...
		'position',[222,245,227,250])

add_block('built-in/Note',[sys,'/','vbg'])
set_param([sys,'/','vbg'],...
		'position',[217,195,222,200])


%     Subsystem  'abc2qds'.

new_system([sys,'/','abc2qds'])
set_param([sys,'/','abc2qds'],'Location',[108,72,707,390])

add_block('built-in/Gain',[sys,'/','abc2qds/1//Csg'])
set_param([sys,'/','abc2qds/1//Csg'],...
		'Gain','50*Zb*wb',...
		'position',[185,215,280,255])

add_block('built-in/Integrator',[sys,'/','abc2qds/Integrator'])
set_param([sys,'/','abc2qds/Integrator'],...
		'position',[300,220,330,250])

add_block('built-in/Inport',[sys,'/','abc2qds/ias+ibs+ics'])
set_param([sys,'/','abc2qds/ias+ibs+ics'],...
		'Port','4',...
		'position',[80,225,100,245])

add_block('built-in/Mux',[sys,'/','abc2qds/Mux'])
set_param([sys,'/','abc2qds/Mux'],...
		'inputs','3',...
		'position',[145,80,170,210])

add_block('built-in/Inport',[sys,'/','abc2qds/in_vag'])
set_param([sys,'/','abc2qds/in_vag'],...
		'position',[80,90,100,110])

add_block('built-in/Inport',[sys,'/','abc2qds/in_vbg'])
set_param([sys,'/','abc2qds/in_vbg'],...
		'Port','2',...
		'position',[80,135,100,155])

add_block('built-in/Inport',[sys,'/','abc2qds/in_vcg'])
set_param([sys,'/','abc2qds/in_vcg'],...
		'Port','3',...
		'position',[80,180,100,200])

add_block('built-in/Fcn',[sys,'/','abc2qds/Fcn1'])
set_param([sys,'/','abc2qds/Fcn1'],...
		'Expr','(u[3]-u[2])/sqrt(3)',...
		'position',[225,132,375,158])

add_block('built-in/Fcn',[sys,'/','abc2qds/Fcn'])
set_param([sys,'/','abc2qds/Fcn'],...
		'Expr','(2/3)*(u[1] - (u[2]+u[3])/2)',...
		'position',[225,81,380,109])

add_block('built-in/Note',[sys,'/','abc2qds/vsg'])
set_param([sys,'/','abc2qds/vsg'],...
		'position',[360,215,365,220])

add_block('built-in/Fcn',[sys,'/','abc2qds/Fcn2'])
set_param([sys,'/','abc2qds/Fcn2'],...
		'Expr','(u[1]+u[2]+u[3])/3',...
		'position',[225,177,375,203])

add_block('built-in/Outport',[sys,'/','abc2qds/out_v0s'])
set_param([sys,'/','abc2qds/out_v0s'],...
		'Port','3',...
		'position',[465,195,485,215])

add_block('built-in/Sum',[sys,'/','abc2qds/Sum'])
set_param([sys,'/','abc2qds/Sum'],...
		'inputs','+-',...
		'position',[420,178,435,227])

add_block('built-in/Outport',[sys,'/','abc2qds/out_vqs'])
set_param([sys,'/','abc2qds/out_vqs'],...
		'position',[465,85,485,105])

add_block('built-in/Outport',[sys,'/','abc2qds/out_vds'])
set_param([sys,'/','abc2qds/out_vds'],...
		'Port','2',...
		'position',[465,135,485,155])
add_line([sys,'/','abc2qds'],[105,100;140,100])
add_line([sys,'/','abc2qds'],[105,145;140,145])
add_line([sys,'/','abc2qds'],[105,190;140,190])
add_line([sys,'/','abc2qds'],[175,145;220,145])
add_line([sys,'/','abc2qds'],[385,95;460,95])
add_line([sys,'/','abc2qds'],[175,145;190,145;190,95;220,95])
add_line([sys,'/','abc2qds'],[380,145;460,145])
add_line([sys,'/','abc2qds'],[175,145;190,145;190,190;220,190])
add_line([sys,'/','abc2qds'],[440,205;460,205])
add_line([sys,'/','abc2qds'],[380,190;415,190])
add_line([sys,'/','abc2qds'],[285,235;295,235])
add_line([sys,'/','abc2qds'],[105,235;180,235])
add_line([sys,'/','abc2qds'],[335,235;385,235;385,215;415,215])


%     Finished composite block 'abc2qds'.

set_param([sys,'/','abc2qds'],...
		'position',[265,182,310,268])

add_block('built-in/Note',[sys,'/','v0s'])
set_param([sys,'/','v0s'],...
		'position',[320,235,325,240])


%     Subsystem  'qds2abc'.

new_system([sys,'/','qds2abc'])
set_param([sys,'/','qds2abc'],'Location',[228,79,747,289])

add_block('built-in/Inport',[sys,'/','qds2abc/in_ids'])
set_param([sys,'/','qds2abc/in_ids'],...
		'Port','2',...
		'position',[45,95,65,115])

add_block('built-in/Mux',[sys,'/','qds2abc/Mux'])
set_param([sys,'/','qds2abc/Mux'],...
		'inputs','3',...
		'position',[110,34,135,176])

add_block('built-in/Fcn',[sys,'/','qds2abc/Fcn1'])
set_param([sys,'/','qds2abc/Fcn1'],...
		'Expr','-(u[1]+sqrt(3)*u[2])/2 +u[3]',...
		'position',[185,92,370,118])

add_block('built-in/Outport',[sys,'/','qds2abc/out_ibs'])
set_param([sys,'/','qds2abc/out_ibs'],...
		'Port','2',...
		'position',[440,95,460,115])

add_block('built-in/Outport',[sys,'/','qds2abc/out_ias'])
set_param([sys,'/','qds2abc/out_ias'],...
		'position',[440,40,460,60])

add_block('built-in/Fcn',[sys,'/','qds2abc/Fcn2'])
set_param([sys,'/','qds2abc/Fcn2'],...
		'Expr','-(u[1]-sqrt(3)*u[2])/2 + u[3]',...
		'position',[185,147,375,173])

add_block('built-in/Fcn',[sys,'/','qds2abc/Fcn'])
set_param([sys,'/','qds2abc/Fcn'],...
		'Expr','u[1] + u[3]',...
		'position',[185,36,375,64])

add_block('built-in/Outport',[sys,'/','qds2abc/out_ics'])
set_param([sys,'/','qds2abc/out_ics'],...
		'Port','3',...
		'position',[440,150,460,170])

add_block('built-in/Inport',[sys,'/','qds2abc/in_iqs'])
set_param([sys,'/','qds2abc/in_iqs'],...
		'position',[45,50,65,70])

add_block('built-in/Inport',[sys,'/','qds2abc/in_i0s'])
set_param([sys,'/','qds2abc/in_i0s'],...
		'Port','3',...
		'position',[45,140,65,160])
add_line([sys,'/','qds2abc'],[70,105;105,105])
add_line([sys,'/','qds2abc'],[70,60;105,60])
add_line([sys,'/','qds2abc'],[70,150;105,150])
add_line([sys,'/','qds2abc'],[140,105;180,105])
add_line([sys,'/','qds2abc'],[375,105;435,105])
add_line([sys,'/','qds2abc'],[380,50;435,50])
add_line([sys,'/','qds2abc'],[140,105;155,105;155,50;180,50])
add_line([sys,'/','qds2abc'],[140,105;155,105;155,160;180,160])
add_line([sys,'/','qds2abc'],[380,160;435,160])


%     Finished composite block 'qds2abc'.

set_param([sys,'/','qds2abc'],...
		'position',[680,185,715,265])

add_block('built-in/Sum',[sys,'/','Sum'])
set_param([sys,'/','Sum'],...
		'inputs','+++',...
		'position',[760,185,780,265])

add_block('built-in/Note',[sys,'/','psiqs'])
set_param([sys,'/','psiqs'],...
		'position',[425,90,430,95])

add_block('built-in/Note',[sys,'/','iqs'])
set_param([sys,'/','iqs'],...
		'position',[420,105,425,110])

add_block('built-in/Note',[sys,'/','psiqr'])
set_param([sys,'/','psiqr'],...
		'position',[425,135,430,140])

add_block('built-in/Note',[sys,'/','ibs'])
set_param([sys,'/','ibs'],...
		'position',[725,205,730,210])

add_block('built-in/Note',[sys,'/','ics'])
set_param([sys,'/','ics'],...
		'position',[725,230,730,235])

add_block('built-in/Note',[sys,'/','vds'])
set_param([sys,'/','vds'],...
		'position',[325,205,330,210])

add_block('built-in/Note',[sys,'/','psids'])
set_param([sys,'/','psids'],...
		'position',[430,265,435,270])

add_block('built-in/Note',[sys,'/','ids'])
set_param([sys,'/','ids'],...
		'position',[425,285,430,290])

add_block('built-in/Note',[sys,'/','psidr'])
set_param([sys,'/','psidr'],...
		'position',[434,310,439,315])

add_block('built-in/Note',[sys,'/','ias'])
set_param([sys,'/','ias'],...
		'position',[730,180,735,185])

add_block('built-in/Gain',[sys,'/','omega*t'])
set_param([sys,'/','omega*t'],...
		'orientation',1,...
		'Gain','120*pi',...
		'position',[16,100,74,135])


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
		'position',[470,251,515,269])


%     Subsystem  'm1'.

new_system([sys,'/','m1'])
set_param([sys,'/','m1'],'Location',[660,4849873,820,4850028])

add_block('built-in/Note',[sys,'/',['m1/Masked block of m1.m to initialize s1.m',13,'and plot results']])
set_param([sys,'/',['m1/Masked block of m1.m to initialize s1.m',13,'and plot results']],...
		'position',[95,55,100,60])
set_param([sys,'/','m1'],...
		'Mask Display','Initialize\nand plot',...
		'Mask Type','Masked block of m1.m',...
		'Mask Dialogue','eval(''m1'')',...
		'Mask Help','Uses m1.m to initialize and plot')


%     Finished composite block 'm1'.

set_param([sys,'/','m1'],...
		'Drop Shadow',4,...
		'position',[687,47,755,92])
add_line(sys,[420,300;650,300;650,225;675,225])
add_line(sys,[650,243;650,225;565,225])
add_line(sys,[405,235;350,235;350,145;370,145])
add_line(sys,[415,110;630,110;630,210;565,210])
add_line(sys,[315,225;340,225;340,295;375,295])
add_line(sys,[315,195;340,195;340,120;370,120])
add_line(sys,[415,125;650,125;650,200;675,200])
add_line(sys,[650,190;650,195;565,195])
add_line(sys,[405,185;360,185;360,320;375,320])
add_line(sys,[420,285;605,285;605,180;565,180])
add_line(sys,[515,230;470,230;470,190;435,190])
add_line(sys,[515,230;435,230])
add_line(sys,[535,65;550,65;550,85;580,85])
add_line(sys,[535,65;550,65;550,45;585,45])
add_line(sys,[515,195;480,195;480,95;500,95])
add_line(sys,[515,230;470,230;470,80;500,80])
add_line(sys,[145,45;145,35;45,35;45,95])
add_line(sys,[45,140;45,165;65,165])
add_line(sys,[45,140;45,215;65,215])
add_line(sys,[45,140;45,265;65,265])
add_line(sys,[210,215;260,215])
add_line(sys,[210,165;245,165;245,195;260,195])
add_line(sys,[210,265;240,265;240,235;260,235])
add_line(sys,[145,45;145,35;500,35])
add_line(sys,[210,165;245,165;245,50;500,50])
add_line(sys,[415,155;455,155;455,180;435,180])
add_line(sys,[420,330;460,330;460,240;435,240])
add_line(sys,[315,255;315,350;490,350])
add_line(sys,[720,200;755,200])
add_line(sys,[720,225;755,225])
add_line(sys,[720,250;755,250])
add_line(sys,[535,350;665,350;675,250])
add_line(sys,[720,200;720,145;460,145;460,65;500,65])
add_line(sys,[785,225;795,225;795,390;250,390;260,255])
add_line(sys,[520,260;585,260;585,240;565,240])

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
