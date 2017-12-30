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

// define costant PI
const double PI = 3.141592653589793238463;

namespace PFM {
    class PathPlanner {
    public:
        PathPlanner(Robot<double> *postion, Point<double> *target);
        // compute distance target
        double distance();
        // compute angle target
        double angle();
        // return distance obstacle
        //const double &distanceObstacle(int i, std::vector<double> *measure) const;
        // compute repulisve force
        void repulsiveForce(std::vector<double> *Xdistance,
                            std::vector<double> *Ydistance,
                            std::vector<double> *laserRes);
        // compute attractive force
        void attractiveForce();
        // compute total potential field
        void totalPotential();
        void repulsiveForce(std::vector<double> *distanceOstacle,
                            std::vector<double> *laserRes);
        double repulsivex(int i, std::vector<double> *distanceOstacle, std::vector<double> *laserRes);
        double repulsivey(int i, std::vector<double> *distanceOstacle, std::vector<double> *laserRes);
        void setTotalPotential(std::vector<double> *distanceOstacle,
                               std::vector<double> *laserRes);
        void setTotalPotential(std::vector<double> *Xdistance,
                               std::vector<double> *Ydistance,
                               std::vector<double> *laserRes);
        // compute and return steering angle
        double getSteerangle(double* robotSpeed);
        double getSpeed(double *robotSpeed);
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
