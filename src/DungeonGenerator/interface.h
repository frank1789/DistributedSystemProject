#include "dungeon.h"
#ifndef INTERFACE_H
#define INTERFACE_H

int getcolunm(const std::vector<geometry::i_point> &dungeonfeature);

void copyarray(const std::vector<geometry::i_point> &dungeon, double *vectorin1, int size, double *vectorin2);

void connectpoint(int i, double *arrayconnect, int size);

void connectpoint(int i, std::vector<int> *vec);

void connectpoint(const std::vector<geometry::i_point> &dungeonpoint, std::vector<int>* vec);
void copyarray(const std::vector<geometry::i_point> &dungeon, double *vectorin1, int size);

void bo(Dungeon &dungeon);

std::vector<geometry::i_point> sortOrdinates(std::vector<geometry::i_point> &vect);

std::vector<geometry::i_point> sortAbscissa(std::vector<geometry::i_point> &vect);

std::vector<geometry::f_point> sortAbscissa(std::vector<geometry::f_point> &vect);

std::vector<geometry::f_point> sortOrdinates(std::vector<geometry::f_point> &vect);

void assembleHorizzontalLine(std::vector<geometry::i_point>* p_room, std::vector<geometry::i_point>* p_door);

void assembleVerticalLine(std::vector<geometry::i_point>* p_room,std::vector<geometry::i_point>* p_door);

//class Interface
//{
//public:
//  Interface(Dungeon &dungeon);
//  ~Interface();
//private:
//  std::vector<geometry::i_point>* p_room;
//  std::vector<geometry::i_point>* p_door;

//}




#endif // INTERFACE_H
