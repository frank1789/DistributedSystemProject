//
//  dungeon.hpp
//  DungeonGenerator
//
//  Created by Francesco Argentieri on 25/02/18.
//  Copyright © 2018 Francesco Argentieri. All rights reserved.
//

#ifndef dungeon_hpp
#define dungeon_hpp

#include <stdio.h>

#define MINROOMSIZE 3
#define MAXROOMSIZE 8


int randomInt(int esclusivemax);
int randomInt(int min, int max);
bool randomBool();




class Dungeon {
    int _width;
    int _height;
    int _numroom;
    enum direction
    {
        NORTH,
        SOUTH,
        WEST,
        EAST
    } _direction;
    struct rectangle
    {
        int x;
        int y;
        int width;
        int height;
    } _baseroom;
    int _directioncount;

    
public:
    Dungeon() {};
    Dungeon(int width, int height, int numroom);
    void print();
    void makeroom(int x, int y);
};

#endif /* dungeon_hpp */
