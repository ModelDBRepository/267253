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
	 +gh*(Ehref-26.45*log(KE/KI))/(65.0-26.45*log(KE/KI))*y[8]*y[8]*(y[0]-26.45*log(120.0/y[7]))  //IHNa
	 +gh*(Ehref-65.0)/(26.45*log(KE/KI)-65.0)*y[8]*y[8]*(y[0]-26.45*log(KE/KI))  //IHK
	 +gL*(ELref-26.45*log(KE/KI))/(65.0-26.45*log(KE/KI))*(y[0]-26.45*log(120.0/y[7]))   //ILNa
	 +gL*(ELref-65.0)/(26.45*log(KE/KI)-65.0)*(y[0]-26.45*log(KE/KI))	//ILK			       
	 +(pumpstr/(1.+exp((termA-y[7])/3.0))*1./(1.+exp(termB-KE)))   //IPump
	 +GKA*(1./(1.+exp((V2mKA-y[0])/kmKA)))*y[9]*(y[0]-26.45*log(KE/KI)) //IKA
	 +GSyn*y[20]*(y[0]-ESyn)
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
  f[7]=-4.682255338155292*(+gh*(Ehref-26.45*log(KE/KI))/(65.0-26.45*log(KE/KI))*y[8]*y[8]*(y[0]-26.45*log(120.0/y[7])) //IHNa
			   +gL*(ELref-26.45*log(KE/KI))/(65.0-26.45*log(KE/KI))*(y[0]-26.45*log(120.0/y[7]))   //ILNa
			   +gNaF*1./(1.+exp(-(y[0]+V2mNaF)/7.8))*1./(1.+exp(-(y[0]+V2mNaF)/7.8))*1./(1.+exp(-(y[0]+V2mNaF)/7.8))*y[1]*(y[0]-26.45*log(120.0/y[7]))   //INaF
			   +gNaS*y[2]*y[3]*(y[0]-26.45*log(120.0/y[7]))    //INaS
			   +3.0*(pumpstr/(1.+exp((termA-y[7])/3.0))*1./(1.+exp(termB-KE))));   //3*IPump

  //mh
  f[8]=((1./(1.+2.0*exp(1.23*180.0*(y[0]+VmH))+exp(1.23*500.0*(y[0]+VmH))))-y[8])/(0.5+1.7/(1.+exp(-100.0*(y[0]+73.0))));

  //hKA
 f[9]=((1./(1.+exp((y[0]-V2hKA)/khKA)))-y[9])/tauhKA;


 //dV2    
 f[10]=-(gNaF*1./(1.+exp(-(y[10]+V2mNaF)/7.8))*1./(1.+exp(-(y[10]+V2mNaF)/7.8))*1./(1.+exp(-(y[10]+V2mNaF)/7.8))*y[11]*(y[10]-26.45*log(120.0/y[17]))       //Fast Sodium   
	 +gNaS*y[12]*y[13]*(y[10]-26.45*log(120.0/y[17]))    //Slow Sodium                         
	 +gK*y[14]*y[14]*y[14]*y[14]*(y[10]-26.45*log(KE/KI))   //Potassium          
	 +gCaS*y[15]*y[15]*y[15]*y[16]*(y[10]-ECa)      //Slow Calcium         
	 +gh*(Ehref-26.45*log(KE/KI))/(65.0-26.45*log(KE/KI))*y[18]*y[18]*(y[10]-26.45*log(120.0/y[17]))  //IHNa   
         +gh*(Ehref-65.0)/(26.45*log(KE/KI)-65.0)*y[18]*y[18]*(y[10]-26.45*log(KE/KI))  //IHK 
	 +gL*(ELref-26.45*log(KE/KI))/(65.0-26.45*log(KE/KI))*(y[10]-26.45*log(120.0/y[17]))   //ILNa          
	 +gL*(ELref-65.0)/(26.45*log(KE/KI)-65.0)*(y[10]-26.45*log(KE/KI))    //ILK 
	 +(pumpstr/(1.+exp((termA-y[17])/3.0))*1./(1.+exp(termB-KE)))   //IPump       
	 +GKA*(1./(1.+exp((V2mKA-y[10])/kmKA)))*y[19]*(y[10]-26.45*log(KE/KI))  //IKA
	 +GSyn*y[21]*(y[10]-ESyn)
	 +gModWE2*(y[10]-0.0)+gModWI2*(y[10]+75.0))/0.001;

 //hNaF      
 f[11]=(1./(1.+exp((y[10]+V2hNaF)/7.0))-y[11])/(0.03/(exp((y[10]+V2hNaF+17.0)/15.0)+exp(-(y[10]+V2hNaF+17.0)/16.0)));

 //mNaS         
 f[12]=(1./(1.+exp(-(y[10]+V2mNaS)/4.1))-y[12])/0.001;

 //hNaS    
 f[13]=(1./(1.+exp((y[10]+V2hNaS)/5.0))-y[13])/ThNaS;

 //mK        
 f[14]=(exp((y[10]+(V2mK+25.0))/40.0)+exp(-(y[10]+(V2mK+25.0))/50.0))/0.007*(1./(1.+exp(-(y[10]+V2mK)/15.0))-y[14]);

 //mCaS    
 f[15]=((1./(1.+exp((y[10]+V2mCaS)/-4.27)))-y[15])/(0.001/((0.02*(y[10]+(V2mCaS+2.41))/(1.-exp(((V2mCaS+2.41)+y[10])/-4.5)))+(-0.05*(V2mCaS+5.41+y[10])/(1.-exp((y[10]+V2mCaS+5.41)/4.5)))));

 //hCaS          
 f[16]=(1./(1.+exp((y[10]+V2hCaS)/khCaS))-y[16])/ThCaS;

 //[Na]i       
 f[17]=-4.682255338155292*(gh*(Ehref-26.45*log(KE/KI))/(65.0-26.45*log(KE/KI))*y[18]*y[18]*(y[10]-26.45*log(120.0/y[17]))  //IHNa
			   +gL*(ELref-26.45*log(KE/KI))/(65.0-26.45*log(KE/KI))*(y[10]-26.45*log(120.0/y[17]))   //ILNa     
			   +gNaF*1./(1.+exp(-(y[10]+V2mNaF)/7.8))*1./(1.+exp(-(y[10]+V2mNaF)/7.8))*1./(1.+exp(-(y[10]+V2mNaF)/7.8))*y[11]*(y[10]-26.45*log(120.0/y[17])) //INaF 
			   +gNaS*y[12]*y[13]*(y[10]-26.45*log(120.0/y[17]))    //INaS
			   +3.0*(pumpstr/(1.+exp((termA-y[17])/3.0))*1./(1.+exp(termB-KE))));   //3*IPump           

 //mh-a 
 f[18]=((1./(1.+2.0*exp(1.23*180.0*(y[10]+VmH))+exp(1.23*500.0*(y[10]+VmH))))-y[18])/(0.5+1.7/(1.+exp(-100.0*(y[10]+73.0))));

 //hKA    
 f[19]=((1./(1.+exp((y[10]-V2hKA)/khKA)))-y[19])/tauhKA;


 //msyn from neuron 2
 f[20]=(1.0/(1.0+exp(-(y[10]+V2Syn)/0.4))-y[20])/TauSyn;

 //msyn from neuron 1
 f[21]=(1.0/(1.0+exp(-(y[0]+V2Syn)/0.4))-y[21])/TauSyn;


  return GSL_SUCCESS;
}
