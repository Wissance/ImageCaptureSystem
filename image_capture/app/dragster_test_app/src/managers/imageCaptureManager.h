#ifndef SRC_MANAGERS_IMAGECAPTUREMANAGER_H_
#define SRC_MANAGERS_IMAGECAPTUREMANAGER_H_

#include "imageCaptureState.h"
#include "dragsterConfig.h"
#include "xaxivdma.h"
#include "xspi.h"

struct ImageCaptureManager
{
public:
    void initialize();
    void startImageCapture();
    void stopImageCapture();
private:
    void initializeVdmaDevices();
    void initializeSpi();
    void initializeDragsters();
    void initializeDragsterImpl(int dragsterSlaveSelectMask);
    void sendDragsterRegisterValue(unsigned char address, unsigned char value);
    void endDragsterTransaction();
private:
    XAxiVdma _vdma1;
    XAxiVdma _vdma2;
    XSpi _spi;

    ImageCaptureState _imageCaptureState;
    DragsterConfig _linescanner0Config;
    DragsterConfig _linescanner1Config;
};



#endif /* SRC_MANAGERS_IMAGECAPTUREMANAGER_H_ */
