//
//  robotinterface.cpp
//  Potential Field
//
//  Created by Francesco Argentieri on 22/12/17.
//  Copyright © 2017 Francesco Argentieri. All rights reserved.
//

#include "robotinterface.hpp"
#include <iostream>

/**
 * @brief Setvector
 * @details has in input the pointer to the date array matlab (N x M) format and copies the values in a output vector (1xM).
 * The actual dimensions and data of the array vectorin are obtained by M and N.
 * Array elements are stored in column-major format, for example, A [m + M * n] (where 0 ≤ m ≤ M - 1 and 0 ≤ n ≤ N - 1)
 * corresponding to matrix element A (m + 1, n +1).
 * @tparam T1 type *
 * @tparam T2 type *
 * @tparam T3 type &
 * @param[in] vectorin  date array in matlab format
 * @param[in,out] vectorout1  output vector
 * @param[in] N   dimension row date array in matlab format
 * @param[in] M   dimension colunm date array in matlab format
 */
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

/**
 * @brief Setvector specialization
 * @see Setvector
 * @tparam T1 type specialization double*
 * @tparam T2 type specialization double*
 * @tparam T3 type specialization int&
 * @param[in] vectorin  date array in matlab format
 * @param[in,out] vectorout1  output vector
 * @param[in] N   dimension row date array in matlab format
 * @param[in] M   dimension colunm date array in matlab format
 */
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

/**
 * @brief Setvector specialization
 * @see Setvector
 * @tparam T1 type specialization double*
 * @tparam T2 type specialization double*
 * @tparam T3 type specialization long&
 * @param[in] vectorin  date array in matlab format
 * @param[in,out] vectorout1  output vector
 * @param[in] N   dimension row date array in matlab format
 * @param[in] M   dimension colunm date array in matlab format
 */
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

/**
 * @brief Setvector2x2
 * @details has in input the pointer to the date array matlab format and copies 2xM the values in two outputs vector (1xM).
 * The actual dimensions and data of the array vectorin are obtained by M and N.
 * Array elements are stored in column-major format, for example, A [m + M * n] (where 0 ≤ m ≤ M - 1 and 0 ≤ n ≤ N - 1)
 * corresponding to matrix element A (m + 1, n +1).
 * @tparam T1 type *
 * @tparam T2 type *
 * @tparam T3 type &
 * @param[in] vectorin  date array in matlab format
 * @param[in,out] vectorout1  output vector
 * @param[in,out] vectorout2   second output vector
 * @param[in] N   dimension row date array in matlab format
 * @param[in] M   dimension colunm date array in matlab format
 */
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

/**
 * @brief Setvector2x2 specialization
 * @see Setvector2x2
 * @tparam T1 type specialization double*
 * @tparam T2 type specialization double*
 * @tparam T3 type specialization int&
 * @param[in] vectorin  date array in matlab format
 * @param[in,out] vectorout1  output vector
 * @param[in,out] vectorout2   second output vector
 * @param[in] N   dimension row date array in matlab format
 * @param[in] M   dimension colunm date array in matlab format
 */
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

/**
 * @brief Setvector2x2 specialization
 * @see Setvector2x2
 * @tparam T1 type specialization double*
 * @tparam T2 type specialization double*
 * @tparam T3 type specialization long&
 * @param[in] vectorin  date array in matlab format
 * @param[in,out] vectorout1  output vector
 * @param[in,out] vectorout2   second output vector
 * @param[in] N   dimension row date array in matlab format
 * @param[in] M   dimension colunm date array in matlab format
 */
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
