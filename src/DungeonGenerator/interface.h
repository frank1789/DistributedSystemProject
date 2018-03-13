#include "leaf.h"
#ifndef INTERFACE_H
#define INTERFACE_H


//using namespace dungeon;

//void connectpoint(const std::vector<point> &dungeonpoint, std::vector<int>* vec);

//void copyarray(const std::vector<point> &v_in, std::vector<int>* v_out);


void setvoidmap(int** m, int width, int height);

void setroom(std::deque<Leaf> &dq, int width, int height, int** m);

void setcorridor(std::deque<Rectangle> &dq, int width, int height, int** m);

#endif // INTERFACE_H
