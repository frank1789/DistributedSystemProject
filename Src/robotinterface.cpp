//
//  robotinterface.cpp
//  Potential Field
//
//  Created by Francesco Argentieri on 22/12/17.
//  Copyright © 2017 Francesco Argentieri. All rights reserved.
//

#include "robotinterface.hpp"
#include <iostream>

void setvector(double *vectorin, std::vector<double> *vectorout, int &N, int &M) {
  if (N == 1)
  {
    for(int m = 0; m < M; m++)
    {
      double tmp = vectorin[m];
      vectorout->push_back(tmp);
    }
  }
  else
  {
    for (int n = 0; n < N; n++)
    {
      for(int m = 0; m < M; m++)
      {
        double tmp = vectorin[m + M * n];
        vectorout->push_back(tmp);
      }
    }
  }
}


void setvector(double *vectorin,
  std::vector<double> *vectorout1,
  std::vector<double> *vectorout2,
  int &N, int &M) {
    for (int n = 0; n < N; n++)
    {
      for(int m = 0; m < M; m++)
      {
        ((m + M * n) % 2 == 0) ? (vectorout1->push_back(vectorin[m + M * n])) :
        (vectorout2->push_back(vectorin[m + M * n]));
      }
    }
  }
