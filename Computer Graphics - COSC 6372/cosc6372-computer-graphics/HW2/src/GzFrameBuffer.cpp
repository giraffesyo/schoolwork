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

    if (triangle[0][Z] > 1000)
    {
        cout << "fuck";
    }
    GzVertex p = triangle[0]; // t0
    GzVertex q = triangle[1]; // t1
    GzVertex s = triangle[2]; // t2
    // sort the vertices
    if (p[Y] > q[Y])
        std::swap(p, q);
    if (p[Y] > s[Y])
        std::swap(p, s);
    if (q[Y] > s[Y])
        std::swap(q, s);
    GzColor red = GzColor(1, 0, 0, 1);
    GzColor green = GzColor(0, 1, 0, 1);

    int total_height = s[Y] - p[Y];
    for (int y = p[Y]; y <= q[Y]; y++)
    {
        int segment_height = q[Y] - p[Y] + 1;
        float alpha = (float)(y - p[Y]) / total_height == 0 ? 0.01f : total_height;
        float beta = (float)(y - p[Y]) / segment_height == 0 ? 0.01f : segment_height; // be careful with divisions by zero
        GzVertex a = p + (s - p) * alpha;
        GzVertex b = p + (q - p) * beta;
        if (a[X] > b[X])
            swap(a, b);
        for (int j = a[X]; j <= b[X]; j++)
        {
            // image.set(j, y, color); // attention, due to int casts t0.y+i != A.y
            drawPoint(GzVertex(j, y, 0), red, ~GZ_DEPTH_TEST);
        }
        // drawPoint(GzVertex(a[X], y, 0), red, ~GZ_DEPTH_TEST);
        // drawPoint(GzVertex(b[X], y, 0), green, ~GZ_DEPTH_TEST);

        // draw PQ
        // drawLine(triangle[0][X], triangle[0][Y], triangle[1][X], triangle[1][Y], red);
        // // draw PS
        // drawLine(triangle[0][X], triangle[0][Y], triangle[2][X], triangle[2][Y], green);
        // // draw QS
        // drawLine(triangle[1][X], triangle[1][Y], triangle[2][X], triangle[2][Y], red);
    }
    for (int y = q[Y]; y <= s[Y]; y++)
    {
        int segment_height = s[Y] - q[Y] + 1;
        float alpha = (float)(y - p[Y]) / total_height == 0 ? 0.01f : total_height;
        float beta = (float)(y - q[Y]) / segment_height == 0 ? 0.01f : segment_height; // be careful with divisions by zero
        GzVertex a = p + (s - p) * alpha;
        GzVertex b = q + (s - q) * beta;
        if (a[X] > b[X])
            std::swap(a, b);
        for (int j = a[X]; j <= b[X]; j++)
        {
            drawPoint(GzVertex(j, y, 0), green, ~GZ_DEPTH_TEST); // attention, due to int casts t0.y+i != A.y
        }
    }
}

// void GzFrameBuffer::drawLine(const GzVertex &p, const GzVertex &q, GzColor)
// {
// }