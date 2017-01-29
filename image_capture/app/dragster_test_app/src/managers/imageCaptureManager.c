#include "imageCaptureManager.h"
#include "axiIoHelper.h"

#define SPI_DEVICE_ID XPAR_SPI_0_DEVICE_ID
#define IMAGE_CAPTURE_MANAGER_BASE_ADDRESS 0x43C00000
#define START_COMMAND 1
#define STOP_COMMAND 2

void ImageCaptureManager::initialize()
{
	initializeSpi();
	initializeDragsters();
}

void ImageCaptureManager::startImageCapture()
{
	//Xil_Out32(IMAGE_CAPTURE_MANAGER_BASE_ADDRESS, 1);
	write(IMAGE_CAPTURE_MANAGER_BASE_ADDRESS, 0, START_COMMAND);
	xil_printf("\n Image Capture Manager has been started\n\r");
}

void ImageCaptureManager::stopImageCapture()
{
	//Xil_Out32(IMAGE_CAPTURE_MANAGER_BASE_ADDRESS, 2);
	write(IMAGE_CAPTURE_MANAGER_BASE_ADDRESS, 0, STOP_COMMAND);
	xil_printf("\n Image Capture Manager has been stopped\n\r");
}

/* Инициализация SPI в блокирующем режиме (polling mode)*/
void ImageCaptureManager::initializeSpi()
{
	int status;

	/* Запрашиваем конфигурацию устройства */
	XSpi_Config* spiConfig = XSpi_LookupConfig(SPI_DEVICE_ID);
	if(!spiConfig)
		xil_printf("\n XSpi_LookupConfig Failed\n\r");

	/* Инициализируем экземпляр SPI */
	status = XSpi_CfgInitialize(&_spi, spiConfig, spiConfig->BaseAddress);
	if(status != XST_SUCCESS)
		xil_printf("\n XSpi_CfgInitialize Failed\n\r");

	/* По умолчанию SPI является Slave, опция ниже конфигурирует его как Master */
	/* status = XSpi_SetOptions(&Spi, XSP_MASTER_OPTION);
	if(Status != XST_SUCCESS) {
		xil_printf("\n XSpi_SetOptions Failed\n\r"); */

	/* Запускаем SPI */
	_spi.NumSlaveBits = 2;
	_spi.SpiMode = XSP_STANDARD_MODE;

	XSpi_Start(&_spi);

	/* Деактивируем SPI прерывания */
	XSpi_IntrGlobalDisable(&_spi);
}

void ImageCaptureManager::initializeDragsters()
{

}

void ImageCaptureManager::initializeDragsterImpl()
{

}
