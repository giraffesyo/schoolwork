#include "GzTriangle.h"

GzTriangle::GzTriangle(const GzVertex p, const GzVertex q, const GzVertex s) : vector<GzVertex>(3)
{
    at(X) = p;
    at(Y) = q;
    at(Z) = s;
    // Sort by highest y (lowest value but closest to top)
    sort(begin(), end(), [](const GzVertex &a, const GzVertex &b) -> bool { return a.at(Y) < b.at(Y); });
    // the first vertex is now the one with highest Y
    topVertex = at(0);
    rowMin = at(0)[Y];
    rowMax = at(2)[Y];
    sort(begin(), end(), [](const GzVertex &a, const GzVertex &b) -> bool { return a.at(X) < b.at(X); });
    colMin = at(0)[X];
    colMax = at(2)[X];
    if (rowMax > 500)
    {
        cout << "this one";
    }
}

GzVertex GzTriangle::barycentric(const GzVertex p)
{
    const GzVertex a = at(X);
    const GzVertex b = at(Y);
    const GzVertex c = at(Z);
    // GzVertex v0 = b - a;
    // GzVertex v1 = c - a;
    // GzVertex v2 = p - a;

    GzVertex u = GzVertex(c[X] - a[X], b[X] - a[X], a[X] - p[X]).cross(GzVertex(c[Y] - a[Y], b[Y] - a[Y], a[Y] - p[Y]));
    GzVertex BarycentricCoords(1.f - (u[X] + u[Y]) / u[Z], u[Y] / u[Z], u[X] / u[Z]);
    return BarycentricCoords;
}

bool GzTriangle::containsPoint(const GzVertex p)
{
    GzVertex barycentric = this->barycentric(p);
    return barycentric.at(X) >= 0 && barycentric.at(Y) >= 0 && barycentric.at(Z) >= 0;
}