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

template <typename T>
struct LaserScan {
    T Xmeasure;
    T Ymeasure;
};

template <>
struct LaserScan<double>;

template <typename T1, typename T2, typename T3>
void setvector(T1 *vectorin, T2 *vectorout, T3 &N, T3 &M);

template <>
void setvector(double *vectorin, std::vector<double> *vectorout, int &N, int &M);

template <>
void setvector(double *vectorin, std::vector<double> *vectorout, long &N, long &M);

template <typename T1, typename T2, typename T3>
void setvector2x2(T1 *vectorin, T2 *vectorout1, T2 *vectorout2, T3 &N, T3 &M);

template<>
void setvector2x2(double *vectorin,
               std::vector<double> *vectorout1,
               std::vector<double> *vectorout2,
               int &N, int &M);

template<>
void setvector2x2(double *vectorin,
               std::vector<double> *vectorout1,
               std::vector<double> *vectorout2,
               long &N, long &M);


#endif /* robotinterface_hpp */
