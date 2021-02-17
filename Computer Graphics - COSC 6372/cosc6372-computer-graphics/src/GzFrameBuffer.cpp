#include "GzFrameBuffer.h"

//Put your implementation here------------------------------------------------

void GzFrameBuffer::initFrameSize(GzInt width, GzInt height)
{
    this->width = width;
    this->height = height;
    colorBuffer.reserve(height); // reserve rows
    image = GzImage(width, height);
}

void GzFrameBuffer::setClearColor(const GzColor &color)
{
    clearColor = color; // set the background color we will use
}

void GzFrameBuffer::clear(GzFunctional buffer)
{
    image.clear(clearColor); // set the background color for the image
    for (int row = 0; row < height; row++)
    {
        vector<GzColor> currentRow = vector<GzColor>(width); // create a vector for this row, it will hold all the columsn in this row
        colorBuffer[row] = currentRow;                       // set the current row to the created vector
        for (int col = 0; col < width; col++)
        {
            currentRow[col] = clearColor; // set every column to the clear color in our framebuffer
        }
    }
}

GzImage GzFrameBuffer::toImage()
{
    return image; // retrun already created image
}

void GzFrameBuffer::setClearDepth(GzReal depth)
{
}

void GzFrameBuffer::drawPoint(const GzVertex &v, const GzColor &c, GzFunctional status)
{
    // ignore status for now
    // colorBuffer[v.at(X)][v.at(Y)] = c; // set the color at the point in our framebuffer
    image.set(v.at(X), v.at(Y), c);
}
