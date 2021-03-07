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

void GzFrameBuffer::drawLine(int x0, int y0, int x1, int y1, GzColor color)
{
    for (float t = 0.; t < 1.; t += .01)
    {
        int x = x0 + (x1 - x0) * t;
        int y = y0 + (y1 - y0) * t;
        drawPoint(GzVertex(x, y, 0), color, ~GZ_DEPTH_TEST);
    }
}

void GzFrameBuffer::drawTriangle(GzTriangle triangle, const GzFunctional status)
{

    if (triangle.rowMax < 0)
        return;

    if (triangle.vertices[0][Z] > 1000)
    {
        cout << "fuck";
    }

    for (int i = triangle.colMin < 0 ? 0 : triangle.colMin; i < triangle.colMax; i++)
    {
        if (i > width)
            break;

        for (int j = triangle.rowMin < 0 ? 0 : triangle.rowMin; j < triangle.rowMax; j++)
        {
            // if (j > height)
            //     break;
            GzVertex p = GzVertex(i, j, 0);
            if (triangle.containsPoint(p))
            {
                //FIXME: interpolate color?
                p.color = triangle.vertices[1].color;
                // FIXME: what do we do with Z
                p[Z] = triangle.vertices[1][Z];
                drawPoint(p, p.color, status);
            }
        }
    }
}

// void GzFrameBuffer::drawLine(const GzVertex &p, const GzVertex &q, GzColor)
// {
// }