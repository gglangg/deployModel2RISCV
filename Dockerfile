FROM nvidia/cuda:11.1.1-devel-ubuntu20.04

# 安装 git
RUN apt-get update && apt-get install -y git

WORKDIR /usr/workspace

# docker build -t your-image-name .
# docker run -v /your/local/directory:/usr/src/app/your-mounted-directory -it your-image-name
