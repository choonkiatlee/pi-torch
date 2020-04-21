# pi-torch

# TLDR:

We used the raspbian image available [here](https://hub.docker.com/r/choonkiatlee/raspbian) to compile a version of Pytorch for the Raspberry Pi. This is an armv7l image that has been compiled with NEON optimisations and NNPACK / QNNPACK, allowing it to run decently fast on the resource constrained RPi.

## Build options for pytorch:

```bash
export USE_CUDA=0
export USE_CUDNN=0
export USE_MKLDNN=0

export USE_METAL=0
export USE_NCCL=OFF

export USE_NNPACK=1
export USE_QNNPACK=1
export USE_DISTRIBUTED=0
export BUILD_TEST=0
```

## Build Process:

```bash
sudo apt-get update && sudo apt-get install qemu-user-static qemu binfmt-support

# Clone the repo to get the above commands as a single script
git clone https://github.com/choonkiatlee/pi-torch.git

# Override the entrypoint
docker create --name pytorch_builder choonkiatlee/raspbian:build qemu-arm-static /bin/bash install_pytorch.sh

# Copy the build script onto the docker container and run the container
docker cp pi-torch/install_pytorch.sh pytorch_builder:/install_pytorch.sh
docker start pytorch_builder

# Attach to the container to see the output
docker attach pytorch_builder

docker cp pytorch_builder:/pytorch/dist/. .
```

## Detailed Explanation

See the blog post [here]() for a more in depth explanation for the entire build process

## Issues
Please file an issue if any of these wheels do not work for you and I will try my best to get them fixed!