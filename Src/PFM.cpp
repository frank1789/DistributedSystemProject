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

#define securdistance 0.55

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
 * @brief calculates the distance between the current point and the target
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
 * @brief calculates the angle between the current point and the target
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
            _XrepulsiveForce +=  (1.0 / pow(distobs.at(j), _k)) * cos(_currentOrientation + laserRes->at(j));
        if (distobs.at(j) <= securdistance && !std::isnan(distobs.at(j)) && laserRes->at(j) < 0)
            _XrepulsiveForce +=  (1.0 / pow(distobs.at(j), _k)) * cos(_currentOrientation - laserRes->at(j));
        // for y
        if (distobs.at(j) <= securdistance && !std::isnan(distobs.at(j)) && laserRes->at(j) >= 0)
            _YrepulsiveForce +=  (1.0 / pow(distobs.at(j), _k)) * sin(_currentOrientation + laserRes->at(j));
        if (distobs.at(j) <= securdistance && !std::isnan(distobs.at(j)) && laserRes->at(j) < 0)
            _YrepulsiveForce +=  (1.0 / pow(distobs.at(j), _k)) * sin(_currentOrientation - laserRes->at(j));
    }
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
 * @brief calculate the potential
 *
 * @param none
 * @return none
 */
inline void PathPlanner::totalPotential()
{
    _XtotalPotential = _XattractiveForce - (_repPotScaling * _XrepulsiveForce);
    _YtotalPotential = _YattractiveForce - (_repPotScaling * _YrepulsiveForce);
    std::cout<<"check TOTAL x force: "<<_XtotalPotential<<std::endl;
    std::cout<<"check TOTAL y force: "<<_YtotalPotential<<std::endl;
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
    std::cout<<"check repuls force: x="<<_XrepulsiveForce<<" y="<<_YrepulsiveForce<<std::endl;
    std::cout<<"check attr   force: x="<<_XattractiveForce<<" y= "<<_YattractiveForce<<std::endl;
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
    std::cout<<"steer: "<<_steer<<"\n";
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

double PathPlanner::repulsivex(int i, std::vector<double> *distanceOstacle, std::vector<double> *laserRes)
{
    double repulsivex = 0;
    
    if (distanceOstacle->size() != 0)
    {
        double obstacledist = sqrt(pow((distanceOstacle->at(i) - _XcurrentPostion), 2)+pow((distanceOstacle->at(i) - _YcurrentPostion),2));
        std::cout<<"distance: "<<obstacledist<<"\n";
        if (laserRes->at(i) >= 0)
        {
            if ((obstacledist > 0 && obstacledist <= securdistance) && !std::isnan(distanceOstacle->at(i)))
            {
                std::cout<<"x angle pos: "<<laserRes->at(i)<<" xmeasure: "<<(distanceOstacle->at(i))<<"\n";
                return repulsivex =  (1.0 / pow(distanceOstacle->at(i), _k)) * cos(laserRes->at(i)) ;
            }
            else return repulsivex = 0;
        }
        else
        {
            if ((obstacledist > 0 && obstacledist <= securdistance) && !std::isnan(distanceOstacle->at(i)))
            {
                std::cout<<"x angle neg: "<<laserRes->at(i)<<" xmeasure: "<<(distanceOstacle->at(i)  - _XcurrentPostion)<<"\n";
                return repulsivex =  (1.0 / pow(distanceOstacle->at(i), _k)) * cos(laserRes->at(i))  ;
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
            if (((distanceOstacle->at(i)) >= securdistance || distanceOstacle->at(i) < -securdistance) && !std::isnan(distanceOstacle->at(i)))
            {
                std::cout<<"y angle pos: "<<laserRes->at(i)<<" ymeasure: "<<(distanceOstacle->at(i))<<"\n";
                return repulsivey =  (1.0 / pow(distanceOstacle->at(i), _k)) * sin(laserRes->at(i));
            }
            else return repulsivey = 0;
        }
        else
        {
            if (((distanceOstacle->at(i)) <= securdistance || distanceOstacle->at(i) > -securdistance) && !std::isnan(distanceOstacle->at(i)))
            {
                std::cout<<"y angle neg: "<<laserRes->at(i)<<" ymeasure: "<<(distanceOstacle->at(i))<<"\n";
                return repulsivey =  (1.0 / pow(distanceOstacle->at(i), _k)) * sin(laserRes->at(i));
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
        
        if (distanceOstacle->size() != 0)
        {
            if (laserRes->at(i) >= 0)
            {
                if (((distanceOstacle->at(i) - _XcurrentPostion) <= securdistance) && !std::isnan(distanceOstacle->at(i)))
                {
                    std::cout<<"x angle pos: "<<laserRes->at(i)<<" xmeasure: "<<(distanceOstacle->at(i) - _XcurrentPostion)<<"\n";
                    _XrepulsiveForce +=  (1.0 / pow(distanceOstacle->at(i), _k)) * cos(_currentOrientation + laserRes->at(i));
                }
                else _XrepulsiveForce += 0;
            }
            else
            {
                if (((distanceOstacle->at(i) - _XcurrentPostion) <= securdistance) && !std::isnan(distanceOstacle->at(i)))
                {
                    std::cout<<"x angle neg: "<<laserRes->at(i)<<" xmeasure: "<<(distanceOstacle->at(i) - _XcurrentPostion)<<"\n";
                    _XrepulsiveForce += (1.0 / pow(distanceOstacle->at(i), _k)) * cos(_currentOrientation - laserRes->at(i));
                }
                else _XrepulsiveForce += 0;
            }
        }
        //        _XrepulsiveForce +=  PathPlanner::repulsivex(i, distanceOstacle, laserRes);
    }
    
    
    // compute y coordinate
    for(int i = 0; i < distanceOstacle->size(); i++)
    {
        
        if (distanceOstacle->size() != 0)
        {
            if (laserRes->at(i) >= 0)
            {
                if (((distanceOstacle->at(i) - _YcurrentPostion) <= securdistance) && !std::isnan(distanceOstacle->at(i)))
                {
                    std::cout<<"y angle pos: "<<laserRes->at(i)<<" measure: "<<(distanceOstacle->at(i) - _YcurrentPostion)<<"\n";
                    _YrepulsiveForce +=  (1.0 / pow(distanceOstacle->at(i), _k)) * sin(_currentOrientation + laserRes->at(i));
                }
                else _YrepulsiveForce += 0;
            }
            else
            {
                if (((distanceOstacle->at(i) - _YcurrentPostion) <= securdistance) && !std::isnan(distanceOstacle->at(i)))
                {
                    std::cout<<"y angle neg: "<<laserRes->at(i)<<" measure: "<<(distanceOstacle->at(i) - _YcurrentPostion)<<"\n";
                    _YrepulsiveForce +=  (1.0 / pow(distanceOstacle->at(i), _k)) * sin(_currentOrientation - laserRes->at(i));
                }
                else _YrepulsiveForce += 0;
            }
        }
        _YrepulsiveForce += 0;
    }
    //        _YrepulsiveForce +=  PathPlanner::repulsivey(i, distanceOstacle, laserRes);
}

void PathPlanner::setTotalPotential(std::vector<double> *distanceOstacle, std::vector<double> *laserRes)
{
    PathPlanner::repulsiveForce(distanceOstacle, laserRes);
    PathPlanner::attractiveForce();
    std::cout<<"check repuls force: x="<<_XrepulsiveForce<<" y="<<_YrepulsiveForce<<std::endl;
    //    std::cout<<"check attr   force: x="<<_XattractiveForce<<" y= "<<_YattractiveForce<<std::endl;
    PathPlanner::totalPotential();
}
