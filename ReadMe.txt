//Readme.txt
//Jessica Parker, November 31, 2021
//
//Instructions for Mouse Locomotion CPG Model

***Software Required and Installation Steps

This code was built for a Linux or Mac computer. A virtual Linux machine on Windows can also be used. Below are instructions on the
software you will need. There are separate instructions for the Linux and for the Mac.

Linux:
- Open the terminal. You can find it with the launch pad.
- Install Homebrew if you don’t already have it, by entering the following line in the terminal.
  	  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
- Install the GSL scientific library with the following command:
  	  brew install gsl
- We use MATLAB for plotting the data, but you can use alternative software if you don't have access to MATLAB.

Mac:
- Open the terminal.
- Xcode needs to be installed.
- The Xcode command line tools also need to be installed.
      	  xcode-select –install
- Install Homebrew by entering the following line in the terminal.
  	  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
- Then, install the GSL scientific library with the following command:
  	  brew install gsl
- We use MATLAB for plotting the data, but you can use alternative software if you don't have access to MATLAB


***C Code for Integration and Analysis:

Enter directory /MouseLocomotionCPG/ in the terminal. There are four sets of C code for integrating the model and producing
simulations, one for the HCO that produces episodic locomotion, one for the HCO that produces continuous locomotion, one for a single cell
that produces episodic bursting, and one for the reduced single cell model that produces continuous bursting. Each of these directories
simulates 5000 sec without writing any output data in order to reach stability without producing an immense ammount of data. It then runs
for 1000 sec and writes this data to files by splitting it into 100-sec-long segments. So after each 100 sec, the simulation pauses, writes that
100 sec to an output file and then starting from the last point of that data simulates another 100 sec, creating a total of 10 output files.
There is a subdirectory called /data/ within each of these four directories.
The simulation output data is saved in this /data/ subdirectory. Each set of code is in a separate directory. The four directories are: 

- /EpisodicHCO/ contains code for the "canonical" model with parameter values in the episodic locomotion regime. 

- /ContinousHCO/ contains code for a model within the continuous bursting regime.  

- /SingleCell/ contains code for a single decoupled cell in the model using the "canonical" parameter set. 

- /ReducedSingleCell/ contains code for the reduced single cell model, in which the variable mh is held constant as a parameter.

Each contains the same code files except for one exception. Here is a description of the files contained in all directories.

Each directory contains:
     compl – compiles code
     MouseLocomotionCPG.h – header file, contains parameter values
     MouseLocomotionCPG_main.c – main file, directs the flow of the program
     MouseLocomotionCPG_integrate.c – integrates the model and save output data
     MouseLocomotionCPG_integrateNW.c – integrates without writing output files
     MouseLocomotionCPG_dy.c – defines differential equations used by integrate() and integrateNW()

/EpisodicHCO/ and /ContinuousHCO/ also contain:
     ipEpisodicHCO.txt - initial conditions for the episodic regime at the canonical parameter set, where the regime is already stable
     ipContinuousHCO.txt - initial conditions for the continuous regime, where gh = 0.365 nS, where the regime is already stable
     runepisodeanalysisHCO.m - Matlab script calls to function episodeanalysisHCO() and saves burst data and episode data to output files
     episodeanalysisHCO.m - Matlab function that analyzes and measures burst characteristics and episode characteristics
     plotJustV.m – MATLAB code that plots the voltage traces made by the C code.
     plotManyVars.m – MATLAB code that plots the voltage traces and other important variables made by the C code.
     
/SingleCell/ and /ReducedSingleCell/ contain:
     runepisodeanalysisSC.m - Matlab script calls to function episodeanalysisHCO() and saves burst data and episode data to output files
     episodeanalysisSC.m - Matlab function that analyzes and measures burst characteristics and episode characteristics
     plotJustVsc.m – MATLAB code that plots the voltage trace made by the C code.
     plotManyVarsSC.m – MATLAB code that plots the voltage trace and other important variables made by the C code.

/SingleCell/ also contains:
     ipSingleCell.txt - initial conditions for the single cell model at the canonical parameter set, where episodic activity is stable

/ReducedSingleCell/ contains:
     ipReducedSingleCell.txt - initial conditions for the reduced single cell model, where mh = 0.95

First, the file compl is a bash script file that compiles the code for you so you don’t have to enter a long confusing line of code to the
terminal every time you want to run the code. It creates the executable file runMouseCPG.exe. All you have to do is enter the following and the
code is compiled.
       ./compl

Next, let’s look at the header file, MouseLocomotionCPG.h. This is where all parameter values are stored. If you want to sweep a parameter, comment out
the initialization of the parameter variable and just declare it instead, and make sure that you don’t declare it again in any other file. 

The main file, MouseLocomotionCPG_main.c, is where the code begins and ends. It directs the flow of the program. If you want to change the numbers used
to make unique file names for your data (run1, run2, run3, run4, run5 and run6), you change them here. If you want to run a parameter sweep or change
the pulse duration or pulse conductance, you do that here.

MouseLocomotionCPG_integrate.c is where the model is integrated and where the output data are written to files. This code saves the output to the directory
/data/ which is inside each of the four main directories. If you want to change where the data is saved to, then there are few different lines
of code where output file names are created. The voltage data and the other variables are saved in a file named Vall[run1]_[run2]_[run3]_[run4]_[run5]_[run6].dat.
In the original example set up in the code, this would be Vall1_0_0_0_[run5]_[run6].dat, where run5 and run6 depend on which directory you are in and which
segment the trace represents. The last point of each simulation segment is saved to files named ip[run1]_[run2]_[run3]_[run4]_[run5]_[run6].txt. These files
can be used to set the initial conditions of the next simulation.

MouseLocomotionCPG_integrateNW.c is another file that is used to integrate the model, except this one does not save any output data. It is used to quickly
integrate for an extended period of time to reach a stable state of the model without creating an immense amount of data saved to your device.

MouseLocomotionCPG_dy.c is where all of the differential equations are defined. This is the substance of your model, so it is important to not change
anything here unless you have a backup copy.

episodeanalysisHCO.m and episodeanalysisSC.m contain functions that analyze and measure the burst characteristics and episode characteristics of a given
voltage trace. episodeanalysisHCO.m is used for the HCO models where there are two cells with alternating activity. episodeanalysisSC.m is used for the single
cell models.

runepisodeanalysisHCO.m and runepisodeanalysisSC.m are Matlab scripts that call to the functions episodeanalysisHCO() and episodeanalysisSC() respectively and
write the following burst characteristics to file: time of burst onset, burst period (BP), burst duration (BD), and interburst interval (IBI); and the
following episode characteristics: time of episode onset, episode period (EP), episode duration (ED), interepisode interval (IEI). The burst characteristics
are saved to files with the prefixes 'bc1j' and 'bc2j', and episode characteristics are saved to file with the prefixes 'ec1j' and 'ec2j'. The script also
saves the indices of the spike times to files with the prefixes ‘sps1j’ and 'sps2j'. The mean episode characteristics are saved to a file with the prefix
'ecmn', the medians are saved with the prefix 'ecmdn', and the standard deviations are saved with the prefix 'ecstd'. The mean burst characteristics are saved
to a file with the prefix 'bcmn' and the standard deviations are saved to a file with the prefix 'bcstd', however, if the activity is episodic, it only saves
the means and stds of the characteristics of the last burst in each episode, while if it is continuous, it saves the means and stds of all bursts. These output
data files are saved in the /data/ directories.

plotJustV.m and plotJustVsc.m are MATLAB scripts that plot the voltage traces of your simulations. You just need to set the time range that you want to plot,
which is defined by variables xmin and xmax. You also need to set the variable showEc and showpar, near the top of the code, which determine whether you have
a title in your plot and what that title is. If you want the episode characteristics in the title, set showEc to 1. If you want a certain parameter value in
the title, set showpar to 1 and set the variables parname, parunits, parcan, and parstep. Parcan is set to parameter value when run4 = 1 and parstep is used
if you are plotting a parameter sweep where run4 changes with the parameter value. In this example case, we are not sweeping a parameter, so parstep is set to
0. If you don't want a title, set both showEc and showpar to zero. This code can be easily altered to plot other variables as well.

plotManyVars.m and plotManyVarsSC.m are MATLAB scripts that plot the voltage traces, sodium concentration, pump current, inactivation of slow sodium,
inactivation of slow calcium, and activation of h-current. You just need to set the time range that you want to plot, which is again defined by variables xmin and
xmax. Again you need to set showEc and showpar and if you set showpar to 1, you need to set parname, parunits, parcan, and parstep. This code can also be easily
altered to plot other variables as well.

***Running the Code

To run the C code, You just need to compile and run. Enter the following lines in the terminal
    ./compl. 
    ./runMouseCPG.exe

To analyze the data, open MATLAB and runepisodeanalysisHCO.m or runepisodeanalysisSC.m, depending on which directory you are in. Make sure the run numbers,
specifically run1, run2, run3, run4, run5, and run6 coincide with the run numbers in your data file names. You can plot a few episodes or bursts with
characteristics marked by setting plt to 1. Run the script. It will output the data files described above, and it will print into the MATLAB command line
whether the activity is silent, spiking, continuous bursting, or episodic bursting.

***Plotting the Output

To plot the voltage traces, open plotJustV.m or plotJustVsc depending on which directory you are in. Make sure the run numbers coincide with the run numbers in
your data file names. Set xmin and xmax to the time range that you want to plot, where xmin is the beginning of the time range and xmax is the end of the time
range. Then run the MATLAB script. It will create the figure and save it as justV[run1]_[run2]_[run3]_[run4]_[run5]_[run6].eps, where run6 in this case is the
last run6 value used. If you want to use a different file type, go to where the file name is created at the bottom of the script where the function print() is
called and change the file type designated there. 

To plot the voltage traces and other important variables, open plotManyVars.m or plotManyVarsSC.m. Make sure the run numbers are correct and run the script.
Output files are saved as ManyVars[run1]_[run2]_[run3]_[run4]_[run5]_[run6].eps, where run6 again is the last run6 value used.
