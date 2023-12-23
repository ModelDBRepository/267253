//MouseLocomotionCPG.h
//Jessica Parker, November 20, 2021
//
//This is the header file. It declares the global functions and parameters. Using 'static const' to initialize
//your global parameters that you don't intend to change is an appropriate way to use global variables. Using
//nonstatic global variables that will be changed in the rest of your code is a less appropriate use of global variables,
//although it still works. This code limits the use of nonstatic global variables to the one or two parameters that
//you may be sweeping. The benefit of setting our parameters as static global variables is that it causes the code to
//run faster and it is much easier to make changes to the equations in EpisodicLocomotion_dy.c. However, if you prefer,
//you can make the parameters that you are sweeping arguments for each of the functions defined below.

#include <stdio.h>
#include <string.h>
#include <math.h>

#include <gsl/gsl_errno.h>
#include <gsl/gsl_matrix.h>
#include <gsl/gsl_odeiv.h>

int main (void);
int integrate(int run1, int run2, int run3, int run4, int run5,  int run6, int nvar, double tf, double tint, double y[]);   //integrates and saves data
int integrateNW(int run1, int run2, int run3, int run4, int run5,  int run6, int nvar, double tf, double tint, double y[]);   //integrates without saving data
int func(double t, const double y[], double f[], void *params);  //equations defined

//Canonical Parameter Set,  
static const double gNaS = 4.97;
static const double gL = 1.88; 
static const double gCaS = 3.3; 
static const double gK = 79.0; 
static const double gNaF = 105.0;
static const double ECa = 160.0;
static const double V2mNaF = 15.00; 
static const double V2hNaF = 26.0;  
static const double V2mNaS = 43.0;
static const double V2hNaS = 57.0;
static const double V2mCaS = 45.6;
static const double V2hCaS = 56.34;
static const double V2mK = 18.00;
static const double khCaS = 0.86;   
static const double ThNaS = 0.1;
static const double ThCaS = 0.34;
static const double KE = 9.0;
static const double KI = 130.0;
static const double pumpstr = 40.26;  
static const double termA = 25.0;
static const double termB = 6.0;
static const double VmH = 52.1; 
static const double gh = 0.34; 
static const double GKA = 1.13;
static const double V2mKA = -20.0;
static const double V2hKA = -59.8;
static const double kmKA = 10.;
static const double khKA = 5.0;
static const double tauhKA = 0.02;
static const double Ehref = -12.4446; 
static const double ELref = -55.0;

static const double V2Syn = 25.0;
static const double TauSyn = 0.05;
static const double GSyn = 1.02; 
static const double ESyn = -70.0;

static const double gModWE1 = 0.0;
static const double gModWI1 = 0.0;
static const double gModWE2 = 0.0;
static const double gModWI2 = 0.0;

//double pumpstr;      //Use this format for parameters that you are sweeping, and comment out
                       //the above (static const) declaration of the variable you are sweeping
