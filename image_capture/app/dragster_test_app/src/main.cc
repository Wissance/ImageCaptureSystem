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
    systemManager.startImageCapture();

    systemManager.stopImageCapture();
    return 0;
}
