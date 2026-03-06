function [ret,x0,str,ts,xts]=smg(t,x,u,flag);
%smg	is the M-file description of the SIMULINK system named smg.
%	The block-diagram can be displayed by typing: smg.
%
%	SYS=smg(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes smg to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling smg with a FLAG of zero:
%	[SIZES]=smg([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[238,75,977,424])
     open_system(sys)
end;
set_param(sys,'algorithm',     'RK-45')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     'tstop')
set_param(sys,'Min step size', '1e-6')
set_param(sys,'Max step size', '1e-2')
set_param(sys,'Relative error','1e-5')
set_param(sys,'Return vars',   '')


%     Subsystem  'mgplt'.

new_system([sys,'/','mgplt'])
set_param([sys,'/','mgplt'],'Location',[190,4915828,670,4915956])

add_block('built-in/Note',[sys,'/','mgplt/Masked block of mgplt.M'])
set_param([sys,'/','mgplt/Masked block of mgplt.M'],...
		'position',[205,50,210,55])
set_param([sys,'/','mgplt'],...
		'Mask Display','Plot',...
		'Mask Type','Masked block of mgplt.M',...
		'Mask Dialogue','eval(''mgplt'')',...
		'Mask Help','Uses mgplt.M to plot results')


%     Finished composite block 'mgplt'.

set_param([sys,'/','mgplt'],...
		'Drop Shadow',4,...
		'position',[185,79,248,115])


%     Subsystem  'mginit'.

new_system([sys,'/','mginit'])
set_param([sys,'/','mginit'],'Location',[175,4915798,506,4915904])

add_block('built-in/Note',[sys,'/','mginit/Masked block of mginit.M '])
set_param([sys,'/','mginit/Masked block of mginit.M '],...
		'position',[155,45,160,50])
set_param([sys,'/','mginit'],...
		'Mask Display','Initialize',...
		'Mask Type','Masked block of mginit.M',...
		'Mask Dialogue','eval(''mginit'')',...
		'Mask Help','Uses mginit.M to initialize simulation')


%     Finished composite block 'mginit'.

set_param([sys,'/','mginit'],...
		'Drop Shadow',4,...
		'position',[101,77,165,113])

add_block('built-in/Sine Wave',[sys,'/',['Voltage',13,'Amplitude',13,'Variation']])
set_param([sys,'/',['Voltage',13,'Amplitude',13,'Variation']],...
		'amplitude','Vmaxrms',...
		'frequency','pi/tstop',...
		'position',[85,261,115,289])

add_block('built-in/Mux',[sys,'/','Mux'])
set_param([sys,'/','Mux'],...
		'inputs','2',...
		'position',[155,196,185,229])

add_block('built-in/Fcn',[sys,'/',['sine ',13,'voltage']])
set_param([sys,'/',['sine ',13,'voltage']],...
		'Expr','sqrt(2)*u[2]*sin(we*u[1])',...
		'position',[210,203,260,227])

add_block('built-in/Look Up Table',[sys,'/','Psi vs i'])
set_param([sys,'/','Psi vs i'],...
		'Input_Values','psifull',...
		'Output_Values','ifull',...
		'position',[305,191,365,239])


%     Subsystem  ['Inner',13,'Product1'].

new_system([sys,'/',['Inner',13,'Product1']])
set_param([sys,'/',['Inner',13,'Product1']],'Location',[33,479,253,634])

add_block('built-in/Product',[sys,'/',['Inner',13,'Product1/Product']])
set_param([sys,'/',['Inner',13,'Product1/Product']],...
		'position',[65,55,90,75])

add_block('built-in/Sum',[sys,'/',['Inner',13,'Product1/Sum']])
set_param([sys,'/',['Inner',13,'Product1/Sum']],...
		'inputs','+',...
		'position',[125,55,145,75])

add_block('built-in/Outport',[sys,'/',['Inner',13,'Product1/out_1']])
set_param([sys,'/',['Inner',13,'Product1/out_1']],...
		'position',[185,55,205,75])

add_block('built-in/Inport',[sys,'/',['Inner',13,'Product1/in_2']])
set_param([sys,'/',['Inner',13,'Product1/in_2']],...
		'Port','2',...
		'position',[15,90,35,110])

add_block('built-in/Inport',[sys,'/',['Inner',13,'Product1/in_1']])
set_param([sys,'/',['Inner',13,'Product1/in_1']],...
		'position',[15,25,35,45])
add_line([sys,'/',['Inner',13,'Product1']],[40,100;60,70])
add_line([sys,'/',['Inner',13,'Product1']],[40,35;60,60])
add_line([sys,'/',['Inner',13,'Product1']],[95,65;120,65])
add_line([sys,'/',['Inner',13,'Product1']],[150,65;180,65])
set_param([sys,'/',['Inner',13,'Product1']],...
		'Mask Display','.\n',...
		'Mask Type','Dot Product',...
		'Mask Dialogue','Inner (dot) product.\ny=sum(u1.*u2)')
set_param([sys,'/',['Inner',13,'Product1']],...
		'Mask Help','Computes the inner (dot) product of the inputs: sum(u1.*u2).  The inputs are vectors of the same length. Output is a scalar.')


%     Finished composite block ['Inner',13,'Product1'].

set_param([sys,'/',['Inner',13,'Product1']],...
		'position',[410,109,430,131])

add_block('built-in/Sum',[sys,'/','Sum'])
set_param([sys,'/','Sum'],...
		'inputs','+-',...
		'position',[590,112,605,148])


%     Subsystem  ['Inner',13,'Product2'].

new_system([sys,'/',['Inner',13,'Product2']])
set_param([sys,'/',['Inner',13,'Product2']],'Location',[33,479,253,634])

add_block('built-in/Product',[sys,'/',['Inner',13,'Product2/Product']])
set_param([sys,'/',['Inner',13,'Product2/Product']],...
		'position',[65,55,90,75])

add_block('built-in/Sum',[sys,'/',['Inner',13,'Product2/Sum']])
set_param([sys,'/',['Inner',13,'Product2/Sum']],...
		'inputs','+',...
		'position',[125,55,145,75])

add_block('built-in/Outport',[sys,'/',['Inner',13,'Product2/out_1']])
set_param([sys,'/',['Inner',13,'Product2/out_1']],...
		'position',[185,55,205,75])

add_block('built-in/Inport',[sys,'/',['Inner',13,'Product2/in_2']])
set_param([sys,'/',['Inner',13,'Product2/in_2']],...
		'Port','2',...
		'position',[15,90,35,110])

add_block('built-in/Inport',[sys,'/',['Inner',13,'Product2/in_1']])
set_param([sys,'/',['Inner',13,'Product2/in_1']],...
		'position',[15,25,35,45])
add_line([sys,'/',['Inner',13,'Product2']],[40,100;60,70])
add_line([sys,'/',['Inner',13,'Product2']],[40,35;60,60])
add_line([sys,'/',['Inner',13,'Product2']],[95,65;120,65])
add_line([sys,'/',['Inner',13,'Product2']],[150,65;180,65])
set_param([sys,'/',['Inner',13,'Product2']],...
		'Mask Display','.\n',...
		'Mask Type','Dot Product',...
		'Mask Dialogue','Inner (dot) product.\ny=sum(u1.*u2)')
set_param([sys,'/',['Inner',13,'Product2']],...
		'Mask Help','Computes the inner (dot) product of the inputs: sum(u1.*u2).  The inputs are vectors of the same length. Output is a scalar.')


%     Finished composite block ['Inner',13,'Product2'].

set_param([sys,'/',['Inner',13,'Product2']],...
		'position',[410,199,430,221])

add_block('built-in/Sum',[sys,'/','Sum1'])
set_param([sys,'/','Sum1'],...
		'inputs','+-',...
		'position',[590,202,605,238])

add_block('built-in/Look Up Table',[sys,'/',['Scaled ',13,'open-circuit',13,'curve']])
set_param([sys,'/',['Scaled ',13,'open-circuit',13,'curve']],...
		'Input_Values','Vfull',...
		'Output_Values','Ifull',...
		'position',[310,103,370,147])

add_block('built-in/Zero-Pole',[sys,'/',['Butterworth',13,'LP Filter']])
set_param([sys,'/',['Butterworth',13,'LP Filter']],...
		'Zeros','z',...
		'Poles','p',...
		'Gain','k',...
		'Mask Display','plot(20*log10(w),20*log10(abs(h)))',...
		'Mask Type','buttap')
set_param([sys,'/',['Butterworth',13,'LP Filter']],...
		'Mask Dialogue','Analog Butterworth low pass filter.\n\n(Requires Signal Processing Toolbox)|Cutoff frequency (rad/sec)|Order')
set_param([sys,'/',['Butterworth',13,'LP Filter']],...
		'Mask Translate','[z,p,k]=buttap(@2); z=@1*z; p=@1*p; k=real(prod(-p)); [num,den]=zp2tf(z,p,k); w=logspace(log10(@1/10),log10(10*@1),20); h=freqs(num,den,w); ')
set_param([sys,'/',['Butterworth',13,'LP Filter']],...
		'Mask Help','Butterworth low pass filter using MATLAB''s butter command.',...
		'Mask Entries','250\/4\/',...
		'position',[465,101,505,139])

add_block('built-in/Zero-Pole',[sys,'/',['Butterworth',13,'LP Filter1']])
set_param([sys,'/',['Butterworth',13,'LP Filter1']],...
		'Zeros','z',...
		'Poles','p',...
		'Gain','k',...
		'Mask Display','plot(20*log10(w),20*log10(abs(h)))',...
		'Mask Type','buttap')
set_param([sys,'/',['Butterworth',13,'LP Filter1']],...
		'Mask Dialogue','Analog Butterworth low pass filter.\n\n(Requires Signal Processing Toolbox)|Cutoff frequency (rad/sec)|Order')
set_param([sys,'/',['Butterworth',13,'LP Filter1']],...
		'Mask Translate','[z,p,k]=buttap(@2); z=@1*z; p=@1*p; k=real(prod(-p)); [num,den]=zp2tf(z,p,k); w=logspace(log10(@1/10),log10(10*@1),20); h=freqs(num,den,w); ')
set_param([sys,'/',['Butterworth',13,'LP Filter1']],...
		'Mask Help','Butterworth low pass filter using MATLAB''s butter command.',...
		'Mask Entries','250\/4\/',...
		'position',[465,191,505,229])

add_block('built-in/Fcn',[sys,'/','Fcn'])
set_param([sys,'/','Fcn'],...
		'Expr','sqrt(u[1])',...
		'position',[525,106,555,134])

add_block('built-in/Fcn',[sys,'/','Fcn1'])
set_param([sys,'/','Fcn1'],...
		'Expr','sqrt(u[1])',...
		'position',[530,196,560,224])

add_block('built-in/Scope',[sys,'/',['error from',13,'rms curve']])
set_param([sys,'/',['error from',13,'rms curve']],...
		'Vgain','0.100000',...
		'Hgain','3.500000',...
		'Vmax','0.200000',...
		'Hmax','7.000000',...
		'Window',[242,523,607,710])
open_system([sys,'/',['error from',13,'rms curve']])
set_param([sys,'/',['error from',13,'rms curve']],...
		'position',[640,115,670,145])

add_block('built-in/Scope',[sys,'/',['error from ',13,'instantaneous',13,'curve']])
set_param([sys,'/',['error from ',13,'instantaneous',13,'curve']],...
		'Vgain','0.100000',...
		'Hgain','3.500000',...
		'Vmax','0.200000',...
		'Hmax','7.000000',...
		'Window',[629,524,992,712])
open_system([sys,'/',['error from ',13,'instantaneous',13,'curve']])
set_param([sys,'/',['error from ',13,'instantaneous',13,'curve']],...
		'position',[645,205,675,235])

add_block('built-in/To Workspace',[sys,'/','To Workspace'])
set_param([sys,'/','To Workspace'],...
		'mat-name','yin',...
		'buffer','4000',...
		'position',[200,147,250,163])

add_block('built-in/Mux',[sys,'/','Mux1'])
set_param([sys,'/','Mux1'],...
		'inputs','2',...
		'position',[145,136,175,169])

add_block('built-in/Clock',[sys,'/','Clock'])
set_param([sys,'/','Clock'],...
		'position',[85,195,105,215])

add_block('built-in/Note',[sys,'/','Vrms'])
set_param([sys,'/','Vrms'],...
		'position',[170,255,175,260])

add_block('built-in/Look Up Table',[sys,'/',['Open-circuit',13,'curve']])
set_param([sys,'/',['Open-circuit',13,'curve']],...
		'Input_Values','V',...
		'Output_Values','I',...
		'position',[210,253,260,297])

add_block('built-in/Mux',[sys,'/','Mux2'])
set_param([sys,'/','Mux2'],...
		'orientation',2,...
		'inputs','2',...
		'position',[570,286,595,319])

add_block('built-in/To Workspace',[sys,'/','To Workspace1'])
set_param([sys,'/','To Workspace1'],...
		'orientation',2,...
		'mat-name','yout',...
		'buffer','4000',...
		'position',[470,297,520,313])

add_block('built-in/Note',[sys,'/',['Demostration compares error from using the rms open circuit curve ',13,'to that of using the instantaneous psi_sat versus i curve  ']])
set_param([sys,'/',['Demostration compares error from using the rms open circuit curve ',13,'to that of using the instantaneous psi_sat versus i curve  ']],...
		'position',[375,25,380,30])
add_line(sys,[190,215;205,215])
add_line(sys,[110,205;150,205])
add_line(sys,[120,275;140,275;150,220])
add_line(sys,[120,275;205,275])
add_line(sys,[265,215;300,215])
add_line(sys,[265,215;280,215;280,125;305,125])
add_line(sys,[610,130;635,130])
add_line(sys,[610,220;640,220])
add_line(sys,[435,210;460,210])
add_line(sys,[435,120;460,120])
add_line(sys,[375,125;385,125;385,115;405,115])
add_line(sys,[375,125;405,125])
add_line(sys,[370,215;380,215;380,205;405,205])
add_line(sys,[370,215;405,215])
add_line(sys,[560,120;585,120])
add_line(sys,[510,120;520,120])
add_line(sys,[565,210;585,210])
add_line(sys,[510,210;525,210])
add_line(sys,[265,275;570,275;570,230;585,230])
add_line(sys,[265,275;570,275;570,140;585,140])
add_line(sys,[180,155;195,155])
add_line(sys,[110,205;115,205;115,145;140,145])
add_line(sys,[120,275;130,275;140,160])
add_line(sys,[610,220;620,220;620,295;600,295])
add_line(sys,[610,130;625,130;625,310;600,310])
add_line(sys,[565,305;525,305])

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
