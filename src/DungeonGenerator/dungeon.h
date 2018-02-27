//
//  dungeon.h
//  DungeonGenerator
//
//  Created by Francesco Argentieri on 25/02/18.
//  Copyright © 2018 Francesco Argentieri. All rights reserved.
//

#ifndef DUNGEON_H
#define DUNGEON_H
#include "numbermanipulate.h"
#include "geomentity.h"
#include <vector>
#include <stdio.h>


#define MINROOMSIZE 3
#define MAXROOMSIZE 8
#define MINCORRIDORLENGTH 2
#define MAXCORRIDORLENGTH 12

void copyarray(std::vector<geometry::point>& dungeonpoint, double* vectorin, int size)
{
    for(int i = 0; i < size; i++)
    {
        int j = i / 2;
        (i % 2 == 0) ? vectorin[i] = dungeonpoint.at(j).first : vectorin[i] = dungeonpoint.at(j).second;
    }
}


struct Rect
{
  int x, y;
  int width, height;
};

class Dungeon
{
public:
  enum Tile
  {
    Unused    = ' ',
    Floor     = '.',
    Corridor  = ',',
    Wall      = '#',
    ClosedDoor	= '+',
    OpenDoor	= '-',
    UpStairs	= '<',
    DownStairs	= '>'
  };

  enum Direction
  {
    North,
    South,
    West,
    East,
//    DirectionCount
  };

  int const DirectionCount = 5;

public:
  Dungeon(int width, int height);
  void generate(int maxFeatures);
  void print();



  void setPointRoom();
  void setPointCorridor();
  void setPointDoor(int x, int y);
  std::vector<geometry::point> getDoor();
  std::vector<geometry::point> getRoom();
  std::vector<geometry::point> getCorridor();
  geometry::point getCorridor(int n);
  geometry::point getRoom(int n);
  geometry::point getDoor(int n);
private:
  char getTile(int x, int y) const;
  void setTile(int x, int y, char tile);
  bool createFeature();
  bool createFeature(int x, int y, Direction dir);
  bool makeRoom(int x, int y, Direction dir, bool firstRoom = false);
  bool makeCorridor(int x, int y, Direction dir);
  bool placeRect(const Rect& rect, char tile);
  bool placeObject(char tile);

private:
  int _width, _height;
  std::vector<char> _tiles;
  std::vector<Rect> _rooms; // rooms for place stairs or monsters
  std::vector<Rect> _exits; // 4 sides of rooms or corridors
  int _doorcounter;
  std::vector<geometry::point> _doorpoint;
  std::vector<geometry::point> _roompoint;
  std::vector<geometry::point> _corridorpoint;
};

#endif // DUNGEON_H
