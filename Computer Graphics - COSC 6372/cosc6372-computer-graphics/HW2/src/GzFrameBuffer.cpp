#include "GzFrameBuffer.h"
#include <cmath>

void GzFrameBuffer::initFrameSize(GzInt width, GzInt height)
{
    this->width = width;
    this->height = height;
    colorBuffer.resize(width); // reserve cols
    depthBuffer.resize(width);
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
    if (buffer & GZ_COLOR_BUFFER)
    {
        fill(colorBuffer.begin(), colorBuffer.end(), vector<GzColor>(height, clearColor));
    }
    if (buffer & GZ_DEPTH_BUFFER)
    {
        fill(depthBuffer.begin(), depthBuffer.end(), vector<GzReal>(height, clearDepth));
    }
}

GzImage GzFrameBuffer::toImage()
{
    image.clear(clearColor); // set the background color for the image

    for (int i = 0; i < width; i++)
    {
        for (int j = 0; j < height; j++)
        {
            image.set(i, j, colorBuffer[i][j]);
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
    const GzInt x = v.at(X);
    const GzInt y = v.at(Y);
    const GzInt z = v.at(Z);
    // do nothing if out of framebuffer bounds
    if (!inBounds(v))
        return;
    // Good resource for explaining depth test:
    // https://learnopengl.com/Advanced-OpenGL/Depth-testing
    if (status & GZ_DEPTH_TEST) // if we should test for depth
    {
        // Note that this is opposite of OpenGL's `GL_LESS`
        // default here is like their `GL_GREATER`
        if (depthBuffer[x][y] < z)
        {
            depthBuffer[x][y] = z;
            colorBuffer[x][y] = c;
        }
    }
    else // we don't consider depth at all
    {

        colorBuffer[x][y] = c; // set the color at the point in our framebuffer
    }
}

void GzFrameBuffer::drawTriangle(GzTriangle triangle, const GzColor colors[3], const GzFunctional status)
{

    const GzColor pColor = colors[0];
    const GzColor qColor = colors[1];
    const GzColor sColor = colors[2];

    for (int i = 0; i < width; i++)
    {
        for (int j = triangle.rowMin; j < triangle.rowMax; j++)
        {
            GzVertex p = GzVertex(i, j, 0);
            if (triangle.containsPoint(p))
            {
                // FIXME: what do we do with Z
                // cout << "drawing";
                drawPoint(p, colors[0], status);
            }
        }
    }
}

// void GzFrameBuffer::drawLine(const GzVertex &p, const GzVertex &q, GzColor)
// {
// }