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
         */
        PathPlanner(Robot<double> *postion, Point<double> *target);
        /**
         * @brief calculates the distance between the current point and the target
         */
        double distance();
        /**
         * @brief calculates the angle between the current point and the target
         */
        double angle();
        /**
         * @brief calculate the repulise force from obstacle
         */
        void repulsiveForce(std::vector<double> *Xdistance, std::vector<double> *Ydistance, std::vector<double> *laserRes);
        /**
         * @brief calculate the attractive force from target
         */
        void attractiveForce();
        /**
         * @brief calculate the potential
         */
        void totalPotential();
        /**
         * @brief calculate the total potential
         */
        void setTotalPotential(std::vector<double> *Xdistance, std::vector<double> *Ydistance, std::vector<double> *laserRes);
        /**
         * @brief calculates the steering angle
         */
        double getSteerangle(double* robotSpeed);
        /**
         * @brief calculates the speed
         */
        double getSpeed(double *robotSpeed);
        /////////////////////////////////////////////////////////////////////////////////////////////
        void repulsiveForce(std::vector<double> *distanceOstacle, std::vector<double> *laserRes);
        double repulsivex(int i, std::vector<double> *distanceOstacle, std::vector<double> *laserRes);
        double repulsivey(int i, std::vector<double> *distanceOstacle, std::vector<double> *laserRes);
        void setTotalPotential(std::vector<double> *distanceOstacle, std::vector<double> *laserRes);
    private:
        double _distThreshold;  /*!< Obstacle beyond this limit are omitted in calcolus */
        int _k; /*!< Deegre of calculating potential */
        const double _attPotScaling = 20000; /*!< Scaling factor for attractive potential. */
        const double _repPotScaling = 30000; /*!< Scaling factor for repulsive potential. */
        const double _minAttPot = 0.5;       /*!< Minimum attractive potential at any point. */
        double  _XcurrentPostion,    /*!< Postion x robot, point coordinate in plane (x, y) */
                _YcurrentPostion,    /*!< Postion y robot, point coordinate in plane (x, y)  */
                _currentOrientation, /*!< Postion robot current orientation */
                _XnewPostion,        /*!< Target point x coordinate in plane (x, y) */
                _YnewPostion;        /*!< Target point y coordinate in plane (x, y) */
        double _XrepulsiveForce, /*!< Component x repulsive force */
               _YrepulsiveForce, /*!< Component y repulsive force */
               _XattractiveForce, /*!< Component x attractive force */
               _YattractiveForce; /*!< Component y attractive force */
        double _XtotalPotential, /*!< Component x total force */
               _YtotalPotential; /*!< Component y total force */
        double _steer; /*!< steering angle */
    };
}

#endif /* PFM_hpp */
