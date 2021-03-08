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

void GzFrameBuffer::drawTriangle(GzTriangle triangle, const GzFunctional status)
{
    // if this triangle is completely off screen, don't do anything
    if (triangle.rowMax < 0 || triangle.rowMin > height || triangle.colMax < 0 || triangle.colMin > width)
        return;

    // clamp loops to bounds of tiangle
    triangle.CalculateBounds(width - 1, height - 1);

    for (double x = triangle.MinBounds[X]; x <= triangle.MaxBounds[X]; x++)
    {
        for (double y = triangle.MinBounds[Y]; y <= triangle.MaxBounds[Y]; y++)
        {
            // initialize Z to 0
            GzVertex P(x, y, 0);
            GzVertex barycentric = triangle.barycentric(P);
            // if this point is not in the triangle, we won't draw it
            // when using barycentric coordinates, range is from (0,1)
            // so any coordinate less than 0 is not inside the triangle
            float cutoff = 0;
            if (barycentric[X] < cutoff || barycentric[Y] < cutoff || barycentric[Z] < cutoff)
                continue;
            for (int i = 0; i < 3; i++)
            {
                // get weighted Z value, by multiplying each barycentric coordinate
                P[Z] += triangle[i][Z] * barycentric[i];
            }
            // draw point flipping image vertically
            drawPoint(GzVertex(P[X], height - P[Y], P[Z]), barycentric.color, status);
        }
    }
}