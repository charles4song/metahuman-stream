# 本镜像完全复刻作者的环境。
# https://hub.docker.com/r/nvidia/cuda/tags?page=&page_size=&ordering=&name=
ARG BASE_IMAGE=nvcr.io/nvidia/cuda:11.6.1-cudnn8-devel-ubuntu20.04
FROM $BASE_IMAGE

LABEL repository="cs_v1" python="3.10" 

# 设置环境变量，防止交互提示
ENV DEBIAN_FRONTEND=noninteractive

# 安装必要的工具
RUN apt-get update -yq --fix-missing && apt-get install -yq --no-install-recommends \
    pkg-config \
    wget \
    cmake \
    curl \
    bzip2 \
    git \
    vim \
    ca-certificates \
    libgl1-mesa-glx \
    && apt-get clean

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
/bin/bash ~/miniconda.sh -b -p /root/miniconda && \
rm ~/miniconda.sh

# 设置环境变量
ENV PATH /root/miniconda/bin:$PATH

# 初始化 Conda
RUN conda init bash

# 创建并激活 Python 3.10 环境 & 验证
RUN conda create -n py310 python=3.10 -y && conda clean -a -y && python -V

# 设置容器启动时默认进入 Python 3.10 环境
RUN echo "conda activate py310" >> ~/.bashrc

# 以上为基础环境 cs_v1:base

# 使用conda安装cuda环境，这里不能使用conda安装torch，conda默认安装torch+cpu
RUN conda install cudatoolkit=11.3 -c pytorch -y

# 启动命令
CMD ["/bin/bash"]