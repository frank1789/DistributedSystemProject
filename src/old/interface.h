#include "dungeon.h"
#ifndef INTERFACE_H
#define INTERFACE_H

using namespace dungeon;

void connectpoint(const std::vector<point> &dungeonpoint, std::vector<int>* vec);

void copyarray(const std::vector<point> &v_in, std::vector<int>* v_out);










std::pair<int,int> operator+(const std::pair<int,int> &a ,const  std::pair<int,int> &b );

void consecutiveset(std::vector<point> v_in, std::vector<point> *v_out);

//// An Interval
//struct Interval
//{
//    int start, end;
//};

//// To compare two intervals accoridng to their start time
//bool mycomp(point p1, point p2)
//{   return interval1.x > interval2.x; }

//void mergeIntervals(Interval arr[], int n)
//{
//    // Sort Intervals in decreasing order of start time
//    sort(arr, arr+n, mycomp);

//    // Stores index of last element in the output array
//    int index = 0;


//    // Traverse all input Intervals
//    for (int i=0; i<n; i++)
//    {
//        // If this is not first Interval and overlaps
//        // with the previous one
//        if (index != 0 && arr[index-1].start <= arr[i].end)
//        {
//            while (index != 0 && arr[index-1].start <= arr[i].end)
//            {
//                // Merge previous and current Intervals
//                arr[index-1].end = max(arr[index-1].end, arr[i].end);
//                arr[index-1].start = min(arr[index-1].start, arr[i].start);
//                index--;
//            }
//        }
//        // Doesn't overlap with previous, add to the solution
//        else
//            arr[index] = arr[i];

//        index++;
//    }

//    // Now arr[0..index-1] stores the merged Intervals
//    cout << "\n After Merging the Intervals are: ";
//    for (int i = 0; i < index; i++)
//        cout << "[" << arr[i].start << ", " << arr[i].end << "] ";
//}






#endif // INTERFACE_H
