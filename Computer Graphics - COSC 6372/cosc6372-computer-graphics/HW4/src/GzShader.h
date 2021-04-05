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

// class GzShader
// {
//     virtual ~GzShader();
//     virtual GzVector verteex(int iface, int nthvert) = 0;
//     virtual bool fragment(GzVector barycentric, GzColor &color) = 0;
// };

// class GzGouraudShader : public GzShader
// {
// public:
//     GzVector intesnity;
//     virtual GzVector vertex(int iface, int nthvert);
//     virtual bool fragment(GzVector barycentric, GzColor &color);
// };

#endif
