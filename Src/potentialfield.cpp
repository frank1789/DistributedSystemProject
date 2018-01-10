#include "mex.h"
#include "matrix.h"
#include <iostream>
#include <vector>
#include "PFM.hpp"
#include "robotinterface.hpp"

/*! \mainpage My Personal Index Page
 *
 * \section intro_sec Introduction
 *
 * This is the introduction.
 *
 * \section install_sec Installation
 *
 * \subsection step1 Step 1: Opening the box
 *
 * etc...
 */

/**\fn mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
 * @brief Potentialfield
 * @param[int] nlhs
 * @param[mxArray *] plhs[]
 * @param[int] nrhs
 * @param[mxArray *] prhs[]
 */
void mexFunction( int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
    /* Define local variable set the data from robot */
    Robot<double> *robot = new Robot<double>;
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
    robot->XcurrentPostion = fromrobot[0];
    robot->YcurrentPostion = fromrobot[1];
    robot->currentOrientation = fromrobot[2];
    
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
    PFM::PathPlanner *pfm = new PFM::PathPlanner(robot, target);
    
    /* retrive laser measure */
    std::vector<double> *Xmeasure = new std::vector<double>;
    std::vector<double> *Ymeasure = new std::vector<double>;
    laserScan = mxGetPr(prhs[2]);
    {
        long M = mxGetM(prhs[2]);
        long N = mxGetN(prhs[2]);
        if (N != 0)
        {
            static long length = N;
            setvector2x2(laserScan, Xmeasure, Ymeasure, N, M);
        }
    }
    
    /* retrive angular laser resoultion */
    std::vector<double> *laser = new std::vector<double>;
    laserRes = mxGetPr(prhs[3]);
    {
        long M = mxGetM(prhs[3]);
        long N = mxGetN(prhs[3]);
        setvector(laserRes, laser, N, M);
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
        delete robot;
        delete target;
        delete Xmeasure;
        delete Ymeasure;
    }
}
