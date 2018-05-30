#include "interface.h"
#include <iterator>
#include <algorithm>



void setvoidmap(int** m, int width, int height)
{

  //  char map[width][height]; // same width / height as the root leaf
  for (int i = 0; i < width; i++)
    for (int j = 0; j < height; j++)
      m[i][j] = 1;

}

void setroom(std::deque<Leaf> &dq, int width, int height, int** m)
{
  int wlimit = width - 1;
  int hlimit = height - 1;
  for (std::deque<Leaf>::iterator l = dq.begin(); l != dq.end(); ++l) {

      Rectangle* room = l->getRoom();
      int left = room->left();
      int right = room->right();
      int top = room->top();
      int bottom = room->bottom();

      if (left < 1) left = 1;
      if (right < 1) right = 1;
      if (top < 1) top = 1;
      if (bottom < 1) bottom = 1;

      if (left >= wlimit) left = wlimit - 1;
      if (right >= wlimit) right = wlimit - 1;
      if (top >= hlimit) top = hlimit - 1;
      if (bottom >= hlimit) bottom = wlimit - 1;


      if (right - left > 3 && bottom - top > 3) {

          for (int i = left; i < right; i++) {
              for (int j = top; j < bottom; j++) {
                  m[i][j] = 0;
                }
            }
        }
    }
}

void setcorridor(std::deque<Rectangle> &dq, int width, int height, int** m)
{
  int wlimit = width - 1;
  int hlimit = height - 1;
  for (std::deque<Rectangle>::iterator it = dq.begin(); it != dq.end(); ++it) {

      int left = it->left();
      int right = it->right();
      int top = it->top();
      int bottom = it->bottom();

      if (left < 1) left = 1;
      if (right < 1) right = 1;
      if (top < 1) top = 1;
      if (bottom < 1) bottom = 1;

      if (left >= wlimit) left = wlimit - 1;
      if (right >= wlimit) right = wlimit - 1;
      if (top >= hlimit) top = hlimit - 1;
      if (bottom >= hlimit) bottom = wlimit - 1;
      for (int i = left; i <= right; i++)
          for (int j = top; j <= bottom; j++)
              m[i][j] = 0;
    }
}
