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

#define securdistance 0.40

using namespace PFM;

PathPlanner::PathPlanner(Robot<double> *position, Point<double> *target)
{
    
    _k = 3;               // initialize deegre of calculating potential
    _distThreshold = 4;   //initialize distance treshold
    // set robot position
    _XcurrentPostion = position->XcurrentPostion;
    _YcurrentPostion = position->YcurrentPostion;
    _currentOrientation = position->currentOrientation;
    // std::cout << "robot positon x: " << position->XcurrentPostion;
    // std::cout << "\ty: " << position->YcurrentPostion;
    // std::cout << "\torientatin: " <<position->currentOrientation <<std::endl;
    // set target point
    _XnewPostion = target->XPostion;
    _YnewPostion = target->YPostion;
    // std::cout<< "target positon x: "<< target->XPostion;
    // std::cout<< "\ty: "<< target->YPostion;
    // std::cout<< "\torientatin: "<< target->Orientation<<std::endl;
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
inline void PathPlanner::repulsiveForce(std::vector<double> *Xdistance,
                                        std::vector<double> *Ydistance,
                                        std::vector<double> *laserRes)
{
    if (Xdistance->size() && Ydistance->size() != 0)
    {
        for(int i = 0; i < Xdistance->size(); i++)
        {
            // compute x coordinate
            if (laserRes->at(i) >= 0)
            {
                if ((Xdistance->at(i) <= securdistance && Xdistance->at(i) > 0 ) && !std::isnan(Xdistance->at(i)))
                {
//                    std::cout<<"angle pos: "<<laserRes->at(i)<<"\n";
                    _XrepulsiveForce +=  1.0 / pow(Xdistance->at(i), _k) * cos(_currentOrientation - laserRes->at(i));
                }
            }
            else
            {
//                std::cout<<"angle neg: "<<laserRes->at(i)<<"\n";
                _XrepulsiveForce +=  1.0 / pow(Xdistance->at(i), _k) * cos(_currentOrientation + laserRes->at(i));
            }
            // compute y coordinate
            if ((Ydistance->at(i) < securdistance && Ydistance->at(i) > 0) && !std::isnan(Ydistance->at(i)))
            {
                //std::cout<<"positive measure y: "<<Ydistance->at(i)<<std::endl;
                _YrepulsiveForce +=  1.0 / pow(abs(Ydistance->at(i)), _k) * sin(_currentOrientation - laserRes->at(i));
                //std::cout<<"repforce: "<<_YrepulsiveForce<<std::endl;
            }
            if ((Ydistance->at(i) > (-securdistance) && Ydistance->at(i) != 0) && !std::isnan(Ydistance->at(i)))
            {
                //std::cout<<"negative measure y: "<<Ydistance->at(i)<<std::endl;
                _YrepulsiveForce +=  1.0 / pow(abs(Ydistance->at(i)), _k) * sin(_currentOrientation + laserRes->at(i));
                //std::cout<<"repforce: "<<_YrepulsiveForce<<std::endl;
            }
        }
    }
}

// compute attractive force
inline void PathPlanner::attractiveForce()
{
    _YattractiveForce = std::max(pow((1.0 / distance()), _k), _minAttPot) * sin(angle()) * _attPotScaling;
    _XattractiveForce = std::max(pow((1.0 / distance()), _k), _minAttPot) * cos(angle()) * _attPotScaling;
    //std::cout<<"attr force: "<<_XattractiveForce<<std::endl;
}

// total potential field
inline void PathPlanner::totalPotential()
{
    //std::cout<<"repforce: "<<_XrepulsiveForce<<std::endl;
    _XtotalPotential = _XattractiveForce - (_repPotScaling * _XrepulsiveForce);
    _YtotalPotential = _YattractiveForce - (_repPotScaling * _YrepulsiveForce);
}

void PFM::PathPlanner::setTotalPotential(std::vector<double> *Xdistance,
                                         std::vector<double> *Ydistance,
                                         std::vector<double> *laserRes)
{
    PathPlanner::repulsiveForce(Xdistance, Ydistance, laserRes);
    PathPlanner::attractiveForce();
    //std::cout<<"check repuls force: "<<_XrepulsiveForce<<std::endl;
    std::cout<<"check repuls force: x="<<_XrepulsiveForce<<" y="<<_YrepulsiveForce<<std::endl;
    //std::cout<<"check attr force: "<<_XattractiveForce<<std::endl;
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
