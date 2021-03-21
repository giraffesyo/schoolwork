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
	frameBuffer.initFrameSize(width, height);
	// Set initial projection and transformation matrices
	prjMatrix = Identity(4);
	transMatrix = Identity(4);
}

GzMatrix Gz::CreateViewportMatrix(int x, int y, int w, int h)
{
	GzMatrix m = Identity(4);
	m[X][W] = x + w / 2.f;
	m[Y][W] = y + h / 2.f;
	m[Z][W] = 255 / 2.f;

	m[X][X] = w / 2.f;
	m[Y][Y] = h / 2.f;
	m[Z][Z] = 255 / 2.f;
	return m;
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
			GzVertex v = vertexQueue.front();
			vertexQueue.pop();
			GzColor c = colorQueue.front();
			colorQueue.pop();
			frameBuffer.drawPoint(v, c, status);
		}
	}
	break;
	case GZ_TRIANGLES:
	{
		//Put your triangle drawing implementation here:
		//   - Extract 3 vertices in the vertexQueue
		//   - Extract 3 colors in the colorQueue
		//   - Call the draw triangle function
		//     (you may put this function in GzFrameBuffer)
		GzInt width = frameBuffer.width;
		GzInt height = frameBuffer.height;
		Viewport = CreateViewportMatrix(width / 8, height / 8, width * 3 / 4, height * 3 / 4);

		// divide the input size intoo groups of 3 because we're dealing with stacks of 3 vertices and 3 colors to create a triangle
		const int sides = 3;
		// continue until we're out of triangles
		while (colorQueue.size() >= sides && vertexQueue.size() >= sides)
		{
			vector<GzColor> colors = vector<GzColor>(3);
			vector<GzVertex> vertices = vector<GzVertex>(3);
			GzMatrix M;
			// loop over each triangle
			for (int i = 0; i < sides; i++)
			{
				// Grab the first color and vertex from queue
				GzColor color = colorQueue.front();
				GzVertex vertex = vertexQueue.front();

				// get matrix from vertex
				M.fromVertex(vertex);
				// Transform matrix by multiplying projection and transformation matrices with current matrix
				// store vertex and color in vector representing this triangle
				vertices[i] = (Viewport * prjMatrix * transMatrix * M).toVertex();
				colors[i] = color;
				// remove the vertex and color from the queue
				vertexQueue.pop();
				colorQueue.pop();
			}

			// draw thhe triangle
			frameBuffer.drawTriangle(vertices, colors, status);
			// Reset vertices and colors vectors
			vertices.clear();
			colors.clear();
		}
	}
	break;
	}
}
//Transformations-------------------------------------------------------------
void Gz::lookAt(GzReal eyeX, GzReal eyeY, GzReal eyeZ,
				GzReal centerX, GzReal centerY, GzReal centerZ,
				GzReal upX, GzReal upY, GzReal upZ)
{
	//Define viewing transformation
	//Or google: gluLookAt
	// Following implementaiton at: https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluLookAt.xml
	GzVertex UP = GzVertex(upX, upY, upZ);
	GzVertex eye = GzVertex(eyeX, eyeY, eyeZ);
	GzVertex center = GzVertex(centerX, centerY, centerZ);
	GzVertex F = GzVertex(centerX - eyeX, centerY - eyeY, centerZ - eyeZ);
	// normalized F and UP
	GzVertex f = F.normalize();
	GzVertex up = UP.normalize();
	GzVertex s = f.cross(up);
	GzVertex u = s.normalize().cross(f);

	GzMatrix M = GzMatrix();
	M.resize(4, 4);
	M.at(0) = {s[0], s[1], s[2], 0};
	M.at(1) = {u[0], u[1], u[2], 0};
	M.at(2) = {-f[0], -f[1], -f[2], 0};
	M.at(3) = {0, 0, 0, 1};
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

// https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glMultMatrix.xml
void Gz::multMatrix(GzMatrix &M)
{
	// Multiplies the current matrix with the one specified and replaces current matrix with product
	transMatrix = M * transMatrix;
}
//End of Transformations------------------------------------------------------

//Projections-----------------------------------------------------------------
void Gz::perspective(GzReal fovy, GzReal aspect, GzReal zNear, GzReal zFar)
{
	//Set up a perspective projection matrix
	// Following implentation from :
	// https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluPerspective.xml

	GzReal f = cos(fovy / 2.f) / sin(fovy / 2.f);
	GzMatrix m;
	m.resize(4, 4);
	m[0] = {f / aspect, 0, 0, 0};
	m[1] = {0, f, 0, 0};
	m[2] = {0, 0, (zFar + zNear) / (zNear - zFar), (2 * zFar * zNear) / (zNear - zFar)};
	m[3] = {0, 0, -1, 0};
	transMatrix = transMatrix * m;
}

void Gz::orthographic(GzReal left, GzReal right, GzReal bottom, GzReal top, GzReal nearVal, GzReal farVal)
{
	//Set up a orthographic projection matrix
	//Or google: glOrtho

	// Following implementation at https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glOrtho.xml
	vector<GzReal> t = {-((right + left) / (right - left)), -((top + bottom) / (top - bottom)), -((farVal + nearVal) / (farVal - nearVal)), 1};

	GzMatrix M;
	M.resize(4, 4);
	M.at(0) = {2 / (right - left), 0, 0, t[X]};
	M.at(1) = {0, 2 / (top - bottom), 0, t[Y]};
	M.at(2) = {0, 0, -2 / (farVal - nearVal), t[Z]};
	M.at(3) = {0, 0, 0, t[W]};
	multMatrix(M);
}
//End of Projections----------------------------------------------------------

//============================================================================
//End of Implementations in Assignment #3
//============================================================================
