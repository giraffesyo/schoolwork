
#ifndef __GZ_TRIANGLE_H_
#define __GZ_TRIANGLE_H_

#include "GzCommon.h"
#include "GzVector.h"
using namespace std;

// Triangle data structure
class GzTriangle : public vector<GzVertex>
{
public:
    GzTriangle(const vector<GzVertex> points, const vector<GzColor> colors, const vector<GzVector> normals);
    void CalculateBounds(const GzReal clampW, const GzReal clampH);
    GzVertex barycentric(const GzVertex p);
    bool containsPoint(const GzVertex p);
    GzVertex topVertex;

    int rowMin;
    int rowMax;
    int colMin;
    int colMax;
    GzVertex MaxBounds = GzVertex(-numeric_limits<double>::max(), -numeric_limits<double>::max(), -numeric_limits<double>::max());
    GzVertex MinBounds = GzVertex(numeric_limits<double>::max(), numeric_limits<double>::max(), numeric_limits<double>::max());
    GzVertex p;
    GzVertex q;
    GzVertex s;
    vector<GzColor> colors;
    vector<GzVector> normals;

private:
};
//----------------------------------------------------------------------------

#endif