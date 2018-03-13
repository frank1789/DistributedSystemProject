#include "dungeon.h"
#include <iterator>
#ifndef MYCLASS_H
#define MYCLASS_H
#include <list>


namespace map {

  typedef std::pair<double, double> point;

  class MyClass
  {
  public:
    MyClass(const std::vector<dungeon::point> &v);
    void make();
    void makevertical();
    void setPointsMatlab();

    std::vector<double> getPointsMatlab();

    ~MyClass();
  private:
    std::vector<point> _import;
    std::vector<point> _hsegment;
    std::vector<point> _vsegment;
    std::vector<point> tmp;
    std::vector<double>* _y;
    std::vector<double>* _x;
    std::vector<point> _points;
    std::vector<double>* points_;

    void findextreme_x(std::vector<point> &v, std::vector<point>::iterator &i);
    void findextreme_y(std::vector<point> &v, std::vector<point>::iterator &i);
    void setOrdinate();
    void setAbscissa();
  };
}

#endif // MYCLASS_H
