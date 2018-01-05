//
//  PFM.hpp
//  Potential Field
//
//  Created by Francesco Argentieri on 22/12/17.
//  Copyright © 2017 Francesco Argentieri. All rights reserved.
//

#ifndef PFM_hpp
#define PFM_hpp

#include <stdio.h>
#include "robotinterface.hpp"

/// define mathematical constant PI
const double PI = 3.141592653589793238463;

namespace PFM {
    /**
     * \class PathPlanner
     *
     *
     */
    class PathPlanner {
    public:
        /**
         * @brief Constructor
         * @param position  robot position coordinate (x, y, orientatation)
         * @param target    target coordinate (x, y, angle)
         * @return none
         */
        PathPlanner(Robot<double> *postion, Point<double> *target);
        /**
         * @brief calculates the distance between the current point and the target
         *
         * @param none
         * @return distance
         */
        double distance();
        /**
         * @brief calculates the angle between the current point and the target
         *
         * @param none
         * @return angle
         */
        double angle();
        /**
         * @brief calculate the repulise force from obstacle
         *
         * @param[in] distance from obstacle in x diection
         * @param[in] distance from obstacle in y diection
         * @param[in] laser scan resolution
         * @return none
         */
        void repulsiveForce(std::vector<double> *Xdistance, std::vector<double> *Ydistance, std::vector<double> *laserRes);
        /**
         * @brief calculate the attractive force from target
         *
         * @param none
         * @return none
         */
        void attractiveForce();
        /**
         * @brief calculate the potential
         *
         * @param none
         * @return none
         */
        void totalPotential();
        /**
         * @brief calculate the total potential
         *
         * @param[in] distance from obstacle in x diection
         * @param[in] distance from obstacle in y diection
         * @param[in] laser scan resolution
         * @return none
         */
        void setTotalPotential(std::vector<double> *Xdistance, std::vector<double> *Ydistance, std::vector<double> *laserRes);
        /**
         * @brief calculates the steering angle
         *
         * @param[in] robot speed
         * @return steering angle
         */
        double getSteerangle(double* robotSpeed);
        /**
         * @brief calculates the speed
         *
         * @param[in] robot speed
         * @return speed
         */
        double getSpeed(double *robotSpeed);
        /////////////////////////////////////////////////////////////////////////////////////////////
        void repulsiveForce(std::vector<double> *distanceOstacle, std::vector<double> *laserRes);
        double repulsivex(int i, std::vector<double> *distanceOstacle, std::vector<double> *laserRes);
        double repulsivey(int i, std::vector<double> *distanceOstacle, std::vector<double> *laserRes);
        void setTotalPotential(std::vector<double> *distanceOstacle, std::vector<double> *laserRes);
    private:
        // Obstacle beyond this limit are omitted in calcolus
        double _distThreshold;
        // Deegre of calculating potential
        int _k;
        // Scaling factor for attractive potential.
        const double _attPotScaling = 20000;
        // Scaling factor for repulsive potential.
        const double _repPotScaling = 30000;
        // Minimum attractive potential at any point.
        const double _minAttPot = 0.5;
        // Postion robot and target point coordinate in plane (x, y) and current angle orientation
        double _XcurrentPostion, _XnewPostion, _YnewPostion, _YcurrentPostion;
        double _currentOrientation;
        // Component force value and total value
        double _XrepulsiveForce, _YrepulsiveForce, _XattractiveForce, _YattractiveForce;
        double _XtotalPotential, _YtotalPotential;
        // steering angle
        double _steer;
    };
}

#endif /* PFM_hpp */
