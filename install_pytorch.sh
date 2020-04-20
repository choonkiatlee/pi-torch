#!/bin/bash
export USE_CUDA=0
export USE_CUDNN=0
export USE_MKLDNN=0

export USE_METAL=0
export USE_NCCL=OFF

export USE_NNPACK=1
export USE_QNNPACK=1
export USE_DISTRIBUTED=0
export BUILD_TEST=0
export MAX_JOBS=2 # For Github host
export CFLAGS="-mfpu=neon -D__NEON__"

apt-get update && apt-get install -y python3-cffi python3-numpy libatlas-base-dev

echo "[global]
extra-index-url=https://www.piwheels.org/simple" >> /etc/pip.conf

pip3 install cython wheel pyyaml pillow

git clone --recursive https://github.com/pytorch/pytorch

cd pytorch

git checkout v1.4.0

git submodule sync --recursive
git submodule update --init --recursive

# Fix from: https://github.com/pytorch/pytorch/issues/22564
git submodule update --remote third_party/protobuf

timeout -s SIGINT 18000 python3 setup.py bdist_wheel # 18,000 seconds = 5 hours = 300 minutes

if [ $? -eq 124 ]; then
  echo "Timeout Reached"
  echo $?
  exit 0
fi

# Should have an else if to return the timeout status code otherwise?