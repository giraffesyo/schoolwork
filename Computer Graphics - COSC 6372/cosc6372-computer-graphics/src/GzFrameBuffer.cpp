#include "GzFrameBuffer.h"

//Put your implementation here------------------------------------------------

void GzFrameBuffer::initFrameSize(GzInt width, GzInt height)
{
    width = width;
    height = height;
}

void GzFrameBuffer::setClearColor(const GzColor &color)
{
    clearColor = color;
}

void GzFrameBuffer::clear(GzFunctional buffer)
{
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
