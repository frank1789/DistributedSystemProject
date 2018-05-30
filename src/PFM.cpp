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

#define securdistance 0.65

using namespace PFM;

/**
 * @brief Constructor object pathplanner
 *
 * @param[in] position   robot position coordinate (x, y, orientatation)
 * @param[in] target    target coordinate (x, y, angle)
 * @return none
 */
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

/**
 * @brief calculates euclidean distance between the current point and the target
 *
 * @param none
 * @return distance
 */
double PathPlanner::distance()
{
    double distance = sqrt(pow((_XnewPostion - _XcurrentPostion), 2) + pow((_YnewPostion - _YcurrentPostion), 2));
    return distance;
}

/**
 * @brief calculates the angle by difference between the current point and the target
 *
 * @param none
 * @return angle
 */
double PathPlanner::angle()
{
    double angle = atan2((_YnewPostion - _YcurrentPostion),(_XnewPostion - _XcurrentPostion));
    //    std::cout<<"target angle:"<<angle<<std::endl;
    return angle;
}

/**
 * @brief calculate the repulise force from obstacle
 *
 * @param[in] distance from obstacle in x diection
 * @param[in] distance from obstacle in y diection
 * @param[in] laser scan resolution
 * @return none
 */
void PathPlanner::repulsiveForce(std::vector<double> *Xdistance, std::vector<double> *Ydistance, std::vector<double> *laserRes)
{
    // initialize vector
    std::vector<double> distobs;
    int counterposx, counternegx,counterposy,counternegy;
    counterposx = 0, counternegx = 0,counterposy = 0,counternegy = 0;
    //compute distance in robot reference frame
    for (int i = 0; i < Xdistance->size(); i++)
    {
        distobs.push_back(sqrt(pow((Xdistance->at(i) - _XcurrentPostion), 2) + pow((Ydistance->at(i) - _YcurrentPostion), 2)));
    }
    //calculates the repulsive potential when the content of the vector is less than the safety distance and when it is not NaN
    for (int j = 0; j < distobs.size(); j++)
    {
        // for x
        if (distobs.at(j) <= securdistance && !std::isnan(distobs.at(j)) && laserRes->at(j) >= 0)
        {
            _XrepulsiveForce +=  (1.0 / pow(distobs.at(j), _k)) * cos(_currentOrientation + laserRes->at(j));
            //            std::cout<<"iter: "<<j<<" dist: "<<distobs.at(j)<<" orient: "<<_currentOrientation<<" laser: "<<laserRes->at(j)<<" computed: "<< _XrepulsiveForce<<"\n";
            ++counterposx;
            //            std::cout<<"counter pos x: "<<counterposx<<"\n";
        }
        if (distobs.at(j) <= securdistance && !std::isnan(distobs.at(j)) && laserRes->at(j) < 0)
        {
            _XrepulsiveForce +=  (1.0 / pow(distobs.at(j), _k)) * cos(_currentOrientation - laserRes->at(j));
            //            std::cout<<"iter: "<<j<<" dist: "<<distobs.at(j)<<" orient: "<<_currentOrientation<<" neg laser: "<<laserRes->at(j)<<" computed: "<< _XrepulsiveForce<<"\n";
            ++counternegx; //std::cout<<"counter neg x: "<<counternegx<<"\n";
        }
        // for y
        if (distobs.at(j) <= securdistance && !std::isnan(distobs.at(j)) && laserRes->at(j) >= 0)
        {
            _YrepulsiveForce +=  (1.0 / pow(distobs.at(j), _k)) * sin(_currentOrientation + laserRes->at(j));
            //            std::cout<<"iter: "<<j<<" dist: "<<distobs.at(j)<<" orient: "<<_currentOrientation<<" laser: "<<laserRes->at(j)<<" computed: "<< _YrepulsiveForce<<"\n";
            ++counterposy;
        }
        if (distobs.at(j) <= securdistance && !std::isnan(distobs.at(j)) && laserRes->at(j) < 0)
        {
            _YrepulsiveForce +=  (1.0 / pow(distobs.at(j), _k)) * sin(_currentOrientation - laserRes->at(j));
            //            std::cout<<"iter: "<<j<<" dist: "<<distobs.at(j)<<" orient: "<<_currentOrientation<<" neg y laser: "<<laserRes->at(j)<<" computed: "<< _YrepulsiveForce<<"\n";
            ++counternegy;
        }
    }
    // avoid bad angle at start
    (counternegy > 0 && counterposy == 0) ? (_YrepulsiveForce = _YrepulsiveForce * -1) : (_YrepulsiveForce);
    (counternegx > 0 && counterposx == 0) ? (_XrepulsiveForce = _XrepulsiveForce * -1) : (_XrepulsiveForce);
}

/**
 * @brief calculate the attractive force from target
 *
 * @param none
 * @return none
 */
inline void PathPlanner::attractiveForce()
{
    _YattractiveForce = std::max(pow((1.0 / PathPlanner::distance()), _k), _minAttPot) * sin(PathPlanner::angle()) * _attPotScaling;
    _XattractiveForce = std::max(pow((1.0 / PathPlanner::distance()), _k), _minAttPot) * cos(PathPlanner::angle()) * _attPotScaling;
}

/**
 * @brief calculate the total potential
 *
 * @param none
 * @return none
 */
inline void PathPlanner::totalPotential()
{
    _XtotalPotential = _XattractiveForce - (_repPotScaling * _XrepulsiveForce);
    _YtotalPotential = _YattractiveForce - (_repPotScaling * _YrepulsiveForce);
    //    std::cout<<"check TOTAL x force: "<<_XtotalPotential<<std::endl;
    //    std::cout<<"check TOTAL y force: "<<_YtotalPotential<<std::endl;
}

/**
 * @brief calculate the total potential
 *
 * @param[in] distance from obstacle in x diection
 * @param[in] distance from obstacle in y diection
 * @param[in] laser scan resolution
 * @return none
 */
void PathPlanner::setTotalPotential(std::vector<double> *Xdistance, std::vector<double> *Ydistance, std::vector<double> *laserRes)
{
    // compute repulisve force
    PathPlanner::repulsiveForce(Xdistance, Ydistance, laserRes);
    //compute attractive force
    PathPlanner::attractiveForce();
    //    std::cout<<"check repuls force: x="<<_XrepulsiveForce<<" y="<<_YrepulsiveForce<<std::endl;
    //    std::cout<<"check attr   force: x="<<_XattractiveForce<<" y= "<<_YattractiveForce<<std::endl;
    // compute total potential
    PathPlanner::totalPotential();
}

/**
 * @brief calculates the steering angle
 *
 * @param[in] robot speed
 * @return steering angle
 */
double PathPlanner::getSteerangle(double* robotSpeed)
{
    double potentialvectorX = *robotSpeed * cos(_currentOrientation) + _XtotalPotential;
    double potentialvectorY = *robotSpeed * sin(_currentOrientation) + _YtotalPotential;
    _steer = atan2(potentialvectorY, potentialvectorX) - _currentOrientation;
    //    std::cout<<"steer: "<<_steer<<"\n";
    return _steer;
}

/**
 * @brief calculates the speed
 *
 * @param[in] robot speed
 * @return speed
 */
double PathPlanner::getSpeed(double *robotSpeed)
{
    double speedY = pow((*robotSpeed * sin(_currentOrientation) + _YtotalPotential), 2);
    double speedX = pow((*robotSpeed * cos(_currentOrientation) + _XtotalPotential), 2);
    return sqrt(speedX +speedY);
}

PathPlanner::~PathPlanner()  { }
