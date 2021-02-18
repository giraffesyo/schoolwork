#ifndef __GZ_FRAME_BUFFER_H_
#define __GZ_FRAME_BUFFER_H_

#include "GzCommon.h"
#include "GzImage.h"

//Frame buffer with Z-buffer -------------------------------------------------
class GzFrameBuffer
{
public:
	//The common interface
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

private:
	//Put any variables and private functions for your implementation here
	// width of the frame buffer
	GzInt width;
	// height of the frame buffer
	GzInt height;
	// color to use when clearing, background color of frame buffer
	GzColor clearColor;
	// the depth to use when clearing
	GzReal clearDepth;
	// vector storing the color of each point in the frame
	vector<vector<GzColor>> colorBuffer;
	// vector storing the depth of each point in the frame
	vector<vector<GzReal>> depthBuffer;
	// stores the image for outputting to bitmap, must be generated with toImage method
	GzImage image;
	// Returns true if a point is within the bounds of the frame buffer
	GzBool inBounds(GzVertex v);
};
//----------------------------------------------------------------------------

#endif
