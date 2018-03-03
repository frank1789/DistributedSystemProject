#include "interface.h"
#include "dungeon.h"
#include <math.h>
#include <algorithm>
#include <utility>
//#include <QDebug>

void connectpoint(const std::vector<geometry::i_point> &dungeonpoint, std::vector<int>* vec)
{
  for(unsigned long i = 0; i < dungeonpoint.size(); i += 4)
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

void copyarray(const std::vector<geometry::i_point> &result, std::vector<int>* vector_in)
{
  for(int i = 0; i < result.size(); i++)
  {
      vector_in->push_back(result.at(i).first);
      vector_in->push_back(result.at(i).second);
    }
}

void copyarray(const std::vector<geometry::i_point> &result, int *vector_in)
{
  for(int i = 0; i < result.size(); i++)
  {
      int j = i / 2;
        (i % 2 == 0) ? vector_in[i] = result.at(j).first : vector_in[i] =  result.at(j).second;
    }
}


#define N_ROW 2

using namespace geometry;





















//void collinear(int x1, int y1, int x2, int y2,
//                              int x3, int y3)
//{
//    if ((y3 - y2)*(x2 - x1) == (y2 - y1)*(x3 - x2))
//        printf("Yes");
//    else
//        printf("No");
//}

//void iscollinear(),[]{};

//auto colinear = [](i_point p1, i_point p2, i_point p3){return true;}




int getcolunm(const std::vector<i_point> &dungeonfeature)
{
  // set dimension for output MATLAB array
  int n_colunm = N_ROW * static_cast<int>(dungeonfeature.size());
  return n_colunm;
}

//void copyarray(const std::vector<i_point> &dungeon, double *vectorin1, int size, double *vectorin2)
//{
//  for(int i = 0; i < size; i++)
//  {
//      int j = i / 2;
//        (i % 2 == 0) ? vectorin1[i] = dungeon.at(j).first : vectorin1[i] = dungeon.at(j).second;
//        connectpoint(i, vectorin2, size);
//      // << vectorin[i];
//    }
//}

//// correct way to return a rectangle in mat plot
//void connectpoint(int i, double *arrayconnect, int size)
//{
//    arrayconnect[0] =   1;
//    arrayconnect[1] =   2;
//    arrayconnect[2] =   2;
//    arrayconnect[3] =   4;
//    arrayconnect[4] =   4;
//    arrayconnect[5] =   3;
//    arrayconnect[6] =   3;
//    arrayconnect[7] =   1;
//}

void setStraightHorizzontalLine(std::vector<geometry::i_point> *p_room)
{
  std::vector<geometry::line> test;
  for(unsigned long i = 0; i < p_room->size(); i+=2)
    {
      test.push_back({p_room->at(i), p_room->at(i+1)});
      //      test.push_back({p_room->at(i+2), p_room->at(i-1)});
    }

  for (auto iter = test.begin(); iter != test.end(); ++iter) {
     //qDebug() << *iter << ' ';
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
 //qDebug()<<"--------------h line------------";
  assembleHorizzontalLine(p_room, p_door);
  //search
 //qDebug()<<"--------------------------------";
 //qDebug()<<"--------------v line------------";
  assembleVerticalLine(p_room, p_door);
 //qDebug()<<"--------------------------------";
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
         //qDebug() << "door is alinged"<< p_door->at(j) << "with point" <<p_room->at(i);
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
     //qDebug() << *iter << ' ';
    }


  for(unsigned long i = 1; i < temp1->size(); i+=2 )
    h_line.push_back({temp1->at(i-1),temp1->at(i)});

  //    for(unsigned long i = 1; i < p_room->size(); i+=2 )
  //      h_line.push_back({p_room->at(i-1),p_room->at(i)});

  for (auto iter = h_line.begin(); iter != h_line.end(); ++iter) {
     //qDebug() << *iter << ' ';
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
         //qDebug() << "door is alinged"<< p_door->at(j) << "with point" <<p_room->at(i);
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
     //qDebug() << *iter << ' ';
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










