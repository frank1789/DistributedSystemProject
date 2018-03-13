/*----------------------------------------------------------------------*/
/*                         Tese Mestrado 2009/2010                      */
/*                           57609 Joao Ferreira                        */
/*                                                                      */
/*                                                                      */
/*  Log: added noise and resolution simulation                          */
/*                                                                      */
/*                                                                      */
/*                                                                      */
/*      Input:  points=[x1,x2,...;                                      */
/*                      y1,y2,...]                                      */
/*              lines =[i1,i2,...;                                      */
/*                      e1,e2,...]                                      */
/*              sensor=[xs,ys,thetas,FOV,steps,stdAngle,stdRange]       */
/*                             rad   rad  rad                           */
/*              sensor=[xs,ys,thetas,FOV,steps]                         */
/*                                                                      */
/*      Output: D = [theta1, theta2,...;  measurement direction         */
/*                     d1  ,   d2  ,...;  distance to closest obstacle  */
/*                     l1  ,   l2  ,...]  index of the obstacle         */
/*                                                                      */
/*      Syntax: D=Sens_model(points,lines,sensor)                       */
/* Example (with Hokuyo FOV and step):                                  */
/*   %x, y, theta, FOV, delta_angular                                   */
/*   c=pi/180;                                                          */
/*   laser = [  -.75,  .12,  pi/4,  239.4141*c, .3516*c, .1*c, .04;     */
/*              -1.3,  .24,    pi,  239.4141*c, .3516*c, .1*c, .04;     */
/*                 0,  .60,    pi,  239.4141*c, .3516*c, .1*c, .04;     */
/*               -.7,  .61,  pi/2,  239.4141*c, .3516*c, .1*c, .04];    */
/*                                                                      */
/*   D = Sens_model(map.points, map.lines, laser(i,:));                 */
/*----------------------------------------------------------------------*/

#include "mex.h"
#include <math.h>
#include <stdlib.h>

#define Indxini ((int)lines[j]-1)*2
#define Indxend ((int)lines[j+1]-1)*2
#define Indyini ((int)lines[j]-1)*2+1
#define Indyend ((int)lines[j+1]-1)*2+1

#define PI atan(1.0)*4

double gaussrand()
{
	static double U, V;
	static int phase = 0;
	double Z;

	if(phase == 0) {
		U = (rand() + 1.) / (RAND_MAX + 2.);
		V = rand() / (RAND_MAX + 1.);
		Z = sqrt(-2 * log(U)) * sin(2 * PI * V);
	} else
		Z = sqrt(-2 * log(U)) * cos(2 * PI * V);

	phase = 1 - phase;

	return Z;
}



void lambd(double * lam, double * px, double * py)
{
    double det, bax,bay, uvx,uvy, uax,uay;
    
    bax = px[1]-px[0]; bay = py[1]-py[0];
    uvx = px[2]-px[3]; uvy = py[2]-py[3];
    uax = px[2]-px[0]; uay = py[2]-py[0];
    
    det = bax*uvy-bay*uvx;
    if( det == 0 ){
        lam[0]=0; lam[1]=0;
        return;
    }
    det=1/det;
    lam[0]=det*(uvy*uax-uvx*uay);
    lam[1]=det*(bax*uay-bay*uax);
   
}

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
  double *points,*lines,*sensor,*z;
  mwSize lines_c;
  double ang;
  double lambda[2], pointX[4],pointY[4];
  double stdTheta, stdRho ;
  int i,j,n_raios;
  
  /*  create a pointer to input matrix */
  points    = mxGetPr(prhs[0]);
  lines     = mxGetPr(prhs[1]);
  sensor    = mxGetPr(prhs[2]);
  

  stdTheta  = sensor[5] ;
  stdRho    = sensor[6] ;
  
  /*
  printf("stdTheta -> %f\n",stdTheta);
  printf("stdRho    -> %f\n",stdRho);*/
 

  /*  get the dimensions of matrix input */
  lines_c  = mxGetN(prhs[1]);
  
  /* number of ray (to check) */    
  n_raios = (int)ceil(sensor[3]/sensor[4])+1;
  
  /*  set the output pointer to the output matrix */
  plhs[0] = mxCreateDoubleMatrix(3,n_raios, mxREAL);
  
  /*  create a C pointer to a copy of the output matrix */
  z = mxGetPr(plhs[0]);
  
  ang = sensor[2]-sensor[3]/2;
  pointX[2] = sensor[0]; pointY[2] = sensor[1];/*sensor location*/

  for(i=0; i < 3*n_raios; i+=3){ /*for every laser ray*/
      z[i] = ang + gaussrand()*stdTheta; /*angle of the ray*/
      pointX[3] = sensor[0]+ cos(ang); pointY[3] = sensor[1]+ sin(ang) ; /*vector with laser ray direction (module =1)*/
      for(j=0; j < 2*lines_c ;j+=2){ /*cycle through the map lines*/
          pointX[0] = points[Indxini]; pointY[0] = points[Indyini]; /*initial point of the map line*/
          pointX[1] = points[Indxend]; pointY[1] = points[Indyend]; /*final point of the map line*/
          lambd(lambda, pointX, pointY);
          if(lambda[0]>=0 && lambda[0]<=1 && lambda[1]>0 && (lambda[1]<z[i+1] || z[i+1]==0)){
              /*z[i+1]=lambda[1];*/ /*the detected collision point is a wall and is closest than the last one detected*/
              z[i+1] = floor( 1000*(lambda[1] + gaussrand()*stdRho + 0.0005) )/1000 ;
              z[i+2]=j/2+1;     /*register the line index*/
          }                     
      }
      ang += sensor[4]; /*increment direction by the angular step*/
  }
}
