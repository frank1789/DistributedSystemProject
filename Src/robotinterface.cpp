//
//  robotinterface.cpp
//  Potential Field
//
//  Created by Francesco Argentieri on 22/12/17.
//  Copyright © 2017 Francesco Argentieri. All rights reserved.
//

#include "robotinterface.hpp"
#include <iostream>
#include <vector>
#include <algorithm>
#include <iterator>
#include <thread>

void setdistance(double *laserScan, int &N, int &M) {
  std::vector<double> Xdistance {};
  std::vector<double> Ydistance {};
  for (int n = 0; n < N; n++) {
    for(int m = 0; m < M; m++) {
      ((m + M * n) % 2 == 0) ? (Xdistance.push_back(laserScan[m + M * n])) :
      (Ydistance.push_back(laserScan[m + M * n]));
    }
  }



  // copymatrix(laserScan, Xdistance, 0, M);
  std::cout << "\nx: ";
  for (auto i = Xdistance.begin(); i != Xdistance.end(); ++i)
    std::cout<< *i << ' ';

  std::cout<<"\ny:";
  for (auto i = Ydistance.begin(); i != Ydistance.end(); ++i)
      std::cout << *i << ' ';
};


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
