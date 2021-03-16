#include "Gz.h"

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
void Gz::end()
{
	// In our implementation, all rendering is done when Gz::end() is called.
	// Depends on selected primitive, different number of vetices, colors, etc.
	// are popped out of the queue.
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
		int size = vertexQueue.size() / 3;
		vector<GzTriangle> triangles = vector<GzTriangle>();

		while (vertexQueue.size() >= 3)
		{
			GzVertex vertices[3];
			for (int i = 0; i < 3; i++)
			{
				vertices[i] = vertexQueue.front();
				vertices[i].color = colorQueue.front();

				vertexQueue.pop();
				colorQueue.pop();
			}
			triangles.push_back(GzTriangle(vertices[0], vertices[1], vertices[2]));
		}
		// sort the triangles so that the highest Y values come first
		sort(triangles.begin(), triangles.end(), [](const GzTriangle &a, const GzTriangle &b) -> bool { return a.rowMin < b.rowMin; });
		for (int i = 0; i < triangles.size() - 1; i++)
		{
			frameBuffer.drawTriangle(triangles[i], status);
		}
	}
	break;
	}
}
