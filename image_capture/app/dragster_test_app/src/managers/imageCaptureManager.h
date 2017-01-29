#ifndef SRC_MANAGERS_IMAGECAPTUREMANAGER_H_
#define SRC_MANAGERS_IMAGECAPTUREMANAGER_H_

#include "imageCaptureState.h"
#include "dragsterConfig.h"
#include "xspi.h"

struct ImageCaptureManager
{
public:
	void initialize();
	void startImageCapture();
	void stopImageCapture();
private:
	void initializeSpi();
	void initializeDragsters();
	void initializeDragsterImpl();
private:
	XSpi _spi;
	ImageCaptureState _imageCaptureState;
    DragsterConfig _linescanner0Config;
    DragsterConfig _linescanner1Config;
};



#endif /* SRC_MANAGERS_IMAGECAPTUREMANAGER_H_ */
