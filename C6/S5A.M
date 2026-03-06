function [ret,x0,str,ts,xts]=s5a(t,x,u,flag);
%s5a	is the M-file description of the SIMULINK system named s5a.
%	The block-diagram can be displayed by typing: s5a.
%
%	SYS=s5a(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes s5a to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling s5a with a FLAG of zero:
%	[SIZES]=s5a([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[0,35,754,560])
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
		'Window',[0,436,812,600])
open_system([sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'position',[600,42,620,68])

add_block('built-in/Note',[sys,'/',['Induction Machine Simulation',13,'  in Stationary Reference Frame']])
set_param([sys,'/',['Induction Machine Simulation',13,'  in Stationary Reference Frame']],...
		'position',[145,375,150,380])

add_block('built-in/Note',[sys,'/','vsg'])
set_param([sys,'/','vsg'],...
		'position',[320,252,325,257])

add_block('built-in/Note',[sys,'/','v0s'])
set_param([sys,'/','v0s'],...
		'position',[325,230,330,235])

add_block('built-in/Note',[sys,'/','vds'])
set_param([sys,'/','vds'],...
		'position',[320,210,325,215])

add_block('built-in/Note',[sys,'/','vqs'])
set_param([sys,'/','vqs'],...
		'position',[320,190,325,195])


%     Subsystem  'abc2qds'.

new_system([sys,'/','abc2qds'])
set_param([sys,'/','abc2qds'],'Location',[450,122,1049,440])

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

add_block('built-in/Outport',[sys,'/','abc2qds/out_vds'])
set_param([sys,'/','abc2qds/out_vds'],...
		'Port','2',...
		'position',[465,135,485,155])

add_block('built-in/Sum',[sys,'/','abc2qds/Sum1'])
set_param([sys,'/','abc2qds/Sum1'],...
		'inputs','+-',...
		'position',[415,86,430,124])

add_block('built-in/Sum',[sys,'/','abc2qds/Sum'])
set_param([sys,'/','abc2qds/Sum'],...
		'inputs','+-',...
		'position',[420,181,435,219])

add_block('built-in/Outport',[sys,'/','abc2qds/out_vqs'])
set_param([sys,'/','abc2qds/out_vqs'],...
		'position',[465,95,485,115])

add_block('built-in/Outport',[sys,'/','abc2qds/out_v0s'])
set_param([sys,'/','abc2qds/out_v0s'],...
		'Port','3',...
		'position',[465,190,485,210])

add_block('built-in/Outport',[sys,'/','abc2qds/out_vsg'])
set_param([sys,'/','abc2qds/out_vsg'],...
		'Port','4',...
		'position',[465,245,485,265])
add_line([sys,'/','abc2qds'],[105,100;140,100])
add_line([sys,'/','abc2qds'],[105,145;140,145])
add_line([sys,'/','abc2qds'],[105,190;140,190])
add_line([sys,'/','abc2qds'],[175,145;220,145])
add_line([sys,'/','abc2qds'],[175,145;190,145;190,95;220,95])
add_line([sys,'/','abc2qds'],[380,145;460,145])
add_line([sys,'/','abc2qds'],[175,145;190,145;190,190;220,190])
add_line([sys,'/','abc2qds'],[440,200;460,200])
add_line([sys,'/','abc2qds'],[380,190;415,190])
add_line([sys,'/','abc2qds'],[285,235;295,235])
add_line([sys,'/','abc2qds'],[105,235;180,235])
add_line([sys,'/','abc2qds'],[335,235;385,235;385,210;415,210])
add_line([sys,'/','abc2qds'],[385,95;410,95])
add_line([sys,'/','abc2qds'],[435,105;460,105])
add_line([sys,'/','abc2qds'],[335,235;385,235;385,115;410,115])
add_line([sys,'/','abc2qds'],[335,235;385,235;385,255;460,255])


%     Finished composite block 'abc2qds'.

set_param([sys,'/','abc2qds'],...
		'position',[265,197,310,283])

add_block('built-in/Note',[sys,'/','vag'])
set_param([sys,'/','vag'],...
		'position',[222,160,227,165])

add_block('built-in/Note',[sys,'/','vbg'])
set_param([sys,'/','vbg'],...
		'position',[222,210,227,215])

add_block('built-in/Note',[sys,'/','vcg'])
set_param([sys,'/','vcg'],...
		'position',[222,260,227,265])

add_block('built-in/Mux',[sys,'/','Mux'])
set_param([sys,'/','Mux'],...
		'inputs','6',...
		'position',[520,46,545,114])

add_block('built-in/Constant',[sys,'/','Tmech'])
set_param([sys,'/','Tmech'],...
		'Value','-Tb/2',...
		'position',[485,266,525,284])


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
		'position',[390,295,425,350])


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
		'position',[385,120,420,175])

add_block('built-in/Clock',[sys,'/','Clock'])
set_param([sys,'/','Clock'],...
		'orientation',3,...
		'position',[141,65,169,90])

add_block('built-in/To Workspace',[sys,'/','To Workspace'])
set_param([sys,'/','To Workspace'],...
		'mat-name','y',...
		'buffer','80000',...
		'position',[595,91,640,109])

add_block('built-in/Note',[sys,'/','i0s'])
set_param([sys,'/','i0s'],...
		'position',[560,345,565,350])


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
		'position',[505,340,540,390])

add_block('built-in/Note',[sys,'/','Tem'])
set_param([sys,'/','Tem'],...
		'position',[509,192,514,197])

add_block('built-in/Product',[sys,'/','Product1'])
set_param([sys,'/','Product1'],...
		'orientation',2,...
		'position',[420,238,440,262])

add_block('built-in/Product',[sys,'/','Product'])
set_param([sys,'/','Product'],...
		'orientation',2,...
		'position',[420,189,440,211])


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
		'position',[530,189,570,261])

add_block('built-in/Fcn',[sys,'/','Fcn2'])
set_param([sys,'/','Fcn2'],...
		'Expr','Vm*cos(u[1]+2*pi/3)',...
		'position',[80,266,210,294])

add_block('built-in/Fcn',[sys,'/','Fcn1'])
set_param([sys,'/','Fcn1'],...
		'Expr','Vm*cos(u[1]-2*pi/3)',...
		'position',[80,215,210,245])

add_block('built-in/Fcn',[sys,'/','Fcn'])
set_param([sys,'/','Fcn'],...
		'Expr','Vm*cos(u[1])',...
		'position',[80,166,210,194])

add_block('built-in/Note',[sys,'/','wr//wb'])
set_param([sys,'/','wr//wb'],...
		'position',[500,220,505,225])


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
		'position',[690,200,725,280])

add_block('built-in/Sum',[sys,'/','Sum'])
set_param([sys,'/','Sum'],...
		'inputs','+++',...
		'position',[770,200,790,280])

add_block('built-in/Note',[sys,'/','psiqs'])
set_param([sys,'/','psiqs'],...
		'position',[435,105,440,110])

add_block('built-in/Note',[sys,'/','iqs'])
set_param([sys,'/','iqs'],...
		'position',[430,120,435,125])

add_block('built-in/Note',[sys,'/','psiqr'])
set_param([sys,'/','psiqr'],...
		'position',[435,150,440,155])

add_block('built-in/Note',[sys,'/','ibs'])
set_param([sys,'/','ibs'],...
		'position',[735,220,740,225])

add_block('built-in/Note',[sys,'/','ics'])
set_param([sys,'/','ics'],...
		'position',[735,245,740,250])

add_block('built-in/Note',[sys,'/','psids'])
set_param([sys,'/','psids'],...
		'position',[440,280,445,285])

add_block('built-in/Note',[sys,'/','ids'])
set_param([sys,'/','ids'],...
		'position',[435,300,440,305])

add_block('built-in/Note',[sys,'/','psidr'])
set_param([sys,'/','psidr'],...
		'position',[444,325,449,330])

add_block('built-in/Note',[sys,'/','ias'])
set_param([sys,'/','ias'],...
		'position',[740,195,745,200])

add_block('built-in/Gain',[sys,'/','omega*t'])
set_param([sys,'/','omega*t'],...
		'orientation',1,...
		'Gain','120*pi',...
		'position',[26,115,84,150])


%     Subsystem  'm5'.

new_system([sys,'/','m5'])
set_param([sys,'/','m5'],'Location',[25,7209387,317,7209476])

add_block('built-in/Note',[sys,'/',['m5/Uses m5.m to initIalize simulation ',13,'and plot results']])
set_param([sys,'/',['m5/Uses m5.m to initIalize simulation ',13,'and plot results']],...
		'position',[140,43,145,48])
set_param([sys,'/','m5'],...
		'Mask Display','Initialize\nand plot',...
		'Mask Type','Masked block of m5.m',...
		'Mask Dialogue','eval(''m5'')',...
		'Mask Help','Uses m5.m to initialize and plot')


%     Finished composite block 'm5'.

set_param([sys,'/','m5'],...
		'Drop Shadow',4,...
		'position',[106,322,176,359])
add_line(sys,[430,315;660,315;660,240;685,240])
add_line(sys,[660,258;660,240;575,240])
add_line(sys,[415,250;360,250;360,160;380,160])
add_line(sys,[425,125;640,125;640,225;575,225])
add_line(sys,[315,230;345,230;345,310;385,310])
add_line(sys,[315,210;335,210;335,135;380,135])
add_line(sys,[425,140;660,140;660,215;685,215])
add_line(sys,[660,205;660,210;575,210])
add_line(sys,[415,200;370,200;370,335;385,335])
add_line(sys,[430,300;615,300;615,195;575,195])
add_line(sys,[525,245;480,245;480,205;445,205])
add_line(sys,[525,245;445,245])
add_line(sys,[550,80;560,80;560,100;590,100])
add_line(sys,[550,80;560,80;560,55;595,55])
add_line(sys,[525,210;490,210;490,95;515,95])
add_line(sys,[525,245;480,245;480,85;515,85])
add_line(sys,[155,60;155,55;55,55;55,110])
add_line(sys,[55,155;55,180;75,180])
add_line(sys,[55,155;55,230;75,230])
add_line(sys,[55,155;55,280;75,280])
add_line(sys,[215,230;260,230])
add_line(sys,[215,180;240,180;240,210;260,210])
add_line(sys,[215,280;240,280;240,250;260,250])
add_line(sys,[155,60;155,55;515,55])
add_line(sys,[215,180;240,180;240,65;515,65])
add_line(sys,[425,170;465,170;465,195;445,195])
add_line(sys,[430,345;470,345;470,255;445,255])
add_line(sys,[315,250;335,250;335,365;500,365])
add_line(sys,[730,215;765,215])
add_line(sys,[730,240;765,240])
add_line(sys,[730,265;765,265])
add_line(sys,[545,365;675,365;685,265])
add_line(sys,[730,215;730,160;470,160;470,75;515,75])
add_line(sys,[795,240;805,240;805,405;250,405;260,270])
add_line(sys,[530,275;595,275;595,255;575,255])
add_line(sys,[315,270;350,270;350,105;515,105])

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
