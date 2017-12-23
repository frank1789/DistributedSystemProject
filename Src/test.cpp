#include "mex.h"
#include <iostream>
#include <vector>
#include "PFM.hpp"
#include "robotinterface.hpp"
#include <thread>
// #include "robotinterface.hpp"



void mexFunction( int nlhs, mxArray *plhs[],
  int nrhs, const mxArray *prhs[])
  {
    /* Define local variable set the data from robot */
    Robot<double> *b = new Robot<double>;
    double *fromrobot = new double;
    double *point = new double;
    double *laserScan = new double;
    double *laserRes = new double;

    fromrobot = mxGetPr(prhs[0]);

    /* initilize variable from robot
     * - X coordinate position
     * - X coordinate position
     * - theta orientation
    */

    b->XcurrentPostion = fromrobot[0];
    b->YcurrentPostion = fromrobot[1];
    b->currentOrientation = fromrobot[2];

    //std::cout<< "x "<<b->XcurrentPostion <<std::endl;
    //std::cout<< "y "<<b->YcurrentPostion <<std::endl;
    //std::cout<< "o "<<b->currentOrientation  <<std::endl;


    #define B_OUT plhs[0]

    /* retrive variable target point
      - X coordinate position
      - X coordinate position
      - theta orientation
    */

    point = mxGetPr(prhs[1]);
    Point<double> *target = new Point<double>;
    target->XPostion = point[0];
    target->YPostion = point[1];
    target->Orientation = point[2];
    //std::cout<< target->XPostion <<std::endl;
    //std::cout<< target->YPostion <<std::endl;
    //std::cout<< target->Orientation  <<std::endl;

    /* instance Potetianl Field Method */
    PFM::PathPlanner *pfm = new PFM::PathPlanner(b, target);

    /* retrive laser measure */
    std::vector<double> *Xmeasure = new std::vector<double>;
    std::vector<double> *Ymeasure = new std::vector<double>;
    laserScan = mxGetPr(prhs[2]);
    {
      int M = mxGetM(prhs[2]);
      int N = mxGetN(prhs[2]);
      setvector(laserScan, Xmeasure, Ymeasure, N, M);
    }

    /* retrive angular laser resoultion */
    std::vector<double> *laser = new std::vector<double>;
    laserRes = mxGetPr(prhs[3]);
    {
      int M = mxGetM(prhs[3]);
      int N = mxGetN(prhs[3]);
      setvector(laserRes, laser, N, M);
    }

    /* compute Potetianl Field Method */
    std::cout << pfm->getTotalPotential(Xmeasure, Ymeasure, laser)<<std::endl;


    //output
    B_OUT = mxCreateDoubleScalar(PI);

    /* garbage collector */
    {
      delete pfm;
    }
    // delete  pfm, laserScan, laserRes;
    // delete fromrobot;
    // delete point;

    /* garbage collector */
    {
      delete laser;
      delete Xmeasure;
      delete Ymeasure;
    }
  }
