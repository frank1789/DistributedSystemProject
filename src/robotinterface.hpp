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

/**
 * @brief Robot position
 * @tparam T type
 */
template <typename T>
struct Robot {
    T XcurrentPostion;  /**< x current postion. */
    T YcurrentPostion;  /**< y current postion.. */
    T currentOrientation;   /**< current angle orientation. */
};

/**
 * @brief Robot position specializzation
 * @see Robot position
 * @tparam T specializzation double
 */
template <>
struct Robot<double> {
    double XcurrentPostion;
    double YcurrentPostion;
    double currentOrientation;
};

/**
 * @brief Objective point to reach
 * @tparam T type
 */
template <typename T>
struct Point {
    T XPostion; /**< x position in global reference frame. */
    T YPostion; /**< y position in global reference frame. */
    T Orientation;  /**< orientation position in global reference frame. */
};

/**
 * @brief Objective point to reach
 * @see Objective point to reach
 * @tparam T specializzation double
 */
template <>
struct Point<double> {
    double XPostion;
    double YPostion;
    double Orientation;
};

/**
 * @brief Measure from laser scan
 * @tparam T type
 */
template <typename T>
struct LaserScan {
    T Xmeasure; /**< x measure distance in robot reference frame. */
    T Ymeasure; /**< y measure distance in robot reference frame. */
};

template <>
struct LaserScan<double>;

//define function to copy from matlab array in std::vector
template <typename T1, typename T2, typename T3>
void setvector(T1 *vectorin, T2 *vectorout, T3 &N, T3 &M);
//specialization
template <>
void setvector(double *vectorin, std::vector<double> *vectorout, int &N, int &M);
//specialization
template <>
void setvector(double *vectorin, std::vector<double> *vectorout, long &N, long &M);

//define function to copy from matlab array in two distinct std::vector
template <typename T1, typename T2, typename T3>
void setvector2x2(T1 *vectorin, T2 *vectorout1, T2 *vectorout2, T3 &N, T3 &M);
//specialization
template<>
void setvector2x2(double *vectorin, std::vector<double> *vectorout1, std::vector<double> *vectorout2, int &N, int &M);
//specialization
template<>
void setvector2x2(double *vectorin, std::vector<double> *vectorout1, std::vector<double> *vectorout2, long &N, long &M);


#endif /* robotinterface_hpp */
