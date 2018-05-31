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

/**
 * @brief mexfunction use Potential Field.
 * @details These MEX variables are analogous to the M-code variables nargout, varargout, nargin, and varargin.
 * The naming “lhs” is an abbreviation for left-hand side (output variables) and “rhs” is an abbreviation
 * for right-hand side (input variables).<br>
 * For example, suppose the MEX-function is called as<br>
 * [X,Y] = mymexfun(A,B,C)<br>
 * Then nlhs = 2 and plhs[0] and plhs[1] are pointers (type mxArray*) pointing respectively to X and Y.
 * Similarly, the inputs are given by rlhs = 3 with prhs[0], prhs[1], and prhs[2] pointing respectively to A, B, and C.
 * The output variables are initially unassigned; it is the responsibility of the MEX-function to create them.<br>
 * If nlhs = 0, the MEX-function is still allowed return one output variable, in which case plhs[0] represents the ans variable.
 *
 * @param[in,out] nlhs Number of output variables
 * @param[in,out] plhs[] Array of mxArray pointers to the output variables
 * @param[in] nrhs Number of input variables
 * @param[in] prhs[] Array of mxArray pointers to the input variables
 */
void mexFunction( int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
    /* Define local variable set the data from robot */
    Robot<double> *robot = new Robot<double>;
    double *fromrobot   = new double;
    double *point       = new double;
    double *laserScan   = new double;
    double *laserRes    = new double;
    
    /*
     * assign actual robot x coordinate position
     * assign actual robot y coordinate position
     * assign actual robot orientation coordinate position
     */
    fromrobot = mxGetPr(prhs[0]);
    robot->XcurrentPostion = fromrobot[0];
    robot->YcurrentPostion = fromrobot[1];
    robot->currentOrientation = fromrobot[2];
    
    /* BOUT first pointer to the output variables for steering angle */
#define B_OUT plhs[0]
    
    /*
     * assign actual target x coordinate position
     * assign actual target y coordinate position
     * assign actual target orientation coordinate position
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
            // copy pointer matlab data in std:vector
            setvector2x2(laserScan, Xmeasure, Ymeasure, N, M);
        }
    }
    
    /* init angular laser resoultion */
    std::vector<double> *laser = new std::vector<double>;
    laserRes = mxGetPr(prhs[3]);
    {
        long M = mxGetM(prhs[3]);
        long N = mxGetN(prhs[3]);
        setvector(laserRes, laser, N, M);
    }
    
    /* init velocity */
    double *velocity = new double;
    velocity = mxGetPr(prhs[4]);
    
    /* compute Potetianl Field Method */
    pfm->setTotalPotential(Xmeasure, Ymeasure, laser);
    /* return mex function output */
    B_OUT = mxCreateDoubleScalar(pfm->getSteerangle(velocity));
    
    Xmeasure->clear();
    Ymeasure->clear();
    laser->clear();
    /* garbage collector */
    delete pfm;
    delete robot;
    delete target;
    delete Xmeasure;
    delete Ymeasure;
    delete laser;
}
