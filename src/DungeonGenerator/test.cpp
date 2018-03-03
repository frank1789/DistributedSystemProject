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
    std::vector<int>* rooms = new std::vector<int>;
    copyarray(d.getRoom(), rooms);
    double* points = new double [rooms->size()];
    std::copy(rooms->begin(), rooms->end(), points); // copy room's points
    
    // set dimension for output MATLAB array, then allocate return array
    std::vector<int>* corridor = new std::vector<int>;
    copyarray(d.getCorridor(), corridor);
    double* c_points = new double [corridor->size()];
    std::copy(corridor->begin(), corridor->end(), c_points); // copy room's points
    
    // connect line
    std::vector<int>* point_to_point = new std::vector<int>;
    connectpoint(d.getRoom(), point_to_point);
    double* line = new double[point_to_point->size()];
    std::copy(point_to_point->begin(), point_to_point->end(), line);
    
    // connect line
    std::vector<int>* cpoint_to_cpoint = new std::vector<int>;
    connectpoint(d.getCorridor(), cpoint_to_cpoint);
    double* c_line = new double[cpoint_to_cpoint->size()];
    std::copy(cpoint_to_cpoint->begin(), cpoint_to_cpoint->end(), c_line);
    
    
    // preallocated return array
    plhs[0] = mxCreateDoubleMatrix(N_ROW, rooms->size()/2, mxREAL);
    plhs[1] = mxCreateDoubleMatrix(N_ROW, point_to_point->size()/2, mxREAL);
    plhs[2] = mxCreateDoubleMatrix(N_ROW, corridor->size()/2, mxREAL);
    plhs[3] = mxCreateDoubleMatrix(N_ROW, cpoint_to_cpoint->size()/2, mxREAL);
    
    // return outputs from MEX-function
    if (nlhs == 4)
    {
        memcpy(mxGetPr(plhs[0]), points, rooms->size() * sizeof(double));
        memcpy(mxGetPr(plhs[1]), line, point_to_point->size() * sizeof(double));
        memcpy(mxGetPr(plhs[2]), c_points, corridor->size() * sizeof(double));
        memcpy(mxGetPr(plhs[3]), c_line, cpoint_to_cpoint->size() * sizeof(double));
    }
    else
    {
        mexErrMsgIdAndTxt("MyProg:ConvertString", "Two return variables are required.");
        // exit MEX file
    }
    // dellocate heap space
    delete [] points;
    delete [] line;
    delete [] c_points;
    delete rooms;
    delete point_to_point;
    delete corridor;
}
