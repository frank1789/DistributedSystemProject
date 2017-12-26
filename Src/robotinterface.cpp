//
//  robotinterface.cpp
//  Potential Field
//
//  Created by Francesco Argentieri on 22/12/17.
//  Copyright © 2017 Francesco Argentieri. All rights reserved.
//

#include "robotinterface.hpp"
#include <iostream>

template <typename T1, typename T2, typename T3>
void setvector(T1 *vectorin, T2 *vectorout, T3 &N, T3 &M)
{
    if (N == 1)
    {
        for(int m = 0; m < M; m++)
        {
            double tmp = vectorin[m];
            vectorout->push_back(tmp);
        }
    }
    else
    {
        for (int n = 0; n < N; n++)
        {
            for(int m = 0; m < M; m++)
            {
                double tmp = vectorin[m + M * n];
                vectorout->push_back(tmp);
            }
        }
    }
};

template <>
void setvector(double *vectorin, std::vector<double> *vectorout, int &N, int &M)
{
    if (N == 1)
    {
        for(int m = 0; m < M; m++)
        {
            double tmp = vectorin[m];
            vectorout->push_back(tmp);
        }
    }
    else
    {
        for (int n = 0; n < N; n++)
        {
            for(int m = 0; m < M; m++)
            {
                double tmp = vectorin[m + M * n];
                vectorout->push_back(tmp);
            }
        }
    }
};

template <>
void setvector(double *vectorin, std::vector<double> *vectorout, long &N, long &M)
{
    if (N == 1)
    {
        for(int m = 0; m < M; m++)
        {
            double tmp = vectorin[m];
            vectorout->push_back(tmp);
        }
    }
    else
    {
        for (int n = 0; n < N; n++)
        {
            for(int m = 0; m < M; m++)
            {
                double tmp = vectorin[m + M * n];
                vectorout->push_back(tmp);
            }
        }
    }
};

template <typename T1, typename T2, typename T3>
void setvector2x2(T1 *vectorin, T2 *vectorout1, T2 *vectorout2, T3 &N, T3 &M)
{
    for (int n = 0; n < N; n++)
    {
        for(int m = 0; m < M; m++)
        {
            ((m + M * n) % 2 == 0) ? (vectorout1->push_back(vectorin[m + M * n])) :
            (vectorout2->push_back(vectorin[m + M * n]));
        }
    }
};

template<>
void setvector2x2(double *vectorin,
                  std::vector<double> *vectorout1,
                  std::vector<double> *vectorout2,
                  int &N, int &M)
{
    for (int n = 0; n < N; n++)
    {
        for(int m = 0; m < M; m++)
        {
            ((m + M * n) % 2 == 0) ? (vectorout1->push_back(vectorin[m + M * n])) :
            (vectorout2->push_back(vectorin[m + M * n]));
        }
    }
};

template<>
void setvector2x2(double *vectorin,
                  std::vector<double> *vectorout1,
                  std::vector<double> *vectorout2,
                  long &N, long &M)
{
    for (int n = 0; n < N; n++)
    {
        for(int m = 0; m < M; m++)
        {
            ((m + M * n) % 2 == 0) ? (vectorout1->push_back(vectorin[m + M * n])) :
            (vectorout2->push_back(vectorin[m + M * n]));
        }
    }
};
