#include "mex.h"
#include "matrix.h"
#include <iostream>
#include <vector>
#include "PFM.hpp"
#include "robotinterface.hpp"

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

    #define B_OUT plhs[0]
    #define B_OUT1 plhs[1]
    

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

    /* instance Potetianl Field Method */
    PFM::PathPlanner *pfm = new PFM::PathPlanner(b, target);

    /* retrive laser measure */
    std::vector<double> *Xmeasure = new std::vector<double>;
    std::vector<double> *Ymeasure = new std::vector<double>;
    laserScan = mxGetPr(prhs[2]);
    {
        long M = mxGetM(prhs[2]);
        long N = mxGetN(prhs[2]);
        //std::cout<<"dimension measure:" << N <<", "<<M <<"\n";
        if (N != 0)
        {
          static long length = N;
          setvector2x2(laserScan, Xmeasure, Ymeasure, N, M);
        //   {
        //     for (std::vector<double>::iterator it = Xmeasure->begin() ; it != Xmeasure->end(); ++it)
        //       std::cout << ' ' << *it;
        //     std::cout << '\n';
        //   }
        //   {
        //     for (std::vector<double>::iterator it = Ymeasure->begin() ; it != Ymeasure->end(); ++it)
        //       std::cout << ' ' << *it;
        //     std::cout << '\n';
        //   }
        }
//        else
//        {
//          Ymeasure->resize(N);
//          Xmeasure->resize(N);
//          std::fill(Ymeasure->begin(), Ymeasure->end(), 1);
//          std::fill(Xmeasure->begin(), Xmeasure->end(), 1);
//        }
    }

    /* retrive angular laser resoultion */
    std::vector<double> *laser = new std::vector<double>;
    laserRes = mxGetPr(prhs[3]);
    {
        long M = mxGetM(prhs[3]);
        long N = mxGetN(prhs[3]);
        //std::cout<<"laser: " << N <<", "<<M <<"\n";
        setvector(laserRes, laser, N, M);
        // {
        //   std::cout<<"laserRes:\n";
        //   for (std::vector<double>::iterator it = laser->begin() ; it != laser->end(); ++it)
        //     std::cout << ' ' << *it;
        //   std::cout << '\n';
        // }
    }

    /* retrive velocity */
    double *velocity = new double;
    velocity = mxGetPr(prhs[4]);

      /* compute Potetianl Field Method */
      pfm->setTotalPotential(Xmeasure, Ymeasure, laser);
      /* return mex function output */
      B_OUT = mxCreateDoubleScalar(pfm->getSteerangle(velocity));
      B_OUT1 = mxCreateDoubleScalar(pfm->getSpeed(velocity));

    /* garbage collector */
    {
        delete pfm;
        delete b;
        delete target;
        delete Xmeasure;
        delete Ymeasure;
    }
}
