#ifndef LEAF_H
#define LEAF_H
#include "geomentity.h"
#include <deque>
#include <vector>

#define MIN_LEAF_SIZE 6
#define MAX_LEAF_SIZE 20

class Leaf
{
public:
  explicit Leaf(int x, int y, int width, int height);
  bool split();
  bool randTrue(int percentage);
  void createRoom(std::deque<Leaf> &v, std::deque<Rectangle> &hall);
  void createHall(std::deque<Rectangle> &hall, Rectangle *l, Rectangle *r);
  void generate();
  int randomInclusveBetween(int a, int b);
  Rectangle* getRoom();

  // attributes
public:
  int _x;
  int _y;
  int _width;
  int _height;
  Leaf* _leftChild;
  Leaf* _rightChild;

private:
  const short min_leaf_size = MIN_LEAF_SIZE;
  const short max_leaf_size = MAX_LEAF_SIZE;
  Rectangle* _room;
  std::vector<Rectangle*> _hall;

};

#endif // LEAF_H
