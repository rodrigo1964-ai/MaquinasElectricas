function [ret,x0,str,ts,xts]=s5(t,x,u,flag);
%S5	is the M-file description of the SIMULINK system named S5.
%	The block-diagram can be displayed by typing: S5.
%
%	SYS=S5(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes S5 to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling S5 with a FLAG of zero:
%	[SIZES]=S5([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[12,65,797,493])
     open_system(sys)
end;
set_param(sys,'algorithm',     'Adams/Gear')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     'tstop')
set_param(sys,'Min step size', '1e-4')
set_param(sys,'Max step size', '5e-3')
set_param(sys,'Relative error','5e-6')
set_param(sys,'Return vars',   '')
set_param(sys,'AssignWideVectorLines','on');

add_block('built-in/Note',[sys,'/','vd'])
set_param([sys,'/','vd'],...
		'position',[360,240,365,245])

add_block('built-in/Note',[sys,'/','v0'])
set_param([sys,'/','v0'],...
		'position',[360,275,365,280])

add_block('built-in/Note',[sys,'/','vq'])
set_param([sys,'/','vq'],...
		'position',[365,210,370,215])


%     Subsystem  'abc2qd0'.

new_system([sys,'/','abc2qd0'])
set_param([sys,'/','abc2qd0'],'Location',[454,254,1125,632])

add_block('built-in/Outport',[sys,'/','abc2qd0/vd'])
set_param([sys,'/','abc2qd0/vd'],...
		'Port','2',...
		'position',[590,145,610,165])

add_block('built-in/Fcn',[sys,'/','abc2qd0/abc2q'])
set_param([sys,'/','abc2qd0/abc2q'],...
		'Expr','(2*u[1]- u[2] - u[3])/3',...
		'position',[150,129,290,151])

add_block('built-in/Fcn',[sys,'/','abc2qd0/abc2d'])
set_param([sys,'/','abc2qd0/abc2d'],...
		'Expr','(u[3] -u[2])/sqrt(3)',...
		'position',[150,174,290,196])

add_block('built-in/Inport',[sys,'/','abc2qd0/vc'])
set_param([sys,'/','abc2qd0/vc'],...
		'Port','3',...
		'position',[40,210,60,230])

add_block('built-in/Inport',[sys,'/','abc2qd0/vb'])
set_param([sys,'/','abc2qd0/vb'],...
		'Port','2',...
		'position',[40,175,60,195])

add_block('built-in/Inport',[sys,'/','abc2qd0/va'])
set_param([sys,'/','abc2qd0/va'],...
		'position',[40,140,60,160])

add_block('built-in/Mux',[sys,'/','abc2qd0/Mux'])
set_param([sys,'/','abc2qd0/Mux'],...
		'inputs','3',...
		'position',[90,129,115,241])

add_block('built-in/Note',[sys,'/','abc2qd0/vds'])
set_param([sys,'/','abc2qd0/vds'],...
		'position',[325,150,330,155])

add_block('built-in/Inport',[sys,'/','abc2qd0/cos_thetar'])
set_param([sys,'/','abc2qd0/cos_thetar'],...
		'Port','4',...
		'position',[40,60,60,80])

add_block('built-in/Mux',[sys,'/','abc2qd0/Mux1'])
set_param([sys,'/','abc2qd0/Mux1'],...
		'position',[375,56,400,189])

add_block('built-in/Inport',[sys,'/','abc2qd0/sin_thetar'])
set_param([sys,'/','abc2qd0/sin_thetar'],...
		'Port','5',...
		'position',[40,95,60,115])

add_block('built-in/Note',[sys,'/','abc2qd0/abc2qd0'])
set_param([sys,'/','abc2qd0/abc2qd0'],...
		'position',[205,275,210,280])

add_block('built-in/Note',[sys,'/','abc2qd0/qds2qdr'])
set_param([sys,'/','abc2qd0/qds2qdr'],...
		'position',[470,275,475,280])

add_block('built-in/Fcn',[sys,'/','abc2qd0/qds2dr'])
set_param([sys,'/','abc2qd0/qds2dr'],...
		'Expr','u[2]*u[3] + u[1]*u[4] ',...
		'position',[425,143,560,167])

add_block('built-in/Note',[sys,'/','abc2qd0/vqs'])
set_param([sys,'/','abc2qd0/vqs'],...
		'position',[325,118,330,123])

add_block('built-in/Fcn',[sys,'/','abc2qd0/qds2qr'])
set_param([sys,'/','abc2qd0/qds2qr'],...
		'Expr','u[1]*u[3] - u[2]*u[4]',...
		'position',[425,88,560,112])

add_block('built-in/Outport',[sys,'/','abc2qd0/vq'])
set_param([sys,'/','abc2qd0/vq'],...
		'position',[595,90,615,110])

add_block('built-in/Fcn',[sys,'/','abc2qd0/abc20'])
set_param([sys,'/','abc2qd0/abc20'],...
		'Expr','(u[1] + u[2]  + u[3])/3',...
		'position',[150,219,290,241])

add_block('built-in/Outport',[sys,'/','abc2qd0/vd0'])
set_param([sys,'/','abc2qd0/vd0'],...
		'Port','3',...
		'position',[590,220,610,240])
add_line([sys,'/','abc2qd0'],[120,185;125,185;125,140;145,140])
add_line([sys,'/','abc2qd0'],[120,185;145,185])
add_line([sys,'/','abc2qd0'],[405,125;405,100;420,100])
add_line([sys,'/','abc2qd0'],[405,125;405,155;420,155])
add_line([sys,'/','abc2qd0'],[65,150;85,150])
add_line([sys,'/','abc2qd0'],[65,185;85,185])
add_line([sys,'/','abc2qd0'],[65,220;85,220])
add_line([sys,'/','abc2qd0'],[565,100;590,100])
add_line([sys,'/','abc2qd0'],[565,155;585,155])
add_line([sys,'/','abc2qd0'],[120,185;125,185;125,230;145,230])
add_line([sys,'/','abc2qd0'],[65,70;370,70])
add_line([sys,'/','abc2qd0'],[65,105;370,105])
add_line([sys,'/','abc2qd0'],[295,140;370,140])
add_line([sys,'/','abc2qd0'],[295,185;325,185;325,175;370,175])
add_line([sys,'/','abc2qd0'],[295,230;585,230])


%     Finished composite block 'abc2qd0'.

set_param([sys,'/','abc2qd0'],...
		'Font Number',3,...
		'position',[300,212,340,308])

add_block('built-in/Note',[sys,'/','sin (wrt)'])
set_param([sys,'/','sin (wrt)'],...
		'position',[640,360,645,365])

add_block('built-in/Note',[sys,'/','cos (wrt)'])
set_param([sys,'/','cos (wrt)'],...
		'orientation',3,...
		'position',[610,345,615,350])

add_block('built-in/Note',[sys,'/','ipf'])
set_param([sys,'/','ipf'],...
		'position',[520,305,525,310])

add_block('built-in/Note',[sys,'/','id_gen'])
set_param([sys,'/','id_gen'],...
		'position',[525,285,530,290])

add_block('built-in/Note',[sys,'/','Tem'])
set_param([sys,'/','Tem'],...
		'position',[520,265,525,270])

add_block('built-in/Note',[sys,'/','wr//wb'])
set_param([sys,'/','wr//wb'],...
		'position',[520,245,525,250])

add_block('built-in/Note',[sys,'/','delta'])
set_param([sys,'/','delta'],...
		'position',[515,225,520,230])


%     Subsystem  'osc'.

new_system([sys,'/','osc'])
set_param([sys,'/','osc'],'Location',[508,236,1098,480])

add_block('built-in/Gain',[sys,'/','osc/Gain'])
set_param([sys,'/','osc/Gain'],...
		'Gain','-wb',...
		'position',[135,63,180,97])

add_block('built-in/Product',[sys,'/','osc/Product'])
set_param([sys,'/','osc/Product'],...
		'position',[370,43,390,92])

add_block('built-in/Integrator',[sys,'/','osc/cos'])
set_param([sys,'/','osc/cos'],...
		'Initial','cos(delto)',...
		'position',[215,63,245,97])

add_block('built-in/Inport',[sys,'/','osc/wr//wb'])
set_param([sys,'/','osc/wr//wb'],...
		'position',[30,45,50,65])

add_block('built-in/Integrator',[sys,'/','osc/sin'])
set_param([sys,'/','osc/sin'],...
		'orientation',2,...
		'Initial','sin(delto)',...
		'position',[265,123,295,157])

add_block('built-in/Gain',[sys,'/','osc/Gain1'])
set_param([sys,'/','osc/Gain1'],...
		'orientation',2,...
		'Gain','wb',...
		'position',[340,120,385,160])

add_block('built-in/Product',[sys,'/','osc/Product1'])
set_param([sys,'/','osc/Product1'],...
		'orientation',2,...
		'position',[140,128,160,172])

add_block('built-in/Outport',[sys,'/','osc/cos_thetar'])
set_param([sys,'/','osc/cos_thetar'],...
		'position',[470,105,490,125])

add_block('built-in/Outport',[sys,'/','osc/sin_thetar'])
set_param([sys,'/','osc/sin_thetar'],...
		'Port','2',...
		'position',[470,160,490,180])
add_line([sys,'/','osc'],[260,140;165,140])
add_line([sys,'/','osc'],[250,80;270,80;270,115;465,115])
add_line([sys,'/','osc'],[395,70;415,70;415,140;390,140])
add_line([sys,'/','osc'],[55,55;365,55])
add_line([sys,'/','osc'],[250,80;365,80])
add_line([sys,'/','osc'],[185,80;210,80])
add_line([sys,'/','osc'],[135,150;115,150;115,80;130,80])
add_line([sys,'/','osc'],[335,140;300,140])
add_line([sys,'/','osc'],[55,55;90,55;90,190;200,190;200,160;165,160])
add_line([sys,'/','osc'],[260,140;230,140;230,170;465,170])


%     Finished composite block 'osc'.

set_param([sys,'/','osc'],...
		'orientation',3,...
		'position',[641,215,674,250])


%     Subsystem  'qdr2abc'.

new_system([sys,'/','qdr2abc'])
set_param([sys,'/','qdr2abc'],'Location',[56,346,800,637])

add_block('built-in/Mux',[sys,'/','qdr2abc/Mux'])
set_param([sys,'/','qdr2abc/Mux'],...
		'position',[125,34,155,196])

add_block('built-in/Inport',[sys,'/','qdr2abc/-id'])
set_param([sys,'/','qdr2abc/-id'],...
		'Port','2',...
		'position',[60,165,80,185])

add_block('built-in/Inport',[sys,'/','qdr2abc/-iq'])
set_param([sys,'/','qdr2abc/-iq'],...
		'position',[60,125,80,145])

add_block('built-in/Inport',[sys,'/','qdr2abc/sin_thetar'])
set_param([sys,'/','qdr2abc/sin_thetar'],...
		'Port','5',...
		'position',[60,85,80,105])

add_block('built-in/Inport',[sys,'/','qdr2abc/cos_thetar'])
set_param([sys,'/','qdr2abc/cos_thetar'],...
		'Port','4',...
		'position',[60,45,80,65])

add_block('built-in/Fcn',[sys,'/','qdr2abc/qdr2qs'])
set_param([sys,'/','qdr2abc/qdr2qs'],...
		'Expr','u[1]*u[3] + u[2]*u[4]',...
		'position',[190,64,310,86])

add_block('built-in/Fcn',[sys,'/','qdr2abc/qdr2ds'])
set_param([sys,'/','qdr2abc/qdr2ds'],...
		'Expr','u[1]*u[4] - u[2]*u[3]',...
		'position',[190,140,310,160])

add_block('built-in/Mux',[sys,'/','qdr2abc/Mux1'])
set_param([sys,'/','qdr2abc/Mux1'],...
		'inputs','3',...
		'position',[375,39,405,261])

add_block('built-in/Inport',[sys,'/','qdr2abc/i0'])
set_param([sys,'/','qdr2abc/i0'],...
		'Port','3',...
		'position',[60,215,80,235])

add_block('built-in/Fcn',[sys,'/','qdr2abc/qds2b'])
set_param([sys,'/','qdr2abc/qds2b'],...
		'Expr','-u[1]/2 -sqrt(3)*u[2]/2 + u[3]',...
		'position',[435,139,600,161])

add_block('built-in/Fcn',[sys,'/','qdr2abc/qds2a'])
set_param([sys,'/','qdr2abc/qds2a'],...
		'Expr','u[1] + u[3]',...
		'position',[435,69,605,91])

add_block('built-in/Outport',[sys,'/','qdr2abc/ia'])
set_param([sys,'/','qdr2abc/ia'],...
		'position',[645,69,670,91])

add_block('built-in/Outport',[sys,'/','qdr2abc/ib'])
set_param([sys,'/','qdr2abc/ib'],...
		'Port','2',...
		'position',[645,139,670,161])

add_block('built-in/Note',[sys,'/','qdr2abc/qdr2qds'])
set_param([sys,'/','qdr2abc/qdr2qds'],...
		'position',[255,15,260,20])

add_block('built-in/Note',[sys,'/','qdr2abc/qds2abc'])
set_param([sys,'/','qdr2abc/qds2abc'],...
		'position',[530,20,535,25])

add_block('built-in/Fcn',[sys,'/','qdr2abc/qds2c'])
set_param([sys,'/','qdr2abc/qds2c'],...
		'Expr','-u[1]/2 +sqrt(3)*u[2]/2 + u[3]',...
		'position',[435,209,605,231])

add_block('built-in/Outport',[sys,'/','qdr2abc/ic'])
set_param([sys,'/','qdr2abc/ic'],...
		'Port','3',...
		'position',[645,208,670,232])
add_line([sys,'/','qdr2abc'],[85,55;120,55])
add_line([sys,'/','qdr2abc'],[85,95;120,95])
add_line([sys,'/','qdr2abc'],[85,135;120,135])
add_line([sys,'/','qdr2abc'],[85,175;120,175])
add_line([sys,'/','qdr2abc'],[160,115;165,115;165,75;185,75])
add_line([sys,'/','qdr2abc'],[160,115;165,115;165,150;185,150])
add_line([sys,'/','qdr2abc'],[315,75;370,75])
add_line([sys,'/','qdr2abc'],[315,150;370,150])
add_line([sys,'/','qdr2abc'],[85,225;370,225])
add_line([sys,'/','qdr2abc'],[410,150;430,150])
add_line([sys,'/','qdr2abc'],[410,150;420,150;430,80])
add_line([sys,'/','qdr2abc'],[610,80;640,80])
add_line([sys,'/','qdr2abc'],[605,150;640,150])
add_line([sys,'/','qdr2abc'],[410,150;420,150;430,220])
add_line([sys,'/','qdr2abc'],[610,220;640,220])


%     Finished composite block 'qdr2abc'.

set_param([sys,'/','qdr2abc'],...
		'orientation',3,...
		'Font Number',3,...
		'position',[597,130,673,160])


%     Subsystem  'qd_gen'.

new_system([sys,'/','qd_gen'])
set_param([sys,'/','qd_gen'],'Location',[165,178,780,654])

add_block('built-in/Outport',[sys,'/','qd_gen/iq_gen'])
set_param([sys,'/','qd_gen/iq_gen'],...
		'position',[340,80,360,100])

add_block('built-in/Inport',[sys,'/','qd_gen/vq'])
set_param([sys,'/','qd_gen/vq'],...
		'position',[60,65,80,85])

add_block('built-in/Product',[sys,'/','qd_gen/prod1'])
set_param([sys,'/','qd_gen/prod1'],...
		'orientation',2,...
		'Font Number',3,...
		'position',[165,148,185,172])

add_block('built-in/Product',[sys,'/','qd_gen/prod2'])
set_param([sys,'/','qd_gen/prod2'],...
		'orientation',2,...
		'Font Number',3,...
		'position',[165,193,185,222])


%     Subsystem  'qd_gen/d_cct'.

new_system([sys,'/','qd_gen/d_cct'])
set_param([sys,'/','qd_gen/d_cct'],'Location',[147,197,1082,712])

add_block('built-in/Inport',[sys,'/','qd_gen/d_cct/In_vd'])
set_param([sys,'/','qd_gen/d_cct/In_vd'],...
		'position',[50,105,70,125])

add_block('built-in/Mux',[sys,'/','qd_gen/d_cct/Mux3'])
set_param([sys,'/','qd_gen/d_cct/Mux3'],...
		'position',[465,122,490,208])

add_block('built-in/Fcn',[sys,'/','qd_gen/d_cct/Fcn6'])
set_param([sys,'/','qd_gen/d_cct/Fcn6'],...
		'Expr','-wb*rpkd2*u[1]',...
		'position',[155,330,260,360])

add_block('built-in/Outport',[sys,'/','qd_gen/d_cct/Out_ipf'])
set_param([sys,'/','qd_gen/d_cct/Out_ipf'],...
		'Port','4',...
		'position',[810,360,830,380])

add_block('built-in/Demux',[sys,'/','qd_gen/d_cct/Demux'])
set_param([sys,'/','qd_gen/d_cct/Demux'],...
		'outputs','3',...
		'position',[650,298,690,382])

add_block('built-in/Mux',[sys,'/','qd_gen/d_cct/Mux4'])
set_param([sys,'/','qd_gen/d_cct/Mux4'],...
		'inputs','3',...
		'position',[535,295,560,385])

add_block('built-in/Sum',[sys,'/','qd_gen/d_cct/Sum1'])
set_param([sys,'/','qd_gen/d_cct/Sum1'],...
		'inputs','-+',...
		'position',[450,323,465,352])

add_block('built-in/Sum',[sys,'/','qd_gen/d_cct/Sum2'])
set_param([sys,'/','qd_gen/d_cct/Sum2'],...
		'inputs','-+',...
		'position',[450,378,465,407])

add_block('built-in/Sum',[sys,'/','qd_gen/d_cct/Sum'])
set_param([sys,'/','qd_gen/d_cct/Sum'],...
		'inputs','-+',...
		'position',[450,263,465,292])

add_block('built-in/Mux',[sys,'/','qd_gen/d_cct/Mux'])
set_param([sys,'/','qd_gen/d_cct/Mux'],...
		'position',[135,91,160,179])

add_block('built-in/Fcn',[sys,'/','qd_gen/d_cct/Fcn'])
set_param([sys,'/','qd_gen/d_cct/Fcn'],...
		'Expr','wb*(u[2]+u[3]+(rs/xls)*(u[1]-u[4]))',...
		'position',[180,120,375,150])

add_block('built-in/Inport',[sys,'/','qd_gen/d_cct/In_wrpsiq'])
set_param([sys,'/','qd_gen/d_cct/In_wrpsiq'],...
		'Port','2',...
		'position',[50,150,70,170])

add_block('built-in/Fcn',[sys,'/','qd_gen/d_cct/Fcn2'])
set_param([sys,'/','qd_gen/d_cct/Fcn2'],...
		'Expr','-wb*rpkd3*u[1]',...
		'position',[150,270,260,300])

add_block('built-in/Integrator',[sys,'/','qd_gen/d_cct/psid'])
set_param([sys,'/','qd_gen/d_cct/psid'],...
		'Initial','Psido',...
		'position',[395,122,425,148])

add_block('built-in/Fcn',[sys,'/','qd_gen/d_cct/Fcn3'])
set_param([sys,'/','qd_gen/d_cct/Fcn3'],...
		'Expr','xMD*(u[1]/xls+u[2]*b1col+u[3]*b2col+u[4]*b3col)',...
		'position',[515,150,790,180])

add_block('built-in/Outport',[sys,'/','qd_gen/d_cct/Out_psid'])
set_param([sys,'/','qd_gen/d_cct/Out_psid'],...
		'position',[460,70,480,90])

add_block('built-in/Mux',[sys,'/','qd_gen/d_cct/Mux2'])
set_param([sys,'/','qd_gen/d_cct/Mux2'],...
		'inputs','2',...
		'position',[555,71,580,129])

add_block('built-in/Outport',[sys,'/','qd_gen/d_cct/Out_-id'])
set_param([sys,'/','qd_gen/d_cct/Out_-id'],...
		'Port','2',...
		'position',[735,90,755,110])

add_block('built-in/Fcn',[sys,'/','qd_gen/d_cct/Fcn5'])
set_param([sys,'/','qd_gen/d_cct/Fcn5'],...
		'Expr','(u[1]-u[2])/xls',...
		'position',[610,86,695,114])

add_block('built-in/Outport',[sys,'/','qd_gen/d_cct/Out_psimd'])
set_param([sys,'/','qd_gen/d_cct/Out_psimd'],...
		'Port','3',...
		'position',[830,155,850,175])

add_block('built-in/Integrator',[sys,'/','qd_gen/d_cct/psipkd3'])
set_param([sys,'/','qd_gen/d_cct/psipkd3'],...
		'Initial','Psikd3o',...
		'position',[315,272,345,298])

add_block('built-in/Integrator',[sys,'/','qd_gen/d_cct/psipkd2'])
set_param([sys,'/','qd_gen/d_cct/psipkd2'],...
		'Initial','Psikd2o',...
		'position',[315,332,345,358])

add_block('built-in/Inport',[sys,'/','qd_gen/d_cct/In_Ef'])
set_param([sys,'/','qd_gen/d_cct/In_Ef'],...
		'Port','3',...
		'position',[65,375,85,395])

add_block('built-in/Mux',[sys,'/','qd_gen/d_cct/Mux1'])
set_param([sys,'/','qd_gen/d_cct/Mux1'],...
		'inputs','2',...
		'position',[135,370,160,430])

add_block('built-in/Fcn',[sys,'/','qd_gen/d_cct/Fcn1'])
set_param([sys,'/','qd_gen/d_cct/Fcn1'],...
		'Expr','wb*rpf*(u[1]/xmd-u[2])',...
		'position',[180,385,320,415])

add_block('built-in/Integrator',[sys,'/','qd_gen/d_cct/psipf'])
set_param([sys,'/','qd_gen/d_cct/psipf'],...
		'Initial','Psifo',...
		'position',[350,387,380,413])

add_block('built-in/State-Space',[sys,'/',['qd_gen/d_cct/Matrix',13,'Gain B']])
set_param([sys,'/',['qd_gen/d_cct/Matrix',13,'Gain B']],...
		'A','[]',...
		'B','[]',...
		'C','[]',...
		'D','K',...
		'Mask Display','K',...
		'Mask Type','Matrix Gain',...
		'Mask Dialogue','Matrix Gain.|Gain matrix:')
set_param([sys,'/',['qd_gen/d_cct/Matrix',13,'Gain B']],...
		'Mask Translate','K = @1;',...
		'Mask Help','Multiplies input vector by entered matrix to produce output vector (y=Au).',...
		'Mask Entries','B\/',...
		'position',[585,326,630,354])
add_line([sys,'/','qd_gen/d_cct'],[75,160;95,160;95,145;130,145])
add_line([sys,'/','qd_gen/d_cct'],[75,115;95,115;95,125;130,125])
add_line([sys,'/','qd_gen/d_cct'],[165,135;175,135])
add_line([sys,'/','qd_gen/d_cct'],[380,135;390,135])
add_line([sys,'/','qd_gen/d_cct'],[430,135;435,135;435,215;115,215;115,165;130,165])
add_line([sys,'/','qd_gen/d_cct'],[165,400;175,400])
add_line([sys,'/','qd_gen/d_cct'],[325,400;345,400])
add_line([sys,'/','qd_gen/d_cct'],[265,285;310,285])
add_line([sys,'/','qd_gen/d_cct'],[430,135;460,135])
add_line([sys,'/','qd_gen/d_cct'],[495,165;510,165])
add_line([sys,'/','qd_gen/d_cct'],[565,340;580,340])
add_line([sys,'/','qd_gen/d_cct'],[795,165;800,165;800,60;115,60;115,105;130,105])
add_line([sys,'/','qd_gen/d_cct'],[795,165;825,165])
add_line([sys,'/','qd_gen/d_cct'],[430,135;435,135;435,80;455,80])
add_line([sys,'/','qd_gen/d_cct'],[265,345;310,345])
add_line([sys,'/','qd_gen/d_cct'],[90,385;130,385])
add_line([sys,'/','qd_gen/d_cct'],[350,285;380,285;380,155;460,155])
add_line([sys,'/','qd_gen/d_cct'],[350,345;390,345;390,175;460,175])
add_line([sys,'/','qd_gen/d_cct'],[385,400;400,400;400,195;460,195])
add_line([sys,'/','qd_gen/d_cct'],[350,285;445,285])
add_line([sys,'/','qd_gen/d_cct'],[385,400;445,400])
add_line([sys,'/','qd_gen/d_cct'],[350,345;445,345])
add_line([sys,'/','qd_gen/d_cct'],[470,280;490,280;490,310;530,310])
add_line([sys,'/','qd_gen/d_cct'],[470,340;530,340])
add_line([sys,'/','qd_gen/d_cct'],[470,395;485,395;485,370;530,370])
add_line([sys,'/','qd_gen/d_cct'],[795,165;800,165;800,230;420,230;420,270;445,270])
add_line([sys,'/','qd_gen/d_cct'],[795,165;800,165;800,230;420,230;420,330;445,330])
add_line([sys,'/','qd_gen/d_cct'],[795,165;800,165;800,230;420,230;420,385;445,385])
add_line([sys,'/','qd_gen/d_cct'],[695,310;705,310;705,250;120,250;120,285;145,285])
add_line([sys,'/','qd_gen/d_cct'],[695,340;725,340;725,245;110,245;110,345;150,345])
add_line([sys,'/','qd_gen/d_cct'],[695,370;705,370;705,445;115,445;115,415;130,415])
add_line([sys,'/','qd_gen/d_cct'],[695,370;805,370])
add_line([sys,'/','qd_gen/d_cct'],[430,135;435,135;435,115;550,115])
add_line([sys,'/','qd_gen/d_cct'],[795,165;800,165;800,60;520,60;520,85;550,85])
add_line([sys,'/','qd_gen/d_cct'],[585,100;605,100])
add_line([sys,'/','qd_gen/d_cct'],[700,100;730,100])
add_line([sys,'/','qd_gen/d_cct'],[635,340;645,340])


%     Finished composite block 'qd_gen/d_cct'.

set_param([sys,'/','qd_gen/d_cct'],...
		'position',[150,253,190,327])

add_block('built-in/Inport',[sys,'/','qd_gen/Ef'])
set_param([sys,'/','qd_gen/Ef'],...
		'Port','3',...
		'position',[55,305,75,325])

add_block('built-in/Inport',[sys,'/','qd_gen/vd'])
set_param([sys,'/','qd_gen/vd'],...
		'Port','2',...
		'position',[55,255,75,275])


%     Subsystem  'qd_gen/Rotor'.

new_system([sys,'/','qd_gen/Rotor'])
set_param([sys,'/','qd_gen/Rotor'],'Location',[229,141,898,406])

add_block('built-in/Outport',[sys,'/','qd_gen/Rotor/wr//wb '])
set_param([sys,'/','qd_gen/Rotor/wr//wb '],...
		'Port','2',...
		'position',[595,180,615,200])

add_block('built-in/Sum',[sys,'/','qd_gen/Rotor/Sum14'])
set_param([sys,'/','qd_gen/Rotor/Sum14'],...
		'position',[495,168,510,212])

add_block('built-in/Constant',[sys,'/','qd_gen/Rotor/we//wb'])
set_param([sys,'/','qd_gen/Rotor/we//wb'],...
		'position',[420,188,450,212])

add_block('built-in/Outport',[sys,'/','qd_gen/Rotor/Tem'])
set_param([sys,'/','qd_gen/Rotor/Tem'],...
		'Port','3',...
		'position',[275,188,300,212])

add_block('built-in/Inport',[sys,'/','qd_gen/Rotor/-id'])
set_param([sys,'/','qd_gen/Rotor/-id'],...
		'Port','4',...
		'position',[85,200,105,220])

add_block('built-in/Inport',[sys,'/','qd_gen/Rotor/-iq'])
set_param([sys,'/','qd_gen/Rotor/-iq'],...
		'position',[85,85,105,105])

add_block('built-in/Inport',[sys,'/','qd_gen/Rotor/Tmech'])
set_param([sys,'/','qd_gen/Rotor/Tmech'],...
		'Port','5',...
		'position',[85,45,105,65])

add_block('built-in/Integrator',[sys,'/','qd_gen/Rotor/slip'])
set_param([sys,'/','qd_gen/Rotor/slip'],...
		'position',[410,111,440,149])

add_block('built-in/Integrator',[sys,'/','qd_gen/Rotor/del'])
set_param([sys,'/','qd_gen/Rotor/del'],...
		'Initial','delto',...
		'position',[535,111,565,149])

add_block('built-in/Outport',[sys,'/','qd_gen/Rotor/(wr-we)//wb'])
set_param([sys,'/','qd_gen/Rotor/(wr-we)//wb'],...
		'Port','4',...
		'position',[590,65,610,85])

add_block('built-in/Note',[sys,'/','qd_gen/Rotor/Tem_'])
set_param([sys,'/','qd_gen/Rotor/Tem_'],...
		'position',[225,130,230,135])

add_block('built-in/Product',[sys,'/','qd_gen/Rotor/Prod'])
set_param([sys,'/','qd_gen/Rotor/Prod'],...
		'position',[145,114,160,136])

add_block('built-in/Inport',[sys,'/','qd_gen/Rotor/psiq'])
set_param([sys,'/','qd_gen/Rotor/psiq'],...
		'Port','3',...
		'position',[85,160,105,180])

add_block('built-in/Product',[sys,'/','qd_gen/Rotor/Prod2'])
set_param([sys,'/','qd_gen/Rotor/Prod2'],...
		'position',[145,165,160,185])

add_block('built-in/Sum',[sys,'/','qd_gen/Rotor/Sum12'])
set_param([sys,'/','qd_gen/Rotor/Sum12'],...
		'inputs','-+',...
		'position',[185,101,205,199])

add_block('built-in/Inport',[sys,'/','qd_gen/Rotor/psid '])
set_param([sys,'/','qd_gen/Rotor/psid '],...
		'Port','2',...
		'position',[85,120,105,140])

add_block('built-in/Gain',[sys,'/','qd_gen/Rotor/D'])
set_param([sys,'/','qd_gen/Rotor/D'],...
		'orientation',2,...
		'Gain','Domega',...
		'position',[320,58,395,92])

add_block('built-in/Sum',[sys,'/','qd_gen/Rotor/Tacc'])
set_param([sys,'/','qd_gen/Rotor/Tacc'],...
		'inputs','-++',...
		'position',[275,100,295,160])

add_block('built-in/Outport',[sys,'/','qd_gen/Rotor/delta'])
set_param([sys,'/','qd_gen/Rotor/delta'],...
		'position',[595,120,615,140])

add_block('built-in/Gain',[sys,'/','qd_gen/Rotor/gain4'])
set_param([sys,'/','qd_gen/Rotor/gain4'],...
		'Gain','wb',...
		'position',[480,114,515,146])

add_block('built-in/Gain',[sys,'/','qd_gen/Rotor/1//2H'])
set_param([sys,'/','qd_gen/Rotor/1//2H'],...
		'Gain','1/(2*H)',...
		'position',[315,110,385,150])
add_line([sys,'/','qd_gen/Rotor'],[315,75;255,75;255,110;270,110])
add_line([sys,'/','qd_gen/Rotor'],[210,150;270,150])
add_line([sys,'/','qd_gen/Rotor'],[445,130;475,130])
add_line([sys,'/','qd_gen/Rotor'],[520,130;530,130])
add_line([sys,'/','qd_gen/Rotor'],[165,175;180,175])
add_line([sys,'/','qd_gen/Rotor'],[390,130;405,130])
add_line([sys,'/','qd_gen/Rotor'],[455,200;490,200])
add_line([sys,'/','qd_gen/Rotor'],[300,130;310,130])
add_line([sys,'/','qd_gen/Rotor'],[165,125;180,125])
add_line([sys,'/','qd_gen/Rotor'],[110,95;120,95;120,120;140,120])
add_line([sys,'/','qd_gen/Rotor'],[110,130;140,130])
add_line([sys,'/','qd_gen/Rotor'],[570,130;590,130])
add_line([sys,'/','qd_gen/Rotor'],[110,170;140,170])
add_line([sys,'/','qd_gen/Rotor'],[110,210;120,210;120,180;140,180])
add_line([sys,'/','qd_gen/Rotor'],[515,190;590,190])
add_line([sys,'/','qd_gen/Rotor'],[210,150;245,150;245,200;270,200])
add_line([sys,'/','qd_gen/Rotor'],[445,130;460,130;460,180;490,180])
add_line([sys,'/','qd_gen/Rotor'],[445,130;460,130;460,75;585,75])
add_line([sys,'/','qd_gen/Rotor'],[445,130;460,130;460,75;400,75])
add_line([sys,'/','qd_gen/Rotor'],[110,55;240,55;240,130;270,130])


%     Finished composite block 'qd_gen/Rotor'.

set_param([sys,'/','qd_gen/Rotor'],...
		'Font Number',3,...
		'position',[345,230,395,330])

add_block('built-in/Outport',[sys,'/','qd_gen/delta'])
set_param([sys,'/','qd_gen/delta'],...
		'Port','2',...
		'position',[450,235,470,255])

add_block('built-in/Outport',[sys,'/','qd_gen/wr//wb'])
set_param([sys,'/','qd_gen/wr//wb'],...
		'Port','3',...
		'position',[500,260,520,280])

add_block('built-in/Outport',[sys,'/','qd_gen/Tem'])
set_param([sys,'/','qd_gen/Tem'],...
		'Port','4',...
		'position',[455,285,475,305])

add_block('built-in/Inport',[sys,'/','qd_gen/Tmech'])
set_param([sys,'/','qd_gen/Tmech'],...
		'Port','4',...
		'position',[295,310,315,330])


%     Subsystem  'qd_gen/q_cct'.

new_system([sys,'/','qd_gen/q_cct'])
set_param([sys,'/','qd_gen/q_cct'],'Location',[171,148,1057,642])

add_block('built-in/Integrator',[sys,'/','qd_gen/q_cct/psiq'])
set_param([sys,'/','qd_gen/q_cct/psiq'],...
		'Initial','Psiqo',...
		'position',[390,127,420,153])

add_block('built-in/Fcn',[sys,'/','qd_gen/q_cct/Fcn'])
set_param([sys,'/','qd_gen/q_cct/Fcn'],...
		'Expr','wb*(u[2]-u[3]+(rs/xls)*(u[1]-u[4]))',...
		'position',[180,125,375,155])

add_block('built-in/Inport',[sys,'/','qd_gen/q_cct/In_wrpsid'])
set_param([sys,'/','qd_gen/q_cct/In_wrpsid'],...
		'Port','2',...
		'position',[50,160,70,180])

add_block('built-in/Inport',[sys,'/','qd_gen/q_cct/In_vq'])
set_param([sys,'/','qd_gen/q_cct/In_vq'],...
		'position',[50,105,70,125])

add_block('built-in/Mux',[sys,'/','qd_gen/q_cct/Mux'])
set_param([sys,'/','qd_gen/q_cct/Mux'],...
		'position',[135,86,160,189])

add_block('built-in/Mux',[sys,'/','qd_gen/q_cct/Mux3'])
set_param([sys,'/','qd_gen/q_cct/Mux3'],...
		'position',[515,128,540,197])

add_block('built-in/Mux',[sys,'/','qd_gen/q_cct/Mux4'])
set_param([sys,'/','qd_gen/q_cct/Mux4'],...
		'inputs','2',...
		'position',[515,214,540,281])

add_block('built-in/Fcn',[sys,'/','qd_gen/q_cct/Fcn4'])
set_param([sys,'/','qd_gen/q_cct/Fcn4'],...
		'Expr','-(u[1]-u[2])/xls',...
		'position',[575,237,665,263])

add_block('built-in/Mux',[sys,'/','qd_gen/q_cct/Mux2'])
set_param([sys,'/','qd_gen/q_cct/Mux2'],...
		'inputs','2',...
		'position',[130,220,155,275])

add_block('built-in/Outport',[sys,'/','qd_gen/q_cct/Out_-iq'])
set_param([sys,'/','qd_gen/q_cct/Out_-iq'],...
		'Port','2',...
		'position',[790,240,810,260])

add_block('built-in/Fcn',[sys,'/','qd_gen/q_cct/Fcn3'])
set_param([sys,'/','qd_gen/q_cct/Fcn3'],...
		'Expr','xMQ*(u[1]/xls+u[2]/xplkq3+u[3]/xplkq2+u[4]/xplkq1)',...
		'position',[565,151,720,179])

add_block('built-in/Outport',[sys,'/','qd_gen/q_cct/Out_psimq'])
set_param([sys,'/','qd_gen/q_cct/Out_psimq'],...
		'Port','3',...
		'position',[790,155,810,175])

add_block('built-in/Fcn',[sys,'/','qd_gen/q_cct/Fcn2'])
set_param([sys,'/','qd_gen/q_cct/Fcn2'],...
		'Expr','wb*rpkq3*(u[1]-u[2])/xplkq3',...
		'position',[180,236,365,264])

add_block('built-in/Integrator',[sys,'/','qd_gen/q_cct/psipkq3'])
set_param([sys,'/','qd_gen/q_cct/psipkq3'],...
		'Initial','Psikq3o',...
		'position',[390,237,420,263])

add_block('built-in/Integrator',[sys,'/','qd_gen/q_cct/psipkq2'])
set_param([sys,'/','qd_gen/q_cct/psipkq2'],...
		'Initial','Psikq2o',...
		'position',[390,332,420,358])

add_block('built-in/Fcn',[sys,'/','qd_gen/q_cct/Fcn5'])
set_param([sys,'/','qd_gen/q_cct/Fcn5'],...
		'Expr','wb*rpkq2*(u[1]-u[2])/xplkq2',...
		'position',[180,331,365,359])

add_block('built-in/Mux',[sys,'/','qd_gen/q_cct/Mux5'])
set_param([sys,'/','qd_gen/q_cct/Mux5'],...
		'inputs','2',...
		'position',[130,315,155,370])

add_block('built-in/Mux',[sys,'/','qd_gen/q_cct/Mux6'])
set_param([sys,'/','qd_gen/q_cct/Mux6'],...
		'inputs','2',...
		'position',[130,396,155,454])

add_block('built-in/Fcn',[sys,'/','qd_gen/q_cct/Fcn6'])
set_param([sys,'/','qd_gen/q_cct/Fcn6'],...
		'Expr','wb*rpkq1*(u[1]-u[2])/xplkq1',...
		'position',[180,411,365,439])

add_block('built-in/Integrator',[sys,'/','qd_gen/q_cct/psipkq1'])
set_param([sys,'/','qd_gen/q_cct/psipkq1'],...
		'Initial','Psikq1o',...
		'position',[390,412,420,438])

add_block('built-in/Outport',[sys,'/','qd_gen/q_cct/Out_psiq'])
set_param([sys,'/','qd_gen/q_cct/Out_psiq'],...
		'position',[575,95,595,115])
add_line([sys,'/','qd_gen/q_cct'],[75,170;95,170;95,150;130,150])
add_line([sys,'/','qd_gen/q_cct'],[75,115;95,115;95,125;130,125])
add_line([sys,'/','qd_gen/q_cct'],[165,140;175,140])
add_line([sys,'/','qd_gen/q_cct'],[380,140;385,140])
add_line([sys,'/','qd_gen/q_cct'],[425,140;435,140;435,205;115,205;115,175;130,175])
add_line([sys,'/','qd_gen/q_cct'],[160,250;175,250])
add_line([sys,'/','qd_gen/q_cct'],[370,250;385,250])
add_line([sys,'/','qd_gen/q_cct'],[425,250;460,250;460,290;110,290;110,260;125,260])
add_line([sys,'/','qd_gen/q_cct'],[425,140;510,140])
add_line([sys,'/','qd_gen/q_cct'],[545,165;560,165])
add_line([sys,'/','qd_gen/q_cct'],[545,250;570,250])
add_line([sys,'/','qd_gen/q_cct'],[425,140;450,140;450,230;510,230])
add_line([sys,'/','qd_gen/q_cct'],[725,165;745,165;745,305;495,305;495,265;510,265])
add_line([sys,'/','qd_gen/q_cct'],[725,165;745,165;745,305;90,305;90,235;125,235])
add_line([sys,'/','qd_gen/q_cct'],[725,165;745,165;745,80;115,80;115,100;130,100])
add_line([sys,'/','qd_gen/q_cct'],[725,165;785,165])
add_line([sys,'/','qd_gen/q_cct'],[670,250;785,250])
add_line([sys,'/','qd_gen/q_cct'],[425,140;435,140;435,105;570,105])
add_line([sys,'/','qd_gen/q_cct'],[425,250;460,250;460,155;510,155])
add_line([sys,'/','qd_gen/q_cct'],[160,345;175,345])
add_line([sys,'/','qd_gen/q_cct'],[370,345;385,345])
add_line([sys,'/','qd_gen/q_cct'],[425,345;470,345;470,385;110,385;110,355;125,355])
add_line([sys,'/','qd_gen/q_cct'],[425,345;470,345;470,170;510,170])
add_line([sys,'/','qd_gen/q_cct'],[725,165;745,165;745,305;90,305;90,330;125,330])
add_line([sys,'/','qd_gen/q_cct'],[160,425;175,425])
add_line([sys,'/','qd_gen/q_cct'],[370,425;385,425])
add_line([sys,'/','qd_gen/q_cct'],[425,425;479,425;479,470;109,470;109,440;125,440])
add_line([sys,'/','qd_gen/q_cct'],[725,165;745,165;745,305;90,305;90,410;125,410])
add_line([sys,'/','qd_gen/q_cct'],[425,425;480,425;480,185;510,185])


%     Finished composite block 'qd_gen/q_cct'.

set_param([sys,'/','qd_gen/q_cct'],...
		'position',[155,53,195,127])

add_block('built-in/Note',[sys,'/','qd_gen/-iq'])
set_param([sys,'/','qd_gen/-iq'],...
		'position',[215,70,220,75])

add_block('built-in/Note',[sys,'/','qd_gen/-id'])
set_param([sys,'/','qd_gen/-id'],...
		'position',[210,260,215,265])

add_block('built-in/Note',[sys,'/','qd_gen/psid'])
set_param([sys,'/','qd_gen/psid'],...
		'position',[210,240,215,245])

add_block('built-in/Note',[sys,'/','qd_gen/psiq'])
set_param([sys,'/','qd_gen/psiq'],...
		'position',[215,45,220,50])

add_block('built-in/Outport',[sys,'/','qd_gen/id_gen'])
set_param([sys,'/','qd_gen/id_gen'],...
		'Port','5',...
		'position',[240,310,260,330])

add_block('built-in/Outport',[sys,'/','qd_gen/ipf'])
set_param([sys,'/','qd_gen/ipf'],...
		'orientation',1,...
		'Port','6',...
		'position',[195,350,215,370])
add_line([sys,'/','qd_gen'],[320,320;340,320])
add_line([sys,'/','qd_gen'],[195,260;340,260])
add_line([sys,'/','qd_gen'],[195,280;220,280;220,300;340,300])
add_line([sys,'/','qd_gen'],[200,90;290,90;290,240;340,240])
add_line([sys,'/','qd_gen'],[200,65;255,65;255,280;340,280])
add_line([sys,'/','qd_gen'],[200,90;335,90])
add_line([sys,'/','qd_gen'],[400,245;445,245])
add_line([sys,'/','qd_gen'],[400,270;495,270])
add_line([sys,'/','qd_gen'],[400,295;450,295])
add_line([sys,'/','qd_gen'],[195,280;220,280;220,320;235,320])
add_line([sys,'/','qd_gen'],[160,160;120,160;120,110;150,110])
add_line([sys,'/','qd_gen'],[85,75;150,75])
add_line([sys,'/','qd_gen'],[195,260;235,260;235,165;190,165])
add_line([sys,'/','qd_gen'],[400,270;415,270;415,155;190,155])
add_line([sys,'/','qd_gen'],[200,65;255,65;255,215;190,215])
add_line([sys,'/','qd_gen'],[400,270;415,270;415,200;190,200])
add_line([sys,'/','qd_gen'],[80,315;145,315])
add_line([sys,'/','qd_gen'],[80,265;145,265])
add_line([sys,'/','qd_gen'],[160,210;120,210;120,290;145,290])
add_line([sys,'/','qd_gen'],[195,320;205,320;205,345])


%     Finished composite block 'qd_gen'.

set_param([sys,'/','qd_gen'],...
		'position',[445,211,500,339])

add_block('built-in/Scope',[sys,'/','sm1'])
set_param([sys,'/','sm1'],...
		'orientation',2,...
		'Vgain','4.000000',...
		'Hgain','1.500000',...
		'Vmax','8.000000',...
		'Hmax','3.000000',...
		'Window',[28,492,825,650])
open_system([sys,'/','sm1'])
set_param([sys,'/','sm1'],...
		'position',[380,28,405,52])

add_block('built-in/To Workspace',[sys,'/','Workspace'])
set_param([sys,'/','Workspace'],...
		'mat-name','y',...
		'buffer','100000',...
		'position',[540,30,560,50])

add_block('built-in/Mux',[sys,'/','Mux'])
set_param([sys,'/','Mux'],...
		'orientation',3,...
		'inputs','9',...
		'position',[250,65,660,85])


%     Subsystem  'VIPQ'.

new_system([sys,'/','VIPQ'])
set_param([sys,'/','VIPQ'],'Location',[284,425,995,813])

add_block('built-in/Mux',[sys,'/','VIPQ/Mux'])
set_param([sys,'/','VIPQ/Mux'],...
		'position',[185,86,215,269])

add_block('built-in/Inport',[sys,'/','VIPQ/vq'])
set_param([sys,'/','VIPQ/vq'],...
		'position',[115,100,135,120])

add_block('built-in/Inport',[sys,'/','VIPQ/iq_gen'])
set_param([sys,'/','VIPQ/iq_gen'],...
		'Port','2',...
		'position',[115,145,135,165])

add_block('built-in/Inport',[sys,'/','VIPQ/vd'])
set_param([sys,'/','VIPQ/vd'],...
		'Port','3',...
		'position',[115,190,135,210])

add_block('built-in/Inport',[sys,'/','VIPQ/id_gen'])
set_param([sys,'/','VIPQ/id_gen'],...
		'Port','4',...
		'position',[115,235,135,255])

add_block('built-in/Fcn',[sys,'/','VIPQ/Q'])
set_param([sys,'/','VIPQ/Q'],...
		'Expr','u[1]*u[4]-u[2]*u[3]',...
		'position',[270,248,445,272])

add_block('built-in/Outport',[sys,'/','VIPQ/Qgen'])
set_param([sys,'/','VIPQ/Qgen'],...
		'Port','4',...
		'position',[480,250,500,270])

add_block('built-in/Fcn',[sys,'/','VIPQ/P'])
set_param([sys,'/','VIPQ/P'],...
		'Expr','u[1]*u[2] + u[3]*u[4]',...
		'position',[265,198,445,222])

add_block('built-in/Outport',[sys,'/','VIPQ/Pgen'])
set_param([sys,'/','VIPQ/Pgen'],...
		'Port','3',...
		'position',[480,200,500,220])

add_block('built-in/Outport',[sys,'/','VIPQ/|Vt|'])
set_param([sys,'/','VIPQ/|Vt|'],...
		'position',[480,90,500,110])

add_block('built-in/Fcn',[sys,'/','VIPQ/P1'])
set_param([sys,'/','VIPQ/P1'],...
		'Expr','sqrt(u[1]*u[1] + u[3]*u[3])',...
		'position',[265,88,445,112])

add_block('built-in/Fcn',[sys,'/','VIPQ/P2'])
set_param([sys,'/','VIPQ/P2'],...
		'Expr','sqrt(u[2]*u[2] + u[4]*u[4])',...
		'position',[265,143,445,167])

add_block('built-in/Outport',[sys,'/','VIPQ/|It|'])
set_param([sys,'/','VIPQ/|It|'],...
		'Port','2',...
		'position',[480,145,500,165])
add_line([sys,'/','VIPQ'],[140,110;180,110])
add_line([sys,'/','VIPQ'],[140,155;180,155])
add_line([sys,'/','VIPQ'],[140,200;180,200])
add_line([sys,'/','VIPQ'],[140,245;180,245])
add_line([sys,'/','VIPQ'],[220,180;240,180;240,210;260,210])
add_line([sys,'/','VIPQ'],[450,210;475,210])
add_line([sys,'/','VIPQ'],[450,260;475,260])
add_line([sys,'/','VIPQ'],[220,180;240,180;240,260;265,260])
add_line([sys,'/','VIPQ'],[450,100;475,100])
add_line([sys,'/','VIPQ'],[450,155;475,155])
add_line([sys,'/','VIPQ'],[220,180;240,180;240,100;260,100])
add_line([sys,'/','VIPQ'],[220,180;240,180;240,155;260,155])


%     Finished composite block 'VIPQ'.

set_param([sys,'/','VIPQ'],...
		'orientation',3,...
		'position',[333,130,457,160])

add_block('built-in/Note',[sys,'/','iq_gen'])
set_param([sys,'/','iq_gen'],...
		'position',[490,180,495,185])


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
		'position',[365,310,390,330])


%     Subsystem  'Ef'.

new_system([sys,'/','Ef'])
set_param([sys,'/','Ef'],'Location',[5,40,315,196])

add_block('built-in/Outport',[sys,'/','Ef/out_1'])
set_param([sys,'/','Ef/out_1'],...
		'position',[285,60,305,80])

add_block('built-in/Look Up Table',[sys,'/','Ef/Look-Up Table'])
set_param([sys,'/','Ef/Look-Up Table'],...
		'Input_Values','t',...
		'Output_Values','y',...
		'position',[210,58,250,82])

add_block('built-in/Fcn',[sys,'/','Ef/Fcn1'])
set_param([sys,'/','Ef/Fcn1'],...
		'Expr','rem(u[1],period)',...
		'position',[110,60,150,80])

add_block('built-in/Clock',[sys,'/','Ef/Clock'])
set_param([sys,'/','Ef/Clock'],...
		'position',[45,60,65,80])
add_line([sys,'/','Ef'],[255,70;280,70])
add_line([sys,'/','Ef'],[70,70;105,70])
add_line([sys,'/','Ef'],[155,70;205,70])
set_param([sys,'/','Ef'],...
		'Mask Display','plot([t,t+period,t+2*period],[y,y,y])',...
		'Mask Type','Repeating table',...
		'Mask Dialogue','Repeating table.\nEnter values of time and output for first cycle.|Time values:|Output values:')
set_param([sys,'/','Ef'],...
		'Mask Translate','period = max(@1); t = @1; y = @2;',...
		'Mask Help','Repeats cycle given in table. Time values should be monotonically increasing.',...
		'Mask Entries','Ex_time\/Ex_value\/')


%     Finished composite block 'Ef'.

set_param([sys,'/','Ef'],...
		'position',[395,280,425,300])

add_block('built-in/Clock',[sys,'/','Clock'])
set_param([sys,'/','Clock'],...
		'orientation',3,...
		'position',[265,140,285,160])


%     Subsystem  'Vm'.

new_system([sys,'/','Vm'])
set_param([sys,'/','Vm'],'Location',[5,40,315,196])

add_block('built-in/Outport',[sys,'/','Vm/out_1'])
set_param([sys,'/','Vm/out_1'],...
		'position',[285,60,305,80])

add_block('built-in/Look Up Table',[sys,'/','Vm/Look-Up Table'])
set_param([sys,'/','Vm/Look-Up Table'],...
		'Input_Values','t',...
		'Output_Values','y',...
		'position',[210,58,250,82])

add_block('built-in/Fcn',[sys,'/','Vm/Fcn1'])
set_param([sys,'/','Vm/Fcn1'],...
		'Expr','rem(u[1],period)',...
		'position',[110,60,150,80])

add_block('built-in/Clock',[sys,'/','Vm/Clock'])
set_param([sys,'/','Vm/Clock'],...
		'position',[45,60,65,80])
add_line([sys,'/','Vm'],[255,70;280,70])
add_line([sys,'/','Vm'],[70,70;105,70])
add_line([sys,'/','Vm'],[155,70;205,70])
set_param([sys,'/','Vm'],...
		'Mask Display','plot([t,t+period,t+2*period],[y,y,y])',...
		'Mask Type','Repeating table',...
		'Mask Dialogue','Repeating table.\nEnter values of time and output for first cycle.|Time values:|Output values:')
set_param([sys,'/','Vm'],...
		'Mask Translate','period = max(@1); t = @1; y = @2;',...
		'Mask Help','Repeats cycle given in table. Time values should be monotonically increasing.',...
		'Mask Entries','Vm_time\/Vm_value\/')


%     Finished composite block 'Vm'.

set_param([sys,'/','Vm'],...
		'orientation',2,...
		'position',[165,162,230,188])

add_block('built-in/Gain',[sys,'/','omega*t'])
set_param([sys,'/','omega*t'],...
		'orientation',2,...
		'Gain','120*pi',...
		'position',[160,107,220,143])

add_block('built-in/Mux',[sys,'/','Mux1'])
set_param([sys,'/','Mux1'],...
		'orientation',2,...
		'inputs','2',...
		'position',[95,109,120,171])

add_block('built-in/Fcn',[sys,'/','Fcn'])
set_param([sys,'/','Fcn'],...
		'Expr','u[2]*cos(u[1] )',...
		'position',[100,207,215,233])

add_block('built-in/Fcn',[sys,'/','Fcn2'])
set_param([sys,'/','Fcn2'],...
		'Expr','u[2]*cos(u[1]+T2piby3)',...
		'position',[100,302,230,328])

add_block('built-in/Fcn',[sys,'/','Fcn1'])
set_param([sys,'/','Fcn1'],...
		'Expr','u[2]*cos(u[1]-T2piby3)',...
		'position',[95,257,225,283])

add_block('built-in/Note',[sys,'/','vag'])
set_param([sys,'/','vag'],...
		'position',[235,200,240,205])

add_block('built-in/Note',[sys,'/','ia'])
set_param([sys,'/','ia'],...
		'orientation',3,...
		'position',[620,115,625,120])

add_block('built-in/Note',[sys,'/','vcg'])
set_param([sys,'/','vcg'],...
		'position',[240,295,245,300])

add_block('built-in/Note',[sys,'/','vbg'])
set_param([sys,'/','vbg'],...
		'position',[235,240,240,245])


%     Subsystem  'm5'.

new_system([sys,'/','m5'])
set_param([sys,'/','m5'],'Location',[75,262204,215,262309])

add_block('built-in/Clock',[sys,'/','m5/Clock1'])
set_param([sys,'/','m5/Clock1'],...
		'position',[60,50,80,70])

add_block('built-in/Outport',[sys,'/','m5/out_1'])
set_param([sys,'/','m5/out_1'],...
		'position',[105,50,125,70])
add_line([sys,'/','m5'],[85,60;100,60])
set_param([sys,'/','m5'],...
		'Mask Display','Initialize\nand plot',...
		'Mask Type','Masked block of m5.m',...
		'Mask Dialogue','eval(''m5'')',...
		'Mask Help','Uses m5.m to initialize and plot')


%     Finished composite block 'm5'.

set_param([sys,'/','m5'],...
		'Drop Shadow',4,...
		'position',[125,31,205,69])
add_line(sys,[345,260;440,260])
add_line(sys,[455,60;455,40;535,40])
add_line(sys,[275,135;275,90])
add_line(sys,[345,230;440,230])
add_line(sys,[345,230;350,230;350,165])
add_line(sys,[505,225;505,200;605,200;605,165])
add_line(sys,[505,225;505,200;380,200;380,165])
add_line(sys,[430,290;440,290])
add_line(sys,[395,320;440,320])
add_line(sys,[350,125;350,120;320,120;320,90])
add_line(sys,[345,260;410,260;410,165])
add_line(sys,[455,60;455,40;410,40])
add_line(sys,[275,135;275,125;225,125])
add_line(sys,[220,220;295,220])
add_line(sys,[230,270;250,270;250,240;295,240])
add_line(sys,[235,315;260,315;260,260;295,260])
add_line(sys,[155,125;125,125])
add_line(sys,[160,175;155,175;155,155;125,155])
add_line(sys,[90,140;75,140;75,220;95,220])
add_line(sys,[90,140;75,140;75,270;90,270])
add_line(sys,[90,140;75,140;75,315;95,315])
add_line(sys,[505,265;660,255])
add_line(sys,[650,210;650,165])
add_line(sys,[665,210;665,165])
add_line(sys,[650,210;650,185;695,185;695,380;275,380;275,280;295,280])
add_line(sys,[665,210;665,205;680,205;680,360;285,360;295,300])
add_line(sys,[505,305;620,305;620,165])
add_line(sys,[505,305;620,305;620,180;440,180;440,165])
add_line(sys,[610,125;610,105;635,105;635,90])
add_line(sys,[505,325;590,325;590,90])
add_line(sys,[505,285;545,285;545,90])
add_line(sys,[505,245;535,245;535,115;500,115;500,90])
add_line(sys,[380,125;380,115;365,115;365,90])
add_line(sys,[410,125;410,90])
add_line(sys,[440,125;440,120;455,120;455,90])

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
