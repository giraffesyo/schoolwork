#include "GzFrameBuffer.h"

//Put your implementation here------------------------------------------------

void GzFrameBuffer::initFrameSize(GzInt width, GzInt height)
{
    this->width = width;
    this->height = height;
    colorBuffer.resize(height); // reserve rows
    image = GzImage(width, height);
}

void GzFrameBuffer::setClearColor(const GzColor &color)
{
    clearColor = color; // set the background color we will use
}

void GzFrameBuffer::clear(GzFunctional buffer)
{
    image.clear(clearColor); // set the background color for the image
    fill(colorBuffer.begin(), colorBuffer.end(), vector<GzColor>(width, clearColor));
}

GzImage GzFrameBuffer::toImage()
{
    return image; // retrun already created image
}

void GzFrameBuffer::setClearDepth(GzReal depth)
{
}

GzBool GzFrameBuffer::inBounds(GzVertex v)
{
    return v.at(X) >= 0 && v.at(Y) >= 0 && v.at(X) < width && v.at(Y) < height;
}

void GzFrameBuffer::drawPoint(const GzVertex &v, const GzColor &c, GzFunctional status)
{

    // ignore status for now
    // do nothing if out of framebuffer bounds
    if (!inBounds(v))
        return;
    colorBuffer[v.at(Y)][v.at(X)] = c; // set the color at the point in our framebuffer

    image.set(v.at(X), v.at(Y), c);
}
