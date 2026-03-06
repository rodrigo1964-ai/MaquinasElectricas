This CD-ROM contains the MATLAB and SIMULINK files for the 
exercises in Chapter 2 and for almost all the projects in 
Chapter 3 to 10 of the book:

DYNAMIC SIMULATION OF ELECTRIC MACHINERY by Chee-Mun Ong,
published by Prentice-Hall, Copyright 1997 Chee-Mun Ong

Files for the Macintosh, Unix, and Window operating systems are 
placed in separate folders. Within these main folders are 
sub folders, C2 through C10, labelled in accordance with the 
chapter number of the text. 

In general, filenames beginning with the letter M are MATLAB 
M-files and those beginning with the letter S are SIMULINK files. 
The MATLAB files will run on MATLAB 4.2 and the new MATLAB 5.
SIMULINK files for version 1 and 2 are, however, slightly different. 
For convenience I have included the files for both SIMULINK 1 and 2. 
Those for SIMULINK 1 have a .m filename extension and those for 
SIMULINK 2 have a .mdl filename extension.  For example, the MATLAB 
M-file for project No. 3, m3.m say, will typically be associated with 
s3.m for SIMULINK 1 and with s3.mdl for SIMULINK 2.

To view or run a SIMULINK file, first move to the directory 
containing the SIMULINK file, then use the open file command 
under the SIMULINK menu to select and open the SIMULINK file. 
If there are parameters in a lookup table or a repeating-sequence 
block that are not initialized, there will be error/warning messages 
saying so at the time when the file is first open. Within most of the 
SIMULINK files, I have placed a masked block of the M file that
you can use to initialize the simulation. Double-click on the masked 
M FILE block and respond to the prompts in the MATLAB command window
to properly initialize the simulation with parameters and operating 
condition, and to run the simulation. 
 
The given files have been tested on MATLAB Version 4.2c and
SIMULINK Version 1.0a and on the pre-release MATLAB Version 5 and 
SIMULINK Version 2.

Also included in the CD-ROM are the following utility files:   

fftplot.m  - for computing and plotting the fft of a variable. 
                  The variable value and time are stored in row arrays. 
             
sizeplot.m - for resizing the figure window 

These utility files should be placed in a directory that is on the 
MATLAB's search path, for example, in the MATLAB/bin directory.

Depending on the display resolution used, the SIMULINK screen window 
on your computer monitor may or may not display the given SIMULINK 
simulations in full. The screen's view can be increased by setting 
the display resolution higher, at the expense of smaller lettering. 
The simulation diagrams given should fit within an open screen when 
using a display resolution of 800X600 pixels or higher. 

c************************************************************

		CONTENTS OF FOLDERS   

CHAPTER 2 (C2 Folder) INTRODUCTION TO MATLAB/SIMULINK 

Exercise 1: Variable Frequency Oscillator
	SIMULINK file s1.mdl
	MATLAB m-file m1.m

Exercise 2: Parallel RLC Circuit
	SIMULINK file s2.mdl
	MATLAB m-file m2.m
	MATLAB m-file m2init.m(1st half of m2.m)
	MATLAB m-file m2plot.m(2nd half of m2.m)

Exercise 3: AC Energization of a RL Circuit
	SIMULINK file s3.mdl
	MATLAB m-file m3.m

Exercise 4: Series RLC Resonant Circuit
	SIMULINK file s4.mdl
	MATLAB m-file m4.m

		***************

CHAPTER 3 (C3 Folder) BASICS ON MAGNETICS AND LINE MODELING 

Project 1: Line Parameters and Circuit Models:

    (a) Relative Accuracy of Circuit Models for 
	Different Line Lengths
    (b) Real and Reactive Power Transfer
	SIMULINK file none
	MATLAB M-file m1.m

Project 2: Switching Transients in Single-Phase Line

	SIMULINK file s2.mdl
	MATLAB M-file m2.m


		***************

CHAPTER 4 (C4 Folder) TRANSFORMERS 

Project 1: Short-circuit and RL Load Terminations

	SIMULINK file s1a.mdl (linear transformer)
	SIMULINK file s1b.mdl (piece-wise linear saturation)
	SIMULINK file s1c.mdl (lookup table saturation)
	MATLAB M-file m1.m
	MATLAB M-file fftplot.m (fftplot.m should be 
                 placed in a directory on MATLAB's search path)  

Project 2: Open-Circuit Termination, In-rush Current, 
	and DC Bias Core Saturation

	SIMULINK file s1c.mdl (lookup table saturation)
	MATLAB M-file m1.m

	Use the given FFTPLOT.m to obtain the discrete Fourier transform. 

Project 3: Autotransformer Connection

	SIMULINK file none
	MATLAB M-file none

Project 4: Delta-Wye Transformer:Voltage and Current Ratios
	Zero-Sequence Current

	SIMULINK file s4.mdl
	MATLAB M-file m4.m
 
It also contain the following M-files for translating an 
open-circuit curve to an instantaneous magnetization 
curve and comparison study.

	SIMULINK file smag.mdl
	maginit.m (translates open-circuit curve and 
		sets up SIMULINK smag.m) 
	magplt.m (plot results from smag.m) 

		***************

CHAPTER 5 (C5 Folder) BASICS OF ELECTRIC MACHINES AND TRANSFORMATION 

Project 1: QD0 Transformation of Network Components

	SIMULINK file none
	MATLAB M-file none

Project 2: Space Vectors

	SIMULINK file s2.mdl
	MATLAB M-file m2.m (also used by masked block)

Project 3: Sinusoidal and Complex Quantities in QD0

	SIMULINK file s3.mdl
	MATLAB M-file m3.m (also used by masked block)

		***************

CHAPTER 6 (C6 Folder) THREE-PHASE INDUCTION MACHINES

Project 1: Operating Characteristics

	SIMULINK file s1.mdl
	MATLAB M-file m1.m to initialize simulation and plot results
	MATLAB M-file p1hp.m (1 hp induction motor)   

Project 2: Starting Methods

	SIMULINK file (modify a copy s1.mdl)
	MATLAB M-file (modify a copy of m1.m)
	MATLAB M-file p1hp.m (1 hp three-phase induction motor)   

Project 3: Open-circuit Conditions

	SIMULINK file (modify a copy of s1.mdl)e
	MATLAB M-file (modify a copy of m1.m) 
	MATLAB M-file p1hp.m (1 hp three-phase induction motor)   

Project 4: Linearized Analysis

	SIMULINK file s4.mdl 
	MATLAB M-file m4.m to initialize, determine linear
	 model, transfer function, and plot root-locus
	MATLAB M-file p20hp.m (20 hp induction motor)   

	MATLAB M-file m4ustp.m calculates the unit step 
	 response of the transfer function set up in the 
	 MATLAB workspace by running m4.m, using the 
	 Control System Toolbox function step.

	SIMULINK file s4stp.m for step response 
	MATLAB M-file m4stp.m to initialize s4STEP.m

Project 5: Some Non-zero v.{sg} Conditions

	SIMULINK M-files s5a.mdl and s5b.mdl
	MATLAB M-file m5.m to initialize simulation and plot results
	MATLAB M-file p1hp.m (1 hp three-phase induction motor)   

Project 6: Single-phase Induction Motor

	SIMULINK file s6.mdl
	MATLAB M-file m6.m to initialize simulation and plot results
	MATLAB M-file psph.m (1/4 hp single-phase induction motor)   

		***************

CHAPTER 7 (C7 Folder) SYNCHRONOUS MACHINES 

Project 1: Operating Characteristics and Parameter Variations

	SIMULINK file s1.mdl
	MATLAB M-file m1.m to initialize simulation and plot results
	MATLAB M-file set1.m (Set 1 synchronous generator parameters)   

Project 2: Terminal Faults on a Synchronous Generator

	SIMULINK file (modify a copy s1.mdl)
	MATLAB M-file m1.m 
	MATLAB M-file set1.m (Set 1 synchronous generator parameters)   

Project 3: Linearized Analysis of a Synchronous Generator

	SIMULINK files s3.mdl and s3eig.mdl
	MATLAB M-file m3.m to initialize simulation,
          	determine linear model, transfer functions,   root-locus and plot results.
	MATLAB M-file set1.m (Set 1 synchronous generator parameters)   

Project 4: Permanent Magnet Synchronous Motor

	SIMULINK file s4.mdl 
	MATLAB M-file m4.m to initialize, calculate operating
	 values, and plot results.

Project 5: Simulation of Synchronous Machine Model with Unequal 
       	 Stator and Rotor Mutual and Coupling of Rotor Circuits

	SIMULINK files s5.mdl and s1.mdl 
	MATLAB M-files m5.m and m1.m to initialize, calculate operating
	 values, and plot results.
	MATLAB M-file set3a.m (Set 3 generator parameters for s5.m)   
	MATLAB M-file set3b.m (Set 3 generator parameters for s5.m)   
	MATLAB M-file set3c.m (Set 3 generator parameters for s1.m)   
	MATLAB M-file plot5c.m (plot results from different runs)

Project 6: Six Phase Synchronous Machine

	None

		***************

CHAPTER 8 (C8 Folder) DC MACHINES 

Project 1: Startup and Loading of a Shunt DC Generator

	SIMULINK file s1.mdl
	MATLAB M-file m1.m to initialize simulation 
	  and plot magnetization curve.

Project 2: Resistance Starting of a DC Shunt Motor

	SIMULINK file s2.mdl
	MATLAB M-file m2.m to initialize simulation 
        	 and plot results 

Project 3: Methods of Braking

	SIMULINK files s3a.mdl and s3b.mdl
	MATLAB M-files m3a.m and m3b.m to initialize simulation,
	  and plot results.
	m3a.m and s3a.mdl are for plugging and dynamic braking 
	m3b.m and s3b.mdl are for regenerative braking 
        
Project 4: Universal Motor 

	SIMULINK file s4.mdl 
	MATLAB M-file m4.m to initialize simulation and plot results.

Project 5: Series DC Machine Hoist

	SIMULINK files s5a.mdl and s5b.mdl
	MATLAB M-file m5.m to initialize simulation,
	  and plot results.

		***************

CHAPTER 9 (C9 Folder) CONTROL OF INDUCTION MACHINES 

Project 1: Closed-Loop Speed Using Scalar Control

   (a) 	Open loop system
	SIMULINK file s1o.mdl 
	MATLAB M-file m1o.m to initialize s1o.m 
	  and plot magnetization curve.
	MATLAB data file p20hp.m 

   (b) 	Closed loop system
	SIMULINK file s1c.mdl 
	MATLAB M-file m1c.m to initialize S1CLOSED.m 
	  and plot magnetization curve.
	MATLAB M-file p20hp.m to put parameters 
	  of the 20 hp motor in MATLAB workspace 

Project 2: Six-Step Inverter/Induction Motor Drive

   (a) 	Open loop system
	SIMULINK file s2O.mdl 
	MATLAB M-file m1O.m to initialize s2o.m 
	  and plot magnetization curve.
	MATLAB data file p20hp.m 

   (b) 	Closed loop system
	SIMULINK file s2c.mdl 
	MATLAB M-file m1c.m to initialize s2c.m 
	  and plot magnetization curve.
	MATLAB M-file p20hp.m to put parameters 
	  of the 20 hp motor in MATLAB workspace 

Project 3: Field-Oriented Control

	SIMULINK file s3.mdl
	MATLAB M-file m3.m to initialize simulation,
	  and plot results.
	MATLAB M-file p20hp.m to put parameters 
	  of the 20 hp motor in MATLAB workspace 
        
		***************

CHAPTER 10 (C10 Folder) SYNCHRONOUS MACHINES IN POWER SYSTEMS
                        AND DRIVES 

Project 1: Transient Models

   (a) 	Linearized Analysis of a Synchronous Generator
	SIMULINK file s1eig.mdl 
	MATLAB M-file m1.m to initialize S1eig.m, compute
	  its steady state and linearized model 
	MATLAB M-file set1.m to put parameters 
	  of synchronous generator set 1 in MATLAB workspace 

   (b) 	Operating Characteristics and Parameter Sensitivity
	Studies
	SIMULINK file s1.mdl
	MATLAB M-file m1.m to initialize s1.mdl 
	  and plot results of simulation.
	MATLAB M-file set1.m to put parameters 
	  of synchronous generator set 1 in MATLAB workspace 

Project 2: Multimachines System

	SIMULINK files s2.mdl and s2eig.mdl: 
	  s2.mdl for simulation and s2eig.mdl for linearized model
	MATLAB M-file m2.m to initialize condition, determine
	  linearized model and plot results of simulation.
	MATLAB M-files set1.m and set2.m to put parameters 
	  of synchronous generators, set 1 and set 2, 
	  in MATLAB workspace 

Project 3: Subsynchronous Resonance

   (a) 	Fixed Terminal Voltage Case
	SIMULINK files s3G.mdl and s3eig.mdl: 
	  s3g.mdl for simulation and s3geig.mdl for linearized model	
	MATLAB M-file m3G.m to initialize condition, determine
	  linearized model and eigenvalues, and plot mode shapes. 
	MATLAB M-file i3essr.m to put parameters 
	  of synchronous generator in the IEEE subsynchronous 
	  benchmark system in MATLAB workspace 

   (b) 	Generator with Series Capacitor Compensated Line
	SIMULINK files s3.mdl and s3eig.mdl: 
	  s3.mdl for simulation and s3eig.mdl for linearized model	
	MATLAB M-file m3.m to initialize condition, determine
	  linearized model and plot results. 
	MATLAB M-file i3essr.m to put parameters 
	  of the IEEE subsynchronous benchmark system in 
	  MATLAB workspace 
        
Project 4: Power System Stabilizer

	SIMULINK file s4.mdl for simulation. 
	MATLAB M-file m4.m to determine linearized model  
	  of synchronous generator and exciter, 
	  GEP(s) and Exc(s), and produces Bode plots.  
	MATLAB M-file m4comp.m to check preliminary design
	  of pss, provides Bode and root locus plots.
	MATLAB M-file set1.m to put parameters 
	  of synchronous generator set 1 in MATLAB workspace 

Project 5: Self-Controlled Permanent Magnet Motor Drive

	SIMULINK file s5.mdl for simulation
	MATLAB M-file m5.m to initialize drive system parameters,
	  and simulation condition, plot steady-state curves, 
	  and plot results of simulation. It uses the MATLAB
	  function files m5torqi.m and m5torqv.m.

		**** END OF FILE ****
