#include "GzTriangle.h"

GzTriangle::GzTriangle(const GzVertex p, const GzVertex q, const GzVertex s)
{
    vertices = {p, q, s};
}

GzVertex GzTriangle::barycentric(const GzVertex p)
{
    GzVertex BarycentricCoords;
    const GzVertex a = vertices.at(X);
    const GzVertex b = vertices.at(Y);
    const GzVertex c = vertices.at(Z);
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