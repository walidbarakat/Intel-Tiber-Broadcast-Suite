#!/bin/bash

docker run -it \
   --user root\
   --privileged \
   --device=/dev/vfio:/dev/vfio \
   --device=/dev/dri:/dev/dri \
   --cap-add ALL \
   -v "$(pwd)":/videos \
   -v /usr/lib/x86_64-linux-gnu/dri:/usr/local/lib/x86_64-linux-gnu/dri/ \
   -v /tmp/kahawai_lcore.lock:/tmp/kahawai_lcore.lock \
   -v /dev/null:/dev/null \
   -v /tmp/hugepages:/tmp/hugepages \
   -v /hugepages:/hugepages \
   --network=my_net_801f0 \
   --ip=192.168.2.2 \
   --expose=20000-20170 \
   --ipc=host -v /dev/shm:/dev/shm \
   --cpuset-cpus=10-30 \
   -e MTL_PARAM_LCORES=25-30 \
   -e MTL_PARAM_DATA_QUOTA=10356 \
      video_production_image -y \
      -qsv_device /dev/dri/renderD128 -hwaccel qsv \
      -p_port 0000:4b:01.2 -p_sip 192.168.2.2 -p_rx_ip 192.168.2.1 -udp_port 20000 -payload_type 112 -fps 25 -pix_fmt yuv422p10le -video_size 1920x1080 -f mtl_st20p -i "0" \
      -p_port 0000:4b:01.2 -p_sip 192.168.2.2 -p_rx_ip 192.168.2.1 -udp_port 20001 -payload_type 112 -fps 25 -pix_fmt yuv422p10le -video_size 1920x1080 -f mtl_st20p -i "1" \
      -filter_complex "[0:v][1:v]overlay_qsv=alpha=127,format=yuv422p10le" \
      -p_port 0000:4b:01.2 -p_sip 192.168.2.2 -p_tx_ip 192.168.2.3 -udp_port 20000 -payload_type 112 -f mtl_st20p -