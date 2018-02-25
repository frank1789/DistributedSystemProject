//
//  main.cpp
//  DungeonGenerator
//
//  Created by Francesco Argentieri on 25/02/18.
//  Copyright © 2018 Francesco Argentieri. All rights reserved.
//

#include <iostream>
#include "dungeon.hpp"

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    std::cout<< randomInt(5)<<std::endl;
    std::cout<< randomInt(1, 6)<<std::endl;
    std::cout<< randomBool()<<std::endl;
    Dungeon d(5,6,1);
    d.print();
    d.makeroom(3, 2);
    return 0;
}
