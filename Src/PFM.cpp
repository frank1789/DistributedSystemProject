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

#define securdistance 0.45

using namespace PFM;

PathPlanner::PathPlanner(Robot<double> *position, Point<double> *target)
{
    
    _k = 3;               // initialize deegre of calculating potential
    _distThreshold = 4;   //initialize distance treshold
    // set robot position
    _XcurrentPostion = position->XcurrentPostion;
    _YcurrentPostion = position->YcurrentPostion;
    _currentOrientation = position->currentOrientation;
//     std::cout << "robot positon x: " << position->XcurrentPostion;
//     std::cout << "\ty: " << position->YcurrentPostion;
//     std::cout << "\torientatin: " <<position->currentOrientation <<std::endl;
    // set target point
    _XnewPostion = target->XPostion;
    _YnewPostion = target->YPostion;
//     std::cout<< "target positon x: "<< target->XPostion;
//     std::cout<< "\ty: "<< target->YPostion;
//     std::cout<< "\torientatin: "<< target->Orientation<<std::endl;
    //init potetianl force
    _XrepulsiveForce = 0; _XattractiveForce = 0; _XtotalPotential = 0;
    _YrepulsiveForce = 0; _YattractiveForce = 0; _YtotalPotential = 0;
}

const double & PathPlanner::distance() const
{
    static double distance = sqrt(pow((_XnewPostion - _XcurrentPostion), 2) + pow((_YnewPostion - _YcurrentPostion), 2));
    return distance;
}

const double & PathPlanner::angle() const
{
    static double angle = atan2((_YnewPostion - _YcurrentPostion),(_XnewPostion - _XcurrentPostion));
    // std::cout<<angle<<std::endl;
    return angle;
}

// compute repulsive force
inline void PathPlanner::repulsiveForce(std::vector<double> *distanceOstacle,
                                        std::vector<double> *laserRes)
{
    if (distanceOstacle->size() != 0)
    {
        for(int i = 0; i < distanceOstacle->size(); i++)
        {
            // compute x coordinate
            if (laserRes->at(i) >= 0)
            {
                if ((distanceOstacle->at(i) <= securdistance) && !std::isnan(distanceOstacle->at(i)))
                {
//                    std::cout<<"x angle pos: "<<laserRes->at(i)<<" xmeasure: "<<distanceOstacle->at(i)<<"\n";
                    _XrepulsiveForce +=  1.0 / pow(distanceOstacle->at(i), _k) * cos(_currentOrientation + laserRes->at(i));
//                     std::cout<<"repforce X: "<<_XrepulsiveForce<<std::endl;
                }
            }
            else
            {
                if ((distanceOstacle->at(i) <= securdistance) && !std::isnan(distanceOstacle->at(i)))
                {
//                    std::cout<<"angle neg: "<<laserRes->at(i)<<" xmeasure: "<<distanceOstacle->at(i)<<"\n";
                    _XrepulsiveForce +=  1.0 / pow(distanceOstacle->at(i), _k) * cos(_currentOrientation - laserRes->at(i));
//                     std::cout<<"repforce x: "<<_XrepulsiveForce<<std::endl;
                }
            }
            // compute y coordinate
            if (laserRes->at(i) >= 0)
            {
                if ((distanceOstacle->at(i) <= securdistance) && !std::isnan(distanceOstacle->at(i)))
                {
//                    std::cout<<"positive measure y: "<<distanceOstacle->at(i)<<", angle neg: "<<laserRes->at(i)<<std::endl;
                    _YrepulsiveForce +=  1.0 / pow(abs(distanceOstacle->at(i)), _k) * sin(_currentOrientation + laserRes->at(i));
//                    std::cout<<"repforce y: "<<_YrepulsiveForce<<std::endl;
                }
            }
            else
            {
                if ((distanceOstacle->at(i) <= securdistance) && !std::isnan(distanceOstacle->at(i)))
                {
//                    std::cout<<"negative measure y: "<<distanceOstacle->at(i)<<", angle neg: "<<laserRes->at(i)<<std::endl;
                    _YrepulsiveForce +=  1.0 / pow(abs(distanceOstacle->at(i)), _k) * sin(_currentOrientation - laserRes->at(i));
//                    std::cout<<"repforce y: "<<_YrepulsiveForce<<std::endl;
                }
            }
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
    //std::cout<<"repforce: "<<_XrepulsiveForce<<std::endl;
    _XtotalPotential = _XattractiveForce - (_repPotScaling * _XrepulsiveForce);
    _YtotalPotential = _YattractiveForce - (_repPotScaling * _YrepulsiveForce);
    std::cout<<"check TOTAL repuls force: "<<_XtotalPotential<<std::endl;
    std::cout<<"check TOTAL attr   force: "<<_YtotalPotential<<std::endl;
}

void PFM::PathPlanner::setTotalPotential(std::vector<double> *distanceOstacle,
                                         std::vector<double> *laserRes)
{
    //    PathPlanner::repulsiveForce(Xdistance, Ydistance, laserRes);
    repulsiveForce(distanceOstacle, laserRes);
    PathPlanner::attractiveForce();
    std::cout<<"check repuls force: x="<<_XrepulsiveForce<<" y="<<_YrepulsiveForce<<std::endl;
    std::cout<<"check attr force: x="<<_XattractiveForce<<" y= "<<_YattractiveForce<<std::endl;
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

double PathPlanner::getSpeed(double *robotSpeed)
{
    double speedY = pow((*robotSpeed * sin(_currentOrientation) + _YtotalPotential), 2);
    double speedX = pow((*robotSpeed * cos(_currentOrientation) + _YtotalPotential), 2);
    return sqrt(speedX +speedY);
}
