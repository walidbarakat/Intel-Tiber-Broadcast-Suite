#!/bin/bash
pkill -f -9 ffmpeg
rm -f gradients*.* outfile*.*
./multiviewer_generator.sh
cp gradients.yuv gradients1.yuv 
cp gradients.yuv gradients2.yuv 
cp gradients.yuv gradients3.yuv 
./multiviewer_4sources_CPU.sh
./multiviewer_4sources_GPU.sh
./multiviewer_compressor.sh outfile_CPU
./multiviewer_compressor.sh outfile_GPU
sha256sum -b *.mp4

if [[ `sha256sum -b outfile_CPU.mp4 | cut -d ' ' -f 1` == `sha256sum -b outfile_GPU.mp4 | cut -d ' ' -f 1` ]]; then
 echo "TEST SUCCEEDED"
else
 echo "TEST FAILED"
fi
rm -f gradients*.* outfile*.*