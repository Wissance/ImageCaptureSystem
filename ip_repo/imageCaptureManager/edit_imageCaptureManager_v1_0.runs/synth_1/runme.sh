#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
# 

echo "This script was generated under a different operating system."
echo "Please update the PATH and LD_LIBRARY_PATH variables below, before executing this script"
exit

if [ -z "$PATH" ]; then
  PATH=F:/Xilinx/SDK/2016.2/bin;F:/Xilinx/Vivado/2016.2/ids_lite/ISE/bin/nt64;F:/Xilinx/Vivado/2016.2/ids_lite/ISE/lib/nt64:F:/Xilinx/Vivado/2016.2/bin
else
  PATH=F:/Xilinx/SDK/2016.2/bin;F:/Xilinx/Vivado/2016.2/ids_lite/ISE/bin/nt64;F:/Xilinx/Vivado/2016.2/ids_lite/ISE/lib/nt64:F:/Xilinx/Vivado/2016.2/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=
else
  LD_LIBRARY_PATH=:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='i:/projects/imagecapturemanager/ip/edit_imageCaptureManager_v1_0.runs/synth_1'
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

EAStep vivado -log imageCaptureManager_v1_0.vds -m64 -mode batch -messageDb vivado.pb -notrace -source imageCaptureManager_v1_0.tcl
