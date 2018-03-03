#include "interface.h"
#include "dungeon.h"
#include <vector>
#include <math.h>
#include <algorithm>
#include <utility>
#include <iostream>

#define N_ROW 2

using namespace geometry;

int getcolunm(const std::vector<i_point> &dungeonfeature)
{
  // set dimension for output MATLAB array
  int n_colunm = N_ROW * static_cast<int>(dungeonfeature.size());
  return n_colunm;
}

void copyarray(const std::vector<i_point> &dungeon, double *vectorin1, int size)
{
//    std::vector<int>* point_to_point = new std::vector<int>;
//    point_to_point->reserve(size);
    
  for(int i = 0; i < size; i++)
  {
      
      int j = i /2;
        (i % 2 == 0) ? vectorin1[i] = dungeon.at(j).first : vectorin1[i] = dungeon.at(j).second;
//        connectpoint((i/4), point_to_point);
      // << vectorin[i];
    }
//    std::copy(point_to_point->begin(), point_to_point->end(), vectorin2);
//    delete point_to_point;
}

void connectpoint(int i, std::vector<int> *vec)
{
//    arrayconnect[i * 0 + 0] = (i * 1) + 1;
//    arrayconnect[i * 1 + 1] = (i * 2) + 2;
//    arrayconnect[i * 2 + 2] = (i * 2) + 2;
//    arrayconnect[i * 3 + 3] = (i * 4) + 4;
//    arrayconnect[i * 4 + 4] = (i * 4) + 4;
//    arrayconnect[i * 5 + 5] = (i * 3) + 3;
//    arrayconnect[i * 6 + 7] = (i * 3) + 3;
//    arrayconnect[i * 7 + 7] = (i * 1) + 1;

vec->push_back((i * 1) + 1);
vec->push_back((i * 2) + 2);
vec->push_back((i * 2) + 2);
vec->push_back((i * 4) + 4);
vec->push_back((i * 4) + 4);
vec->push_back((i * 3) + 3);
vec->push_back((i * 3) + 3);
vec->push_back((i * 1) + 1);
}

void connectpoint(const std::vector<i_point> &dungeonpoint, std::vector<int>* vec)
{
    std::cout <<"connect point" << dungeonpoint.size();
    //reserve size
//    vec->reserve(dungeonpoint.size());
    for(unsigned long i = 0; i < dungeonpoint.size(); i+=4 )
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
    std::cout << vec->size();
}

void setStraightHorizzontalLine(std::vector<geometry::i_point> *p_room)
{
  std::vector<geometry::line> test;
  for(unsigned long i = 0; i < p_room->size(); i+=2)
    {
      test.push_back({p_room->at(i), p_room->at(i+1)});
      //      test.push_back({p_room->at(i+2), p_room->at(i-1)});
    }

  for (auto iter = test.begin(); iter != test.end(); ++iter) {
      // << *iter << ' ';
    }
}

void bo(Dungeon &dungeon)
{
  // copy <i_point> room from class
  std::vector<i_point>* p_room = new std::vector<i_point> {dungeon.getRoom()};
  std::vector<i_point>* p_door = new std::vector<i_point> {dungeon.getDoor()};
  setStraightHorizzontalLine(p_room);
  //    std::vector<f_point> temp;
  //search door aligned with room

  assembleHorizzontalLine(p_room, p_door);
  //search

  assembleVerticalLine(p_room, p_door);
  //<<"--------------------------------";
  //free the heap
  delete p_room;
  delete p_door;
}



void assembleHorizzontalLine(std::vector<geometry::i_point> *p_room, std::vector<geometry::i_point> *p_door)
{
  std::vector<geometry::line> h_line;
  std::vector<f_point>* temp1 = new std::vector<f_point>;
  // research the room's point and door's point aligned
  for(unsigned long i = 0; i < p_room->size(); i ++)
    for(unsigned long j = 0; j < p_door->size(); j++)
      if(p_door->at(j).second >= p_room->at(i).second && p_door->at(j).second <= p_room->at(i).second &&
         p_door->at(j).first > p_room->at(i).first && p_door->at(j).first < p_room->at(i).first)
        //            if(p_door->at(j).second == p_room->at(i).second)
        {
          // << "door is alinged"<< p_door->at(j) << "with point" <<p_room->at(i);
          f_point space1 = p_door->at(j);
          f_point space2 = p_door->at(j);
          (p_door->at(j).first >= p_room->at(i).first && p_door->at(j).first <= p_room->at(i).first) ? space1.first += 0.5 : space1.first -= 0.5;
          (p_door->at(j).first > p_room->at(i).first || p_door->at(j).first < p_room->at(i).first) ? space2.first += 0.5 : space2.first -= 0.5;
          temp1->push_back(space1);
          temp1->push_back(p_room->at(i));
          temp1->push_back(space2);

          // sort vector
          sortAbscissa(*temp1);
          //remove duplicates
          auto last = std::unique(temp1->begin(), temp1->end());
          temp1->erase(last, temp1->end());
          sortAbscissa(*temp1);
        }
  //    else
  //           {
  //             unsigned long j = i -1;
  //             h_line.push_back({p_room->at(j),p_room->at(i)});
  //           }
  // check
  for (auto iter = temp1->begin(); iter != temp1->end(); ++iter) {
      // << *iter << ' ';
    }


  for(unsigned long i = 1; i < temp1->size(); i+=2 )
    h_line.push_back({temp1->at(i-1),temp1->at(i)});

  //    for(unsigned long i = 1; i < p_room->size(); i+=2 )
  //      h_line.push_back({p_room->at(i-1),p_room->at(i)});

  for (auto iter = h_line.begin(); iter != h_line.end(); ++iter) {
      // << *iter << ' ';
    }

  delete temp1;
}

std::vector<geometry::f_point> sortAbscissa(std::vector<geometry::f_point> &vect)
{
  std::sort(vect.begin(), vect.end(), [](const geometry::i_point &left, const geometry::i_point &right) {
      return left.first < right.first;
    });
  return vect;
}

std::vector<geometry::i_point> sortAbscissa(std::vector<geometry::i_point> &vect)
{
  std::sort(vect.begin(), vect.end(), [](const geometry::i_point &left, const geometry::i_point &right) {
      return left.first < right.first;
    });
  return vect;
}

std::vector<geometry::i_point> sortOrdinates(std::vector<geometry::i_point> &vect)
{
  std::sort(vect.begin(), vect.end(), [](const geometry::i_point &left, const geometry::i_point &right) {
      return left.second < right.second;
    });
  return vect;
}

std::vector<geometry::f_point> sortOrdinates(std::vector<geometry::f_point> &vect)
{
  std::sort(vect.begin(), vect.end(), [](const geometry::f_point &left, const geometry::f_point &right) {
      return left.second < right.second;
    });
  return vect;
}

void assembleVerticalLine(std::vector<geometry::i_point>* p_room,std::vector<geometry::i_point>* p_door)
{
  std::vector<f_point>* temp1 = new std::vector<f_point>;
  // research the room's point and door's point aligned
  for(unsigned long i = 0; i < p_room->size(); i ++)
    for(unsigned long j = 0; j < p_door->size(); j++)
      if(p_door->at(j).first >= p_room->at(i).first && p_door->at(j).first <= p_room->at(i).first)
        {
          // << "door is alinged"<< p_door->at(j) << "with point" <<p_room->at(i);
          f_point space1 = p_door->at(j);
          f_point space2 = p_door->at(j);
          (p_door->at(j).second >= p_room->at(i).second && p_door->at(j).second <= p_room->at(i).second) ? space1.second += 0.5 : space1.second -= 0.5;
          (p_door->at(j).second > p_room->at(i).second || p_door->at(j).second < p_room->at(i).second) ? space2.second += 0.5 : space2.second -= 0.5;
          temp1->push_back(space1);
          temp1->push_back(p_room->at(i));
          temp1->push_back(space2);
        }
  // sort vector
  sortOrdinates(*temp1);
  //remove duplicates
  auto last = std::unique(temp1->begin(), temp1->end());
  temp1->erase(last, temp1->end());
  // check
  for (auto iter = temp1->begin(); iter != temp1->end(); ++iter) {
      // << *iter << ' ';
    }
  delete temp1;
  //
}

//Interface::Interface(Dungeon &dungeon)
//{
//  p_room = new std::vector<geometry::i_point> {dungeon.getRoom()};
//  p_door = new std::vector<geometry::i_point> {dungeon.getDoor()};
//      setStraightHorizzontalLine(p_room);
//}

//Interface::~Interface()
//{
//  delete p_room;
//  delete p_door;
//}
