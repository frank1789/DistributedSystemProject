//
//  dungeon.cpp
//  DungeonGenerator
//
//  Created by Francesco Argentieri on 25/02/18.
//  Copyright © 2018 Francesco Argentieri. All rights reserved.
//

#include "dungeon.hpp"
#include "random"
#include "iostream"

std::random_device rd;
std::mt19937_64 mt(rd());

int randomInt(int esclusivemax)
{
    std::uniform_int_distribution<> dist(0, esclusivemax - 1);
    return dist(mt);
}

int randomInt(int min, int max)
{
    std::uniform_int_distribution<> dist(0, max - min);
    return dist(mt) + min;
}

bool randomBool()
{
    double probability = 0.5;
    std::bernoulli_distribution dist(probability);
    return dist(mt);
}


Dungeon::Dungeon(int width, int height, int numroom)
{
    _width = width;
    _height = height;
}

void Dungeon::print()
{
    for(int i = 0; i < _width; i++)
    {
        for(int j = 0; j < _height; j++)
        {
            std::cout<<j+1;
        }
        std::cout<<std::endl;
    }
    std::cout<<"\n";
}


void Dungeon::makeroom(int x, int y)
{
    /// generate random dimension for room
    int dim_width = randomInt(MINROOMSIZE, MAXROOMSIZE);
    int dim_height = randomInt(MINROOMSIZE, MAXROOMSIZE);
    switch (_direction) {
        case NORTH:
            _baseroom.x = x - dim_width / 2;
            _baseroom.y = y - dim_height;
            break;
            case SOUTH:
            _baseroom.x = x - dim_width / 2;
            _baseroom.y = y + 1;
            break;
            case EAST:
            _baseroom.x = x + 1;
            _baseroom.y = y - dim_height / 2;
            break;
            case WEST:
            _baseroom.x = x - dim_width;
            _baseroom.y = y - dim_height / 2;
            break;
        default:
            break;
    }
}

