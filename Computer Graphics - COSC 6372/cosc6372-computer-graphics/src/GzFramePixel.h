#ifndef __GZ_FRAME_PIXEL_H_
#define __GZ_FRAME_PIXEL_H_

#include "GzCommon.h"

class GzFramePixel
{
public:
    GzFramePixel(const GzColor &color, GzInt depth);
    GzInt getDepth();
    GzColor getColor();

private:
    GzColor color;
    GzInt depth;
};

#endif