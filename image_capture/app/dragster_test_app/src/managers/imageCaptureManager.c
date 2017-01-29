#include "imageCaptureManager.h"

#define SPI_DEVICE_ID XPAR_SPI_0_DEVICE_ID

void ImageCaptureManager::initialize()
{
	initializeSpi();
}

void ImageCaptureManager::startImageCapture()
{

}

void ImageCaptureManager::stopImageCapture()
{

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

	/* По умолчанию SPI является Slave, опция ниже конфигурирует его как Master
	/* status = XSpi_SetOptions(&Spi, XSP_MASTER_OPTION);
	if(Status != XST_SUCCESS) {
		xil_printf("\n XSpi_SetOptions Failed\n\r"); */

	/* Запускаем SPI */
	XSpi_Start(&_spi);

	/* Деактивируем SPI прерывания */
	XSpi_IntrGlobalDisable(&_spi);
}


