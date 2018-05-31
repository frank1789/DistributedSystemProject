#include "leaf.h"
#include <memory>
#include <cstdlib>
#include <utility>



Leaf::Leaf(int x, int y, int width, int height) : _x(x), _y(y), _width(width), _height(height)
{
  _leftChild = nullptr;
  _rightChild = nullptr;
  _room = nullptr;
}


bool Leaf::split()
{
  // begin splitting the leaf into two children
  if (_leftChild != nullptr || _rightChild != nullptr)
    return false; // we're already split! Abort!

  // determine direction of split
  // if the width is >25% larger than height, we split vertically
  // if the height is >25% larger than the width, we split horizontally
  // otherwise we split randomly
  bool splitH = (rand() % 10 + 1) > 5;
  if (_width > _height && _width / _height >= 0.05)
    splitH = false;
  else if (_height > _width && _height / _width >= 0.05)
    splitH = true;

  int max = ((splitH) ? _height : _width) - min_leaf_size;
  if (max <= min_leaf_size)
    return false; // the area is too small to split any more...

  int split = randomInclusveBetween(min_leaf_size, max); // determine where we're going to split

  // create our left and right children based on the direction of the split
  if (splitH)
    {
      _leftChild = new Leaf(_x, _y, _width, split);
      _rightChild = new Leaf(_x, _y + split, _width, _height - split);
    }
  else
    {
      _leftChild = new Leaf(_x, _y, split, _height);
      _rightChild = new Leaf(_x + split, _y, _width - split, _height);
    }
  return true; // split successful!
}



void Leaf::generate()
{
  if (nullptr == this->_leftChild && nullptr == this->_rightChild)
    {
      if (this->_width > max_leaf_size || this->_height > max_leaf_size || randTrue(75)) {
          if (split())
            {
              this->_leftChild->generate();
              this->_rightChild->generate();
            }
          else
            return;  // no more splitting possible on this branch so return
        }
    }
}

void Leaf::createRoom(std::deque<Leaf> &v, std::deque<Rectangle> &hall)
{
  // this function generates all the rooms and hallways for this Leaf and all of its children.
  if (_leftChild != nullptr || _rightChild != nullptr)
    {
      // this leaf has been split, so go into the children leafs
      if (_leftChild != nullptr)
        this->_leftChild->createRoom(v, hall);
      if (_rightChild != nullptr)
          this->_rightChild->createRoom(v, hall);

      // if there are both left and right children in this Leaf, create a hallway between them
      if (_leftChild != nullptr && _rightChild != nullptr)
        createHall(hall, _leftChild->getRoom(), _rightChild->getRoom());
    }
  else
    {
      // this Leaf is the ready to make a room
      point* roomSize = new point;
      point* roomPosition;

      // the room can be between 3 x 3 tiles to the size of the leaf - 2.
      *roomSize = std::make_pair(randomInclusveBetween(_width - 2, 3), randomInclusveBetween(3, _height - 2));

      // place the room within the Leaf, but don't put it right
      // against the side of the Leaf (that would merge rooms together)
      roomPosition = new point({randomInclusveBetween(1, _width - roomSize->first - 1), randomInclusveBetween(1, _height - roomSize->second - 1)});
      this->_room = new Rectangle(_x + roomPosition->first, _y + roomPosition->second, roomSize->first, roomSize->second);
      v.push_back(*this);
      delete roomSize;
      delete roomPosition;
    }
}

int Leaf::randomInclusveBetween(int a, int b)
{
  return ((rand() % (b==0?1:b)) + a);
}

Rectangle* Leaf::getRoom()
{
  // iterate all the way through these leafs to find a room, if one exists.
  if (nullptr != _room)
    {
      return _room;
    }
  else
    {
      Rectangle* leftroom = nullptr;
      Rectangle* rightroom = nullptr;
      if (nullptr != _leftChild){
          leftroom = _leftChild->getRoom();
        }
      if (nullptr != _rightChild) {
          rightroom = _rightChild->getRoom();
        }
      if ((nullptr == leftroom) && (nullptr == rightroom)) {
          return nullptr;
        }
      else if (nullptr == rightroom) {
          return leftroom;
        }
      else if (nullptr == leftroom) {
          return rightroom;
        }
      else if (randomInclusveBetween(1, 10) > 5){
          return leftroom;
        }
      else {
          return rightroom;
        }
      delete leftroom;
      delete rightroom;
    }
}

bool Leaf::randTrue(int percentage)
{
  return (percentage > randomInclusveBetween(1, 100));
}



void Leaf::createHall(std::deque<Rectangle> &hall, Rectangle *l, Rectangle *r)
{
  // now we connect these two rooms together with hallways.
  // this looks pretty complicated, but it's just trying to figure out which point is where and then either draw a straight line, or a pair of lines to make a right-angle to connect them.
  // you could do some extra logic to make your halls more bendy, or do some more advanced things if you wanted.
  point* point1 = new point(randomInclusveBetween(l->left() + 1, l->right() - 2), randomInclusveBetween(l->top() + 1, l->bottom() - 2));
  point* point2 = new point(randomInclusveBetween(r->left() + 1, r->right() - 2), randomInclusveBetween(r->top() + 1, r->bottom() - 2));

  int w = point2->first - point1->first;
  int h = point2->second - point1->second;

  if (w < 0) {
      if (h < 0) {
          if (randTrue(50)) {
              hall.push_back(*new Rectangle(point2->first, point1->second, abs(w), 1));
              hall.push_back(*new Rectangle(point2->first, point2->second, 1, abs(h)));
            }
          else {
              hall.push_back(*new Rectangle(point2->first, point2->second, abs(w), 1));
              hall.push_back(*new Rectangle(point1->first, point2->second, 1, abs(h)));
            }
        }
      else if (h > 0)
        {
          if (randTrue(50)) {
              hall.push_back(*new Rectangle(point2->first, point1->second, abs(w), 1));
              hall.push_back(*new Rectangle(point2->first, point1->second, 1, abs(h)));
            }
          else {
              hall.push_back(*new Rectangle(point2->first, point2->second, abs(w), 1));
              hall.push_back(*new Rectangle(point1->first, point1->second, 1, abs(h)));
            }
        }
      else
        {
          hall.push_back(*new Rectangle(point2->first, point2->second, abs(w), 1));
        }
    }
  else if (w > 0)
    {
      if (h < 0) {
          if (randTrue(50)) {
              hall.push_back(*new Rectangle(point1->first, point2->second, abs(w), 1));
              hall.push_back(*new Rectangle(point1->first, point2->second, 1, abs(h)));
            }
          else {
              hall.push_back(*new Rectangle(point1->first, point1->second, abs(w), 1));
              hall.push_back(*new Rectangle(point2->first, point2->second, 1, abs(h)));
            }
        }
      else if (h > 0) {
          if (randTrue(50)) {
              hall.push_back(*new Rectangle(point1->first, point1->second, abs(w), 1));
              hall.push_back(*new Rectangle(point2->first, point1->second, 1, abs(h)));
            }
          else {
              hall.push_back(*new Rectangle(point1->first, point2->second, abs(w), 1));
              hall.push_back(*new Rectangle(point1->first, point1->second, 1, abs(h)));
            }
        }
      else {
          hall.push_back(*new Rectangle(point1->first, point1->second, abs(w), 1));
        }
    }
  else
    {
      if (h < 0) {
          hall.push_back(*new Rectangle(point2->first, point2->second, 1, abs(h)));
        }
      else if (h > 0) {
          hall.push_back(*new Rectangle(point1->first, point1->second, 1, abs(h)));
        }
    }
  delete point1;
  delete point2;
}
