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
     set_param(sys,'Location',[16,40,762,502])
     open_system(sys)
end;
set_param(sys,'algorithm',     'RK-45')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     'tstop')
set_param(sys,'Min step size', '1e-4')
set_param(sys,'Max step size', '5e-3')
set_param(sys,'Relative error','5e-6')
set_param(sys,'Return vars',   '')


%     Subsystem  'osc'.

new_system([sys,'/','osc'])
set_param([sys,'/','osc'],'Location',[280,55,870,299])

add_block('built-in/Gain',[sys,'/','osc/Gain'])
set_param([sys,'/','osc/Gain'],...
		'Gain','-wb',...
		'position',[135,63,180,97])

add_block('built-in/Product',[sys,'/','osc/Product'])
set_param([sys,'/','osc/Product'],...
		'position',[370,43,390,92])

add_block('built-in/Integrator',[sys,'/','osc/cos'])
set_param([sys,'/','osc/cos'],...
		'Initial','cos(thetaro)',...
		'position',[215,63,245,97])

add_block('built-in/Inport',[sys,'/','osc/wr//wb'])
set_param([sys,'/','osc/wr//wb'],...
		'position',[30,45,50,65])

add_block('built-in/Integrator',[sys,'/','osc/sin'])
set_param([sys,'/','osc/sin'],...
		'orientation',2,...
		'Initial','sin(thetaro)',...
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
		'position',[605,276,640,314])

add_block('built-in/Note',[sys,'/','vcg'])
set_param([sys,'/','vcg'],...
		'position',[215,320,220,325])

add_block('built-in/Note',[sys,'/','vbg'])
set_param([sys,'/','vbg'],...
		'position',[205,275,210,280])

add_block('built-in/Fcn',[sys,'/','Fcn'])
set_param([sys,'/','Fcn'],...
		'Expr','u[2]*cos(u[1] )',...
		'position',[65,237,180,263])


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
		'position',[320,340,345,360])

add_block('built-in/Note',[sys,'/','vd'])
set_param([sys,'/','vd'],...
		'position',[345,270,350,275])

add_block('built-in/Note',[sys,'/','vq'])
set_param([sys,'/','vq'],...
		'position',[355,240,360,245])


%     Subsystem  'abc2qd0'.

new_system([sys,'/','abc2qd0'])
set_param([sys,'/','abc2qd0'],'Location',[454,254,1125,632])

add_block('built-in/Outport',[sys,'/','abc2qd0/vq'])
set_param([sys,'/','abc2qd0/vq'],...
		'position',[595,70,615,90])

add_block('built-in/Outport',[sys,'/','abc2qd0/vd'])
set_param([sys,'/','abc2qd0/vd'],...
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
		'position',[270,242,310,338])

add_block('built-in/Note',[sys,'/','sin (wrt)'])
set_param([sys,'/','sin (wrt)'],...
		'position',[590,365,595,370])

add_block('built-in/Note',[sys,'/','cos (wrt)'])
set_param([sys,'/','cos (wrt)'],...
		'position',[590,385,595,390])

add_block('built-in/Clock',[sys,'/','Clock'])
set_param([sys,'/','Clock'],...
		'orientation',3,...
		'position',[214,165,236,185])

add_block('built-in/Note',[sys,'/','Tem'])
set_param([sys,'/','Tem'],...
		'position',[470,295,475,300])

add_block('built-in/Note',[sys,'/','delta'])
set_param([sys,'/','delta'],...
		'position',[470,255,475,260])

add_block('built-in/Note',[sys,'/','id_gen'])
set_param([sys,'/','id_gen'],...
		'position',[475,335,480,340])

add_block('built-in/Note',[sys,'/','wr//wb'])
set_param([sys,'/','wr//wb'],...
		'position',[475,275,480,280])


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
		'position',[345,310,375,330])


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

add_block('built-in/Outport',[sys,'/','qd_gen/id_gen'])
set_param([sys,'/','qd_gen/id_gen'],...
		'Port','6',...
		'position',[240,310,260,330])


%     Subsystem  'qd_gen/d_cct'.

new_system([sys,'/','qd_gen/d_cct'])
set_param([sys,'/','qd_gen/d_cct'],'Location',[148,276,1097,793])

add_block('built-in/Outport',[sys,'/','qd_gen/d_cct/Out_psid'])
set_param([sys,'/','qd_gen/d_cct/Out_psid'],...
		'position',[585,45,605,65])

add_block('built-in/Inport',[sys,'/','qd_gen/d_cct/In_Ef'])
set_param([sys,'/','qd_gen/d_cct/In_Ef'],...
		'Port','3',...
		'position',[50,250,70,270])

add_block('built-in/Outport',[sys,'/','qd_gen/d_cct/Out_ipf'])
set_param([sys,'/','qd_gen/d_cct/Out_ipf'],...
		'Port','4',...
		'position',[835,335,855,355])

add_block('built-in/Outport',[sys,'/','qd_gen/d_cct/Out_-id'])
set_param([sys,'/','qd_gen/d_cct/Out_-id'],...
		'Port','2',...
		'position',[830,230,850,250])

add_block('built-in/Outport',[sys,'/','qd_gen/d_cct/Out_psimd'])
set_param([sys,'/','qd_gen/d_cct/Out_psimd'],...
		'Port','3',...
		'position',[835,120,855,140])

add_block('built-in/Fcn',[sys,'/','qd_gen/d_cct/Fcn5'])
set_param([sys,'/','qd_gen/d_cct/Fcn5'],...
		'Expr','(u[1]-u[2])/xplf',...
		'position',[565,332,655,358])

add_block('built-in/Mux',[sys,'/','qd_gen/d_cct/Mux5'])
set_param([sys,'/','qd_gen/d_cct/Mux5'],...
		'inputs','2',...
		'position',[520,309,540,376])

add_block('built-in/Mux',[sys,'/','qd_gen/d_cct/Mux4'])
set_param([sys,'/','qd_gen/d_cct/Mux4'],...
		'inputs','2',...
		'position',[520,204,540,271])

add_block('built-in/Fcn',[sys,'/','qd_gen/d_cct/Fcn4'])
set_param([sys,'/','qd_gen/d_cct/Fcn4'],...
		'Expr','-(u[1]-u[2])/xls',...
		'position',[565,227,655,253])

add_block('built-in/Fcn',[sys,'/','qd_gen/d_cct/Fcn3'])
set_param([sys,'/','qd_gen/d_cct/Fcn3'],...
		'Expr','xMD*(u[1]/xls+u[2]/xplf+u[3]/xplkd)',...
		'position',[565,114,775,146])

add_block('built-in/Mux',[sys,'/','qd_gen/d_cct/Mux3'])
set_param([sys,'/','qd_gen/d_cct/Mux3'],...
		'inputs','3',...
		'position',[520,87,545,173])

add_block('built-in/Integrator',[sys,'/','qd_gen/d_cct/psipkd_'])
set_param([sys,'/','qd_gen/d_cct/psipkd_'],...
		'Initial','Psikdo',...
		'position',[390,357,420,383])

add_block('built-in/Fcn',[sys,'/','qd_gen/d_cct/Fcn2'])
set_param([sys,'/','qd_gen/d_cct/Fcn2'],...
		'Expr','wb*rpkd*(u[1]-u[2])/xplkd',...
		'position',[180,356,365,384])

add_block('built-in/Integrator',[sys,'/','qd_gen/d_cct/psipf_'])
set_param([sys,'/','qd_gen/d_cct/psipf_'],...
		'Initial','Psifo',...
		'position',[390,247,420,273])

add_block('built-in/Fcn',[sys,'/','qd_gen/d_cct/Fcn1'])
set_param([sys,'/','qd_gen/d_cct/Fcn1'],...
		'Expr','wb*rpf*(u[2]/xmd+(u[1]-u[3])/xplf)',...
		'position',[175,245,375,275])

add_block('built-in/Integrator',[sys,'/','qd_gen/d_cct/psid_'])
set_param([sys,'/','qd_gen/d_cct/psid_'],...
		'Initial','Psido',...
		'position',[390,127,420,153])

add_block('built-in/Mux',[sys,'/','qd_gen/d_cct/Mux2'])
set_param([sys,'/','qd_gen/d_cct/Mux2'],...
		'inputs','2',...
		'position',[130,330,155,405])

add_block('built-in/Mux',[sys,'/','qd_gen/d_cct/Mux1'])
set_param([sys,'/','qd_gen/d_cct/Mux1'],...
		'inputs','3',...
		'position',[135,217,160,303])

add_block('built-in/Fcn',[sys,'/','qd_gen/d_cct/Fcn'])
set_param([sys,'/','qd_gen/d_cct/Fcn'],...
		'Expr','wb*(u[2]+u[3]+(rs/xls)*(u[1]-u[4]))',...
		'position',[180,125,375,155])

add_block('built-in/Inport',[sys,'/','qd_gen/d_cct/In_wrpsiq'])
set_param([sys,'/','qd_gen/d_cct/In_wrpsiq'],...
		'Port','2',...
		'position',[50,160,70,180])

add_block('built-in/Inport',[sys,'/','qd_gen/d_cct/In_vd'])
set_param([sys,'/','qd_gen/d_cct/In_vd'],...
		'position',[50,105,70,125])

add_block('built-in/Mux',[sys,'/','qd_gen/d_cct/Mux'])
set_param([sys,'/','qd_gen/d_cct/Mux'],...
		'position',[135,86,160,189])

add_block('built-in/Scope',[sys,'/','qd_gen/d_cct/daxis_Scope'])
set_param([sys,'/','qd_gen/d_cct/daxis_Scope'],...
		'Vgain','3.000000',...
		'Hgain','0.050000',...
		'Vmax','6.000000',...
		'Hmax','2.000000',...
		'Window',[451,130,627,387],...
		'position',[835,402,855,428])
add_line([sys,'/','qd_gen/d_cct'],[75,170;95,170;95,150;130,150])
add_line([sys,'/','qd_gen/d_cct'],[75,115;95,115;95,125;130,125])
add_line([sys,'/','qd_gen/d_cct'],[165,140;175,140])
add_line([sys,'/','qd_gen/d_cct'],[380,140;385,140])
add_line([sys,'/','qd_gen/d_cct'],[425,140;435,140;435,205;115,205;115,175;130,175])
add_line([sys,'/','qd_gen/d_cct'],[165,260;170,260])
add_line([sys,'/','qd_gen/d_cct'],[380,260;385,260])
add_line([sys,'/','qd_gen/d_cct'],[425,260;450,260;450,320;115,320;115,290;130,290])
add_line([sys,'/','qd_gen/d_cct'],[75,260;130,260])
add_line([sys,'/','qd_gen/d_cct'],[160,370;175,370])
add_line([sys,'/','qd_gen/d_cct'],[370,370;385,370])
add_line([sys,'/','qd_gen/d_cct'],[425,370;460,370;460,430;110,430;110,385;125,385])
add_line([sys,'/','qd_gen/d_cct'],[425,140;435,140;435,100;515,100])
add_line([sys,'/','qd_gen/d_cct'],[425,260;450,260;450,130;515,130])
add_line([sys,'/','qd_gen/d_cct'],[425,370;460,370;460,160;515,160])
add_line([sys,'/','qd_gen/d_cct'],[550,130;560,130])
add_line([sys,'/','qd_gen/d_cct'],[545,240;560,240])
add_line([sys,'/','qd_gen/d_cct'],[425,140;470,140;470,220;515,220])
add_line([sys,'/','qd_gen/d_cct'],[545,345;560,345])
add_line([sys,'/','qd_gen/d_cct'],[425,260;485,260;485,325;515,325])
add_line([sys,'/','qd_gen/d_cct'],[780,130;790,130;790,445;495,445;495,360;515,360])
add_line([sys,'/','qd_gen/d_cct'],[780,130;790,130;790,305;495,305;495,255;515,255])
add_line([sys,'/','qd_gen/d_cct'],[780,130;790,130;790,445;90,445;90,350;125,350])
add_line([sys,'/','qd_gen/d_cct'],[780,130;790,130;790,445;90,445;90,230;130,230])
add_line([sys,'/','qd_gen/d_cct'],[780,130;790,130;790,80;115,80;115,100;130,100])
add_line([sys,'/','qd_gen/d_cct'],[780,130;830,130])
add_line([sys,'/','qd_gen/d_cct'],[660,240;825,240])
add_line([sys,'/','qd_gen/d_cct'],[660,345;830,345])
add_line([sys,'/','qd_gen/d_cct'],[425,140;435,140;435,55;580,55])


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
set_param([sys,'/','qd_gen/q_cct'],'Location',[168,276,1117,793])

add_block('built-in/Outport',[sys,'/','qd_gen/q_cct/Out_psiq'])
set_param([sys,'/','qd_gen/q_cct/Out_psiq'],...
		'position',[585,45,605,65])

add_block('built-in/Integrator',[sys,'/','qd_gen/q_cct/psiq_'])
set_param([sys,'/','qd_gen/q_cct/psiq_'],...
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
		'inputs','2',...
		'position',[515,124,540,191])

add_block('built-in/Mux',[sys,'/','qd_gen/q_cct/Mux4'])
set_param([sys,'/','qd_gen/q_cct/Mux4'],...
		'inputs','2',...
		'position',[515,214,540,281])

add_block('built-in/Fcn',[sys,'/','qd_gen/q_cct/Fcn4'])
set_param([sys,'/','qd_gen/q_cct/Fcn4'],...
		'Expr','-(u[1]-u[2])/xls',...
		'position',[575,237,665,263])

add_block('built-in/Fcn',[sys,'/','qd_gen/q_cct/Fcn3'])
set_param([sys,'/','qd_gen/q_cct/Fcn3'],...
		'Expr','xMQ*(u[1]/xls+u[2]/xplkq)',...
		'position',[565,146,720,174])

add_block('built-in/Outport',[sys,'/','qd_gen/q_cct/Out_psimq'])
set_param([sys,'/','qd_gen/q_cct/Out_psimq'],...
		'Port','3',...
		'position',[830,150,850,170])

add_block('built-in/Outport',[sys,'/','qd_gen/q_cct/Out_-iq'])
set_param([sys,'/','qd_gen/q_cct/Out_-iq'],...
		'Port','2',...
		'position',[830,240,850,260])

add_block('built-in/Mux',[sys,'/','qd_gen/q_cct/Mux2'])
set_param([sys,'/','qd_gen/q_cct/Mux2'],...
		'inputs','2',...
		'position',[130,220,155,295])

add_block('built-in/Fcn',[sys,'/','qd_gen/q_cct/Fcn2'])
set_param([sys,'/','qd_gen/q_cct/Fcn2'],...
		'Expr','wb*rpkq*(u[1]-u[2])/xplkq',...
		'position',[180,246,365,274])

add_block('built-in/Integrator',[sys,'/','qd_gen/q_cct/psipkq_'])
set_param([sys,'/','qd_gen/q_cct/psipkq_'],...
		'Initial','Psikqo',...
		'position',[390,247,420,273])

add_block('built-in/Scope',[sys,'/','qd_gen/q_cct/qaxis_Scope'])
set_param([sys,'/','qd_gen/q_cct/qaxis_Scope'],...
		'Vgain','3.000000',...
		'Hgain','0.050000',...
		'Vmax','6.000000',...
		'Hmax','2.000000',...
		'Window',[451,130,627,387],...
		'position',[825,292,845,318])
add_line([sys,'/','qd_gen/q_cct'],[75,170;95,170;95,150;130,150])
add_line([sys,'/','qd_gen/q_cct'],[75,115;95,115;95,125;130,125])
add_line([sys,'/','qd_gen/q_cct'],[165,140;175,140])
add_line([sys,'/','qd_gen/q_cct'],[380,140;385,140])
add_line([sys,'/','qd_gen/q_cct'],[425,140;435,140;435,205;115,205;115,175;130,175])
add_line([sys,'/','qd_gen/q_cct'],[160,260;175,260])
add_line([sys,'/','qd_gen/q_cct'],[370,260;385,260])
add_line([sys,'/','qd_gen/q_cct'],[425,260;460,260;460,320;110,320;110,275;125,275])
add_line([sys,'/','qd_gen/q_cct'],[425,140;510,140])
add_line([sys,'/','qd_gen/q_cct'],[545,160;560,160])
add_line([sys,'/','qd_gen/q_cct'],[545,250;570,250])
add_line([sys,'/','qd_gen/q_cct'],[425,140;470,140;470,230;510,230])
add_line([sys,'/','qd_gen/q_cct'],[725,160;790,160;790,345;495,345;495,265;510,265])
add_line([sys,'/','qd_gen/q_cct'],[725,160;790,160;790,345;90,345;90,240;125,240])
add_line([sys,'/','qd_gen/q_cct'],[725,160;790,160;790,80;115,80;115,100;130,100])
add_line([sys,'/','qd_gen/q_cct'],[725,160;825,160])
add_line([sys,'/','qd_gen/q_cct'],[670,250;825,250])
add_line([sys,'/','qd_gen/q_cct'],[425,140;435,140;435,55;580,55])
add_line([sys,'/','qd_gen/q_cct'],[425,260;460,260;460,175;510,175])


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

add_block('built-in/Outport',[sys,'/','qd_gen/ipf'])
set_param([sys,'/','qd_gen/ipf'],...
		'orientation',1,...
		'Port','5',...
		'position',[195,345,215,365])
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
add_line([sys,'/','qd_gen'],[195,320;205,320;205,340])


%     Finished composite block 'qd_gen'.

set_param([sys,'/','qd_gen'],...
		'position',[395,241,450,369])

add_block('built-in/Note',[sys,'/','v0'])
set_param([sys,'/','v0'],...
		'position',[320,305,325,310])


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
		'position',[130,187,195,213])

add_block('built-in/Gain',[sys,'/','omega*t'])
set_param([sys,'/','omega*t'],...
		'orientation',2,...
		'Gain','120*pi',...
		'position',[125,132,185,168])

add_block('built-in/Mux',[sys,'/','Mux1'])
set_param([sys,'/','Mux1'],...
		'orientation',2,...
		'inputs','2',...
		'position',[60,134,85,196])

add_block('built-in/Fcn',[sys,'/','Fcn2'])
set_param([sys,'/','Fcn2'],...
		'Expr','u[2]*cos(u[1]+T2piby3)',...
		'position',[65,327,195,353])

add_block('built-in/Fcn',[sys,'/','Fcn1'])
set_param([sys,'/','Fcn1'],...
		'Expr','u[2]*cos(u[1]-T2piby3)',...
		'position',[60,282,190,308])

add_block('built-in/Note',[sys,'/','vag'])
set_param([sys,'/','vag'],...
		'position',[200,225,205,230])

add_block('built-in/To Workspace',[sys,'/','Workspace'])
set_param([sys,'/','Workspace'],...
		'mat-name','y',...
		'buffer','100000',...
		'position',[550,55,570,75])

add_block('built-in/Scope',[sys,'/','sm1'])
set_param([sys,'/','sm1'],...
		'orientation',2,...
		'Vgain','2.000000',...
		'Hgain','5.000000',...
		'Vmax','4.000000',...
		'Hmax','10.000000',...
		'Window',[9,421,800,600])
open_system([sys,'/','sm1'])
set_param([sys,'/','sm1'],...
		'position',[315,52,340,78])


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
		'position',[632,160,688,190])

add_block('built-in/Note',[sys,'/','ia'])
set_param([sys,'/','ia'],...
		'orientation',3,...
		'position',[635,135,640,140])

add_block('built-in/Note',[sys,'/','iq_gen'])
set_param([sys,'/','iq_gen'],...
		'position',[470,235,475,240])

add_block('built-in/Mux',[sys,'/','Mux'])
set_param([sys,'/','Mux'],...
		'orientation',3,...
		'inputs','9',...
		'position',[240,95,660,115])


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
		'position',[298,160,422,195])


%     Subsystem  'm1'.

new_system([sys,'/','m1'])
set_param([sys,'/','m1'],'Location',[150,1048646,275,1048716])

add_block('built-in/Note',[sys,'/',['m1/Masked block of m1.m to',13,'initialize and print results']])
set_param([sys,'/',['m1/Masked block of m1.m to',13,'initialize and print results']],...
		'position',[80,40,85,45])
set_param([sys,'/','m1'],...
		'Mask Display','Initialize\nand plot',...
		'Mask Type','Masked block of m1.m',...
		'Mask Dialogue','eval(''m1'')',...
		'Mask Help','Uses m1.m to initialize and plot')


%     Finished composite block 'm1'.

set_param([sys,'/','m1'],...
		'Drop Shadow',4,...
		'position',[137,50,225,85])
add_line(sys,[645,285;670,285;670,195])
add_line(sys,[645,305;680,305;680,195])
add_line(sys,[315,290;390,290])
add_line(sys,[450,90;450,65;545,65])
add_line(sys,[315,260;390,260])
add_line(sys,[645,285;670,285;670,405;240,405;240,310;265,310])
add_line(sys,[645,305;680,305;680,385;250,385;250,330;265,330])
add_line(sys,[315,260;315,200])
add_line(sys,[455,255;470,255;470,225;640,225;640,195])
add_line(sys,[455,255;470,255;470,225;345,225;345,200])
add_line(sys,[455,295;600,295])
add_line(sys,[455,355;565,355;565,215;650,215;650,195])
add_line(sys,[455,355;565,355;565,215;405,215;405,200])
add_line(sys,[380,320;390,320])
add_line(sys,[350,350;390,350])
add_line(sys,[315,155;315,120])
add_line(sys,[315,290;375,290;375,200])
add_line(sys,[450,90;450,65;345,65])
add_line(sys,[225,160;225,150;270,150;270,120])
add_line(sys,[225,160;225,150;190,150])
add_line(sys,[120,150;90,150])
add_line(sys,[125,200;120,200;120,180;90,180])
add_line(sys,[55,165;40,165;40,250;60,250])
add_line(sys,[55,165;40,165;40,295;55,295])
add_line(sys,[55,165;40,165;40,340;60,340])
add_line(sys,[185,250;265,250])
add_line(sys,[195,295;225,295;225,270;265,270])
add_line(sys,[200,340;235,340;235,290;265,290])
add_line(sys,[640,155;640,150;630,150;630,120])
add_line(sys,[455,335;585,335;585,120])
add_line(sys,[455,315;540,315;540,120])
add_line(sys,[455,275;495,275;495,120])
add_line(sys,[405,155;405,150;450,150;450,120])
add_line(sys,[375,155;375,140;405,140;405,120])
add_line(sys,[345,155;345,140;360,140;360,120])

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
