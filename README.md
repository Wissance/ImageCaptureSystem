# VideoControlIP
Xilinx IP Core for Zynq 7k SoC for 2 channel image capture from CMOSIS/AWAIBA/Dragster linescanners.
Data stored in separate RAM Area for each channel.

In very simple approach we work with C++ Standalone application (written in C style with structs, no classes).
This app could do following:

1) Configure each scanner via SPI and AXI Quad SPI IP core
2) Managing image capture proccess (Start/Stop).
3) Store data in RAM

For alpha version we are planning to save captured data on uSD card and configure AXI VDMA Cores.

Main Contributors are:

Ushakov Michael (EvilLord666, um.nix.user@gmail.com)
Alex Petrov (veryniceguy, )
