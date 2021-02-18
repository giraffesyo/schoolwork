#include "GzFrameBuffer.h"

//Put your implementation here------------------------------------------------

void GzFrameBuffer::initFrameSize(GzInt width, GzInt height)
{
    this->width = width;
    this->height = height;
    pixelBuffer.resize(height); // reserve rows
    image = GzImage(width, height);
}

void GzFrameBuffer::setClearColor(const GzColor &color)
{
    clearColor = color;
}
void GzFrameBuffer::setClearDepth(GzReal depth)
{
    clearDepth = depth;
}

void GzFrameBuffer::clear(GzFunctional buffer)
{
    image.clear(clearColor); // set the background color for the image
    fill(pixelBuffer.begin(), pixelBuffer.end(), vector<GzFramePixel>(width, GzFramePixel(clearColor, clearDepth)));
}

GzImage GzFrameBuffer::toImage()
{
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            image.set(i, j, pixelBuffer[i][j].getColor());
        }
    }
    return image; // return already created image
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
    pixelBuffer[v.at(Y)][v.at(X)] = GzFramePixel(c, 0); // set the color at the point in our framebuffer, ignoring depth
}
