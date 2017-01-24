#include <platform.h>
#include <xaxivdma.h>
#include <xparameters.h>

/* Указатель на экземпляр vdma */
XAxiVdma* vdma;

void configureVdmaWrite()
{
  /* Структура хранящая конфигурацию канала */
  XAxiVdma_DmaSetup vdmaWriteConfig;
  
  /* Вертикальное разрешение */
  vdmaWriteConfig.VertSizeInput = 1;
  
  /* Горизонтальное разрешение */
  vdmaWriteConfig.HoriSizeInput = 1;
  
  /* Шаг */
  vdmaWriteConfig.Stride = vdmaWriteConfig.HoriSizeInput;
  
  /* Тест кадровой задержки */
  vdmaWriteConfig.FrameDelay = 0;
  
  /* Круговой буфер */
  vdmaWriteConfig.EnableCircularBuf = 1;
  
  /* Gen-Lock синхронизация */
  vdmaWriteConfig.EnableSync = 0;
  
  /* Gen-Lock режим, идентификатор другого VDMA (Мастера) с которым синхронизируется данный VDMA */
  vdmaWriteConfig.PointNum = 0;
  
  /* Счетчик кадров */
  vdmaWriteConfig.EnableFrameCounter = 0;
  
  /* Роль данного параметра мне пока до конца не ясна */
  vdmaWriteConfig.FixedFrameStoreAddr = 0;
  
  /* Еще один мистический параметр имеющий отношение к Gen-Lock*/
  vdmaWriteConfig.GenLockRepeat = 0;
  
  /* Конфигурируем канал записи */
  XAxiVdma_DmaConfig(vdma, XAXIVDMA_WRITE, &vdmaWriteConfig);
}

int main()
{  
  /* Запрашиваем конфигурацию данного экземпляра vdma */
  XAxiVdma_Config *vdmaConfig = XAxiVdma_LookupConfig(0);

  /* Инициализируем драйвер используя запрошенную конфигурацию */
  XAxiVdma_CfgInitialize(vdma, vdmaConfig, vdmaConfig->BaseAddress);
    
  /* Конфигурируем канал записи */
  configureVdmaWrite();
    
  /* Инициируем трансфер по каналу записи */
  XAxiVdma_DmaStart(vdma, XAXIVDMA_WRITE);
  
  return 0;
}