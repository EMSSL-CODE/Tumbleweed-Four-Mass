This code is used to simulate the tumbleweed rover motion to the actual experimental results
Written by P Sardeshmukh, C Yoder, and D Talaski

% Code outline
1. The main file is "run_sim.m" which is used to run the entire code base. 
	a. In "run_sim.m", bindir is the directory where all plots will be made. If it does not exist, it will be created. Look here for results. 
	b. In "run_sim.m", paramfile is the run file used to specify all parameters in the simulation. 
2. "run_sim.m" will do the following:
	a. Load the parameter file paramfile into the working variable space. 
	b. If there is an experiment to compare results with, load the experimental data file. 
	c. Simulate using the states file. 
	d. Plot the results. 
	
% Parameter file
Of note, the following variables are useful:
	a. LL, UL, I_B_B, mCH, R, mv, m, sp, ca, m - all are parameters of the rover
	b. savename - the filename to save all data to
	c. massflag - specify either simulation or experimental working
	d. Crr0 - rolling resistance coefficient
	e. use_ode - ode function to use, including 45, 23, 15, 1, 2, 3, 4, 5
	f. ics - initial conditions of the rover
	g. kP_vel - angular velocity proportional controller gain

% Help
cdyoder@ncsu.edu