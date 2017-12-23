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

/**
 * Copy matlab array [1 x n] in STL C++ std::vector
 * @param[in]  vectorin {matlab array pointer}
 * @param[in]  vectorout {std::vector<> pointer}
 * @param[in]  N {row dimension matlab array}
 * @param[in]  M {colunm dimension matlab array}
 * @return none
 */
void setvector(double *vectorin, std::vector<double> *vectorout, int &N, int &M);

/**
 * Copy matlab array [2 x n] in STL C++ std::vector
 * @param[in]  vectorin {matlab array pointer}
 * @param[in]  vectorout1 {std::vector<> pointer}
 * @param[in]  vectorout2 {std::vector<> pointer}
 * @param[in]  N {row dimension matlab array}
 * @param[in]  M {colunm dimension matlab array}
 * @return none
 */
void setvector(double *vectorin,
               std::vector<double> *vectorout1,
               std::vector<double> *vectorout2,
               int &N, int &M);

#endif /* robotinterface_hpp */
