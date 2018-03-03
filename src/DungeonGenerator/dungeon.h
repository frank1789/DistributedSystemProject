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
#define MINCORRIDORLENGTH 1
#define MAXCORRIDORLENGTH 12


struct Rect
{
  int x, y;
  int width, height;
};

class Dungeon
{
  // define attributes
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
  };
public: // define public method
  Dungeon(int width, int height);
  void generate(int maxFeatures);
  void print();
  void setPointRoom();
  std::vector<geometry::i_point> getDoor();
  std::vector<geometry::i_point> getRoom();
  std::vector<geometry::i_point> getCorridor();
  std::vector<geometry::i_point> getHorizzontalCorridor();
  std::vector<geometry::i_point> getVerticalCorridor();
  std::vector<geometry::i_point> getWall();
  void setPointCorridor(int &x, int &y, int &height, int &width);
private: // define private method
  char getTile(int x, int y) const;
  bool createFeature();
  bool createFeature(int x, int y, Direction dir);
  bool makeRoom(int x, int y, Direction dir, bool firstRoom = false);
  bool makeCorridor(int x, int y, Direction dir);
  bool placeRect(const Rect& rect, char tile);
  bool placeObject(char tile);
  void setTile(int x, int y, char tile);
  void setPointDoor(int x, int y);
  void setPointHorizzontalCorridor(int &x, int &y, int &height, int &width);
  void setPointVerticalCorridor(int &x, int &y, int &height, int &width);
  // define attributes
private:
  int _width, _height;
  std::vector<char> _tiles;
  std::vector<Rect> _rooms; // rooms for place stairs or monsters
  std::vector<Rect> _exits; // 4 sides of rooms or corridors
  int const DirectionCount = 5;
  int _doorcounter;
  std::vector<geometry::i_point> _doorpoint;
  std::vector<geometry::i_point> _roompoint;
  std::vector<geometry::i_point> _corrvertpoint;
  std::vector<geometry::i_point> _corrhorzpoint;
  std::vector<geometry::i_point> _wallpoint;
  void setPointWall(int x, int y);

};

#endif // DUNGEON_H
