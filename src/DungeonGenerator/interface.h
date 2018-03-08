#include "dungeon.h"
#ifndef INTERFACE_H
#define INTERFACE_H

void connectpoint(const std::vector<geometry::i_point> &dungeonpoint, std::vector<int>* vec);

void copyarray(const std::vector<geometry::i_point> &v_in, std::vector<int>* v_out);

#endif // INTERFACE_H
