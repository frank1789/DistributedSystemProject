#include "mex.h"
#include "geomentity.h"
#include "dungeon.h"
#include "interface.h"
#include "myclass.h"
#include <iostream>
#include <vector>

#define N_ROW 2

void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    // gateway value
    if (nrhs == 3)
        {
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
            std::vector<int>* wall = new std::vector<int>;
            std::vector<int>* corridor = new std::vector<int>;
            std::vector<int>* structure = new std::vector<int>;
            copyarray(d.getRoom(), rooms);
            copyarray(d.getWall(), wall);
            copyarray(d.getCorridor(), corridor);
            unsigned long dim = rooms->size() + wall->size() + corridor->size();
            structure->reserve(dim);
            structure->insert(structure->end(), rooms->begin(), rooms->end());
            structure->insert(structure->end(), corridor->begin(), corridor->end());
            structure->insert(structure->end(), wall->begin(), wall->end());
            double* points = new double [structure->size()];
            std::copy(structure->begin(), structure->end(), points); // copy room's points
            // set dimension for output MATLAB array, then allocate return array
            // connect line
            std::vector<int>* point_to_point = new std::vector<int>;
            connectpoint(d.getRoom(), point_to_point);
            connectpoint(d.getCorridor(), point_to_point);
            unsigned long dim_line = point_to_point->size() ;
            double* line = new double[dim_line];
            std::copy(point_to_point->begin(), point_to_point->end(), line);
            
            map::MyClass b(d.getWall());
            b.setPointsMatlab();
            std::vector<double>* t = new std::vector<double>;
            for (auto j: b.getPointsMatlab()) t->push_back(j);
            double* test = new double[t->size()];
            std::copy(t->begin(), t->end(), test);
            

            // preallocated return array
            plhs[0] = mxCreateDoubleMatrix(N_ROW, structure->size()/2, mxREAL);
            plhs[1] = mxCreateDoubleMatrix(N_ROW, dim_line/2, mxREAL);
            plhs[2] = mxCreateDoubleMatrix(N_ROW, b.getPointsMatlab().size(), mxREAL);

            // return outputs from MEX-function
            if (nlhs >= 2)
                {
                    memcpy(mxGetPr(plhs[0]), points, structure->size() * sizeof(double));
                    memcpy(mxGetPr(plhs[1]), line, dim_line * sizeof(double));
                    memcpy(mxGetPr(plhs[2]), test, b.getPointsMatlab().size()* sizeof(double));
                }
            else // exit MEX file
                mexErrMsgIdAndTxt("MyProg:ConvertString", "Four return variables are required.");


            // dellocate heap space
            delete [] points;
            delete [] line;
            delete rooms;
            delete structure;
            delete corridor;
            delete wall;
            delete point_to_point;
            delete [] test;
            delete t;

        }
    else
        mexErrMsgIdAndTxt("MyProg:ConvertString", "Three input parameters are required:\n\t width,\n\t height,\n\t number of rooms");
}
