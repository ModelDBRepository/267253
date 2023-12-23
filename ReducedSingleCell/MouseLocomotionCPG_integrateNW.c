//MouseLocomotionCPG_integrateNW.c
//Jessica Parker, March 14, 2021
//
//This function allows you to integrate your simulation for a long time without saving an immense
//amount of data, so that you can more easily be sure that you have reached the stable state of the
//system. It runs much faster than the integrate() function in EpisodicLocomotion_integrate.c, due to the
//lack of file writing, although it still takes many minutes to run a few thousand seconds. This function
//does save the last point of the simulation.

#include "MouseLocomotionCPG.h"

int integrateNW(int run1, int run2, int run3, int run4, int run5, int run6, int nvar, double tf, double tint, double y[])
{
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
  iLn=t1*(1.0/tint);  //number of data points

  // make system using gsl options and system parameters
  // this integrator does not use the Jacbion, so pass NULL in its place
  gsl_odeiv_system sys = {func, NULL, nvar};  

  t=0; // reset time for convenience
  // integrator takes very small steps, but i only save the data every 0.0001 (tint) seconds.
  for (ii=0; ii<=iLn; ii++)
    {
      lnPts=ii; 
      ti = ii * t1 / iLn;
  
      // use however many steps to move to the next 0.0001 (tint) seconds
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
    }
  
  // free memory
  gsl_odeiv_evolve_free (e);
  gsl_odeiv_control_free (c);
  gsl_odeiv_step_free (s);

  //Save last point.
  char f_ipr[100];
  sprintf(f_ipr,"./data/ip%i_%i_%i_%i_%i_%i.txt",run1,run2,run3,run4,run5,run6);
  FILE * f_ip = fopen(f_ipr,"w+");
  for (nn=0;nn<nvar;nn++)
  {
    fprintf(f_ip,"%14.14g\n", y[nn]);
  }
  fclose(f_ip);
  
  printf("termino\n");
  
  return 0;
}
