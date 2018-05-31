#ifndef GEOMENTITY_H
#define GEOMENTITY_H
#include <list>
#include <vector>

typedef std::pair<int, int> point;

class Rectangle
{
public:
  Rectangle() {}
  Rectangle(int x, int y, int width, int height);
  int left();
  int right();
  int top();
  int bottom();
private:
  int _x;
  int _y;
  int _width;
  int _height;
};


#endif // GEOMENTITY_H
