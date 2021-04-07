#include "GzFrameBuffer.h"
#include "GzTriangle.h"
//Put your implementation here------------------------------------------------
#include <climits>
#include <iostream>
void GzFrameBuffer::initFrameSize(GzInt width, GzInt height)
{
	image.resize(width, height);
	depthBuffer = vector<vector<GzReal>>(width, vector<GzReal>(height, clearDepth));
}

GzImage GzFrameBuffer::toImage()
{
	return image;
}

void GzFrameBuffer::clear(GzFunctional buffer)
{
	if (buffer & GZ_COLOR_BUFFER)
		image.clear(clearColor);
	if (buffer & GZ_DEPTH_BUFFER)
		for (GzInt x = 0; x != depthBuffer.size(); x++)
			fill(depthBuffer[x].begin(), depthBuffer[x].end(), clearDepth);
}

void GzFrameBuffer::setClearColor(const GzColor &color)
{
	clearColor = color;
}

void GzFrameBuffer::setClearDepth(GzReal depth)
{
	clearDepth = depth;
}

void GzFrameBuffer::drawPoint(const GzVertex &v, const GzColor &c, GzFunctional status)
{
	GzInt x = (GzInt)v[X];
	GzInt y = image.sizeH() - (GzInt)v[Y] - 1;
	if ((x < 0) || (y < 0) || (x >= image.sizeW()) || (y >= image.sizeH()))
		return;
	if (status & GZ_DEPTH_TEST)
	{
		if (v[Z] >= depthBuffer[x][y])
		{
			image.set(x, y, c);
			depthBuffer[x][y] = v[Z];
		}
	}
	else
	{
		image.set(x, y, c);
		depthBuffer[x][y] = v[Z];
	}
}

void GzFrameBuffer::drawTriangle(GzTriangle tri, GzFunctional status)
{
	// only support two shaders at the moment
	if (status & GZ_LIGHTING)
	{
		assert(curShadeModel == GZ_GOURAUD || curShadeModel == GZ_PHONG);
	}

	// handle different shaders
	// if (curShadeModel == GZ_GOURAUD)
	// {
	// 	vector<GzColor> colors(3);
	// 	// Apply ambient color
	// 	// for (int i = 0; i < colors.size(); i++)
	// 	// {
	// 	// 	colors[i] = GzColor();

	// 	// 	for (int j = 0; j < colors[i].size(); j++)
	// 	// 	{
	// 	// 		colors[i][j] = tri.colors[i][j] * kA;
	// 	// 	}
	// 	// }

	// 	for (int i = 0; i < Lights.size(); i++)
	// 	{
	// 		GzVector n = tri.normals[i];
	// 		GzVector lightDir = transformedLights[i].direction;
	// 		lightDir.normalize();
	// 		GzVector r = (n * (n * lightDir * 2.f) - lightDir);
	// 		r.normalize();
	// 		// lightDir = -lightDir;

	// 		GzReal diffuse = kD * dotProduct(tri.normals[i], r);
	// 		GzReal specular = kS * pow(max(float(r.at(Z)), 0.f), s);
	// 		for (int j = 0; j < colors.size(); j++)
	// 		{
	// 			GzReal color = colors[i][j];
	// 			colors[i][j] = clamp(kA + color * (diffuse + specular), 0.0, 1.0);
	// 		}
	// 		cout << colors[0][0];
	// 	}

	// 	drawTriangle(tri, colors, status);
	// }
	// else if (curShadeModel == GZ_PHONG)
	// {
	// }
	GzInt yMin, yMax;
	GzReal xMin, xMax, zMin, zMax;
	GzColor cMin, cMax;
	GzVector nMin, nMax;

	tri.push_back(tri[0]);
	tri.colors.push_back(tri.colors[0]);
	tri.normals.push_back(tri.normals[0]);

	yMin = INT_MAX;
	yMax = -INT_MAX;

	for (GzInt i = 0; i < 3; i++)
	{
		yMin = min((GzInt)floor(tri[i][Y]), yMin);
		yMax = max((GzInt)floor(tri[i][Y] - 1e-3), yMax);
	}

	for (GzInt y = yMin; y <= yMax; y++)
	{
		xMin = INT_MAX;
		xMax = -INT_MAX;

		for (GzInt i = 0; i < 3; i++)
		{
			if ((GzInt)floor(tri[i][Y]) == y)
			{
				if (tri[i][X] < xMin)
				{
					xMin = tri[i][X];
					zMin = tri[i][Z];
					cMin = tri.colors[i];
					nMin = tri.normals[i];
				}
				if (tri[i][X] > xMax)
				{
					xMax = tri[i][X];
					zMax = tri[i][Z];
					cMax = tri.colors[i];
					nMax = tri.normals[i];
				}
			}
			if ((y - tri[i][Y]) * (y - tri[i + 1][Y]) < 0)
			{
				GzReal x;
				realInterpolate(tri[i][Y], tri[i][X], tri[i + 1][Y], tri[i + 1][X], y, x);
				if (x < xMin)
				{
					xMin = x;
					realInterpolate(tri[i][Y], tri[i][Z], tri[i + 1][Y], tri[i + 1][Z], y, zMin);
					colorInterpolate(tri[i][Y], tri.colors[i], tri[i + 1][Y], tri.colors[i + 1], y, cMin);
					normalInterpolate(tri[i][Y], tri.normals[i], tri[i + 1][Y], tri.normals[i + 1], y, nMin);
				}
				if (x > xMax)
				{
					xMax = x;
					realInterpolate(tri[i][Y], tri[i][Z], tri[i + 1][Y], tri[i + 1][Z], y, zMax);
					colorInterpolate(tri[i][Y], tri.colors[i], tri[i + 1][Y], tri.colors[i + 1], y, cMax);
					normalInterpolate(tri[i][Y], tri.normals[i], tri[i + 1][Y], tri.normals[i + 1], y, nMax);
				}
			}
		}
		drawRasLine(y, xMin, zMin, cMin, nMin, xMax - 1e-3, zMax, cMax, nMax, status);
	}
}

GzColor GzFrameBuffer::shade(GzColor c, GzVector n)
{
	if (curShadeModel == GZ_GOURAUD)
	{
		GzColor color;
		//Add ambient light first
		for (int i = 0; i < 3; i++)
		{
			color[i] = kA * c[i];
		}

		for (int i = 0; i < Lights.size(); i++)
		{
			//Add diffuse light
			float normalLight = dotProduct(n, Lights[i].direction);
			for (int j = 0; j < 3; j++)
			{
				color[j] += kD * Lights[i].color[j] * normalLight;
			}
			//If n and l are normalized, then r = 2n<n,l> - l
			GzVector r = 2 * abs(normalLight) * n - Lights[i].direction;
			GzVector E = GzVector(0, 0, 1);
			GzMatrix reflectedMatrix = GzMatrix();
			reflectedMatrix.resize(3, 1);

			reflectedMatrix[0][0] = r[0];
			reflectedMatrix[1][0] = r[1];
			reflectedMatrix[2][0] = r[2];
			reflectedMatrix = lightTransformMat * reflectedMatrix;
			r[0] = reflectedMatrix[0][0];
			r[1] = reflectedMatrix[1][0];
			r[2] = reflectedMatrix[2][0];
			r.normalize();

			GzReal z = dotProduct(r, E);
			// Apply specular lighting
			for (int j = 0; j < 3; j++)
				//all numbers inferior to 1 will decrease when we apply the power,
				// this is helping us know if it should be glossy or not (specular)
				color[i] += kS * Lights[i].color[j] * pow(max(z, 0.0), s);
		}

		for (int i = 0; i < 3; i++)
			color[i] = clamp(color[i], 0.0, 1.0);
		return color;
	}
	else if (curShadeModel == GZ_PHONG)
	{
	}
	else
	{
		// base case no shader
		return c;
	}
}

void GzFrameBuffer::drawRasLine(GzInt y, GzReal xMin, GzReal zMin, GzColor &cMin, GzVector nMin, GzReal xMax, GzReal zMax, GzColor &cMax, GzVector nMax, GzFunctional status)
{
	if ((y < 0) || (y >= image.sizeH()))
		return;
	if ((GzInt)floor(xMin) == (GzInt)floor(xMax))
	{
		if (zMin > zMax)
			drawPoint(GzVertex(floor(xMin), y, zMin), cMin, status);
		else
			drawPoint(GzVertex(floor(xMin), y, zMax), cMax, status);
	}
	else
	{
		GzReal z;
		GzColor c;
		GzVector n;
		y = image.sizeH() - y - 1;
		int w = image.sizeW();
		if (status & GZ_DEPTH_TEST)
		{
			for (int x = max(0, (GzInt)floor(xMin)); x <= min(w - 1, (GzInt)floor(xMax)); x++)
			{
				realInterpolate(xMin, zMin, xMax, zMax, x, z);
				if (z >= depthBuffer[x][y])
				{
					colorInterpolate(xMin, cMin, xMax, cMax, x, c);
					if (status & GZ_LIGHTING)
					{
						normalInterpolate(xMin, nMin, xMax, nMax, x, n);
						c = shade(c, n);
					}
					image.set(x, y, c);
					depthBuffer[x][y] = z;
				}
			}
		}
		else
		{
			for (int x = max(0, (GzInt)floor(xMin)); x <= min(w - 1, (GzInt)floor(xMax)); x++)
			{
				realInterpolate(xMin, zMin, xMax, zMax, x, z);
				colorInterpolate(xMin, cMin, xMax, cMax, x, c);
				if (status & GZ_LIGHTING)
				{
					normalInterpolate(xMin, nMin, xMax, nMax, x, n);
					c = shade(c, n);
				}

				image.set(x, y, c);
				depthBuffer[x][y] = z;
			}
		}
	}
}

void GzFrameBuffer::realInterpolate(GzReal key1, GzReal val1, GzReal key2, GzReal val2, GzReal key, GzReal &val)
{
	val = val1 + (val2 - val1) * (key - key1) / (key2 - key1);
}

void GzFrameBuffer::colorInterpolate(GzReal key1, GzColor &val1, GzReal key2, GzColor &val2, GzReal key, GzColor &val)
{
	GzReal k = (key - key1) / (key2 - key1);
	for (GzInt i = 0; i < 4; i++)
		val[i] = val1[i] + (val2[i] - val1[i]) * k;
}

void GzFrameBuffer::normalInterpolate(GzReal key1, GzVector &val1, GzReal key2, GzVector &val2, GzReal key, GzVector &val)
{
	GzReal k = (key - key1) / (key2 - key1);
	for (GzInt i = 0; i < 3; i++)
	{
		val[i] = val1[i] + (val2[i] - val1[i]) * k;
	}
}
void GzFrameBuffer::shadeModel(const GzInt model)
{
	curShadeModel = model;
}

void GzFrameBuffer::material(GzReal _kA, GzReal _kD, GzReal _kS, GzReal _s)
{
	kA = _kA;
	kD = _kD;
	kS = _kS;
	s = _s;
}

void GzFrameBuffer::addLight(const GzVector &v, const GzColor &c)
{
	Lights.push_back(GzLight(v, c));
}

void GzFrameBuffer::loadLightTrans(GzMatrix &transMatrix)
{
	GzMatrix lightTransform = GzMatrix();
	// make it a 3x3
	lightTransform.resize(3, 3);
	// copy transform matrix into light transform matrix
	for (int i = 0; i < 3; i++)
		for (int j = 0; j < 3; j++)
			lightTransform[i][j] = transMatrix[i][j];
	// inverse and transpose matrix, store to class
	lightTransformMat = lightTransform.inverse3x3().transpose();
}