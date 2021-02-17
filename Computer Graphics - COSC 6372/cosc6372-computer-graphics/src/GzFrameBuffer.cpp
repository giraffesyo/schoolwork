#include "GzFrameBuffer.h"

//Put your implementation here------------------------------------------------

void GzFrameBuffer::initFrameSize(GzInt width, GzInt height)
{
    this->width = width;
    this->height = height;
    colorBuffer.reserve(height * width);
    image = GzImage(width, height);
}

void GzFrameBuffer::setClearColor(const GzColor &color)
{
    clearColor = color;
}

void GzFrameBuffer::clear(GzFunctional buffer)
{
    image.clear(clearColor);
    for (int i = 0; i < height * width; i++)
    {
        colorBuffer.push_back(clearColor);
    }
}

GzImage GzFrameBuffer::toImage()
{
    return image;
}

void GzFrameBuffer::setClearDepth(GzReal depth)
{
}

void GzFrameBuffer::drawPoint(const GzVertex &v, const GzColor &c, GzFunctional status)
{
}
