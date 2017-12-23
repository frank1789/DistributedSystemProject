//
//  PFM.cpp
//  Potential Field
//
//  Created by Francesco Argentieri on 22/12/17.
//  Copyright © 2017 Francesco Argentieri. All rights reserved.
//

#include "PFM.hpp"
#include <cstdlib>
#include <algorithm>
#include <limits>
#include <cmath>
#include <thread>

using namespace PFM;

PFM::PathPlanner::PathPlanner(Robot<double> *position, Point<double> *target)
{
    _XnewPostion = 12;
    _XcurrentPostion = position->XcurrentPostion;
    _YnewPostion = 12;
    _YcurrentPostion = position->YcurrentPostion;
    _currentOrientation = position->currentOrientation;
    
}

const double & PFM::PathPlanner::distance() const {
    static double distance = sqrt(pow((_XnewPostion - _XcurrentPostion), 2) + pow((_YnewPostion - _YcurrentPostion), 2));
    return distance;
}

const double & PathPlanner::distanceObstacle(int i, std::vector<double> *measure) const {
    if (std::isnan(measure->at(i)))
    {
        return 1.0;
    }
    else
    {
        return measure->at(i);
    }
}

// compute repulsive force
inline void PFM::PathPlanner::repulsiveForce(std::vector<double> *Xdistance,
                                             std::vector<double> *Ydistance,
                                             std::vector<double> *laserRes)
{
    for(int i = 0; i < Xdistance->size(); i++)
    {
        YrepulsiveForce +=  1.0 / pow(distanceObstacle(i, Ydistance), _k) * sin(_currentOrientation - laserRes->at(i));
        XrepulsiveForce +=  1.0 / pow(distanceObstacle(i, Xdistance), _k) * cos(_currentOrientation - laserRes->at(i));
    }
//                        +1.0 / pow((distanceLeft), _k) * sin(_currentOrientation - PI / 2) +
//                        1.0 / pow((distanceRight), _k) * sin(_currentOrientation + PI / 2) +
//                        1.0 / pow((distanceFrontLeftDiagonal), _k) * sin(_currentOrientation - PI / 4) +
//                        1.0 / pow((distanceFrontRightDiagonal), _k) * sin(_currentOrientation + PI / 4);
    //XrepulsiveForce = 1.0 / pow(distance(), _k) * cos(_currentOrientation);
//
//
//
//
//    XrepulsiveForce =   1.0 / pow((distanceFront), _k) * cos(_currentOrientation) +
//                        1.0 / pow((distanceLeft), _k) * cos(_currentOrientation - PI / 2) +
//                        1.0 / pow((distanceRight), _k) * cos(_currentOrientation + PI / 2) +
//                        1.0 / pow((distanceFrontLeftDiagonal), _k) * cos(_currentOrientation - PI / 4) +
//                        1.0 / pow((distanceFrontRightDiagonal), _k) * cos(_currentOrientation + PI / 4);
}

// compute attractive force
inline void PFM::PathPlanner::attractiveForce() {
   YattractiveForce = std::max(pow((1.0 / distance()), _k), _minAttPot) * sin(_currentOrientation) * _attPotScaling;
   XattractiveForce = std::max(pow((1.0 / distance()), _k), _minAttPot) * cos(_currentOrientation) * _attPotScaling;
}

// total potential field
inline void PFM::PathPlanner::totalPotential() {
  XtotalPotential = XattractiveForce - (_repPotScaling * XrepulsiveForce);
  YtotalPotential = YattractiveForce - (_repPotScaling * YrepulsiveForce);
}

double PFM::PathPlanner::getTotalPotential(std::vector<double> *Xdistance,
                                           std::vector<double> *Ydistance,
                                           std::vector<double> *laserRes) {
//    std::thread t1(&Test::calculate, this,  0, 10);
    std::thread repulsive(&PFM::PathPlanner::repulsiveForce, this, Xdistance, Ydistance, laserRes);
    std::thread attractive(&PFM::PathPlanner::attractiveForce, this);
    repulsive.join();
    attractive.join();
    PFM::PathPlanner::totalPotential();
    return XtotalPotential;
}

// compute steerangle for ode45
double PFM::PathPlanner::computeSteerangle(double a, double b) {
    return atan2(a, b) - _currentOrientation;
}
