#include "numbermanipulate.h"
#include <random>

std::random_device rd;
std::mt19937_64 mt(rd());

int randomInt(int esclusivemax)
{
  std::uniform_int_distribution<> dist(0, esclusivemax - 1);
  return dist(mt);
}

int randomInt(int min, int max)
{
  std::uniform_int_distribution<> dist(0, max - min);
  return dist(mt) + min;
}

bool randomBool()
{
  double probability = 0.5;
  std::bernoulli_distribution dist(probability);
  return dist(mt);
}
