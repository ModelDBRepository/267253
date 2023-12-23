//MouseLocomotionCPG_main.c
//Jessica Parker, November 20, 2021
//
//This is the main function, which begins your program and guides the actions in your program.

#include "MouseLocomotionCPG.h" 
#include "time.h" 

int main (void) {  

  int run1 = 1;  //These numbers gets written into the names of the data files. You can use any 
  int run2 = 0;  //combination of numbers according to whatever organizational system you prefer.
  int run3 = 0;  //Here is the system I use: run1 represents the overall project, run2 represents the 
  int run4 = 3;   //state of the model, changing when equations are changed or when "canonical" parameter 
  int run5 = 0;   //set changes, run3 represents a specific sweep, run4 changes with the sweeped parameter
  int run6 = 0;   //run5 is only used if its a 2D sweep, otherwise it is always 0, run6 is used to
  int run6f = 10;  //split integration time into segments. run6f is equal to the number of segments that
                   //the output data is split into

  //parameters defined in EpisodicLocomotion.h
  
  double tf1 = 5000.0;  //The amount of time the code integrates before beginning to save the data
  double tf2 = 100.0;  //The amount of time integrated in each data file.
  double tint = 0.0001;  //Time step between data points.
 
  clock_t start;
  clock_t end; 
  float seconds; 

  int nvar = 9;  //Number of variables or number of equations
  double yy[nvar]; 
  double yy0[nvar];  //initial condition variable
  int numIP=0;   //used to read initial condition file
  
  int a, b, c, d; //used for loops

  FILE * f = fopen("ipReducedSingleCell.txt", "r");  //initial condition file
  double number = 0; 
  
  while( fscanf(f, "%lf,", &number) > 0 )  //reading initial conditions 
    { 
      yy0[numIP]= number; 
      numIP++; 
    }  
  fclose(f);

  for (a=0; a<nvar; a++)  //Setting time zero to initial conditions
    { 
      yy[a] = yy0[a]; 
    } 

  for (b=0; b<1; b++)  //Change maximum limit if you want to sweep a parameter
    {
      //run3 = b+1;    //Uncomment if you are sweeping a parameter. This makes sure each simulation has a unique file name.

      for (d=0; d<1; d++)  //Change maximum limit if you want to run a 2D sweep
	{
	  //run4 = d+1;    //Uncomment if you are sweeping a parameter. This also makes sure each simulation has a unique file name.

	  mh = 0.9; 
	  
	  printf("run3 = %i, run4 = %i, run5 = %i \n",run3,run4,run5);

	  /*for (a=0; a<nvar; a++)  //Uncomment if you want to use the same initial conditions for each integration   
	    { 
	      yy[a] = yy0[a]; 
	    }*/
	  
	  start = clock();  
	  integrateNW(run1,run2,run3,run4,run5,0,nvar,tf1,tint,yy);   //Call to function defined in EpisodicLocomotion_integrateNW.c
	                              //Integrates for tf1 seconds without saving data. Saves last point as run6 = 0.
	  for (c=0; c<run6f; c++)  //Splits integration and saved data into (run6f) files, where each file
	    {                       //contains tf2 seconds of data, maintaining a manageable file size
	      integrate(run1,run2,run3,run4,run5,c+1,nvar,tf2,tint,yy);  //Call to function defined in EpisodicLocomotion_integrate.c
	    }
	  
	  end = clock();
	  seconds = (float)(end-start)/CLOCKS_PER_SEC;
	  
	  printf("running time: %6.6g\n", seconds); //the code as it is should take about 15 min.
	}
    }
  return(0); 
} 
