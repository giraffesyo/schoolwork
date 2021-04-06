#ifndef __GZ_SHADER_H_
#define __GZ_SHADER_H_

#include "GzVector.h"
#include "GzCommon.h"

class GzLight
{
public:
    GzVector direction;
    GzColor color;
    GzLight(const GzVector &v, const GzColor &c);

private:
};

#endif
