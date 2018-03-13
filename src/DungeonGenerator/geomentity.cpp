#include "geomentity.h"



Rectangle::Rectangle(int x, int y, int width, int height) : _x(x), _y(y), _width(width), _height(height)
{
    
}

int Rectangle::left() {
        return _x - (_width/2);
}

int Rectangle::right() {
        return _x + (_width / 2);
}

int Rectangle::top() {
        return _y - (_height / 2);
}

int Rectangle::bottom() {
        return _y + (_height / 2);

}
