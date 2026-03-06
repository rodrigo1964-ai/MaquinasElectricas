function [ret,x0,str,ts,xts]=s4(t,x,u,flag);
%s4	is the M-file description of the SIMULINK system named s4.
%	The block-diagram can be displayed by typing: s4.
%
%	SYS=s4(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes s4 to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling s4 with a FLAG of zero:
%	[SIZES]=s4([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[27,71,780,445])
     open_system(sys)
end;
set_param(sys,'algorithm',     'Adams/Gear')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     'tstop')
set_param(sys,'Min step size', '1e-4')
set_param(sys,'Max step size', '5e-3')
set_param(sys,'Relative error','5e-6')
set_param(sys,'Return vars',   '')

add_block('built-in/Note',[sys,'/','vq'])
set_param([sys,'/','vq'],...
		'position',[220,170,225,175])

add_block('built-in/Note',[sys,'/','v0'])
set_param([sys,'/','v0'],...
		'position',[215,235,220,240])

add_block('built-in/Sine Wave',[sys,'/','va'])
set_param([sys,'/','va'],...
		'Font Number',3,...
		'amplitude','Vm',...
		'frequency','we',...
		'phase','pi/2',...
		'position',[65,169,90,191])

add_block('built-in/Sine Wave',[sys,'/','vb'])
set_param([sys,'/','vb'],...
		'Font Number',3,...
		'amplitude','Vm',...
		'frequency','we',...
		'phase','-pi/6',...
		'position',[65,209,90,231])


%     Subsystem  'abc2qd0'.

new_system([sys,'/','abc2qd0'])
set_param([sys,'/','abc2qd0'],'Location',[454,254,1125,632])

add_block('built-in/Outport',[sys,'/','abc2qd0/vqr'])
set_param([sys,'/','abc2qd0/vqr'],...
		'position',[595,70,615,90])

add_block('built-in/Outport',[sys,'/','abc2qd0/vdr'])
set_param([sys,'/','abc2qd0/vdr'],...
		'Port','2',...
		'position',[590,145,610,165])

add_block('built-in/Outport',[sys,'/','abc2qd0/vd0'])
set_param([sys,'/','abc2qd0/vd0'],...
		'Port','3',...
		'position',[590,225,610,245])

add_block('built-in/Fcn',[sys,'/','abc2qd0/abc2q'])
set_param([sys,'/','abc2qd0/abc2q'],...
		'Expr','(2*u[1]- u[2] - u[3])/3',...
		'position',[150,129,290,151])

add_block('built-in/Fcn',[sys,'/','abc2qd0/abc20'])
set_param([sys,'/','abc2qd0/abc20'],...
		'Expr','(u[1] + u[2]  + u[3])/3',...
		'position',[150,224,290,246])

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

add_block('built-in/Fcn',[sys,'/','abc2qd0/qds2qr'])
set_param([sys,'/','abc2qd0/qds2qr'],...
		'Expr','u[1]*u[3] - u[2]*u[4]',...
		'position',[425,68,560,92])

add_block('built-in/Note',[sys,'/','abc2qd0/vqs'])
set_param([sys,'/','abc2qd0/vqs'],...
		'position',[325,118,330,123])
add_line([sys,'/','abc2qd0'],[120,185;125,185;125,140;145,140])
add_line([sys,'/','abc2qd0'],[120,185;145,185])
add_line([sys,'/','abc2qd0'],[405,125;405,80;420,80])
add_line([sys,'/','abc2qd0'],[405,125;405,155;420,155])
add_line([sys,'/','abc2qd0'],[65,150;85,150])
add_line([sys,'/','abc2qd0'],[65,185;85,185])
add_line([sys,'/','abc2qd0'],[65,220;85,220])
add_line([sys,'/','abc2qd0'],[565,80;590,80])
add_line([sys,'/','abc2qd0'],[565,155;585,155])
add_line([sys,'/','abc2qd0'],[120,185;125,185;125,235;145,235])
add_line([sys,'/','abc2qd0'],[65,70;370,70])
add_line([sys,'/','abc2qd0'],[65,105;370,105])
add_line([sys,'/','abc2qd0'],[295,140;370,140])
add_line([sys,'/','abc2qd0'],[295,185;325,185;325,175;370,175])
add_line([sys,'/','abc2qd0'],[295,235;585,235])


%     Finished composite block 'abc2qd0'.

set_param([sys,'/','abc2qd0'],...
		'Font Number',3,...
		'position',[160,172,200,268])


%     Subsystem  'qd_motor'.

new_system([sys,'/','qd_motor'])
set_param([sys,'/','qd_motor'],'Location',[165,178,780,654])

add_block('built-in/Outport',[sys,'/','qd_motor/iq_motor'])
set_param([sys,'/','qd_motor/iq_motor'],...
		'position',[340,80,360,100])

add_block('built-in/Inport',[sys,'/','qd_motor/vq'])
set_param([sys,'/','qd_motor/vq'],...
		'position',[60,65,80,85])

add_block('built-in/Product',[sys,'/','qd_motor/prod1'])
set_param([sys,'/','qd_motor/prod1'],...
		'orientation',2,...
		'Font Number',3,...
		'position',[165,148,185,172])

add_block('built-in/Product',[sys,'/','qd_motor/prod2'])
set_param([sys,'/','qd_motor/prod2'],...
		'orientation',2,...
		'Font Number',3,...
		'position',[165,193,185,222])

add_block('built-in/Outport',[sys,'/','qd_motor/id_motor'])
set_param([sys,'/','qd_motor/id_motor'],...
		'Port','6',...
		'position',[240,310,260,330])


%     Subsystem  'qd_motor/d_cct'.

new_system([sys,'/','qd_motor/d_cct'])
set_param([sys,'/','qd_motor/d_cct'],'Location',[71,250,1020,767])

add_block('built-in/Outport',[sys,'/','qd_motor/d_cct/Out_psid'])
set_param([sys,'/','qd_motor/d_cct/Out_psid'],...
		'position',[585,45,605,65])

add_block('built-in/Outport',[sys,'/','qd_motor/d_cct/Out_psimd'])
set_param([sys,'/','qd_motor/d_cct/Out_psimd'],...
		'Port','3',...
		'position',[835,120,855,140])

add_block('built-in/Fcn',[sys,'/','qd_motor/d_cct/Fcn3'])
set_param([sys,'/','qd_motor/d_cct/Fcn3'],...
		'Expr','xMD*(u[1]/xls+u[2]+u[3]/xplkd)',...
		'position',[565,114,775,146])

add_block('built-in/Mux',[sys,'/','qd_motor/d_cct/Mux3'])
set_param([sys,'/','qd_motor/d_cct/Mux3'],...
		'inputs','3',...
		'position',[520,87,545,173])

add_block('built-in/Integrator',[sys,'/','qd_motor/d_cct/psid_'])
set_param([sys,'/','qd_motor/d_cct/psid_'],...
		'Initial','Psido',...
		'position',[390,127,420,153])

add_block('built-in/Fcn',[sys,'/','qd_motor/d_cct/Fcn'])
set_param([sys,'/','qd_motor/d_cct/Fcn'],...
		'Expr','wb*(u[2]+u[3]+(rs/xls)*(u[1]-u[4]))',...
		'position',[180,125,375,155])

add_block('built-in/Inport',[sys,'/','qd_motor/d_cct/In_wrpsiq'])
set_param([sys,'/','qd_motor/d_cct/In_wrpsiq'],...
		'Port','2',...
		'position',[50,160,70,180])

add_block('built-in/Inport',[sys,'/','qd_motor/d_cct/In_vd'])
set_param([sys,'/','qd_motor/d_cct/In_vd'],...
		'position',[50,105,70,125])

add_block('built-in/Mux',[sys,'/','qd_motor/d_cct/Mux'])
set_param([sys,'/','qd_motor/d_cct/Mux'],...
		'position',[135,86,160,189])

add_block('built-in/Inport',[sys,'/','qd_motor/d_cct/In_Ipm'])
set_param([sys,'/','qd_motor/d_cct/In_Ipm'],...
		'Port','3',...
		'position',[50,225,70,245])

add_block('built-in/Mux',[sys,'/','qd_motor/d_cct/Mux4'])
set_param([sys,'/','qd_motor/d_cct/Mux4'],...
		'inputs','2',...
		'position',[520,194,540,261])

add_block('built-in/Fcn',[sys,'/','qd_motor/d_cct/Fcn4'])
set_param([sys,'/','qd_motor/d_cct/Fcn4'],...
		'Expr','(u[1]-u[2])/xls',...
		'position',[570,217,660,243])

add_block('built-in/Outport',[sys,'/','qd_motor/d_cct/Out_id'])
set_param([sys,'/','qd_motor/d_cct/Out_id'],...
		'Port','2',...
		'position',[835,220,855,240])

add_block('built-in/Scope',[sys,'/','qd_motor/d_cct/daxis_Scope'])
set_param([sys,'/','qd_motor/d_cct/daxis_Scope'],...
		'Vgain','3.000000',...
		'Hgain','0.050000',...
		'Vmax','6.000000',...
		'Hmax','2.000000',...
		'Window',[451,130,627,387],...
		'position',[835,347,855,373])

add_block('built-in/Outport',[sys,'/','qd_motor/d_cct/Out_iplkd'])
set_param([sys,'/','qd_motor/d_cct/Out_iplkd'],...
		'Port','4',...
		'position',[835,305,855,325])

add_block('built-in/Fcn',[sys,'/','qd_motor/d_cct/Fcn5'])
set_param([sys,'/','qd_motor/d_cct/Fcn5'],...
		'Expr','(u[1]-u[2])/xplkd',...
		'position',[565,302,660,328])

add_block('built-in/Mux',[sys,'/','qd_motor/d_cct/Mux5'])
set_param([sys,'/','qd_motor/d_cct/Mux5'],...
		'inputs','2',...
		'position',[520,279,540,346])

add_block('built-in/Integrator',[sys,'/','qd_motor/d_cct/psipkd_'])
set_param([sys,'/','qd_motor/d_cct/psipkd_'],...
		'Initial','Psikdo',...
		'position',[395,282,425,308])

add_block('built-in/Fcn',[sys,'/','qd_motor/d_cct/Fcn2'])
set_param([sys,'/','qd_motor/d_cct/Fcn2'],...
		'Expr','wb*rpkd*(u[1]-u[2])/xplkd',...
		'position',[185,281,370,309])

add_block('built-in/Mux',[sys,'/','qd_motor/d_cct/Mux2'])
set_param([sys,'/','qd_motor/d_cct/Mux2'],...
		'inputs','2',...
		'position',[135,255,160,330])
add_line([sys,'/','qd_motor/d_cct'],[75,170;95,170;95,150;130,150])
add_line([sys,'/','qd_motor/d_cct'],[75,115;95,115;95,125;130,125])
add_line([sys,'/','qd_motor/d_cct'],[165,140;175,140])
add_line([sys,'/','qd_motor/d_cct'],[380,140;385,140])
add_line([sys,'/','qd_motor/d_cct'],[425,140;435,140;435,205;115,205;115,175;130,175])
add_line([sys,'/','qd_motor/d_cct'],[165,295;180,295])
add_line([sys,'/','qd_motor/d_cct'],[375,295;390,295])
add_line([sys,'/','qd_motor/d_cct'],[430,295;460,295;460,360;110,360;110,310;130,310])
add_line([sys,'/','qd_motor/d_cct'],[425,140;435,140;435,100;515,100])
add_line([sys,'/','qd_motor/d_cct'],[430,295;460,295;460,160;515,160])
add_line([sys,'/','qd_motor/d_cct'],[550,130;560,130])
add_line([sys,'/','qd_motor/d_cct'],[545,230;565,230])
add_line([sys,'/','qd_motor/d_cct'],[425,140;470,140;470,210;515,210])
add_line([sys,'/','qd_motor/d_cct'],[545,315;560,315])
add_line([sys,'/','qd_motor/d_cct'],[780,130;790,130;790,375;495,375;495,330;515,330])
add_line([sys,'/','qd_motor/d_cct'],[780,130;790,130;790,275;495,275;495,245;515,245])
add_line([sys,'/','qd_motor/d_cct'],[780,130;790,130;790,375;90,375;90,275;130,275])
add_line([sys,'/','qd_motor/d_cct'],[780,130;790,130;790,80;115,80;115,100;130,100])
add_line([sys,'/','qd_motor/d_cct'],[780,130;830,130])
add_line([sys,'/','qd_motor/d_cct'],[665,230;830,230])
add_line([sys,'/','qd_motor/d_cct'],[665,315;830,315])
add_line([sys,'/','qd_motor/d_cct'],[425,140;435,140;435,55;580,55])
add_line([sys,'/','qd_motor/d_cct'],[430,295;515,295])
add_line([sys,'/','qd_motor/d_cct'],[75,235;450,235;450,130;515,130])


%     Finished composite block 'qd_motor/d_cct'.

set_param([sys,'/','qd_motor/d_cct'],...
		'position',[150,253,190,327])

add_block('built-in/Inport',[sys,'/','qd_motor/Ipm'])
set_param([sys,'/','qd_motor/Ipm'],...
		'Port','3',...
		'position',[55,305,75,325])

add_block('built-in/Inport',[sys,'/','qd_motor/vd'])
set_param([sys,'/','qd_motor/vd'],...
		'Port','2',...
		'position',[55,255,75,275])


%     Subsystem  'qd_motor/Rotor'.

new_system([sys,'/','qd_motor/Rotor'])
set_param([sys,'/','qd_motor/Rotor'],'Location',[153,246,845,533])

add_block('built-in/Gain',[sys,'/','qd_motor/Rotor/gain4'])
set_param([sys,'/','qd_motor/Rotor/gain4'],...
		'Gain','wb',...
		'position',[490,123,530,157])

add_block('built-in/Gain',[sys,'/','qd_motor/Rotor/1//2H'])
set_param([sys,'/','qd_motor/Rotor/1//2H'],...
		'Gain','1/(2*H)',...
		'position',[325,120,395,160])

add_block('built-in/Sum',[sys,'/','qd_motor/Rotor/Tacc'])
set_param([sys,'/','qd_motor/Rotor/Tacc'],...
		'inputs','-++',...
		'position',[285,110,305,170])

add_block('built-in/Gain',[sys,'/','qd_motor/Rotor/D'])
set_param([sys,'/','qd_motor/Rotor/D'],...
		'orientation',2,...
		'Gain','Domega',...
		'position',[330,68,405,102])

add_block('built-in/Inport',[sys,'/','qd_motor/Rotor/psid '])
set_param([sys,'/','qd_motor/Rotor/psid '],...
		'Port','2',...
		'position',[95,130,115,150])

add_block('built-in/Sum',[sys,'/','qd_motor/Rotor/Sum12'])
set_param([sys,'/','qd_motor/Rotor/Sum12'],...
		'inputs','+-',...
		'position',[195,111,215,209])

add_block('built-in/Product',[sys,'/','qd_motor/Rotor/Prod2'])
set_param([sys,'/','qd_motor/Rotor/Prod2'],...
		'position',[155,175,170,195])

add_block('built-in/Inport',[sys,'/','qd_motor/Rotor/psiq'])
set_param([sys,'/','qd_motor/Rotor/psiq'],...
		'Port','3',...
		'position',[95,170,115,190])

add_block('built-in/Product',[sys,'/','qd_motor/Rotor/Prod'])
set_param([sys,'/','qd_motor/Rotor/Prod'],...
		'position',[155,124,170,146])

add_block('built-in/Note',[sys,'/','qd_motor/Rotor/Tem_'])
set_param([sys,'/','qd_motor/Rotor/Tem_'],...
		'position',[235,140,240,145])

add_block('built-in/Integrator',[sys,'/','qd_motor/Rotor/slip'])
set_param([sys,'/','qd_motor/Rotor/slip'],...
		'Initial','wrslipo',...
		'position',[420,121,450,159])

add_block('built-in/Inport',[sys,'/','qd_motor/Rotor/Tmech'])
set_param([sys,'/','qd_motor/Rotor/Tmech'],...
		'Port','5',...
		'position',[95,55,115,75])

add_block('built-in/Inport',[sys,'/','qd_motor/Rotor/iq'])
set_param([sys,'/','qd_motor/Rotor/iq'],...
		'position',[95,95,115,115])

add_block('built-in/Inport',[sys,'/','qd_motor/Rotor/id'])
set_param([sys,'/','qd_motor/Rotor/id'],...
		'Port','4',...
		'position',[95,210,115,230])

add_block('built-in/Outport',[sys,'/','qd_motor/Rotor/Tem'])
set_param([sys,'/','qd_motor/Rotor/Tem'],...
		'Port','3',...
		'position',[285,198,310,222])

add_block('built-in/Constant',[sys,'/','qd_motor/Rotor/we//wb'])
set_param([sys,'/','qd_motor/Rotor/we//wb'],...
		'position',[430,198,460,222])

add_block('built-in/Sum',[sys,'/','qd_motor/Rotor/Sum14'])
set_param([sys,'/','qd_motor/Rotor/Sum14'],...
		'position',[505,178,520,222])

add_block('built-in/Outport',[sys,'/','qd_motor/Rotor/wr//wb '])
set_param([sys,'/','qd_motor/Rotor/wr//wb '],...
		'Port','2',...
		'position',[605,190,625,210])

add_block('built-in/Integrator',[sys,'/','qd_motor/Rotor/del'])
set_param([sys,'/','qd_motor/Rotor/del'],...
		'Initial','delto',...
		'position',[545,121,575,159])

add_block('built-in/Outport',[sys,'/','qd_motor/Rotor/delta'])
set_param([sys,'/','qd_motor/Rotor/delta'],...
		'position',[605,130,625,150])

add_block('built-in/Outport',[sys,'/','qd_motor/Rotor/(wr-we)//wb'])
set_param([sys,'/','qd_motor/Rotor/(wr-we)//wb'],...
		'Port','4',...
		'position',[590,75,610,95])
add_line([sys,'/','qd_motor/Rotor'],[325,85;265,85;265,120;280,120])
add_line([sys,'/','qd_motor/Rotor'],[220,160;280,160])
add_line([sys,'/','qd_motor/Rotor'],[455,140;485,140])
add_line([sys,'/','qd_motor/Rotor'],[535,140;540,140])
add_line([sys,'/','qd_motor/Rotor'],[175,185;190,185])
add_line([sys,'/','qd_motor/Rotor'],[400,140;415,140])
add_line([sys,'/','qd_motor/Rotor'],[465,210;500,210])
add_line([sys,'/','qd_motor/Rotor'],[310,140;320,140])
add_line([sys,'/','qd_motor/Rotor'],[175,135;190,135])
add_line([sys,'/','qd_motor/Rotor'],[120,105;130,105;130,130;150,130])
add_line([sys,'/','qd_motor/Rotor'],[120,140;150,140])
add_line([sys,'/','qd_motor/Rotor'],[120,180;150,180])
add_line([sys,'/','qd_motor/Rotor'],[120,220;130,220;130,190;150,190])
add_line([sys,'/','qd_motor/Rotor'],[525,200;600,200])
add_line([sys,'/','qd_motor/Rotor'],[220,160;255,160;255,210;280,210])
add_line([sys,'/','qd_motor/Rotor'],[455,140;470,140;470,190;500,190])
add_line([sys,'/','qd_motor/Rotor'],[455,140;470,140;470,85;585,85])
add_line([sys,'/','qd_motor/Rotor'],[455,140;470,140;470,85;410,85])
add_line([sys,'/','qd_motor/Rotor'],[120,65;250,65;250,140;280,140])
add_line([sys,'/','qd_motor/Rotor'],[580,140;600,140])


%     Finished composite block 'qd_motor/Rotor'.

set_param([sys,'/','qd_motor/Rotor'],...
		'Font Number',3,...
		'position',[345,230,395,330])

add_block('built-in/Outport',[sys,'/','qd_motor/delta'])
set_param([sys,'/','qd_motor/delta'],...
		'Port','2',...
		'position',[450,235,470,255])

add_block('built-in/Outport',[sys,'/','qd_motor/wr//wb'])
set_param([sys,'/','qd_motor/wr//wb'],...
		'Port','3',...
		'position',[500,260,520,280])

add_block('built-in/Outport',[sys,'/','qd_motor/Tem'])
set_param([sys,'/','qd_motor/Tem'],...
		'Port','4',...
		'position',[455,285,475,305])

add_block('built-in/Outport',[sys,'/','qd_motor/(wr-we)//wb'])
set_param([sys,'/','qd_motor/(wr-we)//wb'],...
		'Port','5',...
		'position',[495,310,515,330])

add_block('built-in/Inport',[sys,'/','qd_motor/Tmech'])
set_param([sys,'/','qd_motor/Tmech'],...
		'Port','4',...
		'position',[295,310,315,330])


%     Subsystem  'qd_motor/q_cct'.

new_system([sys,'/','qd_motor/q_cct'])
set_param([sys,'/','qd_motor/q_cct'],'Location',[159,307,1108,824])

add_block('built-in/Outport',[sys,'/','qd_motor/q_cct/Out_psiq'])
set_param([sys,'/','qd_motor/q_cct/Out_psiq'],...
		'position',[585,45,605,65])

add_block('built-in/Integrator',[sys,'/','qd_motor/q_cct/psiq_'])
set_param([sys,'/','qd_motor/q_cct/psiq_'],...
		'Initial','Psiqo',...
		'position',[390,127,420,153])

add_block('built-in/Fcn',[sys,'/','qd_motor/q_cct/Fcn'])
set_param([sys,'/','qd_motor/q_cct/Fcn'],...
		'Expr','wb*(u[2]-u[3]+(rs/xls)*(u[1]-u[4]))',...
		'position',[180,125,375,155])

add_block('built-in/Inport',[sys,'/','qd_motor/q_cct/In_wrpsid'])
set_param([sys,'/','qd_motor/q_cct/In_wrpsid'],...
		'Port','2',...
		'position',[50,160,70,180])

add_block('built-in/Inport',[sys,'/','qd_motor/q_cct/In_vq'])
set_param([sys,'/','qd_motor/q_cct/In_vq'],...
		'position',[50,105,70,125])

add_block('built-in/Mux',[sys,'/','qd_motor/q_cct/Mux'])
set_param([sys,'/','qd_motor/q_cct/Mux'],...
		'position',[135,86,160,189])

add_block('built-in/Mux',[sys,'/','qd_motor/q_cct/Mux3'])
set_param([sys,'/','qd_motor/q_cct/Mux3'],...
		'inputs','2',...
		'position',[515,124,540,191])

add_block('built-in/Mux',[sys,'/','qd_motor/q_cct/Mux4'])
set_param([sys,'/','qd_motor/q_cct/Mux4'],...
		'inputs','2',...
		'position',[515,214,540,281])

add_block('built-in/Fcn',[sys,'/','qd_motor/q_cct/Fcn4'])
set_param([sys,'/','qd_motor/q_cct/Fcn4'],...
		'Expr','(u[1]-u[2])/xls',...
		'position',[575,237,665,263])

add_block('built-in/Fcn',[sys,'/','qd_motor/q_cct/Fcn3'])
set_param([sys,'/','qd_motor/q_cct/Fcn3'],...
		'Expr','xMQ*(u[1]/xls+u[2]/xplkq)',...
		'position',[565,146,720,174])

add_block('built-in/Outport',[sys,'/','qd_motor/q_cct/Out_psimq'])
set_param([sys,'/','qd_motor/q_cct/Out_psimq'],...
		'Port','3',...
		'position',[830,150,850,170])

add_block('built-in/Outport',[sys,'/','qd_motor/q_cct/Out_iq'])
set_param([sys,'/','qd_motor/q_cct/Out_iq'],...
		'Port','2',...
		'position',[830,240,850,260])

add_block('built-in/Mux',[sys,'/','qd_motor/q_cct/Mux2'])
set_param([sys,'/','qd_motor/q_cct/Mux2'],...
		'inputs','2',...
		'position',[130,220,155,295])

add_block('built-in/Fcn',[sys,'/','qd_motor/q_cct/Fcn2'])
set_param([sys,'/','qd_motor/q_cct/Fcn2'],...
		'Expr','wb*rpkq*(u[1]-u[2])/xplkq',...
		'position',[180,246,365,274])

add_block('built-in/Integrator',[sys,'/','qd_motor/q_cct/psipkq_'])
set_param([sys,'/','qd_motor/q_cct/psipkq_'],...
		'Initial','Psikqo',...
		'position',[390,247,420,273])

add_block('built-in/Scope',[sys,'/','qd_motor/q_cct/qaxis_Scope'])
set_param([sys,'/','qd_motor/q_cct/qaxis_Scope'],...
		'Vgain','3.000000',...
		'Hgain','0.050000',...
		'Vmax','6.000000',...
		'Hmax','2.000000',...
		'Window',[451,130,627,387],...
		'position',[825,292,845,318])
add_line([sys,'/','qd_motor/q_cct'],[75,170;95,170;95,150;130,150])
add_line([sys,'/','qd_motor/q_cct'],[75,115;95,115;95,125;130,125])
add_line([sys,'/','qd_motor/q_cct'],[165,140;175,140])
add_line([sys,'/','qd_motor/q_cct'],[380,140;385,140])
add_line([sys,'/','qd_motor/q_cct'],[425,140;435,140;435,205;115,205;115,175;130,175])
add_line([sys,'/','qd_motor/q_cct'],[160,260;175,260])
add_line([sys,'/','qd_motor/q_cct'],[370,260;385,260])
add_line([sys,'/','qd_motor/q_cct'],[425,260;460,260;460,320;110,320;110,275;125,275])
add_line([sys,'/','qd_motor/q_cct'],[425,140;510,140])
add_line([sys,'/','qd_motor/q_cct'],[545,160;560,160])
add_line([sys,'/','qd_motor/q_cct'],[545,250;570,250])
add_line([sys,'/','qd_motor/q_cct'],[425,140;470,140;470,230;510,230])
add_line([sys,'/','qd_motor/q_cct'],[725,160;790,160;790,345;495,345;495,265;510,265])
add_line([sys,'/','qd_motor/q_cct'],[725,160;790,160;790,345;90,345;90,240;125,240])
add_line([sys,'/','qd_motor/q_cct'],[725,160;790,160;790,80;115,80;115,100;130,100])
add_line([sys,'/','qd_motor/q_cct'],[725,160;825,160])
add_line([sys,'/','qd_motor/q_cct'],[670,250;825,250])
add_line([sys,'/','qd_motor/q_cct'],[425,140;435,140;435,55;580,55])
add_line([sys,'/','qd_motor/q_cct'],[425,260;460,260;460,175;510,175])


%     Finished composite block 'qd_motor/q_cct'.

set_param([sys,'/','qd_motor/q_cct'],...
		'position',[155,53,195,127])

add_block('built-in/Note',[sys,'/','qd_motor/iq'])
set_param([sys,'/','qd_motor/iq'],...
		'position',[215,70,220,75])

add_block('built-in/Note',[sys,'/','qd_motor/id'])
set_param([sys,'/','qd_motor/id'],...
		'position',[210,260,215,265])

add_block('built-in/Note',[sys,'/','qd_motor/psid'])
set_param([sys,'/','qd_motor/psid'],...
		'position',[210,240,215,245])

add_block('built-in/Note',[sys,'/','qd_motor/psiq'])
set_param([sys,'/','qd_motor/psiq'],...
		'position',[215,45,220,50])
add_line([sys,'/','qd_motor'],[320,320;340,320])
add_line([sys,'/','qd_motor'],[195,260;340,260])
add_line([sys,'/','qd_motor'],[195,280;220,280;220,300;340,300])
add_line([sys,'/','qd_motor'],[200,90;290,90;290,240;340,240])
add_line([sys,'/','qd_motor'],[200,65;255,65;255,280;340,280])
add_line([sys,'/','qd_motor'],[200,90;335,90])
add_line([sys,'/','qd_motor'],[400,245;445,245])
add_line([sys,'/','qd_motor'],[400,320;490,320])
add_line([sys,'/','qd_motor'],[400,270;495,270])
add_line([sys,'/','qd_motor'],[400,295;450,295])
add_line([sys,'/','qd_motor'],[195,280;220,280;220,320;235,320])
add_line([sys,'/','qd_motor'],[160,160;120,160;120,110;150,110])
add_line([sys,'/','qd_motor'],[85,75;150,75])
add_line([sys,'/','qd_motor'],[195,260;235,260;235,165;190,165])
add_line([sys,'/','qd_motor'],[400,270;415,270;415,155;190,155])
add_line([sys,'/','qd_motor'],[200,65;255,65;255,215;190,215])
add_line([sys,'/','qd_motor'],[400,270;415,270;415,200;190,200])
add_line([sys,'/','qd_motor'],[80,315;145,315])
add_line([sys,'/','qd_motor'],[80,265;145,265])
add_line([sys,'/','qd_motor'],[160,210;120,210;120,290;145,290])


%     Finished composite block 'qd_motor'.

set_param([sys,'/','qd_motor'],...
		'position',[290,171,345,299])


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
		'position',[210,270,235,290])

add_block('built-in/Note',[sys,'/','wr//wb'])
set_param([sys,'/','wr//wb'],...
		'position',[370,205,375,210])

add_block('built-in/Note',[sys,'/','Tem'])
set_param([sys,'/','Tem'],...
		'position',[365,225,370,230])

add_block('built-in/Note',[sys,'/','cos (wrt)'])
set_param([sys,'/','cos (wrt)'],...
		'position',[505,195,510,200])

add_block('built-in/Note',[sys,'/','sin (wrt)'])
set_param([sys,'/','sin (wrt)'],...
		'position',[505,210,510,215])

add_block('built-in/Sine Wave',[sys,'/','vc'])
set_param([sys,'/','vc'],...
		'Font Number',3,...
		'amplitude','Vm',...
		'frequency','we',...
		'phase','7*pi/6',...
		'position',[65,249,90,271])

add_block('built-in/Note',[sys,'/','vd'])
set_param([sys,'/','vd'],...
		'position',[220,200,225,205])


%     Subsystem  'osc'.

new_system([sys,'/','osc'])
set_param([sys,'/','osc'],'Location',[442,141,1032,385])

add_block('built-in/Gain',[sys,'/','osc/Gain'])
set_param([sys,'/','osc/Gain'],...
		'Gain','-wb',...
		'position',[135,63,180,97])

add_block('built-in/Product',[sys,'/','osc/Product'])
set_param([sys,'/','osc/Product'],...
		'position',[370,43,390,92])

add_block('built-in/Integrator',[sys,'/','osc/cos'])
set_param([sys,'/','osc/cos'],...
		'Initial','1',...
		'position',[215,63,245,97])

add_block('built-in/Inport',[sys,'/','osc/wr//wb'])
set_param([sys,'/','osc/wr//wb'],...
		'position',[30,45,50,65])

add_block('built-in/Integrator',[sys,'/','osc/sin'])
set_param([sys,'/','osc/sin'],...
		'orientation',2,...
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
		'position',[450,205,475,240])


%     Subsystem  'qdr2abc'.

new_system([sys,'/','qdr2abc'])
set_param([sys,'/','qdr2abc'],'Location',[56,346,800,637])

add_block('built-in/Mux',[sys,'/','qdr2abc/Mux'])
set_param([sys,'/','qdr2abc/Mux'],...
		'position',[125,34,155,196])

add_block('built-in/Inport',[sys,'/','qdr2abc/id'])
set_param([sys,'/','qdr2abc/id'],...
		'Port','2',...
		'position',[60,165,80,185])

add_block('built-in/Inport',[sys,'/','qdr2abc/iq'])
set_param([sys,'/','qdr2abc/iq'],...
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

add_block('built-in/Outport',[sys,'/','qdr2abc/ic'])
set_param([sys,'/','qdr2abc/ic'],...
		'Port','3',...
		'position',[640,208,665,232])

add_block('built-in/Fcn',[sys,'/','qdr2abc/qds2c'])
set_param([sys,'/','qdr2abc/qds2c'],...
		'Expr','-u[1]/2 +sqrt(3)*u[2]/2 + u[3]',...
		'position',[435,209,605,231])
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
add_line([sys,'/','qdr2abc'],[610,220;635,220])


%     Finished composite block 'qdr2abc'.

set_param([sys,'/','qdr2abc'],...
		'Font Number',3,...
		'position',[545,157,580,243])


%     Subsystem  'VIPQ'.

new_system([sys,'/','VIPQ'])
set_param([sys,'/','VIPQ'],'Location',[284,425,995,813])

add_block('built-in/Outport',[sys,'/','VIPQ/Texc'])
set_param([sys,'/','VIPQ/Texc'],...
		'Port','6',...
		'position',[480,300,500,320])

add_block('built-in/Fcn',[sys,'/','VIPQ/Texcitation'])
set_param([sys,'/','VIPQ/Texcitation'],...
		'Expr','u[2]*Ipm*xmd',...
		'position',[270,295,435,325])

add_block('built-in/Outport',[sys,'/','VIPQ/Trel'])
set_param([sys,'/','VIPQ/Trel'],...
		'Port','5',...
		'position',[480,250,500,270])

add_block('built-in/Fcn',[sys,'/','VIPQ/Treluctance '])
set_param([sys,'/','VIPQ/Treluctance '],...
		'Expr','u[2]*u[4]*(xd-xq)',...
		'position',[270,244,440,276])

add_block('built-in/Outport',[sys,'/','VIPQ/|It|'])
set_param([sys,'/','VIPQ/|It|'],...
		'Port','2',...
		'position',[480,100,500,120])

add_block('built-in/Fcn',[sys,'/','VIPQ/terminal current mag'])
set_param([sys,'/','VIPQ/terminal current mag'],...
		'Expr','sqrt(u[2]*u[2] + u[4]*u[4])',...
		'position',[265,97,440,123])

add_block('built-in/Outport',[sys,'/','VIPQ/Pm'])
set_param([sys,'/','VIPQ/Pm'],...
		'Port','3',...
		'position',[480,155,500,175])

add_block('built-in/Fcn',[sys,'/','VIPQ/Pmotor'])
set_param([sys,'/','VIPQ/Pmotor'],...
		'Expr','u[1]*u[2] + u[3]*u[4]',...
		'position',[265,150,440,180])

add_block('built-in/Outport',[sys,'/','VIPQ/Qm'])
set_param([sys,'/','VIPQ/Qm'],...
		'Port','4',...
		'position',[480,205,500,225])

add_block('built-in/Fcn',[sys,'/','VIPQ/Qmotor'])
set_param([sys,'/','VIPQ/Qmotor'],...
		'Expr','u[1]*u[4]-u[2]*u[3]',...
		'position',[270,201,440,229])

add_block('built-in/Fcn',[sys,'/','VIPQ/terminal voltage mag'])
set_param([sys,'/','VIPQ/terminal voltage mag'],...
		'Expr','sqrt(u[1]*u[1] + u[3]*u[3])',...
		'position',[270,47,440,73])

add_block('built-in/Outport',[sys,'/','VIPQ/|Vt|'])
set_param([sys,'/','VIPQ/|Vt|'],...
		'position',[480,50,500,70])

add_block('built-in/Inport',[sys,'/','VIPQ/id'])
set_param([sys,'/','VIPQ/id'],...
		'Port','4',...
		'position',[115,245,135,265])

add_block('built-in/Inport',[sys,'/','VIPQ/vd'])
set_param([sys,'/','VIPQ/vd'],...
		'Port','3',...
		'position',[115,200,135,220])

add_block('built-in/Inport',[sys,'/','VIPQ/iq'])
set_param([sys,'/','VIPQ/iq'],...
		'Port','2',...
		'position',[115,155,135,175])

add_block('built-in/Inport',[sys,'/','VIPQ/vq'])
set_param([sys,'/','VIPQ/vq'],...
		'position',[115,110,135,130])

add_block('built-in/Mux',[sys,'/','VIPQ/Mux'])
set_param([sys,'/','VIPQ/Mux'],...
		'position',[185,96,215,279])
add_line([sys,'/','VIPQ'],[140,120;180,120])
add_line([sys,'/','VIPQ'],[140,165;180,165])
add_line([sys,'/','VIPQ'],[140,210;180,210])
add_line([sys,'/','VIPQ'],[140,255;180,255])
add_line([sys,'/','VIPQ'],[220,190;240,190;240,165;260,165])
add_line([sys,'/','VIPQ'],[445,165;475,165])
add_line([sys,'/','VIPQ'],[445,215;475,215])
add_line([sys,'/','VIPQ'],[220,190;240,190;240,215;265,215])
add_line([sys,'/','VIPQ'],[445,60;475,60])
add_line([sys,'/','VIPQ'],[445,110;475,110])
add_line([sys,'/','VIPQ'],[220,190;240,190;240,60;265,60])
add_line([sys,'/','VIPQ'],[220,190;240,190;240,110;260,110])
add_line([sys,'/','VIPQ'],[220,190;240,190;240,260;265,260])
add_line([sys,'/','VIPQ'],[445,260;475,260])
add_line([sys,'/','VIPQ'],[440,310;475,310])
add_line([sys,'/','VIPQ'],[220,190;240,190;240,310;265,310])


%     Finished composite block 'VIPQ'.

set_param([sys,'/','VIPQ'],...
		'orientation',3,...
		'position',[251,115,354,135])

add_block('built-in/Mux',[sys,'/','Mux'])
set_param([sys,'/','Mux'],...
		'orientation',3,...
		'inputs','9',...
		'position',[223,60,537,80])

add_block('built-in/Note',[sys,'/','id'])
set_param([sys,'/','id'],...
		'position',[360,265,365,270])

add_block('built-in/Note',[sys,'/','delta'])
set_param([sys,'/','delta'],...
		'position',[365,185,370,190])

add_block('built-in/Note',[sys,'/','iq'])
set_param([sys,'/','iq'],...
		'position',[360,165,365,170])

add_block('built-in/Note',[sys,'/','ia'])
set_param([sys,'/','ia'],...
		'position',[595,150,600,155])

add_block('built-in/Constant',[sys,'/','Ipm'])
set_param([sys,'/','Ipm'],...
		'Value','Ipm',...
		'position',[235,240,265,260])

add_block('built-in/Clock',[sys,'/','Clock'])
set_param([sys,'/','Clock'],...
		'position',[175,100,195,120])


%     Subsystem  'm4'.

new_system([sys,'/','m4'])
set_param([sys,'/','m4'],'Location',[200,4653208,260,4653268])

add_block('built-in/Note',[sys,'/',['m4/Masked block of m4.m to',13,'initialize s4.m and plot results']])
set_param([sys,'/',['m4/Masked block of m4.m to',13,'initialize s4.m and plot results']],...
		'position',[10,45,15,50])
set_param([sys,'/','m4'],...
		'Mask Display','Initialize\nand plot',...
		'Mask Type','Masked block of m4.m',...
		'Mask Dialogue','eval(''m4'')',...
		'Mask Help','Uses m4.m to initialize and plot')


%     Finished composite block 'm4'.

set_param([sys,'/','m4'],...
		'Drop Shadow',4,...
		'position',[70,53,159,95])

add_block('built-in/To Workspace',[sys,'/','Workspace'])
set_param([sys,'/','Workspace'],...
		'orientation',2,...
		'mat-name','y',...
		'buffer','100000',...
		'position',[310,15,330,35])

add_block('built-in/Scope',[sys,'/','sm1'])
set_param([sys,'/','sm1'],...
		'Vgain','3.000000',...
		'Hgain','1.500000',...
		'Vmax','6.000000',...
		'Hmax','3.000000',...
		'Window',[22,407,780,565])
open_system([sys,'/','sm1'])
set_param([sys,'/','sm1'],...
		'position',[430,13,450,37])
add_line(sys,[480,215;540,215])
add_line(sys,[480,230;540,230])
add_line(sys,[205,220;285,220])
add_line(sys,[380,55;380,25;335,25])
add_line(sys,[205,190;285,190])
add_line(sys,[95,260;115,260;115,220;155,220])
add_line(sys,[95,220;105,220;105,200;155,200])
add_line(sys,[95,180;155,180])
add_line(sys,[480,215;480,325;125,325;125,240;155,240])
add_line(sys,[480,230;490,230;490,315;140,315;140,260;155,260])
add_line(sys,[205,190;265,190;265,140])
add_line(sys,[350,185;355,185;355,170;540,170])
add_line(sys,[350,185;355,185;355,160;290,160;290,140])
add_line(sys,[350,225;445,225])
add_line(sys,[350,285;400,285;400,185;540,185])
add_line(sys,[350,285;400,285;400,155;340,155;340,140])
add_line(sys,[240,280;285,280])
add_line(sys,[205,220;235,220;235,165;315,165;315,140])
add_line(sys,[380,55;380,25;425,25])
add_line(sys,[295,110;295,105;275,105;275,85])
add_line(sys,[310,110;310,85])
add_line(sys,[200,110;240,110;240,85])
add_line(sys,[585,170;610,170;610,130;520,130;520,85])
add_line(sys,[350,245;435,245;435,155;485,155;485,85])
add_line(sys,[350,225;425,225;425,145;450,145;450,85])
add_line(sys,[350,205;415,205;415,85])
add_line(sys,[340,110;340,105;380,105;380,85])
add_line(sys,[325,110;325,100;345,100;345,85])
add_line(sys,[270,250;285,250])

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
