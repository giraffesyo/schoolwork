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
}

// Caclulate bounds of triangle
void GzTriangle::CalculateBounds(const GzReal clampW, const GzReal clampH)
{
    GzVertex clamp(clampW, clampH, numeric_limits<float>::max());
    for (int i = 0; i < 3; i++)
    {
        for (int j = 0; j < 2; j++)
        {
            MinBounds[j] = max(0., min(MinBounds[j], at(i)[j]));
            MaxBounds[j] = min(clamp[j], max(MaxBounds[j], at(i)[j]));
        }
    }
}

GzVertex GzTriangle::barycentric(const GzVertex p)
{
    // get easier names for the three points of the triangle
    const GzVertex a = at(X);
    const GzVertex b = at(Y);
    const GzVertex c = at(Z);
    // calculate barycentric coordinates using cross product, z as common divisor
    GzVertex u = GzVertex(c[X] - a[X], b[X] - a[X], a[X] - p[X]).cross(GzVertex(c[Y] - a[Y], b[Y] - a[Y], a[Y] - p[Y]));
    GzVertex BarycentricCoords(1.f - (u[X] + u[Y]) / u[Z], u[Y] / u[Z], u[X] / u[Z]);
    // https://codeplea.com/triangular-interpolation, weighted average formulas for calculating colors come from barycentric coordinates
    // BarycentricCoords.color = (a.color * BarycentricCoords[0] + b.color * BarycentricCoords[1] + c.color * BarycentricCoords[2]) / (BarycentricCoords[0] + BarycentricCoords[1] + BarycentricCoords[2]);

    return BarycentricCoords;
}