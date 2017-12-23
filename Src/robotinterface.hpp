//
//  robotinterface.hpp
//  Potential Field
//
//  Created by Francesco Argentieri on 22/12/17.
//  Copyright © 2017 Francesco Argentieri. All rights reserved.
//

#ifndef robotinterface_hpp
#define robotinterface_hpp

#include <stdio.h>
#include <vector>

template <typename T>
struct Robot {
    T XcurrentPostion;
    T YcurrentPostion;
    T currentOrientation;
};

template <>
struct Robot<double> {
    double XcurrentPostion;
    double YcurrentPostion;
    double currentOrientation;
};

template <typename T>
struct Point {
  T XPostion;
  T YPostion;
  T Orientation;
};

template <>
struct Point<double> {
  double XPostion;
  double YPostion;
  double Orientation;
};

struct LaserScan {
  double Xmeasure;
  double Ymeasure;
};

void setdistance(double *laserScan, int &N, int &M);

void setvector(double *vectorin, std::vector<double> *vectorout, int &N, int &M);




#endif /* robotinterface_hpp */
