function [ret,x0,str,ts,xts]=s3(t,x,u,flag);
%s3	is the M-file description of the SIMULINK system named s3.
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
     set_param(sys,'Location',[90,54,609,390])
     open_system(sys)
end;
set_param(sys,'algorithm',     'RK-45')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     '999999')
set_param(sys,'Min step size', '0.0001')
set_param(sys,'Max step size', '10')
set_param(sys,'Relative error','1e-3')
set_param(sys,'Return vars',   '')

add_block('built-in/Inport',[sys,'/','vqe'])
set_param([sys,'/','vqe'],...
		'position',[100,80,120,100])


%     Subsystem  'smwes'.

new_system([sys,'/','smwes'])
set_param([sys,'/','smwes'],'Location',[225,202,1090,655])

add_block('built-in/Fcn',[sys,'/','smwes/Fcn1'])
set_param([sys,'/','smwes/Fcn1'],...
		'Expr','u[2]*sin(u[1])+u[3]*cos(u[1])',...
		'position',[185,279,350,311])

add_block('built-in/Note',[sys,'/','smwes/vdr'])
set_param([sys,'/','smwes/vdr'],...
		'position',[385,270,390,275])

add_block('built-in/Note',[sys,'/','smwes/vqr'])
set_param([sys,'/','smwes/vqr'],...
		'position',[388,223,393,228])

add_block('built-in/Fcn',[sys,'/','smwes/Fcn'])
set_param([sys,'/','smwes/Fcn'],...
		'Expr','u[2]*cos(u[1])-u[3]*sin(u[1])',...
		'position',[185,229,350,261])

add_block('built-in/Mux',[sys,'/','smwes/Mux1'])
set_param([sys,'/','smwes/Mux1'],...
		'inputs','3',...
		'position',[130,198,155,322])

add_block('built-in/Note',[sys,'/','smwes/-iqr'])
set_param([sys,'/','smwes/-iqr'],...
		'position',[485,227,490,232])

add_block('built-in/Note',[sys,'/','smwes/psid'])
set_param([sys,'/','smwes/psid'],...
		'position',[485,282,490,287])

add_block('built-in/Note',[sys,'/','smwes/psiq'])
set_param([sys,'/','smwes/psiq'],...
		'position',[485,197,490,202])

add_block('built-in/Note',[sys,'/','smwes/-idr'])
set_param([sys,'/','smwes/-idr'],...
		'position',[500,307,505,312])

add_block('built-in/Product',[sys,'/','smwes/prod1'])
set_param([sys,'/','smwes/prod1'],...
		'orientation',2,...
		'Font Number',3,...
		'position',[435,159,450,186])


%     Subsystem  'smwes/d_cct'.

new_system([sys,'/','smwes/d_cct'])
set_param([sys,'/','smwes/d_cct'],'Location',[276,284,1225,801])

add_block('built-in/Outport',[sys,'/','smwes/d_cct/Out_psid'])
set_param([sys,'/','smwes/d_cct/Out_psid'],...
		'position',[585,45,605,65])

add_block('built-in/Inport',[sys,'/','smwes/d_cct/In_Ef'])
set_param([sys,'/','smwes/d_cct/In_Ef'],...
		'Port','3',...
		'position',[50,250,70,270])

add_block('built-in/Outport',[sys,'/','smwes/d_cct/Out_ipf'])
set_param([sys,'/','smwes/d_cct/Out_ipf'],...
		'Port','4',...
		'position',[835,335,855,355])

add_block('built-in/Outport',[sys,'/','smwes/d_cct/Out_-id'])
set_param([sys,'/','smwes/d_cct/Out_-id'],...
		'Port','2',...
		'position',[830,230,850,250])

add_block('built-in/Outport',[sys,'/','smwes/d_cct/Out_psimd'])
set_param([sys,'/','smwes/d_cct/Out_psimd'],...
		'Port','3',...
		'position',[835,120,855,140])

add_block('built-in/Fcn',[sys,'/','smwes/d_cct/Fcn5'])
set_param([sys,'/','smwes/d_cct/Fcn5'],...
		'Expr','(u[1]-u[2])/xplf',...
		'position',[565,332,655,358])

add_block('built-in/Mux',[sys,'/','smwes/d_cct/Mux5'])
set_param([sys,'/','smwes/d_cct/Mux5'],...
		'inputs','2',...
		'position',[520,309,540,376])

add_block('built-in/Mux',[sys,'/','smwes/d_cct/Mux4'])
set_param([sys,'/','smwes/d_cct/Mux4'],...
		'inputs','2',...
		'position',[520,204,540,271])

add_block('built-in/Fcn',[sys,'/','smwes/d_cct/Fcn4'])
set_param([sys,'/','smwes/d_cct/Fcn4'],...
		'Expr','-(u[1]-u[2])/xls',...
		'position',[565,227,655,253])

add_block('built-in/Fcn',[sys,'/','smwes/d_cct/Fcn3'])
set_param([sys,'/','smwes/d_cct/Fcn3'],...
		'Expr','xMD*(u[1]/xls+u[2]/xplf+u[3]/xplkd)',...
		'position',[565,114,775,146])

add_block('built-in/Mux',[sys,'/','smwes/d_cct/Mux3'])
set_param([sys,'/','smwes/d_cct/Mux3'],...
		'inputs','3',...
		'position',[520,87,545,173])

add_block('built-in/Integrator',[sys,'/','smwes/d_cct/psipkd_'])
set_param([sys,'/','smwes/d_cct/psipkd_'],...
		'Initial','Psikdo',...
		'position',[390,357,420,383])

add_block('built-in/Fcn',[sys,'/','smwes/d_cct/Fcn2'])
set_param([sys,'/','smwes/d_cct/Fcn2'],...
		'Expr','wb*rpkd*(u[1]-u[2])/xplkd',...
		'position',[180,356,365,384])

add_block('built-in/Integrator',[sys,'/','smwes/d_cct/psipf_'])
set_param([sys,'/','smwes/d_cct/psipf_'],...
		'Initial','Psifo',...
		'position',[390,247,420,273])

add_block('built-in/Fcn',[sys,'/','smwes/d_cct/Fcn1'])
set_param([sys,'/','smwes/d_cct/Fcn1'],...
		'Expr','wb*rpf*(u[2]/xmd+(u[1]-u[3])/xplf)',...
		'position',[175,245,375,275])

add_block('built-in/Integrator',[sys,'/','smwes/d_cct/psid_'])
set_param([sys,'/','smwes/d_cct/psid_'],...
		'Initial','Psido',...
		'position',[390,127,420,153])

add_block('built-in/Mux',[sys,'/','smwes/d_cct/Mux2'])
set_param([sys,'/','smwes/d_cct/Mux2'],...
		'inputs','2',...
		'position',[130,330,155,405])

add_block('built-in/Mux',[sys,'/','smwes/d_cct/Mux1'])
set_param([sys,'/','smwes/d_cct/Mux1'],...
		'inputs','3',...
		'position',[135,217,160,303])

add_block('built-in/Fcn',[sys,'/','smwes/d_cct/Fcn'])
set_param([sys,'/','smwes/d_cct/Fcn'],...
		'Expr','wb*(u[2]+u[3]+(rs/xls)*(u[1]-u[4]))',...
		'position',[180,125,375,155])

add_block('built-in/Inport',[sys,'/','smwes/d_cct/In_wrpsiq'])
set_param([sys,'/','smwes/d_cct/In_wrpsiq'],...
		'Port','2',...
		'position',[50,160,70,180])

add_block('built-in/Inport',[sys,'/','smwes/d_cct/In_vdr'])
set_param([sys,'/','smwes/d_cct/In_vdr'],...
		'position',[50,105,70,125])

add_block('built-in/Mux',[sys,'/','smwes/d_cct/Mux'])
set_param([sys,'/','smwes/d_cct/Mux'],...
		'position',[135,86,160,189])

add_block('built-in/Scope',[sys,'/','smwes/d_cct/daxis_Scope'])
set_param([sys,'/','smwes/d_cct/daxis_Scope'],...
		'Vgain','3.000000',...
		'Hgain','0.050000',...
		'Vmax','6.000000',...
		'Hmax','2.000000',...
		'Window',[451,130,627,387],...
		'position',[835,402,855,428])
add_line([sys,'/','smwes/d_cct'],[75,170;95,170;95,150;130,150])
add_line([sys,'/','smwes/d_cct'],[75,115;95,115;95,125;130,125])
add_line([sys,'/','smwes/d_cct'],[165,140;175,140])
add_line([sys,'/','smwes/d_cct'],[380,140;385,140])
add_line([sys,'/','smwes/d_cct'],[425,140;435,140;435,205;115,205;115,175;130,175])
add_line([sys,'/','smwes/d_cct'],[165,260;170,260])
add_line([sys,'/','smwes/d_cct'],[380,260;385,260])
add_line([sys,'/','smwes/d_cct'],[425,260;450,260;450,320;115,320;115,290;130,290])
add_line([sys,'/','smwes/d_cct'],[75,260;130,260])
add_line([sys,'/','smwes/d_cct'],[160,370;175,370])
add_line([sys,'/','smwes/d_cct'],[370,370;385,370])
add_line([sys,'/','smwes/d_cct'],[425,370;460,370;460,430;110,430;110,385;125,385])
add_line([sys,'/','smwes/d_cct'],[425,140;435,140;435,100;515,100])
add_line([sys,'/','smwes/d_cct'],[425,260;450,260;450,130;515,130])
add_line([sys,'/','smwes/d_cct'],[425,370;460,370;460,160;515,160])
add_line([sys,'/','smwes/d_cct'],[550,130;560,130])
add_line([sys,'/','smwes/d_cct'],[545,240;560,240])
add_line([sys,'/','smwes/d_cct'],[425,140;470,140;470,220;515,220])
add_line([sys,'/','smwes/d_cct'],[545,345;560,345])
add_line([sys,'/','smwes/d_cct'],[425,260;485,260;485,325;515,325])
add_line([sys,'/','smwes/d_cct'],[780,130;790,130;790,445;495,445;495,360;515,360])
add_line([sys,'/','smwes/d_cct'],[780,130;790,130;790,305;495,305;495,255;515,255])
add_line([sys,'/','smwes/d_cct'],[780,130;790,130;790,445;90,445;90,350;125,350])
add_line([sys,'/','smwes/d_cct'],[780,130;790,130;790,445;90,445;90,230;130,230])
add_line([sys,'/','smwes/d_cct'],[780,130;790,130;790,80;115,80;115,100;130,100])
add_line([sys,'/','smwes/d_cct'],[780,130;830,130])
add_line([sys,'/','smwes/d_cct'],[660,240;825,240])
add_line([sys,'/','smwes/d_cct'],[660,345;830,345])
add_line([sys,'/','smwes/d_cct'],[425,140;435,140;435,55;580,55])


%     Finished composite block 'smwes/d_cct'.

set_param([sys,'/','smwes/d_cct'],...
		'position',[425,284,460,341])


%     Subsystem  'smwes/Rotor'.

new_system([sys,'/','smwes/Rotor'])
set_param([sys,'/','smwes/Rotor'],'Location',[250,375,944,671])

add_block('built-in/Outport',[sys,'/','smwes/Rotor/wr//wb '])
set_param([sys,'/','smwes/Rotor/wr//wb '],...
		'Port','2',...
		'position',[600,195,620,215])

add_block('built-in/Outport',[sys,'/','smwes/Rotor/delta'])
set_param([sys,'/','smwes/Rotor/delta'],...
		'position',[595,130,615,150])

add_block('built-in/Outport',[sys,'/','smwes/Rotor/(wr-we)//wb'])
set_param([sys,'/','smwes/Rotor/(wr-we)//wb'],...
		'Port','4',...
		'position',[595,75,615,95])

add_block('built-in/Inport',[sys,'/','smwes/Rotor/Tmech'])
set_param([sys,'/','smwes/Rotor/Tmech'],...
		'Port','5',...
		'position',[80,60,100,80])

add_block('built-in/Outport',[sys,'/','smwes/Rotor/Tem'])
set_param([sys,'/','smwes/Rotor/Tem'],...
		'Port','3',...
		'position',[265,203,290,227])

add_block('built-in/Inport',[sys,'/','smwes/Rotor/-id'])
set_param([sys,'/','smwes/Rotor/-id'],...
		'Port','4',...
		'position',[80,210,100,230])

add_block('built-in/Inport',[sys,'/','smwes/Rotor/-iq'])
set_param([sys,'/','smwes/Rotor/-iq'],...
		'position',[80,95,100,115])

add_block('built-in/Note',[sys,'/','smwes/Rotor/Tem_'])
set_param([sys,'/','smwes/Rotor/Tem_'],...
		'position',[220,140,225,145])

add_block('built-in/Product',[sys,'/','smwes/Rotor/Prod'])
set_param([sys,'/','smwes/Rotor/Prod'],...
		'position',[140,124,155,146])

add_block('built-in/Inport',[sys,'/','smwes/Rotor/psiq'])
set_param([sys,'/','smwes/Rotor/psiq'],...
		'Port','3',...
		'position',[80,170,100,190])

add_block('built-in/Product',[sys,'/','smwes/Rotor/Prod2'])
set_param([sys,'/','smwes/Rotor/Prod2'],...
		'position',[140,175,155,195])

add_block('built-in/Sum',[sys,'/','smwes/Rotor/Sum12'])
set_param([sys,'/','smwes/Rotor/Sum12'],...
		'inputs','-+',...
		'position',[180,111,200,209])

add_block('built-in/Inport',[sys,'/','smwes/Rotor/psid '])
set_param([sys,'/','smwes/Rotor/psid '],...
		'Port','2',...
		'position',[80,130,100,150])

add_block('built-in/Integrator',[sys,'/','smwes/Rotor/slip'])
set_param([sys,'/','smwes/Rotor/slip'],...
		'position',[400,125,435,155])

add_block('built-in/Gain',[sys,'/','smwes/Rotor/Damping'])
set_param([sys,'/','smwes/Rotor/Damping'],...
		'orientation',2,...
		'Gain','Domega',...
		'position',[315,68,405,102])

add_block('built-in/Sum',[sys,'/','smwes/Rotor/Tacc'])
set_param([sys,'/','smwes/Rotor/Tacc'],...
		'inputs','-++',...
		'position',[270,110,290,170])

add_block('built-in/Constant',[sys,'/','smwes/Rotor/we//wb'])
set_param([sys,'/','smwes/Rotor/we//wb'],...
		'position',[415,203,445,227])

add_block('built-in/Sum',[sys,'/','smwes/Rotor/Sum14'])
set_param([sys,'/','smwes/Rotor/Sum14'],...
		'position',[490,183,505,227])

add_block('built-in/Integrator',[sys,'/','smwes/Rotor/del'])
set_param([sys,'/','smwes/Rotor/del'],...
		'position',[530,125,565,155])

add_block('built-in/Gain',[sys,'/','smwes/Rotor/gain4'])
set_param([sys,'/','smwes/Rotor/gain4'],...
		'Gain','wb',...
		'position',[475,124,510,156])

add_block('built-in/Gain',[sys,'/','smwes/Rotor/1//2H'])
set_param([sys,'/','smwes/Rotor/1//2H'],...
		'Gain','1/(2*H)',...
		'position',[310,120,380,160])
add_line([sys,'/','smwes/Rotor'],[310,85;250,85;250,120;265,120])
add_line([sys,'/','smwes/Rotor'],[205,160;265,160])
add_line([sys,'/','smwes/Rotor'],[440,140;470,140])
add_line([sys,'/','smwes/Rotor'],[515,140;525,140])
add_line([sys,'/','smwes/Rotor'],[160,185;175,185])
add_line([sys,'/','smwes/Rotor'],[385,140;395,140])
add_line([sys,'/','smwes/Rotor'],[450,215;485,215])
add_line([sys,'/','smwes/Rotor'],[295,140;305,140])
add_line([sys,'/','smwes/Rotor'],[160,135;175,135])
add_line([sys,'/','smwes/Rotor'],[105,105;115,105;115,130;135,130])
add_line([sys,'/','smwes/Rotor'],[105,140;135,140])
add_line([sys,'/','smwes/Rotor'],[105,180;135,180])
add_line([sys,'/','smwes/Rotor'],[105,220;115,220;115,190;135,190])
add_line([sys,'/','smwes/Rotor'],[510,205;595,205])
add_line([sys,'/','smwes/Rotor'],[205,160;240,160;240,215;260,215])
add_line([sys,'/','smwes/Rotor'],[440,140;455,140;455,195;485,195])
add_line([sys,'/','smwes/Rotor'],[440,140;455,140;455,85;410,85])
add_line([sys,'/','smwes/Rotor'],[105,70;235,70;235,140;265,140])
add_line([sys,'/','smwes/Rotor'],[570,140;590,140])
add_line([sys,'/','smwes/Rotor'],[440,140;455,140;455,85;590,85])


%     Finished composite block 'smwes/Rotor'.

set_param([sys,'/','smwes/Rotor'],...
		'Font Number',3,...
		'position',[595,213,640,347])


%     Subsystem  'smwes/q_cct'.

new_system([sys,'/','smwes/q_cct'])
set_param([sys,'/','smwes/q_cct'],'Location',[168,350,1046,687])

add_block('built-in/Outport',[sys,'/','smwes/q_cct/Out_psiq'])
set_param([sys,'/','smwes/q_cct/Out_psiq'],...
		'position',[585,45,605,65])

add_block('built-in/Integrator',[sys,'/','smwes/q_cct/psiq_'])
set_param([sys,'/','smwes/q_cct/psiq_'],...
		'Initial','Psiqo',...
		'position',[390,127,420,153])

add_block('built-in/Fcn',[sys,'/','smwes/q_cct/Fcn'])
set_param([sys,'/','smwes/q_cct/Fcn'],...
		'Expr','wb*(u[2]-u[3]+(rs/xls)*(u[1]-u[4]))',...
		'position',[180,125,375,155])

add_block('built-in/Inport',[sys,'/','smwes/q_cct/In_wrpsid'])
set_param([sys,'/','smwes/q_cct/In_wrpsid'],...
		'Port','2',...
		'position',[50,160,70,180])

add_block('built-in/Inport',[sys,'/','smwes/q_cct/In_vqr'])
set_param([sys,'/','smwes/q_cct/In_vqr'],...
		'position',[50,105,70,125])

add_block('built-in/Mux',[sys,'/','smwes/q_cct/Mux'])
set_param([sys,'/','smwes/q_cct/Mux'],...
		'position',[135,86,160,189])

add_block('built-in/Mux',[sys,'/','smwes/q_cct/Mux3'])
set_param([sys,'/','smwes/q_cct/Mux3'],...
		'inputs','2',...
		'position',[515,92,540,163])

add_block('built-in/Fcn',[sys,'/','smwes/q_cct/Fcn3'])
set_param([sys,'/','smwes/q_cct/Fcn3'],...
		'Expr','xMQ*(u[1]/xls+u[2]/xplkq)',...
		'position',[565,113,715,147])

add_block('built-in/Fcn',[sys,'/','smwes/q_cct/Fcn4'])
set_param([sys,'/','smwes/q_cct/Fcn4'],...
		'Expr','-(u[1]-u[2])/xls',...
		'position',[565,202,655,228])

add_block('built-in/Mux',[sys,'/','smwes/q_cct/Mux4'])
set_param([sys,'/','smwes/q_cct/Mux4'],...
		'inputs','2',...
		'position',[520,179,540,246])

add_block('built-in/Mux',[sys,'/','smwes/q_cct/Mux2'])
set_param([sys,'/','smwes/q_cct/Mux2'],...
		'inputs','2',...
		'position',[135,213,160,277])

add_block('built-in/Outport',[sys,'/','smwes/q_cct/Out_psimq'])
set_param([sys,'/','smwes/q_cct/Out_psimq'],...
		'Port','3',...
		'position',[805,120,825,140])

add_block('built-in/Outport',[sys,'/','smwes/q_cct/Out_-iq'])
set_param([sys,'/','smwes/q_cct/Out_-iq'],...
		'Port','2',...
		'position',[805,205,825,225])

add_block('built-in/Fcn',[sys,'/','smwes/q_cct/Fcn2'])
set_param([sys,'/','smwes/q_cct/Fcn2'],...
		'Expr','wb*rpkq*(u[1]-u[2])/xplkq',...
		'position',[185,231,370,259])

add_block('built-in/Integrator',[sys,'/','smwes/q_cct/psipkq_'])
set_param([sys,'/','smwes/q_cct/psipkq_'],...
		'Initial','Psikqo',...
		'position',[395,232,425,258])

add_block('built-in/Scope',[sys,'/','smwes/q_cct/qaxis_Scope'])
set_param([sys,'/','smwes/q_cct/qaxis_Scope'],...
		'Vgain','3.000000',...
		'Hgain','0.050000',...
		'Vmax','6.000000',...
		'Hmax','2.000000',...
		'Window',[451,130,627,387],...
		'position',[805,252,825,278])
add_line([sys,'/','smwes/q_cct'],[75,170;95,170;95,150;130,150])
add_line([sys,'/','smwes/q_cct'],[75,115;95,115;95,125;130,125])
add_line([sys,'/','smwes/q_cct'],[165,140;175,140])
add_line([sys,'/','smwes/q_cct'],[380,140;385,140])
add_line([sys,'/','smwes/q_cct'],[425,140;435,140;435,205;115,205;115,175;130,175])
add_line([sys,'/','smwes/q_cct'],[165,245;180,245])
add_line([sys,'/','smwes/q_cct'],[375,245;390,245])
add_line([sys,'/','smwes/q_cct'],[430,245;460,245;460,305;115,305;115,260;130,260])
add_line([sys,'/','smwes/q_cct'],[425,140;435,140;435,110;510,110])
add_line([sys,'/','smwes/q_cct'],[430,245;460,245;460,145;510,145])
add_line([sys,'/','smwes/q_cct'],[545,130;560,130])
add_line([sys,'/','smwes/q_cct'],[545,215;560,215])
add_line([sys,'/','smwes/q_cct'],[425,140;470,140;470,195;515,195])
add_line([sys,'/','smwes/q_cct'],[720,130;755,130;755,315;495,315;495,230;515,230])
add_line([sys,'/','smwes/q_cct'],[720,130;755,130;755,315;90,315;90,230;130,230])
add_line([sys,'/','smwes/q_cct'],[720,130;755,130;755,80;115,80;115,100;130,100])
add_line([sys,'/','smwes/q_cct'],[720,130;800,130])
add_line([sys,'/','smwes/q_cct'],[660,215;800,215])
add_line([sys,'/','smwes/q_cct'],[425,140;435,140;435,55;580,55])


%     Finished composite block 'smwes/q_cct'.

set_param([sys,'/','smwes/q_cct'],...
		'position',[425,204,460,256])

add_block('built-in/Outport',[sys,'/','smwes/out_Tem'])
set_param([sys,'/','smwes/out_Tem'],...
		'Port','4',...
		'position',[720,290,740,310])

add_block('built-in/Outport',[sys,'/','smwes/out_delta'])
set_param([sys,'/','smwes/out_delta'],...
		'Port','3',...
		'position',[720,220,740,240])

add_block('built-in/Outport',[sys,'/','smwes/out_(wr-we)//wb'])
set_param([sys,'/','smwes/out_(wr-we)//wb'],...
		'Port','5',...
		'position',[720,325,740,345])

add_block('built-in/Inport',[sys,'/','smwes/in_Tmech'])
set_param([sys,'/','smwes/in_Tmech'],...
		'Port','4',...
		'position',[550,320,570,340])

add_block('built-in/Product',[sys,'/','smwes/prod2'])
set_param([sys,'/','smwes/prod2'],...
		'orientation',2,...
		'Font Number',3,...
		'position',[435,358,450,387])

add_block('built-in/Inport',[sys,'/','smwes/in_vqse'])
set_param([sys,'/','smwes/in_vqse'],...
		'position',[70,250,90,270])

add_block('built-in/Inport',[sys,'/','smwes/in_vdse'])
set_param([sys,'/','smwes/in_vdse'],...
		'Port','2',...
		'position',[70,290,90,310])


%     Subsystem  'smwes/VIPQ'.

new_system([sys,'/','smwes/VIPQ'])
set_param([sys,'/','smwes/VIPQ'],'Location',[217,186,928,574])

add_block('built-in/Mux',[sys,'/','smwes/VIPQ/Mux'])
set_param([sys,'/','smwes/VIPQ/Mux'],...
		'position',[180,75,210,260])

add_block('built-in/Inport',[sys,'/','smwes/VIPQ/vdr'])
set_param([sys,'/','smwes/VIPQ/vdr'],...
		'Port','3',...
		'position',[115,180,135,200])

add_block('built-in/Fcn',[sys,'/','smwes/VIPQ/Fcn'])
set_param([sys,'/','smwes/VIPQ/Fcn'],...
		'Expr','sqrt(u[1]*u[1] + u[3]*u[3])',...
		'position',[285,75,450,105])

add_block('built-in/Fcn',[sys,'/','smwes/VIPQ/P'])
set_param([sys,'/','smwes/VIPQ/P'],...
		'Expr','u[1]*u[2] + u[3]*u[4]',...
		'position',[285,180,450,210])

add_block('built-in/Fcn',[sys,'/','smwes/VIPQ/Q'])
set_param([sys,'/','smwes/VIPQ/Q'],...
		'Expr','u[1]*u[4]-u[2]*u[3]',...
		'position',[285,230,450,260])

add_block('built-in/Outport',[sys,'/','smwes/VIPQ/Pgen'])
set_param([sys,'/','smwes/VIPQ/Pgen'],...
		'Port','3',...
		'position',[510,185,530,205])

add_block('built-in/Outport',[sys,'/','smwes/VIPQ/Out_|Vt|'])
set_param([sys,'/','smwes/VIPQ/Out_|Vt|'],...
		'position',[510,80,530,100])

add_block('built-in/Fcn',[sys,'/','smwes/VIPQ/Fcn1'])
set_param([sys,'/','smwes/VIPQ/Fcn1'],...
		'Expr','sqrt(u[2]*u[2] + u[4]*u[4])',...
		'position',[285,125,450,155])

add_block('built-in/Outport',[sys,'/','smwes/VIPQ/Qgen'])
set_param([sys,'/','smwes/VIPQ/Qgen'],...
		'Port','4',...
		'position',[510,235,530,255])

add_block('built-in/Outport',[sys,'/','smwes/VIPQ/Out_|It|'])
set_param([sys,'/','smwes/VIPQ/Out_|It|'],...
		'Port','2',...
		'position',[510,130,530,150])

add_block('built-in/Inport',[sys,'/','smwes/VIPQ/-iqr'])
set_param([sys,'/','smwes/VIPQ/-iqr'],...
		'Port','2',...
		'position',[115,135,135,155])

add_block('built-in/Inport',[sys,'/','smwes/VIPQ/vqr'])
set_param([sys,'/','smwes/VIPQ/vqr'],...
		'position',[115,90,135,110])

add_block('built-in/Inport',[sys,'/','smwes/VIPQ/-idr'])
set_param([sys,'/','smwes/VIPQ/-idr'],...
		'Port','4',...
		'position',[115,225,135,245])
add_line([sys,'/','smwes/VIPQ'],[140,100;175,100])
add_line([sys,'/','smwes/VIPQ'],[140,145;175,145])
add_line([sys,'/','smwes/VIPQ'],[140,190;175,190])
add_line([sys,'/','smwes/VIPQ'],[140,235;175,235])
add_line([sys,'/','smwes/VIPQ'],[215,170;240,170;240,195;280,195])
add_line([sys,'/','smwes/VIPQ'],[455,195;505,195])
add_line([sys,'/','smwes/VIPQ'],[455,245;505,245])
add_line([sys,'/','smwes/VIPQ'],[215,170;240,170;240,245;280,245])
add_line([sys,'/','smwes/VIPQ'],[215,170;240,170;240,90;280,90])
add_line([sys,'/','smwes/VIPQ'],[215,170;240,170;240,140;280,140])
add_line([sys,'/','smwes/VIPQ'],[455,140;505,140])
add_line([sys,'/','smwes/VIPQ'],[455,90;505,90])


%     Finished composite block 'smwes/VIPQ'.

set_param([sys,'/','smwes/VIPQ'],...
		'position',[560,78,595,137])

add_block('built-in/Outport',[sys,'/','smwes/out_Qgen'])
set_param([sys,'/','smwes/out_Qgen'],...
		'Port','2',...
		'position',[680,120,700,140])

add_block('built-in/Outport',[sys,'/','smwes/out_Pgen'])
set_param([sys,'/','smwes/out_Pgen'],...
		'position',[720,105,740,125])

add_block('built-in/Inport',[sys,'/','smwes/in_Ex'])
set_param([sys,'/','smwes/in_Ex'],...
		'Port','3',...
		'position',[350,325,370,345])
add_line([sys,'/','smwes'],[465,215;470,215;470,365;455,365])
add_line([sys,'/','smwes'],[465,290;510,290;510,165;455,165])
add_line([sys,'/','smwes'],[645,265;660,265;660,180;455,180])
add_line([sys,'/','smwes'],[645,265;660,265;660,380;455,380])
add_line([sys,'/','smwes'],[465,215;550,215;550,280;590,280])
add_line([sys,'/','smwes'],[465,230;590,230])
add_line([sys,'/','smwes'],[465,305;590,305])
add_line([sys,'/','smwes'],[465,290;565,290;565,255;590,255])
add_line([sys,'/','smwes'],[430,375;395,375;395,315;420,315])
add_line([sys,'/','smwes'],[645,230;715,230])
add_line([sys,'/','smwes'],[645,300;715,300])
add_line([sys,'/','smwes'],[375,335;420,335])
add_line([sys,'/','smwes'],[645,335;715,335])
add_line([sys,'/','smwes'],[575,330;590,330])
add_line([sys,'/','smwes'],[95,260;125,260])
add_line([sys,'/','smwes'],[95,300;125,300])
add_line([sys,'/','smwes'],[645,230;650,230;650,155;110,155;110,220;125,220])
add_line([sys,'/','smwes'],[355,245;380,245;380,220;420,220])
add_line([sys,'/','smwes'],[160,260;165,260;165,245;180,245])
add_line([sys,'/','smwes'],[355,295;420,295])
add_line([sys,'/','smwes'],[160,260;165,260;165,295;180,295])
add_line([sys,'/','smwes'],[465,230;520,230;520,100;555,100])
add_line([sys,'/','smwes'],[465,305;535,305;535,130;555,130])
add_line([sys,'/','smwes'],[355,245;365,245;365,85;555,85])
add_line([sys,'/','smwes'],[355,295;380,295;380,115;555,115])
add_line([sys,'/','smwes'],[600,115;715,115])
add_line([sys,'/','smwes'],[600,130;675,130])
add_line([sys,'/','smwes'],[430,175;405,175;405,245;420,245])


%     Finished composite block 'smwes'.

set_param([sys,'/','smwes'],...
		'position',[170,58,285,282])

add_block('built-in/Inport',[sys,'/','vde'])
set_param([sys,'/','vde'],...
		'Port','2',...
		'position',[100,135,120,155])

add_block('built-in/Inport',[sys,'/','Ex'])
set_param([sys,'/','Ex'],...
		'Port','3',...
		'position',[100,190,120,210])

add_block('built-in/Inport',[sys,'/','Tmech'])
set_param([sys,'/','Tmech'],...
		'Port','4',...
		'position',[100,245,120,265])

add_block('built-in/Outport',[sys,'/','Pgen'])
set_param([sys,'/','Pgen'],...
		'position',[335,70,355,90])

add_block('built-in/Outport',[sys,'/','Qgen'])
set_param([sys,'/','Qgen'],...
		'Port','2',...
		'position',[335,115,355,135])

add_block('built-in/Outport',[sys,'/','delta'])
set_param([sys,'/','delta'],...
		'Port','3',...
		'position',[335,160,355,180])

add_block('built-in/Outport',[sys,'/','Tem'])
set_param([sys,'/','Tem'],...
		'Port','4',...
		'position',[335,205,355,225])

add_block('built-in/Outport',[sys,'/','(wr-we)//wb'])
set_param([sys,'/','(wr-we)//wb'],...
		'Port','5',...
		'position',[335,250,355,270])
add_line(sys,[125,255;165,255])
add_line(sys,[290,80;330,80])
add_line(sys,[290,125;330,125])
add_line(sys,[290,170;330,170])
add_line(sys,[125,200;165,200])
add_line(sys,[125,90;165,90])
add_line(sys,[125,145;165,145])
add_line(sys,[290,215;330,215])
add_line(sys,[290,260;330,260])

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
