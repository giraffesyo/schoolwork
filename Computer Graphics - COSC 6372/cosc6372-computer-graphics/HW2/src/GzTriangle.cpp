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
    GzVertex BarycentricCoords;
    const GzVertex a = at(X);
    const GzVertex b = at(Y);
    const GzVertex c = at(Z);
    GzVertex v0 = b - a;
    GzVertex v1 = c - a;
    GzVertex v2 = p - a;

    GzReal d00 = v0.dot(v0);
    GzReal d01 = v0.dot(v1);
    GzReal d11 = v1.dot(v1);
    GzReal d20 = v2.dot(v0);
    GzReal d21 = v2.dot(v1);
    GzReal denominator = d00 * d11 - d01 * d01;
    BarycentricCoords.at(Y) = (d11 * d20 - d01 * d21) / denominator;
    BarycentricCoords.at(Z) = (d00 * d21 - d01 * d20) / denominator;
    BarycentricCoords.at(X) = 1.0f - BarycentricCoords.at(Y) - BarycentricCoords.at(Z);
    return BarycentricCoords;
}

bool GzTriangle::containsPoint(const GzVertex p)
{
    GzVertex barycentric = this->barycentric(p);
    return barycentric.at(X) >= 0 && barycentric.at(Y) >= 0 && barycentric.at(Z) >= 0;
}