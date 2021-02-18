#ifndef __GZ_COMMON_H_
#define __GZ_COMMON_H_

#include <vector>
using namespace std;

//============================================================================
//Declarations in Assignment #1
//============================================================================

//Common data type------------------------------------------------------------
// wrapper around int
typedef int GzInt;
// wrapper around bool
typedef bool GzBool;
// wrapper around double
typedef double GzReal;
// flag representing capabilities
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
// vector position X
#define X 0
// vector position Y
#define Y 1
// vector position Z
#define Z 2

struct GzVertex : public vector<GzReal>
{
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
// vector position R
#define R 0
// vector position G
#define G 1
// vector position B
#define B 2
// vector position A
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

#endif
