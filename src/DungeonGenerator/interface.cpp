#include "interface.h"
#include "dungeon.h"
#include <utility>
#include <iterator>
#include <algorithm>

void connectpoint(const std::vector<geometry::i_point> &dungeonpoint, std::vector<int>* vec)
{
    int last;
    (vec->size() != 0) ? last = *std::max_element(vec->begin(), vec->end()) : last = 0;
  for(unsigned long i = last; i < dungeonpoint.size(); i += 4)
    {
      //const struct to assemble line
      vec->push_back(i + 1);
      vec->push_back(i + 2);
      vec->push_back(i + 2);
      vec->push_back(i + 4);
      vec->push_back(i + 4);
      vec->push_back(i + 3);
      vec->push_back(i + 3);
      vec->push_back(i + 1);
    }
}


void copyarray(const std::vector<geometry::i_point> &v_in, std::vector<int>* v_out)
{
    for(auto point: v_in)
    {
        v_out->push_back(point.first);
        v_out->push_back(point.second);
    }
}
