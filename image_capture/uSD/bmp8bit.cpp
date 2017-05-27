#define _CRT_SECURE_NO_WARNINGS
#include <cstring>
#include <iostream>
#include <cstdio>
#include <conio.h>

using namespace std;

typedef struct tagBITMAPFILEHEADER
{
    unsigned short  bfType;                // тип файла (0x4D42)
    unsigned short	bfSize1;			   //размер файла
	unsigned short  bfSize2;
    unsigned short  bfReserved1;        
    unsigned short  bfReserved2;        
    unsigned short	bfOffBits1;			   // ѕоложение пиксельных данных относительно начала данной структуры
	unsigned short	bfOffBits2;
}BITMAPFILEHEADER;

typedef struct tagBITMAPINFOHEADER
{
	 long biSize;                // размер структуры BITMAPFILEHEADER
	 long biWidth;                // ширина изображени€ в пикселах
	 long biHeight;            // высота изображени€ в пикселах
	 short biPlanes;            // количество плоскостей
	 short biBitCount;            // количество бит на пиксель
	 long biCompression;        // тип сжати€
	 long biSizeImage;        // размер изображени€ в байтах
	 long biXPelsPerMeter;    // разрешение устройства вывода по X
	 long biYPelsPerMeter;    // разрешение устройства вывода по Y
	 long biClrUsed;            // размер таблицы цветов
	 long biClrImportant;    // необходимое количество цветов
}BITMAPINFOHEADER;

int main()
{
	BITMAPFILEHEADER BitmapFileHeader;
	BITMAPINFOHEADER BitmapInfoHeader;
	long  Width;
	long  Height;
	int Palette[256];	//палитра
	char data[4096];	//входные данные
	int i;
	Width = 1024;
	Height = 1 + (sizeof(data)-1) / Width;

	memset(&BitmapFileHeader, 0, sizeof(BitmapFileHeader));

	BitmapFileHeader.bfType = 0x4D42;    // тип файла (текстова€ строка "BM")
	BitmapFileHeader.bfSize1 = (sizeof(BITMAPFILEHEADER)+sizeof(BITMAPINFOHEADER)+1024+sizeof(data)) & 0x0000ffff;
	BitmapFileHeader.bfSize2 = (sizeof(BITMAPFILEHEADER)+sizeof(BITMAPINFOHEADER)+1024 + sizeof(data)) >> 16;
	BitmapFileHeader.bfOffBits1 = sizeof(BITMAPFILEHEADER)+sizeof(BITMAPINFOHEADER)+1024;

	memset(&BitmapInfoHeader, 0, sizeof(BITMAPINFOHEADER));

	BitmapInfoHeader.biSize = sizeof(BITMAPINFOHEADER);
	BitmapInfoHeader.biHeight = Height;
	
	if (sizeof(data) < Width)
		BitmapInfoHeader.biWidth = sizeof(data);
	else
		BitmapInfoHeader.biWidth = Width;

	BitmapInfoHeader.biPlanes = 1;
	BitmapInfoHeader.biBitCount = 8;
	
	memset(&Palette, 0, sizeof(Palette));
	for (i = 0; i < 256; i++)
		Palette[i] = i*0x00010101;

	memset(&data, 0, sizeof(data));
	
	for (i = 0; i < Width; i++)    //заполнение массива произвольными данными
	{
		data[i] = i;
		data[i+Width] = i*i;
	}
	
	const char * name = "test.bmp";
	FILE* stream;
	stream = fopen(name, "wb");
	if (stream == NULL)
	{
		cout << "ќшибка открыти€ файла дл€ записи" << endl;
		exit(1);
	}

	fwrite(&BitmapFileHeader, sizeof(BITMAPFILEHEADER), 1, stream);
	fwrite(&BitmapInfoHeader, sizeof(BITMAPINFOHEADER), 1, stream);
	fwrite(&Palette, sizeof(Palette), 1, stream);
	fwrite(&data, sizeof(data), 1, stream);
	fclose(stream);
	//printf("%d", sizeof(data));
	//_getch();
	return 0;
}