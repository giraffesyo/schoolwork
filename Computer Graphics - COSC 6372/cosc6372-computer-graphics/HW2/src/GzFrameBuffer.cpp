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
// references line drawing from https://github.com/ssloy/tinyrenderer/wiki/Lesson-1-Bresenham%E2%80%99s-Line-Drawing-Algorithm
void GzFrameBuffer::drawLine(int x0, int y0, int x1, int y1, GzColor color)
{
    bool steep = false;
    if (std::abs(x0 - x1) < std::abs(y0 - y1))
    {
        std::swap(x0, y0);
        std::swap(x1, y1);
        steep = true;
    }
    if (x0 > x1)
    {
        std::swap(x0, x1);
        std::swap(y0, y1);
    }
    int dx = x1 - x0;
    int dy = y1 - y0;
    int derror2 = std::abs(dy) * 2;
    int error2 = 0;
    int y = y0;
    for (int x = x0; x <= x1; x++)
    {
        if (steep)
        {
            drawPoint(GzVertex(x, y, 0), color, ~GZ_DEPTH_TEST);
        }
        else
        {
            drawPoint(GzVertex(x, y, 0), color, ~GZ_DEPTH_TEST);
        }
        error2 += derror2;
        if (error2 > dx)
        {
            y += (y1 > y0 ? 1 : -1);
            error2 -= dx * 2;
        }
    }
}

void GzFrameBuffer::drawTriangle(GzTriangle triangle, const GzFunctional status)
{
    // if this triangle is completely off screen, don't do anything
    if (triangle.rowMax < 0)
        return;

    GzColor color(1, 0, 0, 1);

    float maxF = numeric_limits<float>::max();
    GzVertex minBounds(maxF, maxF, 0);
    GzVertex maxBounds(-maxF, -maxF, 0);
    GzVertex clamp(width - 1, height - 1, 0);
    for (int i = 0; i < 3; i++)
    {
        for (int j = 0; j < 2; j++)
        {
            minBounds[j] = max(0., min(minBounds[j], triangle[i][j]));
            maxBounds[j] = min(clamp[j], max(maxBounds[j], triangle[i][j]));
        }
    }
    GzVertex P;
    for (P[X] = minBounds[X]; P[X] <= maxBounds[X]; P[X]++)
    {
        for (P[Y] = minBounds[Y]; P[Y] <= maxBounds[Y]; P[Y]++)
        {
            GzVertex bc_screen = triangle.barycentric(P);
            if (bc_screen[X] < 0 || bc_screen[Y] < 0 || bc_screen[Z] < 0)
                continue;
            P[Z] = 0;
            for (int i = 0; i < 3; i++)
            {
                P[Z] += triangle[i][Z] * bc_screen[i];
            }
            drawPoint(GzVertex(P[X], P[Y], P[Z]), triangle[0].color, status);
        }
    }
}

// void GzFrameBuffer::drawLine(const GzVertex &p, const GzVertex &q, GzColor)
// {
// }