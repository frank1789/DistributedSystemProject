#include "mex.h"
#include "geomentity.h"
#include "dungeon.h"
#include "interface.h"
#include <iostream>
#include <vector>

#define N_ROW 2

void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    // gateway value
    double* width   = mxGetPr(prhs[0]);
    double* height  = mxGetPr(prhs[1]);
    double* room    = mxGetPr(prhs[2]);
    std::cout << "start creating the map " << *width << " x " << *height <<std::endl;
    std::cout << "take a while..." << std::endl;
    
    //generate dungeon - cast from double to int
    Dungeon d(static_cast<int>(*width), static_cast<int>(*height));
    d.generate(static_cast<int>(*room));
    d.print();
    
    // read data from dungeon generator
    d.setPointRoom();
    
    // set dimension for output MATLAB array, then allocate return array
    int dim_room_point = static_cast<int>(d.getRoom().size());
    double* points = new double [dim_room_point];
    copyarray(d.getRoom(), points); // copy room's points
    
    // connect line
    std::vector<int>* point_to_point = new std::vector<int>;
    connectpoint(d.getRoom(), point_to_point);
    double* line = new double[point_to_point->size()];
    std::copy(point_to_point->begin(), point_to_point->end(), line);
    
    // preallocated return array
    plhs[0] = mxCreateDoubleMatrix(N_ROW, dim_room_point, mxREAL);
    plhs[1] = mxCreateDoubleMatrix(N_ROW, point_to_point->size()/2, mxREAL);
    
    // return outputs from MEX-function
    if (nlhs == 2)
    {
        memcpy(mxGetPr(plhs[0]), points, dim_room_point * sizeof(double));
        memcpy(mxGetPr(plhs[1]), line, point_to_point->size() * sizeof(double));
    }
    else
    {
        mexErrMsgIdAndTxt("MyProg:ConvertString", "Two return variables are required.");
        // exit MEX file
    }
    // dellocate heap space
    delete [] points;
    delete [] line;
    delete point_to_point;
}
