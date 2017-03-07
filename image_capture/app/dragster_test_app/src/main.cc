/*
 * Dragster line scanners readout test
 */

#include <stdio.h>
#include "imageCaptureManager.h"
#include "videoBuffer.h"
#include "globalDefs.h"
#include "callbacks.h"

struct VideoBuffer vBuffer0;
struct VideoBuffer vBuffer1;

static void sendViaUart(u8 bufferIndex, struct VideoBuffer* buffer);

void copyVdma(u8 linescannerIndex, u8* address, u32 mask)
{
    if(linescannerIndex == 0)
    {
        if(vBuffer0._writeIndex == NUMBER_OF_LINES)
            vBuffer0._writeIndex = -1;
        vBuffer0._writeIndex++;
        for(int i = 0; i < DRAGSTER_LINE_LENGTH; i++)
            vBuffer0._buffer[vBuffer0._writeIndex][i] = *(address + i);
        sendViaUart(0, &vBuffer0);
    }
    else
    {
        if(vBuffer1._writeIndex == NUMBER_OF_LINES)
            vBuffer1._writeIndex = -1;
        vBuffer1._writeIndex++;
        for(int i = 0; i < DRAGSTER_LINE_LENGTH; i++)
            vBuffer1._buffer[vBuffer1._writeIndex][i] = *(address + i);
        sendViaUart(1, &vBuffer1);
    }
}

static void sendViaUart(u8 bufferIndex, struct VideoBuffer* buffer)
{

}

int main()
{
    printf("Application started\n\r");
    vBuffer0._sendIndex = -1;
    vBuffer0._writeIndex = -1;
    vBuffer1._sendIndex = -1;
    vBuffer1._writeIndex = -1;
    ImageCaptureManager systemManager;
    systemManager.initialize();
    // check config
    struct DragsterConfig linescanner0Config = systemManager.getDragsterConfig(LINESCANNER0);
    struct DragsterConfig linescanner1Config = systemManager.getDragsterConfig(LINESCANNER1);
    xil_printf("Linescanner 0, Register1: 0x%02X", linescanner0Config.getControlRegister1()._registerValue);
    xil_printf("Linescanner 0, Register2: 0x%02X", linescanner0Config.getControlRegister2()._registerValue);
    xil_printf("Linescanner 0, Register3: 0x%02X", linescanner0Config.getControlRegister3()._registerValue);

    xil_printf("Linescanner 1, Register1: 0x%02X", linescanner1Config.getControlRegister1()._registerValue);
    xil_printf("Linescanner 1, Register2: 0x%02X", linescanner1Config.getControlRegister2()._registerValue);
    xil_printf("Linescanner 1, Register3: 0x%02X", linescanner1Config.getControlRegister3()._registerValue);
    // todo: umv: write configuration in files via FatFS
    // start process ...
    systemManager.startImageCapture();
    // stop ...
    systemManager.stopImageCapture();
    return 0;
}
