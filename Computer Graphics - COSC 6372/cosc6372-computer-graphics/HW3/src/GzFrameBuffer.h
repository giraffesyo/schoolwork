#ifndef __GZ_FRAME_BUFFER_H_
#define __GZ_FRAME_BUFFER_H_

#include "GzCommon.h"
#include "GzImage.h"

//Frame buffer with Z-buffer -------------------------------------------------
class GzFrameBuffer
{
public:
	// sizes the frame buffer, should be called before other methods
	void initFrameSize(GzInt width, GzInt height);
	// Creates a GzImage from the frame buffer
	GzImage toImage();
	// sets all pixels/points in the frame buffer to the clear color
	void clear(GzFunctional buffer);
	// sets the background color
	void setClearColor(const GzColor &color);
	// sets the depth for the background, points behind this will be culled
	void setClearDepth(GzReal depth);
	// attempts to add a point or pixel to the frame buffer
	void drawPoint(const GzVertex &v, const GzColor &c, GzFunctional status);
	// attempts to add a triangle to the frame buffer
	void drawTriangle(vector<GzVertex> &v, vector<GzColor> &c, GzFunctional status);
	void drawLine(int x0, int y0, int x1, int y1, GzColor color);

private:
	// color to use when clearing, background color of frame buffer
	GzColor clearColor;
	// the depth to use when clearing
	GzReal clearDepth;
	// vector storing the depth of each point in the frame
	vector<vector<GzReal>> depthBuffer;
	// stores the image for outputting to bitmap, must be generated with toImage method
	GzImage image;
	// Returns true if a point is within the bounds of the frame buffer
	GzBool inBounds(GzVertex v);
	void realInterpolate(GzReal key1, GzReal val1, GzReal key2, GzReal val2, GzReal key, GzReal &val);
	void colorInterpolate(GzReal key1, GzColor &val1, GzReal key2, GzColor &val2, GzReal key, GzColor &val);
	void drawRasLine(GzInt y, GzReal xMin, GzReal zMin, GzColor &cMin, GzReal xMax, GzReal zMax, GzColor &cMax, GzFunctional status);
};
//----------------------------------------------------------------------------

#endif
