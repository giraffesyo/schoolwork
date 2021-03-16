#include "Gz.h"

GzImage Gz::toImage()
{
	return frameBuffer.toImage();
}

void Gz::clear(GzFunctional buffer)
{
	frameBuffer.clear(buffer);
}

void Gz::clearColor(const GzColor &color)
{
	frameBuffer.setClearColor(color);
}

void Gz::clearDepth(GzReal depth)
{
	frameBuffer.setClearDepth(depth);
}

void Gz::enable(GzFunctional f)
{
	status = status | f;
}

void Gz::disable(GzFunctional f)
{
	status = status & (~f);
}

GzBool Gz::get(GzFunctional f)
{
	if (status & f)
		return true;
	else
		return false;
}

void Gz::begin(GzPrimitiveType p)
{
	currentPrimitive = p;
}

void Gz::addVertex(const GzVertex &v)
{
	vertexQueue.push(v);
}

void Gz::addColor(const GzColor &c)
{
	colorQueue.push(c);
}
//============================================================================
//Implementations in Assignment #3
//============================================================================

void Gz::initFrameSize(GzInt width, GzInt height)
{
	//This function need to be updated since we have introduced the viewport.
	//The viewport size is set to the size of the frame buffer.
	wViewport = (GzReal)width;
	hViewport = (GzReal)height;
	frameBuffer.initFrameSize(width, height);
	viewport(0, 0); //Default center of the viewport
}

void Gz::end()
{
	//This function need to be updated since we have introduced the viewport,
	//projection, and transformations.
	//In our implementation, all rendering is done when Gz::end() is called.
	//Depends on selected primitive, different number of vetices, colors, ect.
	//are pop out of the queue.
	switch (currentPrimitive)
	{
	case GZ_POINTS:
	{
		while ((vertexQueue.size() >= 1) && (colorQueue.size() >= 1))
		{
			// GzVertex v = vertexQueue.front();
			// vertexQueue.pop();
			// GzColor c = colorQueue.front();
			// colorQueue.pop();
			// frameBuffer.drawPoint(v, c, status);
		}
	}
	break;
	case GZ_TRIANGLES:
	{
		// int size = vertexQueue.size() / 3;
		// vector<GzTriangle> triangles = vector<GzTriangle>();

		// while (vertexQueue.size() >= 3)
		// {
		// 	GzVertex vertices[3];
		// 	for (int i = 0; i < 3; i++)
		// 	{
		// 		vertices[i] = vertexQueue.front();
		// 		vertices[i].color = colorQueue.front();

		// 		vertexQueue.pop();
		// 		colorQueue.pop();
		// 	}
		// 	triangles.push_back(GzTriangle(vertices[0], vertices[1], vertices[2]));
		// }
		// // sort the triangles so that the highest Y values come first
		// sort(triangles.begin(), triangles.end(), [](const GzTriangle &a, const GzTriangle &b) -> bool { return a.rowMin < b.rowMin; });
		// for (int i = 0; i < triangles.size() - 1; i++)
		// {
		// 	frameBuffer.drawTriangle(triangles[i], status);
		// }
	}
	break;
	}
}

void Gz::viewport(GzInt x, GzInt y)
{
	//This function only updates xViewport and yViewport.
	//Viewport calculation will be done in different function, e.g. Gz::end().
	//See http://www.opengl.org/sdk/docs/man/xhtml/glViewport.xml
	//Or google: glViewport
	xViewport = x;
	yViewport = y;
}

//Transformations-------------------------------------------------------------
void Gz::lookAt(GzReal eyeX, GzReal eyeY, GzReal eyeZ, GzReal centerX, GzReal centerY, GzReal centerZ, GzReal upX, GzReal upY, GzReal upZ)
{
	//Define viewing transformation
	//See http://www.opengl.org/sdk/docs/man/xhtml/gluLookAt.xml
	//Or google: gluLookAt
}

void Gz::translate(GzReal x, GzReal y, GzReal z)
{
	//Multiply transMatrix by a translation matrix
	//See http://www.opengl.org/sdk/docs/man/xhtml/glTranslate.xml
	//    http://en.wikipedia.org/wiki/Translation_(geometry)
	//Or google: glTranslate
}

void Gz::rotate(GzReal angle, GzReal x, GzReal y, GzReal z)
{
	//Multiply transMatrix by a rotation matrix
	//See http://www.opengl.org/sdk/docs/man/xhtml/glRotate.xml
	//    http://en.wikipedia.org/wiki/Rotation_(geometry)
	//Or google: glRotate
}

void Gz::scale(GzReal x, GzReal y, GzReal z)
{
	//Multiply transMatrix by a scaling matrix
	//See http://www.opengl.org/sdk/docs/man/xhtml/glScale.xml
	//    http://en.wikipedia.org/wiki/
	//Or google: glScale
}

//This function was updated on September 26, 2010
void Gz::multMatrix(GzMatrix mat)
{
	//Multiply transMatrix by the matrix mat
	transMatrix = mat * transMatrix;
}
//End of Transformations------------------------------------------------------

//Projections-----------------------------------------------------------------
void Gz::perspective(GzReal fovy, GzReal aspect, GzReal zNear, GzReal zFar)
{
	//Set up a perspective projection matrix
	//See http://www.opengl.org/sdk/docs/man/xhtml/gluPerspective.xml
	//Or google: gluPerspective
}

void Gz::orthographic(GzReal left, GzReal right, GzReal bottom, GzReal top, GzReal nearVal, GzReal farVal)
{
	//Set up a orthographic projection matrix
	//See http://www.opengl.org/sdk/docs/man/xhtml/glOrtho.xml
	//Or google: glOrtho
}
//End of Projections----------------------------------------------------------

//============================================================================
//End of Implementations in Assignment #3
//============================================================================
