#!/bin/bash
pkill -f -9 ffmpeg
rm -f gradients.* received.*
./IMTL_generator.sh
./IMTL_docker_camera.sh & timeout 40 ./docker_receiver.sh
./IMTL_compressor.sh
./IMTL_compressor_received.sh
sha256sum -b *.mp4
if [[ `sha256sum -b gradients.mp4 | cut -d ' ' -f 1` == `sha256sum -b received.mp4 | cut -d ' ' -f 1` ]]; then
 rm -f gradients.* received.*
 echo "TEST SUCCEEDED"
else
 rm -f gradients.* received.*
 echo "TEST FAILED"
fi

