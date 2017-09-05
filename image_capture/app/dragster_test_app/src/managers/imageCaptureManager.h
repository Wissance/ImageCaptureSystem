#ifndef SRC_MANAGERS_IMAGECAPTUREMANAGER_H_
#define SRC_MANAGERS_IMAGECAPTUREMANAGER_H_

#include "imageCaptureState.h"
#include "dragsterConfig.h"
#include "xaxivdma.h"
#include "xscugic.h"
#include "xil_exception.h"
#include "xil_assert.h"

class ImageCaptureManager
{
public:
    void initialize();
    void startImageCapture();
    void stopImageCapture();
private:
    // vdma
    void initializeVdmaDevices();
    void setupVdmaDevice(XAxiVdma* vdma, u16 deviceId, u32 memoryBaseAddress);
    void configureVdmaInterrupts();
    void startVdmaTransfer();
    void stopVdmaTransfer();
private:
    // vdma entities
    XAxiVdma _vdma1;
    XAxiVdma _vdma2;
    XScuGic _interruptController;

    struct ImageCaptureState _imageCaptureState;
    struct DragsterConfig _linescanner0Config;
    struct DragsterConfig _linescanner1Config;
};


#endif /* SRC_MANAGERS_IMAGECAPTUREMANAGER_H_ */
