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

const double PI = 3.141592653589793238463;

namespace PFM {
    
    
    class PathPlanner {
    public:
        PathPlanner(Robot<double> *postion, Point<double> *target);
        const double &distance() const;
        const double &distanceObstacle(int i, std::vector<double> *measure) const;
        // compute repulisve force
        void repulsiveForce(std::vector<double> *Xdistance,
                            std::vector<double> *Ydistance,
                            std::vector<double> *laserRes);
        // compute attractive force
        void attractiveForce();
        // total potential field
        void totalPotential();
        void setTotalPotential(std::vector<double> *Xdistance,
                                 std::vector<double> *Ydistance,
                                 std::vector<double> *laserRes);
        double getSteerangle(double* robotSpeed);
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
        double _XnewPostion,_XcurrentPostion,_YnewPostion, _YcurrentPostion;
        double XrepulsiveForce, YrepulsiveForce;
        double XattractiveForce, YattractiveForce;
        double XtotalPotential, YtotalPotential;
        double _currentOrientation;
        double _steer;
    };
}

#endif /* PFM_hpp */
