function [ret,x0,str,ts,xts]=s3eig(t,x,u,flag);
%s3eig	is the M-file description of the SIMULINK system named s3eig.
%	The block-diagram can be displayed by typing: s3eig.
%
%	SYS=s3eig(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes s3eig to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling s3eig with a FLAG of zero:
%	[SIZES]=s3eig([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[-7,83,784,483])
     open_system(sys)
end;
set_param(sys,'algorithm',     'RK-45')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     '999999')
set_param(sys,'Min step size', '0.0001')
set_param(sys,'Max step size', '10')
set_param(sys,'Relative error','1e-3')
set_param(sys,'Return vars',   '')

add_block('built-in/Note',[sys,'/','vqr'])
set_param([sys,'/','vqr'],...
		'position',[356,172,361,177])

add_block('built-in/Note',[sys,'/','vdr'])
set_param([sys,'/','vdr'],...
		'position',[358,224,363,229])

add_block('built-in/Inport',[sys,'/','in_Ex'])
set_param([sys,'/','in_Ex'],...
		'Port','3',...
		'position',[335,275,355,295])

add_block('built-in/Outport',[sys,'/','out_Pgen'])
set_param([sys,'/','out_Pgen'],...
		'position',[705,55,725,75])

add_block('built-in/Outport',[sys,'/','out_Qgen'])
set_param([sys,'/','out_Qgen'],...
		'Port','2',...
		'position',[665,70,685,90])


%     Subsystem  'VIPQ'.

new_system([sys,'/','VIPQ'])
set_param([sys,'/','VIPQ'],'Location',[217,186,928,574])

add_block('built-in/Mux',[sys,'/','VIPQ/Mux'])
set_param([sys,'/','VIPQ/Mux'],...
		'position',[180,75,210,260])

add_block('built-in/Inport',[sys,'/','VIPQ/vdr'])
set_param([sys,'/','VIPQ/vdr'],...
		'Port','3',...
		'position',[115,180,135,200])

add_block('built-in/Fcn',[sys,'/','VIPQ/Fcn'])
set_param([sys,'/','VIPQ/Fcn'],...
		'Expr','sqrt(u[1]*u[1] + u[3]*u[3])',...
		'position',[285,75,450,105])

add_block('built-in/Fcn',[sys,'/','VIPQ/P'])
set_param([sys,'/','VIPQ/P'],...
		'Expr','u[1]*u[2] + u[3]*u[4]',...
		'position',[285,180,450,210])

add_block('built-in/Fcn',[sys,'/','VIPQ/Q'])
set_param([sys,'/','VIPQ/Q'],...
		'Expr','u[1]*u[4]-u[2]*u[3]',...
		'position',[285,230,450,260])

add_block('built-in/Outport',[sys,'/','VIPQ/Pgen'])
set_param([sys,'/','VIPQ/Pgen'],...
		'Port','3',...
		'position',[510,185,530,205])

add_block('built-in/Outport',[sys,'/','VIPQ/Out_|Vt|'])
set_param([sys,'/','VIPQ/Out_|Vt|'],...
		'position',[510,80,530,100])

add_block('built-in/Fcn',[sys,'/','VIPQ/Fcn1'])
set_param([sys,'/','VIPQ/Fcn1'],...
		'Expr','sqrt(u[2]*u[2] + u[4]*u[4])',...
		'position',[285,125,450,155])

add_block('built-in/Outport',[sys,'/','VIPQ/Qgen'])
set_param([sys,'/','VIPQ/Qgen'],...
		'Port','4',...
		'position',[510,235,530,255])

add_block('built-in/Outport',[sys,'/','VIPQ/Out_|It|'])
set_param([sys,'/','VIPQ/Out_|It|'],...
		'Port','2',...
		'position',[510,130,530,150])

add_block('built-in/Inport',[sys,'/','VIPQ/-iqr'])
set_param([sys,'/','VIPQ/-iqr'],...
		'Port','2',...
		'position',[115,135,135,155])

add_block('built-in/Inport',[sys,'/','VIPQ/vqr'])
set_param([sys,'/','VIPQ/vqr'],...
		'position',[115,90,135,110])

add_block('built-in/Inport',[sys,'/','VIPQ/-idr'])
set_param([sys,'/','VIPQ/-idr'],...
		'Port','4',...
		'position',[115,225,135,245])
add_line([sys,'/','VIPQ'],[140,100;175,100])
add_line([sys,'/','VIPQ'],[140,145;175,145])
add_line([sys,'/','VIPQ'],[140,190;175,190])
add_line([sys,'/','VIPQ'],[140,235;175,235])
add_line([sys,'/','VIPQ'],[215,170;240,170;240,195;280,195])
add_line([sys,'/','VIPQ'],[455,195;505,195])
add_line([sys,'/','VIPQ'],[455,245;505,245])
add_line([sys,'/','VIPQ'],[215,170;240,170;240,245;280,245])
add_line([sys,'/','VIPQ'],[215,170;240,170;240,90;280,90])
add_line([sys,'/','VIPQ'],[215,170;240,170;240,140;280,140])
add_line([sys,'/','VIPQ'],[455,140;505,140])
add_line([sys,'/','VIPQ'],[455,90;505,90])


%     Finished composite block 'VIPQ'.

set_param([sys,'/','VIPQ'],...
		'position',[545,28,580,87])

add_block('built-in/Inport',[sys,'/','in_vdse'])
set_param([sys,'/','in_vdse'],...
		'Port','2',...
		'position',[55,240,75,260])

add_block('built-in/Inport',[sys,'/','in_vqse'])
set_param([sys,'/','in_vqse'],...
		'position',[55,200,75,220])

add_block('built-in/Product',[sys,'/','prod2'])
set_param([sys,'/','prod2'],...
		'orientation',2,...
		'Font Number',3,...
		'position',[420,308,435,337])

add_block('built-in/Inport',[sys,'/','in_Tmech'])
set_param([sys,'/','in_Tmech'],...
		'Port','4',...
		'position',[535,270,555,290])

add_block('built-in/Outport',[sys,'/','out_(wr-we)//wb'])
set_param([sys,'/','out_(wr-we)//wb'],...
		'Port','5',...
		'position',[705,275,725,295])

add_block('built-in/Outport',[sys,'/','out_delta'])
set_param([sys,'/','out_delta'],...
		'Port','3',...
		'position',[705,170,725,190])

add_block('built-in/Outport',[sys,'/','out_Tem'])
set_param([sys,'/','out_Tem'],...
		'Port','4',...
		'position',[705,240,725,260])


%     Subsystem  'q_cct'.

new_system([sys,'/','q_cct'])
set_param([sys,'/','q_cct'],'Location',[168,350,1046,687])

add_block('built-in/Outport',[sys,'/','q_cct/Out_psiq'])
set_param([sys,'/','q_cct/Out_psiq'],...
		'position',[585,45,605,65])

add_block('built-in/Integrator',[sys,'/','q_cct/psiq_'])
set_param([sys,'/','q_cct/psiq_'],...
		'Initial','Psiqo',...
		'position',[390,127,420,153])

add_block('built-in/Fcn',[sys,'/','q_cct/Fcn'])
set_param([sys,'/','q_cct/Fcn'],...
		'Expr','wb*(u[2]-u[3]+(rs/xls)*(u[1]-u[4]))',...
		'position',[180,125,375,155])

add_block('built-in/Inport',[sys,'/','q_cct/In_wrpsid'])
set_param([sys,'/','q_cct/In_wrpsid'],...
		'Port','2',...
		'position',[50,160,70,180])

add_block('built-in/Inport',[sys,'/','q_cct/In_vqr'])
set_param([sys,'/','q_cct/In_vqr'],...
		'position',[50,105,70,125])

add_block('built-in/Mux',[sys,'/','q_cct/Mux'])
set_param([sys,'/','q_cct/Mux'],...
		'position',[135,86,160,189])

add_block('built-in/Mux',[sys,'/','q_cct/Mux3'])
set_param([sys,'/','q_cct/Mux3'],...
		'inputs','2',...
		'position',[515,92,540,163])

add_block('built-in/Fcn',[sys,'/','q_cct/Fcn3'])
set_param([sys,'/','q_cct/Fcn3'],...
		'Expr','xMQ*(u[1]/xls+u[2]/xplkq)',...
		'position',[565,113,715,147])

add_block('built-in/Fcn',[sys,'/','q_cct/Fcn4'])
set_param([sys,'/','q_cct/Fcn4'],...
		'Expr','-(u[1]-u[2])/xls',...
		'position',[565,202,655,228])

add_block('built-in/Mux',[sys,'/','q_cct/Mux4'])
set_param([sys,'/','q_cct/Mux4'],...
		'inputs','2',...
		'position',[520,179,540,246])

add_block('built-in/Mux',[sys,'/','q_cct/Mux2'])
set_param([sys,'/','q_cct/Mux2'],...
		'inputs','2',...
		'position',[135,213,160,277])

add_block('built-in/Outport',[sys,'/','q_cct/Out_psimq'])
set_param([sys,'/','q_cct/Out_psimq'],...
		'Port','3',...
		'position',[805,120,825,140])

add_block('built-in/Outport',[sys,'/','q_cct/Out_-iq'])
set_param([sys,'/','q_cct/Out_-iq'],...
		'Port','2',...
		'position',[805,205,825,225])

add_block('built-in/Fcn',[sys,'/','q_cct/Fcn2'])
set_param([sys,'/','q_cct/Fcn2'],...
		'Expr','wb*rpkq*(u[1]-u[2])/xplkq',...
		'position',[185,231,370,259])

add_block('built-in/Integrator',[sys,'/','q_cct/psipkq_'])
set_param([sys,'/','q_cct/psipkq_'],...
		'Initial','Psikqo',...
		'position',[395,232,425,258])

add_block('built-in/Scope',[sys,'/','q_cct/qaxis_Scope'])
set_param([sys,'/','q_cct/qaxis_Scope'],...
		'Vgain','3.000000',...
		'Hgain','0.050000',...
		'Vmax','6.000000',...
		'Hmax','2.000000',...
		'Window',[451,130,627,387],...
		'position',[805,252,825,278])
add_line([sys,'/','q_cct'],[75,170;95,170;95,150;130,150])
add_line([sys,'/','q_cct'],[75,115;95,115;95,125;130,125])
add_line([sys,'/','q_cct'],[165,140;175,140])
add_line([sys,'/','q_cct'],[380,140;385,140])
add_line([sys,'/','q_cct'],[425,140;435,140;435,205;115,205;115,175;130,175])
add_line([sys,'/','q_cct'],[165,245;180,245])
add_line([sys,'/','q_cct'],[375,245;390,245])
add_line([sys,'/','q_cct'],[430,245;460,245;460,305;115,305;115,260;130,260])
add_line([sys,'/','q_cct'],[425,140;435,140;435,110;510,110])
add_line([sys,'/','q_cct'],[430,245;460,245;460,145;510,145])
add_line([sys,'/','q_cct'],[545,130;560,130])
add_line([sys,'/','q_cct'],[545,215;560,215])
add_line([sys,'/','q_cct'],[425,140;470,140;470,195;515,195])
add_line([sys,'/','q_cct'],[720,130;755,130;755,315;495,315;495,230;515,230])
add_line([sys,'/','q_cct'],[720,130;755,130;755,315;90,315;90,230;130,230])
add_line([sys,'/','q_cct'],[720,130;755,130;755,80;115,80;115,100;130,100])
add_line([sys,'/','q_cct'],[720,130;800,130])
add_line([sys,'/','q_cct'],[660,215;800,215])
add_line([sys,'/','q_cct'],[425,140;435,140;435,55;580,55])


%     Finished composite block 'q_cct'.

set_param([sys,'/','q_cct'],...
		'position',[410,154,445,206])


%     Subsystem  'Rotor'.

new_system([sys,'/','Rotor'])
set_param([sys,'/','Rotor'],'Location',[250,375,944,671])

add_block('built-in/Outport',[sys,'/','Rotor/wr//wb '])
set_param([sys,'/','Rotor/wr//wb '],...
		'Port','2',...
		'position',[600,195,620,215])

add_block('built-in/Outport',[sys,'/','Rotor/delta'])
set_param([sys,'/','Rotor/delta'],...
		'position',[595,130,615,150])

add_block('built-in/Outport',[sys,'/','Rotor/(wr-we)//wb'])
set_param([sys,'/','Rotor/(wr-we)//wb'],...
		'Port','4',...
		'position',[595,75,615,95])

add_block('built-in/Inport',[sys,'/','Rotor/Tmech'])
set_param([sys,'/','Rotor/Tmech'],...
		'Port','5',...
		'position',[80,60,100,80])

add_block('built-in/Outport',[sys,'/','Rotor/Tem'])
set_param([sys,'/','Rotor/Tem'],...
		'Port','3',...
		'position',[265,203,290,227])

add_block('built-in/Inport',[sys,'/','Rotor/-idr'])
set_param([sys,'/','Rotor/-idr'],...
		'Port','4',...
		'position',[80,210,100,230])

add_block('built-in/Inport',[sys,'/','Rotor/-iqr'])
set_param([sys,'/','Rotor/-iqr'],...
		'position',[80,95,100,115])

add_block('built-in/Note',[sys,'/','Rotor/Tem_'])
set_param([sys,'/','Rotor/Tem_'],...
		'position',[220,140,225,145])

add_block('built-in/Product',[sys,'/','Rotor/Prod'])
set_param([sys,'/','Rotor/Prod'],...
		'position',[140,124,155,146])

add_block('built-in/Inport',[sys,'/','Rotor/psiq'])
set_param([sys,'/','Rotor/psiq'],...
		'Port','3',...
		'position',[80,170,100,190])

add_block('built-in/Product',[sys,'/','Rotor/Prod2'])
set_param([sys,'/','Rotor/Prod2'],...
		'position',[140,175,155,195])

add_block('built-in/Sum',[sys,'/','Rotor/Sum12'])
set_param([sys,'/','Rotor/Sum12'],...
		'inputs','-+',...
		'position',[180,111,200,209])

add_block('built-in/Inport',[sys,'/','Rotor/psid '])
set_param([sys,'/','Rotor/psid '],...
		'Port','2',...
		'position',[80,130,100,150])

add_block('built-in/Integrator',[sys,'/','Rotor/slip'])
set_param([sys,'/','Rotor/slip'],...
		'position',[400,125,435,155])

add_block('built-in/Gain',[sys,'/','Rotor/Damping'])
set_param([sys,'/','Rotor/Damping'],...
		'orientation',2,...
		'Gain','Domega',...
		'position',[315,68,405,102])

add_block('built-in/Sum',[sys,'/','Rotor/Tacc'])
set_param([sys,'/','Rotor/Tacc'],...
		'inputs','-++',...
		'position',[270,110,290,170])

add_block('built-in/Constant',[sys,'/','Rotor/we//wb'])
set_param([sys,'/','Rotor/we//wb'],...
		'position',[415,203,445,227])

add_block('built-in/Sum',[sys,'/','Rotor/Sum14'])
set_param([sys,'/','Rotor/Sum14'],...
		'position',[490,183,505,227])

add_block('built-in/Integrator',[sys,'/','Rotor/del'])
set_param([sys,'/','Rotor/del'],...
		'position',[530,125,565,155])

add_block('built-in/Gain',[sys,'/','Rotor/gain4'])
set_param([sys,'/','Rotor/gain4'],...
		'Gain','wb',...
		'position',[475,124,510,156])

add_block('built-in/Gain',[sys,'/','Rotor/1//2H'])
set_param([sys,'/','Rotor/1//2H'],...
		'Gain','1/(2*H)',...
		'position',[310,120,380,160])
add_line([sys,'/','Rotor'],[310,85;250,85;250,120;265,120])
add_line([sys,'/','Rotor'],[205,160;265,160])
add_line([sys,'/','Rotor'],[440,140;470,140])
add_line([sys,'/','Rotor'],[515,140;525,140])
add_line([sys,'/','Rotor'],[160,185;175,185])
add_line([sys,'/','Rotor'],[385,140;395,140])
add_line([sys,'/','Rotor'],[450,215;485,215])
add_line([sys,'/','Rotor'],[295,140;305,140])
add_line([sys,'/','Rotor'],[160,135;175,135])
add_line([sys,'/','Rotor'],[105,105;115,105;115,130;135,130])
add_line([sys,'/','Rotor'],[105,140;135,140])
add_line([sys,'/','Rotor'],[105,180;135,180])
add_line([sys,'/','Rotor'],[105,220;115,220;115,190;135,190])
add_line([sys,'/','Rotor'],[510,205;595,205])
add_line([sys,'/','Rotor'],[205,160;240,160;240,215;260,215])
add_line([sys,'/','Rotor'],[440,140;455,140;455,195;485,195])
add_line([sys,'/','Rotor'],[440,140;455,140;455,85;410,85])
add_line([sys,'/','Rotor'],[105,70;235,70;235,140;265,140])
add_line([sys,'/','Rotor'],[570,140;590,140])
add_line([sys,'/','Rotor'],[440,140;455,140;455,85;590,85])


%     Finished composite block 'Rotor'.

set_param([sys,'/','Rotor'],...
		'Font Number',3,...
		'position',[580,163,625,297])


%     Subsystem  'd_cct'.

new_system([sys,'/','d_cct'])
set_param([sys,'/','d_cct'],'Location',[276,284,1225,801])

add_block('built-in/Outport',[sys,'/','d_cct/Out_psid'])
set_param([sys,'/','d_cct/Out_psid'],...
		'position',[585,45,605,65])

add_block('built-in/Inport',[sys,'/','d_cct/In_Ef'])
set_param([sys,'/','d_cct/In_Ef'],...
		'Port','3',...
		'position',[50,250,70,270])

add_block('built-in/Outport',[sys,'/','d_cct/Out_ipf'])
set_param([sys,'/','d_cct/Out_ipf'],...
		'Port','4',...
		'position',[835,335,855,355])

add_block('built-in/Outport',[sys,'/','d_cct/Out_-id'])
set_param([sys,'/','d_cct/Out_-id'],...
		'Port','2',...
		'position',[830,230,850,250])

add_block('built-in/Outport',[sys,'/','d_cct/Out_psimd'])
set_param([sys,'/','d_cct/Out_psimd'],...
		'Port','3',...
		'position',[835,120,855,140])

add_block('built-in/Fcn',[sys,'/','d_cct/Fcn5'])
set_param([sys,'/','d_cct/Fcn5'],...
		'Expr','(u[1]-u[2])/xplf',...
		'position',[565,332,655,358])

add_block('built-in/Mux',[sys,'/','d_cct/Mux5'])
set_param([sys,'/','d_cct/Mux5'],...
		'inputs','2',...
		'position',[520,309,540,376])

add_block('built-in/Mux',[sys,'/','d_cct/Mux4'])
set_param([sys,'/','d_cct/Mux4'],...
		'inputs','2',...
		'position',[520,204,540,271])

add_block('built-in/Fcn',[sys,'/','d_cct/Fcn4'])
set_param([sys,'/','d_cct/Fcn4'],...
		'Expr','-(u[1]-u[2])/xls',...
		'position',[565,227,655,253])

add_block('built-in/Fcn',[sys,'/','d_cct/Fcn3'])
set_param([sys,'/','d_cct/Fcn3'],...
		'Expr','xMD*(u[1]/xls+u[2]/xplf+u[3]/xplkd)',...
		'position',[565,114,775,146])

add_block('built-in/Mux',[sys,'/','d_cct/Mux3'])
set_param([sys,'/','d_cct/Mux3'],...
		'inputs','3',...
		'position',[520,87,545,173])

add_block('built-in/Integrator',[sys,'/','d_cct/psipkd_'])
set_param([sys,'/','d_cct/psipkd_'],...
		'Initial','Psikdo',...
		'position',[390,357,420,383])

add_block('built-in/Fcn',[sys,'/','d_cct/Fcn2'])
set_param([sys,'/','d_cct/Fcn2'],...
		'Expr','wb*rpkd*(u[1]-u[2])/xplkd',...
		'position',[180,356,365,384])

add_block('built-in/Integrator',[sys,'/','d_cct/psipf_'])
set_param([sys,'/','d_cct/psipf_'],...
		'Initial','Psifo',...
		'position',[390,247,420,273])

add_block('built-in/Fcn',[sys,'/','d_cct/Fcn1'])
set_param([sys,'/','d_cct/Fcn1'],...
		'Expr','wb*rpf*(u[2]/xmd+(u[1]-u[3])/xplf)',...
		'position',[175,245,375,275])

add_block('built-in/Integrator',[sys,'/','d_cct/psid_'])
set_param([sys,'/','d_cct/psid_'],...
		'Initial','Psido',...
		'position',[390,127,420,153])

add_block('built-in/Mux',[sys,'/','d_cct/Mux2'])
set_param([sys,'/','d_cct/Mux2'],...
		'inputs','2',...
		'position',[130,330,155,405])

add_block('built-in/Mux',[sys,'/','d_cct/Mux1'])
set_param([sys,'/','d_cct/Mux1'],...
		'inputs','3',...
		'position',[135,217,160,303])

add_block('built-in/Fcn',[sys,'/','d_cct/Fcn'])
set_param([sys,'/','d_cct/Fcn'],...
		'Expr','wb*(u[2]+u[3]+(rs/xls)*(u[1]-u[4]))',...
		'position',[180,125,375,155])

add_block('built-in/Inport',[sys,'/','d_cct/In_wrpsiq'])
set_param([sys,'/','d_cct/In_wrpsiq'],...
		'Port','2',...
		'position',[50,160,70,180])

add_block('built-in/Inport',[sys,'/','d_cct/In_vdr'])
set_param([sys,'/','d_cct/In_vdr'],...
		'position',[50,105,70,125])

add_block('built-in/Mux',[sys,'/','d_cct/Mux'])
set_param([sys,'/','d_cct/Mux'],...
		'position',[135,86,160,189])

add_block('built-in/Scope',[sys,'/','d_cct/daxis_Scope'])
set_param([sys,'/','d_cct/daxis_Scope'],...
		'Vgain','3.000000',...
		'Hgain','0.050000',...
		'Vmax','6.000000',...
		'Hmax','2.000000',...
		'Window',[451,130,627,387],...
		'position',[835,402,855,428])
add_line([sys,'/','d_cct'],[75,170;95,170;95,150;130,150])
add_line([sys,'/','d_cct'],[75,115;95,115;95,125;130,125])
add_line([sys,'/','d_cct'],[165,140;175,140])
add_line([sys,'/','d_cct'],[380,140;385,140])
add_line([sys,'/','d_cct'],[425,140;435,140;435,205;115,205;115,175;130,175])
add_line([sys,'/','d_cct'],[165,260;170,260])
add_line([sys,'/','d_cct'],[380,260;385,260])
add_line([sys,'/','d_cct'],[425,260;450,260;450,320;115,320;115,290;130,290])
add_line([sys,'/','d_cct'],[75,260;130,260])
add_line([sys,'/','d_cct'],[160,370;175,370])
add_line([sys,'/','d_cct'],[370,370;385,370])
add_line([sys,'/','d_cct'],[425,370;460,370;460,430;110,430;110,385;125,385])
add_line([sys,'/','d_cct'],[425,140;435,140;435,100;515,100])
add_line([sys,'/','d_cct'],[425,260;450,260;450,130;515,130])
add_line([sys,'/','d_cct'],[425,370;460,370;460,160;515,160])
add_line([sys,'/','d_cct'],[550,130;560,130])
add_line([sys,'/','d_cct'],[545,240;560,240])
add_line([sys,'/','d_cct'],[425,140;470,140;470,220;515,220])
add_line([sys,'/','d_cct'],[545,345;560,345])
add_line([sys,'/','d_cct'],[425,260;485,260;485,325;515,325])
add_line([sys,'/','d_cct'],[780,130;790,130;790,445;495,445;495,360;515,360])
add_line([sys,'/','d_cct'],[780,130;790,130;790,305;495,305;495,255;515,255])
add_line([sys,'/','d_cct'],[780,130;790,130;790,445;90,445;90,350;125,350])
add_line([sys,'/','d_cct'],[780,130;790,130;790,445;90,445;90,230;130,230])
add_line([sys,'/','d_cct'],[780,130;790,130;790,80;115,80;115,100;130,100])
add_line([sys,'/','d_cct'],[780,130;830,130])
add_line([sys,'/','d_cct'],[660,240;825,240])
add_line([sys,'/','d_cct'],[660,345;830,345])
add_line([sys,'/','d_cct'],[425,140;435,140;435,55;580,55])


%     Finished composite block 'd_cct'.

set_param([sys,'/','d_cct'],...
		'position',[410,234,445,291])

add_block('built-in/Product',[sys,'/','prod1'])
set_param([sys,'/','prod1'],...
		'orientation',2,...
		'Font Number',3,...
		'position',[420,109,435,136])

add_block('built-in/Note',[sys,'/','-idr'])
set_param([sys,'/','-idr'],...
		'position',[483,256,488,261])

add_block('built-in/Note',[sys,'/','psiq'])
set_param([sys,'/','psiq'],...
		'position',[468,146,473,151])

add_block('built-in/Note',[sys,'/','psid'])
set_param([sys,'/','psid'],...
		'position',[468,231,473,236])

add_block('built-in/Note',[sys,'/','-iqr'])
set_param([sys,'/','-iqr'],...
		'position',[468,176,473,181])

add_block('built-in/Mux',[sys,'/','Mux1'])
set_param([sys,'/','Mux1'],...
		'inputs','3',...
		'position',[115,148,140,272])

add_block('built-in/Fcn',[sys,'/','Fcn'])
set_param([sys,'/','Fcn'],...
		'Expr','u[2]*cos(u[1])-u[3]*sin(u[1])',...
		'position',[170,179,335,211])

add_block('built-in/Fcn',[sys,'/','Fcn1'])
set_param([sys,'/','Fcn1'],...
		'Expr','u[2]*sin(u[1])+u[3]*cos(u[1])',...
		'position',[170,229,335,261])
add_line(sys,[450,165;453,165;453,315;440,315])
add_line(sys,[450,240;493,240;493,115;440,115])
add_line(sys,[630,215;643,215;643,130;440,130])
add_line(sys,[630,215;643,215;643,330;440,330])
add_line(sys,[450,165;533,165;533,230;575,230])
add_line(sys,[450,180;575,180])
add_line(sys,[450,255;575,255])
add_line(sys,[450,240;548,240;548,205;575,205])
add_line(sys,[415,325;378,325;378,265;405,265])
add_line(sys,[630,180;700,180])
add_line(sys,[630,250;700,250])
add_line(sys,[360,285;405,285])
add_line(sys,[630,285;700,285])
add_line(sys,[560,280;575,280])
add_line(sys,[80,210;110,210])
add_line(sys,[80,250;110,250])
add_line(sys,[630,180;633,180;633,104;93,104;93,170;110,170])
add_line(sys,[340,195;373,195;373,170;405,170])
add_line(sys,[145,210;148,210;148,195;165,195])
add_line(sys,[340,245;405,245])
add_line(sys,[145,210;148,210;148,245;165,245])
add_line(sys,[450,180;503,180;503,50;540,50])
add_line(sys,[450,255;518,255;518,80;540,80])
add_line(sys,[340,195;373,195;373,35;540,35])
add_line(sys,[340,245;343,245;343,65;540,65])
add_line(sys,[585,65;700,65])
add_line(sys,[585,80;660,80])
add_line(sys,[415,125;388,125;388,195;405,195])

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
