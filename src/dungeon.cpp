//
//  dungeon.cpp
//  DungeonGenerator
//
//  Created by Francesco Argentieri on 25/02/18.
//  Copyright © 2018 Francesco Argentieri. All rights reserved.
//

#include "dungeon.h"
#include "iostream"
#include "geomentity.h"


Dungeon::Dungeon(int width, int height)
  : _width(width)
  , _height(height)
  , _tiles(width * height, Unused)
  , _rooms()
  , _exits()
{
//   qDebug() << "initialize class Dungeon, set scenario dimension (w,h):" << _width << _height;
}

void Dungeon::generate(int maxFeatures)
{
//   qDebug() << "Start generation, then set room's number: #" << maxFeatures;
  // place the first room in the center
  if (!makeRoom(_width / 2, _height / 2, static_cast<Direction>(randomInt(4), true)))
    {
//       qDebug() << "Unable to place the first room.\n";
      return;
    }

  // we already placed 1 feature (the first room)
  for (int i = 1; i < maxFeatures; ++i)
    {
      if (!createFeature())
        {
//           qDebug() << "Unable to place more features (placed " << i << ").\n";
          break;
        }
    }

  //  if (!placeObject(UpStairs))
  //    {
  //      qDebug() << "Unable to place up stairs.\n";
  //      return;
  //    }

  //  if (!placeObject(DownStairs))
  //    {
  //      qDebug() << "Unable to place down stairs.\n";
  //      return;
  //    }

  for (char& tile : _tiles)
    {
      if (tile == Unused)
        tile = '.';
      else if (tile == Floor || tile == Corridor)
        tile = ' ';
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

bool Dungeon::createFeature(int x, int y, Dungeon::Direction dir)
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
          return true;
        }
    }
  else
    {
      if (makeCorridor(x, y, dir))
        {
          if (getTile(x + dx, y + dy) == Floor)
            setTile(x, y, ClosedDoor);
          else // don't place a door between corridors
            setTile(x, y, Corridor);

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
          setTile(x, y, Wall);
        else
          setTile(x, y, tile);
      }
  return true;
}

bool Dungeon::placeObject(char tile)
{
  if (_rooms.empty())
    {
      return false;
    }
  int r = randomInt(_rooms.size()); // choose a random room
  int x = randomInt(_rooms[r].x + 1, _rooms[r].x + _rooms[r].width - 2);
  int y = randomInt(_rooms[r].y + 1, _rooms[r].y + _rooms[r].height - 2);
  if (getTile(x, y) == Floor)
    {
      setTile(x, y, tile);
      // place one object in one room (optional)
      _rooms.erase(_rooms.begin() + r);
      return true;
    }
  return false;
}



void Dungeon::bo()
{
  //  std::vector<geometry::rectangle<4>> j;
  std::vector<geometry::point> rectangle;
  geometry::point p[4];
//   qDebug()<<"room generated:"<< _rooms.size();
  for (unsigned long i= 0; i < _rooms.size(); ++i)
    {
//      p = new geometry::point[4];
//      qDebug() << _rooms[i].x << _rooms[i].y << _rooms[i].width << _rooms[i].height;
//      qDebug() << _rooms[i].x << _rooms[i].y << _rooms[i].x + _rooms[i].width << _rooms[i].y + _rooms[i].height;
//      qDebug() << "coordinate p1" << _rooms[i].x << _rooms[i].y;
//      qDebug() << "coordinate p2" << _rooms[i].x + _rooms[i].width << _rooms[i].y;
//      qDebug() << "coordinate p3" << _rooms[i].x << _rooms[i].y+ _rooms[i].height;
//      qDebug() << "coordinate p4" << _rooms[i].x + _rooms[i].width << _rooms[i].y + _rooms[i].height;

      p[0] = {_rooms[i].x, _rooms[i].y};
      p[1] = {_rooms[i].x + _rooms[i].width , _rooms[i].y};
      p[2] = {_rooms[i].x ,_rooms[i].y+ _rooms[i].height};
      p[3] = {_rooms[i].x + _rooms[i].width , _rooms[i].y + _rooms[i].height};
      for(int s =0; s< 4; s++)
        {
//          rectangle.append(p);
//           qDebug()<< "extract corrdinate:" << p[s];
        }


      //      j.push_back({_rooms[i].x << _rooms[i].y, _rooms[i].x + _rooms[i].width << _rooms[i].y, _rooms[i].x << _rooms[i].y+ _rooms[i].height, _rooms[i].x + _rooms[i].width << _rooms[i].y + _rooms[i].height})
      //      p = new point[4];
      //      coordinatepoint.push_back();

//      delete [] p;
    }
}
//  qDebug()<<rectangle.size();
//  for(int b = 0; b < rectangle.size(); ++b)
////   qDebug()<<rectangle[b]->second;

////  geometry::point a;
////  a.x =1;
////  a.y =2;
////  qDebug()<<a.x<<a.y;


//}

//geometry::point Dungeon::getPoint()
//{

//}
