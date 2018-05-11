#include "mex.h"
#include "matrix.h"
#include "leaf.h"
#include "interface.h"
#include <iostream>
#include <ctime>
#include <cstdlib>
#include <deque>

#define N_ROW 2

void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    if (nrhs == 2)
    {
        /* gateway value*/
        double* ptr_width   = mxGetPr(prhs[0]);
        double* ptr_height  = mxGetPr(prhs[1]);
        
        int width = static_cast<int>(*ptr_width);
        int height= static_cast<int>(*ptr_height);
        
        /* build dungeon */
        srand(time(NULL)); // initialize seed
        // perform construction
        std::deque<Leaf>* leafs = new std::deque<Leaf> {};
        std::deque<Rectangle>* hall = new std::deque<Rectangle> {};
        // first, create a Leaf to be the 'root' of all Leafs.
        Leaf* root = new Leaf(0, 0, width, height);
        for(int i = 0; i < MAX_LEAF_SIZE; i++)
            root->generate();
        // generate room & hallway
        root->createRoom(*leafs, *hall);
        
        /* create map */
        // initialize matrix to export
        int rows = width;
        int cols = height;
        int** matrix = new int*[rows];
        if (rows)
        {
            matrix[0] = new int[rows * cols];
            for (int i = 1; i < rows; ++i)
                matrix[i] = matrix[0] + i * cols;
        }
        
        setvoidmap(matrix, width, height); //prepare void map
        setroom(*leafs, width, height, matrix); // fill with room
        setcorridor(*hall, width, height, matrix); // fill with hallway
        
        /* print */
        //            for (int j = 0; j < width; j++) {
        //                for (int i = 0; i < height; i++){
        //                    std::cout << matrix[i][j];
        //                }
        //                std::cout << "\n";
        //            }
        
        /* return matrix MATLAB */
        plhs[0] = mxCreateDoubleMatrix(rows, cols, mxREAL);
        double *B;
        B = mxGetPr(plhs[0]);
        
        for(int n = 0; n < cols; n++)
            for(int m = 0; m < rows; m++)
                B[m + rows * n] = matrix[n][m];
        
        /* free the heap */
        delete leafs;
        delete hall;
        delete root;
        if (rows) delete [] matrix[0];
        delete [] matrix;
    }
    else
        mexErrMsgIdAndTxt("MyProg:ConvertString", "Three input parameters are required:\n\t width,\n\t height,\n\t number of rooms");
}
