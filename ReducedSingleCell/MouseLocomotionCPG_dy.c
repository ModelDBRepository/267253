//MouseLocomotionCPG_dy.c
//Jessica Parker, November 20, 2021
//
//This is the equation file. The set of differential equations for this model are defined here.

#include "MouseLocomotionCPG.h"

int func(double t, const double y[], double f[],void *params) //params is the pointer to the array of parameter values
{

  //dV1
  f[0]=-((gNaF*(1./(1.+exp(-(y[0]+V2mNaF)/7.8)))*(1./(1.+exp(-(y[0]+V2mNaF)/7.8)))*(1./(1.+exp(-(y[0]+V2mNaF)/7.8)))*y[1]*(y[0]-26.45*log(120.0/y[7])))	//Fast Sodium
	 +gNaS*y[2]*y[3]*(y[0]-26.45*log(120.0/y[7]))    //Slow Sodium
	 +gK*y[4]*y[4]*y[4]*y[4]*(y[0]-26.45*log(KE/KI))	  //Potassium
	 +gCaS*y[5]*y[5]*y[5]*y[6]*(y[0]-ECa)	   //Slow Calcium
	 +gh*(Ehref-26.45*log(KE/KI))/(65.0-26.45*log(KE/KI))*mh*mh*(y[0]-26.45*log(120.0/y[7]))  //IHNa
	 +gh*(Ehref-65.0)/(26.45*log(KE/KI)-65.0)*mh*mh*(y[0]-26.45*log(KE/KI))  //IHK
	 +gL*(ELref-26.45*log(KE/KI))/(65.0-26.45*log(KE/KI))*(y[0]-26.45*log(120.0/y[7]))   //ILNa
	 +gL*(ELref-65.0)/(26.45*log(KE/KI)-65.0)*(y[0]-26.45*log(KE/KI))	//ILK			       
	 +(pumpstr/(1.+exp((termA-y[7])/3.0))*1./(1.+exp(termB-KE)))   //IPump
	 +GKA*(1./(1.+exp((V2mKA-y[0])/kmKA)))*y[8]*(y[0]-26.45*log(KE/KI)) //IKA
	 +gModWE1*(y[0]-0.0)+gModWI1*(y[0]+75.0))/0.001;	 

  //hNaF
  f[1]=(1./(1.+exp((y[0]+V2hNaF)/7.0))-y[1])/(0.03/(exp((y[0]+V2hNaF+17.0)/15.0)+exp(-(y[0]+ V2hNaF+17.0)/16.0)));

  //mNaS
  f[2]=(1./(1.+exp(-(y[0]+V2mNaS)/4.1))-y[2])/0.001;

  //hNaS
  f[3]=(1./(1.+exp((y[0]+V2hNaS)/5.0))-y[3])/ThNaS;  
  
  //mK 
  f[4]=(exp((y[0]+(V2mK+25.0))/40.0)+exp(-(y[0]+(V2mK+25.0))/50.0))/0.007*(1./(1.+exp(-(y[0]+V2mK)/15.0))-y[4]);

  //mCaS 
  f[5]=((1./(1.+exp((y[0]+V2mCaS)/-4.27)))-y[5])/(0.001/((0.02*(y[0]+(V2mCaS+2.41))/(1.-exp(((V2mCaS+2.41)+y[0])/-4.5)))+(-0.05*(V2mCaS+5.41+y[0])/(1.-exp((y[0]+V2mCaS+5.41)/4.5)))));

  //hCaS
  f[6]=(1./(1.+exp((y[0]+V2hCaS)/khCaS))-y[6])/ThCaS;

  //[Na]i
  f[7]=-4.682255338155292*(+gh*(Ehref-26.45*log(KE/KI))/(65.0-26.45*log(KE/KI))*mh*mh*(y[0]-26.45*log(120.0/y[7])) //IHNa
			   +gL*(ELref-26.45*log(KE/KI))/(65.0-26.45*log(KE/KI))*(y[0]-26.45*log(120.0/y[7]))   //ILNa
			   +gNaF*1./(1.+exp(-(y[0]+V2mNaF)/7.8))*1./(1.+exp(-(y[0]+V2mNaF)/7.8))*1./(1.+exp(-(y[0]+V2mNaF)/7.8))*y[1]*(y[0]-26.45*log(120.0/y[7]))   //INaF
			   +gNaS*y[2]*y[3]*(y[0]-26.45*log(120.0/y[7]))    //INaS
			   +3.0*(pumpstr/(1.+exp((termA-y[7])/3.0))*1./(1.+exp(termB-KE))));   //3*IPump

  //hKA
 f[8]=((1./(1.+exp((y[0]-V2hKA)/khKA)))-y[8])/tauhKA;


  return GSL_SUCCESS;
}
