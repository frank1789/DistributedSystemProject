#ifndef SORTUTILITY_H
#define SORTUTILITY_H
#include <algorithm>




template<typename T>
T sortAbscissa(T &v)
{
  std::sort(v.begin(), v.end(), [](const T &lhs, const T &rhs) {
      return lhs.first < rhs.first;
    });
  return v;
}


template<typename T>
T sortOrdinates(const T &v)
{
  std::sort(v.begin(), v.end(), [](const T &lhs, const T &rhs) {
      return lhs.second < rhs.second;
    });
  return v;
}


#endif // SORTUTILITY_H
