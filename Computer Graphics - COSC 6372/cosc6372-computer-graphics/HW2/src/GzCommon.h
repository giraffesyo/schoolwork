#ifndef __GZ_COMMON_H_
#define __GZ_COMMON_H_

#include <vector>
using namespace std;

//Common data type------------------------------------------------------------
typedef int GzInt;
typedef bool GzBool;
typedef double GzReal;
typedef unsigned int GzFunctional;
typedef unsigned int GzPrimitiveType;
//----------------------------------------------------------------------------

//Funtional constants---------------------------------------------------------
#define GZ_DEPTH_TEST 0x00000001
#define GZ_COLOR_BUFFER 0x00000002
#define GZ_DEPTH_BUFFER 0x00000004
//----------------------------------------------------------------------------

//Primitive types-------------------------------------------------------------
#define GZ_POINTS 0
#define GZ_TRIANGLES 1
//----------------------------------------------------------------------------

//3D coordinate data type-----------------------------------------------------
#define X 0
#define Y 1
#define Z 2

//Color data type-------------------------------------------------------------
#define R 0
#define G 1
#define B 2
#define A 3

#include <iostream>
using namespace std;

struct GzColor : public vector<GzReal>
{
	GzColor() : vector<GzReal>(4, 0) { at(A) = 1; }
	GzColor(GzReal r, GzReal g, GzReal b) : vector<GzReal>(4, 0)
	{
		at(R) = r;
		at(G) = g;
		at(B) = b;
		at(A) = 1;
	}
	GzColor(GzReal r, GzReal g, GzReal b, GzReal a) : vector<GzReal>(4, 0)
	{
		at(R) = r;
		at(G) = g;
		at(B) = b;
		at(A) = a;
	}
};
//----------------------------------------------------------------------------

struct GzVertex : public vector<GzReal>
{
	GzColor color;
	GzVertex operator-(const GzVertex &v) const
	{
		GzVertex vertex;
		vertex[X] = at(X) - v[X];
		vertex[Y] = at(Y) - v[Y];
		vertex[Z] = at(Z) - v[Z];
		return vertex;
	}

	GzVertex operator+(const GzVertex &v) const
	{
		GzVertex vertex;
		vertex.at(X) = at(X) + v[X];
		vertex.at(Y) = at(Y) + v[Y];
		vertex.at(Z) = at(Z) + v[Z];
		return vertex;
	}

	// reference algorithm for cross product @ https://www.tutorialspoint.com/cplusplus-program-to-compute-cross-product-of-two-vectors
	GzVertex cross(const GzVertex &P, const GzVertex &Q)
	{
		GzVertex CrossProduct;
		CrossProduct[X] = P[Y] * Q[Z] - P[Z] * Q[Y];
		CrossProduct[Y] = -(P[X] * Q[Z] - P[Z] * Q[X]);
		CrossProduct[Z] = P[X] * Q[Y] - P[Y] * Q[X];
		return CrossProduct;
	}

	// Multiplies each component and then sums all of the results
	// https://en.wikipedia.org/wiki/Dot_product
	GzReal dot(const GzVertex &Q)
	{
		return at(X) * Q[X] + at(Y) * Q[Y] + at(Z) * Q[Z];
	}

	GzVertex() : vector<GzReal>(3, 0) {}
	GzVertex(GzReal x, GzReal y, GzReal z) : vector<GzReal>(3, 0)
	{
		at(X) = x;
		at(Y) = y;
		at(Z) = z;
	}
};
//----------------------------------------------------------------------------

#endif
