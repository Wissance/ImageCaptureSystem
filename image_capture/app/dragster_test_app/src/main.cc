/*
 * Dragster line scanners readout test
 */

#include <stdio.h>
#include "imageCaptureManager.h"

int main()
{
    printf("Application started\n\r");
    ImageCaptureManager systemManager;
    systemManager.initialize();
    // check config
    struct DragsterConfig linescanner0Config = systemManager.getDragsterConfig(LINESCANNER0);
    struct DragsterConfig linescanner1Config = systemManager.getDragsterConfig(LINESCANNER1);
    // todo: umv: write config in file via FatFS
    // start process ...
    systemManager.startImageCapture();
    // stop ...
    systemManager.stopImageCapture();
    return 0;
}
