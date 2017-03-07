#ifndef SRC_DATA_VIDEOBUFFER_H_
#define SRC_DATA_VIDEOBUFFER_H_

#define NUMBER_OF_LINES 16

#include "globalDefs.h"


struct VideoBuffer
{
public:
    unsigned char _buffer [NUMBER_OF_LINES] [DRAGSTER_LINE_LENGTH];    // 16 lines of 1024 8bit values
    int _writeIndex;    // written index line from ISR
    int _sendIndex;     // index of send line via UART
};



#endif /* SRC_DATA_VIDEOBUFFER_H_ */
