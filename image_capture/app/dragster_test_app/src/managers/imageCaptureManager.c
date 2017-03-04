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

#define INTERRUPT_CONTROLLER_DEVICE_ID XPAR_SCUGIC_SINGLE_DEVICE_ID

#define VDMA_1_WRITE_INTERRUPT_ID XPAR_FABRIC_AXI_VDMA_0_S2MM_INTROUT_INTR
#define VDMA_2_WRITE_INTERRUPT_ID XPAR_FABRIC_AXI_VDMA_1_S2MM_INTROUT_INTR

#define DRAGSTER_LINE_LENGTH 1024

u8 readBuffer[2];
u8 writeBuffer[2];

/* Callbacks */
static void Vdma1WriteCallback(void* CallbackRef, u32 Mask)
{
	// Do something with a frame produced by first VDMA
	u8* frameBuffer = (u8*)VDMA_1_MEMORY_BASE_ADDRESS;
}

static void Vdma2WriteCallback(void* CallbackRef, u32 Mask)
{
	// Do something with a frame produced by second VDMA
	u8* frameBuffer = (u8*)VDMA_2_MEMORY_BASE_ADDRESS;
}

static void Vdma1WriteErrorCallback(void* CallbackRef, u32 Mask){}
static void Vdma2WriteErrorCallback(void* CallbackRef, u32 Mask){}

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
	setupVdmaDevice(&_vdma1, VDMA_1_DEVICE_ID, VDMA_1_MEMORY_BASE_ADDRESS);
	setupVdmaDevice(&_vdma2, VDMA_2_DEVICE_ID, VDMA_2_MEMORY_BASE_ADDRESS);
	configureVdmaInterrupts();
}

void ImageCaptureManager::setupVdmaDevice(XAxiVdma* vdma, u16 deviceId, u32 memoryBaseAddress)
{
	/* Acquire a device configuration. */
	XAxiVdma_Config* config = XAxiVdma_LookupConfig(deviceId);
	if(!config)
		xil_printf("\n XAxiVdma_LookupConfig Failed\n\r");

	/* Initialize a device. */
    int status = XAxiVdma_CfgInitialize(vdma, config, config->BaseAddress);
    if (status != XST_SUCCESS)
    	xil_printf("\n XAxiVdma_CfgInitialize Failed\r\n");

    /* Create a channel configuration. */
    XAxiVdma_DmaSetup setup;

    /* Width(in bytes). Set this parameter to 1024 as DR-2k-7LCC
     * has 1x2048 pixels, we use half, and the size of each pixel is 1 byte. */
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
    *setup.FrameStoreStartAddr = memoryBaseAddress;

    /* Function which actually configures buffer addresses per channel.
     * I assume it can be done earlier. I mean I believe XAxiVdma_DmaConfig
     * can configure buffer addresses too, but unfortunately I cannot test it so far.*/
    status = XAxiVdma_DmaSetBufferAddr(vdma, XAXIVDMA_WRITE, setup.FrameStoreStartAddr);
    if (status != XST_SUCCESS)
    	xil_printf("\n XAxiVdma_DmaSetBufferAddr Failed\r\n");
}

void ImageCaptureManager::configureVdmaInterrupts()
{
	XScuGic_Config* config = XScuGic_LookupConfig(INTERRUPT_CONTROLLER_DEVICE_ID);
	if(!config)
		xil_printf("\n XScuGic_LookupConfig failed \r\n");

	int status = XScuGic_CfgInitialize(&_interruptController, config, config->CpuBaseAddress);
	if (status != XST_SUCCESS)
		xil_printf("\n XScuGic_CfgInitialize \r\n");

	/* Set priority and trigger type.
	 * Priority range: 0...248.
	 * Trigger types:
	 *     Software-generated Interrupts(SFI): 2(always);
	 *     Private Peripheral Interrupt(PPI): 1(Active HIGH), 3(Rising edge);
	 *     Shared Peripheral Interrupts(SPI): 1(Active HIGH), 3(Rising edge);*/

	XScuGic_SetPriorityTriggerType(&_interruptController, VDMA_1_WRITE_INTERRUPT_ID, 0xA0, 0x3);
	XScuGic_SetPriorityTriggerType(&_interruptController, VDMA_2_WRITE_INTERRUPT_ID, 0xA0, 0x3);

	status = XScuGic_Connect(
			&_interruptController,
			VDMA_1_WRITE_INTERRUPT_ID,
			(Xil_InterruptHandler)XAxiVdma_WriteIntrHandler,
			&_vdma1);

	if (status != XST_SUCCESS)
		xil_printf("\n XScuGic_Connect failed (VDMA 1) \r\n");

	status = XScuGic_Connect(
			&_interruptController,
			VDMA_2_WRITE_INTERRUPT_ID,
			(Xil_InterruptHandler)XAxiVdma_WriteIntrHandler,
			&_vdma2);

	if (status != XST_SUCCESS)
		xil_printf("\n XScuGic_Connect failed (VDMA 2) \r\n");

	XScuGic_Enable(&_interruptController, VDMA_1_WRITE_INTERRUPT_ID);
	XScuGic_Enable(&_interruptController, VDMA_2_WRITE_INTERRUPT_ID);

	Xil_ExceptionInit();
	Xil_ExceptionRegisterHandler(
			XIL_EXCEPTION_ID_IRQ_INT,
			(Xil_ExceptionHandler)XScuGic_InterruptHandler,
			&_interruptController);

	Xil_ExceptionEnable();

	XAxiVdma_SetCallBack(&_vdma1, XAXIVDMA_HANDLER_GENERAL, (void*)Vdma1WriteCallback, (void*)&_vdma1, XAXIVDMA_WRITE);
	XAxiVdma_SetCallBack(&_vdma2, XAXIVDMA_HANDLER_GENERAL, (void*)Vdma2WriteCallback, (void*)&_vdma2, XAXIVDMA_WRITE);

	XAxiVdma_SetCallBack(&_vdma1, XAXIVDMA_HANDLER_ERROR, (void*)Vdma1WriteErrorCallback, (void*)&_vdma1, XAXIVDMA_WRITE);
	XAxiVdma_SetCallBack(&_vdma2, XAXIVDMA_HANDLER_ERROR, (void*)Vdma2WriteErrorCallback, (void*)&_vdma2, XAXIVDMA_WRITE);

	XAxiVdma_IntrEnable(&_vdma1, XAXIVDMA_IXR_ALL_MASK, XAXIVDMA_WRITE);
	XAxiVdma_IntrEnable(&_vdma2, XAXIVDMA_IXR_ALL_MASK, XAXIVDMA_WRITE);
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


