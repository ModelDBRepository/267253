//MouseLocomotionCPG_integrate.c
//Jessica Parker, November 20, 2021
//
//This is the main integration file. This uses the 8th order Runge-Kutta method to integrate the set of differential equations and then
//writes the solution to an output file.

#include "MouseLocomotionCPG.h"

int integrate(int run1, int run2, int run3, int run4, int run5,  int run6, int nvar, double tf, double tint, double y[])
{

  char file_name_string[100];
  sprintf(file_name_string,"./data/Vall%i_%i_%i_%i_%i_%i.dat",run1,run2,run3,run4,run5,run6); //filename where simulation data is saved 
                                                                                         //You may want to change the prefix of this name
                                                                                         //depending on which variables you want to save.
                                                                                         //In this example case, I am saving all variables.
  //gsl stuff
  const gsl_odeiv_step_type * T = gsl_odeiv_step_rk8pd; //choose integrator
  gsl_odeiv_step * s = gsl_odeiv_step_alloc (T, nvar);
  gsl_odeiv_control * c = gsl_odeiv_control_y_new (1e-8, 1e-9); //set tolerances
  gsl_odeiv_evolve * e = gsl_odeiv_evolve_alloc (nvar);

  // declare variables
  double t, t1, ti, iLn, h;
  int ii,nn,status,lnPts;

  h = 1e-8; // set initial stepsize
  t1 = tf; // set total integrate time for data
  iLn=t1*(1.0/tint); 
  int ln2 = (int)iLn;

  if (ln2 < iLn)
    {
      ln2 = ln2+1;
    }

  // allocate data matrix  
  gsl_matrix * Vs = gsl_matrix_alloc (ln2+1, nvar);  //Set to nvar if you want to save all variables. Set to 2 if you only want to save voltages.
                                                   //or set to 10 if you want to save the select few that I have chosen below.

 // make system using gsl options and system parameters
  // this integrator does not use the Jacbion, so pass NULL in its place
  gsl_odeiv_system sys = {func, NULL, nvar};  

  t=0; // reset time for convenience
  // integrator takes very small steps, but i only care about what happens once per 0.0001 seconds.
  for (ii = 0; ii <= iLn;ii++)
    {
      lnPts=ii; 
      ti = ii * t1 / iLn;

      // use however many steps to move the next 0.0001 seconds
      while (t < ti)
	{
	  // take one step
	  status = gsl_odeiv_evolve_apply (e, c, s,&sys,&t, ti, &h,y);
	  if (y[7]<=0.0)   //y[7] and yy[17] represent sodium concentration in this system
	    {              //which we cannot allow to become negative. Although these if statements
	      y[7]=1e-8;   //are generally not triggered if the equations are written correctly.
	    } 

	  if (status !=GSL_SUCCESS)
	    {
	    break;
	    }
	  if (h<1e-14)
	    {
	    h=1e-14;
	    }
	}

      //Only one of two code blocks, A and B, below should be uncommented.
      
      //A: Use this if you want to save all variables
      for (nn=0;nn<nvar;nn++)
	{
	  gsl_matrix_set(Vs,ii,nn,y[nn]);
	}

      //B: Use this entire block to save a few important variables
      /*gsl_matrix_set(Vs,ii,0,y[0]); //only uncomment these 2 lines if 
      gsl_matrix_set(Vs,ii,1,y[10]);  //you only want to save voltage data
      gsl_matrix_set(Vs,ii,2,y[3]); //hNaP1
      gsl_matrix_set(Vs,ii,3,y[13]); //hNaP2
      gsl_matrix_set(Vs,ii,4,y[6]); //hCaS1
      gsl_matrix_set(Vs,ii,5,y[16]); //hCaS2
      gsl_matrix_set(Vs,ii,6,y[7]); //[Na]i1
      gsl_matrix_set(Vs,ii,7,y[17]); //[Na]i2
      gsl_matrix_set(Vs,ii,8,y[8]); //mh-a1
      gsl_matrix_set(Vs,ii,9,y[18]); //mh-a2*/
    }
  
  // write data to file
  FILE * f1 = fopen(file_name_string,"wb");
  gsl_matrix_fwrite (f1,Vs);
  fclose (f1);
 
  // free memory
  gsl_odeiv_evolve_free (e);
  gsl_odeiv_control_free (c);
  gsl_odeiv_step_free (s);
  gsl_matrix_free (Vs);

  //Save last point.
  char f_ipr[100];
  sprintf(f_ipr,"./data/ip%i_%i_%i_%i_%i_%i.txt",run1,run2,run3,run4,run5,run6);
  FILE * f_ip = fopen(f_ipr,"w+");
  for (nn=0;nn<nvar;nn++)
  {
    fprintf(f_ip,"%14.14g\n", y[nn]);
  }
  fclose(f_ip);
  
  printf("\n Current iteration: %i \n", run6);
  printf("termino\n");
  
  return 0;
}
