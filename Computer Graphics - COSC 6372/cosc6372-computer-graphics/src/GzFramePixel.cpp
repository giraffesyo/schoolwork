#include "GzFramePixel.h"
#include "GzCommon.h"

GzFramePixel::GzFramePixel(const GzColor &color, GzInt depth)
{
    this->color = color;
    this->depth = depth;
}

GzInt GzFramePixel::getDepth()
{
    return depth;
}
GzColor GzFramePixel::getColor()
{
    return color;
}