#ifndef __GZ_TRIANGLE_H_
#define __GZ_TRIANGLE_H_

#include "GzCommon.h"
using namespace std;

// Triangle data structure
class GzTriangle : public vector<GzVertex>
{
public:
    GzTriangle(const GzVertex p, const GzVertex q, const GzVertex s);
    GzVertex barycentric(const GzVertex p);
    bool containsPoint(const GzVertex p);
    GzVertex topVertex;
    int rowMin;
    int rowMax;
    int colMin;
    int colMax;

private:
};
//----------------------------------------------------------------------------

#endif
