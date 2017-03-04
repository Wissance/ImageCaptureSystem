#include "imageCaptureManager.h"
#include "axiIoHelper.h"

#define SPI_DEVICE_ID XPAR_SPI_0_DEVICE_ID
#define IMAGE_CAPTURE_MANAGER_BASE_ADDRESS 0x43C00000

#define START_COMMAND 1
#define STOP_COMMAND 2

#define LINESCANNER0_SLAVE_SELECT 1
#define LINESCANNER1_SLAVE_SELECT 2

#define VDMA_1_DEVICE_ID XPAR_AXI_VDMA_0_DEVICE_ID
#define VDMA_2_DEVICE_ID XPAR_AXI_VDMA_1_DEVICE_ID

#define VDMA_1_MEMORY_BASE_ADDRESS 0x00000000
#define VDMA_2_MEMORY_BASE_ADDRESS 0x01000000

#define DRAGSTER_LINE_LENGTH 2048

u8 readBuffer[2];
u8 writeBuffer[2];

/* Callbacks for first VDMA*/
static void Vdma1WriteCallBack(void* CallbackRef, u32 Mask)
{
	// Do something with frame produced by first VDMA
	u8* frameBuffer = (u8*)VDMA_1_MEMORY_BASE_ADDRESS;
}

static void Vdma1WriteErrorCallBack(void* CallbackRef, u32 Mask){}

/* Callbacks for second VDMA */
static void Vdma2WriteCallBack(void* CallbackRef, u32 Mask)
{
	// Do something with frame produced by second VDMA
	u8* frameBuffer = (u8*)VDMA_2_MEMORY_BASE_ADDRESS;
}

static void Vdma2WriteErrorCallBack(void* CallbackRef, u32 Mask){}

void ImageCaptureManager::initialize()
{
	initializeVdmaDevices();
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

void ImageCaptureManager::initializeVdmaDevices()
{
	initializeVdmaDevice(&_vdma1, VDMA_1_DEVICE_ID, VDMA_1_MEMORY_BASE_ADDRESS);
	initializeVdmaDevice(&_vdma2, VDMA_2_DEVICE_ID, VDMA_2_MEMORY_BASE_ADDRESS);

	configureAllVdmaInterrupts();
}

void ImageCaptureManager::configureAllVdmaInterrupts()
{
	/* Initialize the interrupt controller */
	int status = XIntc_Initialize(&_interruptController, XPAR_INTC_0_DEVICE_ID);
	if (status != XST_SUCCESS)
		xil_printf("\n XIntc_Initialize Failed\r\n");

	connectInterruptHandlerToVdma(&_vdma1, XPAR_INTC_0_AXIVDMA_0_S2MM_INTROUT_VEC_ID);
	connectInterruptHandlerToVdma(&_vdma2, XPAR_INTC_0_AXIVDMA_1_S2MM_INTROUT_VEC_ID);

	status = XIntc_Start(&_interruptController, XIN_REAL_MODE);
	if (status != XST_SUCCESS)
		xil_printf("\n XIntc_Start Failed\r\n");

	XIntc_Enable(&_interruptController, writeChannelInterruptId);
	Xil_ExceptionInit();
	Xil_ExceptionRegisterHandler(
			XIL_EXCEPTION_ID_INT(Xil_ExceptionHandler)XIntc_InterruptHandler,
			(void*)interruptController);
	Xil_ExceptionEnable();

	setVdmaCallbacks(_vdma1, Vdma1WriteCallBack);
	setVdmaCallbacks(_vdma2, Vdma1WriteErrorCallBack);
}

/* Инициализация SPI в блокирующем режиме (polling mode)*/
void ImageCaptureManager::initializeSpi()
{
	int status;

	/* Запрашиваем конфигурацию устройства */
	XSpi_Config* spiConfig = XSpi_LookupConfig(SPI_DEVICE_ID);
	if(!spiConfig)
		xil_printf("\n XSpi_LookupConfig Failed\n\r");
	_spi.NumSlaveBits = 2;
	_spi.SpiMode = XSP_STANDARD_MODE;

	/* Инициализируем экземпляр SPI */
	status = XSpi_CfgInitialize(&_spi, spiConfig, spiConfig->BaseAddress);
	if(status != XST_SUCCESS)
		xil_printf("\n XSpi_CfgInitialize Failed\n\r");

	/* По умолчанию SPI является Slave, опция ниже конфигурирует его как Master */
	 status = XSpi_SetOptions(&_spi, XSP_MASTER_OPTION);
	if(status != XST_SUCCESS)
		xil_printf("\n XSpi_SetOptions Failed\n\r");

	/* Запускаем SPI */

	XSpi_Start(&_spi);

	/* Деактивируем SPI прерывания */
	XSpi_IntrGlobalDisable(&_spi);
}

void ImageCaptureManager::initializeDragsters()
{
	initializeDragsterImpl(LINESCANNER0_SLAVE_SELECT);
	initializeDragsterImpl(LINESCANNER1_SLAVE_SELECT);
	// deselecting any slave
    XSpi_SetSlaveSelect(&_spi, 0);
}

void ImageCaptureManager::initializeDragsterImpl(int dragsterSlaveSelectMask)
{
    int status = XSpi_SetSlaveSelect(&_spi, dragsterSlaveSelectMask);
    if(status == XST_SUCCESS)
    {
    	// todo: umv: read from fields
        // Запись конфигурации регистров Dragster
        // CONTROL Register 2
    	sendDragsterRegisterValue(CONTROL_REGISTER_2_ADDRESS, 0x32);
        // CONTROL Register 3
    	sendDragsterRegisterValue(CONTROL_REGISTER_3_ADDRESS, 0x13);
        // End of Data Register
    	sendDragsterRegisterValue(END_OF_RANGE_REGISTER_ADDRESS, 0x08);  // 8 bit pixels value
        // CONTROL Register 1
    	sendDragsterRegisterValue(CONTROL_REGISTER_1_ADDRESS, //0xAD);
    			                                             0xA9);
        // 0 byte (must generate at least 3 clk before SS is disabled)
        endDragsterTransaction();
	}
}

void ImageCaptureManager::sendDragsterRegisterValue(unsigned char address, unsigned char value)
{
	unsigned char convertedAddress = convertFromMsbToLsbFirst(address);
    writeBuffer[1] = convertedAddress;
    unsigned char convertedValue = convertFromMsbToLsbFirst(value);
    writeBuffer[0] = convertedValue;
    XSpi_Transfer(&_spi, writeBuffer, NULL, 2);
}

void ImageCaptureManager::endDragsterTransaction()
{
	writeBuffer[0] = 0;
	XSpi_Transfer(&_spi, writeBuffer, NULL, 1);
}

void ImageCaptureManager::initializeVdmaDevice(XAxiVdma* vdma, u16 deviceId, u32 memoryBaseAddress)
{
	/* Acquire device configuration. */
	XAxiVdma_Config* vdmaConfig = XAxiVdma_LookupConfig(deviceId);
	if(!vdmaConfig)
		xil_printf("\n XAxiVdma_LookupConfig Failed\n\r");

	/* Initialize device. */
    int status = XAxiVdma_CfgInitialize(vdma, vdmaConfig, vdmaConfig->BaseAddress);
    if (status != XST_SUCCESS)
    	xil_printf("\n XAxiVdma_CfgInitialize Failed\r\n");

    /* Create channel configuration. */
    XAxiVdma_DmaSetup setup;

    /* Width(in bytes). Set this parameter to 2048 as DR-2k-7LCC
     * has 1x2048 pixels and size of each pixel is 1 byte. */
    setup.HoriSizeInput = DRAGSTER_LINE_LENGTH;

    /* Height(in lines). In our case it is always 1. */
    setup.VertSizeInput = 1;

    /* Stride. Specifies the number of bytes between
     * the first pixels of each horizontal line. */
    setup.Stride = DRAGSTER_LINE_LENGTH;

    /* Circular buffer mode. We most definitely want it to be enabled. */
    setup.EnableCircularBuf = 1;

    /* Frame delay. Set it to 0 for now. */
    setup.FrameDelay = 0;

    // Gen-Lock parameters. Set them to 0 for now.
    setup.EnableSync = 0;
    setup.PointNum = 0;

    // Frame counter. Set it to 0 as we dont need it so far.
    setup.EnableFrameCounter = 0;

    // Fixed frame store address. Used for parking.
    setup.FixedFrameStoreAddr = 0;

    /* Configure VDMA write channel. */
    status = XAxiVdma_DmaConfig(vdma, XAXIVDMA_WRITE, &setup);
    if (status != XST_SUCCESS)
    	xil_printf("\n XAxiVdma_DmaConfig Failed\r\n");

    /* Set start address for 1 buffer. */
    setup.FrameStoreStartAddr[0] = memoryBaseAddress;

    /* Function which actually configures buffer addresses per channel.
     * I assume it can be done earlier. I mean I believe XAxiVdma_DmaConfig
     * can configure buffer addresses too, but unfortunately I cannot test it so far.*/
    status = XAxiVdma_DmaSetBufferAddr(vdma, XAXIVDMA_WRITE, setup.FrameStoreStartAddr);
    if (status != XST_SUCCESS)
    	xil_printf("\n XAxiVdma_DmaSetBufferAddr Failed\r\n");
}

void ImageCaptureManager::connectInterruptHandlerToVdma(XAxiVdma* vdma, u16 writeChannelInterruptId)
{
	int status = XIntc_Connect(
			&_interruptController,
			writeChannelInterruptId,
			(XInterruptHandler)XAxiVdma_WriteIntrHandler,
			vdma);

	if (status != XST_SUCCESS)
		xil_printf("\n XIntc_Connect Failed\r\n");
}

void ImageCaptureManager::setVdmaCallbacks(
		XAxiVdma* vdma,
		XAxiVdma_CallBack writeCallback,
		XAxiVdma_CallBack writeErrorCallback)
{
	/* Set VDMA callbacks */
	XAxiVdma_SetCallBack(vdma, XAXIVDMA_HANDLER_GENERAL, (void*)writeCallback, (void*)vdma, XAXIVDMA_WRITE);
	XAxiVdma_SetCallBack(vdma, XAXIVDMA_HANDLER_ERROR, (void*)writeErrorCallback, (void*)vdma, XAXIVDMA_WRITE);
}



