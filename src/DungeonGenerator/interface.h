#include "leaf.h"
#ifndef INTERFACE_H
#define INTERFACE_H

void setvoidmap(int** m, int width, int height);

void setroom(std::deque<Leaf> &dq, int width, int height, int** m);

void setcorridor(std::deque<Rectangle> &dq, int width, int height, int** m);

#endif // INTERFACE_H
