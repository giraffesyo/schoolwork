#ifndef __GZ_COMMON_H_
#define __GZ_COMMON_H_

#include <vector>
using namespace std;

//============================================================================
//Declarations in Assignment #1
//============================================================================

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
//----------------------------------------------------------------------------

//3D coordinate data type-----------------------------------------------------
#define X 0
#define Y 1
#define Z 2

struct GzVertex : public vector<GzReal>
{
	GzVertex operator-(const GzVertex &v) const
	{
		GzVertex vertex;
		vertex.at(X) = this->at(X) - v.at(X);
		vertex.at(Y) = this->at(Y) - v.at(Y);
		vertex.at(Z) = this->at(Z) - v.at(Z);
		return vertex;
	}

	GzVertex operator+(const GzVertex &v) const
	{
		GzVertex vertex;
		vertex.at(X) = this->at(X) + v.at(X);
		vertex.at(Y) = this->at(Y) + v.at(Y);
		vertex.at(Z) = this->at(Z) + v.at(Z);
		return vertex;
	}

	// reference algorithm for cross product @ https://www.tutorialspoint.com/cplusplus-program-to-compute-cross-product-of-two-vectors
	GzVertex cross(const GzVertex &P, const GzVertex &Q)
	{
		GzVertex CrossProduct;
		CrossProduct.at(X) = P.at(Y) * Q.at(Z) - P.at(Z) * Q.at(Y);
		CrossProduct.at(Y) = -(P.at(X) * Q.at(Z) - P.at(Z) * Q.at(X));
		CrossProduct.at(Z) = P.at(X) * Q.at(Y) - P.at(Y) * Q.at(X);
		return CrossProduct;
	}

	// Multiplies each component and then sums all of the results
	// https://en.wikipedia.org/wiki/Dot_product
	GzReal dot(const GzVertex &Q)
	{
		return this->at(X) * Q.at(X) + this->at(Y) * Q.at(Y) + this->at(Z) * Q.at(Z);
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

//============================================================================
//End of Declarations in Assignment #1
//============================================================================

//============================================================================
//Declarations in Assignment #2
//============================================================================

//Primitive types-------------------------------------------------------------
#define GZ_TRIANGLES 1
//----------------------------------------------------------------------------

//============================================================================
//End of Declarations in Assignment #2
//============================================================================

#endif
