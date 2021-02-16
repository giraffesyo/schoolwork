#include "GzFrameBuffer.h"

//Put your implementation here------------------------------------------------

void GzFrameBuffer::initFrameSize(GzInt width, GzInt height)
{
    this->width = width;
    this->height = height;
    colorBuffer.reserve(height * width);
}

void GzFrameBuffer::setClearColor(const GzColor &color)
{
    clearColor = color;
}

void GzFrameBuffer::clear(GzFunctional buffer)
{
    for (int i = 0; i < height * width; i++)
    {
        colorBuffer.push_back(clearColor);
    }
}

GzImage GzFrameBuffer::toImage()
{
    return GzImage(width, height);
}

void GzFrameBuffer::setClearDepth(GzReal depth)
{
}

void GzFrameBuffer::drawPoint(const GzVertex &v, const GzColor &c, GzFunctional status)
{
}
