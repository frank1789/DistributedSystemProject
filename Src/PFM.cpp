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
//         std::cout << "robot positon x: " << position->XcurrentPostion;
//         std::cout << "\ty: " << position->YcurrentPostion;
//         std::cout << "\torientatin: " <<position->currentOrientation <<std::endl;
    // set target point
    _XnewPostion = target->XPostion;
    _YnewPostion = target->YPostion;
//         std::cout<< "target positon x: "<< target->XPostion;
//         std::cout<< "\ty: "<< target->YPostion;
//         std::cout<< "\torientatin: "<< target->Orientation<<std::endl;
    //init potetianl force
    _XrepulsiveForce = 0; _XattractiveForce = 0; _XtotalPotential = 0;
    _YrepulsiveForce = 0; _YattractiveForce = 0; _YtotalPotential = 0;
}

double PathPlanner::distance()
{
    double distance = sqrt(pow((_XnewPostion - _XcurrentPostion), 2) + pow((_YnewPostion - _YcurrentPostion), 2));
    return distance;
}

double PathPlanner::angle()
{
    double angle = atan2((_YnewPostion - _YcurrentPostion),(_XnewPostion - _XcurrentPostion));
    std::cout<<"target angle:"<<angle<<std::endl;
    return angle;
}




double PathPlanner::repulsivex(int i, std::vector<double> *distanceOstacle, std::vector<double> *laserRes)
{
    static double repulsivex = 0;
    
    if (distanceOstacle->size() != 0)
    {
        if (laserRes->at(i) >= 0)
        {
            if ((distanceOstacle->at(i) <= securdistance) && !std::isnan(distanceOstacle->at(i)))
            {
//                                std::cout<<"x angle pos: "<<laserRes->at(i)<<" xmeasure: "<<distanceOstacle->at(i)<<"\n";
                return repulsivex =  1.0 / pow(distanceOstacle->at(i), _k) * cos(_currentOrientation + laserRes->at(i));
            }
            else return repulsivex = 0;
        }
        else
        {
            if ((distanceOstacle->at(i) <= securdistance) && !std::isnan(distanceOstacle->at(i)))
            {
//                              std::cout<<"x angle neg: "<<laserRes->at(i)<<" xmeasure: "<<distanceOstacle->at(i)<<"\n";
                return repulsivex =  1.0 / pow(distanceOstacle->at(i), _k) * cos(_currentOrientation - laserRes->at(i));
            }
            else return repulsivex = 0;
        }
    }
    return repulsivex;
}
    
    
    
    
    
    
double PathPlanner::repulsivey(int i, std::vector<double> *distanceOstacle, std::vector<double> *laserRes)
{
    static double repulsivey = 0;
    
    if (distanceOstacle->size() != 0)
    {
        if (laserRes->at(i) >= 0)
        {
            if ((distanceOstacle->at(i) <= securdistance) && !std::isnan(distanceOstacle->at(i)))
            {
//                std::cout<<"y angle pos: "<<laserRes->at(i)<<" measure: "<<distanceOstacle->at(i)<<"\n";
                return repulsivey =  1.0 / pow(distanceOstacle->at(i), _k) * sin(_currentOrientation + laserRes->at(i));
            }
            else return repulsivey = 0;
        }
        else
        {
            if ((distanceOstacle->at(i) <= securdistance) && !std::isnan(distanceOstacle->at(i)))
            {
//                std::cout<<"y angle neg: "<<laserRes->at(i)<<" measure: "<<distanceOstacle->at(i)<<"\n";
                return repulsivey =  1.0 / pow(distanceOstacle->at(i), _k) * sin(_currentOrientation - laserRes->at(i));
            }
            else return repulsivey = 0;
        }
    }
    return repulsivey;
}


// compute repulsive force
inline void PathPlanner::repulsiveForce(std::vector<double> *distanceOstacle, std::vector<double> *laserRes)
{
    // compute x coordinate
    for(int i = 0; i < distanceOstacle->size(); i++)
    {
        _XrepulsiveForce +=  PathPlanner::repulsivex(i, distanceOstacle, laserRes);
    }
    
    // compute y coordinate
    for(int i = 0; i < distanceOstacle->size(); i++)
    {
        _YrepulsiveForce +=  PathPlanner::repulsivey(i, distanceOstacle, laserRes);
    }
}

// compute attractive force
inline void PathPlanner::attractiveForce()
{
    _YattractiveForce = std::max(pow((1.0 / PathPlanner::distance()), _k), _minAttPot) * sin(PathPlanner::angle()) * _attPotScaling;
    _XattractiveForce = std::max(pow((1.0 / PathPlanner::distance()), _k), _minAttPot) * cos(PathPlanner::angle()) * _attPotScaling;
}

// total potential field
inline void PathPlanner::totalPotential()
{
    //std::cout<<"repforce: "<<_XrepulsiveForce<<std::endl;
    std::cout<<"total BEFORE check repuls force: x="<<_XrepulsiveForce<<" y="<<_YrepulsiveForce<<std::endl;
    std::cout<<"total BEFORE check attr   force: x="<<_XattractiveForce<<" y= "<<_YattractiveForce<<std::endl;
    _XtotalPotential = _XattractiveForce - (_repPotScaling * _XrepulsiveForce);
    _YtotalPotential = _YattractiveForce - (_repPotScaling * _YrepulsiveForce);
    std::cout<<"check TOTAL x force: "<<_XtotalPotential<<std::endl;
    std::cout<<"check TOTAL y force: "<<_YtotalPotential<<std::endl;
}

void PathPlanner::setTotalPotential(std::vector<double> *distanceOstacle, std::vector<double> *laserRes)
{
    //    PathPlanner::repulsiveForce(Xdistance, Ydistance, laserRes);
    repulsiveForce(distanceOstacle, laserRes);
    PathPlanner::attractiveForce();
//    std::cout<<"check repuls force: x="<<_XrepulsiveForce<<" y="<<_YrepulsiveForce<<std::endl;
//    std::cout<<"check attr   force: x="<<_XattractiveForce<<" y= "<<_YattractiveForce<<std::endl;
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

