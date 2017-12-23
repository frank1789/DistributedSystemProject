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

const double & PFM::PathPlanner::distance() const
{
    static double distance = sqrt(pow((_XnewPostion - _XcurrentPostion), 2) + pow((_YnewPostion - _YcurrentPostion), 2));
    return distance;
}

const double & PathPlanner::distanceObstacle(int i, std::vector<double> *measure) const
{
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
        _YrepulsiveForce +=  1.0 / pow(distanceObstacle(i, Ydistance), _k) * sin(_currentOrientation - laserRes->at(i));
        _XrepulsiveForce +=  1.0 / pow(distanceObstacle(i, Xdistance), _k) * cos(_currentOrientation - laserRes->at(i));
    }
}

// compute attractive force
inline void PFM::PathPlanner::attractiveForce()
{
    _YattractiveForce = std::max(pow((1.0 / distance()), _k), _minAttPot) * sin(_currentOrientation) * _attPotScaling;
    _XattractiveForce = std::max(pow((1.0 / distance()), _k), _minAttPot) * cos(_currentOrientation) * _attPotScaling;
}

// total potential field
inline void PFM::PathPlanner::totalPotential()
{
    _XtotalPotential = _XattractiveForce - (_repPotScaling * _XrepulsiveForce);
    _YtotalPotential = _YattractiveForce - (_repPotScaling * _YrepulsiveForce);
}

inline void PFM::PathPlanner::setTotalPotential(std::vector<double> *Xdistance,
                                                std::vector<double> *Ydistance,
                                                std::vector<double> *laserRes)
{
    std::thread repulsive(&PFM::PathPlanner::repulsiveForce, this, Xdistance, Ydistance, laserRes);
    std::thread attractive(&PFM::PathPlanner::attractiveForce, this);
    repulsive.join();
    attractive.join();
    PFM::PathPlanner::totalPotential();
}

// compute steerangle for ode45
double PFM::PathPlanner::getSteerangle(double* robotSpeed)
{
    double potentilavectorX = *robotSpeed * cos(_currentOrientation) + _XtotalPotential;
    double potentilavectorY = *robotSpeed * sin(_currentOrientation) + _YtotalPotential;
    _steer = atan2(potentilavectorY, potentilavectorX) - _currentOrientation;
    return _steer;
}
