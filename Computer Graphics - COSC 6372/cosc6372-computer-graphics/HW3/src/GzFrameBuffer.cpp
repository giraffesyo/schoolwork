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
    const GzInt x = v[X];
    const GzInt y = v[Y];
    const GzInt z = v[Z];
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

void GzFrameBuffer::drawTriangle(vector<GzVertex> &v, vector<GzColor> &c, GzFunctional status)
{
    GzInt yMin, yMax;
    GzReal xMin, xMax, zMin, zMax;
    GzColor cMin, cMax;

    v.push_back(v[0]);
    c.push_back(c[0]);

    yMin = INT_MAX;
    yMax = -INT_MAX;

    for (GzInt i = 0; i < 3; i++)
    {
        yMin = min((GzInt)floor(v[i][Y]), yMin);
        yMax = max((GzInt)floor(v[i][Y] - 1e-3), yMax);
    }

    for (GzInt y = yMin; y <= yMax; y++)
    {
        xMin = INT_MAX;
        xMax = -INT_MAX;
        for (GzInt i = 0; i < 3; i++)
        {
            if ((GzInt)floor(v[i][Y]) == y)
            {
                if (v[i][X] < xMin)
                {
                    xMin = v[i][X];
                    zMin = v[i][Z];
                    cMin = c[i];
                }
                if (v[i][X] > xMax)
                {
                    xMax = v[i][X];
                    zMax = v[i][Z];
                    cMax = c[i];
                }
            }
            if ((y - v[i][Y]) * (y - v[i + 1][Y]) < 0)
            {
                GzReal x;
                realInterpolate(v[i][Y], v[i][X], v[i + 1][Y], v[i + 1][X], y, x);
                if (x < xMin)
                {
                    xMin = x;
                    realInterpolate(v[i][Y], v[i][Z], v[i + 1][Y], v[i + 1][Z], y, zMin);
                    colorInterpolate(v[i][Y], c[i], v[i + 1][Y], c[i + 1], y, cMin);
                }
                if (x > xMax)
                {
                    xMax = x;
                    realInterpolate(v[i][Y], v[i][Z], v[i + 1][Y], v[i + 1][Z], y, zMax);
                    colorInterpolate(v[i][Y], c[i], v[i + 1][Y], c[i + 1], y, cMax);
                }
            }
        }
        drawRasLine(y, xMin, zMin, cMin, xMax - 1e-3, zMax, cMax, status);
    }
}

void GzFrameBuffer::drawRasLine(GzInt y, GzReal xMin, GzReal zMin, GzColor &cMin, GzReal xMax, GzReal zMax, GzColor &cMax, GzFunctional status)
{
    if ((y < 0) || (y >= image.sizeH()))
        return;
    if ((GzInt)floor(xMin) == (GzInt)floor(xMax))
    {
        if (zMin > zMax)
            drawPoint(GzVertex(floor(xMin), y, zMin), cMin, status);
        else
            drawPoint(GzVertex(floor(xMin), y, zMax), cMax, status);
    }
    else
    {
        GzReal z;
        GzColor c;
        y = image.sizeH() - y - 1;
        int w = image.sizeW();
        if (status & GZ_DEPTH_TEST)
        {
            for (int x = max(0, (GzInt)floor(xMin)); x <= min(w - 1, (GzInt)floor(xMax)); x++)
            {
                realInterpolate(xMin, zMin, xMax, zMax, x, z);
                if (z >= depthBuffer[x][y])
                {
                    colorInterpolate(xMin, cMin, xMax, cMax, x, c);
                    image.set(x, y, c);
                    depthBuffer[x][y] = z;
                }
            }
        }
        else
        {
            for (int x = max(0, (GzInt)floor(xMin)); x <= min(w - 1, (GzInt)floor(xMax)); x++)
            {
                realInterpolate(xMin, zMin, xMax, zMax, x, z);
                colorInterpolate(xMin, cMin, xMax, cMax, x, c);
                image.set(x, y, c);
                depthBuffer[x][y] = z;
            }
        }
    }
}

void GzFrameBuffer::realInterpolate(GzReal key1, GzReal val1, GzReal key2, GzReal val2, GzReal key, GzReal &val)
{
    val = val1 + (val2 - val1) * (key - key1) / (key2 - key1);
}

void GzFrameBuffer::colorInterpolate(GzReal key1, GzColor &val1, GzReal key2, GzColor &val2, GzReal key, GzColor &val)
{
    GzReal k = (key - key1) / (key2 - key1);
    for (GzInt i = 0; i < 4; i++)
        val[i] = val1[i] + (val2[i] - val1[i]) * k;
}
