#include "GzShader.h"

GzLight::GzLight(const GzVector &v, const GzColor &c)
{
    this->color = c;
    this->direction = GzVector(-v[0], -v[1], -v[2]);
}
// GzVector GzGouraudShader::vertex(int iface, int nthvert)
// {

//     // intesnity[nthvert] = std::max(0.f, model->normal(iface, nthvert) * light_dir); // get diffuse lighting intensity
//     // GzVector gl_Vertex = embed<4>(model->vert(iface, nthvert));                               // read the vertex from .obj file
//     // return Viewport * Projection * ModelView * gl_Vertex;                                  // transform it to screen coordinates
// }

// bool GzGouraudShader::fragment(GzVector barycentric, GzColor &color)
// {
//     float intensity = intensity * barycentric;  // interpolate intensity for the current pixel
//     color = GzColor(255, 255, 255) * intensity; // well duh
//     return false;                               // no, we do not discard this pixel
// }
