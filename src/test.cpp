#include "mex.h"
#include "iostream"
#include "geomentity.h"
#include "dungeon.h"

void mexFunction( int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[])
        
{
    double* width = mxGetPr(prhs[0]);
    double* height = mxGetPr(prhs[1]);
    double* room = mxGetPr(prhs[2]);
    std::cout<<"hello\n";
    std::cout << "start creating the map " << *width << " x " << *height << "\n";
    std::cout << "take a while..." << std::endl;
    
    int test = static_cast<int>(*width);
    std::cout << test <<std::endl;
    Dungeon d(static_cast<int>(*width), static_cast<int>(*height));
    d.generate(static_cast<int>(*room));
    d.print();
}