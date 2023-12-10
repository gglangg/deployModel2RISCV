FROM nvidia/cuda:12.3.1-devel-ubuntu22.04

# 12.3.1-devel-ubuntu22.04
# 安装 git
RUN apt update && apt upgrade -y && export DEBIAN_FRONTEND=noninteractive && apt-get install -y git && apt install wget build-essential ninja-build gcc g++ ca-certificates cmake clang python3-pip llvm -y

WORKDIR /usr/workspace

# CMD git clone https://github.com/gglangg/deployModel2RISCV 
#     wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null &&\
#     echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ jammy main' | tee /etc/apt/sources.list.d/kitware.list >/dev/null
#     apt-get update &&\
#     apt-get install kitware-archive-keyring &&\
#     echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ jammy-rc main' | tee -a /etc/apt/sources.list.d/kitware.list >/dev/null
#     apt-get update -y &&\
#     apt-get install cmake -y

# docker build -t your-image-name .
# docker run -v /home/cluster/workspace/PLLAB/testd:/usr/workspace -it mt
