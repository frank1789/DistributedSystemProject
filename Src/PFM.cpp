//
//  PFM.cpp
//  Potential Field
//
//  Created by Francesco Argentieri on 22/12/17.
//  Copyright © 2017 Francesco Argentieri. All rights reserved.
//

#include "PFM.hpp"
#include <iostream>
#include <cstdlib>
#include <algorithm>
#include <limits>
#include <cmath>
#include <thread>

using namespace PFM;

PathPlanner::PathPlanner(Robot<double> *position, Point<double> *target)
{

    _k = 3;               // initialize deegre of calculating potential
    _distThreshold = 4;   //initialize distance treshold
    // set robot position
    _XcurrentPostion = position->XcurrentPostion;
    _YcurrentPostion = position->YcurrentPostion;
    _currentOrientation = position->currentOrientation;
    std::cout << "robot positon x: " << position->XcurrentPostion;
    std::cout << "\ty: " << position->YcurrentPostion;
    std::cout << "\torientatin: " <<position->currentOrientation <<std::endl;
    // set target point
    _XnewPostion = target->XPostion;
    _YnewPostion = target->YPostion;
    std::cout<< "target positon x: "<< target->XPostion;
    std::cout<< "\ty: "<< target->YPostion;
    std::cout<< "\torientatin: "<< target->Orientation<<std::endl;
}

const double & PathPlanner::distance() const
{
    static double distance = sqrt(pow((_XnewPostion - _XcurrentPostion), 2) + pow((_YnewPostion - _YcurrentPostion), 2));
    return distance;
}

const double & PathPlanner::angle() const
{
    static double angle = atan2((_YnewPostion - _YcurrentPostion),(_XnewPostion - _XcurrentPostion));
    std::cout<<angle<<std::endl;
    return angle;
}

// const double & PathPlanner::distanceObstacle(int i, std::vector<double> *measure) const
// {
//     if (std::isnan(measure->at(i)))
//     {
//         return 1.0;
//     }
//     else
//     {
//         return measure->at(i);
//     }
// }

// compute repulsive force
inline void PathPlanner::repulsiveForce(std::vector<double> *Xdistance,
                                        std::vector<double> *Ydistance,
                                        std::vector<double> *laserRes)
{
    for(int i = 0; i < Xdistance->size(); i++)
    {
        if (Xdistance->at(i) <= 0.40 || !std::isnan(Xdistance->at(i)))
        {
            _YrepulsiveForce +=  1.0 / pow(Ydistance->at(i), _k) * sin(_currentOrientation - laserRes->at(i));
            _XrepulsiveForce +=  1.0 / pow(Xdistance->at(i), _k) * cos(_currentOrientation - laserRes->at(i));
        }
    }
}

// compute attractive force
inline void PathPlanner::attractiveForce()
{
    _YattractiveForce = std::max(pow((1.0 / distance()), _k), _minAttPot) * sin(angle()) * _attPotScaling;
    _XattractiveForce = std::max(pow((1.0 / distance()), _k), _minAttPot) * cos(angle()) * _attPotScaling;
}

// total potential field
inline void PathPlanner::totalPotential()
{
    _XtotalPotential = _XattractiveForce - (_repPotScaling * _XrepulsiveForce);
    _YtotalPotential = _YattractiveForce - (_repPotScaling * _YrepulsiveForce);
}

void PFM::PathPlanner::setTotalPotential(std::vector<double> *Xdistance,
                                         std::vector<double> *Ydistance,
                                         std::vector<double> *laserRes)
{
    std::thread repulsive(&PathPlanner::repulsiveForce, this, Xdistance, Ydistance, laserRes);
    std::thread attractive(&PathPlanner::attractiveForce, this);
    repulsive.join();
    attractive.join();
    PathPlanner::totalPotential();
}

// compute steerangle for ode45
double PathPlanner::getSteerangle(double* robotSpeed)
{
    double potentialvectorX = *robotSpeed * cos(_currentOrientation) + _XtotalPotential;
    double potentialvectorY = *robotSpeed * sin(_currentOrientation) + _YtotalPotential;
    _steer = atan2(potentialvectorY, potentialvectorX) - _currentOrientation;
    return _steer;
}
