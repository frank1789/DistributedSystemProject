//
//  dungeon.cpp
//  DungeonGenerator
//
//  Created by Francesco Argentieri on 25/02/18.
//  Copyright © 2018 Francesco Argentieri. All rights reserved.
//

#include "dungeon.h"
#include <iostream>


using namespace dungeon;
Dungeon::Dungeon(int width, int height)
  : _width(width)
  , _height(height)
  , _tiles(width * height, Unused)
  , _rooms()
  , _exits()
{
  _doorcounter = 0;
  //qDebug() << "initialize class Dungeon, set scenario dimension (w,h):" << _width << _height;
  _wallpoint.clear();
  _roompoint.clear();
}

void Dungeon::generate(int maxFeatures)
{
  //qDebug() << "Start generation, then set room's number: #" << maxFeatures;
  // place the first room in the center
  if (!makeRoom(_width / 2, _height / 2, static_cast<Direction>(randomInt(4), true)))
    {
      //qDebug() << "Unable to place the first room.\n";
      return;
    }

  // we already placed 1 feature (the first room)
  for (int i = 1; i < maxFeatures; ++i)
    {
      if (!createFeature())
        {
          //qDebug() << "Unable to place more features (placed " << i << ").\n";
          break;
        }
    }

  //  if (!placeObject(UpStairs))
  //    {
  //      //qDebug() << "Unable to place up stairs.\n";
  //      return;
  //    }

  //  if (!placeObject(DownStairs))
  //    {
  //      //qDebug() << "Unable to place down stairs.\n";
  //      return;
  //    }

  for (char& tile : _tiles)
    {
      if (tile == Unused)
        tile = '.';
      else if (tile == Floor )//|| tile == Corridor)
        tile = '*';
    }
}

void Dungeon::print()
{
  for (int y = 0; y < _height; ++y)
    {
      for (int x = 0; x < _width; ++x)
        {
          std::cout << getTile(x, y);
        }

      std::cout << std::endl;
    }
}

char Dungeon::getTile(int x, int y) const
{
  if (x < 0 || y < 0 || x >= _width || y >= _height)
    {
      return Unused;
    }
  return _tiles[x + y * _width];
}

void Dungeon::setTile(int x, int y, char tile)
{
  _tiles[x + y * _width] = tile;
}

bool Dungeon::createFeature()
{
  for (int i = 0; i < 1000; ++i)
    {
      if (_exits.empty())
        {
          break;
        }
      // choose a random side of a random room or corridor
      int r = randomInt(_exits.size());
      int x = randomInt(_exits[r].x, _exits[r].x + _exits[r].width - 1);
      int y = randomInt(_exits[r].y, _exits[r].y + _exits[r].height - 1);
      // north, south, west, east
      for (int j = 0; j < DirectionCount; ++j)
        {
          if (createFeature(x, y, static_cast<Direction>(j)))
            {
              _exits.erase(_exits.begin() + r);
              return true;
            }
        }
    }
  return false;
}

bool Dungeon::createFeature(int x, int y, Direction dir)
{
  static const int roomChance = 50; // corridorChance = 100 - roomChance
  int dx = 0;
  int dy = 0;
  switch (dir)
    {
    case North:
      dy = 1;
      break;
    case South:
      dy = -1;
      break;
    case West:
      dx = 1;
      break;
    case East:
      dx = -1;
      break;
    }
  if (getTile(x + dx, y + dy) != Floor && getTile(x + dx, y + dy) != Corridor)
    {
      return false;
    }
  if (randomInt(100) < roomChance)
    {
      if (makeRoom(x, y, dir))
        {
          setTile(x, y, ClosedDoor);
          setPointDoor(x, y);
          return true;
        }
    }
  else
    {
      if (makeCorridor(x, y, dir))
        {
          if (getTile(x + dx, y + dy) == Floor)
            {
              setTile(x, y, ClosedDoor);
//              setPointDoor(x, y);
            }
          else // don't place a door between corridors
            {
              setTile(x, y, Corridor);
            }
          return true;
        }
    }
  return false;
}

bool Dungeon::makeRoom(int x, int y, Dungeon::Direction dir, bool firstRoom)
{
  Rect room;
  room.width = randomInt(MINROOMSIZE, MAXROOMSIZE);
  room.height = randomInt(MINROOMSIZE, MAXROOMSIZE);
  switch(dir)
    {
    case North:
      room.x = x - room.width / 2;
      room.y = y - room.height;
      break;
    case South:
      room.x = x - room.width / 2;
      room.y = y + 1;
      break;
    case West:
      room.x = x - room.width;
      room.y = y - room.height / 2;
      break;
    case East:
      room.x = x + 1;
      room.y = y - room.height / 2;
      break;
    }
  // place the rectangle
  if (placeRect(room, Floor))
    {
      _rooms.emplace_back(room);
      if (dir != South || firstRoom) // north side
        {
          _exits.emplace_back(Rect{ room.x, room.y - 1, room.width, 1 });
        }
      if (dir != North || firstRoom) // south side
        {
          _exits.emplace_back(Rect{ room.x, room.y + room.height, room.width, 1 });
        }
      if (dir != East || firstRoom) // west side
        {
          _exits.emplace_back(Rect{ room.x - 1, room.y, 1, room.height });
        }
      if (dir != West || firstRoom) // east side
        {
          _exits.emplace_back(Rect{ room.x + room.width, room.y, 1, room.height });
        }
      return true;
    }
  return false;
}

bool Dungeon::makeCorridor(int x, int y, Dungeon::Direction dir)
{
  Rect corridor;
  corridor.x = x;
  corridor.y = y;
  if (randomBool()) // horizontal corridor
    {
      corridor.width = randomInt(MINCORRIDORLENGTH, MAXCORRIDORLENGTH);
      corridor.height = 1;
      switch(dir)
        {
        case North:
          corridor.y = y - 1;
          if (randomBool()) // west
            {
              corridor.x = x - corridor.width + 1;
            }
          break;
        case South:
          corridor.y = y + 1;
          if (randomBool()) // west
            {
              corridor.x = x - corridor.width + 1;
            }
          break;
        case West:
          corridor.x = x - corridor.width;
          break;
        case East:
          corridor.x = x + 1;
          break;
        }
      //save point of horizzontal corridor
//      setPointHorizzontalCorridor(corridor.x, corridor.y, corridor.height, corridor.width);
    }
  else // vertical corridor
    {
      corridor.width = 1;
      corridor.height = randomInt(MINCORRIDORLENGTH, MAXCORRIDORLENGTH);
      switch(dir)
        {
        case North:
          corridor.y = y - corridor.height;
          break;
        case South:
          corridor.y = y + 1;
          break;
        case West:
          corridor.x = x - 1;
          if (randomBool()) // north
            {
              corridor.y = y - corridor.height + 1;
            }
          break;
        case East:
          corridor.x = x + 1;
          if (randomBool()) // north
            {
              corridor.y = y - corridor.height + 1;
            }
          break;
        }
    }
  if (placeRect(corridor, Corridor))
    {
      if (dir != South && corridor.width != 1) // north side
        {
          _exits.emplace_back(Rect{ corridor.x, corridor.y - 1, corridor.width, 1 });
        }
      if (dir != North && corridor.width != 1) // south side
        {
          _exits.emplace_back(Rect{ corridor.x, corridor.y + corridor.height, corridor.width, 1 });
        }
      if (dir != East && corridor.height != 1) // west side
        {
          _exits.emplace_back(Rect{ corridor.x - 1, corridor.y, 1, corridor.height });
        }
      if (dir != West && corridor.height != 1) // east side
        {
          _exits.emplace_back(Rect{ corridor.x + corridor.width, corridor.y, 1, corridor.height });
        }
      //save point of vertical corridor
      setPointCorridor(corridor.x, corridor.y, corridor.height, corridor.width);
      return true;

    }

  return false;
}

bool Dungeon::placeRect(const Rect &rect, char tile)
{
  if (rect.x < 1 || rect.y < 1 || rect.x + rect.width > _width - 1 || rect.y + rect.height > _height - 1)
    {
      return false;
    }
  for (int y = rect.y; y < rect.y + rect.height; ++y)
    for (int x = rect.x; x < rect.x + rect.width; ++x)
      {
        if (getTile(x, y) != Unused)
          return false; // the area already used
      }
  for (int y = rect.y - 1; y < rect.y + rect.height + 1; ++y)
    for (int x = rect.x - 1; x < rect.x + rect.width + 1; ++x)
      {
        if (x == rect.x - 1 || y == rect.y - 1 || x == rect.x + rect.width || y == rect.y + rect.height)
          {
            setTile(x, y, Wall);
            setPointWall(x, y);
          }
        else
          setTile(x, y, tile);
      }
  return true;
}

/**
 * @brief Dungeon::setPointRoom
 */
void Dungeon::setPointRoom()
{
  //qDebug()<<"Extract room coordinate generated:"<< _rooms.size();
  for (unsigned long i= 0; i < _rooms.size(); ++i)
    {
      {
        //qDebug() << "Coordinate for room: #" << i;
        //qDebug() << "\tcoordinate p1" << _rooms[i].x << _rooms[i].y;
        //qDebug() << "\tcoordinate p2" << _rooms[i].x + _rooms[i].width << _rooms[i].y;
        //qDebug() << "\tcoordinate p3" << _rooms[i].x << _rooms[i].y+ _rooms[i].height;
        //qDebug() << "\tcoordinate p4" << _rooms[i].x + _rooms[i].width << _rooms[i].y + _rooms[i].height;
      }
      _roompoint.push_back({_rooms[i].x, _rooms[i].y});                                        ///store point 1
      _roompoint.push_back({_rooms[i].x + _rooms[i].width , _rooms[i].y});                     ///store point 2
      _roompoint.push_back({_rooms[i].x ,_rooms[i].y+ _rooms[i].height});                      ///store point 3
      _roompoint.push_back({_rooms[i].x + _rooms[i].width , _rooms[i].y + _rooms[i].height});  ///store point 4
    }
}


/**
 * @brief Dungeon::setPointVerticalCorridor
 * @param x
 * @param y
 * @param height
 * @param width
 */
void Dungeon::setPointCorridor(int &x, int &y, int &height, int &width)
{
  {
    //qDebug() << "Extract corridor:";
    //qDebug() << "\tcoordinate c1" << x << y;
    //qDebug() << "\tcoordinate c2" << x + width << y;
    //qDebug() << "\tcoordinate c3" << x << y + height;
    //qDebug() << "\tcoordinate c4" << x + width << y + height;
  }
  _corridorpoint.push_back({x, y});                    ///store point 1
  _corridorpoint.push_back({x + width , y});           ///store point 2
  _corridorpoint.push_back({x , y + height});           ///store point 3
  _corridorpoint.push_back({x + width , y + height});  ///store point 4
}

/**
 * @brief Dungeon::setPointHorizzontalCorridor
 * @param x
 * @param y
 * @param height
 * @param width
 */
void Dungeon::setPointHorizzontalCorridor(int &x, int &y, int &height, int &width)
{
  {
    //qDebug() << "Extract coordinate for horizzontal corridor:";
    //qDebug() << "\tcoordinate c1" << x << y;
    //qDebug() << "\tcoordinate c2" << x + width << y;
    //qDebug() << "\tcoordinate c3" << x << y + height;
    //qDebug() << "\tcoordinate c4" << x + width << y + height;
  }
  _corrhorzpoint.push_back({x, y});                    ///store point 1
  _corrhorzpoint.push_back({x + width , y});           ///store point 2
  _corrhorzpoint.push_back({x , y+ height});           ///store point 3
  _corrhorzpoint.push_back({x + width , y + height});  ///store point 4
}

/**
 * @brief Dungeon::setPointDoor
 * @param x
 * @param y
 */
void Dungeon::setPointDoor(int x, int y)
{
  //qDebug() << "Exctract Door coordinate";
  _doorpoint.push_back({x, y});
  //qDebug() << "Door: #" << _doorcounter << "\n\t coordinate"<< x << y;
  _doorcounter++;
}

void Dungeon::setPointWall(int x, int y)
{
//  //qDebug() << "Exctract Door coordinate";
  _wallpoint.push_back({x, y});
//  //qDebug() << "coordinate"<< x << y;
//  _doorcounter++;
}

/**
 * @brief Dungeon::getDoor
 * @return
 */
std::vector<point> Dungeon::getDoor() { return _doorpoint;}

/**
 * @brief Dungeon::getRoom
 * @return
 */
std::vector<point> Dungeon::getRoom(){ return _roompoint;}

/**
 * @brief Dungeon::getCorridor
 * @return
 */
std::vector<point> Dungeon::getCorridor() { return _corridorpoint;}

/**
 * @brief Dungeon::getHorizzontalCorridor
 * @return
 */
std::vector<point> Dungeon::getHorizzontalCorridor() { return _corrhorzpoint;}

std::vector<point> Dungeon::getWall() { return _wallpoint;}
