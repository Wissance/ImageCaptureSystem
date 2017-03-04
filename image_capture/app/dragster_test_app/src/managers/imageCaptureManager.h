#ifndef SRC_MANAGERS_IMAGECAPTUREMANAGER_H_
#define SRC_MANAGERS_IMAGECAPTUREMANAGER_H_

#include "imageCaptureState.h"
#include "dragsterConfig.h"
#include "xaxivdma.h"
#include "xspi.h"
#include "xscugic.h"
#include "xil_exception.h"
#include "xil_assert.h"

struct ImageCaptureManager
{
public:
    void initialize();
    void startImageCapture();
    void stopImageCapture();
private:
    void initializeVdmaDevices();
    void setupVdmaDevice(XAxiVdma* vdma, u16 deviceId, u32 memoryBaseAddress);
    void configureVdmaInterrupts();
    void initializeSpi();
    void initializeDragsters();
    void initializeDragsterImpl(int dragsterSlaveSelectMask);
    void sendDragsterRegisterValue(unsigned char address, unsigned char value);
    void endDragsterTransaction();
private:
    XAxiVdma _vdma1;
    XAxiVdma _vdma2;
    XScuGic _interruptController;

    XSpi _spi;
    ImageCaptureState _imageCaptureState;
    DragsterConfig _linescanner0Config;
    DragsterConfig _linescanner1Config;
};



#endif /* SRC_MANAGERS_IMAGECAPTUREMANAGER_H_ */
