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
		int iter = 0;
		while (vertexQueue.size() >= 3 && iter < 25)
		{
			//   - Pop 3 vertices in the vertexQueue
			GzVertex vA = vertexQueue.front();
			vertexQueue.pop();
			GzVertex vB = vertexQueue.front();
			vertexQueue.pop();
			GzVertex vC = vertexQueue.front();
			vertexQueue.pop();
			GzTriangle tri = GzTriangle(vA, vB, vC);

			//   - Pop 3 colors in the colorQueue
			GzColor cA = colorQueue.front();
			GzColor cB = colorQueue.front();
			GzColor cC = colorQueue.front();
			GzColor colors[] = {cA, cB, cC};
			//   - Call the draw triangle function
			//     (you may put this function in GzFrameBuffer)
			frameBuffer.drawTriangle(tri, colors, status);
			iter++;
		}
	}
	break;
	}
}
//============================================================================
//End of Implementations in Assignment #2
//============================================================================
