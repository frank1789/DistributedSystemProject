#include "mex.h"
#include "iostream"
#include "geomentity.h"
#include "dungeon.h"
//#include "interface.h"

#define N_ROW 2

void mexFunction( int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])

{
    double* width = mxGetPr(prhs[0]);
    double* height = mxGetPr(prhs[1]);
    double* room = mxGetPr(prhs[2]);
    
    std::cout << "start creating the map " << *width << " x " << *height << "\n";
    std::cout << "take a while..." << std::endl;
    
    int test = static_cast<int>(*width);
    std::cout << test <<std::endl;
    Dungeon d(static_cast<int>(*width), static_cast<int>(*height));
    d.generate(static_cast<int>(*room));
    d.print();
    
    // read data from dungeon generator
//    d.setPointRoom();
//    d.setPointCorridor();
//    // set dimension for output MATLAB array
//    int dim_room_point = 2 * static_cast<int>(d.getRoom().size());
//    // allocate return array
//    double* point = new double[dim_room_point];
//    // fill the array
//    copyarray(d.getRoom(), point, dim_room_point);
//    // return outputs from MEX-function
//    plhs[0] = mxCreateDoubleMatrix(N_ROW, dim_room_point, mxREAL);
//    memcpy(mxGetPr(plhs[0]), point, dim_room_point * sizeof(double));
//    if (nlhs > 1) {
//        plhs[1] = mxCreateDoubleScalar(dim_room_point);
//    }
//
//    // dellocate heap space
//    delete [] point;
}
