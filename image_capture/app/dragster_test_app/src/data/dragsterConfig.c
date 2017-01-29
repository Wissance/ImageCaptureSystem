#include "dragsterConfig.h"

unsigned char convertImpl(unsigned char byte);

unsigned char convertFromMsbToLsbFirst(unsigned char byte)
{
	return convertImpl(byte);
}

unsigned char convertFromLsbToMsbFirst(unsigned char byte)
{
	return convertImpl(byte);
}

unsigned char convertImpl(unsigned char byte)
{
	unsigned char result = 0;
    for(int i = 0; i < 8; i++)
       result += ((byte & (2^i)) << (7 - i));
    return result;
}



