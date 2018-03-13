#include "myclass.h"
#include "dungeon.h"
#include "sortutility.h"
#include <algorithm>
#include <iterator>
#include <utility>
#include <functional>
//#include <QDebug>
#include <iostream>


using namespace map;

MyClass::MyClass(const std::vector<dungeon::point> &v)
{
    _y = new std::vector<double>;
    _y->clear();
    _x = new std::vector<double>;
    _x->clear();
    // import from dungeon
    for(auto it: v) _import.push_back(it);
    //  for(auto it: _import) //qDebug() << it;
    setOrdinate();
    setAbscissa();
}

void MyClass::setOrdinate()
{
    for(auto it = _import.begin(); it != _import.end(); ++it)
    {
        auto nx = std::next(it,1);
        if(it->second != nx->second) _y->push_back(it->second);
    }
    std::sort(_y->begin(),_y->end(),std::less<double>());
    auto last = std::unique(_y->begin(), _y->end());
    _y->erase(last, _y->end());
}

void MyClass::setAbscissa()
{
    for(auto it = _import.begin(); it != _import.end(); ++it)
    {
        auto nx = std::next(it,1);
        if(it->first != nx->first) _x->push_back(it->first);
    }
}


void MyClass::make()
{
    if(!tmp.empty()) tmp.clear();
    std::vector<point>::iterator i1;
    tmp.reserve(_import.size());
    std::copy(_import.begin(), _import.end(), back_inserter(tmp));
    for(auto y: *_y)
    {
        //partition vector with same y
        auto bound = std::partition(tmp.begin(), tmp.end(),[y](point n){return (n.second == y);});
        
        // reorder
        std::sort(tmp.begin(), bound, [](const point lhs, const point rhs){return lhs.first < rhs.first;});
        for(std::vector<point>::iterator it = tmp.begin(); it != bound; ++it ) //qDebug() << *it;
        //search adjacent element
        i1 = std::adjacent_find(tmp.begin(), bound, [](const point lhs, const point rhs){return lhs.first > rhs.first+1;});
        // serach maximum and minimum value for a segment
        findextreme_x(tmp, i1);
    }
    // clear the vector
    tmp.clear();
}

void MyClass::findextreme_x(std::vector<point> &v, std::vector<point>::iterator &i)
{
    // serach max & min
    auto max = std::max_element(v.begin(), i, [](const point &lhs, const point &rhs){return lhs.first < rhs.first;});
    auto min = std::min_element(v.begin(), i, [](const point &lhs, const point &rhs){return lhs.first < rhs.first;});
    
//    //qDebug() << *min << *max;
    //store value
    if(min->first != max->first)
    {
        _hsegment.push_back(*min);
        _hsegment.push_back(*max);
    }
}

void MyClass::findextreme_y(std::vector<point> &v, std::vector<point>::iterator &i)
{
    // serach max & min
    auto max = std::max_element(v.begin(), i, [](const point &lhs, const point &rhs){return lhs.second < rhs.second;});
    auto min = std::min_element(v.begin(), i, [](const point &lhs, const point &rhs){return lhs.second < rhs.second;});
    
//    //qDebug() << *min << *max;
    //store value
    if(*min != *max)
    {
        _vsegment.push_back(*min);
        _vsegment.push_back(*max);
    }
}





void MyClass::makevertical()
{
    
    if(!tmp.empty()) tmp.clear();
    tmp.reserve(_import.size());
    std::copy(_import.begin(), _import.end(), back_inserter(tmp));
    for(auto x: *_x){
        //partition vector with same y
        auto bound = std::partition(tmp.begin(), tmp.end(),[x](point n){return (n.first == x);});
        
        // reorder
        std::sort(tmp.begin(), bound, [](const point lhs, const point rhs){return lhs.second < rhs.second;});
//        for(std::vector<point>::iterator it = tmp.begin(); it != bound; ++it ) qDebug() << *it;
        //search adjacent element
        auto i1 = std::adjacent_find(tmp.begin(), bound, [](const point lhs, const point rhs){return lhs.second > rhs.second + 1;});
        // serach maximum and minimum value for a segment
        findextreme_y(tmp, i1);
    }
    // clear the vector
    tmp.clear();
}


void MyClass::setPointsMatlab()
{
    make();
      makevertical();
      std::sort(_hsegment.begin(), _hsegment.end(), [](const point &lhs, const point &rhs) {return lhs.first < rhs.first;});
      auto hduplicates = std::unique(_hsegment.begin(),_hsegment.end());
      _hsegment.erase(hduplicates, _hsegment.end());
    
    std::sort(_vsegment.begin(), _vsegment.end(), [](const point &lhs, const point &rhs) {return lhs.second < rhs.second;});
    auto vduplicates = std::unique(_vsegment.begin(),_vsegment.end());
    _vsegment.erase(vduplicates, _vsegment.end());
    
    
    unsigned long size = _hsegment.size() + _vsegment.size();
    _points.reserve(size);
    
    _points.insert(std::end(_points), std::begin(_vsegment), std::end(_vsegment));
    _points.insert(std::end(_points), std::begin(_hsegment), std::end(_hsegment));

    //qDebug() << "list point";
//     std::sort(_points.begin(), _points.end(), [](const point &lhs, const point &rhs) {return lhs.second < rhs.second;});
//        auto duplicates = std::unique(_points.begin(),_points.end());
//        _points.erase(duplicates, _points.end());
//    for(auto i: _points) //qDebug()<<i;
    
    // set return points
    points_ = new std::vector<double>;
    points_->clear();
    for(auto i = _points.begin(); i != _points.end(); ++i)
    {
        points_->push_back(i->first);
        points_->push_back(i->second);
    }
}

std::vector<double> MyClass::getPointsMatlab()
{
    return *points_;
}

MyClass::~MyClass()
{
    delete points_;
    delete _x;
    delete _y;
}

