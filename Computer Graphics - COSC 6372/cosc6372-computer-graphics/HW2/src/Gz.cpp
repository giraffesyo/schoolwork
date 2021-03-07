#include "Gz.h"

//============================================================================
//Implementations in Assignment #1
//============================================================================
void Gz::initFrameSize(GzInt width, GzInt height)
{
	frameBuffer.initFrameSize(width, height);
}

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
//End of Implementations in Assignment #1
//============================================================================

//============================================================================
//Implementations in Assignment #2
//============================================================================
void Gz::end()
{
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
		// int iter = 0;
		int size = vertexQueue.size() / 3;
		vector<GzTriangle> triangles = vector<GzTriangle>();

		while (vertexQueue.size() >= 3)
		{

			//   - Pop 3 vertices in the vertexQueue
			GzVertex vA = vertexQueue.front();
			vertexQueue.pop();
			GzVertex vB = vertexQueue.front();
			vertexQueue.pop();
			GzVertex vC = vertexQueue.front();
			vertexQueue.pop();

			//   - Pop 3 colors in the colorQueue
			const GzColor cA = colorQueue.front();
			colorQueue.pop();
			const GzColor cB = colorQueue.front();
			colorQueue.pop();
			const GzColor cC = colorQueue.front();
			colorQueue.pop();

			vA.color = cA;
			vB.color = cB;
			vC.color = cC;

			GzTriangle tri = GzTriangle(vA, vB, vC);
			triangles.push_back(tri);
			//   - Call the draw triangle function
			//     (you may put this function in GzFrameBuffer)
			// frameBuffer.drawTriangle(tri, colors, status);
			// iter++;
		}
		// sort the triangles so that the highest Y values come first
		sort(triangles.begin(), triangles.end(), [](const GzTriangle &a, const GzTriangle &b) -> bool { return a.rowMin < b.rowMin; });
		for (int i = 0; i < triangles.size() - 1; i++)
		{
			frameBuffer.drawTriangle(triangles[i], status);
		}
		frameBuffer.drawLine(0, 0, 10, 10, GzColor(1, 0, 0));
	}
	break;
	}
}
//============================================================================
//End of Implementations in Assignment #2
//============================================================================
